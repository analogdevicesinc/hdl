
create_clock -period "20.000 ns" -name clk_50m  [get_ports {sys_clk}]
create_clock -period  "4.000 ns" -name clk_250m [get_ports {rx_clk_in}]
create_clock -period "12.500 ns" -name clk_80m  [get_pins {i_system_bd|c5soc|sys_hps|fpga_interfaces|clocks_resets|h2f_user0_clk}]

derive_pll_clocks
derive_clock_uncertainty

set clk_125m [get_clocks {i_system_bd|arradio|axi_ad9361|i_dev_if|i_rx|i_altlvds_rx|auto_generated|pll_sclk~PLL_OUTPUT_COUNTER|divclk}]

set clk_vga [get_clocks {i_system_bd|c5soc|vga_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from clk_50m     -to clk_80m
set_false_path -from clk_50m     -to $clk_125m
set_false_path -from clk_80m     -to clk_50m 
set_false_path -from clk_80m     -to $clk_125m
set_false_path -from $clk_125m   -to clk_50m 
set_false_path -from $clk_125m   -to clk_80m 
set_false_path -from clk_50m     -to $clk_vga
set_false_path -from $clk_vga    -to clk_50m

create_clock -period 4.0 -name v_rx_clk

set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_frame_in}]
set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[0]}]
set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[1]}]
set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[2]}]
set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[3]}]
set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[4]}]
set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[5]}]
set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_frame_in}]     -clock_fall -add_delay
set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[0]}]   -clock_fall -add_delay
set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[1]}]   -clock_fall -add_delay
set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[2]}]   -clock_fall -add_delay
set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[3]}]   -clock_fall -add_delay
set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[4]}]   -clock_fall -add_delay
set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[5]}]   -clock_fall -add_delay

create_generated_clock -source [get_ports {rx_clk_in}] -name v_tx_clk [get_ports {tx_clk_out}] -phase 90

set_false_path -from clk_250m    -to v_tx_clk
set_false_path -from v_tx_clk    -to clk_250m

set_output_delay  -clock {v_tx_clk} -max  1.2 [get_ports {tx_frame_out}]
set_output_delay  -clock {v_tx_clk} -max  1.2 [get_ports {tx_data_out[0]}]
set_output_delay  -clock {v_tx_clk} -max  1.2 [get_ports {tx_data_out[1]}]
set_output_delay  -clock {v_tx_clk} -max  1.2 [get_ports {tx_data_out[2]}]
set_output_delay  -clock {v_tx_clk} -max  1.2 [get_ports {tx_data_out[3]}]
set_output_delay  -clock {v_tx_clk} -max  1.2 [get_ports {tx_data_out[4]}]
set_output_delay  -clock {v_tx_clk} -max  1.2 [get_ports {tx_data_out[5]}]
set_output_delay  -clock {v_tx_clk} -min  0.2 [get_ports {tx_frame_out}]    -clock_fall -add_delay
set_output_delay  -clock {v_tx_clk} -min  0.2 [get_ports {tx_data_out[0]}]  -clock_fall -add_delay
set_output_delay  -clock {v_tx_clk} -min  0.2 [get_ports {tx_data_out[1]}]  -clock_fall -add_delay
set_output_delay  -clock {v_tx_clk} -min  0.2 [get_ports {tx_data_out[2]}]  -clock_fall -add_delay
set_output_delay  -clock {v_tx_clk} -min  0.2 [get_ports {tx_data_out[3]}]  -clock_fall -add_delay
set_output_delay  -clock {v_tx_clk} -min  0.2 [get_ports {tx_data_out[4]}]  -clock_fall -add_delay
set_output_delay  -clock {v_tx_clk} -min  0.2 [get_ports {tx_data_out[5]}]  -clock_fall -add_delay

