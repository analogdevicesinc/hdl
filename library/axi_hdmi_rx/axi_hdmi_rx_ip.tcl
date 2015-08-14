#ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_hdmi_rx
adi_ip_files axi_hdmi_rx [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_csc_1.v" \
  "$ad_hdl_dir/library/common/ad_csc_1_mul.v" \
  "$ad_hdl_dir/library/common/ad_csc_1_add.v" \
  "$ad_hdl_dir/library/common/ad_ss_422to444.v" \
  "$ad_hdl_dir/library/common/ad_csc_CrYCb2RGB.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_hdmi_rx.v" \
  "axi_hdmi_rx.v" \
  "axi_hdmi_rx_es.v" \
  "axi_hdmi_rx_tpm.v" \
  "axi_hdmi_rx_constr.xdc" \
  "axi_hdmi_rx_core.v" ]

adi_ip_properties axi_hdmi_rx
adi_ip_constraints axi_hdmi_rx [list \
  "axi_hdmi_rx_constr.xdc" ]

ipx::save_core [ipx::current_core]

