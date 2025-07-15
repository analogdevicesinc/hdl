###############################################################################
## Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set LANE_RATE $ad_project_params(LANE_RATE)   ; # [gbps]
set PLL_TYPE  $ad_project_params(PLL_TYPE)    ; # [CPLL/QPLL0/QPLL1]
set REF_CLK   $ad_project_params(REF_CLK)     ; # [MHz]

source $ad_hdl_dir/projects/scripts/gtwizard_generator.tcl
get_diff_params $LANE_RATE $PLL_TYPE $REF_CLK
