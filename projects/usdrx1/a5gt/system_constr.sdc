
create_clock -period "8.000 ns" -name n_eth_rx_clk_125m [get_ports {eth_rx_clk}]
create_clock -period "8.000 ns" -name n_eth_tx_clk_125m [get_ports {eth_tx_clk_out}]
create_clock -period "10.000 ns" -name n_clk_100m [get_ports {sys_clk}]
create_clock -period "12.500 ns" -name n_clk_80m [get_ports {ref_clk}]

derive_pll_clocks
derive_clock_uncertainty

set clk_100m     {i_system_bd|sys_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}
set clk_166m     {i_system_bd|sys_pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}
set clk_125m     {i_system_bd|sys_pll|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}
set clk_25m      {i_system_bd|sys_pll|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}
set clk_2m5      {i_system_bd|sys_pll|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|divclk}
set clk_rxlink   {i_system_bd|sys_jesd204b_s1_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}

set_clock_groups -asynchronous -group [get_clocks {n_clk_80m} ]
set_clock_groups -asynchronous -group [get_clocks {n_clk_100m} ]
set_clock_groups -asynchronous -group [get_clocks {n_eth_rx_clk_125m} ]
set_clock_groups -asynchronous -group [get_clocks {n_eth_tx_clk_125m} ]
set_clock_groups -asynchronous -group [get_clocks $clk_100m ]
set_clock_groups -asynchronous -group [get_clocks $clk_166m ]
set_clock_groups -asynchronous -group [get_clocks $clk_125m ]
set_clock_groups -asynchronous -group [get_clocks $clk_25m ]
set_clock_groups -asynchronous -group [get_clocks $clk_2m5 ]
set_clock_groups -asynchronous -group [get_clocks $clk_rxlink ]

set_false_path -from {sys_resetn} -to *
set_false_path -from  * -to {sys_resetn}
