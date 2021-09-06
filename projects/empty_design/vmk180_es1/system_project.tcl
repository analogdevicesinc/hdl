
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project emply_design_vmk180_es1

adi_project_files emply_design_vmk180_es1 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "timing_constr.xdc"\
  "$ad_hdl_dir/projects/common/vmk180_es1/vmk180_es1_system_constr.xdc" ]


adi_project_run emply_design_vmk180_es1

