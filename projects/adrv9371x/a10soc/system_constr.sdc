
# qsys- automatically infers these clocks

create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "8.139 ns"  -name ref_clk0_122mhz     [get_ports {ref_clk0}]
create_clock -period  "8.139 ns"  -name ref_clk1_122mhz     [get_ports {ref_clk1}]
create_clock -period  "7.503 ns"  -name hps_ddr_ref_clk_133mhz  [get_ports {hps_ddr_ref_clk}]
create_clock -period "10.000 ns"  -name sys_ddr_ref_clk_100mhz  [get_ports {sys_ddr_ref_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -to [get_registers *sys_gpio_in|readdata[12]*]
set_false_path -to [get_registers *sys_gpio_in|readdata[13]*]

set_false_path -from [get_clocks {sys_clk_100mhz}]\
  -through [get_nets *altera_jesd204_tx_csr_inst*]\
  -to [get_clocks {i_system_bd|avl_ad9371_tx_xcvr|alt_core_pll|outclk0}]

set_false_path -from [get_clocks {sys_clk_100mhz}]\
  -through [get_nets *altera_jesd204_tx_ctl_inst*]\
  -to [get_clocks {i_system_bd|avl_ad9371_tx_xcvr|alt_core_pll|outclk0}]

set_false_path -from [get_clocks {sys_clk_100mhz}]\
  -through [get_nets *altera_jesd204_rx_csr_inst*]\
  -to [get_clocks {i_system_bd|avl_ad9371_rx_xcvr|alt_core_pll|outclk0}]

set_false_path -from [get_clocks {sys_clk_100mhz}]\
  -through [get_nets *altera_jesd204_rx_csr_inst*]\
  -to [get_clocks {i_system_bd|avl_ad9371_rx_os_xcvr|alt_core_pll|outclk0}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9371_tx_xcvr|alt_core_pll|outclk0}]\
  -through [get_nets *altera_jesd204_tx_csr_inst*]\
  -to [get_clocks {sys_clk_100mhz}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9371_tx_xcvr|alt_core_pll|outclk0}]\
  -through [get_nets *altera_jesd204_tx_ctl_inst*]\
  -to [get_clocks {sys_clk_100mhz}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9371_rx_xcvr|alt_core_pll|outclk0}]\
  -through [get_nets *altera_jesd204_rx_csr_inst*]\
  -to [get_clocks {sys_clk_100mhz}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9371_rx_os_xcvr|alt_core_pll|outclk0}]\
  -through [get_nets *altera_jesd204_rx_csr_inst*]\
  -to [get_clocks {sys_clk_100mhz}]

