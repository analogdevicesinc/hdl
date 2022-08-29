source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_assign.tcl

adi_project template_a10soc

execute_flow -compile
