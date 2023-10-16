###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice.tcl

adi_project template_ctpnxe
  # example commands:
  # -cmd_list { \
  # {prj_clean_impl -impl "impl_1"} \
  # {prj_set_strategy_value -strategy Strategy1 bit_ip_eval=True}}

adi_project_files template_ctpnxe -ppath ./template_ctpnxe
adi_project_files template_ctpnxe -ppath ./template_ctpnxe \
  -spath ../ -exts {*.v *.pdc *.sdc *.mem} -sdepth 0
adi_project_files template_ctpnxe -ppath ./template_ctpnxe \
  -spath ./template_ctpnxe -exts {template_ctpnxe.v} -sdepth 0
adi_project_files template_ctpnxe -ppath ./ -usage manual \
  -flist {./template_ctpnxe/template_ctpnxe.v}

# adi_project_run_cmd template_ctpnxe -ppath ./template_ctpnxe
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

adi_project_run template_ctpnxe -ppath ./ -mode export \
  -top system_top -impl impl_1
  # you can clear the default commands by -cmd_list ""
  # default commands:
  # -cmd_list { \
  # {prj_clean_impl -impl $impl} \
  # {prj_set_strategy_value -strategy Strategy1 bit_ip_eval=True}}
