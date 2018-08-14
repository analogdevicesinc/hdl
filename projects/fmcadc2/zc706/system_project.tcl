
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project fmcadc2_zc706
adi_project_files fmcadc2_zc706 [list \
  "../common/fmcadc2_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/common/ad_sysref_gen.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_plddr3_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

adi_project_run fmcadc2_zc706

ad_ip_instance ila ila_core
ad_ip_parameter ila_core CONFIG.C_MONITOR_TYPE Native
ad_ip_parameter ila_core CONFIG.C_TRIGIN_EN false
ad_ip_parameter ila_core CONFIG.C_EN_STRG_QUAL 1
ad_ip_parameter ila_core CONFIG.C_NUM_OF_PROBES 4
ad_ip_parameter ila_core CONFIG.C_PROBE0_WIDTH 1
ad_ip_parameter ila_core CONFIG.C_PROBE1_WIDTH 1
ad_ip_parameter ila_core CONFIG.C_PROBE2_WIDTH 1
ad_ip_parameter ila_core CONFIG.C_PROBE3_WIDTH 256

ad_connect  axi_ad9625_core/adc_clk ila_core/clk
ad_connect  axi_ad9625_core/adc_rst ila_core/probe0
ad_connect  axi_ad9625_core/adc_valid ila_core/probe1
ad_connect  axi_ad9625_core/rx_ready ila_core/probe2
ad_connect  axi_ad9625_core/adc_data ila_core/probe3
