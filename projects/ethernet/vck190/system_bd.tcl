###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
#
# Corundum-on-Versal block design for the VCK190 (xcvc1902), MRMAC 1x100GE over GTY.
# GTY sibling of the VPK180 (GTM) block design: byte-identical host/clocking/reset
# wiring; the GTM/GTY choice lives entirely in the Corundum MRMAC companion network
# (mrmac_0 GT_TYPE + gtwiz preset + mrmac_versal_glue GT_TYPE), built by
# corundum_vck190_mac.tcl and selected by corundum.tcl's VCK190 branch.
#
# Flow:
#   1. Source the VCK190 CIPS + NoC carrier base (no PCIe). The VCK190 common
#      carrier reuses the vmk180 CIPS/NoC base (same silicon family, DDR4 host
#      memory); it exports the SAME net names as the VPK180 carrier
#      (sys_cpu_clk, sys_350m_clk, sys_cpu_resetn, sys_cips/pl0_resetn, axi_noc_0,
#      M_AXI_FPD, 16 IRQs), so the host wiring below is identical to VPK180.
#   2. Source the Corundum VCK190 config, then the shared Corundum integrator.
#      corundum.tcl builds /corundum_hierarchy (the mqnic_core_axi datapath + the
#      MRMAC-over-GTY companion network built by corundum_vck190_mac.tcl) and a
#      top-level corundum_rstgen. It reads $env(BOARD)=VCK190 and $env(CPU)=versal
#      (both exported from the Makefile) to select the VCK190 branch and skip the
#      MicroBlaze-only GPIO reset.
#   3. Drive the /corundum_hierarchy boundary (physical + MAC bring-up pins) and
#      wire the AXI host path (control, DMA over NoC, interrupt) to the CIPS.
#
# Host contract (NO PCIe - the Versal host is AXI):
#   s_axil_corundum  <- CPU control            (ad_cpu_interconnect -> FPD)
#   s_axi_mac        <- CPU MRMAC registers     (ad_cpu_interconnect -> FPD)
#   s_axi_gt         <- CPU GT-wizard registers (ad_cpu_interconnect -> FPD)
#   m_axi            -> host memory (DDR4)       (ad_mem_hp0_interconnect -> NoC)
#   irq              -> CPU interrupt            (ad_cpu_interrupt -> pl_ps_irq5)

# 1. VCK190 carrier base (CIPS, NoC, DDR4, sys clk/reset, GPIO, SPI, sysid). The
#    VCK190 common carrier sources the vmk180 CIPS/NoC base.
source $ad_hdl_dir/projects/common/vck190/vck190_system_bd.tcl

# 2. Corundum config + integrator.
source $ad_hdl_dir/library/corundum/scripts/corundum_vck190_cfg.tcl

# The Corundum core clock (clk_corundum) is driven from the CIPS 100 MHz PL clock
# (sys_cpu_clk / pl0_ref_clk) - see the clocking note below. Override CLK_PERIOD_NS
# (default 4ns = 250 MHz in the cfg) to 10ns so the core's datapath math is
# self-consistent with the actual 100 MHz clock. corundum.tcl sources
# corundum_common_cfg.tcl only if unset, then passes these to corundum_core, so
# setting them here (after the cfg, before the integrator) takes effect.
# TODO(perf): to run the datapath at 250 MHz, add a clk_wizard (sys_cpu_clk ->
# 250 MHz) for clk_corundum AND give the control-path smartconnect a second ACLK
# so s_axil_* crosses 100->250 MHz cleanly, then restore CLK_PERIOD_NS to 4/1.
set CLK_PERIOD_NS_NUM   10
set CLK_PERIOD_NS_DENOM 1

# PTP hardware clock (ptp_clk) runs in its OWN domain, mirroring VCU118 Corundum:
# there ptp_clk is the 156.25 MHz MGT-refclk BUFG (PTP_CLK_PERIOD_NS = 32/5 =
# 6.4 ns), distinct from the datapath clk_corundum, and ptp_sample_clk is a
# separate asynchronous clock (125 MHz) used only for CDC sampling. We reproduce
# that EXACTLY here: the GT reference clock is set to 156.25 MHz, and the MRMAC
# glue taps a BUFG'd copy of it into the fabric (corundum_hierarchy/ptp_refclk_bufg)
# which drives ptp_clk (section 3b) - the true VCU118 pattern (ptp_clk <-
# qsfp_mgt_refclk_bufg), not a synthesized clock. Keep PTP_CLK_PERIOD_NS at the
# VCU118 value 32/5: the PTP timestamp increment is computed by corundum_core from
# this ratio, so it must match the physical ptp_clk frequency (156.25 MHz).
set PTP_CLK_PERIOD_NS_NUM   32
set PTP_CLK_PERIOD_NS_DENOM 5

source $ad_hdl_dir/library/corundum/scripts/corundum.tcl

###############################################################################
# 3a. Physical boundary ports (top-level, user-constrained in system_constr.xdc)
###############################################################################

# GT reference clock differential pair (QSFP cage refclk, 156.25 MHz; also the
# Corundum PTP hardware-clock source - see the PTP clocking note below).
# The hierarchy exposes single-ended pins; the glue IBUFDS_GTE (GTY variant) is
# inside corundum_hierarchy/ethernet_core (mrmac_versal_glue, GT_TYPE=GTY).
create_bd_port -dir I gt_ref_clk_p
create_bd_port -dir I gt_ref_clk_n
ad_connect gt_ref_clk_p corundum_hierarchy/gt_ref_clk_p
ad_connect gt_ref_clk_n corundum_hierarchy/gt_ref_clk_n

# QSFP GT serial (4 lanes) out to the GTY transceivers.
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 qsfp_serial
ad_connect corundum_hierarchy/qsfp_serial qsfp_serial

###############################################################################
# 3b. Clocking
###############################################################################
# Datapath + control (clk_corundum) and the GT free-running clock stay on the
# CIPS 100 MHz PL clock (sys_cpu_clk / pl0_ref_clk):
#  - gt_freerun_clk MUST be 100 MHz: the MAC builder ties it to mrmac_0/s_axi_aclk
#    and gtwiz_versal/gtwiz_freerun_clk. sys_cpu_clk is exactly 100 MHz (carrier
#    PMC_CRP_PL0_REF_CTRL_FREQMHZ {100}).
#  - clk_corundum on the same net keeps the datapath + AXI-Lite control path in
#    one domain with the CIPS/FPD control clock, so no CDC is needed there.
# These are driven BEFORE the interconnect helpers so the helpers' associated-
# clock auto-drive sees them already connected and is a no-op.
ad_connect corundum_hierarchy/clk_corundum    sys_cpu_clk
ad_connect corundum_hierarchy/gt_freerun_clk  sys_cpu_clk

# MRMAC client + PTP-timestamp clocks. These used to come from ONE clk_wizard INSIDE
# the companion network (corundum_vck190_mac.tcl created it there); they are here now
# so both frequencies are visible at the top level and can be shared -- a second
# MRMAC port, or any consumer logic touching the MRMAC client interface, needs the
# same 390.625 MHz clock and should not have to reach into corundum_hierarchy for it.
#
# TWO SEPARATE GENERATORS, each using its clk_out1:
#   corundum_mac_clkgen (MMCM)   clk_out1 = 390.625 MHz -> mrmac_axis_clk
#   corundum_mac_ts_clkgen (PLL) clk_out1 = 250 MHz     -> mrmac_ts_clk
# Not two outputs of one primitive: 390.625 and 250 MHz cannot both be produced from
# a single 100 MHz-fed MMCM, because their ratio (25/16) forces one of the two output
# divides to be fractional while the VCO stays in range, and only one output per
# primitive supports a fractional divide. Separate primitives sidestep that.
#
# BOTH FREQUENCIES ARE CONSTRAINED BY THE MRMAC, NOT FREE CHOICES:
#   390.625 MHz (mrmac_axis_clk) - the MRMAC non-segmented independent mode client
#     clock. 100 Gb/s across the 6x64 = 384-bit bus needs 260.4 MHz as an absolute
#     floor; 390.625 MHz is what the IP specifies and what the 1536-bit NECK width
#     conversion in mrmac_gty_wrapper was sized against.
#   250 MHz (mrmac_ts_clk) - the PTP timestamp clock. It MUST be slower than the
#     client clock: MRMAC caps ts_clk at 50-350 MHz. Its period must equal the IP's
#     CONFIG.TIMESTAMP_CLK_PERIOD_NS (4.0 ns), set in corundum_vck190_mac.tcl --
#     change one and you must change the other, or the MRMAC PTP timer's
#     auto-increment rate is silently wrong.
#
# Both driven from sys_cpu_clk (the CIPS 100 MHz PL clock), the same free-running
# source the companion network's clk_wizard used via gt_freerun_clk.
ad_ip_instance clk_wizard corundum_mac_clkgen
ad_ip_parameter corundum_mac_clkgen CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY \
  {390.625,100.000,100.000,100.000,100.000,100.000,100.000}
ad_ip_parameter corundum_mac_clkgen CONFIG.CLKOUT_USED \
  {true,false,false,false,false,false,false}
ad_ip_parameter corundum_mac_clkgen CONFIG.PRIM_SOURCE {Global_buffer}

ad_ip_instance clk_wizard corundum_mac_ts_clkgen
ad_ip_parameter corundum_mac_ts_clkgen CONFIG.PRIMITIVE_TYPE {PLL}
ad_ip_parameter corundum_mac_ts_clkgen CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY \
  {250.000,100.000,100.000,100.000,100.000,100.000,100.000}
ad_ip_parameter corundum_mac_ts_clkgen CONFIG.CLKOUT_USED \
  {true,false,false,false,false,false,false}
ad_ip_parameter corundum_mac_ts_clkgen CONFIG.PRIM_SOURCE {Global_buffer}

ad_connect corundum_mac_clkgen/clk_in1    sys_cpu_clk
ad_connect corundum_mac_ts_clkgen/clk_in1 sys_cpu_clk
ad_connect corundum_hierarchy/mrmac_axis_clk corundum_mac_clkgen/clk_out1
ad_connect corundum_hierarchy/mrmac_ts_clk   corundum_mac_ts_clkgen/clk_out1

# PTP hardware clock - its OWN domain, mirroring VCU118 Corundum EXACTLY. On VCU118:
#   ptp_clk        <- qsfp_mgt_refclk_bufg (156.25 MHz, PTP_CLK_PERIOD_NS = 32/5)
#   ptp_sample_clk <- clk_125mhz (a SEPARATE, asynchronous clock, CDC sampling only)
# qsfp_mgt_refclk_bufg is a BUFG'd copy of the 156.25 MHz GT reference clock (the
# board MGT refclk tapped into the fabric via IBUFDS_GTE.ODIV2 -> BUFG_GT). The
# MRMAC glue now reproduces that tap and exposes it on the hierarchy boundary as
# ptp_refclk_bufg (an OUTPUT). With the GT refclk set to 156.25 MHz (see the MAC
# builder GT_REF_CLK_FREQ_C0 / INTF*_GT_SETTINGS), this net is exactly 156.25 MHz,
# so drive ptp_clk straight from it and keep PTP_CLK_PERIOD_NS = 32/5 - no
# synthesized clock, the true VCU118 pattern.
ad_connect corundum_hierarchy/ptp_clk corundum_hierarchy/ptp_refclk_bufg

# PTP sample clock: a genuinely separate, asynchronous free-running clock (as on
# VCU118, where it is a different clock from ptp_clk and used only to sample the
# PTP ToD counter across a CDC). Use the carrier's second PL clock sys_350m_clk
# (pl1_ref_clk = 334 MHz per the CIPS config) - async to both ptp_clk and the
# 100 MHz datapath, which is exactly the intent.
ad_connect corundum_hierarchy/ptp_sample_clk sys_350m_clk

###############################################################################
# 3c. Resets
###############################################################################
# MAC/GT companion-network reset (active-low): drive from the carrier's
# active-low system reset (sys_rstgen/peripheral_aresetn).
ad_connect corundum_hierarchy/mac_resetn sys_cpu_resetn

# PTP reset (active-high), synchronous to ptp_clk. Generated by a dedicated
# proc_sys_reset in the 156.25 MHz PTP domain (clocked by the same BUFG'd GT
# refclk that drives ptp_clk), driven from the CIPS pl0_resetn - the same source
# and wiring as the carrier's sys_rstgen / sys_350m_rstgen. corundum_core's
# ptp_rst pin is active-high, matching proc_sys_reset's peripheral_reset (VCU118
# likewise feeds ptp_rst an ACTIVE_HIGH reset).
ad_ip_instance proc_sys_reset corundum_ptp_rstgen
ad_ip_parameter corundum_ptp_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_connect corundum_ptp_rstgen/slowest_sync_clk corundum_hierarchy/ptp_refclk_bufg
ad_connect corundum_ptp_rstgen/ext_reset_in     sys_cips/pl0_resetn
ad_connect corundum_hierarchy/ptp_rst corundum_ptp_rstgen/peripheral_reset

# corundum_rstgen (proc_sys_reset created by corundum.tcl at /). Its
# peripheral_reset already drives corundum_hierarchy/rst_corundum. Drive its clock
# and external reset from the CIPS, exactly as the carrier drives sys_rstgen.
ad_connect corundum_rstgen/slowest_sync_clk sys_cpu_clk
ad_connect corundum_rstgen/ext_reset_in     sys_cips/pl0_resetn

###############################################################################
# 3d. AXI host path - control, DMA (NoC), interrupt
###############################################################################
# Control + MAC/GT register slaves onto the CIPS FPD master (ad_cpu_interconnect
# -> sys_cips/M_AXI_FPD on Versal). AXIL_CTRL_ADDR_WIDTH=24 (16 MB) per the cfg.
ad_cpu_interconnect 0x46000000 corundum_hierarchy s_axil_corundum
ad_cpu_interconnect 0x47000000 corundum_hierarchy s_axi_mac
ad_cpu_interconnect 0x48000000 corundum_hierarchy s_axi_gt

# Corundum DMA master -> host memory via the carrier's NoC (ad_mem_hp0_interconnect
# adds a new SI to axi_noc_0, associates the clock, and maps C0_DDR_LOW0 on Versal).
ad_mem_hp0_interconnect sys_cpu_clk corundum_hierarchy/m_axi

# Single interrupt line (corundum_core OR-reduces IRQ_COUNT internally -> scalar
# irq). ps-5 -> sys_cips/pl_ps_irq5 (irq0 is taken by the carrier's axi_gpio).
ad_cpu_interrupt "ps-5" "mb-5" corundum_hierarchy/irq

# #system ID
# ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
# ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
# ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

# sysid_gen_sys_init_file
