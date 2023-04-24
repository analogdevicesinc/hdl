source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project template_fm87

source $ad_hdl_dir/projects/common/fm87/fm87_system_assign.tcl

execute_flow -compile