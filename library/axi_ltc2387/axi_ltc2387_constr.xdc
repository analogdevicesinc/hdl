###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_multicycle_path -setup -from [get_pins -hier -filter {name=~*i_if/i_rx_d*/i_rx_data_iddr/C}] 2
set_multicycle_path -hold -from [get_pins -hier -filter {name=~*i_if/i_rx_d*/i_rx_data_iddr/C}] 1

set_multicycle_path -setup -to [get_pins -hier -filter {name=~*i_if/i_rx_d*/i_rx_data_iddr/D}] 2
set_multicycle_path -hold -to [get_pins -hier -filter {name=~*i_if/i_rx_d*/i_rx_data_iddr/D}] 1

set_multicycle_path -setup -to [get_pins -hier -filter {name=~*i_if/adc_data_reg[*]/D}] 2
set_multicycle_path -hold -to [get_pins -hier -filter {name=~*i_if/adc_data_reg[*]/D}] 1
