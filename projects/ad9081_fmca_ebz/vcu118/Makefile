####################################################################################
## Copyright (c) 2018 - 2025 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################

PROJECT_NAME := ad9081_fmca_ebz_vcu118

M_DEPS += timing_constr.xdc
M_DEPS += ../../scripts/adi_pd.tcl
M_DEPS += ../../common/xilinx/data_offload_bd.tcl
M_DEPS += ../../common/xilinx/dacfifo_bd.tcl
M_DEPS += ../../common/xilinx/adcfifo_bd.tcl
M_DEPS += ../../common/vcu118/vcu118_system_constr.xdc
M_DEPS += ../../common/vcu118/vcu118_system_bd.tcl
M_DEPS += ../../ad9081_fmca_ebz/common/ad9081_fmca_ebz_bd.tcl
M_DEPS += ../../../library/xilinx/scripts/versal_xcvr_subsystem.tcl
M_DEPS += ../../../library/util_hbm/scripts/adi_util_hbm.tcl
M_DEPS += ../../../library/jesd204/scripts/jesd204.tcl
M_DEPS += ../../../library/common/ad_iobuf.v
M_DEPS += ../../../library/common/ad_3w_spi.v
M_DEPS += ../../../library/axi_tdd/scripts/axi_tdd.tcl

LIB_DEPS += axi_dmac
LIB_DEPS += axi_sysid
LIB_DEPS += axi_tdd
LIB_DEPS += data_offload
LIB_DEPS += jesd204/ad_ip_jesd204_tpl_adc
LIB_DEPS += jesd204/ad_ip_jesd204_tpl_dac
LIB_DEPS += jesd204/axi_jesd204_rx
LIB_DEPS += jesd204/axi_jesd204_tx
LIB_DEPS += jesd204/jesd204_rx
LIB_DEPS += jesd204/jesd204_tx
LIB_DEPS += jesd204/jesd204_versal_gt_adapter_rx
LIB_DEPS += jesd204/jesd204_versal_gt_adapter_tx
LIB_DEPS += sysid_rom
LIB_DEPS += util_adcfifo
LIB_DEPS += util_dacfifo
LIB_DEPS += util_do_ram
LIB_DEPS += util_hbm
LIB_DEPS += util_pack/util_cpack2
LIB_DEPS += util_pack/util_upack2
LIB_DEPS += xilinx/axi_adxcvr
LIB_DEPS += xilinx/util_adxcvr

CORUNDUM ?= 0

ifeq ($(CORUNDUM), 1)
	export BOARD := VCU118
	export CPU := MB

	M_DEPS += system_constr_corundum.xdc

	M_DEPS += $(ADI_HDL_DIR)/library/corundum/scripts/corundum_vcu118_cfg.tcl
	M_DEPS += $(ADI_HDL_DIR)/library/corundum/scripts/corundum.tcl
	M_DEPS += $(ADI_HDL_DIR)/library/corundum/scripts/sync_reset.tcl

	EXTERNAL_DEPS += $(ADI_HDL_DIR)/../corundum/fpga/common/syn/vivado/rb_drp.tcl
	EXTERNAL_DEPS += $(ADI_HDL_DIR)/../corundum/fpga/common/syn/vivado/cmac_gty_wrapper.tcl
	EXTERNAL_DEPS += $(ADI_HDL_DIR)/../corundum/fpga/common/syn/vivado/cmac_gty_ch_wrapper.tcl
	EXTERNAL_DEPS += $(ADI_HDL_DIR)/../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl
	EXTERNAL_DEPS += $(ADI_HDL_DIR)/../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl
	EXTERNAL_DEPS += $(ADI_HDL_DIR)/../corundum/fpga/common/syn/vivado/mqnic_port.tcl
	EXTERNAL_DEPS += $(ADI_HDL_DIR)/../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl
	EXTERNAL_DEPS += $(ADI_HDL_DIR)/../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl
	EXTERNAL_DEPS += $(ADI_HDL_DIR)/../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl

	LIB_DEPS += corundum/corundum_core
	LIB_DEPS += corundum/ethernet/vcu118
endif

include ../../scripts/project-xilinx.mk
