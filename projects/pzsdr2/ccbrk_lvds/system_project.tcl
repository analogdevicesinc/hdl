
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device "xc7z035ifbg676-2L"
adi_project_create pzsdr2_ccbrk_lvds
adi_project_files pzsdr2_ccbrk_lvds [list \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "../common/pzsdr2_constr.xdc" \
  "../common/pzsdr2_constr_lvds.xdc" \
  "../common/ccbrk_constr.xdc" \
  "system_top.v" ]

set_property is_enabled false [get_files  *axi_gpreg_constr.xdc]
adi_project_run pzsdr2_ccbrk_lvds


