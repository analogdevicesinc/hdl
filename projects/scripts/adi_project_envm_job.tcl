###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

###############################################################################
# Exports the FlashPro job with the fabric and the HSS (eNVM) of a built
# project, with adi_project_envm_job.
#
# Usage:
#   libero SCRIPT:adi_project_envm_job.tcl \
#     "SCRIPT_ARGS:<project.prjx> <hss.hex> <export_dir> [<job_file_name>]"
#
# Example, in projects/fmcomms2/mpfs_video_kit:
#   libero SCRIPT:../../scripts/adi_project_envm_job.tcl \
#     "SCRIPT_ARGS:_bld/prj/fmcomms2_mpfs_video_kit.prjx hss/hss.hex _bld"
###############################################################################

source [file join [file dirname [file normalize [info script]]] .. .. scripts adi_env.tcl]
source $ad_hdl_dir/projects/scripts/adi_project_microchip.tcl

if {[llength $argv] < 3} {
  puts "ERROR: adi_project_envm_job.tcl: expected <project.prjx> <hss.hex> <export_dir> \[<job_file_name>\]"
  exit 2
}

lassign $argv project_file envm_hex export_dir job_file_name

set job_args {}
if {$job_file_name ne ""} {
  lappend job_args -job_file_name $job_file_name
}

adi_project_envm_job $project_file $envm_hex $export_dir {*}$job_args
