###############################################################################
## Copyright (C) 2017-2023, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
