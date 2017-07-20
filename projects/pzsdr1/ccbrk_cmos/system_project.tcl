
source ../../scripts/adi_env.tcl 
source $ad_hdl_dir/projects/scripts/adi_project.tcl 
source $ad_hdl_dir/projects/scripts/adi_board.tcl 

set p_device "xc7z020clg400-1"
adi_project_create pzsdr1_ccbrk_cmos
adi_project_files pzsdr1_ccbrk_cmos [list \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "../common/pzsdr1_constr.xdc" \
  "../common/pzsdr1_constr_cmos.xdc" \
  "../common/ccbrk_constr.xdc" \
  "system_top.v" ]

set_property is_enabled false [get_files  *axi_gpreg_constr.xdc]
adi_project_run pzsdr1_ccbrk_cmos


