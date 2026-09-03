####################################################################################
## Copyright (c) 2026 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

LIBRARY_NAME := ethernet_vck190

GENERIC_DEPS += ethernet_vck190.v

XILINX_DEPS += ethernet_vck190_ip.tcl

# RTL sources. The vck190 IP dir is 5 levels below repo root
# (hdl/library/corundum/ethernet/vck190 -> /), so ../../../../../ == root.
#
# vs VCU118: the CMAC MAC/PHY chain (cmac_gty_wrapper/cmac_gty_ch_wrapper/rb_drp/
# mac_ts_insert + the cmac_usplus/cmac_gty IP .tcl) is REPLACED by the four
# mrmac_gty_wrapper MAC-shims and the two MRMAC adapters. The MRMAC hard IP
# itself is NOT here - it is a BD cell built by corundum.tcl.
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/mqnic_port_map_mac_axis.v
# rb_drp: the per-port DRP register block, same source file VCU118 uses
# (ethernet/vcu118/Makefile:11).
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/rb_drp.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v
EXTERNAL_DEPS += ../../versal/mrmac_gty_wrapper.v
EXTERNAL_DEPS += ../../versal/mrmac_tx_adapt.v
EXTERNAL_DEPS += ../../versal/mrmac_rx_adapt.v
# PTP path (VCU118-faithful): 55<->80b format converter, system-timer discipline
# FSM, and the RX timestamp inserter. Instantiated by mrmac_gty_wrapper.
EXTERNAL_DEPS += ../../versal/mrmac_ptp_ts_cvt.v
EXTERNAL_DEPS += ../../versal/mrmac_ptp_sync.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/mac_ts_insert.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/cmac_pad.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/axis/rtl/axis_adapter.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/axis/rtl/axis_fifo.v

# Custom analog.com interfaces used on the fpga_core-facing side. vs VCU118:
# QSPI/QSFP/I2C physical interfaces are dropped (no board physical here); the
# core<->MAC contract (ctrl_reg + flow_control + ptp) is kept identical.
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
