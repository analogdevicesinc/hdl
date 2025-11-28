###############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set timer_en 0
source $ad_hdl_dir/projects/common/lfcpnx/lfcpnx_system_pb.tcl

sysid_gen_sys_init_file
