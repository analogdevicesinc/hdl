###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path -to [get_registers *cdc_sync_stage1*]

set_false_path \
  -from [get_registers *i_sdi_level_sync*|cdc_hold[*]] \
  -to   [get_registers *i_sdi_level_sync*|out_data[*]]
