
create_clock -period  "4.000 ns" -name ref_clk [get_ports {ref_clk}]
create_clock -period "20.000 ns" -name sys_cpu_clk [get_pins {i_system_bd|sys_hps|fpga_interfaces|clocks_resets|h2f_user0_clk}]
create_clock -period "10.000 ns" -name sys_dma_clk [get_pins {i_system_bd|sys_hps|fpga_interfaces|clocks_resets|h2f_user1_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -to [get_registers *sysref_en_m1*]

set_false_path -from [get_clocks {sys_cpu_clk}] -through [get_nets *altera_jesd204_rx_ctl_inst*]\
  -to [get_clocks {i_system_bd|avl_ad9250_xcvr|alt_core_pll|altera_pll_i|arriav_pll|counter[0].output_counter|divclk}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9250_xcvr|alt_core_pll|altera_pll_i|arriav_pll|counter[0].output_counter|divclk}]\
  -through [get_nets *altera_jesd204_rx_ctl_inst*] -to [get_clocks {sys_cpu_clk}]

set_false_path -from [get_clocks {sys_cpu_clk}] -through [get_nets *altera_jesd204_rx_csr_inst*]\
  -to [get_clocks {i_system_bd|avl_ad9250_xcvr|alt_core_pll|altera_pll_i|arriav_pll|counter[0].output_counter|divclk}]

set_false_path -from [get_clocks {i_system_bd|avl_ad9250_xcvr|alt_core_pll|altera_pll_i|arriav_pll|counter[0].output_counter|divclk}]\
  -through [get_nets *altera_jesd204_rx_csr_inst*] -to [get_clocks {sys_cpu_clk}]

