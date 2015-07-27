
create_clock -period  "4.000 ns" -name clk_250m [get_ports {ref_clk}]

derive_pll_clocks
derive_clock_uncertainty



