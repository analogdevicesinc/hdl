###############################################################################
## Copyright (C) 2024, 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# mmcm_clk_0_s (ADC sample clock, from PS PLL1 via MMCM) and clk_pl_0 (AXI clock, from PS PLL0)
# are asynchronous - they share no common primary clock with a defined phase relationship.
# All crossings between them are properly synchronised in RTL (sync_bits, up_xfer_cntrl, etc.)
# The clocks only exist after the block design is built, so this file is used in implementation only.
set_clock_groups -asynchronous -group [get_clocks mmcm_clk_0_s] -group [get_clocks clk_pl_0]
