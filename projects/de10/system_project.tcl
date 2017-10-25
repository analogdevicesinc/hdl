
source ../scripts/adi_env.tcl
source ../scripts/adi_project_alt.tcl

adi_project_altera generic_de10

source $ad_hdl_dir/projects/common/de10/de10_system_assign.tcl
execute_flow -compile

