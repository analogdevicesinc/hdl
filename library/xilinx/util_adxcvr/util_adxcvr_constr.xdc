###############################################################################
## Copyright (C) 2016-2023, 2026 Analog Devices, Inc. All rights reserved.
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

set_property ASYNC_REG TRUE -quiet [get_cells -quiet -hier -filter {name =~ *up_rx_rst_done*}]
set_property ASYNC_REG TRUE -quiet [get_cells -quiet -hier -filter {name =~ *up_tx_rst_done*}]
set_property ASYNC_REG TRUE -quiet [get_cells -quiet -hier -filter {name =~ *rx_rate*}]
set_property ASYNC_REG TRUE -quiet [get_cells -quiet -hier -filter {name =~ *tx_rate*}]

set_false_path -quiet -to [get_cells -quiet -hier -filter {name =~ *up_rx_rst_done_m1_reg && IS_SEQUENTIAL}]
set_false_path -quiet -to [get_cells -quiet -hier -filter {name =~ *up_tx_rst_done_m1_reg && IS_SEQUENTIAL}]
set_false_path -quiet -to [get_cells -quiet -hier -filter {name =~ *rx_rate_m1_reg* && IS_SEQUENTIAL}]
set_false_path -quiet -to [get_cells -quiet -hier -filter {name =~ *tx_rate_m1_reg* && IS_SEQUENTIAL}]

# sync bits i_sync_bits_tx_prbs_in
set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_bits_tx_prbs_in* && IS_SEQUENTIAL}
    ]

# sync bits i_sync_bits_rx_prbs_in
set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_bits_rx_prbs_in* && IS_SEQUENTIAL}
    ]

# sync bits i_sync_bits_rx_prbs_out
set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_bits_rx_prbs_out* && IS_SEQUENTIAL}
    ]

# sync bits i_sync_bits_rx_bufstatus_in
set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_bits_rx_bufstatus_in* && IS_SEQUENTIAL}
    ]

# sync bits i_sync_bits_bufstatus_out
set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_bits_bufstatus_out* && IS_SEQUENTIAL}]
    

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_i_reset* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_o_reset* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_resetdone* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_bits_rx_in* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_bits_status* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_lcplllock* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_powergood* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_link_clk_locked* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_data_rx_prbssel* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_sync_data_tx_prbssel* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_i_reset* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_o_reset* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_resetdone* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_bits_rx_in* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_bits_status* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_lcplllock* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_powergood* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_link_clk_locked* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_data_rx_prbssel* && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *cdc_sync_stage*_reg* \
    -filter {NAME =~ *i_sync_data_tx_prbssel* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -from [get_cells -quiet -hier *cdc_hold_reg* -filter {NAME =~ *i_sync_data_rx_prbssel* && IS_SEQUENTIAL}] \
  -to [get_cells -quiet -hier *out_data_reg* -filter {NAME =~ *i_sync_data_rx_prbssel* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -from [get_cells -quiet -hier *cdc_hold_reg* -filter {NAME =~ *i_sync_data_tx_prbssel* && IS_SEQUENTIAL}] \
  -to [get_cells -quiet -hier *out_data_reg* -filter {NAME =~ *i_sync_data_tx_prbssel* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hier *usr_rate_m1_reg* -filter {IS_SEQUENTIAL}]
set_property ASYNC_REG TRUE -quiet \
  [get_cells -quiet -hier *usr_rate_m*_reg* -filter {IS_SEQUENTIAL}]
