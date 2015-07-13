
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "7.500 ns"   -name ddr3_ref_clk_133mhz [get_ports {ddr3_ref_clk}]
create_clock -period "8.000 ns"   -name eth_ref_clk_125mhz  [get_ports {eth_ref_clk}]
create_clock -period "2.000 ns"   -name rx_ref_clk_500mhz   [get_ports {rx_ref_clk}]
create_clock -period "2.000 ns"   -name tx_ref_clk_500mhz   [get_ports {tx_ref_clk}]

derive_pll_clocks

create_generated_clock -source {i_system_bd|axi_jesd_xcvr|i_sys_xcvr|i_rx_pll|iopll_0|altera_pll_i|general[0].gpll~IOPLL|refclk[0]} \
  -divide_by 8 -multiply_by 4 -duty_cycle 50.00 -name {i_system_bd|axi_jesd_xcvr|rx_clk} \
  {i_system_bd|axi_jesd_xcvr|i_sys_xcvr|i_rx_pll|iopll_0|altera_pll_i|general[0].gpll~IOPLL|outclk[0]}

create_generated_clock -source {i_system_bd|axi_jesd_xcvr|i_sys_xcvr|i_tx_pll|iopll_0|altera_pll_i|general[0].gpll~IOPLL|refclk[0]} \
  -divide_by 8 -multiply_by 4 -duty_cycle 50.00 -name {i_system_bd|axi_jesd_xcvr|tx_clk} \
  {i_system_bd|axi_jesd_xcvr|i_sys_xcvr|i_tx_pll|iopll_0|altera_pll_i|general[0].gpll~IOPLL|outclk[0]}

derive_clock_uncertainty

