###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints
set_property  -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 4}  [get_ports fan_en_b]; # Bank  45 VCCO - som240_1_b13 - IO_L11P_AD9P_45

set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]
