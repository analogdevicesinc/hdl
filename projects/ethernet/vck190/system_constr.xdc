###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
#
# Corundum-on-Versal (VCK190, MRMAC 1x100GE over GTY) project constraints.
#
# STARTER FILE - PIN ASSIGNMENTS ARE INTENTIONALLY LEFT AS TODO.
# The system clock and board GPIO (LEDs/switches/buttons) pins are already
# constrained by the carrier's projects/common/vck190/vck190_system_constr.xdc.
# The GT reference clock, GT lane, and any QSFP sideband pins below MUST be filled
# in from the VCK190 board schematic for the specific QSFP cage / FMCP you use
# before a bitstream can close. Nothing here should be treated as a verified pinout.

###############################################################################
# GT Reference Clock (156.25 MHz) - GTY refclk feeding the bonded 100G quad
###############################################################################
# 156.25 MHz is a valid refclk (25.78125 Gb/s per lane x 4 bonded = 100G). It is
# also the Corundum PTP hardware-clock source: the MRMAC glue taps a BUFG'd copy
# of this refclk (ptp_refclk_bufg) to drive ptp_clk, exactly as VCU118 drives
# ptp_clk from qsfp_mgt_refclk_bufg. 1000 / 156.25 = 6.400 ns.
#
# TODO: set PACKAGE_PIN for gt_ref_clk_p/n to the GTY_REFCLK site your VCK190
# board routes the QSFP/FMCP MGT reference clock to. VERIFY against the board
# schematic before building a bitstream.
create_clock -period 6.400 -name gt_ref_clk [get_ports gt_ref_clk_p]

set_property -dict {PACKAGE_PIN AD11} [get_ports gt_ref_clk_p]  ;# GTY_REFCLKP
set_property -dict {PACKAGE_PIN AD10} [get_ports gt_ref_clk_n]  ;# GTY_REFCLKN

###############################################################################
# QSFP GT lanes - all four bonded on ONE GTY quad
###############################################################################
# WIDE-SERDES PLACEMENT (fixes Place 30-2089 / 30-2090): a 1x100G CAUI-4 MRMAC
# bonds all four lanes of ONE GTY quad and REQUIRES that quad in the SAME clock
# region as the MRMAC hard block. Choose lane pins on a GTY quad that shares a
# clock region with an MRMAC site on the xcvc1902, and LOC the MRMAC into that
# region below (see the placement section). CONFIRM these match your board's QSFP
# cage / FMCP MGT lanes.
#
# TODO: set PACKAGE_PIN for all eight qsfp_serial_grx/gtx_p/n[3:0] to the GTY
# RX/TX P/N sites of the chosen quad.
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

###############################################################################
# GT Quad + MRMAC hard-block placement (same clock region)
###############################################################################
# The lane pins above bind the GTY quad; the critical constraint is pinning the
# MRMAC into the SAME region so the 4x80b serdes buses use the dedicated
# GT<->MRMAC hard routing instead of stranded fabric routing. Both LOCs are
# guarded (XDC is Tcl) so a cell-name change cannot break the flow; if a guard
# reports empty, regenerate the BD and re-check the cell paths with
#   get_cells -hier -filter {PRIMITIVE_TYPE =~ *MRMAC*}
#   get_cells -hier -filter {NAME =~ */gtwiz_versal*/*quad_inst}
#
# TODO: set the MRMAC and GTY_QUAD LOC sites to the region chosen above.
# set _mrmac_cell [get_cells -quiet -hier -filter {NAME =~ */mrmac_0/* && PRIMITIVE_TYPE =~ *MRMAC*}]
# if {[llength $_mrmac_cell]} { set_property LOC <MRMAC_XmYn> $_mrmac_cell }
# set _gt_quad_cell [get_cells -quiet -hier -filter {NAME =~ */gtwiz_versal*/*quad_inst && PRIMITIVE_TYPE =~ *GT*QUAD*}]
# if {[llength $_gt_quad_cell]} { set_property LOC <GTY_QUAD_XmYn> $_gt_quad_cell }

###############################################################################
# Clock domain crossing / async groups
###############################################################################
# The whole Corundum + control path runs on the CIPS 100 MHz PL clock (clk_pl_0);
# the GT reference clock is asynchronous to it. Declaring the async relationship
# avoids false timing failures on the inevitable GT<->fabric crossings.
# TODO: confirm the PL clock object name after the BD is generated (it is
# clk_pl_0 for the CIPS pl0_ref_clk output on this carrier).
set_clock_groups -asynchronous \
  -group [get_clocks clk_pl_0] \
  -group [get_clocks gt_ref_clk]

###############################################################################
# PTP clock domains (mirrors the VCU118 Corundum PTP scheme)
###############################################################################
# The PTP subsystem runs on its OWN clocks, deliberately asynchronous to the
# 100 MHz datapath/control clock (clk_pl_0):
#   ptp_clk         = 156.25 MHz, a BUFG'd copy of the GT reference clock tapped
#                     into the fabric by the MRMAC glue (ptp_refclk_bufg), EXACTLY
#                     as VCU118 drives ptp_clk from qsfp_mgt_refclk_bufg.
#                     PTP_CLK_PERIOD_NS = 32/5.
#   ptp_sample_clk  = sys_350m_clk (CIPS pl1_ref_clk, 334 MHz) - used only for
#                     asynchronous CDC sampling of the PTP ToD counter.
# ptp_clk is a generated clock derived from gt_ref_clk (through the BUFG_GT), so
# it is already covered by the gt_ref_clk async group above with respect to
# clk_pl_0. It must ALSO be declared async to ptp_sample_clk (pl1_ref_clk): the
# CDC logic inside corundum_core is designed for that crossing.
#
# THE REMAINING CROSSINGS ARE CONSTRAINED BY CELL, NOT BY CLOCK GROUP.
# An earlier version of this section carried a TODO to write a three-way
# set_clock_groups over clk_pl_0 / gt_ref_clk / sys_350m_clk once the generated
# clock names were known. That approach was NOT taken, and the reason is worth
# recording so nobody re-adds it:
#
#   1. The names are not stable. The failing path groups in this design are
#      clk_wizard's clkout1_primitive / clkout2_primitive and the auto-named
#      BUFG_GT/MBUFG_GT outputs. Vivado assigns those, and they change when the
#      block design is regenerated -- so a set_clock_groups written against them
#      stops matching SILENTLY (no error, timing quietly reopens).
#      (The names moved once already: the MMCM that generated these clocks used to
#      sit inside corundum_hierarchy and now lives at the top level as
#      corundum_mac_clkgen / corundum_mac_ts_clkgen, which reparents every
#      auto-generated clock object. The cell-scoped constraints kept matching
#      across that change; clock-name-scoped ones would not have.)
#   2. It over-waives. A clock group removes the relationship for EVERY path
#      between the domains, including any real one added later. The actual
#      failures were three reset-sync chains, one status bit and one PTP
#      systemtimer bus -- not a whole domain.
#
# MEASURED on the placed checkpoint, sourcing the tcl below: setup WNS
# -2.427 -> +0.239, hold WNS -1.874 -> -0.227 (the residual hold is a
# same-clock clkout1 BRAM->MRMAC TX_AXIS path, which the router closes).
#
# Instead, every crossing is constrained where the flop lives, in
# library/corundum/scripts/mrmac_gty_wrapper.tcl (added to constrs_1 by
# system_project.tcl) -- the same cell-scoped style as Corundum's own
# syn/vivado/*.tcl files, which survives a BD regen. It covers:
#   - the three sync_reset chains in mrmac_gty_wrapper (async preset false path)
#   - mrmac_ptp_sync's systemtimer bus into MRMAC's ts_clk domain (max_delay
#     -datapath_only, NOT a false path: the bus must settle inside its hold window)
#   - MRMAC's stat_rx/tx_status into mqnic_port's first synchronizer stage
#
# If a genuinely new async crossing appears, add it there rather than widening
# the group below.

###############################################################################
# LED status false paths
###############################################################################
set_false_path -to [get_ports gpio_led[*]]

###############################################################################
# GT DRC waivers (Versal MRMAC + GT-Wizard)
###############################################################################
# MBUFG_GT CLR/CLRBLEAF pins are connected appropriately by the GT-Wizard.
create_waiver -quiet -type DRC -id {REQP-2057} -user "ethernet_vck190" \
  -desc "MBUFG_GT CLR and CLRBLEAF pins are connected appropriately" \
  -objects [get_cells -quiet -hier -filter {REF_NAME==MBUFG_GT}]

# GT placement DRC (waived only if a non-default GT location is used above).
create_waiver -quiet -type DRC -id {XDCH-2} -user "ethernet_vck190" \
  -desc "GT placement is intentional for this design"
