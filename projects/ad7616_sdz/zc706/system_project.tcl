
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

##--------------------------------------------------------------
# IMPORTANT: Set AD7616 operation and interface mode
#
#    ad7616_opm - Defines the operation mode (software OR hardware)
#    ad7616_if  - Defines the interface type (serial OR parallel)
#
# LEGEND: Software  - 0
#         Hardware  - 1
#         Serial    - 0
#         Parallel  - 1
#
# NOTE : These switches are 'hardware' switches. User needs to
# reimplement the design each and every time, after these variables
# were changed.
#
##--------------------------------------------------------------

set ad7616_if   0
set ad7616_opm  0

adi_project_create ad7616_sdz_zc706

if { $ad7616_if == 0 } {

  adi_project_files ad7616_sdz_zc706 [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "serial_if_constr.xdc" \
    "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

} elseif { $ad7616_if == 1 } {

  adi_project_files ad7616_sdz_zc706 [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "parallel_if_constr.xdc" \
    "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

} else {

  return -code error [format "ERROR: Invalid interface type! Define as \'serial\' or \'parallel\' ..."]

}

adi_project_run ad7616_sdz_zc706

