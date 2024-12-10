###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create ethernet

set_property part xcvu9p-flga2104-2L-e [current_project]

source "$ad_hdl_dir/../ucorundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_usplus.tcl"
source "$ad_hdl_dir/../ucorundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_gty.tcl"

# Corundum sources
adi_ip_files ethernet [list \
  "ethernet_core.v" \
  "$ad_hdl_dir/../ucorundum/fpga/mqnic/VCU118/fpga_100g/rtl/sync_signal.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_port_map_mac_axis.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/cmac_gty_wrapper.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/cmac_gty_ch_wrapper.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/rb_drp.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/cmac_pad.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mac_ts_insert.v" \
]

adi_ip_properties_lite ethernet
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum} [ipx::current_core]

set cc [ipx::current_core]

set_property display_name "Corundum Ethernet" $cc
set_property description "Corundum Ethernet Core IP" $cc

# Remove all inferred interfaces and address spaces
ipx::remove_all_bus_interface [ipx::current_core]
ipx::remove_all_address_space [ipx::current_core]

# Interface definitions

adi_add_bus "axis_eth_tx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"axis_eth_tx_tdata" "TDATA"} \
    {"axis_eth_tx_tkeep" "TKEEP"} \
    {"axis_eth_tx_tvalid" "TVALID"} \
    {"axis_eth_tx_tready" "TREADY"} \
    {"axis_eth_tx_tlast" "TLAST"} \
    {"axis_eth_tx_tuser" "TUSER"} ]

adi_add_bus_clock "eth_tx_clk" "axis_eth_tx" "eth_tx_rst"

adi_add_bus "axis_eth_rx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"axis_eth_rx_tdata" "TDATA"} \
    {"axis_eth_rx_tkeep" "TKEEP"} \
    {"axis_eth_rx_tvalid" "TVALID"} \
    {"axis_eth_rx_tready" "TREADY"} \
    {"axis_eth_rx_tlast" "TLAST"} \
    {"axis_eth_rx_tuser" "TUSER"} ]

adi_add_bus_clock "eth_rx_clk" "axis_eth_rx" "eth_rx_rst"

adi_if_infer_bus analog.com:interface:if_ctrl_reg slave ctrl_reg [list \
  "ctrl_reg_wr_addr ctrl_reg_wr_addr" \
  "ctrl_reg_wr_data ctrl_reg_wr_data" \
  "ctrl_reg_wr_strb ctrl_reg_wr_strb" \
  "ctrl_reg_wr_en   ctrl_reg_wr_en" \
  "ctrl_reg_wr_wait ctrl_reg_wr_wait" \
  "ctrl_reg_wr_ack  ctrl_reg_wr_ack" \
  "ctrl_reg_rd_addr ctrl_reg_rd_addr" \
  "ctrl_reg_rd_data ctrl_reg_rd_data" \
  "ctrl_reg_rd_en   ctrl_reg_rd_en" \
  "ctrl_reg_rd_wait ctrl_reg_rd_wait" \
  "ctrl_reg_rd_ack  ctrl_reg_rd_ack" \
]

adi_if_infer_bus analog.com:interface:if_flow_control_tx slave flow_control_tx [list \
  "tx_enable           eth_tx_enable" \
  "tx_status           eth_tx_status" \
  "tx_lfc_en           eth_tx_lfc_en" \
  "tx_lfc_req          eth_tx_lfc_req" \
  "tx_pfc_en           eth_tx_pfc_en" \
  "tx_pfc_req          eth_tx_pfc_req" \
]

adi_if_infer_bus analog.com:interface:if_flow_control_rx slave flow_control_rx [list \
  "rx_enable           eth_rx_enable" \
  "rx_status           eth_rx_status" \
  "rx_lfc_en           eth_rx_lfc_en" \
  "rx_lfc_req          eth_rx_lfc_req" \
  "rx_lfc_ack          eth_rx_lfc_ack" \
  "rx_pfc_en           eth_rx_pfc_en" \
  "rx_pfc_req          eth_rx_pfc_req" \
  "rx_pfc_ack          eth_rx_pfc_ack" \
]

adi_if_infer_bus analog.com:interface:if_ethernet_ptp slave ethernet_ptp_tx [list \
  "ptp_clk     eth_tx_ptp_clk" \
  "ptp_rst     eth_tx_ptp_rst" \
  "ptp_ts      eth_tx_ptp_ts" \
  "ptp_ts_step eth_tx_ptp_ts_step" \
]

adi_if_infer_bus analog.com:interface:if_ethernet_ptp slave ethernet_ptp_rx [list \
  "ptp_clk     eth_rx_ptp_clk" \
  "ptp_rst     eth_rx_ptp_rst" \
  "ptp_ts      eth_rx_ptp_ts" \
  "ptp_ts_step eth_rx_ptp_ts_step" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp slave axis_tx_ptp [list \
  "ts    axis_eth_tx_ptp_ts" \
  "tag   axis_eth_tx_ptp_ts_tag" \
  "valid axis_eth_tx_ptp_ts_valid" \
  "ready axis_eth_tx_ptp_ts_ready" \
]

adi_if_infer_bus analog.com:interface:if_qspi master qspi0 [list \
  "dq_i  qspi_0_dq_i" \
  "dq_o  qspi_0_dq_o" \
  "dq_oe qspi_0_dq_oe" \
  "cs    qspi_0_cs" \
]

adi_if_infer_bus analog.com:interface:if_qspi master qspi1 [list \
  "dq_i  qspi_1_dq_i" \
  "dq_o  qspi_1_dq_o" \
  "dq_oe qspi_1_dq_oe" \
  "cs    qspi_1_cs" \
]

adi_if_infer_bus analog.com:interface:if_qsfp master qsfp [list \
  "tx_p        qsfp_tx_p" \
  "tx_n        qsfp_tx_n" \
  "rx_p        qsfp_rx_p" \
  "rx_n        qsfp_rx_n" \
  "modsell     qsfp_modsell" \
  "resetl      qsfp_resetl" \
  "modprsl     qsfp_modprsl" \
  "intl        qsfp_intl" \
  "lpmode      qsfp_lpmode" \
  "gtpowergood qsfp_gtpowergood" \
]

adi_if_infer_bus analog.com:interface:if_i2c master i2c [list \
  "scl_i i2c_scl_i" \
  "scl_o i2c_scl_o" \
  "scl_t i2c_scl_t" \
  "sda_i i2c_sda_i" \
  "sda_o i2c_sda_o" \
  "sda_t i2c_sda_t" \
]

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
