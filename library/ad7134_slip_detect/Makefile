####################################################################################
## Copyright (c) 2026 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
####################################################################################

LIBRARY_NAME := ad7134_slip_detect

GENERIC_DEPS += ../common/ad_rst.v
GENERIC_DEPS += ../common/up_axi.v
GENERIC_DEPS += ad7134_slip_detect.v
GENERIC_DEPS += ad7134_slip_detect_pair.v
GENERIC_DEPS += ad7134_slip_detect_regmap.v

XILINX_DEPS += ../xilinx/common/ad_rst_constr.xdc
XILINX_DEPS += ad7134_slip_detect_constr.sdc
XILINX_DEPS += ad7134_slip_detect_ip.tcl

XILINX_LIB_DEPS += util_cdc

include ../scripts/library.mk
