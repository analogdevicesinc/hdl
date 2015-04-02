# load script

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set project_name imageon_zed

adi_project_create $project_name

adi_project_files $project_name [list "system_top.v" \
                                      "$ad_hdl_dir/library/common/ad_iobuf.v" \
                                      "system_constr.xdc" \
                                      "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

set_property PROCESSING_ORDER EARLY [get_files $ad_hdl_dir/projects/common/zed/zed_system_constr.xdc]
set_property PROCESSING_ORDER EARLY [get_files system_constr.xdc]

adi_project_run $project_name

