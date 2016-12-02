
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "2.000 ns"   -name rx_clk_500mhz       [get_ports {adc_clk_in}]
create_clock -period "2.000 ns"   -name tx_clk_500mhz       [get_ports {dac_clk_in}]

derive_pll_clocks
derive_clock_uncertainty

