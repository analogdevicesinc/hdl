
create_clock -period "10.000 ns" -name n_clk_100m [get_ports {sys_clk}]
create_clock -period "4.000 ns" -name n_clk_250m [get_ports {ref_clk}]
create_clock -period "8.000 ns" -name n_eth_rx_clk_125m [get_ports {eth_rx_clk}]
create_clock -period "8.000 ns" -name n_eth_tx_clk_125m [get_nets {eth_tx_clk}]

derive_pll_clocks
derive_clock_uncertainty

set clk_100m    [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]
set clk_125m    [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]
set clk_25m     [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]
set clk_2m5     [get_clocks {i_system_bd|sys_pll|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|divclk}]
set clk_rxlink  [get_clocks {i_system_bd|sys_jesd204b_s1_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from {sys_resetn} -to *
set_false_path -from $clk_100m -to $clk_rxlink
set_false_path -from $clk_rxlink -to $clk_100m

set_false_path -from $clk_125m -to $clk_25m
set_false_path -from $clk_125m -to $clk_2m5
set_false_path -from $clk_25m -to $clk_125m
set_false_path -from $clk_25m -to $clk_2m5
set_false_path -from $clk_2m5 -to $clk_125m
set_false_path -from $clk_2m5 -to $clk_25m


