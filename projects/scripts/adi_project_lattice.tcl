###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

###############################################################################
# This file contains the following procedures for Lattice Radiant projects:
# * adi_project - Sets the device settings based on project_name or manually
#     by options.
#               - Calls the adi_project_create procedure
#               - Optionally you can add a list of tcl commands to be executed
#     in adi_project_create after creating the project.
# * adi_project_create - Creates the Radiant project itself and executes some
#     optional commands that are piped trough adi_project procedure.
# * adi_project_files - Adds a list of files to the project automatically
#     or manually.
# * get_file_list - Searches for files or file extentions in a specified
#     directory, returns a list of file paths.
# * adopt_path - No use case yet.
# * adi_project_run - Runs the Radiant project with specified option.
#                   - Optionally runs a list of tcl commands before running the
#     the project.
# * adi_project_run_cmd - Opens the radinat project and runs a list of tcl
#     commands given as parameter.
###############################################################################

###############################################################################
## Extracts the device parameters from project name.
## Calls the adi_project_create procedure with specified parameters.
## There is option to pass the Device parameters manually, and an options
## to pass a list of tcl commands to be executed after creating the project in
## adi_project_create procedure.
#
# \opt[ppath] -ppath ./
# \opt[device] -device "LFCPNX-100-9LFG672C"
# \opt[performance] -performance "9_High-Performance_1.0V"
# \opt[board] -board "Certus Pro NX Evaluation Board"
# \opt[synthesis] -synthesis "synplify"
# \opt[impl] -impl "impl_1"
# \opt[cmd_list] -cmd_list {{source ./csacsi.tcl} {source ./a_szamar.tcl}}
###############################################################################
proc adi_project {project_name args} {
  puts "\nadi_project:\n"

  array set opt [list -ppath "./$project_name" \
    -device "" \
    -performance "" \
    -board "" \
    -synthesis "synplify" \
    -impl "impl_1" \
    -cmd_list "" {*}$args]

  set ppath $opt(-ppath)
  set device $opt(-device)
  set performance $opt(-performance)
  set board $opt(-board)
  set synthesis $opt(-synthesis)
  set impl $opt(-impl)
  set cmd_list $opt(-cmd_list)

  # Determine the device based on the board name
  if [regexp "_ctpnxe" $project_name] {
    set device "LFCPNX-100-9LFG672C"
    set performance "9_High-Performance_1.0V"
    set board "Certus Pro NX Evaluation Board"
  }

  adi_project_create $project_name \
    -ppath $ppath \
    -device $device \
    -performance $performance \
    -board $board \
    -synthesis $synthesis \
    -impl $impl \
    -cmd_list $cmd_list
}

###############################################################################
## Creates a Radiant project with specified parameters.
## There is an option to run a list of tcl commands given as parameter after
## creating the radiant design.
#
# \opt[ppath] -ppath ./
# \opt[device] -device "LFCPNX-100-9LFG672C"
# \opt[performance] -performance "9_High-Performance_1.0V"
# \opt[board] -board "Certus Pro NX Evaluation Board"
# \opt[synthesis] -synthesis "synplify"
# \opt[impl] -impl "impl_1"
# \opt[cmd_list] -cmd_list {{source ./csacsi.tcl} {source ./a_szamar.tcl}}
###############################################################################
proc adi_project_create {project_name args}  {
  puts "\nadi_project_create:\n"

  array set opt [list -ppath "./$project_name" \
    -device "" \
    -performance "" \
    -board "" \
    -synthesis "synplify" \
    -impl "impl_1" \
    -cmd_list "" {*}$args]

  set ppath $opt(-ppath)
  set device $opt(-device)
  set performance $opt(-performance)
  set board $opt(-board)
  set synthesis $opt(-synthesis)
  set impl $opt(-impl)
  set cmd_list $opt(-cmd_list)

  global ad_hdl_dir
  global ad_ghdl_dir
  global ad_project_dir
  global required_radiant_version
  global IGNORE_VERSION_CHECK
  global env

  puts "\nProject name:   $project_name"
  puts "Device:   $device"
  puts "Performance:  $performance"
  puts "Board:  $board\n"

  ## Extracting the radiant version using sys_install_version command from
  ## propel builder.
  # set RADIANT_VERSION [string range [sys_install_version] \
  #  0 [expr {[string first "." [sys_install_version]] + 1}]]

  # Extracting the radiant version from TOOLRTF env variable.
  # It is the path for the used radiant version witch includes the version.
  if {[regexp {.*(\d{4}\.\d{1})} $env(TOOLRTF) str match]} {
    set RADIANT_VERSION $match
    puts "Radiant version: $RADIANT_VERSION\n"
  } else {
    puts "Wrong path! Cannot extract Radiant tool version!"
  }

  if {$IGNORE_VERSION_CHECK} {
    if {[string compare $RADIANT_VERSION $required_radiant_version] != 0} {
      puts -nonewline "CRITICAL WARNING: Radiant version mismatch; "
      puts -nonewline "expected $required_radiant_version, "
      puts -nonewline "got $RADIANT_VERSION.\n"
    }
  } else {
    if {[string compare $RADIANT_VERSION $required_radiant_version] != 0} {
      puts -nonewline "ERROR: Radiant version mismatch; "
      puts -nonewline "expected $required_radiant_version, "
      puts -nonewline "got $RADIANT_VERSION.\n"
      puts -nonewline "This ERROR message can be down-graded to CRITICAL \
        WARNING by setting ADI_IGNORE_VERSION_CHECK environment variable to 1. \
        Be aware that ADI will not support you, if you are using a different \
        tool version.\n"
      exit 2
    }
  }

  set dir [pwd]
  cd $ppath

  if { [file exists $project_name.rdf] == 1} {
    prj_open $project_name.rdf
    prj_set_device -part $device -performance $performance
  } else {
    prj_create -name "$project_name" \
      -impl $impl \
      -dev $device \
      -performance $performance \
      -synthesis $synthesis
  }

  foreach cmd $cmd_list {
    puts "Executing cmd: $cmd"
    eval $cmd
  }

  prj_save
  prj_close

  cd $dir
}
