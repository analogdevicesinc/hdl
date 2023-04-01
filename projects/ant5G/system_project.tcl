
source ../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device "xc7z020clg400-2"
adi_project ant5G

adi_project_files ant5G [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

set_property is_enabled false [get_files  *system_sys_ps7_0.xdc]
adi_project_run ant5G
source $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl

