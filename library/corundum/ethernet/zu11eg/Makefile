LIBRARY_NAME := ethernet_zu11eg

GENERIC_DEPS += ethernet_zu11eg.v
GENERIC_DEPS += eth_xcvr_phy_100g_gth_wrapper.v
GENERIC_DEPS += eth_xcvr_phy_100g_gth_quad_wrapper.v

XILINX_DEPS += ethernet_zu11eg_ip.tcl
XILINX_DEPS += cmac_usplus.tcl
XILINX_DEPS += eth_xcvr_gth.tcl

EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/mqnic_port_map_mac_axis.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/rb_drp.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/cmac_pad.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/mac_ts_insert.v

XILINX_DEPS  += ../../interfaces/if_ctrl_reg.xml
XILINX_DEPS  += ../../interfaces/if_ctrl_reg_rtl.xml
XILINX_DEPS  += ../../interfaces/if_ptp.xml
XILINX_DEPS  += ../../interfaces/if_ptp_rtl.xml
XILINX_DEPS  += ../../interfaces/if_flow_control_tx.xml
XILINX_DEPS  += ../../interfaces/if_flow_control_tx_rtl.xml
XILINX_DEPS  += ../../interfaces/if_flow_control_rx.xml
XILINX_DEPS  += ../../interfaces/if_flow_control_rx_rtl.xml
XILINX_DEPS  += ../../interfaces/if_ethernet_ptp.xml
XILINX_DEPS  += ../../interfaces/if_ethernet_ptp_rtl.xml
XILINX_DEPS  += ../../interfaces/if_axis_tx_ptp.xml
XILINX_DEPS  += ../../interfaces/if_axis_tx_ptp_rtl.xml
XILINX_DEPS  += ../../interfaces/if_qspi.xml
XILINX_DEPS  += ../../interfaces/if_qspi_rtl.xml
XILINX_DEPS  += ../../interfaces/if_qsfp.xml
XILINX_DEPS  += ../../interfaces/if_qsfp_rtl.xml
XILINX_DEPS  += ../../interfaces/if_i2c.xml
XILINX_DEPS  += ../../interfaces/if_i2c_rtl.xml

XILINX_INTERFACE_DEPS += corundum/interfaces

include ../../../scripts/library.mk
