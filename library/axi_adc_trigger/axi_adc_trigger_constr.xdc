###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_xfer_toggle*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *trigger_a_d*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *trigger_b_d*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_triggered_d*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_triggered_reset_d*}]

set_false_path  -to [get_cells -hier -filter {name =~ *trigger_a_d1_reg*      && IS_SEQUENTIAL}]
set_false_path  -to [get_cells -hier -filter {name =~ *trigger_b_d1_reg*      && IS_SEQUENTIAL}]
set_false_path  -to [get_cells -hier -filter {name =~ *up_triggered_d1*       && IS_SEQUENTIAL}]
set_false_path  -to [get_cells -hier -filter {name =~ *up_triggered_reset_d1* && IS_SEQUENTIAL}]

