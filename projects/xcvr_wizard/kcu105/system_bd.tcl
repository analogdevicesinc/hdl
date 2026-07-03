###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set LANE_RATE $ad_project_params(LANE_RATE)   ; # [gbps]
set PLL_TYPE  $ad_project_params(PLL_TYPE)    ; # [CPLL/QPLL0/QPLL1]
set REF_CLK   $ad_project_params(REF_CLK)     ; # [MHz]
set JESD_MODE $ad_project_params(JESD_MODE)

foreach rx_param {XCVR_RX_PLL_TYPE XCVR_RX_LANE_RATE XCVR_RX_REF_CLK} {
    if {[info exists ad_project_params($rx_param)] && $ad_project_params($rx_param) ne ""} {
        set $rx_param $ad_project_params($rx_param)
    } else {
        set $rx_param ""
    }
}

source $ad_hdl_dir/projects/scripts/gtwizard_generator.tcl
get_diff_params $LANE_RATE $PLL_TYPE $REF_CLK $JESD_MODE $XCVR_RX_PLL_TYPE $XCVR_RX_LANE_RATE $XCVR_RX_REF_CLK
