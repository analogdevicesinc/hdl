###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Replacement for the constraints delivered by the two high_speed_selectio_wiz
# IP XDC files, which are disabled in system_project.tcl to work around a
# Vivado 2025.1 segfault in the REF-name-scoped XDC reader
# (HXIUtil::readXDCForRefNameScoppedCells). See system_project.tcl for details.
#
# PACKAGE_PIN, IOSTANDARD and DIFF_TERM_ADV for these 32 ports are already set
# in system_constr.xdc, so only the properties unique to the IP XDCs are set
# here. Port names invert relative to the IP: the IP's clk_in/data_in are the
# top-level hsci_cko/hsci_do inputs, and clk_out/data_out are hsci_ckin/hsci_din.

# Inputs from the Apollo devices (IP clk_in_*/data_in_*).
set hsci_lvds_in_ports [get_ports { \
  hsci_cko_p[*] hsci_cko_n[*] \
  hsci_do_p[*]  hsci_do_n[*]  }]

# Outputs towards the Apollo devices (IP clk_out_*/data_out_*).
set hsci_lvds_out_ports [get_ports { \
  hsci_ckin_p[*] hsci_ckin_n[*] \
  hsci_din_p[*]  hsci_din_n[*]  }]

set_property DATA_RATE DDR $hsci_lvds_in_ports
set_property DATA_RATE DDR $hsci_lvds_out_ports

set_property EQUALIZATION EQ_LEVEL0 $hsci_lvds_in_ports
set_property LVDS_PRE_EMPHASIS FALSE $hsci_lvds_out_ports

# The IP XDCs applied these two with unqualified hierarchical searches, which
# were confined to the IP because the file was scoped to it. At top level they
# must be filtered to hsci_phy_top so they cannot reach unrelated PLLs or
# synchronizers elsewhere in the design.
set_property PHASESHIFT_MODE LATENCY \
  [get_cells -hierarchical -filter {NAME =~ "hsci_phy_top/*plle*"}]

set_false_path -to \
  [get_pins -hierarchical -filter {NAME =~ "hsci_phy_top/*sync_flop_0*/D"}]
