###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports spi_sdia]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports spi_sdib]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports spi_sdid]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list i_system_wrapper/system_i/sys_ps7/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 17 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[0]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[1]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[2]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[3]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[4]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[5]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[6]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[7]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[8]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[9]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[10]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[11]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[12]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[13]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[14]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[15]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/burst_count[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 17 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[0]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[1]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[2]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[3]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[4]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[5]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[6]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[7]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[8]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[9]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[10]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[11]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[12]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[13]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[14]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[15]} {i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_burst_count[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/eot]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list i_system_wrapper/system_i/axi_ad738x_dma/inst/i_transfer/i_request_arb/i_req_gen/req_valid]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list i_system_wrapper/system_i/spi_clkgen/inst/i_mmcm_drp/clk_0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 1 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cs[0]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 1 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/sdi[0]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 16 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[0]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[1]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[2]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[3]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[4]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[5]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[6]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[7]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[8]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[9]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[10]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[11]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[12]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[13]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[14]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/cmd_d1[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 32 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[0]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[1]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[2]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[3]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[4]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[5]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[6]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[7]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[8]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[9]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[10]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[11]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[12]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[13]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[14]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[15]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[16]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[17]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[18]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[19]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[20]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[21]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[22]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[23]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[24]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[25]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[26]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[27]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[28]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[29]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[30]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_data[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 16 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[0]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[1]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[2]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[3]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[4]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[5]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[6]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[7]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[8]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[9]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[10]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[11]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[12]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[13]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[14]} {i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd_ready]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 1 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/cmd_valid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe7]
set_property port_width 1 [get_debug_ports u_ila_1/probe7]
connect_debug_port u_ila_1/probe7 [get_nets [list i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_ready]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe8]
set_property port_width 1 [get_debug_ports u_ila_1/probe8]
connect_debug_port u_ila_1/probe8 [get_nets [list i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/offload_sdi_valid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe9]
set_property port_width 1 [get_debug_ports u_ila_1/probe9]
connect_debug_port u_ila_1/probe9 [get_nets [list i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/sclk]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe10]
set_property port_width 1 [get_debug_ports u_ila_1/probe10]
connect_debug_port u_ila_1/probe10 [get_nets [list i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_execution/inst/sdo]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe11]
set_property port_width 1 [get_debug_ports u_ila_1/probe11]
connect_debug_port u_ila_1/probe11 [get_nets [list i_system_wrapper/system_i/spi_ad738x_adc/spi_ad738x_adc_offload/inst/trigger]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_1_clk_0]
