###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Configurable parameters
set SAMPLE_RATE_MHZ 1000.0
set NUM_OF_CHANNELS 4           ; # M
set SAMPLES_PER_FRAME 1         ; # S
set NUM_OF_LANES 4              ; # L
set ADC_RESOLUTION 8            ; # N & NP

set LANE_RATE [expr {($ADC_RESOLUTION * $NUM_OF_CHANNELS *$SAMPLE_RATE_MHZ * 1.25) / $NUM_OF_LANES}]

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/ad_fmclidar1_ebz_qsys.tcl
} else {
  source ../common/ad_fmclidar1_ebz_qsys.tcl
}

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

sysid_gen_sys_init_file;

#spi
set_instance_parameter_value sys_spi {clockPhase} {1}
set_instance_parameter_value sys_spi {clockPolarity} {1}
