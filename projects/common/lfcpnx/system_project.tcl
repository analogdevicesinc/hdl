###############################################################################
## Copyright (C) 2023-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

## default options for adi_project ############################################
## if the -dev_select "manual" then the -device, -speed and -board options can
## be set manually.
# adi_project $project_name \
#   -dev_select "auto" \
#   -ppath "./$project_name" \
#   -device "" \
#   -speed "" \
#   -board "" \
#   -synthesis "synplify" \
#   -impl "impl_1" \
#   -cmd_list ""

## default options for adi_project_files_auto #################################
# adi_project_files_auto $project_name \
#   -exts {*.ipx} \
#   -spath ./$project_name/project_name/lib \
#   -ppath "./$project_name" \
#   -sdepth "6" \
#   -opt_args ""
## use case 0 #################################################################
# adi_project_files_auto $project_name \
#   -exts [list *.ipx $project_name.v] \
#   -spath ./ \
#   -ppath "./$project_name" \
#   -sdepth "9" \
#   -opt_args "<opt args for prj_add_source Radiant tcl command>"

## options for adi_project_files ##############################################
# adi_project_files $project_name \
#   -ppath "./$project_name" \
#   -flist [list system_top.v \
#     ./lfcpnx_system_constr.pdc \
#     "$ad_hdl_dir/library/common/ad_iobuf.v"]
#   -opt_args "<opt args for prj_add_source Radiant tcl command>"

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
#   -ppath ./$project_name \
#   -mode "export" \
#   -impl "impl_1" \
#   -top "system_top" \
#   -cmd_list ""

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice.tcl

# Creates the Radiant project with default configurations.
# The device parameters are extracted by matching part of the project name.
adi_project template_lfcpnx

# Adds the generated file dependencies by Propel Builder to the Radiant project.
adi_project_files_default template_lfcpnx

# Adds the other not generated file dependencies to Radiant project.
adi_project_files template_lfcpnx -flist [list \
  system_top.v \
  lfcpnx_system_constr.pdc]

adi_project_run template_lfcpnx \
  -cmd_list { \
    {prj_clean_impl -impl $impl} \
    {prj_set_strategy_value -strategy Strategy1 bit_ip_eval=True} \
    {prj_set_strategy_value -strategy Strategy1 par_place_iterator_start_pt=1} \
    {prj_set_strategy_value -strategy Strategy1 par_place_iterator=0} \
    {prj_set_strategy_value -strategy Strategy1 par_save_best_result=1} \
    {prj_set_strategy_value -strategy Strategy1 syn_frequency=} \
  }
