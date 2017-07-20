
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create fmcadc2_zc706
adi_project_files fmcadc2_zc706 [list \
  "../common/fmcadc2_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_lvds_out.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/common/ad_sysref_gen.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_mig_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

adi_project_run fmcadc2_zc706

set ila_core [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_core]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_core
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_core
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_core
set_property -dict [list CONFIG.C_NUM_OF_PROBES {4}] $ila_core
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_core
set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] $ila_core
set_property -dict [list CONFIG.C_PROBE2_WIDTH {1}] $ila_core
set_property -dict [list CONFIG.C_PROBE3_WIDTH {256}] $ila_core

ad_connect  axi_ad9625_core/adc_clk ila_core/clk
ad_connect  axi_ad9625_core/adc_rst ila_core/probe0
ad_connect  axi_ad9625_core/adc_valid ila_core/probe1
ad_connect  axi_ad9625_core/rx_ready ila_core/probe2
ad_connect  axi_ad9625_core/adc_data ila_core/probe3
