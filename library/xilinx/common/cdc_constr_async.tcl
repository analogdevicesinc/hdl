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

set_property -quiet -dict { \
  DONT_TOUCH TRUE \
} [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == sync_bits || REF_NAME == sync_bits)}]

set_property -quiet -dict { \
  DONT_TOUCH TRUE \
} [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == sync_data || REF_NAME == sync_data)}]

set_property -quiet -dict { \
  DONT_TOUCH TRUE \
} [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == sync_event || REF_NAME == sync_event)}]

set_property -quiet -dict { \
  DONT_TOUCH TRUE \
} [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == util_rst || REF_NAME == util_rst)}]

set_property -quiet -dict { \
  DONT_TOUCH TRUE \
} [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == util_rst_chain || REF_NAME == util_rst_chain)}]
