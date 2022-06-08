
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project adv7513_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

# files
set_global_assignment -name VERILOG_FILE ../../../library/common/ad_iobuf.v

execute_flow -compile
