###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_microchip.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

adi_project fmcomms2_mpfs_video_kit

source system_lb.tcl

adi_project_files fmcomms2_mpfs_video_kit \
  -hdl_source ../../../library/common/ad_iobuf.v \
  -hdl_source system_top.v \
  -synthesize {
    -sdc system_constr.sdc
  } \
  -placeroute {
    -io_pdc system_constr.pdc
    -sdc system_constr.sdc
  } \
  -verifytiming {
    -sdc system_constr.sdc
  }

if {[get_env_param ADI_SKIP_RUN 0]} {
  puts "INFO: Skipping adi_project_run because ADI_SKIP_RUN is set."
  save_project
  close_project
} else {
  # repair hold violations on short same-clock paths in place and route, as
  # the Microchip reference design does
  configure_tool -name {PLACEROUTE} -params {REPAIR_MIN_DELAY:true}

  adi_project_run fmcomms2_mpfs_video_kit \
    -program_design 1 \
    -program_spi_flash 0
}
