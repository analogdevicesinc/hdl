
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "2.000 ns"   -name rx_ref_clk_500mhz   [get_ports {rx_ref_clk}]
create_clock -period "2.000 ns"   -name tx_ref_clk_500mhz   [get_ports {tx_ref_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_clocks {sys_clk_100mhz}] -to [get_clocks {\
  i_system_bd|sys_ddr3_cntrl_phy_clk_0 \
  i_system_bd|sys_ddr3_cntrl_phy_clk_1 \
  i_system_bd|sys_ddr3_cntrl_phy_clk_2 \
  i_system_bd|sys_ddr3_cntrl_phy_clk_l_0 \
  i_system_bd|sys_ddr3_cntrl_phy_clk_l_1 \
  i_system_bd|sys_ddr3_cntrl_phy_clk_l_2}]

set_false_path -from [get_clocks {sys_clk_100mhz}] -to [get_clocks {\
  i_system_bd|sys_ddr3_cntrl_core_nios_clk}]

set_false_path -from [get_clocks {sys_clk_100mhz}]\
  -through [get_nets *altera_jesd204_tx_csr_inst*]\
  -to [get_clocks {i_system_bd|avl_ad9152_xcvr|alt_core_pll|outclk0}]

set_false_path -from [get_clocks {sys_clk_100mhz}]\
  -through [get_nets *altera_jesd204_tx_ctl_inst*]\
  -to [get_clocks {i_system_bd|avl_ad9152_xcvr|alt_core_pll|outclk0}]

set_false_path -from [get_clocks {sys_clk_100mhz}]\
  -through [get_nets *altera_jesd204_rx_csr_inst*]\
  -to [get_clocks {i_system_bd|avl_ad9680_xcvr|alt_core_pll|outclk0}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9152_xcvr|alt_core_pll|outclk0}]\
  -through [get_nets *altera_jesd204_tx_csr_inst*]\
  -to [get_clocks {sys_clk_100mhz}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9152_xcvr|alt_core_pll|outclk0}]\
  -through [get_nets *altera_jesd204_tx_ctl_inst*]\
  -to [get_clocks {sys_clk_100mhz}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9680_xcvr|alt_core_pll|outclk0}]\
  -through [get_nets *altera_jesd204_rx_csr_inst*]\
  -to [get_clocks {sys_clk_100mhz}]

