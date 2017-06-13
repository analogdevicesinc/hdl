
create_clock -period  "4.000 ns" -name ref_clk [get_ports {ref_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -to [get_registers *sysref_en_m1*]
set_false_path -from [get_clocks *h2f_user0_clk*] -through [get_nets *altera_jesd204*] -to [get_clocks *divclk*]
set_false_path -from [get_clocks *divclk*] -through [get_nets *altera_jesd204*] -to [get_clocks *h2f_user0_clk*]

