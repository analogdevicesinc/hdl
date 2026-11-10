###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -quiet ASYNC_REG TRUE \
  [get_cells -quiet -hier {*cdc_sync_stage1_reg*}] \
  [get_cells -quiet -hier {*cdc_sync_stage2_reg*}]
