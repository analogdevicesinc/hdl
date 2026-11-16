####################################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
####################################################################################

PROJECT_NAME := corundum_100g_vck190

export BOARD := VCK190
export CPU := versal

M_DEPS += system_bd.tcl
M_DEPS += system_top.v
M_DEPS += system_constr.xdc
M_DEPS += ../../../common/vck190/vck190_system_constr.xdc
M_DEPS += ../../../common/vck190/vck190_system_bd.tcl
M_DEPS += ../../../common/vmk180/vmk180_system_bd.tcl
M_DEPS += ../../../../library/common/ad_iobuf.v
M_DEPS += ../../../../library/corundum/scripts/corundum_common_cfg.tcl
M_DEPS += ../../../../library/corundum/scripts/corundum_vck190_cfg.tcl
M_DEPS += ../../../../library/corundum/scripts/corundum.tcl
M_DEPS += ../../../../library/corundum/scripts/corundum_vck190_mac.tcl
M_DEPS += ../../../../library/corundum/scripts/sync_reset.tcl
M_DEPS += ../../../../library/corundum/scripts/mrmac_gty_wrapper.tcl
M_DEPS += ../../../../library/corundum/versal/mrmac_versal_glue.v
M_DEPS += ../../../../library/corundum/versal/mrmac_init.v
M_DEPS += ../../../../library/corundum/versal/mrmac_gt_regs.v
M_DEPS += ../../../../library/util_cdc/sync_bits.v
M_DEPS += ../../../../library/util_cdc/sync_event.v
M_DEPS += ../../../../library/util_cdc/sync_data.v

EXTERNAL_DEPS += ../../../../../corundum/fpga/common/syn/vivado/rb_drp.tcl
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/syn/vivado/mqnic_port.tcl
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl

LIB_DEPS += axi_sysid
LIB_DEPS += sysid_rom
LIB_DEPS += corundum/corundum_core
LIB_DEPS += corundum/ethernet/vck190

include ../../../scripts/project-xilinx.mk
