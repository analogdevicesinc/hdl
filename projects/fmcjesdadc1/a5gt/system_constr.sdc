
create_clock -period "10.000 ns"  -name sys_clk_100mhz        [get_ports {sys_clk}]
create_clock -period "4.000 ns"   -name ref_clk_250mhz        [get_ports {ref_clk}]
create_clock -period "8.000 ns"   -name eth_rx_clk_125mhz     [get_ports {eth_rx_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_clock_groups -exclusive \
  -group [get_clocks {i_system_bd|a5gt_base|sys_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] \
  -group [get_clocks {i_system_bd|a5gt_base|sys_pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] \
  -group [get_clocks {i_system_bd|a5gt_base|sys_pll|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_clock_groups -asynchronous \
  -group {ref_clk_250mhz} \
  -group [get_clocks {i_system_bd|fmcjesdadc1|xcvr_rx_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] \
  -group [get_clocks {i_system_bd|a5gt_base|sys_pll|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]
