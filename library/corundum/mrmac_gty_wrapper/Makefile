####################################################################################
## Copyright (c) 2026 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

LIBRARY_NAME := mrmac_gty_wrapper

XILINX_DEPS += mrmac_gty_wrapper_ip.tcl

# RTL: the wrapper + its two leaf adapters (in the sibling versal/ dir of the
# corundum library) and the Corundum-lib submodules it instantiates. Paths are
# relative to this IP dir; ../../../../ == repo root (hdl/library/corundum/
# mrmac_gty_wrapper -> /); ../versal == hdl/library/corundum/versal.
EXTERNAL_DEPS += ../versal/mrmac_gty_wrapper.v
EXTERNAL_DEPS += ../versal/mrmac_tx_adapt.v
EXTERNAL_DEPS += ../versal/mrmac_rx_adapt.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/cmac_pad.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/axis/rtl/axis_adapter.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/axis/rtl/axis_fifo.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v

# Custom analog.com interfaces used on the fpga_core-facing side.
XILINX_DEPS += ../interfaces/if_flow_control_tx.xml
XILINX_DEPS += ../interfaces/if_flow_control_tx_rtl.xml
XILINX_DEPS += ../interfaces/if_flow_control_rx.xml
XILINX_DEPS += ../interfaces/if_flow_control_rx_rtl.xml

XILINX_INTERFACE_DEPS += corundum/interfaces

include ../../scripts/library.mk
