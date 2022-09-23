source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project adrv9001_zc706 0 [list \
  CMOS_LVDS_N 1 \
]

adi_project_files adrv9001_zc706 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "cmos_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

set_property PROCESSING_ORDER LATE [get_files system_constr.xdc]

adi_project_run adrv9001_zc706

