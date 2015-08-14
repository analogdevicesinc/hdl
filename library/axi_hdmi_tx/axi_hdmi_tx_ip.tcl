# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_hdmi_tx
adi_ip_files axi_hdmi_tx [list \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_csc_1_mul.v" \
  "$ad_hdl_dir/library/common/ad_csc_1_add.v" \
  "$ad_hdl_dir/library/common/ad_csc_1.v" \
  "$ad_hdl_dir/library/common/ad_csc_RGB2CrYCb.v" \
  "$ad_hdl_dir/library/common/ad_ss_444to422.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_hdmi_tx.v" \
  "axi_hdmi_tx_vdma.v" \
  "axi_hdmi_tx_es.v" \
  "axi_hdmi_tx_core.v" \
  "axi_hdmi_tx.v" \
  "axi_hdmi_tx_constr.xdc" ]

adi_ip_properties axi_hdmi_tx

adi_ip_constraints axi_hdmi_tx [list \
  "axi_hdmi_tx_constr.xdc" ]

ipx::save_core [ipx::current_core]

