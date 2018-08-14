
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

##--------------------------------------------------------------
# IMPORTANT: Set AD7616 operation and interface mode
#
#    ad7616_if  - Defines the interface type (serial OR parallel)
#
# LEGEND: Serial    - 0
#         Parallel  - 1
#
# NOTE : This switch is a 'hardware' switch. Please reimplenent the
# design if the variable has been changed.
#
##--------------------------------------------------------------

set ad7616_if   0

adi_project ad7616_sdz_zc706

if { $ad7616_if == 0 } {

  adi_project_files ad7616_sdz_zc706 [list \
    "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
    "system_top_si.v" \
    "serial_if_constr.xdc" \
    "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

} elseif { $ad7616_if == 1 } {

  adi_project_files ad7616_sdz_zc706 [list \
    "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
    "system_top_pi.v" \
    "parallel_if_constr.xdc" \
    "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

} else {

  return -code error [format "ERROR: Invalid interface type! Define as \'serial\' or \'parallel\' ..."]

}

adi_project_run ad7616_sdz_zc706

