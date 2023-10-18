###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## default options for adi_project ############################################
## if the project name does not match any board definitions, device parameters 
## can be added by options manually.
# adi_project $project_name \
#   -ppath "./$project_name" \
#   -device "" \
#   -performance "" \
#   -board "" \
#   -synthesis "synplify" \
#   -impl "impl_1" \
#   -cmd_list ""

## default options for adi_project_files ######################################
# adi_project_files $project_name \
#   -usage "auto" \
#   -exts {*.ipx} \
#   -spath ./$project_name/lib \
#   -ppath "." \
#   -sdepth "6" \
#   -flist ""
## use case 0 #################################################################
# adi_project_files $project_name \
#   -usage "auto" \
#   -exts {*.v *.pdc *.sdc *.mem} \
#   -spath ../ \
#   -ppath "." \
#   -sdepth "0" \
#   -flist ""
## use case 1 #################################################################
# adi_project_files $project_name \
#   -usage "manual" \
#   -exts "" \
#   -spath "" \
#   -ppath "." \
#   -sdepth "" \
#   -flist [list ./$project_name/$project_name.v]

## default options for adi_project_run_cmd ####################################
# adi_project_run_cmd $project_name \
#   -ppath "./$project_name" \
#   -cmd_list ""
# example commands ############################################################
# adi_project_run_cmd $project_name -ppath ./$project_name \
#   -cmd_list { \
#     {prj_clean_impl -impl $impl} \
#     {prj_set_impl_opt -impl $impl "include path" "."} \
#     {prj_set_impl_opt -impl $impl "top" $top} \
#     {prj_set_strategy_value -strategy Strategy1 bit_ip_eval=True} \
#     {prj_set_strategy_value -strategy Strategy1 syn_force_gsr=False} \
#     {prj_set_strategy_value -strategy Strategy1 map_infer_gsr=False} \
#     {prj_set_strategy_value -strategy Strategy1 par_place_iterator=10} \
#     {prj_set_strategy_value -strategy Strategy1 par_stop_zero=True} \
#   }

## default options for adi_project_run ########################################
# adi_project_run $project_name \
#   -ppath ./ \
#   -mode "export" \
#   -impl "impl_1" \
#   -top "system_top" \
#   -cmd_list ""

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice.tcl

# getting the projects name that is defined in Makefile like PROJECT_NAME
if {$argc == 1} {
  set project_name [lindex $argv 0]
}

# Creates the Radiant project with default configurations. 
# the device parameters are extracted by matching part of the project name.
adi_project $project_name

# Adds the default project files to the Radiant project.
adi_project_files_default $project_name

adi_project_run $project_name \
  -cmd_list { \
    {prj_clean_impl -impl $impl} \
    {prj_set_strategy_value -strategy Strategy1 bit_ip_eval=True}
  }
