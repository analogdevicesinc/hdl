# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_jesd_gt
adi_ip_files axi_jesd_gt [list \
  "$ad_hdl_dir/library/common/ad_gt_common_1.v" \
  "$ad_hdl_dir/library/common/ad_gt_channel_1.v" \
  "$ad_hdl_dir/library/common/ad_gt_es.v" \
  "$ad_hdl_dir/library/common/ad_jesd_align.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_gt.v" \
  "axi_jesd_gt.v" \
  "axi_jesd_gt_constr.xdc" ]

adi_ip_properties axi_jesd_gt

adi_ip_constraints axi_jesd_gt [list \
  "axi_jesd_gt_constr.xdc" ]

set_property value m_axi:s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces axi_signal_clock \
  -of_objects [ipx::current_core]]]

set_property value axi_aresetn [ipx::get_bus_parameters ASSOCIATED_RESET \
  -of_objects [ipx::get_bus_interfaces axi_signal_clock \
  -of_objects [ipx::current_core]]]

ipx::save_core [ipx::current_core]

