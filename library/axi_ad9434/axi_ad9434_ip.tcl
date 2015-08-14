# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_ad9434
adi_ip_files axi_ad9434 [list \
  "$ad_hdl_dir/library/common/ad_serdes_clk.v" \
  "$ad_hdl_dir/library/common/ad_mmcm_drp.v" \
  "$ad_hdl_dir/library/common/ad_serdes_in.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_ad9434_if.v" \
  "axi_ad9434_pnmon.v" \
  "axi_ad9434_core.v" \
  "axi_ad9434_constr.xdc" \
  "axi_ad9434.v" ]

adi_ip_properties axi_ad9434

adi_ip_constraints axi_ad9434 [list \
  "axi_ad9434_constr.xdc" ]

ipx::save_core [ipx::current_core]

