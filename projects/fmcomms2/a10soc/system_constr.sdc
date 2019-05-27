
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "4.000 ns"   -name rx_clk_250mhz       [get_ports {rx_clk_in}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]
set_false_path -from [get_registers system_bd:i_system_bd|axi_ad9361:axi_ad9361|axi_ad9361_lvds_if:i_dev_if|axi_ad9361_lvds_if_10:i_axi_ad9361_lvds_if_10|locked_int]
