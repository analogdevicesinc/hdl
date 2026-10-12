###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# synchronizers for the SPI slave CS and RX toggle

set_property ASYNC_REG TRUE \
  [get_cells -hier -filter {NAME =~ *i_spi_slave/i_cs_sync/cdc_sync_stage* && IS_SEQUENTIAL}] \
  [get_cells -hier -filter {NAME =~ *i_spi_slave/i_tog_sync/cdc_sync_stage* && IS_SEQUENTIAL}]

# CS is asynchronous to clk

set_false_path \
  -to [get_cells -hier -filter {NAME =~ *i_spi_slave/i_cs_sync/cdc_sync_stage1_reg* && IS_SEQUENTIAL}]

# sclk -> clk: toggle handshake; sdi_hold is stable for a whole word once the
# toggle is seen in the clk domain

set_false_path \
  -from [get_cells -hier -filter {NAME =~ *i_spi_slave/sdi_tog_reg && IS_SEQUENTIAL}] \
  -to   [get_cells -hier -filter {NAME =~ *i_spi_slave/i_tog_sync/cdc_sync_stage1_reg* && IS_SEQUENTIAL}]

set_false_path \
  -from [get_cells -hier -filter {NAME =~ *i_spi_slave/sdi_hold_reg[*] && IS_SEQUENTIAL}] \
  -to   [get_cells -hier -filter {NAME =~ *i_spi_slave/rx_data_reg_reg[*] && IS_SEQUENTIAL}]

# CS asynchronously clears the sclk domain shift register and bit counter; the
# SPI protocol guarantees at least half an SCLK period before the first edge

set_false_path -to [get_pins -hier -filter {NAME =~ *i_spi_slave/bit_cnt_reg[*]/CLR}]
set_false_path -to [get_pins -hier -filter {NAME =~ *i_spi_slave/sdi_shift_reg[*]/CLR}]
