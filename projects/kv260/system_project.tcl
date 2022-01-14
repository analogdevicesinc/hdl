
source ../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

## adi_project_create params: project_name, mode (0(default)-proj mode / 1-non-proj), param list
adi_project kv260

## adi_project_files params: project_name, list of files to be added in project
adi_project_files kv260 [list "system_top.v" "system_constr.xdc"]

##adi_project_run params: project_name
adi_project_run kv260

