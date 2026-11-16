###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
# GTY channel N is QSFP lane N+1, no polarity swaps.

create_clock -period 6.400 -name gt_ref_clk [get_ports gt_ref_clk_p]

set_property -dict {PACKAGE_PIN AB11} [get_ports gt_ref_clk_p]
set_property -dict {PACKAGE_PIN AB10} [get_ports gt_ref_clk_n]

set_property -dict {PACKAGE_PIN AF2} [get_ports qsfp_serial_grx_p[0]]
set_property -dict {PACKAGE_PIN AF1} [get_ports qsfp_serial_grx_n[0]]
set_property -dict {PACKAGE_PIN AE4} [get_ports qsfp_serial_grx_p[1]]
set_property -dict {PACKAGE_PIN AE3} [get_ports qsfp_serial_grx_n[1]]
set_property -dict {PACKAGE_PIN AD2} [get_ports qsfp_serial_grx_p[2]]
set_property -dict {PACKAGE_PIN AD1} [get_ports qsfp_serial_grx_n[2]]
set_property -dict {PACKAGE_PIN AC4} [get_ports qsfp_serial_grx_p[3]]
set_property -dict {PACKAGE_PIN AC3} [get_ports qsfp_serial_grx_n[3]]

set_property -dict {PACKAGE_PIN AF7} [get_ports qsfp_serial_gtx_p[0]]
set_property -dict {PACKAGE_PIN AF6} [get_ports qsfp_serial_gtx_n[0]]
set_property -dict {PACKAGE_PIN AE9} [get_ports qsfp_serial_gtx_p[1]]
set_property -dict {PACKAGE_PIN AE8} [get_ports qsfp_serial_gtx_n[1]]
set_property -dict {PACKAGE_PIN AD7} [get_ports qsfp_serial_gtx_p[2]]
set_property -dict {PACKAGE_PIN AD6} [get_ports qsfp_serial_gtx_n[2]]
set_property -dict {PACKAGE_PIN AC9} [get_ports qsfp_serial_gtx_p[3]]
set_property -dict {PACKAGE_PIN AC8} [get_ports qsfp_serial_gtx_n[3]]

set_clock_groups -asynchronous \
  -group [get_clocks clk_pl_0] \
  -group [get_clocks gt_ref_clk]

set_false_path -to [get_ports gpio_led[*]]

set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports qsfp_resetl]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports qsfp_lpmode]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports qsfp_modsell]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports qsfp_modprsl]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports qsfp_intl]

set_false_path -to   [get_ports {qsfp_resetl qsfp_lpmode qsfp_modsell}]
set_false_path -from [get_ports {qsfp_modprsl qsfp_intl}]

create_waiver -quiet -type DRC -id {REQP-2057} -user "corundum_100g_vck190" \
  -desc "MBUFG_GT CLR and CLRBLEAF pins are connected appropriately" \
  -objects [get_cells -quiet -hier -filter {REF_NAME==MBUFG_GT}]

create_waiver -quiet -type DRC -id {XDCH-2} -user "corundum_100g_vck190" \
  -desc "GT placement is intentional for this design"
