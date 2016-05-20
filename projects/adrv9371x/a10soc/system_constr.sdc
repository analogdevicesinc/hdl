
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "8.139 ns"  -name ref_clk0_122mhz     [get_ports {ref_clk0}]
create_clock -period  "8.139 ns"  -name ref_clk1_122mhz     [get_ports {ref_clk1}]

derive_pll_clocks
derive_clock_uncertainty

