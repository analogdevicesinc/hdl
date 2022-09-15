source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project template_a10gx

source $ad_hdl_dir/projects/common/a10gx/a10gx_system_assign.tcl

execute_flow -compile
