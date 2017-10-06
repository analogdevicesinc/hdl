
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -to [get_registers *sysref_en_m1*]
set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]
set_false_path -from [get_clocks {sys_clk_100mhz}] -through [get_nets *altera_jesd204*] -to [get_clocks *outclk0*]
set_false_path -from [get_clocks *outclk0*] -through [get_nets *altera_jesd204*] -to [get_clocks {sys_clk_100mhz}]
set_false_path -to [get_registers *altera_jesd204_rx_csr_inst|phy_csr_rx_pcfifo_full_latched*]

# flash interface

set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_addr[*]} ]
set_input_delay   -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_data[*]} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_data[*]} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_cen[*]} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_oen} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_resetn} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_wen} ]
set_false_path    -from * -to [get_ports {flash_resetn}]

