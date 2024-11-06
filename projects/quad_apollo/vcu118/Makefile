####################################################################################
## Copyright (c) 2024 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################

hdl_generic_location := $(wildcard ../../../../hdl)
ifndef ADI_HDL_DIR
  ifeq ($(hdl_generic_location),)
    $(error ADI_HDL_DIR is not defined! e.g. export ADI_HDL_DIR=/media/data/github/hdl)
  else
    ADI_HDL_DIR := $(realpath $(hdl_generic_location))
    export ADI_HDL_DIR=$(realpath $(hdl_generic_location))
  endif
endif

ifndef ADI_GHDL_DIR
  export ADI_GHDL_DIR=$(shell dirname $(shell dirname $(shell dirname $(shell pwd))))
endif

PROJECT_NAME := ad_xband16_ebz_vcu118

M_DEPS += timing_constr.xdc
M_DEPS += ../common/clk_spi.v
M_DEPS += ../common/hsci_phy_top.sv
M_DEPS += ${ADI_HDL_DIR}/projects/scripts/adi_pd.tcl
M_DEPS += ${ADI_HDL_DIR}/projects/common/xilinx/data_offload_bd.tcl
M_DEPS += ${ADI_HDL_DIR}/projects/common/xilinx/dacfifo_bd.tcl
M_DEPS += ${ADI_HDL_DIR}/projects/common/xilinx/adcfifo_bd.tcl
M_DEPS += ${ADI_HDL_DIR}/projects/common/vcu118/vcu118_system_constr.xdc
M_DEPS += ${ADI_HDL_DIR}/projects/common/vcu118/vcu118_system_bd.tcl
M_DEPS += ${ADI_HDL_DIR}/library/util_hbm/scripts/adi_util_hbm.tcl
M_DEPS += ${ADI_HDL_DIR}/library/jesd204/scripts/jesd204.tcl
M_DEPS += ${ADI_HDL_DIR}/library/common/ad_iobuf.v
M_DEPS += ${ADI_HDL_DIR}/library/common/ad_3w_spi.v
M_DEPS += ${ADI_HDL_DIR}/library/common/ad_rst.v
M_DEPS += ${ADI_HDL_DIR}/library/xilinx/common/ad_rst_constr.xdc
M_DEPS += ../../quad_apollo/common/ad_xband16_ebz_bd.tcl

# LIB_GHDL_DEPS += axi_adf4030

LIB_DEPS += axi_dmac
LIB_DEPS += axi_sysid
LIB_DEPS += axi_tdd
LIB_DEPS += axi_hsci
LIB_DEPS += axi_adf4030
LIB_DEPS += axi_clkgen
LIB_DEPS += data_offload
LIB_DEPS += jesd204/ad_ip_jesd204_tpl_adc
LIB_DEPS += jesd204/ad_ip_jesd204_tpl_dac
LIB_DEPS += jesd204/axi_jesd204_rx
LIB_DEPS += jesd204/axi_jesd204_tx
LIB_DEPS += jesd204/jesd204_rx
LIB_DEPS += jesd204/jesd204_tx
LIB_DEPS += sysid_rom
LIB_DEPS += util_adcfifo
LIB_DEPS += util_dacfifo
LIB_DEPS += util_do_ram
LIB_DEPS += util_hbm
LIB_DEPS += util_pack/util_cpack2
LIB_DEPS += util_pack/util_upack2
LIB_DEPS += util_tdd_sync
LIB_DEPS += xilinx/axi_adxcvr
LIB_DEPS += xilinx/util_adxcvr

include $(ADI_HDL_DIR)/projects/scripts/project-xilinx.mk

debug:
	@echo "hdl dir: ${ADI_HDL_DIR}"
	@echo "ghdl dir: ${ADI_GHDL_DIR}"