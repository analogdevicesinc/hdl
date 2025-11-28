###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set timer_en 0
source $ad_hdl_dir/projects/common/lfcpnx/lfcpnx_system_pb.tcl
source $ad_hdl_dir/projects/ad738x_fmc/common/ad738x_pb.tcl

set sys_cstring "ALERT_SPI_N=$ad_project_params(ALERT_SPI_N)\
NUM_OF_SDI=$ad_project_params(NUM_OF_SDI)"

sysid_gen_sys_init_file $sys_cstring
