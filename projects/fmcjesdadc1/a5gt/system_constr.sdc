
create_clock -period "10.000 ns"  -name sys_clk        [get_ports {sys_clk}]
create_clock -period "4.000 ns"   -name ref_clk        [get_ports {ref_clk}]
create_clock -period "8.000 ns"   -name eth_rx_clk     [get_ports {eth_rx_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_clock_groups -exclusive \
  -group [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] \
  -group [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] \
  -group [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from [get_clocks *divclk*] -through [get_nets *altera_jesd204*] -to [get_clocks *pll_avl_clk*]
set_false_path -from [get_clocks *pll_avl_clk*] -through [get_nets *altera_jesd204*] -to [get_clocks *divclk*]

if {[string equal "quartus_fit" $::TimeQuestInfo(nameofexecutable)]} {
  set_max_delay -from [get_clocks *pll_hr_clk*] -to [get_clocks *pll_afi_phy_clk*] 0.150
  set_min_delay -from [get_clocks *pll_hr_clk*] -to [get_clocks *pll_afi_phy_clk*] 0.000
}

