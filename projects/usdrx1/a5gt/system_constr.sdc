
create_clock -period "10.000 ns" -name n_clk_100m [get_ports {sys_clk}]
create_clock -period "12.500 ns" -name n_clk_80m [get_ports {ref_clk}]


derive_pll_clocks
derive_clock_uncertainty


