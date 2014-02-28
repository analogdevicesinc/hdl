# ip

source ../scripts/adi_ip.tcl

adi_ip_create axi_hdmi_tx
adi_ip_files axi_hdmi_tx [list \
  "../common/ad_mem.v" \
  "../common/ad_rst.v" \
  "../common/ad_csc_1_mul.v" \
  "../common/ad_csc_1_add.v" \
  "../common/ad_csc_1.v" \
  "../common/ad_csc_RGB2CrYCb.v" \
  "../common/ad_ss_444to422.v" \
  "../common/up_axi.v" \
  "../common/up_xfer_cntrl.v" \
  "../common/up_xfer_status.v" \
  "../common/up_clock_mon.v" \
  "../common/up_hdmi_tx.v" \
  "axi_hdmi_tx_vdma.v" \
  "axi_hdmi_tx_core.v" \
  "axi_hdmi_tx.v" ]

adi_ip_properties axi_hdmi_tx

ipx::save_core [ipx::current_core]

