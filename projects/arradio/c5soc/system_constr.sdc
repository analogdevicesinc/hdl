
create_clock -period "20.000 ns" -name sys_clk  [get_ports {sys_clk}]
create_clock -period "12.500 ns" -name dma_clk  [get_pins {*sys_hps*h2f_user0_clk}]

create_clock -period 4.0 -name rx_clk [get_ports {rx_clk_in}]

derive_pll_clocks
derive_clock_uncertainty

#create_clock -period 4.0 -name v_rx_clk
#create_generated_clock -source [get_clocks {*axi_ad9361*alt_clk*divclk}] -name v_fb_clk [get_ports {tx_clk_out}]

#set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_frame_in}]
#set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[0]}]
#set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[1]}]
#set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[2]}]
#set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[3]}]
#set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[4]}]
#set_input_delay   -clock {v_rx_clk} -max  1.2 [get_ports {rx_data_in[5]}]
#set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_frame_in}]     -clock_fall -add_delay
#set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[0]}]   -clock_fall -add_delay
#set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[1]}]   -clock_fall -add_delay
#set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[2]}]   -clock_fall -add_delay
#set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[3]}]   -clock_fall -add_delay
#set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[4]}]   -clock_fall -add_delay
#set_input_delay   -clock {v_rx_clk} -min  0.2 [get_ports {rx_data_in[5]}]   -clock_fall -add_delay


#set_output_delay  -clock {v_fb_clk} -max  1.2 [get_ports {tx_frame_out}]
#set_output_delay  -clock {v_fb_clk} -max  1.2 [get_ports {tx_data_out[0]}]
#set_output_delay  -clock {v_fb_clk} -max  1.2 [get_ports {tx_data_out[1]}]
#set_output_delay  -clock {v_fb_clk} -max  1.2 [get_ports {tx_data_out[2]}]
#set_output_delay  -clock {v_fb_clk} -max  1.2 [get_ports {tx_data_out[3]}]
#set_output_delay  -clock {v_fb_clk} -max  1.2 [get_ports {tx_data_out[4]}]
#set_output_delay  -clock {v_fb_clk} -max  1.2 [get_ports {tx_data_out[5]}]
#set_output_delay  -clock {v_fb_clk} -min  0.2 [get_ports {tx_frame_out}]    -clock_fall -add_delay
#set_output_delay  -clock {v_fb_clk} -min  0.2 [get_ports {tx_data_out[0]}]  -clock_fall -add_delay
#set_output_delay  -clock {v_fb_clk} -min  0.2 [get_ports {tx_data_out[1]}]  -clock_fall -add_delay
#set_output_delay  -clock {v_fb_clk} -min  0.2 [get_ports {tx_data_out[2]}]  -clock_fall -add_delay
#set_output_delay  -clock {v_fb_clk} -min  0.2 [get_ports {tx_data_out[3]}]  -clock_fall -add_delay
#set_output_delay  -clock {v_fb_clk} -min  0.2 [get_ports {tx_data_out[4]}]  -clock_fall -add_delay
#set_output_delay  -clock {v_fb_clk} -min  0.2 [get_ports {tx_data_out[5]}]  -clock_fall -add_delay

