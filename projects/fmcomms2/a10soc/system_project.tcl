
load_package flow

source ../../scripts/adi_env.tcl
project_new fmcomms2_a10soc -overwrite

source "../../common/a10soc/a10soc_system_assign.tcl"

set_global_assignment -name QSYS_FILE system_bd.qsys
set_global_assignment -name VERILOG_FILE system_top.v
set_global_assignment -name SDC_FILE system_constr.sdc
set_global_assignment -name TOP_LEVEL_ENTITY system_top

execute_flow -compile

