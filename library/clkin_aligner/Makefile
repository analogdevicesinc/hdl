####################################################################################
## Copyright (c) 2026 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
####################################################################################

LIBRARY_NAME := clkin_aligner

GENERIC_DEPS += ../common/ad_rst.v
GENERIC_DEPS += ../common/up_axi.v
GENERIC_DEPS += clkin_aligner.v
GENERIC_DEPS += clkin_aligner_regmap.v

XILINX_DEPS += ../xilinx/common/ad_rst_constr.xdc
XILINX_DEPS += clkin_aligner_constr.sdc
XILINX_DEPS += clkin_aligner_ip.tcl

XILINX_LIB_DEPS += util_cdc

include ../scripts/library.mk
