###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path \
  -from [get_registers {*|i_regmap|up_tdd_burst_count[*]}] \
  -to [get_registers {*|i_counter|tdd_burst_count[*]}]

set_false_path \
  -from [get_registers {*|i_regmap|up_tdd_startup_delay[*]}] \
  -to [get_registers {*|i_counter|tdd_startup_delay[*]}]

set_false_path \
  -from [get_registers {*|i_regmap|up_tdd_frame_length[*]}] \
  -to [get_registers {*|i_counter|tdd_frame_length[*]}]

set_false_path \
  -to [get_registers {*|i_sync_gen|tdd_sync_m1}]

set_false_path \
  -from [get_registers {*|i_regmap|up_tdd_sync_period_low[*]}] \
  -to [get_registers {*|i_sync_gen|tdd_sync_period[*]}]

set_false_path \
  -from [get_registers {*|i_regmap|up_tdd_sync_period_high[*]}] \
  -to [get_registers {*|i_sync_gen|tdd_sync_period[*]}]

set_false_path \
  -from [get_registers {*|i_regmap|up_tdd_channel_pol[*]}] \
  -to [get_registers {*|[*].i_channel|ch_pol}]

set_false_path \
  -from [get_registers {*|i_regmap|*up_tdd_channel_on[*][*]}] \
  -to [get_registers {*|[*].i_channel|t_high[*]}]

set_false_path \
  -from [get_registers {*|i_regmap|*up_tdd_channel_off[*][*]}] \
  -to [get_registers {*|[*].i_channel|t_low[*]}]

util_cdc_sync_bits_constr {*|axi_tdd_regmap:i_regmap|sync_bits:i_tdd_control_sync}

util_cdc_sync_bits_constr {*|axi_tdd_regmap:i_regmap|sync_bits:i_tdd_ch_en_sync}

util_cdc_sync_data_constr {*|axi_tdd_regmap:i_regmap|sync_data:i_tdd_cstate_sync}

util_cdc_sync_event_constr {*|axi_tdd_regmap:i_regmap|sync_event:i_tdd_soft_sync}

