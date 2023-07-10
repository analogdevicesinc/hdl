###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_cal_done_t_m1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_sysref_ack_t_m1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_sync_status_t_m1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_sync_status_1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_sync_status_0* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_cal_enable_m1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_cor_enable_t_m1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_sysref_control_t_m1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_sysref_mode_e* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_sysref_mode_i* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_sysref_req_t_m1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_sync_control_t_m1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_sync_mode* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_sync_disable_1* && IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_sync_disable_0* && IS_SEQUENTIAL}]

set_false_path -to [get_cells -hier -filter {name =~ *up_cal_done_t_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_cal_max_0* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_cal_min_0* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_cal_max_1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_cal_min_1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_sysref_ack_t_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_sync_status_t_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_sync_status_1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_sync_status_0* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_cal_enable_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_cor_enable_t_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_cor_enable* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_cor_scale_0* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_cor_offset_0* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_cor_scale_1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_cor_offset_1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_sysref_control_t_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_sysref_mode_e* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_sysref_mode_i* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_sysref_req_t_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_sync_control_t_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_sync_mode* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_sync_disable_1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_sync_disable_0* && IS_SEQUENTIAL}]

# Define spi clock
create_generated_clock -name forwarded_spi_clk  \
  -source [get_pins -hier up_spi_clk_int_reg/C] \
  -divide_by 2 [get_pins -hier up_spi_clk_int_reg/Q]
