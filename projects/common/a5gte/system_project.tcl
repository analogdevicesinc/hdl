
load_package flow

source ../../scripts/adi_env.tcl
project_new a5gte -overwrite

# device settings

set_global_assignment -name FAMILY "Arria V"
set_global_assignment -name DEVICE 5AGTFD7K3F40I3
set_global_assignment -name TOP_LEVEL_ENTITY system_top
set_global_assignment -name VERILOG_FILE system_top.v

# fmc fpga interface

set_location_assignment PIN_R11 -to eth_rx_clk
set_location_assignment PIN_T11 -to "eth_rx_clk(n)"
set_location_assignment PIN_J11 -to eth_rx_cntrl
set_location_assignment PIN_K11 -to "eth_rx_cntrl(n)"
set_location_assignment PIN_F12 -to eth_rx_data[0]
set_location_assignment PIN_G12 -to "eth_rx_data[0](n)"
set_location_assignment PIN_H12 -to eth_rx_data[1]
set_location_assignment PIN_J12 -to "eth_rx_data[1](n)"
set_location_assignment PIN_M13 -to eth_rx_data[2]
set_location_assignment PIN_N13 -to "eth_rx_data[2](n)"
set_location_assignment PIN_G13 -to eth_rx_data[3]
set_location_assignment PIN_H13 -to "eth_rx_data[3](n)"

set_instance_assignment -name IO_STANDARD LVDS -to eth_rx_clk
set_instance_assignment -name IO_STANDARD LVDS -to eth_rx_cntrl
set_instance_assignment -name IO_STANDARD LVDS -to eth_rx_data[0]
set_instance_assignment -name IO_STANDARD LVDS -to eth_rx_data[1]
set_instance_assignment -name IO_STANDARD LVDS -to eth_rx_data[2]
set_instance_assignment -name IO_STANDARD LVDS -to eth_rx_data[3]

set_location_assignment PIN_E10 -to eth_tx_clk_out
set_location_assignment PIN_F10 -to "eth_tx_clk_out(n)"
set_location_assignment PIN_P12 -to eth_tx_cntrl
set_location_assignment PIN_R12 -to "eth_tx_cntrl(n)"
set_location_assignment PIN_M12 -to eth_tx_data[0]
set_location_assignment PIN_N12 -to "eth_tx_data[0](n)"
set_location_assignment PIN_D12 -to eth_tx_data[1]
set_location_assignment PIN_E12 -to "eth_tx_data[1](n)"
set_location_assignment PIN_P13 -to eth_tx_data[2]
set_location_assignment PIN_R13 -to "eth_tx_data[2](n)"
set_location_assignment PIN_D13 -to eth_tx_data[3]
set_location_assignment PIN_E13 -to "eth_tx_data[3](n)"

set_instance_assignment -name IO_STANDARD LVDS -to eth_tx_clk_out
set_instance_assignment -name IO_STANDARD LVDS -to eth_tx_cntrl
set_instance_assignment -name IO_STANDARD LVDS -to eth_tx_data[0]
set_instance_assignment -name IO_STANDARD LVDS -to eth_tx_data[1]
set_instance_assignment -name IO_STANDARD LVDS -to eth_tx_data[2]
set_instance_assignment -name IO_STANDARD LVDS -to eth_tx_data[3]

set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to eth_tx_clk_out
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to eth_tx_cntrl
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to eth_tx_data[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to eth_tx_data[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to eth_tx_data[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to eth_tx_data[3]

set_location_assignment PIN_L15 -to eth_mdc
set_location_assignment PIN_M15 -to eth_mdio_i
set_location_assignment PIN_N15 -to eth_mdio_o
set_location_assignment PIN_P15 -to eth_mdio_t
set_location_assignment PIN_A9  -to eth_phy_resetn

set_instance_assignment -name IO_STANDARD "2.5 V" -to eth_mdc
set_instance_assignment -name IO_STANDARD "2.5 V" -to eth_mdio_i
set_instance_assignment -name IO_STANDARD "2.5 V" -to eth_mdio_o
set_instance_assignment -name IO_STANDARD "2.5 V" -to eth_mdio_t
set_instance_assignment -name IO_STANDARD "2.5 V" -to eth_phy_resetn

# phy interface

set_location_assignment PIN_AK17  -to phy_resetn
set_location_assignment PIN_AJ18  -to phy_mdc
set_location_assignment PIN_AL17  -to phy_mdio
set_location_assignment PIN_AK7   -to phy_rx_clk
set_location_assignment PIN_AW17  -to phy_rx_cntrl
set_location_assignment PIN_AU17  -to phy_rx_data[0]
set_location_assignment PIN_AT17  -to phy_rx_data[1]
set_location_assignment PIN_AW16  -to phy_rx_data[2]
set_location_assignment PIN_AH18  -to phy_rx_data[3]
set_location_assignment PIN_AN16  -to phy_tx_clk_out
set_location_assignment PIN_AP19  -to phy_tx_cntrl
set_location_assignment PIN_AT19  -to phy_tx_data[0]
set_location_assignment PIN_AU18  -to phy_tx_data[1]
set_location_assignment PIN_AH19  -to phy_tx_data[2]
set_location_assignment PIN_AG19  -to phy_tx_data[3]

set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_resetn
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_mdc
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_mdio
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_rx_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_rx_cntrl
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_rx_data[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_rx_data[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_rx_data[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_rx_data[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_tx_clk_out
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_tx_cntrl
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_tx_data[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_tx_data[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_tx_data[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to phy_tx_data[3]

set_global_assignment -name SYNCHRONIZER_IDENTIFICATION AUTO
set_global_assignment -name ENABLE_ADVANCED_IO_TIMING ON
set_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER ON
set_global_assignment -name TIMEQUEST_DO_REPORT_TIMING ON
set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL ON
set_global_assignment -name TIMEQUEST_REPORT_SCRIPT $ad_hdl_dir/projects/scripts/adi_tquest.tcl
set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF

execute_flow -compile

