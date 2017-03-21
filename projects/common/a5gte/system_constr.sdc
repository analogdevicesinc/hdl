
create_clock -period "8.000 ns" -name phy_rx_clk [get_ports {phy_rx_clk}]

derive_pll_clocks
derive_clock_uncertainty

