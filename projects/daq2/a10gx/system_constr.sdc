
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "7.500 ns"   -name ddr3_ref_clk_133mhz [get_ports {ddr3_ref_clk}]
create_clock -period "8.000 ns"   -name eth_ref_clk_125mhz  [get_ports {eth_ref_clk}]
create_clock -period "2.000 ns"   -name rx_ref_clk_500mhz   [get_ports {rx_ref_clk}]
create_clock -period "2.000 ns"   -name tx_ref_clk_500mhz   [get_ports {tx_ref_clk}]

derive_pll_clocks
derive_clock_uncertainty



