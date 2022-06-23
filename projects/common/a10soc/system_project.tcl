source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_assign.tcl

adi_project a10soc

# set optimization to get a better timing closure
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"

execute_flow -compile
