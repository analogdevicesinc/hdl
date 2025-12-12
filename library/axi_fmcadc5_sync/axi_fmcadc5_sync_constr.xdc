###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Define spi clock
create_generated_clock -name forwarded_spi_clk  \
  -source [get_pins -hier up_spi_clk_int_reg/C] \
  -divide_by 2 [get_pins -hier up_spi_clk_int_reg/Q]
