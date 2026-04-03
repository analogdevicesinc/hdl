###############################################################################
## Copyright (C) 2023-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Constraints for single-channel mode (NUM_OF_SDI=1)

set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports ad4134_din[0]]; ## FMC_LPC_LA00_N_CC
