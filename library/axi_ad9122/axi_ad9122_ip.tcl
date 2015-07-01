# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_ad9122
adi_ip_files axi_ad9122 [list \
  "$ad_hdl_dir/library/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_mmcm_drp.v" \
  "$ad_hdl_dir/library/common/ad_serdes_out.v" \
  "$ad_hdl_dir/library/common/ad_serdes_clk.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "axi_ad9122_channel.v" \
  "axi_ad9122_core.v" \
  "axi_ad9122_if.v" \
  "axi_ad9122_constr.xdc" \
  "axi_ad9122.v" ]

adi_ip_properties axi_ad9122

adi_ip_constraints axi_ad9122 [list \
  "axi_ad9122_constr.xdc" ]

ipx::save_core [ipx::current_core]

