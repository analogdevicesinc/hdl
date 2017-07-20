
create_clock -period "10.000 ns"  -name sys_clk        [get_ports {sys_clk}]
create_clock -period "4.000 ns"   -name ref_clk        [get_ports {ref_clk}]
create_clock -period "8.000 ns"   -name eth_rx_clk     [get_ports {eth_rx_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_clock_groups -exclusive \
  -group [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] \
  -group [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] \
  -group [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -to [get_registers *sysref_en_m1*]

set_false_path -from [get_clocks {i_system_bd|sys_ddr3_cntrl|pll0|pll6~PLL_OUTPUT_COUNTER|divclk}] -through [get_nets *altera_jesd204_rx_ctl_inst*] \
  -to [get_clocks {i_system_bd|avl_ad9250_xcvr|alt_core_pll|altera_pll_i|arriav_pll|counter[0].output_counter|divclk}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9250_xcvr|alt_core_pll|altera_pll_i|arriav_pll|counter[0].output_counter|divclk}] \
  -through [get_nets *altera_jesd204_rx_ctl_inst*] -to [get_clocks {i_system_bd|sys_ddr3_cntrl|pll0|pll6~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from [get_clocks {i_system_bd|sys_ddr3_cntrl|pll0|pll6~PLL_OUTPUT_COUNTER|divclk}] -through [get_nets *altera_jesd204_rx_csr_inst*] \
  -to [get_clocks {i_system_bd|avl_ad9250_xcvr|alt_core_pll|altera_pll_i|arriav_pll|counter[0].output_counter|divclk}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9250_xcvr|alt_core_pll|altera_pll_i|arriav_pll|counter[0].output_counter|divclk}] \
  -through [get_nets *altera_jesd204_rx_csr_inst*] -to [get_clocks {i_system_bd|sys_ddr3_cntrl|pll0|pll6~PLL_OUTPUT_COUNTER|divclk}]

if {[string equal "quartus_fit" $::TimeQuestInfo(nameofexecutable)]} {
  set_max_delay -from [get_clocks {i_system_bd|sys_ddr3_cntrl|pll0|pll8~PLL_OUTPUT_COUNTER|divclk}] \
    -to [get_clocks {i_system_bd|sys_ddr3_cntrl|pll0|pll4~PLL_OUTPUT_COUNTER|divclk}] 0.150
  set_min_delay -from [get_clocks {i_system_bd|sys_ddr3_cntrl|pll0|pll8~PLL_OUTPUT_COUNTER|divclk}] \
    -to [get_clocks {i_system_bd|sys_ddr3_cntrl|pll0|pll4~PLL_OUTPUT_COUNTER|divclk}] 0.000
}

