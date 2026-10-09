####################################################################################
## Copyright (c) 2026 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################

LIBRARY_NAME := spi_translator

GENERIC_DEPS += ../common/ad_mem.v
GENERIC_DEPS += spi_translator_slave.v
GENERIC_DEPS += spi_translator.v
GENERIC_DEPS += spi_translator_decoder.v
GENERIC_DEPS += spi_translator_execution.v
GENERIC_DEPS += spi_translator_regmap.v

XILINX_DEPS += spi_translator_ip.tcl

XILINX_DEPS += ../spi_engine/interfaces/spi_engine_ctrl.xml
XILINX_DEPS += ../spi_engine/interfaces/spi_engine_ctrl_rtl.xml

XILINX_LIB_DEPS += util_axis_fifo
XILINX_LIB_DEPS += util_cdc

XILINX_INTERFACE_DEPS += spi_engine/interfaces

include ../scripts/library.mk
