###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

##############################################################################
## The folowing procedures are available:
##
## adi_make::lib <args>
##               -"all"(project libraries)
##               -"library name to build (plus path to it relative to library folder)
##                  e.g.: adi_make_lib xilinx/util_adxcvr
## adi_make::boot_bin - expected that u-boot*.elf (plus bl31.elf for zynq_mp)
##                     files are in the project folder"
## For more info please see: https://wiki.analog.com/resources/fpga/docs/build



namespace eval adi_make {
  ##############################################################################
  # to print debug step messages "set debug_msg=1" (set adi_make::debug_msg 1)
  variable debug_msg 0
  ##############################################################################

  variable library_dir
  variable PWD [pwd]
  variable root_hdl_folder
  variable done_list ""
  variable indent_level ""

  # get library absolute path
  set root_hdl_folder ""
  set glb_path $PWD
  if { [regexp projects $glb_path] } {
    regsub {/projects.*$} $glb_path "" root_hdl_folder
  } else {
    puts "ERROR: Not in hdl/* folder"
    return
  }

  set library_dir "$root_hdl_folder/library"

  #----------------------------------------------------------------------------
  # have debug messages
  proc puts_msg { message } {
    variable debug_msg
    variable indent_level
    if { $debug_msg == 1 } {
      puts $indent_level$message
    }
  }

  #----------------------------------------------------------------------------
  # returns the projects required set of libraries
  proc get_libraries {} {

    set build_list ""

    set search_pattern "LIB_DEPS.*="
    set fp1 [open ./Makefile r]
    set file_data [read $fp1]
    close $fp1

    set lines [split $file_data \n]
    foreach line $lines {
      if { [regexp $search_pattern $line] } {
        regsub -all $search_pattern $line "" library
        set library [string trim $library]
        puts_msg "\t- project dep: $library"
        append build_list "$library "
      }
    }
    return $build_list
  }

  #----------------------------------------------------------------------------
  proc lib { libraries } {

    variable library_dir
    variable PWD
    variable done_list

    set build_list $libraries
    if { $libraries == "all" } {
      set build_list "[get_libraries]"
    }

    set libraries ""
    puts "Building:"
    foreach b_lib $build_list {
      puts "- $b_lib"
      append libraries "$library_dir/$b_lib "
    }

    puts "Please wait, this might take a few minutes"

    # searching for subdir libraries in path of the given args
    set first_lib [lindex $libraries 0]
    if { $first_lib == "" } {
     set first_lib "."
    }
    # getting all (libraries)
    set index 0
    set library_element(1) $first_lib
    foreach argument $libraries {
     incr index 1
     set library_element($index) $argument
    }

    # search for all possible IPs in the given argument paths
    set makefiles ""
    if { $index == 0 } {
      set index 1
    }
    for {set y 1} {$y<=$index} {incr y} {
      set dir "$library_element($y)/"
      #search 4 level subdirectories for Makefiles
      for {set x 1} {$x<=4} {incr x} {
      catch { append makefiles " [glob "${dir}Makefile"]" } err
        append dir "*/"
      }
    }

    if { $makefiles == "" } {
      puts "ERROR: Wrong path to IP or the IP does not have a Makefile starting from \"$library_element(1)\""
    }

    # filter out non buildable libs (non *_ip.tcl)
    set buildable ""
    foreach fs $makefiles {
      set lib_dir [file dirname $fs]
      set lib_name "[file tail $lib_dir]_ip.tcl"
      if { [file exists $lib_dir/$lib_name] } {
        append buildable "$fs "
      }
    }
    set makefiles $buildable

    # build all detected IPs
    foreach fs $makefiles {
      regsub /Makefile $fs "" fs
      if { $fs == "." } {
        set fs [string trim [file tail [file normalize $fs]]]
      }
      regsub .*library/ $fs "" fs
      build_lib $fs
    }

    cd $PWD
    set done_list ""
  }

  #----------------------------------------------------------------------------
  # IP build procedure
  proc build_lib { library } {

    variable done_list
    variable library_dir
    variable indent_level

    append indent_level "\t" ;# debug messages

    puts_msg "DEBUG build_lib proc (recursive called)"

    # determine if the IP was previously built in the current adi_make_lib.tcl call
    if { [regexp $library $done_list] } {
      puts_msg "> Build previously done on $library"
      regsub . $indent_level "" indent_level
      return
    } else {
      puts_msg "- Start build of $library"
    }
    puts_msg "- Search dependencies for $library"

    # search for current IP dependencies

    # define library dependency search (Makefiles)
    set serch_pattern "XILINX_.*_DEPS.*="
    set dep_list ""

    set fp1 [open $library_dir/$library/Makefile r]
    set file_data [read $fp1]
    close $fp1

    set lines [split $file_data \n]
    foreach line $lines {
      if { [regexp $serch_pattern $line] } {
        regsub -all $serch_pattern $line "" lib_dep
        set lib_dep [string trim $lib_dep]
        puts_msg "\t$library is dependent on $lib_dep"
        append dep_list "$lib_dep "
      }
    }

    foreach lib $dep_list {
      build_lib $lib
    }

    puts_msg "- Continue build on $library"
    set lib_name "[file tail $library]_ip"

    cd $library_dir/${library}
    exec vivado -mode batch -source "$library_dir/${library}/${lib_name}.tcl"
    file copy -force ./vivado.log ./${lib_name}.log
    puts "- Done building $library"
    append done_list $library
    regsub . $indent_level "" indent_level
  }

  #----------------------------------------------------------------------------
  # boot_bin build procedure
  proc boot_bin {} {

    variable root_hdl_folder

    set arm_tr_sw_elf "bl31.elf"
    set boot_bin_folder "boot_bin"
    if {[catch {set xsa_file "[glob "./*.sdk/system_top.xsa"]"} fid]} {
      puts stderr "ERROR: $fid\n\rNOTE: you must have built hdl project\n\
      \rSee: https://wiki.analog.com/resources/fpga/docs/build\n"
      return
    }
    if {[catch {set uboot_elf "[glob "./u-boot*.elf"]" } fid]} {
      puts stderr "ERROR: $fid\n\rNOTE: you must have a the u-boot.elf in [pwd]\n\
      \rSee: https://wiki.analog.com/resources/fpga/docs/build\n"
      return
    }

    puts "root_hdl_folder $root_hdl_folder"
    puts "uboot_elf $uboot_elf"
    puts "xsa_file $xsa_file"

    # determine if Xilinx SDK tools are set in the enviroment
    package require platform
    set os_type [platform::generic]
    if { [regexp ^win $os_type] } {
      set w_cmd where
    } elseif { [regexp ^linux $os_type] } {
      set w_cmd which
    } else {
      puts "ERROR: Unknown OS: $os_type"
      exit 1
    }
    set xsct_loc [exec $w_cmd xsct]

    # search for Xilinx Command Line Tool (SDK)
    if { $xsct_loc == "" } {
      puts $env(PATH)
      puts "ERROR: SDK not installed or it is not defined in the enviroment path"
      exit 1
    }

    set xsct_script "exec xsct $root_hdl_folder/projects/scripts/adi_make_boot_bin.tcl"
    set build_args "$xsa_file $uboot_elf $boot_bin_folder $arm_tr_sw_elf"
    puts "Please wait, this may take a few minutes."
    eval $xsct_script $build_args
  }

} ;# ad_make namespace


#############################################################################
#############################################################################
