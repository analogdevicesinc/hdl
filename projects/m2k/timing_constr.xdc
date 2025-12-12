###############################################################################
## Copyright (C) 2017-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_max_delay -datapath_only \
  -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/logic_analyzer/inst/BUFGMUX_CTRL_inst/O]] \
  -to [get_ports data_bd] \
  [get_property PERIOD [get_clocks rx_clk]]
