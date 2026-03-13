####################################################################################
## Copyright (c) 2018 - 2023, 2026 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################

PROJECT_NAME := template_vcu118

M_DEPS += ../../scripts/adi_pd.tcl
M_DEPS += ../../common/vcu118/vcu118_system_constr.xdc
M_DEPS += ../../common/vcu118/vcu118_system_bd.tcl
M_DEPS += ../../../library/common/ad_iobuf.v

LIB_DEPS += axi_sysid
LIB_DEPS += sysid_rom

CORUNDUM ?= 0

ifeq ($(CORUNDUM), 1)
	export BOARD := VCU118
	export CPU := MB

	M_DEPS += vcu118_qsfp_system_constr.xdc
	M_DEPS += ../../common/vcu118/vcu118_corundum_bd.tcl
	M_DEPS += ../../../library/corundum/scripts/corundum_vcu118_cfg.tcl
	M_DEPS += ../../../library/corundum/scripts/corundum.tcl
	M_DEPS += ../../../library/corundum/scripts/sync_reset.tcl

	EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/rb_drp.tcl
	EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/cmac_gty_wrapper.tcl
	EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/cmac_gty_ch_wrapper.tcl
	EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl
	EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl
	EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/mqnic_port.tcl
	EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl
	EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl
	EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl

	LIB_DEPS += corundum/corundum_core
	LIB_DEPS += corundum/ethernet/vcu118
endif

include ../../scripts/project-xilinx.mk
