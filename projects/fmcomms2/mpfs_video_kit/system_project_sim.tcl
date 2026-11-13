###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

if {![info exists project_name]} {
  set project_name fmcomms2_mpfs_video_kit_sim
}

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_microchip.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# The testbench captures the RX data with a cyclic ADC DMA
adi_project $project_name -parameter_list {ADC_DMA_CYCLIC 1}

source system_lb.tcl

adi_project_files $project_name \
  -hdl_source ../../../library/common/ad_iobuf.v \
  -hdl_source system_top.v

adi_project_sim $project_name \
  -tb verification/system_tb.v \
  -root system_top \
  -sim_runtime 1ns \
  -vsim_options {+PFSoC_MSS_DDR_INIT_FILE -gNO_OF_QOS_TRANSACTIONS=0}
