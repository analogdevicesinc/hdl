###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

###############################################################################
# This file contains the following procedures for Lattice Propel Builder
# projects:
# * adi_project_bd - Sets the device settings based on project_name or manually
#     by options.
#               - Calls the adi_project_create_bd procedure
#               - Optionally you can add a list of tcl commands to be executed
#     in adi_project_create_bd after creating the project.
# * adi_project_create_bd - Creates the Propel Builder project itself and
#     executes some optional commands that are piped trough adi_project_bd
#     procedure.
# * adi_ip_instance - Creates a Propel Builder ip config file and adds the
#     specified ip to the opened project with that configuration.
###############################################################################

###############################################################################
## Extracts the device parameters from project name.
## Calls the adi_project_create_bd procedure with specified parameters.
## There is option to pass the Device parameters manually, and an option
## to pass a list of tcl commands to be executed after creating the project in
## adi_project_create_bd procedure.
#
# \opt[dev_select] -dev_select "auto"
# \opt[ppath] -ppath .
# \opt[device] -device "LFCPNX-100-9LFG672C"
# \opt[speed] -speed "9_High-Performance_1.0V"
# \opt[board] -board "Certus Pro NX Evaluation Board"
# \opt[language] -language "verilog"
# \opt[cmd_list] -cmd_list {{source ./system_bd.tcl}}
###############################################################################
proc adi_project_bd {project_name args} {
  puts "\nadi_project_bd:\n"

  array set opt [list -dev_select "auto" \
    -ppath "." \
    -device "" \
    -board "" \
    -speed "" \
    -language "verilog" \
    -cmd_list {{source ./system_bd.tcl} \
      {sbp_design pge sge \
        -i "$ppath/$project_name/$project_name/$project_name.sbx" \
        -o "$ppath"}} \
    {*}$args]

  set dev_select $opt(-dev_select)
  set ppath $opt(-ppath)
  set language $opt(-language)
  set cmd_list $opt(-cmd_list)

  global ad_hdl_dir

  if { [string match "auto" $dev_select] } {
    source $ad_hdl_dir/projects/scripts/adi_lattice_dev_select.tcl
  } elseif { [string match "manual" $dev_select] } {
    set device $opt(-device)
    set board $opt(-board)
    set speed $opt(-speed)
  }

  adi_project_create_bd $project_name \
    -ppath $ppath \
    -device $device \
    -board $board \
    -speed $speed \
    -language $language \
    -cmd_list $cmd_list
}

###############################################################################
## Creates a Propel Builder project with specified parameters.
## There is an option to run a list of tcl commands given as parameter after
## creating the Propel Builder design.
#
# \opt[ppath] -ppath .
# \opt[device] -device "LFCPNX-100-9LFG672C"
# \opt[speed] -speed "9_High-Performance_1.0V"
# \opt[board] -board "Certus Pro NX Evaluation Board"
# \opt[language] -language "verilog"
# \opt[cmd_list] -cmd_list {{source ./system_bd.tcl}}
###############################################################################
proc adi_project_create_bd {project_name args} {
  puts "\nadi_project_create_bd:\n"

  array set opt [list -ppath "." \
    -device "" \
    -board "" \
    -speed "" \
    -language "verilog" \
    -cmd_list "" \
    {*}$args]

  set ppath $opt(-ppath)
  set device $opt(-device)
  set board $opt(-board)
  set speed $opt(-speed)
  set language $opt(-language)
  set cmd_list $opt(-cmd_list)

  global ad_hdl_dir
  global ad_ghdl_dir
  global ad_project_dir
  global required_propel_builder_version
  global IGNORE_VERSION_CHECK
  global env
  # global sys_cpu_type - for the feature

  # I have to check for cpu selection options.

  # Extracting the propel builder version from TOOLRTF env variable.
  # It is the path for lib components in propel builder.
  if {[regexp {.*(\d{4}\.\d{1})} $env(TOOLRTF) str match]} {
      set PROPEL_BUILDER_VERSION $match
      puts "Propel Builder version: $PROPEL_BUILDER_VERSION"
  } else {
      puts "Wrong path! Cannot extract Propel Builder tool version!"
  }

  if {$IGNORE_VERSION_CHECK} {
    if {[string compare $PROPEL_BUILDER_VERSION $required_propel_builder_version] != 0} {
      puts -nonewline "CRITICAL WARNING: Propel Builder version mismatch; "
      puts -nonewline "expected $required_propel_builder_version, "
      puts -nonewline "got $PROPEL_BUILDER_VERSION.\n"
    }
  } else {
    if {[string compare $PROPEL_BUILDER_VERSION $required_propel_builder_version] != 0} {
      puts -nonewline "ERROR: Propel Builder version mismatch; "
      puts -nonewline "expected $required_propel_builder_version, "
      puts -nonewline "got $PROPEL_BUILDER_VERSION.\n"
      puts -nonewline "This ERROR message can be down-graded to CRITICAL \
        WARNING by setting ADI_IGNORE_VERSION_CHECK environment variable to 1. \
        Be aware that ADI will not support you, if you are using a different \
        tool version.\n"
      exit 2
      error
    }
  }

  set preinst_ip_mod_dir ${env(TOOLRTF)}
  set ip_download_path ${env(USERPROFILE)}/PropelIPLocal
  set propel_builder_project_dir "$ppath/$project_name/$project_name"

  file mkdir $propel_builder_project_dir

  # Creating the necessary .socproject file for being able to open the Radiant
  # and Propel SDK from Propel builder if needed.
  set file [open "$ppath/$project_name/.socproject" w]
  puts $file [format {<?xml version="1.0" encoding="UTF-8"?>
<propelProject>
  <builder-resource>
    <socProject sbxfile="./%s/%s.sbx"/>
  </builder-resource>
</propelProject>} $project_name $project_name]
  close $file

  # I will think on library components later becouse those are still not
  # applicable due to no ip generation tcl option. I will solve it later.

  sbp_design new -name $project_name \
    -path $propel_builder_project_dir/$project_name.sbx \
    -device $device  \
    -speed $speed \
    -language $language \
    -board $board
  sbp_design save

  foreach cmd $cmd_list {
    puts "Executing cmd: $cmd"
    sbp_design save
    eval $cmd
  }

  sbp_design save
  sbp_design generate
  sbp_design close
}

###############################################################################
## Creates a Propel Builder ip config file and configures the specified ip.
## Project has to be open.
#
# \opt[cfg_path] -cfg_path "./ipcfg"
# \opt[vlnv] -vlnv {latticesemi.com:ip:cpu0:2.4.0}
# \opt[ip_path] -ip_path "$ip_download_path/latticesemi.com_ip_riscv_mc_2.4.0"
# \opt[ip_params] -ip_params {"SIMULATION": false, "DEBUG_ENABLE": true}
# \opt[ip_iname] -ip_iname cpu0_inst
###############################################################################
proc adi_ip_config {args} {
  array set opt [list -cfg_path "./ipcfg" \
    -vlnv "" \
    -ip_path "" \
    -ip_params "" \
    -ip_iname "" \
    {*}$args]

  set cfg_path $opt(-cfg_path)
  set vlnv $opt(-vlnv)
  set ip_path $opt(-ip_path)
  set ip_params $opt(-ip_params)
  set ip_iname $opt(-ip_iname)

  puts "adi_ip_config: $ip_iname"

  if {[file exists $cfg_path] != 1} {
    file mkdir $cfg_path
  }

  set file [open "$cfg_path/$ip_iname.cfg" w]
  puts $file [format {{%s}} $ip_params]
  close $file

  sbp_design config_ip -vlnv $vlnv \
    -meta_loc $ip_path \
    -cfg "$cfg_path/$ip_iname.cfg"
}

###############################################################################
## Creates a Propel Builder ip config file and adds the specified ip to the
## opened project with that configuration.
## Project has to be open.
#
# \opt[cfg_path] -cfg_path "./ipcfg"
# \opt[vlnv] -vlnv {latticesemi.com:ip:cpu0:2.4.0}
# \opt[ip_path] -ip_path "$ip_download_path/latticesemi.com_ip_riscv_mc_2.4.0"
# \opt[ip_params] -ip_params {"SIMULATION": false, "DEBUG_ENABLE": true}
# \opt[ip_iname] -ip_iname cpu0_inst
###############################################################################
proc adi_ip_instance {args} {
  array set opt [list -cfg_path "./ipcfg" \
    -vlnv "" \
    -ip_path "" \
    -ip_params "" \
    -ip_iname "" \
    {*}$args]

  set vlnv $opt(-vlnv)
  set ip_iname $opt(-ip_iname)

  puts "adi_ip_instance: $ip_iname"

  adi_ip_config {*}$args

  sbp_add_component -vlnv $vlnv -name $ip_iname
}