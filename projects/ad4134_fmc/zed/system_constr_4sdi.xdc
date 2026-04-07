###############################################################################
## Copyright (C) 2023-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Constraints for quad-channel mode (NUM_OF_SDI=4)

set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS18} [get_ports ad4134_din[0]]; ## FMC_LPC_LA00_N_CC
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS18} [get_ports ad4134_din[1]]; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS18} [get_ports ad4134_din[2]]; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18} [get_ports ad4134_din[3]]; ## FMC_LPC_LA02_N
