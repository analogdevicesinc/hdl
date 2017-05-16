
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_clocks {sys_clk_100mhz}] -through [get_nets *altera_jesd204_rx_csr_inst*] \
	-to [get_clocks {i_system_bd|avl_ad9680_xcvr|alt_core_pll|outclk0}]
set_false_path -from [get_clocks {sys_clk_100mhz}] -through [get_nets *altera_jesd204_tx_csr_inst*] \
	-to [get_clocks {i_system_bd|avl_ad9144_xcvr|alt_core_pll|outclk0}]
set_false_path -from [get_clocks {sys_clk_100mhz}] -through [get_nets *altera_jesd204_tx_ctl_inst*] \
	-to [get_clocks {i_system_bd|avl_ad9144_xcvr|alt_core_pll|outclk0}]
set_false_path -from [get_clocks {i_system_bd|avl_ad9680_xcvr|alt_core_pll|outclk0}] \
	-through [get_nets *altera_jesd204_rx_csr_inst*] -to [get_clocks {sys_clk_100mhz}]
set_false_path -from [get_clocks {i_system_bd|avl_ad9144_xcvr|alt_core_pll|outclk0}] \
	-through [get_nets *altera_jesd204_tx_csr_inst*] -to [get_clocks {sys_clk_100mhz}]
set_false_path -from [get_clocks {i_system_bd|avl_ad9144_xcvr|alt_core_pll|outclk0}] \
	-through [get_nets *altera_jesd204_tx_ctl_inst*] -to [get_clocks {sys_clk_100mhz}]


