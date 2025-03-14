###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fpga_pll_cnv_p]; ## H10 FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fpga_pll_cnv_n]; ## H11 FMC_LPC_LA04_N

set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports pll_sync_fmc];              ## D11 FMC_LPC_LA05_P
