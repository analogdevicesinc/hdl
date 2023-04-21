####################################################################################
## Copyright 2018(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################

PROJECT_NAME := adrv9026_zcu102

M_DEPS += ../common/adrv9026_bd.tcl
M_DEPS += $(ADI_HDL_DIR)/projects/common/zcu102/zcu102_system_constr.xdc
M_DEPS += $(ADI_HDL_DIR)/projects/common/zcu102/zcu102_system_bd.tcl
M_DEPS += $(ADI_HDL_DIR)/projects/common/xilinx/dacfifo_bd.tcl
M_DEPS += $(ADI_HDL_DIR)/library/common/ad_iobuf.v
M_DEPS += $(ADI_HDL_DIR)/library/jesd204/scripts/jesd204.tcl

LIB_DEPS += axi_dmac
LIB_DEPS += axi_sysid
LIB_DEPS += jesd204/ad_ip_jesd204_tpl_adc
LIB_DEPS += jesd204/ad_ip_jesd204_tpl_dac
LIB_DEPS += jesd204/axi_jesd204_rx
LIB_DEPS += jesd204/axi_jesd204_tx
LIB_DEPS += jesd204/jesd204_rx
LIB_DEPS += jesd204/jesd204_tx
LIB_DEPS += sysid_rom
LIB_DEPS += util_dacfifo
LIB_DEPS += util_pack/util_cpack2
LIB_DEPS += util_pack/util_upack2
LIB_DEPS += xilinx/axi_adxcvr
LIB_DEPS += xilinx/util_adxcvr

ifndef ADI_HDL_DIR
$(error ADI_HDL_DIR is not set)
endif

include $(ADI_HDL_DIR)/projects/scripts/project-xilinx.mk
