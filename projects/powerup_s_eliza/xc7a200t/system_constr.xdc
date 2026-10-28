###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN Y18  IOSTANDARD DIFF_SSTL18_I} [get_ports clk_122_p]
set_property -dict {PACKAGE_PIN Y19  IOSTANDARD DIFF_SSTL18_I} [get_ports clk_122_n]

# Aurora

set_property -dict {PACKAGE_PIN F6} [get_ports aurora_refclk_p]
set_property -dict {PACKAGE_PIN E6} [get_ports aurora_refclk_n]
set_property -dict {PACKAGE_PIN B4} [get_ports aurora_txp[0]]
set_property -dict {PACKAGE_PIN A4} [get_ports aurora_txn[0]]
set_property -dict {PACKAGE_PIN D5} [get_ports aurora_txp[1]]
set_property -dict {PACKAGE_PIN C5} [get_ports aurora_txn[1]]
set_property -dict {PACKAGE_PIN B8} [get_ports aurora_rxp[0]]
set_property -dict {PACKAGE_PIN A8} [get_ports aurora_rxn[0]]
set_property -dict {PACKAGE_PIN D11} [get_ports aurora_rxp[1]]
set_property -dict {PACKAGE_PIN C11} [get_ports aurora_rxn[1]]

set_property -dict {PACKAGE_PIN E2   IOSTANDARD LVCMOS18} [get_ports FPGA_TRIG]

create_clock -period 8.138 -name aurora_refclk [get_ports aurora_refclk_p]

create_generated_clock -name sys_clk [get_pins i_system_wrapper/system_i/clk_wizard/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name spi_clk [get_pins i_system_wrapper/system_i/clk_wizard/inst/mmcm_adv_inst/CLKOUT1]

set_false_path -from [get_ports FPGA_TRIG]
