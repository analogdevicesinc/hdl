###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dco_clk_period 8.33
create_clock -period $dco_clk_period -name dco  [get_ports dco_p]

# input delays for 120MHz clk

set_input_delay -clock [get_clocks dco] -clock_fall -min -add_delay 1.880 [get_ports da_p]
set_input_delay -clock [get_clocks dco] -clock_fall -max -add_delay 3.120 [get_ports da_p]
set_input_delay -clock [get_clocks dco] -min -add_delay 1.880 [get_ports da_p]
set_input_delay -clock [get_clocks dco] -max -add_delay 3.120 [get_ports da_p]

set_input_delay -clock [get_clocks dco] -clock_fall -min -add_delay 1.880 [get_ports db_p]
set_input_delay -clock [get_clocks dco] -clock_fall -max -add_delay 3.120 [get_ports db_p]
set_input_delay -clock [get_clocks dco] -min -add_delay 1.880 [get_ports db_p]
set_input_delay -clock [get_clocks dco] -max -add_delay 3.120 [get_ports db_p]

set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387/inst/i_if/i_rx_db/i_rx_data_idelay]
set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387/inst/i_if/i_rx_da/i_rx_data_idelay]
