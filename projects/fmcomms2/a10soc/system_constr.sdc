
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "4.000 ns"  -name rx_clk_250mhz       [get_ports {rx_clk_in}]

derive_pll_clocks
derive_clock_uncertainty

