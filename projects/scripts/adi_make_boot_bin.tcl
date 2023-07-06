###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# script name adi_make_boot_bin.tcl

# -- HELP SECTION --
#
# This script was designed to work within the Xilinx tool command line interface
# Script arguments:
# 1 - xsa file location (default: ./system_top.xsa)
# 2 - u-boot.elf file location/name (default: ./u-boot.elf)
# 3 - build location (default: pwd: $PWD)"
# 4 - bl31.elf(mp soc projects only) file location
#
# The order of script arguments is mandatory.
#
# Examples:
# - adi_make_boot_bin.tcl
# - adi_make_boot_bin.tcl $xsa_path/system_top.xsa $uboot_path/u-boot.elf
# - adi_make_boot_bin.tcl $xsa_path/system_top.xsa $uboot_path/u-boot.elf $workspace
# - adi_make_boot_bin.tcl $xsa_path/system_top.xsa $uboot_path/u-boot.elf $workspace $arm_trf_repo/bl31.elf

set PWD [pwd]

# init variables
set app_type ""
set xsa_file ""
set uboot_file ""

# getting parsed arguments
set xsa_file [lindex $argv 0 ] ; # or .xsa(xilinx shell archive)
set uboot_file [lindex $argv 1]
set build_dir [lindex $argv 2]
set arm_tr_frm_file [lindex $argv 3]

# xsa file exists
if { $xsa_file == "" } {
  set xsa_file system_top.xsa
  if { ![file exists $xsa_file] } {
    set xsa_file system_top.xsa
  }
}
if { ![file exists $xsa_file] } {
  puts "ERROR: xsa file location is not set nor located in $PWD"
  return
}

# uboot file exists
if { $uboot_file == "" } {
    if {[catch {set uboot_file "[glob "./u-boot*.elf"]" } fid]} {
      puts stderr "ERROR: $fid\n\rNOTE: you must have a the u-boot.elf in [pwd]\n\
      \rSee: https://wiki.analog.com/resources/fpga/docs/build\n"
   }
}
if { ![file exists $uboot_file] } {
  puts "ERROR: uboot file location is not set, nor located in $PWD"
  return
}

# build dir defined
if { $build_dir == "" } {
  set build_dir "boot_bin"
}

if { [file exists $build_dir] } {
  file delete -force $build_dir
}
catch { file mkdir $build_dir } err
if { ![file exists $build_dir] } {
  puts "ERROR: Failed to create \"$build_dir\" dir"
  return
}
file copy -force $xsa_file $build_dir/system_top.xsa
file copy -force $uboot_file $build_dir

# Zynq MP arm trusted firwmware
if { $app_type == "Zynq MP FSBL" } {
  if { $arm_tr_frm_file == "" } {
    set arm_tr_frm_file bl31.elf
  }
  if { ![file exists $arm_tr_frm_file] } {
    puts "ERROR: arm trusted firmware (bl31.el) file is not defined or located in $PWD"
  }
}

# get cpu(app_type)
set cpu_name ""
set app_type ""
hsi open_hw_design $build_dir/system_top.xsa
set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]

if { $cpu_name == ""} {
  puts "ERROR: cpu name could not be determine from .xsa file"
  return
} else {
  if { [regexp psu_cortexa53.. $cpu_name] } {
    set app_type "Zynq MP FSBL"
  } elseif { [regexp ps7_cortexa9.. $cpu_name] } {
    set app_type "Zynq FSBL"
  } elseif { $cpu_name == "sys_mb" } {
    puts "ERROR: boot_bin (first stage boot loader + ...) is design for arm processors"
    return
  } else {
    puts "ERROR: unknown processor \"$cpu_name\" detected in $build_dir/system_top.xsa"
    return
  }
}

# Zynq MP arm trusted firwmware
if { $app_type == "Zynq MP FSBL" } {
  if { $arm_tr_frm_file == "" } {
    set arm_tr_frm_file bl31.elf
  }
  if { ![file exists $arm_tr_frm_file] } {
    puts "ERROR: arm trusted firmware (bl31.el) file is not defined or located in $PWD"
  } else {
    file copy -force $arm_tr_frm_file $build_dir
  }
}

puts "Using CPU $cpu_name"

# create zynq.bif for target app

set l_sq_bracket "\["
set r_sq_bracket "\]"
if { $app_type == "Zynq FSBL" } {

  set zynq_bif [open "$build_dir/zynq.bif" a+]
  puts  $zynq_bif "the_ROM_image:"
  puts  $zynq_bif "{"
  puts  $zynq_bif "${l_sq_bracket}bootloader${r_sq_bracket} ./fsbl.elf"
  puts  $zynq_bif "./system_top.bit"
  puts  $zynq_bif "$uboot_file"
  puts  $zynq_bif "}"
  close $zynq_bif

} elseif { $app_type == "Zynq MP FSBL" } {

  set zynqmp_bif [open "$build_dir/zynqmp.bif" a+]
  puts  $zynqmp_bif "the_ROM_image:"
  puts  $zynqmp_bif "{"
  puts  $zynqmp_bif "${l_sq_bracket}pmufw_image${r_sq_bracket} ./pmufw.elf"
  puts  $zynqmp_bif "${l_sq_bracket}bootloader,destination_cpu=a53-0${r_sq_bracket} ./fsbl.elf"
  puts  $zynqmp_bif "${l_sq_bracket}destination_device=pl${r_sq_bracket} ./system_top.bit"
  puts  $zynqmp_bif "${l_sq_bracket}destination_cpu=a53-0,exception_level=el-3,trustzone${r_sq_bracket} $arm_tr_frm_file"
  puts  $zynqmp_bif "${l_sq_bracket}destination_cpu=a53-0,exception_level=el-2${r_sq_bracket} $uboot_file"
  puts  $zynqmp_bif "}"
  close $zynqmp_bif

} else {
  puts "ERROR: unknown \"$app_type\" when creating zynqx.bif "
  return -level 0 -code error
}

# create fsbl_build.tcl script
set fsbl_build [open "$build_dir/fsbl_build.tcl" a+]
puts  $fsbl_build "hsi open_hw_design system_top.xsa"
puts  $fsbl_build "platform create -name hw0 -hw system_top.xsa -os standalone -out ./output -proc $cpu_name"
puts  $fsbl_build "platform generate"
close $fsbl_build

cd $build_dir

if {[catch { [exec xsct fsbl_build.tcl] } msg]} {
  puts "$msg"
}
puts "end of FSBL build"

file copy -force output/hw0/export/hw0/sw/hw0/boot/fsbl.elf .

if { $app_type == "Zynq FSBL" } {
    exec bootgen -image zynq.bif -w -o i BOOT.BIN
} elseif { $app_type == "Zynq MP FSBL" } {
    file copy -force output/hw0/export/hw0/sw/hw0/boot/pmufw.elf .
    exec bootgen -image zynqmp.bif -arch zynqmp -o BOOT.BIN -w
}

puts "adi_make_boot_bin.tcl done: $build_dir/BOOT.BIN"

## ***************************************************************************
## ***************************************************************************
