
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "4.000 ns"   -name rx_clk_250mhz       [get_ports {rx_clk_in}]
create_clock -period "4.000 ns"   -name tx_clk_250mhz       [get_ports {tx_clk_out_*}]
create_clock -period "4.000 ns"   -name rx_clk_virtual_250mhz
create_clock -period "4.000 ns"   -name tx_clk_virtual_250mhz
create_clock -period "100khz"     -name i2c_clk_virtual_100khz

derive_pll_clocks
derive_clock_uncertainty

set_input_delay 0.000 -clock {rx_clk_virtual_250mhz} [get_ports {rx_clk_in}]

# output async false paths
set_false_path -from * -to [get_ports {gpio*}]
set_false_path -from * -to [get_ports {enable}]
set_false_path -from * -to [get_ports {txnrx}]
#unused output
set_false_path -from * -to [get_ports {spi_csn}]

# input async false paths
set_false_path -from [get_ports {sys_resetn}] -to *
set_false_path -from [get_ports {gpio*}] -to *

set_output_delay 0.000 -clock {tx_clk_virtual_250mhz} [get_ports tx_clk_out_*]

#taken from blade rf :)
create_generated_clock -name spi_clk_reg -source [get_ports {sys_clk}] -divide_by 10 [get_registers {i_system_bd|sys_spi|sys_spi|SCLK_reg}]
create_generated_clock -name spi_clk_10mhz -source [get_registers -no_duplicates {i_system_bd|sys_spi|sys_spi|SCLK_reg}] [get_ports {spi_clk}]

set_max_skew -from [get_clocks {spi_clk_10mhz}] -to [get_ports {spi_clk}] 0.2

set_output_delay -max 1.000 -clock {spi_clk_10mhz} [get_ports {spi_mosi}]
set_output_delay -min 0.000 -clock {spi_clk_10mhz} [get_ports {spi_mosi}]
set_output_delay -max 1.000 -clock {spi_clk_10mhz} [get_ports {spi_csn}]
set_output_delay -min 0.000 -clock {spi_clk_10mhz} [get_ports {spi_csn}]

set_input_delay -max 2.000 -clock {spi_clk_10mhz} [get_ports {spi_miso}]
set_input_delay -min 3.000 -clock {spi_clk_10mhz} [get_ports {spi_miso}]

#i2c should be slow enough to ignore, 100khz vs 100mhz system clock.
set_false_path -to [get_ports "fpga_i2c* fmc_i2c*"]

#AN433 + DDR_timing_cookbook_v2
set_input_delay -max 0.000 -clock {rx_clk_virtual_250mhz} [get_ports rx_data_in*]
set_input_delay -min 2.000 -clock {rx_clk_virtual_250mhz} [get_ports rx_data_in*]

set_input_delay -max -add_delay 0.000 -clock {rx_clk_virtual_250mhz} -clock_fall [get_ports rx_data_in*]
set_input_delay -min -add_delay 2.000 -clock {rx_clk_virtual_250mhz} -clock_fall [get_ports rx_data_in*]

set_input_delay -max 0.000 -clock {rx_clk_virtual_250mhz} [get_ports rx_frame_in*]
set_input_delay -min 2.000 -clock {rx_clk_virtual_250mhz} [get_ports rx_frame_in*]

set_input_delay -max -add_delay 0.000 -clock {rx_clk_virtual_250mhz} -clock_fall [get_ports rx_frame_in*]
set_input_delay -min -add_delay 2.000 -clock {rx_clk_virtual_250mhz} -clock_fall [get_ports rx_frame_in*]

set_output_delay -max 0.000 -clock {tx_clk_virtual_250mhz} [get_ports tx_data_out*]
set_output_delay -min 2.000 -clock {tx_clk_virtual_250mhz} [get_ports tx_data_out*]

set_output_delay -max -add_delay 0.000 -clock {tx_clk_virtual_250mhz} -clock_fall  [get_ports tx_data_out*]
set_output_delay -min -add_delay 2.000 -clock {tx_clk_virtual_250mhz} -clock_fall  [get_ports tx_data_out*]

set_output_delay -max 0.000 -clock {tx_clk_virtual_250mhz}  [get_ports tx_frame_out*]
set_output_delay -min 2.000 -clock {tx_clk_virtual_250mhz}  [get_ports tx_frame_out*]

set_output_delay -max -add_delay 0.000 -clock {tx_clk_virtual_250mhz} -clock_fall  [get_ports tx_frame_out*]
set_output_delay -min -add_delay 2.000 -clock {tx_clk_virtual_250mhz} -clock_fall  [get_ports tx_frame_out*]

set_false_path -setup -fall_from [get_clocks rx_clk_virtual_250mhz] -rise_to [get_clocks rx_clk_250mhz]
set_false_path -setup -rise_from [get_clocks rx_clk_virtual_250mhz] -fall_to [get_clocks rx_clk_250mhz]
set_false_path -hold  -fall_from [get_clocks rx_clk_virtual_250mhz] -fall_to [get_clocks rx_clk_250mhz]
set_false_path -hold  -rise_from [get_clocks rx_clk_virtual_250mhz] -rise_to [get_clocks rx_clk_250mhz]

set_false_path -setup -rise_from [get_clocks {rx_clk_virtual_250mhz}] -rise_to [get_clocks {rx_clk_250mhz}]
set_false_path -setup -fall_from [get_clocks {rx_clk_virtual_250mhz}] -fall_to [get_clocks {rx_clk_250mhz}]
set_false_path -hold  -rise_from [get_clocks {rx_clk_virtual_250mhz}] -fall_to [get_clocks {rx_clk_250mhz}]
set_false_path -hold  -fall_from [get_clocks {rx_clk_virtual_250mhz}] -rise_to [get_clocks {rx_clk_250mhz}]
set_false_path -setup -rise_from [get_clocks {tx_clk_virtual_250mhz}] -fall_to [get_clocks {tx_clk_250mhz}]
set_false_path -setup -fall_from [get_clocks {tx_clk_virtual_250mhz}] -rise_to [get_clocks {tx_clk_250mhz}]
set_false_path -hold  -fall_from [get_clocks {tx_clk_virtual_250mhz}] -fall_to [get_clocks {tx_clk_250mhz}]
set_false_path -hold  -rise_from [get_clocks {tx_clk_virtual_250mhz}] -rise_to [get_clocks {tx_clk_250mhz}]

set_multicycle_path -setup -end -rise_from [get_clocks {tx_clk_virtual_250mhz}] -rise_to [get_clocks {tx_clk_250mhz}] 0
set_multicycle_path -setup -end -fall_from [get_clocks {tx_clk_virtual_250mhz}] -rise_to [get_clocks {tx_clk_250mhz}] 0

# false paths
set_false_path -from {rx_clk_250mhz} -to  [get_ports tx_data_out*]
set_false_path -from {rx_clk_250mhz} -to  [get_ports tx_frame_out*]

set_false_path -from [get_ports {rx_clk_in}] -to  [get_ports {tx_clk_out_*}]

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]


