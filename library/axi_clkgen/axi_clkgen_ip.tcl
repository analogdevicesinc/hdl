# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_clkgen
adi_ip_files axi_clkgen [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_mmcm_drp.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_clkgen.v" \
  "axi_clkgen_constr.xdc" \
  "axi_clkgen.v" ]

adi_ip_properties axi_clkgen

adi_ip_constraints axi_clkgen [list \
  "axi_clkgen_constr.xdc" ]

set_property physical_name {s_axi_aclk} [ipx::get_port_map CLK \
  [ipx::get_bus_interface s_axi_signal_clock [ipx::current_core]]]

ipx::remove_bus_interface {signal_clock} [ipx::current_core]

ipx::save_core [ipx::current_core]


