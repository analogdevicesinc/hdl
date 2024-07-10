###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

###############################################################################
# This file contains the following procedures for Lattice Propel Builder
# projects:
# * adi_project_pb - Sets the device settings based on project_name or manually
#     by options.
#               - Calls the adi_project_create_pb procedure
#               - Optionally you can add a list of tcl commands to be executed
#     in adi_project_create_pb after creating the project.
# * adi_project_create_pb - Creates the Propel Builder project itself and
#     executes some optional commands that are piped trough adi_project_pb
#     procedure.
# * adi_ip_instance - Creates a Propel Builder ip config file and adds the
#     specified ip to the opened project with that configuration.
# * adi_ip_update - Updates a specified ip with new configurations and optional
#     new name.
###############################################################################

###############################################################################
## Extracts the device parameters from project name.
## Calls the adi_project_create_pb procedure with specified parameters.
## There is option to pass the Device parameters manually, and an option
## to pass a list of tcl commands to be executed after creating the project in
## adi_project_create_pb procedure.
#
# \opt[dev_select] -dev_select "auto"
# \opt[ppath] -ppath .
# \opt[device] -device "LFCPNX-100-9LFG672C"
# \opt[speed] -speed "9_High-Performance_1.0V"
# \opt[board] -board "Certus Pro NX Evaluation Board"
# \opt[language] -language "verilog"
# \opt[cmd_list] -cmd_list {{source ./system_pb.tcl}}
# \opt[psc] -psc "${env(TOOLRTF)}/../../templates/MachXO3D_Template01/MachXO3D_Template01.psc"
###############################################################################
proc adi_project_pb {project_name args} {
  puts "\nadi_project_pb:\n"

  global env
  set preinst_ip_mod_dir ${env(TOOLRTF)}

  array set opt [list -dev_select "auto" \
    -ppath "." \
    -device "" \
    -board "" \
    -speed "" \
    -language "verilog" \
    -psc "" \
    -cmd_list {{source ./system_pb.tcl}} \
    {*}$args]

  set dev_select $opt(-dev_select)
  set ppath $opt(-ppath)
  set language $opt(-language)
  set cmd_list $opt(-cmd_list)
  set psc $opt(-psc)

  global ad_hdl_dir

  if { [string match "auto" $dev_select] } {
    source $ad_hdl_dir/projects/scripts/adi_lattice_dev_select.tcl
  } elseif { [string match "manual" $dev_select] } {
    set device $opt(-device)
    set board $opt(-board)
    set speed $opt(-speed)
  }

  adi_project_create_pb $project_name \
    -ppath $ppath \
    -device $device \
    -board $board \
    -speed $speed \
    -language $language \
    -psc $psc \
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
# \opt[cmd_list] -cmd_list {{source ./system_pb.tcl}}
###############################################################################
proc adi_project_create_pb {project_name args} {
  puts "\nadi_project_create_pb:\n"

  array set opt [list -ppath "." \
    -device "" \
    -board "" \
    -speed "" \
    -language "verilog" \
    -psc "" \
    -cmd_list "" \
    {*}$args]

  set ppath $opt(-ppath)
  set device $opt(-device)
  set board $opt(-board)
  set speed $opt(-speed)
  set language $opt(-language)
  set psc $opt(-psc)
  set cmd_list $opt(-cmd_list)

  global ad_hdl_dir
  global ad_ghdl_dir
  global ad_project_dir
  global required_lattice_version
  global IGNORE_VERSION_CHECK
  global env

  # Extracting the Propel Builder version from $env(TOOLRTF)/../../components.xml
  set regex "<Name>com\.latticesemi\.systembuilder.*<Version>$required_lattice_version"
  set file [open "$env(TOOLRTF)/../../components.xml"]
  set data [read $file]
  close $file

  if {[regexp $regex $data match]} {
      regexp <Version>$required_lattice_version $match data
      set version [lindex [split $data ">"] 1]
      set PROPEL_BUILDER_VERSION $version
      puts "Propel Builder version: $PROPEL_BUILDER_VERSION\n"
  } else {
      set PROPEL_BUILDER_VERSION "UNKNOWN"
      puts "Propel Builder version: $PROPEL_BUILDER_VERSION\n"
  }

  if {$IGNORE_VERSION_CHECK} {
    if {[string compare $PROPEL_BUILDER_VERSION $required_lattice_version] != 0} {
      puts -nonewline "CRITICAL WARNING: Propel Builder version mismatch; "
      puts -nonewline "expected $required_lattice_version, "
      puts -nonewline "got $PROPEL_BUILDER_VERSION.\n"
    }
  } else {
    if {[string compare $PROPEL_BUILDER_VERSION $required_lattice_version] != 0} {
      puts -nonewline "ERROR: Propel Builder version mismatch; "
      puts -nonewline "expected $required_lattice_version, "
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
  set propel_builder_project_dir "$ppath/$project_name/$project_name"

  if {$psc == ""} {
    file mkdir $propel_builder_project_dir

  # Creating the necessary .socproject file for being able to open the Radiant
  # and Propel SDK from Propel Builder if needed.
    set file [open "$ppath/$project_name/.socproject" w]
    puts $file [format {<?xml version="1.0" encoding="UTF-8"?>
<propelProject>
  <builder-resource>
    <socProject sbxfile="./%s/%s.sbx"/>
  </builder-resource>
</propelProject>} $project_name $project_name]
    close $file

    sbp_design new -name $project_name \
      -path $propel_builder_project_dir/$project_name.sbx \
      -device $device  \
      -speed $speed \
      -language $language \
      -board $board
  } else {
    sbp_create_project  -name "$project_name" \
      -path $ppath \
      -device $device \
      -speed $speed \
      -language $language \
      -psc $psc

      foreach port [sbp_get_ports *] {
        sbp_delete $port -type port
      }
  }

  sbp_design save

  foreach cmd $cmd_list {
    puts "Executing cmd: $cmd"
    sbp_design save
    eval $cmd
  }

# Workaround for keeping the configured IP folders in Propel Builder 2023.2
# command line version.
# The 'sbp_design save' doesn't saves the temporary .lib folder to lib folder,
# instead deletes if there is anything in lib folder.
# I am copying the content of .lib (the configured IP cores) to lib after save
# to keep the configured IP cores for the Radiant project.
# Also generating the bsp after copying the configured IP cores to lib folder
# because that's also based on the content of lib folder.
#
# Update: - If the psc default template file exists then the save works fine
# and we do not need to generate the bsp separately also.
  sbp_design save
  sbp_design generate

  if {$psc == ""} {
    set files [glob -directory $propel_builder_project_dir/.lib *]
    foreach file $files {
        set fname [file tail $file]
        set dest_p [file join $propel_builder_project_dir/lib $fname]
        file copy -force $file $dest_p
    }
  }

  # Generating the bsp.
  sbp_design pge sge \
    -i "$propel_builder_project_dir/$project_name.sbx" \
    -o "$ppath/$project_name"

  sbp_design close
}

###############################################################################
## Creates a Propel Builder ip config file and configures the specified ip.
## Project must be open.
#
# \opt[cfg_path] -cfg_path "./ipcfg"
# \opt[vlnv] -vlnv {latticesemi.com:ip:cpu0:2.4.0}
# \opt[ip_path] -ip_path "$ip_download_path/latticesemi.com_ip_riscv_mc_2.4.0"
# \opt[meta_vlnv] -meta_vlnv {latticesemi.com:ip:riscv_mc:2.4.0}
# \opt[ip_params] -ip_params {"SIMULATION": false, "DEBUG_ENABLE": true}
# \opt[cfg_value] -cfg_value {SIMULATION: false, DEBUG_ENABLE: true}
# \opt[ip_iname] -ip_iname cpu0_inst
###############################################################################
proc adi_ip_config {args} {
  array set opt [list -cfg_path "./ipcfg" \
    -vlnv "" \
    -ip_path "" \
    -meta_vlnv "" \
    -ip_params "" \
    -ip_iname "" \
    -cfg_value "" \
    {*}$args]

  set cfg_path $opt(-cfg_path)
  set vlnv $opt(-vlnv)
  set ip_path $opt(-ip_path)
  set ip_params $opt(-ip_params)
  set ip_iname $opt(-ip_iname)
  set meta_vlnv $opt(-meta_vlnv)
  set cfg_value $opt(-cfg_value)

  puts "adi_ip_config: $ip_iname"

  if {$cfg_value != ""} {
    if {$meta_vlnv != ""} {
      sbp_config_ip -vlnv $vlnv \
      -meta_vlnv $meta_vlnv \
      -cfg_value $cfg_value
    }
    if {$ip_path != ""} {
      sbp_config_ip -vlnv $vlnv \
      -meta_loc $ip_path \
      -cfg_value $cfg_value
    }
  } else {
    if {[file exists $cfg_path] != 1} {
      file mkdir $cfg_path
    }

    set file [open "$cfg_path/$ip_iname.cfg" w]
    puts $file [format {{%s}} $ip_params]
    close $file

    if {$meta_vlnv != ""} {
      sbp_config_ip -vlnv $vlnv \
      -meta_vlnv $meta_vlnv \
      -cfg "$cfg_path/$ip_iname.cfg"
    }
    if {$ip_path != ""} {
      sbp_config_ip -vlnv $vlnv \
      -meta_loc $ip_path \
      -cfg "$cfg_path/$ip_iname.cfg"
    }
  }
}

###############################################################################
## Creates a Propel Builder ip config file and adds the specified ip to the
## opened project with that configuration.
## Project must be open.
#
# \opt[cfg_path] -cfg_path "./ipcfg"
# \opt[vlnv] -vlnv {latticesemi.com:ip:cpu0:2.4.0}
# \opt[ip_path] -ip_path "$ip_download_path/latticesemi.com_ip_riscv_mc_2.4.0"
# \opt[meta_vlnv] -meta_vlnv {latticesemi.com:ip:riscv_mc:2.4.0}
# \opt[ip_params] -ip_params {"SIMULATION": false, "DEBUG_ENABLE": true}
# \opt[cfg_value] -cfg_value {SIMULATION: false, DEBUG_ENABLE: true}
# \opt[ip_iname] -ip_iname cpu0_inst
###############################################################################
proc adi_ip_instance {args} {
  array set opt [list -cfg_path "./ipcfg" \
    -vlnv "" \
    -ip_path "" \
    -meta_vlnv "" \
    -ip_params "" \
    -ip_iname "" \
    -cfg_value "" \
    {*}$args]

  set vlnv $opt(-vlnv)
  set ip_iname $opt(-ip_iname)

  puts "adi_ip_instance: $ip_iname"

  adi_ip_config {*}$args

  sbp_add_component -vlnv $vlnv -name $ip_iname
}

###############################################################################
## Updates a Propel Builder ip.
## Project must be open.
#
# \opt[cfg_path] -cfg_path "./ipcfg"
# \opt[vlnv] -vlnv {latticesemi.com:ip:cpu0:2.4.0}
# \opt[ip_path] -ip_path "$ip_download_path/latticesemi.com_ip_riscv_mc_2.4.0"
# \opt[meta_vlnv] -meta_vlnv {latticesemi.com:ip:riscv_mc:2.4.0}
# \opt[ip_params] -ip_params {"SIMULATION": false, "DEBUG_ENABLE": true}
# \opt[cfg_value] -cfg_value {SIMULATION: false, DEBUG_ENABLE: true}
# \opt[ip_iname] -ip_iname cpu0_inst
# \opt[ip_niname] -ip_niname new_name_inst
###############################################################################
proc adi_ip_update {project_name args} {
  array set opt [list -cfg_path "./ipcfg" \
    -vlnv "" \
    -ip_path "" \
    -meta_vlnv "" \
    -ip_params "" \
    -ip_iname "" \
    -ip_niname "" \
    -cfg_value "" \
    {*}$args]

  set vlnv $opt(-vlnv)
  set ip_iname $opt(-ip_iname)
  set ip_niname $opt(-ip_niname)

  puts "adi_ip_update: $ip_iname"

  adi_ip_config {*}$args

  if {$ip_niname == ""} {
    sbp_replace -vlnv $vlnv -name $ip_iname -component $project_name/$ip_iname
  } else {
    sbp_replace -vlnv $vlnv -name $ip_niname -component $project_name/$ip_iname
  }
}
