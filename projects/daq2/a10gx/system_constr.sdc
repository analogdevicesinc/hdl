
source ../../common/a10gx/a10gx_system_constr.sdc

create_clock -period  "3.000 ns"  -name rx_ref_clk          [get_ports {rx_ref_clk}]
create_clock -period  "3.000 ns"  -name tx_ref_clk          [get_ports {tx_ref_clk}]

derive_pll_clocks
derive_clock_uncertainty

