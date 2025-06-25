###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -quiet -dict { \
  SHREG_EXTRACT NO \
  ASYNC_REG TRUE \
  SRL_STYLE REGISTER \
  DONT_TOUCH TRUE \
} [get_cells -quiet -hier -regexp -filter {NAME =~ \S*cdc_a*sync_stage_reg\[\d+\]\S*}]
# } [get_cells -quiet -hier -regexp -filter {NAME =~ \S*cdc_a*sync_stage_reg\[\d+\]\[\d+\]\S*}]
