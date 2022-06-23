source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project template_s10soc

source $ad_hdl_dir/projects/common/s10soc/s10soc_system_assign.tcl

execute_flow -compile
