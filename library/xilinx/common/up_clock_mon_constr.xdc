###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property ASYNC_REG true [get_cells -hierarchical -filter {name =~ *up_count_running_m*}]
set_property ASYNC_REG true [get_cells -hierarchical -filter {name =~ *d_count_run_m*}]
set_property ASYNC_REG true [get_cells -hierarchical -filter {name =~ *up_d_count_reg*}]

set_false_path -from [get_cells -hierarchical -filter {name =~ *d_count_run_m3_reg*  && IS_SEQUENTIAL}] -to [get_cells -hierarchical -filter {name =~ *up_count_running_m1_reg* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hierarchical -filter {name =~ *up_count_run_reg*    && IS_SEQUENTIAL}] -to [get_cells -hierarchical -filter {name =~ *d_count_run_m1_reg* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hierarchical -filter {name =~ *d_count_reg*         && IS_SEQUENTIAL}] -to [get_cells -hierarchical -filter {name =~ *up_d_count_reg* && IS_SEQUENTIAL}]

