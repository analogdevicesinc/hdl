###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/coraz7s/coraz7s_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source ../common/ad5706r_bd.tcl

#system ID
ad_sysid_init

set sys_dma_clk [get_bd_nets sys_dma_clk]
