source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl
source $ad_hdl_dir/projects/common/c5soc/c5soc_system_assign.tcl

adi_project c5soc

execute_flow -compile
