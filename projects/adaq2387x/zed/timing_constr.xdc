###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# data delay (dco to da/db skew 200ps)
#set data_delay  0.200

# data delay for 240MHz clk
#set data_delay_min 1.880
#set data_delay_max 3.120

# input delays

#set_input_delay -clock dco -max  $data_delay_max [get_ports da_p]
#set_input_delay -clock dco -min -$data_delay_min [get_ports da_p]
#set_input_delay -clock dco -clock_fall -max -add_delay  $data_delay_max [get_ports da_p]
#set_input_delay -clock dco -clock_fall -min -add_delay -$data_delay_min [get_ports da_p]

#set_input_delay -clock dco -max  $data_delay [get_ports db_p]
#set_input_delay -clock dco -min -$data_delay [get_ports db_p]
#set_input_delay -clock dco -clock_fall -max -add_delay  $data_delay [get_ports db_p]
#set_input_delay -clock dco -clock_fall -min -add_delay -$data_delay [get_ports db_p]

#set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387/inst/i_if/i_rx_db/i_rx_data_idelay]
#set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387/inst/i_if/i_rx_da/i_rx_data_idelay]

