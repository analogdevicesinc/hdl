####################################################################################
## Copyright (c) 2026 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

LIBRARY_NAME := ethernet_vck190

GENERIC_DEPS += ethernet_vck190.v

XILINX_DEPS += ethernet_vck190_ip.tcl

EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/mqnic_port_map_mac_axis.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/rb_drp.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v
EXTERNAL_DEPS += ../../versal/mrmac_gty_wrapper.v
EXTERNAL_DEPS += ../../versal/mrmac_tx_adapt.v
EXTERNAL_DEPS += ../../versal/mrmac_rx_adapt.v
EXTERNAL_DEPS += ../../versal/mrmac_ptp_ts_cvt.v
EXTERNAL_DEPS += ../../versal/mrmac_ptp_sync.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/mac_ts_insert.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/cmac_pad.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/axis/rtl/axis_adapter.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/axis/rtl/axis_fifo.v

XILINX_DEPS  += ../../interfaces/if_ctrl_reg.xml
XILINX_DEPS  += ../../interfaces/if_ctrl_reg_rtl.xml
XILINX_DEPS  += ../../interfaces/if_flow_control_tx.xml
XILINX_DEPS  += ../../interfaces/if_flow_control_tx_rtl.xml
XILINX_DEPS  += ../../interfaces/if_flow_control_rx.xml
XILINX_DEPS  += ../../interfaces/if_flow_control_rx_rtl.xml
XILINX_DEPS  += ../../interfaces/if_ethernet_ptp.xml
XILINX_DEPS  += ../../interfaces/if_ethernet_ptp_rtl.xml
XILINX_DEPS  += ../../interfaces/if_axis_tx_ptp.xml
XILINX_DEPS  += ../../interfaces/if_axis_tx_ptp_rtl.xml

XILINX_INTERFACE_DEPS += corundum/interfaces

include ../../../scripts/library.mk
