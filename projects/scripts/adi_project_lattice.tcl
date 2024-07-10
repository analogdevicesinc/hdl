###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
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
# * adi_project_files_auto - Adds files to the project automatically.
# * adi_project_files - Adds a manually defined list of files to the project.
# * get_file_list - Searches for files or file extensions in a specified
#     directory, returns a list of file paths.
# * adopt_path - No use case yet.
# * adi_project_run - Runs the Radiant project with specified option.
#                   - Optionally runs a list of tcl commands before running the
#     project.
# * adi_project_run_cmd - Opens the Radinat project and runs a list of tcl
#     commands given as parameter.
###############################################################################

###############################################################################
## Extracts the device parameters from project name.
## Calls the adi_project_create procedure with specified parameters.
## There is option to pass the Device parameters manually, and an options
## to pass a list of tcl commands to be executed after creating the project in
## adi_project_create procedure.
#
# \opt[dev_select] -dev_select "auto"
# \opt[ppath] -ppath ./
# \opt[device] -device "LFCPNX-100-9LFG672C"
# \opt[speed] -speed "9_High-Performance_1.0V"
# \opt[board] -board "Certus Pro NX Evaluation Board"
# \opt[synthesis] -synthesis "synplify"
# \opt[impl] -impl "impl_1"
# \opt[cmd_list] -cmd_list {{source ./csacsi.tcl} {source ./a_szamar.tcl}}
###############################################################################
proc adi_project {project_name args} {
  puts "\nadi_project:\n"

  array set opt [list -dev_select "auto" \
    -ppath "./_bld/$project_name" \
    -device "" \
    -speed "" \
    -board "" \
    -synthesis "synplify" \
    -impl "impl_1" \
    -cmd_list "" {*}$args]

  set dev_select $opt(-dev_select)
  set ppath $opt(-ppath)
  set synthesis $opt(-synthesis)
  set impl $opt(-impl)
  set cmd_list $opt(-cmd_list)

  global ad_hdl_dir

  if { [string match "auto" $dev_select] } {
    source $ad_hdl_dir/projects/scripts/adi_lattice_dev_select.tcl
  } elseif { [string match "manual" $dev_select] } {
    set device $opt(-device)
    set board $opt(-board)
    set speed $opt(-speed)
  }

  adi_project_create $project_name \
    -ppath $ppath \
    -device $device \
    -performance $speed \
    -board $board \
    -synthesis $synthesis \
    -impl $impl \
    -cmd_list $cmd_list
}

###############################################################################
## Creates a Radiant project with specified parameters.
## There is an option to run a list of tcl commands given as parameter after
## creating the Radiant design.
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

  array set opt [list -ppath "./_bld/$project_name" \
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
  global required_lattice_version
  global IGNORE_VERSION_CHECK
  global env

  puts "\nProject name:   $project_name"
  puts "Device:   $device"
  puts "Performance:  $performance"
  puts "Board:  $board\n"

  ## Extracting the Radiant version using sys_install_version command from
  ## propel builder.
  set RADIANT_VERSION [string range [sys_install_version] 0 \
    [expr {[string first "." [sys_install_version]] + 1}]]
  puts "Radiant version: $RADIANT_VERSION\n"

  if {$IGNORE_VERSION_CHECK} {
    if {[string compare $RADIANT_VERSION $required_lattice_version] != 0} {
      puts -nonewline "CRITICAL WARNING: Radiant version mismatch; "
      puts -nonewline "expected $required_lattice_version, "
      puts -nonewline "got $RADIANT_VERSION.\n"
    }
  } else {
    if {[string compare $RADIANT_VERSION $required_lattice_version] != 0} {
      puts -nonewline "ERROR: Radiant version mismatch; "
      puts -nonewline "expected $required_lattice_version, "
      puts -nonewline "got $RADIANT_VERSION.\n"
      puts -nonewline "This ERROR message can be down-graded to CRITICAL \
        WARNING by setting ADI_IGNORE_VERSION_CHECK environment variable to 1. \
        Be aware that ADI will not support you, if you are using a different \
        tool version.\n"
      exit 2
    }
  }

  set dir [pwd]

  if {[file exists $ppath] != 1} {
    file mkdir $ppath
  }
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
  cd $dir

  foreach cmd $cmd_list {
    puts "Executing cmd: $cmd"
    eval $cmd
  }

  prj_save
  prj_close

  cd $dir
}

###############################################################################
## Adds files to the specified project by searching them in the specyfied
## '-spath' folder '-sdepth' deep.
## You can use with normalized paths, or with paths relative to the Radiant
## project file .rdf for spath (search path).
## The ppath (project path) must be a folder that contains the .rdf project
## file max 3 directory deep.
#
# \opt[exts] -exts {csacsi.v a_szamar.v *.ipx}
# \opt[spath] -spath ./$project_name/$project_name/lib
# \opt[ppath] -ppath ./$project_name
# \opt[sdepth] -sdepth 7
# \opt[opt_args] -opt_args {<opt args for prj_add_source Radiant tcl command>}
###############################################################################
proc adi_project_files_auto {project_name args} {
  puts "\nadi_project_files_auto:\n"

  array set opt [list -exts {*.ipx} \
    -spath ./_bld/$project_name/$project_name/lib \
    -ppath "./_bld/$project_name" \
    -sdepth "6" \
    -opt_args "" \
    {*}$args]

  set exts $opt(-exts)
  set spath $opt(-spath)
  set ppath $opt(-ppath)
  set sdepth $opt(-sdepth)
  set opt_args $opt(-opt_args)

  puts "args:\n"
  puts "Project path: $ppath"
  puts "Extentions: $exts"
  puts "Search path: $spath"
  puts "search depth: $sdepth"
  puts "Optional arguments: $opt_args\n"

  # Searching for the Radiant project file.
  set sbx_lsit [get_file_list $ppath *${project_name}.rdf 3]
  set radiant_project [lindex $sbx_lsit 0]

  # setting the current directory
  set dir [pwd]

  if { [file exists $radiant_project] == 1} {
    set project_dir [string map [list /${project_name}.rdf ""] $radiant_project]
    puts "\n------Adding files to $radiant_project project.------\n"

    # When I open the Radiant project, this tool enters the directory
    # where the Radiant .rdf project file is.
    # So, if we add files with relative path, then the path must be relative
    # to this file.
    prj_open $radiant_project
    cd $dir

    set flist [get_file_list $spath $exts $sdepth]
    if {$flist != ""} {
      puts "\n------List of files to be added:------ \n"
      foreach file $flist {
        puts $file
      }
    } else {
      puts {No files to be added.}
    }
  } else {
    puts "Project does not exist."
    exit 2
  }

  puts "\n"

  foreach pfile $flist {
    puts "Trying to add $pfile to the $radiant_project project"

    # In Lattice Radiant there can be only one active .sdc (Pre-Synthesis
    # Constraint File) and one active .pdc (Post-Synthesis Constraint File).
    # Generating a single system_constr.sdc and a single system_constr.pdc
    # from multiple .sdc and .pdc constraint files.
    if {[regexp {^.+\.pdc$} $pfile]} {
      add_update_constraint_file $pfile $project_dir pdc $radiant_project $opt_args
    } elseif {[regexp {^.+\.sdc$} $pfile]} {
      add_update_constraint_file $pfile $project_dir sdc $radiant_project $opt_args
    } else {
      if { [catch {prj_add_source $opt_args $pfile} fid] } {
        puts "$pfile already added to $radiant_project project!"
      }
    }
  }

  prj_save
  prj_close

  # changing directory back, because Radiant enters the project directory
  # and lets it like that so if we use relative paths somewhere in scripts
  # it would affect our code.
  cd $dir
}

###############################################################################
## Adds files to the specified project.
## The ppath (project path) must be a folder that contains the .rdf project
## file max 3 directory deep.
#
# \opt[ppath] -ppath ./$project_name
# \opt[flist] -flist {./csacsi.v ./a_szamar.v}
# \opt[opt_args] -opt_args {<opt args for prj_add_source Radiant tcl command>}
###############################################################################
proc adi_project_files {project_name args} {
  puts "\nadi_project_files:\n"

  array set opt [list -ppath "./_bld/$project_name" \
    -flist "" \
    -opt_args "" \
    {*}$args]

  set ppath $opt(-ppath)
  set flist $opt(-flist)
  set opt_args $opt(-opt_args)

  # Searching for the Radiant project file.
  set sbx_lsit [get_file_list $ppath *${project_name}.rdf 3]
  set radiant_project [lindex $sbx_lsit 0]

  # setting the current directory
  set dir [pwd]

  if { [file exists $radiant_project] == 1} {
    set project_dir [string map [list /${project_name}.rdf ""] $radiant_project]
    puts "\n------Adding files to $radiant_project project.------\n"

    # When I open the Radiant project, this tool enters the directory
    # where the Radiant .rdf project file is.
    # So, if we add files with relative path, then the path must be relative
    # to this file.
    prj_open $radiant_project
    cd $dir

    if {$flist != ""} {
      puts "\n------List of manually defined files to be added:------ \n"
      foreach file $flist {
        puts $file
      }
    } else {
      puts {No manually defined files to be added.}
    }
  } else {
    puts "Project does not exist."
    exit 2
  }

  puts "\n"

  foreach pfile $flist {
    puts "Trying to add $pfile to the $radiant_project project"

    # In Lattice Radiant there can be only one active .sdc (Pre-Synthesis
    # Constraint File) and one active .pdc (Post-Synthesis Constraint File).
    # Generating a single system_constr.sdc and a single system_constr.pdc
    # from multiple .sdc and .pdc constraint files.
    if {[regexp {^.+\.pdc$} $pfile]} {
      add_update_constraint_file $pfile $project_dir pdc $radiant_project $opt_args
    } elseif {[regexp {^.+\.sdc$} $pfile]} {
      add_update_constraint_file $pfile $project_dir sdc $radiant_project $opt_args
    } else {
      if { [catch {prj_add_source $opt_args $pfile} fid] } {
        puts "$pfile already added to $radiant_project project!"
      }
    }
  }

  prj_save
  prj_close

  # changing directory back, because Radiant enters the project directory
  # and lets it like that so if we use relative paths somewhere in scripts
  # it would affect our code.
  cd $dir
}

proc add_update_constraint_file {pfile project_dir ext radiant_project opt_args} {
      puts "Adding $pfile to $project_dir/system_constr.$ext"
      set file [open $pfile]
      set data [read $file]
      close $file

      set file_out [open "$project_dir/system_constr.$ext" a]
      puts $file_out "\n# $pfile\n\n$data"
      close $file_out

      if { [catch {prj_add_source $opt_args $project_dir/system_constr.$ext} fid] } {
        puts "$project_dir/system_constr.$ext already added to $radiant_project project!"
      }
}

# Adds the default project files to the Radiant project ($project_name.rdf)
proc adi_project_files_default {project_name} {
  adi_project_files_auto $project_name -exts {*.ipx} \
    -spath "./_bld/$project_name/$project_name/lib" \
    -ppath "./_bld/$project_name" \
    -sdepth "6"
  adi_project_files $project_name \
    -flist [list ./_bld/$project_name/$project_name/$project_name.v]
}

###############################################################################
## Returns a list of files in a given path searching recursively.
#
# \param[path] - the base directory
# \param[extension_list] - the list of extension files, for example:
#                                                              {*.v *.tcl *.xdc}
# \param[depth] - the depth of recursive search
# \return - file_list
#
# The return path depends on what path you use as input.
# For example you can use like:
#                                    get_file_list [file normalize ./] {*.ipx} 7
#   to get the list of .ipx files from the current directory 7 directories deep
#   with normalized paths or you can use with relative paths like:
#                                                     get_file_list ./ {*.ipx} 7
###############################################################################
proc get_file_list {path {extension_list {*.ipx}} {depth 5}} {
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

###############################################################################
## Returns a list of file paths and replaces the base_to_cut part
## at start of file paths with base_to_add.
#
# \param[full_path_flist] - list of file paths
# \param[base_to_cut] - the start of file paths to cut
# \param[base_to_add] - the start of file paths to add
###############################################################################
proc adopt_path {full_path_flist base_to_cut {base_to_add ""}} {
  set bpath_length [string length $base_to_cut]
  set flist {}

  foreach file $full_path_flist {
    set flist [list {*}$flist \
      $base_to_add[string range $file [expr {$bpath_length + 1}] end]]
  }

  return $flist
}

###############################################################################
## Runs the Radiant project with the defined options.
## Optionally runs a list of commands before running the design in specified
## in specified mode.
## Searches for the .rdf project 3 directories deep from -ppath (project path).
#
# \opt[ppath] -ppath ./$project_name
# \opt[mode] -mode synth
# \opt[impl] -impl "impl_1"
# \opt[top] -top "system_top"
# \opt[cmd_list] -cmd_list {{source csacsi.tcl} {source a_szamar.tcl}}
###############################################################################
proc adi_project_run {project_name args} {
  puts "\nadi_project_run:\n"

  array set opt [list -ppath "./_bld/$project_name" \
    -mode "export" \
    -impl "impl_1" \
    -top "system_top" \
    -cmd_list "" \
    {*}$args]

  set ppath $opt(-ppath)
  set mode $opt(-mode)
  set impl $opt(-impl)
  set top $opt(-top)
  set cmd_list $opt(-cmd_list)

  set sbx_lsit [get_file_list $ppath *${project_name}.rdf 3]
  set radiant_project [lindex $sbx_lsit 0]

  set dir [pwd]

  if {[file exists $radiant_project] == 1} {
    prj_open $radiant_project
    cd $dir
  } else {
    puts "\nProject does not exist.\n"
    exit 2
  }

  prj_set_impl_opt -impl $impl "include path" "."
  prj_set_impl_opt -impl $impl "top" $top

  foreach cmd $cmd_list {
    puts "Executing cmd: $cmd"
    eval $cmd
  }

  if {[string match "export" $mode]} {
    puts "\nRun Export design.\n"
    prj_run Export -impl $impl
  } elseif {[string match "synth" $mode]} {
    puts "\nRun Synthesis design.\n"
    prj_run Synthesis -impl $impl
  } elseif {[string match "map" $mode]} {
    puts "\nRun Map design.\n"
    prj_run Map -impl $impl
  } elseif {[string match "par" $mode]} {
    puts "\nRun PAR design.\n"
    prj_run PAR -impl $impl
  } else {
    puts "\nRun Export design.\n"
    prj_run Export -impl $impl
  }

  prj_save
  prj_close

  cd $dir
}

###############################################################################
## Opens the Radiant project and runs a list of commands given as option
## saves and closes the project.
## Searches for the .rdf project 3 directories deep from -ppath (project path).
#
# \opt[ppath] -ppath ./$project_name
# \opt[cmd_list] -cmd_list {{source csacsi.tcl} {source a_szamar.tcl}}
###############################################################################
proc adi_project_run_cmd {project_name args} {
  puts "\nadi_project_run_cmd:\n"
  set dir [pwd]

  array set opt [list -ppath "./_bld/$project_name" -cmd_list "" {*}$args]
  set ppath $opt(-ppath)
  set cmd_list $opt(-cmd_list)

  set sbx_lsit [get_file_list $ppath *${project_name}.rdf 3]
  set radiant_project [lindex $sbx_lsit 0]

  if { [file exists $radiant_project] == 1} {
    prj_open $radiant_project
    cd $dir
  } else {
    puts "\nProject does not exist.\n"
    exit 2
  }

  foreach cmd $cmd_list {
    puts "Executing cmd: $cmd"
    eval $cmd
  }

  prj_save
  prj_close

  cd $dir
}
