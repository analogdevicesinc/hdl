###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# xfer_req crosses from the DMA clock with no relation to the device clock, so
# the launch and capture edges beat against each other and the tool derives a
# near-zero requirement. The synchroniser is the whole point of the crossing.
set_property ASYNC_REG TRUE [get_cells -quiet -hier *cdc_sync_stage*_reg* \
  -filter {IS_SEQUENTIAL}]

set_false_path -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
  -filter {IS_SEQUENTIAL}]
