
## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/common/vck190/vck190_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

# use versal transceiver wizard
set ADI_PHY_SEL 0

source $ad_hdl_dir/projects/ad9081_fmca_ebz/common/ad9081_fmca_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# Add VIO
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_vio:1.0 jesd204_phy/axis_vio_0
connect_bd_net [get_bd_pins jesd204_phy/axis_vio_0/probe_out0] [get_bd_pins jesd204_phy/gt_quad_base_0/ch0_loopback]
set_property -dict [list CONFIG.C_PROBE_OUT1_WIDTH {3} CONFIG.C_PROBE_OUT0_WIDTH {3} CONFIG.C_NUM_PROBE_OUT {2} CONFIG.C_EN_PROBE_IN_ACTIVITY {0} CONFIG.C_NUM_PROBE_IN {0}] [get_bd_cells jesd204_phy/axis_vio_0]
connect_bd_net [get_bd_pins jesd204_phy/apb3clk] [get_bd_pins jesd204_phy/axis_vio_0/clk]
connect_bd_net [get_bd_pins jesd204_phy/gt_quad_base_0/ch1_loopback] [get_bd_pins jesd204_phy/axis_vio_0/probe_out1]


# Add ILA
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {rx_mxfe_tpl_core_adc_data_0 }]
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {ext_sync_in_1 }]
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {util_mxfe_upack_fifo_rd_data_0 }]
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {tx_mxfe_tpl_core_link}]
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {rx_mxfe_tpl_core_adc_valid_0 }]
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {axi_mxfe_rx_jesd_rx_data_tvalid axi_mxfe_rx_jesd_rx_data_tdata }]
apply_bd_automation -rule xilinx.com:bd_rule:debug -dict [list \
                                                          [get_bd_nets axi_mxfe_rx_jesd_rx_data_tdata] {PROBE_TYPE "Data and Trigger" CLK_SRC "None (Connect manually)" AXIS_ILA "Auto" } \
                                                          [get_bd_nets axi_mxfe_rx_jesd_rx_data_tvalid] {PROBE_TYPE "Data and Trigger" CLK_SRC "None (Connect manually)" AXIS_ILA "Auto" } \
                                                          [get_bd_nets ext_sync_in_1] {PROBE_TYPE "Data and Trigger" CLK_SRC "None (Connect manually)" AXIS_ILA "Auto" } \
                                                          [get_bd_nets rx_mxfe_tpl_core_adc_data_0] {PROBE_TYPE "Data and Trigger" CLK_SRC "None (Connect manually)" AXIS_ILA "Auto" } \
                                                          [get_bd_nets rx_mxfe_tpl_core_adc_valid_0] {PROBE_TYPE "Data and Trigger" CLK_SRC "None (Connect manually)" AXIS_ILA "Auto" } \
                                                          [get_bd_intf_nets tx_mxfe_tpl_core_link] {AXIS_SIGNALS "Data and Trigger" CLK_SRC "/tx_device_clk" AXIS_ILA "Auto" APC_EN "0" } \
                                                          [get_bd_nets util_mxfe_upack_fifo_rd_data_0] {PROBE_TYPE "Data and Trigger" CLK_SRC "/tx_device_clk" AXIS_ILA "Auto" } \
                                                         ]
set_property -dict [list CONFIG.C_BRAM_CNT {50.5} CONFIG.C_DATA_DEPTH {4096}] [get_bd_cells axis_ila_0]

set_property -dict [list CONFIG.C_NUM_OF_PROBES {7}] [get_bd_cells axis_ila_0]
connect_bd_net [get_bd_pins axis_ila_0/probe6] [get_bd_pins manual_sync_or/Res]
