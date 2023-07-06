###############################################################################
## Copyright (C) 2023-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Create only the RX path
set INTF_CFG RX

# Dummy parameters for TX
set ad_project_params(TX_LANE_RATE) 0
set ad_project_params(TX_JESD_M) 1
set ad_project_params(TX_JESD_L) 1
set ad_project_params(TX_JESD_S) 1
set ad_project_params(TX_JESD_NP) 12
set ad_project_params(TX_NUM_LINKS) 1
set ad_project_params(TX_KS_PER_CHANNEL) 1

source $ad_hdl_dir/projects/ad9081_fmca_ebz/vck190/system_bd.tcl
