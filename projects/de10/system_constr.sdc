
create_clock -period "20.000 ns" -name sys_clk  [get_ports {sys_clk}]

derive_pll_clocks
derive_clock_uncertainty

