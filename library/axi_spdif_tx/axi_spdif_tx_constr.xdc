###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property ASYNC_REG TRUE \
	[get_cells -hier cdc_sync_stage1_*_reg] \
	[get_cells -hier cdc_sync_stage2_*_reg]

set_false_path \
	-from [get_cells -hier cdc_sync_stage0_*_reg -filter {PRIMITIVE_SUBGROUP == flop || primitive_subgroup == SDR}] \
	-to [get_cells -hier cdc_sync_stage1_*_reg -filter {PRIMITIVE_SUBGROUP == flop || primitive_subgroup == SDR}]

set_false_path \
	-from [get_cells -hier spdif_out_reg -filter {PRIMITIVE_SUBGROUP == flop || primitive_subgroup == SDR}] \
	-to [get_cells -hier spdif_tx_o_reg -filter {PRIMITIVE_SUBGROUP == flop || primitive_subgroup == SDR}]
