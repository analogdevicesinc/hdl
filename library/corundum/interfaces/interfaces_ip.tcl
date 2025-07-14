###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

# Control register bus interface

adi_if_define if_ctrl_reg
adi_if_ports  output -1   ctrl_reg_wr_addr none    0
adi_if_ports  output -1   ctrl_reg_wr_data none    0
adi_if_ports  output -1   ctrl_reg_wr_strb none    0
adi_if_ports  output  1   ctrl_reg_wr_en   none    0
adi_if_ports  input   1   ctrl_reg_wr_wait none    0
adi_if_ports  input   1   ctrl_reg_wr_ack  none    0
adi_if_ports  output -1   ctrl_reg_rd_addr none    0
adi_if_ports  output  1   ctrl_reg_rd_en   none    0
adi_if_ports  input  -1   ctrl_reg_rd_data none    0
adi_if_ports  input   1   ctrl_reg_rd_wait none    0
adi_if_ports  input   1   ctrl_reg_rd_ack  none    0

adi_if_define if_ptp
adi_if_ports  output   1   ptp_td_sd            none    0
adi_if_ports  output   1   ptp_pps              none    0
adi_if_ports  output   1   ptp_pps_str          none    0
adi_if_ports  output   1   ptp_sync_locked      none    0
adi_if_ports  output  64   ptp_sync_ts_rel      none    0
adi_if_ports  output   1   ptp_sync_ts_rel_step none    0
adi_if_ports  output  97   ptp_sync_ts_tod      none    0
adi_if_ports  output   1   ptp_sync_ts_tod_step none    0
adi_if_ports  output   1   ptp_sync_pps         none    0
adi_if_ports  output   1   ptp_sync_pps_str     none    0
adi_if_ports  output  -1   ptp_perout_locked    none    0
adi_if_ports  output  -1   ptp_perout_error     none    0
adi_if_ports  output  -1   ptp_perout_pulse     none    0

adi_if_define if_flow_control_tx
adi_if_ports  output -1   tx_enable           none    0
adi_if_ports  input  -1   tx_status           none    0
adi_if_ports  output -1   tx_lfc_en           none    0
adi_if_ports  output -1   tx_lfc_req          none    0
adi_if_ports  output -1   tx_pfc_en           none    0
adi_if_ports  output -1   tx_pfc_req          none    0
adi_if_ports  input  -1   tx_fc_quanta_clk_en none    0

adi_if_define if_flow_control_rx
adi_if_ports  output -1   rx_enable           none    0
adi_if_ports  input  -1   rx_status           none    0
adi_if_ports  output -1   rx_lfc_en           none    0
adi_if_ports  input  -1   rx_lfc_req          none    0
adi_if_ports  output -1   rx_lfc_ack          none    0
adi_if_ports  output -1   rx_pfc_en           none    0
adi_if_ports  input  -1   rx_pfc_req          none    0
adi_if_ports  output -1   rx_pfc_ack          none    0
adi_if_ports  input  -1   rx_fc_quanta_clk_en none    0

adi_if_define if_ethernet_ptp
adi_if_ports  input  -1   ptp_clk     none    0
adi_if_ports  input  -1   ptp_rst     none    0
adi_if_ports  output -1   ptp_ts      none    0
adi_if_ports  output -1   ptp_ts_step none    0

adi_if_define if_axis_tx_ptp
adi_if_ports  input  -1   ts    none    0
adi_if_ports  input  -1   tag   none    0
adi_if_ports  input  -1   valid none    0
adi_if_ports  output -1   ready none    0

adi_if_define if_jtag
adi_if_ports  input   1   tdi none    0
adi_if_ports  output  1   tdo none    0
adi_if_ports  input   1   tms none    0
adi_if_ports  input   1   tck none    0

adi_if_define if_gpio
adi_if_ports  input  -1   gpio_in    none    0
adi_if_ports  output -1   gpio_out   none    0

adi_if_define if_qspi
adi_if_ports  input  3   dq_i  none    0
adi_if_ports  output 3   dq_o  none    0
adi_if_ports  output 3   dq_oe none    0
adi_if_ports  output 1   cs    none    0

adi_if_define if_qsfp
adi_if_ports  output -1   tx_p        none    0
adi_if_ports  output -1   tx_n        none    0
adi_if_ports  input  -1   rx_p        none    0
adi_if_ports  input  -1   rx_n        none    0
adi_if_ports  output -1   modsell     none    0
adi_if_ports  output -1   resetl      none    0
adi_if_ports  input  -1   modprsl     none    0
adi_if_ports  input  -1   intl        none    0
adi_if_ports  output -1   lpmode      none    0
adi_if_ports  output -1   gtpowergood none    0

adi_if_define if_sfp
adi_if_ports  output  1   tx_p         none    0
adi_if_ports  output  1   tx_n         none    0
adi_if_ports  input   1   rx_p         none    0
adi_if_ports  input   1   rx_n         none    0
adi_if_ports  input   1   mgt_refclk_p none    0
adi_if_ports  input   1   mgt_refclk_n none    0
adi_if_ports  output  1   tx_disable   none    0
adi_if_ports  input   1   tx_fault     none    0
adi_if_ports  input   1   rx_los       none    0
adi_if_ports  input   1   mod_abs      none    0

adi_if_define if_i2c
adi_if_ports  input   1   scl_i none    0
adi_if_ports  output  1   scl_o none    0
adi_if_ports  output  1   scl_t none    0
adi_if_ports  input   1   sda_i none    0
adi_if_ports  output  1   sda_o none    0
adi_if_ports  output  1   sda_t none    0

adi_if_define if_axis_dma_desc
adi_if_ports  output  -1   dma_addr none    0
adi_if_ports  output  -1   ram_sel  none    0
adi_if_ports  output  -1   ram_addr none    0
adi_if_ports  output  -1   imm      none    0
adi_if_ports  output   1   imm_en   none    0
adi_if_ports  output  -1   len      none    0
adi_if_ports  output  -1   tag      none    0
adi_if_ports  output   1   valid    none    0
adi_if_ports  input    1   ready    none    0

adi_if_define if_axis_dma_desc_status
adi_if_ports  output  -1   tag   none    0
adi_if_ports  output  -1   error none    0
adi_if_ports  output   1   valid none    0

adi_if_define if_dma_ram
adi_if_ports  input  -1   wr_cmd_sel    none    0
adi_if_ports  input  -1   wr_cmd_be     none    0
adi_if_ports  input  -1   wr_cmd_addr   none    0
adi_if_ports  input  -1   wr_cmd_data   none    0
adi_if_ports  input  -1   wr_cmd_valid  none    0
adi_if_ports  output -1   wr_cmd_ready  none    0
adi_if_ports  output -1   wr_done       none    0
adi_if_ports  input  -1   rd_cmd_sel    none    0
adi_if_ports  input  -1   rd_cmd_addr   none    0
adi_if_ports  input  -1   rd_cmd_valid  none    0
adi_if_ports  output -1   rd_cmd_ready  none    0
adi_if_ports  output -1   rd_resp_data  none    0
adi_if_ports  output -1   rd_resp_valid none    0
adi_if_ports  input  -1   rd_resp_ready none    0

adi_if_define if_axis_stat
adi_if_ports  output  -1   tdata  none    0
adi_if_ports  output  -1   tid    none    0
adi_if_ports  output   1   tvalid none    0
adi_if_ports  input    1   tready none    0
