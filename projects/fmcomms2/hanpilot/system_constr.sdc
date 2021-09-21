
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "4.000 ns"   -name rx_clk_250mhz       [get_ports {rx_clk_in}]
create_clock -period "4.000 ns"   -name tx_clk_250mhz       [get_ports {tx_clk_out}]
create_clock -period "4.000 ns"   -name rx_clk_virtual_250mhz

derive_pll_clocks
derive_clock_uncertainty

#AN433
set_input_delay -max 0.25 -clock {rx_clk_virtual_250mhz} [get_ports rx_data_in*]
set_input_delay -max -add_delay 0.25 -clock {rx_clk_virtual_250mhz} -clock_fall [get_ports rx_data_in*]

set_input_delay -max 0.25 -clock {rx_clk_virtual_250mhz} [get_ports rx_frame_in]
set_input_delay -max -add_delay 0.25 -clock {rx_clk_virtual_250mhz} -clock_fall [get_ports rx_frame_in]

set_input_delay -min -add_delay 0.5 -clock {rx_clk_virtual_250mhz} [get_ports rx_data_in*]
set_input_delay -min -add_delay 0.5 -clock {rx_clk_virtual_250mhz} -clock_fall [get_ports rx_data_in*]

set_input_delay -min -add_delay 0.5 -clock {rx_clk_virtual_250mhz} [get_ports rx_frame_in]
set_input_delay -min -add_delay 0.5 -clock {rx_clk_virtual_250mhz} -clock_fall [get_ports rx_frame_in]

set_output_delay 0.25 -clock {tx_clk_250mhz} [get_ports tx_data_out*]
set_output_delay -add_delay 0.25 -clock {tx_clk_250mhz} -clock_fall [get_ports tx_data_out*]

set_output_delay 0.25 -clock {tx_clk_250mhz} [get_ports tx_frame_out]
set_output_delay -add_delay 0.25 -clock {tx_clk_250mhz} -clock_fall [get_ports tx_frame_out]

set_false_path -from {rx_clk_250mhz} -to  [get_ports tx_data_out*]
set_false_path -from {rx_clk_250mhz} -to  [get_ports tx_frame_out*]

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

