
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device "xc7z020clg400-1"
adi_project_create pzsdr1_ccusb_lvds
adi_project_files pzsdr1_ccusb_lvds [list \
  "system_top.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "../common/pzsdr1_constr.xdc" \
  "../common/pzsdr1_constr_lvds.xdc" \
  "../common/ccusb_constr.xdc" ]

set_property PROCESSING_ORDER EARLY [get_files ../common/pzsdr1_constr.xdc]
set_property PROCESSING_ORDER LATE [get_files ../common/ccusb_constr.xdc]

adi_project_run pzsdr1_ccusb_lvds


