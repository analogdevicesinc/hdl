
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "1.621 ns"  -name rx_ref_clk          [get_ports {rx_ref_clk}]
create_clock -period  "1.621 ns"  -name tx_ref_clk          [get_ports {tx_ref_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

# flash interface

set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_addr[*]} ]
set_input_delay   -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_data[*]} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_data[*]} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_cen[*]} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_oen} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_resetn} ]
set_output_delay  -clock [ get_clocks sys_clk_100mhz ] 2   [ get_ports {flash_wen} ]
set_false_path    -from * -to [get_ports {flash_resetn}]

 set current_exe $::TimeQuestInfo(nameofexecutable)
 if { $current_exe == "quartus_fit" } {
   set_max_delay -from [get_clocks {i_system_bd|sys_ddr3_cntrl_core_usr_clk}] -to [get_clocks {i_system_bd|sys_ddr3_cntrl_core_usr_clk}] 3
   set_max_delay -from [get_clocks {i_system_bd|sys_ddr3_cntrl_phy_clk_l_0}] -to [get_clocks {i_system_bd|sys_ddr3_cntrl_core_usr_clk}] 3
   set_max_delay -from [get_clocks {i_system_bd|sys_ddr3_cntrl_phy_clk_l_1}] -to [get_clocks {i_system_bd|sys_ddr3_cntrl_core_usr_clk}] 3
   set_max_delay -from [get_clocks {i_system_bd|ad9680_jesd204|link_pll|outclk0}] -to [get_clocks {i_system_bd|ad9680_jesd204|link_pll|outclk0}] 3
 }
