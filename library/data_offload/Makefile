####################################################################################
## Copyright (c) 2018 - 2025 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################

LIBRARY_NAME := data_offload

GENERIC_DEPS += ../common/ad_mem_asym.v
GENERIC_DEPS += ../common/ad_mem.v
GENERIC_DEPS += ../common/up_axi.v
GENERIC_DEPS += data_offload.v
GENERIC_DEPS += data_offload_fsm.v
GENERIC_DEPS += data_offload_regmap.v

XILINX_DEPS += data_offload_ip.tcl
XILINX_DEPS += data_offload_sv.ttcl

XILINX_DEPS += ../interfaces/if_do_ctrl.xml
XILINX_DEPS += ../interfaces/if_do_ctrl_rtl.xml

XILINX_LIB_DEPS += util_axis_fifo_asym
XILINX_LIB_DEPS += util_cdc

XILINX_INTERFACE_DEPS += interfaces

INTEL_DEPS += ../util_axis_fifo_asym/util_axis_fifo_asym.v
INTEL_DEPS += ../util_axis_fifo/util_axis_fifo.v
INTEL_DEPS += ../util_axis_fifo/util_axis_fifo_address_generator.v
INTEL_DEPS += ../util_cdc/sync_bits.v
INTEL_DEPS += ../util_cdc/sync_event.v
INTEL_DEPS += ../util_cdc/sync_gray.v
INTEL_DEPS += data_offload_constr.sdc
INTEL_DEPS += data_offload_hw.tcl

include ../scripts/library.mk
