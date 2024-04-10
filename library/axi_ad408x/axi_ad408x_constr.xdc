###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path \
  -from [get_cells -hierarchical * -filter {NAME=~*/ad408x_interface/adc_data_d_reg[*]}] \
    -to [get_cells -hierarchical * -filter {NAME=~*/ad408x_interface/adc_data_dd_reg[*]*}]
    
set_false_path \
  -from [get_cells -hierarchical * -filter {NAME=~*/ad408x_interface/sync_status_int_d_reg*}] \
    -to [get_cells -hierarchical * -filter {NAME=~*/ad408x_interface/sync_status_int_dd_reg*}]

set_false_path  -from [get_cells -hier -filter {name =~ *up_adc_num_lanes_reg* }]
set_false_path  -from [get_cells -hier -filter {name =~ */i_up_adc_common/i_xfer_cntrl/d_data_cntrl_int_reg[*]* }]
set_false_path  -from [get_cells -hier -filter {name =~ */ad408x_interface/adc_valid_p_d_reg[*]*}]
