source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl

adi_project template_ac701
adi_project_files template_ac701 [list \
  "$ad_hdl_dir/projects/common/ac701/ac701_system_constr.xdc" \
  "system_constr.xdc"\
  "system_top.v" ]
  
adi_project_run template_ac701
