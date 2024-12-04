# VCCO_HDA
# set_property -dict {PACKAGE_PIN  IOSTANDARD LVCMOS18 PULLUP true} [get_ports sfp_i2c_sda] ;
# set_property -dict {PACKAGE_PIN  IOSTANDARD LVCMOS18 PULLUP true} [get_ports sfp_i2c_scl] ;
# set_property -dict {PACKAGE_PIN  IOSTANDARD LVCMOS18} [get_ports sfp_i2c_rstn]            ;
# set_property -dict {PACKAGE_PIN  IOSTANDARD LVCMOS18} [get_ports sfp_i2c_en]              ;




# set_false_path -to [get_ports {sfp_i2c_sda sfp_i2c_scl}]
# set_output_delay 0 [get_ports {sfp_i2c_sda sfp_i2c_scl}]

# set_false_path -from [get_ports {sfp_i2c_sda sfp_i2c_scl}]
# set_input_delay 0 [get_ports {sfp_i2c_sda sfp_i2c_scl}]

set_property -dict {PACKAGE_PIN AU10 IOSTANDARD LVCMOS18} [get_ports sfp_tx_disable] ;
set_false_path -to [get_ports {sfp_tx_disable}]
set_output_delay 0 [get_ports {sfp_tx_disable}]

# SFP+ Interface corundum
set_property PACKAGE_PIN U12  [get_ports sfp_mgt_refclk_p] ; ####ETH_REFCLK2_P
set_property PACKAGE_PIN U11  [get_ports sfp_mgt_refclk_n] ; ####ETH_REFCLK2_N
set_property PACKAGE_PIN J4   [get_ports sfp_rx_p] ;
set_property PACKAGE_PIN J3   [get_ports sfp_rx_n] ;
set_property PACKAGE_PIN J8   [get_ports sfp_tx_p] ;
set_property PACKAGE_PIN J7   [get_ports sfp_tx_n] ;

create_clock -period 6.400 -name gt_ref_clk [get_ports sfp_mgt_refclk_p]
