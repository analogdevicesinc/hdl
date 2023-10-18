###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice.tcl

# getting the projects name that is defined in Makefile like PROJECT_NAME
if {$argc == 1} {
  set project_name [lindex $argv 0]
}

adi_project $project_name
  # example commands:
  # -cmd_list { \
  # {prj_clean_impl -impl "impl_1"} \
  # {prj_set_strategy_value -strategy Strategy1 bit_ip_eval=True}}

adi_project_files $project_name -ppath ./$project_name
adi_project_files $project_name -ppath ./$project_name \
  -spath ../ -exts {*.v *.pdc *.sdc *.mem} -sdepth 0
adi_project_files $project_name -ppath ./$project_name \
  -spath ./$project_name -exts [list $project_name.v] -sdepth 0
adi_project_files $project_name -ppath ./ -usage manual \
  -flist [list ./$project_name/$project_name.v]

# adi_project_run_cmd $project_name -ppath ./$project_name
  # example commands:
  # -cmd_list { \
  # {prj_clean_impl -impl $impl} \
  # {prj_set_impl_opt -impl $impl "include path" "."} \
  # {prj_set_impl_opt -impl $impl "top" $top} \
  # {prj_set_strategy_value -strategy Strategy1 bit_ip_eval=True} \
  # {prj_set_strategy_value -strategy Strategy1 syn_force_gsr=False} \
  # {prj_set_strategy_value -strategy Strategy1 map_infer_gsr=False} \
  # {prj_set_strategy_value -strategy Strategy1 par_place_iterator=10} \
  # {prj_set_strategy_value -strategy Strategy1 par_stop_zero=True} \
  # }

adi_project_run $project_name -ppath ./ -mode export \
  -top system_top -impl impl_1
  # you can clear the default commands by -cmd_list ""
  # default commands:
  # -cmd_list { \
  # {prj_clean_impl -impl $impl} \
  # {prj_set_strategy_value -strategy Strategy1 bit_ip_eval=True}}
