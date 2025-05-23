###############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
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
  global ad_hdl_dir
  set preinst_ip_mod_dir ${env(TOOLRTF)}

  array set opt [list -dev_select "auto" \
    -ppath "./_bld" \
    -device "" \
    -board "" \
    -speed "" \
    -language "verilog" \
    -psc "${env(TOOLRTF)}/../../templates/MachXO3D_Template01/MachXO3D_Template01.psc" \
    -cmd_list {{source ./system_pb.tcl}} \
    -interface_paths "$ad_hdl_dir/library/interfaces_ltt" \
    {*}$args]

  set dev_select $opt(-dev_select)
  set ppath [file normalize $opt(-ppath)]
  set language $opt(-language)
  set cmd_list $opt(-cmd_list)
  set psc $opt(-psc)
  set interface_paths $opt(-interface_paths)

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

  global ad_hdl_dir
  global required_lattice_version
  global IGNORE_VERSION_CHECK
  global env

  array set opt [list -ppath "./_bld" \
    -device "" \
    -board "" \
    -speed "" \
    -language "verilog" \
    -psc "" \
    -cmd_list "" \
    -interface_paths "$ad_hdl_dir/library/interfaces_ltt" \
    {*}$args]

  set ppath [file normalize $opt(-ppath)]
  set device $opt(-device)
  set board $opt(-board)
  set speed $opt(-speed)
  set language $opt(-language)
  set psc $opt(-psc)
  set cmd_list $opt(-cmd_list)
  set interface_paths $opt(-interface_paths)

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

  if {[file exists $ppath] != 1} {
    file mkdir $ppath
  }

  sbp_create_project  -name "$project_name" \
    -path $ppath \
    -device $device \
    -speed $speed \
    -language $language \
    -psc $psc

  foreach port [sbp_get_ports *] {
    sbp_delete $port -type port
  }

  sbp_design save

  if {$interface_paths != ""} {
    foreach interface_path $interface_paths {
      set env(LATTICE_INTERFACE_SEARCH_PATH) \
        "$env(LATTICE_INTERFACE_SEARCH_PATH);$interface_path"
    }
  }

  foreach cmd $cmd_list {
    puts "Executing cmd: $cmd"
    sbp_design save
    eval $cmd
  }

  sbp_design save
  sbp_design generate

  # Generating the bsp.
  sbp_design pge sge \
    -i "$propel_builder_project_dir/$project_name.sbx" \
    -o "$ppath/$project_name"

  set file [open _bld/pb_design_finished.log "w"]
  puts $file "Design generated."
  close $file

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
set adi_move_ip_to_project "false"
proc adi_ip_config {args} {
  global adi_move_ip_to_project
  array set opt [list -cfg_path "./ipcfg" \
    -vlnv "" \
    -ip_path "" \
    -meta_vlnv "" \
    -ip_params "" \
    -ip_iname "" \
    -cfg_value "" \
    -move_to_project "$adi_move_ip_to_project" \
    {*}$args]

  set cfg_path $opt(-cfg_path)
  set vlnv $opt(-vlnv)
  set ip_path $opt(-ip_path)
  set ip_params $opt(-ip_params)
  set ip_iname $opt(-ip_iname)
  set meta_vlnv $opt(-meta_vlnv)
  set cfg_value $opt(-cfg_value)
  set move_to_project $opt(-move_to_project)
  set checked 0

  puts "adi_ip_config: $ip_iname"

  if {$ip_path == "" && $meta_vlnv == ""} {
    puts "ERROR: no -meta_vlnv nor -ip_path is specified!"
    exit 2
  }

  if {[info exists ::env(LATTICE_EXTERNAL_LIBS)] && \
    $::env(LATTICE_EXTERNAL_LIBS) != ""} {

    if {$meta_vlnv != ""} {
      global external_lattice_ip_folder_map

      # Mapping IPs from external directories.
      if {$external_lattice_ip_folder_map == {}} {
        global tcl_platform
        if {$tcl_platform(platform) eq "windows"} {
          puts "WARNING: Please make shure you export a valid Windows paths in 'LATTICE_EXTERNAL_LIBS' env variable!"
        }
        set external_lattice_ip_folder_map {}
        set paths [string map [list \\ /] $::env(LATTICE_EXTERNAL_LIBS)]
        foreach path $paths {
          set external_lattice_ip_folder_map \
            [dict merge $external_lattice_ip_folder_map \
            [map_lattice_ips $path 5]]
        }
        puts $external_lattice_ip_folder_map
      }
      if {[dict keys $external_lattice_ip_folder_map $meta_vlnv] != ""} {
        puts "INSTANTIATING from '$::env(LATTICE_EXTERNAL_LIBS)' directories."
        # Setting IP path for instantiation.
        set ip_path [dict get $external_lattice_ip_folder_map $meta_vlnv]

        if {$move_to_project == "true"} {
          set folder_name [string map [list ":" "_"] $meta_vlnv]
          set ddir [file normalize [lindex [get_dir_list ./ /lib 8] 0]]/IPs
          if {[file exists $ddir/$folder_name] != 1} {
            file mkdir $ddir/$folder_name
            file copy -force {*}[glob -nocomplain -directory $ip_path *] \
              $ddir/$folder_name
            puts "COPYING from $ip_path to $ddir/$folder_name paths."
          } else {
            puts "The '$ddir/$folder_name' directory already exists! (1)"
          }
        }
        set checked 1
        set meta_vlnv {}
      }
    }
  }

  if {(![info exists ::env(LATTICE_DEFAULT_PATHS)] || \
    $::env(LATTICE_DEFAULT_PATHS) != 1) && $checked != 1} {

    if {$meta_vlnv != ""} {
      global hdl_lattice_ip_folder_map
      global ad_hdl_dir
      set lib_dir $ad_hdl_dir/library

      # Mapping IPs from local repo.
      if {$hdl_lattice_ip_folder_map == {}} {
        set hdl_lattice_ip_folder_map [map_lattice_ips $lib_dir 8]
        puts $hdl_lattice_ip_folder_map
      }

      if {[dict keys $hdl_lattice_ip_folder_map $meta_vlnv] != ""} {
        puts "INSTANTIATING from '$ad_hdl_dir/library'."

        # Setting IP path for instantiation.
        set ip_path [dict get $hdl_lattice_ip_folder_map $meta_vlnv]

        if {$move_to_project == "true"} {
          set folder_name [string map [list ":" "_"] $meta_vlnv]
          set ddir [file normalize [lindex [get_dir_list ./ /lib 8] 0]]/IPs
          if {[file exists $ddir/$folder_name] != 1} {
            file mkdir $ddir/$folder_name
            file copy -force {*}[glob -nocomplain -directory $ip_path *] \
              $ddir/$folder_name
            puts "COPYING from $ip_path to $ddir/$folder_name paths."
          } else {
            puts "The '$ddir/$folder_name' directory already exists! (2)"
          }
        }
        set checked 1

        # Clearing meta_vlnv because ip_path is set which will be used instead.
        set meta_vlnv {}
      }
    }
  }

  # Copying installed IPs to the project.
  if {[info exists ::env(LATTICE_DEFAULT_PATHS)] && \
    $::env(LATTICE_DEFAULT_PATHS) == 1 && \
    $checked != 1 && $move_to_project == "true" && \
    $meta_vlnv != ""} {

    set splt [split $meta_vlnv ":"]
    set vendor [lindex $splt 0]

    global lattice_local_ip_folder_map
    global env
    global tcl_platform

    # Mapping installed IPs.
    if {$lattice_local_ip_folder_map == {}} {
      if {[info exists env(TOOLRTF)]} {
        set lattice_local_ip_folder_map [map_lattice_ips $env(TOOLRTF)/ip 8]
      }
      if {$tcl_platform(platform) eq "windows"} {
        if {[info exists env(HOMEDRIVE)] && [info exists env(HOMEPATH)]} {
          set home $env(HOMEDRIVE)[string map [list \\ /] $env(HOMEPATH)]
          set lattice_local_ip_folder_map \
            [dict merge $lattice_local_ip_folder_map \
            [map_lattice_ips $home/PropelIPLocal 3]]
        }
      } else {
        if {[info exists env(HOME)]} {
          set lattice_local_ip_folder_map \
            [dict merge $lattice_local_ip_folder_map \
            [map_lattice_ips $env(HOME)/PropelIPLocal 3]]
        }
      }
      puts $lattice_local_ip_folder_map
    }

    # Copying IPs if they exist in map.
    if {[dict keys $lattice_local_ip_folder_map $meta_vlnv] != ""} {
      set ddir [file normalize [lindex [get_dir_list ./ /lib 8] 0]]/IPs
      set src_path [dict get $lattice_local_ip_folder_map $meta_vlnv]
      set folder_name [string map [list ":" "_"] $meta_vlnv]
      if {[file exists $ddir/$folder_name] != 1} {
        file mkdir $ddir/$folder_name
        file copy -force {*}[glob -nocomplain -directory $src_path *] \
          $ddir/$folder_name
        puts "COPYING from $src_path to $ddir/$folder_name paths."
      } else {
        puts "The '$ddir/$folder_name' directory already exists! (3)"
      }
    }
  }

  # Copying IPs instantiated using -ip_path.
  if {$checked != 1 && $move_to_project == "true" && $ip_path != ""} {
    set ddir [file normalize [lindex [get_dir_list ./ /lib 8] 0]]/IPs

    if {[set mt_vlnv [get_lattice_vlnv "$ip_path/metadata.xml"]] != {}} {
      set folder_name [string map [list ":" "_"] $mt_vlnv]
      if {[file exists $ddir/$folder_name] != 1} {
        file mkdir $ddir/$folder_name
        file copy -force {*}[glob -nocomplain -directory $ip_path *] \
          $ddir/$folder_name
        puts "COPYING from $ip_path to $ddir/$folder_name paths."
      } else {
        puts "The '$ddir/$folder_name' directory already exists! (4)"
      }
    }
  }

  # Trying to install the locally inexistent IPs from server.
  if {[info exists ::env(LATTICE_DEFAULT_PATHS)] && \
    $::env(LATTICE_DEFAULT_PATHS) == 1 && $checked != 1} {
    if {$meta_vlnv != ""} {
      set splt [split $meta_vlnv ":"]
      set vendor [lindex $splt 0]

      if {$vendor == "latticesemi.com"} {
        global lattice_local_ip_folder_map
        global env
        global tcl_platform
        if {$lattice_local_ip_folder_map == {}} {
          if {[info exists env(TOOLRTF)]} {
            set lattice_local_ip_folder_map [map_lattice_ips $env(TOOLRTF)/ip 8]
          }
          if {$tcl_platform(platform) eq "windows"} {
            if {[info exists env(HOMEDRIVE)] && [info exists env(HOMEPATH)]} {
              set home $env(HOMEDRIVE)[string map [list \\ /] $env(HOMEPATH)]
              set lattice_local_ip_folder_map \
                [dict merge $lattice_local_ip_folder_map \
                [map_lattice_ips $home/PropelIPLocal 3]]
            }
          } else {
            if {[info exists env(HOME)]} {
              set lattice_local_ip_folder_map \
                [dict merge $lattice_local_ip_folder_map \
                [map_lattice_ips $env(HOME)/PropelIPLocal 3]]
            }
          }
          puts $lattice_local_ip_folder_map
        }
        if {[dict keys $lattice_local_ip_folder_map $meta_vlnv] == ""} {
          ip_catalog_install -vlnv $meta_vlnv
        }
      }
    }
  }

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
    -project_name "" \
    -move_to_project "false" \
    {*}$args]

  set vlnv $opt(-vlnv)
  set ip_iname $opt(-ip_iname)

  puts "\nadi_ip_instance: $ip_iname\n"

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
    -move_to_project "false" \
    {*}$args]

  set vlnv $opt(-vlnv)
  set ip_iname $opt(-ip_iname)
  set ip_niname $opt(-ip_niname)

  puts "\nadi_ip_update: $ip_iname\n"

  adi_ip_config {*}$args

  if {$ip_niname == ""} {
    sbp_replace -vlnv $vlnv -name $ip_iname -component $project_name/$ip_iname
  } else {
    sbp_replace -vlnv $vlnv -name $ip_niname -component $project_name/$ip_iname
  }
}

proc get_file_list {path {extension_list {*.v}} {depth 0}} {
    set file_list {}
    foreach ext $extension_list {
        set file_list [list {*}$file_list \
        {*}[glob -nocomplain -type f -directory $path $ext]]
    }
    if {$depth > 0} {
        foreach dir [glob -nocomplain -type d -directory $path *] {
        set file_list [list {*}$file_list \
            {*}[get_file_list $dir $extension_list [expr {$depth-1}]]]
        }
    }
    return $file_list
}

proc get_dir_list {path {extension_list {*}} {depth 0}} {
    set dir_list {}
    foreach ext $extension_list {
        set dir_list [list {*}$dir_list \
        {*}[glob -nocomplain -type d -directory $path $ext]]
    }
    if {$depth > 0} {
        foreach dir [glob -nocomplain -type d -directory $path *] {
        set dir_list [list {*}$dir_list \
            {*}[get_dir_list $dir $extension_list [expr {$depth-1}]]]
        }
    }
    return $dir_list
}

set hdl_lattice_ip_folder_map {}
set lattice_local_ip_folder_map {}
set external_lattice_ip_folder_map {}
proc map_lattice_ips {path depth} {
  set ip_map {}
  set file_list [get_file_list $path {metadata.xml} $depth]
  foreach file $file_list {
    set file [file normalize $file]
    if {[set meta_vlnv [get_lattice_vlnv $file]] != {}} {
      dict set ip_map $meta_vlnv [file dirname $file]
    }
  }
  return $ip_map
}

proc get_lattice_vlnv {xml} {
  set regex ".*<lsccip:ip.*>.*<lsccip:general>.*<lsccip:vendor>(.+)</lsccip:vendor>.*<lsccip:library>(.+)</lsccip:library>.*<lsccip:name>(.+)</lsccip:name>.*<lsccip:version>(.+)</lsccip:version>.*</lsccip:general>"
  set file [open $xml]
  set data [read $file]
  close $file
  if {[regexp $regex $data -> vnd lib nm vrs]} {
    return $vnd:$lib:$nm:$vrs
  } else {
    return {}
  }
}
