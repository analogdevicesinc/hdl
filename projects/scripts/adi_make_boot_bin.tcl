## ***************************************************************************
## ***************************************************************************
## Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
##
## In this HDL repository, there are many different and unique modules, consisting
## of various HDL (Verilog or VHDL) components. The individual modules are
## developed independently, and may be accompanied by separate and unique license
## terms.
##
## The user should read each of these license terms, and understand the
## freedoms and responsibilities that he or she has by using this source/core.
##
## This core is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
## A PARTICULAR PURPOSE.
##
## Redistribution and use of source or resulting binaries, with or without modification
## of this file, are permitted under one of the following two license terms:
##
##   1. The GNU General Public License version 2 as published by the
##      Free Software Foundation, which can be found in the top level directory
##      of this repository (LICENSE_GPL2), and also online at:
##      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
##
## OR
##
##   2. An ADI specific BSD license, which can be found in the top level directory
##      of this repository (LICENSE_ADIBSD), and also on-line at:
##      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
##      This will allow to generate bit files and not release the source code,
##      as long as it attaches to an ADI device.
##
## ***************************************************************************
## ***************************************************************************

# script name adi_make_boot_bin.tcl

# -- HELP SECTION --
#
# This script was designed to work within the Xilinx tool command line interface
# Script arguments:
# 1 - hdf file location (default: ./system_top.hdf)
# 2 - u-boot.elf file location/name (default: ./u-boot.elf)
# 3 - build location (default: pwd: $PWD)"
# 4 - bl31.elf(mp soc projects only) file location
#
# The order of script arguments is mandatory.
#
# Examples:
# - adi_make_boot_bin.tcl
# - adi_make_boot_bin.tcl $hdf_path/system_top.hdf $uboot_path/u-boot.elf
# - adi_make_boot_bin.tcl $hdf_path/system_top.hdf $uboot_path/u-boot.elf $workspace
# - adi_make_boot_bin.tcl $hdf_path/system_top.hdf $uboot_path/u-boot.elf $workspace $arm_trf_repo/bl31.elf

set PWD [pwd]

# getting parsed arguments
set app_type ""
set hdf_file ""
set uboot_file ""

set hdf_file [lindex $argv 0]
set uboot_file [lindex $argv 1]
set build_dir [lindex $argv 2]
set arm_tr_frm_file [lindex $argv 3]

# hdf file exists
if { $hdf_file == "" } {
  set hdf_file system_top.hdf
}
if { ![file exists $hdf_file] } {
  puts "ERROR: hdf file is not defined or located in $PWD"
  return
}

# uboot file exists
if { $uboot_file == "" } {
  set uboot_file u-boot.elf
}
if { ![file exists $uboot_file] } {
  puts "ERROR: uboot file is not defined or located in $PWD"
  return
}

# build dir defined
if { $build_dir == "" } {
  set build_dir "boot_bin"
}

catch { file mkdir $build_dir } err
if { ![file exists $build_dir] } {
  puts "ERROR: Failed to create \"$build_dir\" dir"
  return
}
file copy -force $hdf_file $build_dir/system_top.hdf
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
hsi open_hw_design $build_dir/system_top.hdf
set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]

if { $cpu_name == ""} {
  puts "ERROR: cpu name could not be determine from hdf file"
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
    puts "ERROR: unknown processor \"$cpu_name\" detected in $build_dir/system_top.hdf"
    return
  }
}
puts "Using CPU $cpu_name"

# create zynq.bif for target app

set l_sq_bracket "\["
set r_sq_bracket "\]"
if { $app_type == "Zynq FSBL" } {

  file delete -force $build_dir/zynq.bif
  set zynq_bif [open "$build_dir/zynq.bif" a+]
  puts  $zynq_bif "the_ROM_image:"
  puts  $zynq_bif "{"
  puts  $zynq_bif "${l_sq_bracket}bootloader${r_sq_bracket} ./fsbl_prj/fsbl/Debug/fsbl.elf"
  puts  $zynq_bif "./system_top.bit"
  puts  $zynq_bif "$uboot_file"
  puts  $zynq_bif "}"
  close $zynq_bif

} elseif { $app_type == "Zynq MP FSBL" } {

  file delete -force $build_dir/zynqmp.bif
  set zynqmp_bif [open "$build_dir/zynqmp.bif" a+]
  puts  $zynqmp_bif "the_ROM_image:"
  puts  $zynqmp_bif "{"
  puts  $zynqmp_bif "${l_sq_bracket}fsbl_config${r_sq_bracket} a53_x64"
  puts  $zynqmp_bif "${l_sq_bracket}bootloader${r_sq_bracket} ./fsbl_prj/fsbl/Debug/fsbl.elf"
  puts  $zynqmp_bif "${l_sq_bracket}pmufw_image${r_sq_bracket} ./pmufw/executable.elf"
  puts  $zynqmp_bif "${l_sq_bracket}destination_device=pl${r_sq_bracket} ./system_top.bit"
  puts  $zynqmp_bif "${l_sq_bracket}destination_cpu=a53-0,exception_level=el-3,trustzone${r_sq_bracket} $arm_tr_frm_file"
  puts  $zynqmp_bif "${l_sq_bracket}destination_cpu=a53-0,exception_level=el-2${r_sq_bracket} $uboot_file"
  puts  $zynqmp_bif "}"
  close $zynqmp_bif

  file delete -force $build_dir/create_pmufw_project.tcl
  set pmufw_proj [open "$build_dir/create_pmufw_project.tcl" a+]
  puts  $pmufw_proj "set hwdsgn ${l_sq_bracket}open_hw_design ./system_top.hdf${r_sq_bracket}"
  puts  $pmufw_proj "generate_app -hw \$hwdsgn -os standalone -proc psu_pmu_0 -app zynqmp_pmufw -compile -sw pmufw -dir pmufw"
  puts  $pmufw_proj "quit"
  close $pmufw_proj

} else {
  puts "ERROR: unknown \"$app_type\" when creating zynqx.bif "
  return -level 0 -code error
}

# create fsbl_build.tcl script
file delete -force $build_dir/fsbl_build.tcl
set fsbl_build [open "$build_dir/fsbl_build.tcl" a+]
puts  $fsbl_build "hsi open_hw_design system_top.hdf"
puts  $fsbl_build "setws ./fsbl_prj"
puts  $fsbl_build "createhw -name hw -hwspec system_top.hdf"
puts  $fsbl_build "createapp -name fsbl -app \"$app_type\" -proc $cpu_name -bsp bsp -hwproject hw -os standalone -lang C"
puts  $fsbl_build "projects -build -type all\n"
close $fsbl_build

cd $build_dir
file delete -force fsbl_prj
file delete -force pmufw

exec xsdk -batch -source fsbl_build.tcl -wait

if { $app_type == "Zynq FSBL" } {
    exec bootgen -image zynq.bif -w -o i BOOT.BIN
} elseif { $app_type == "Zynq MP FSBL" } {
    exec hsi -source create_pmufw_project.tcl
    exec bootgen -image zynqmp.bif -arch zynqmp -o BOOT.BIN -w
}

puts "adi_make_boot_bin.tcl done: $build_dir/BOOT.BIN"

## ***************************************************************************
## ***************************************************************************
