
# SPI interface

set_property -dict {PACKAGE_PIN  G15 IOSTANDARD LVCMOS33 IOB TRUE}                  [get_ports ad7768_0_spi_sclk]    ; ## 
set_property -dict {PACKAGE_PIN  J18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP}  [get_ports ad7768_0_spi_mosi]    ; ## 
set_property -dict {PACKAGE_PIN  K18 IOSTANDARD LVCMOS33}                           [get_ports ad7768_0_spi_miso]    ; ## 
set_property -dict {PACKAGE_PIN  U15 IOSTANDARD LVCMOS33}                           [get_ports ad7768_0_spi_cs]      ; ## 

# reset and GPIO signals

set_property -dict {PACKAGE_PIN  T15 IOSTANDARD LVCMOS33}                           [get_ports ad7768_0_reset]       ; ## 
set_property -dict {PACKAGE_PIN  M18 IOSTANDARD LVCMOS33}                           [get_ports ad7768_0_fda_dis]     ; ## 
set_property -dict {PACKAGE_PIN  N18 IOSTANDARD LVCMOS33}                           [get_ports ad7768_0_fda_mode]    ; ## 
set_property -dict {PACKAGE_PIN  V18 IOSTANDARD LVCMOS33}                           [get_ports ad7768_0_dac_buf_en]  ; ## 

# syncronization and timing

set_property -dict {PACKAGE_PIN  T14 IOSTANDARD LVCMOS33 IOB TRUE}                  [get_ports ad7768_0_drdy]        ; ## 
set_property -dict {PACKAGE_PIN  R17 IOSTANDARD LVCMOS33}                           [get_ports ad7768_0_sync_in]     ; ## 