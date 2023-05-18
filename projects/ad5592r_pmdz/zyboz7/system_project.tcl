source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad5592r_zyboz7

adi_project_files ad5592r_zyboz7 [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/projects/common/zyboz7/zyboz7_system_constr.xdc" \
    "system_constr.xdc" \
    "system_top.v" \
]

adi_project_run ad5592r_zyboz7
