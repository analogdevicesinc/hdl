
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "8.138 ns"  -name ref_clk0            [get_ports {ref_clk0}]
create_clock -period  "8.138 ns"  -name ref_clk1            [get_ports {ref_clk1}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

if {[string equal "quartus_fit" $::TimeQuestInfo(nameofexecutable)]} {
  set_max_delay -from [get_clocks *sys_ddr3_cntrl_phy_clk_l*] -to [get_clocks *sys_ddr3_cntrl_core_usr_clk*] 0.150
  set_min_delay -from [get_clocks *sys_ddr3_cntrl_phy_clk_l*] -to [get_clocks *sys_ddr3_cntrl_core_usr_clk*] 0.000
}

# flash interface

set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_addr[*]} ]
set_input_delay   -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_data[*]} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_data[*]} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_cen[*]} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_oen} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_resetn} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_wen} ]
set_false_path    -from * -to [get_ports {flash_resetn}]

