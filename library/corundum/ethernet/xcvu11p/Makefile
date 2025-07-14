LIBRARY_NAME := ethernet_xcvu11p

GENERIC_DEPS += ethernet_xcvu11p.v

XILINX_DEPS += ethernet_xcvu11p_ip.tcl

EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/mqnic_port_map_mac_axis.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/cmac_gty_wrapper.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/cmac_gty_ch_wrapper.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/rb_drp.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/cmac_pad.v
EXTERNAL_DEPS += ../../../../../corundum/fpga/common/rtl/mac_ts_insert.v

EXTERNAL_DEPS += ../../../../../corundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_usplus.tcl
EXTERNAL_DEPS += ../../../../../corundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_gty.tcl

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
