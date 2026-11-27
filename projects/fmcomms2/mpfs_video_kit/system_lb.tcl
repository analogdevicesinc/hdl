###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

if {![llength [info commands ::adi_gen_sysid_init_file]]} {
  source [file join $ad_hdl_dir projects scripts adi_pd.tcl]
}

adi_gen_sysid_init_file -board mpfs_video_kit -output_dir $ad_project_dir

source [file join $ad_hdl_dir projects common mpfs_video_kit system_lb.tcl]
source [file join $ad_hdl_dir projects fmcomms2 common fmcomms2_lb.tcl]
