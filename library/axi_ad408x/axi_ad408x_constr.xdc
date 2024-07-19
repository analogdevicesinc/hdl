###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# set_property ASYNC_REG TRUE \
#   [get_cells -quiet -hierarchical *cdc_sync_stage1_reg*] \
#   [get_cells -quiet -hierarchical *cdc_sync_stage2_reg*]


set_false_path  \
 -from [get_cells -quiet -hierarchical -filter {NAME =~ *da_iddr/i_rx_data_iddr*}] \
 -to [get_cells -quiet -hierarchical -filter {NAME =~ *ad408x_interface/adc_data_p_reg[*]*}]

# set_false_path  -from [get_cells -hier -filter {name =~ *i_address_gray/s_axis_waddr_reg_reg[*]*}]
# set_false_path  -from [get_cells -hier -filter {name =~ *i_address_gray/g_async_clock.i_raddr_sync_gray/out_count_m_reg[*]*}]
set_false_path  -from [get_cells -hier -filter {name =~ */i_up_adc_common/i_xfer_cntrl/d_data_cntrl_int_reg[*]* }]
