###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Primary clock definitions

# Set clocks depending on the requested LANE_RATE paramter from the util_adxcvr block
# Maximum values for Link clock:
# 204B - 15.5 Gbps /40 = 387.5MHz
# 204C - 24.75 Gbps /66 = 375MHz







# refclk and refclk_replica are connect to the same source on the PCB
# Set reference clock to same frequency as the link clock,
# this will ease the XCVR out clocks propagation calculation.
# TODO: this restricts RX_LANE_RATE=TX_LANE_RATE
create_clock -period 4.000 -name refclk [get_ports fpga_refclk_in_p]
create_clock -period 4.000 -name refclk_replica [get_ports fpga_refclk_in_replica_p]

# device clock
create_clock -period 4.000 -name rx_device_clk [get_ports clkin8_p]
create_clock -period 4.000 -name tx_device_clk [get_ports clkin6_p]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks rx_device_clk] 4.000 [get_ports sysref2_*]
set_input_delay -clock [get_clocks tx_device_clk] -add_delay 4.000 [get_ports sysref2_*]
set_clock_groups -asynchronous -group rx_device_clk -group tx_device_clk


# For transceiver output clocks use reference clock divided by one
# This will help autoderive the clocks correcly
set_case_analysis 0 [get_pins -quiet -hier {*_channel/TXSYSCLKSEL[0]}] -quiet
set_case_analysis 0 [get_pins -quiet -hier {*_channel/TXSYSCLKSEL[1]}] -quiet
set_case_analysis 1 [get_pins -quiet -hier {*_channel/TXOUTCLKSEL[0]}] -quiet
set_case_analysis 1 [get_pins -quiet -hier {*_channel/TXOUTCLKSEL[1]}] -quiet
set_case_analysis 0 [get_pins -quiet -hier {*_channel/TXOUTCLKSEL[2]}] -quiet

set_case_analysis 0 [get_pins -quiet -hier {*_channel/RXSYSCLKSEL[0]}] -quiet
set_case_analysis 0 [get_pins -quiet -hier {*_channel/RXSYSCLKSEL[1]}] -quiet
set_case_analysis 1 [get_pins -quiet -hier {*_channel/RXOUTCLKSEL[0]}] -quiet
set_case_analysis 1 [get_pins -quiet -hier {*_channel/RXOUTCLKSEL[1]}] -quiet
set_case_analysis 0 [get_pins -quiet -hier {*_channel/RXOUTCLKSEL[2]}] -quiet
