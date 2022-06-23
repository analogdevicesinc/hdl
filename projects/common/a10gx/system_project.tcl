source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl
source $ad_hdl_dir/projects/common/a10gx/a10gx_system_assign.tcl

adi_project a10gx

execute_flow -compile
