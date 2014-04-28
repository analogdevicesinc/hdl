
create_clock -period "20.000 ns" -name n_clk_50m [get_ports {sys_clk}]
create_clock -period "4.000 ns" -name n_clk_250m [get_ports {ref_clk}]

derive_pll_clocks
derive_clock_uncertainty

#set clk_500m    [get_clocks {i_system_bd|sys_jesd204b_s1_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]
set clk_rxlink  [get_clocks {i_system_bd|sys_jesd204b_s1_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from {sys_resetn} -to *
#set_false_path -from $clk_50m -to $clk_rxlink
#set_false_path -from $clk_rxlink -to $clk_50m



