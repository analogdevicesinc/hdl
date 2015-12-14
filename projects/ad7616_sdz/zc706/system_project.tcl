
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set ad7616_interface "serial"
#set ad7616_interface "parallel"

adi_project_create ad7616_sdz_zc706

if { $ad7616_interface eq "serial" } {

  adi_project_files ad7616_sdz_zc706 [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "serial_if_constr.xdc" \
    "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

} elseif { $ad7616_interface eq "parallel" } {

  adi_project_files ad7616_sdz_zc706 [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "parallel_if_constr.xdc" \
    "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

} else {

  return -code error [format "ERROR: Invalid interface type! Define as \'serial\' or \'parallel\' ..."]

}

adi_project_run ad7616_sdz_zc706

