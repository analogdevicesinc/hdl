# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_hil
adi_ip_files axi_hil [list \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/util_cdc/sync_data.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "axi_hil_constr.ttcl" \
  "axi_hil_regmap.v" \
  "axi_hil.v"]

adi_ip_properties axi_hil
adi_ip_ttcl axi_hil "axi_hil_constr.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_hil} [ipx::current_core]

set cc [ipx::current_core]

ipx::save_core $cc
