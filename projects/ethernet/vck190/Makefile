####################################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
####################################################################################
#
# Corundum-on-Versal reference design for the VCK190 (xcvc1902), MRMAC over GTY.
# This is the consumer project for the shared Corundum integrator's VCK190 branch
# in library/corundum/scripts/corundum.tcl. It is the GTY sibling of the VPK180
# (GTM) consumer: same CIPS + NoC host (NO PCIe - the host path is AXI: s_axil
# control from the CPU, m_axi DMA to DDR4 via the NoC, and a single interrupt
# line). The GTM/GTY difference lives entirely in the block design (mrmac_0
# GT_TYPE + gtwiz preset + mrmac_versal_glue GT_TYPE), not here.
#
# The project name MUST contain "_vck190" so adi_project_xilinx.tcl auto-selects
# part xcvc1902-vsva2197-2MP-e-S; do NOT set the part manually.

PROJECT_NAME := ethernet_vck190

# Corundum host contract: the integrator reads $CPU and $BOARD from the environment.
#   BOARD=VCK190 -> selects the VCK190 (MRMAC 1x100GE, GTY) branch in corundum.tcl.
#   CPU=versal   -> any non-"MB" value; skips the MicroBlaze-only GPIO reset branch
#                   (corundum.tcl) so the reset comes from CIPS instead.
export BOARD := VCK190
export CPU := versal

M_DEPS += system_bd.tcl
M_DEPS += system_top.v
M_DEPS += system_constr.xdc
M_DEPS += ../../common/vck190/vck190_system_constr.xdc
# The VCK190 carrier bd sources the vmk180 CIPS/NoC base (same silicon family);
# list both so a change in either triggers a rebuild.
M_DEPS += ../../common/vck190/vck190_system_bd.tcl
M_DEPS += ../../common/vmk180/vmk180_system_bd.tcl
M_DEPS += ../../../library/common/ad_iobuf.v

# Corundum integrator + VCK190 config + MRMAC (GTY) companion-network builder.
M_DEPS += ../../../library/corundum/scripts/corundum_common_cfg.tcl
M_DEPS += ../../../library/corundum/scripts/corundum_vck190_cfg.tcl
M_DEPS += ../../../library/corundum/scripts/corundum.tcl
M_DEPS += ../../../library/corundum/scripts/corundum_vck190_mac.tcl
M_DEPS += ../../../library/corundum/scripts/sync_reset.tcl
M_DEPS += ../../../library/corundum/scripts/mrmac_gty_wrapper.tcl

# Out-of-tree Corundum sources (sibling checkout beside hdl/). These are the
# board-independent scoped-constraint tcls the corundum_core RTL needs; they are
# global project constraints (NOT packaged into the IP - see system_project.tcl).
# The CMAC-specific ones (cmac_gty_wrapper, cmac_gty_ch_wrapper, rb_drp) are
# intentionally dropped - the MRMAC path replaces them with the BD companion network.
EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/mqnic_port.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl

LIB_DEPS += axi_sysid
LIB_DEPS += sysid_rom
LIB_DEPS += corundum/corundum_core
LIB_DEPS += corundum/ethernet/vck190

include ../../scripts/project-xilinx.mk
