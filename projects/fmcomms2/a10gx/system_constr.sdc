
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "4.000 ns"   -name rx_clk_250mhz       [get_ports {rx_clk}]

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
