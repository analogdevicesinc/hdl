 set_property  -dict {PACKAGE_PIN N18   IOSTANDARD LVCMOS33}  [get_ports clk_in     ]; ##   P12.10 IO8 
 set_property  -dict {PACKAGE_PIN M18   IOSTANDARD LVCMOS33}  [get_ports ready_in   ]; ##   P12.9  IO9
 
 set_property  -dict {PACKAGE_PIN R14   IOSTANDARD LVCMOS33}  [get_ports data_in[0] ]; ##   P14.1  IO7
 set_property  -dict {PACKAGE_PIN R17   IOSTANDARD LVCMOS33}  [get_ports data_in[1] ]; ##   P14.2  IO6
 set_property  -dict {PACKAGE_PIN V18   IOSTANDARD LVCMOS33}  [get_ports data_in[2] ]; ##   P14.3  IO5
 set_property  -dict {PACKAGE_PIN V17   IOSTANDARD LVCMOS33}  [get_ports data_in[3] ]; ##   P14.4  IO4
 
 set_property  -dict {PACKAGE_PIN T15   IOSTANDARD LVCMOS33}  [get_ports shutdown_n ]; ##   P14.5  IO3
 set_property  -dict {PACKAGE_PIN T14   IOSTANDARD LVCMOS33}  [get_ports reset_n    ]; ##   P14.6  IO2
 
 set_property  -dict {PACKAGE_PIN U15   IOSTANDARD LVCMOS33}  [get_ports spi_csn    ]; ##   P12.8  IO10
 set_property  -dict {PACKAGE_PIN K18   IOSTANDARD LVCMOS33}  [get_ports spi_mosi   ]; ##   P12.7  IO11
 set_property  -dict {PACKAGE_PIN J18   IOSTANDARD LVCMOS33}  [get_ports spi_miso   ]; ##   P12.6  IO12
 set_property  -dict {PACKAGE_PIN G15   IOSTANDARD LVCMOS33}  [get_ports spi_clk    ]; ##   P12.5  IO13
 set_property  -dict {PACKAGE_PIN P16   IOSTANDARD LVCMOS33}  [get_ports dac_i2c_scl]; ##   P12.1  CK_SCL
 set_property  -dict {PACKAGE_PIN P15   IOSTANDARD LVCMOS33}  [get_ports dac_i2c_sda]; ##   P12.2  CK_SDA

set input_clock_period  30.51;    # Period of input clock fMAX_DCLK=32.768MHz
set hold_time           8.5;               
set setup_time          8.5;       

create_clock -name adc_clk -period $input_clock_period   [get_ports clk_in] 

set_input_delay -clock adc_clk -max   [expr $input_clock_period - $setup_time]  [get_ports data_in[*]] -clock_fall -add_delay;
set_input_delay -clock adc_clk -min   $hold_time  [get_ports data_in[*]] -clock_fall -add_delay;
