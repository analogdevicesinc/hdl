LIBRARY_NAME := ethernet

XILINX_DEPS += ethernet_ip.tcl

GENERIC_DEPS += ethernet_core_k26.v
GENERIC_DEPS += ethernet_core_vcu118.v

EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/mqnic_port_map_mac_axis.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/cmac_gty_wrapper.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/cmac_gty_ch_wrapper.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/cmac_pad.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/mac_ts_insert.v
EXTERNAL_DEPS += ../../../../corundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_usplus.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_gty.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/mqnic/KR260/fpga/ip/eth_xcvr_gth.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/eth_xcvr_phy_10g_gty_quad_wrapper.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/eth_xcvr_phy_10g_gty_wrapper.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/mqnic_port_map_phy_xgmii.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/rb_drp.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/tdma_scheduler.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/tdma_ber.v
EXTERNAL_DEPS += ../../../../corundum/fpga/common/rtl/tdma_ber_ch.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/eth_mac_10g.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/axis_xgmii_rx_64.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/axis_xgmii_rx_32.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/axis_xgmii_tx_64.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/axis_xgmii_tx_32.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/mac_ctrl_rx.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/mac_ctrl_tx.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/mac_pause_ctrl_rx.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/mac_pause_ctrl_tx.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/lfsr.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/eth_phy_10g_tx_if.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/eth_phy_10g_tx.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_frame_sync.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/eth_phy_10g.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_if.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_ber_mon.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_watchdog.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/xgmii_baser_dec_64.v
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/rtl/xgmii_baser_enc_64.v

XILINX_DEPS  += ../interfaces/if_ctrl_reg.xml
XILINX_DEPS  += ../interfaces/if_ctrl_reg_rtl.xml
XILINX_DEPS  += ../interfaces/if_ptp.xml
XILINX_DEPS  += ../interfaces/if_ptp_rtl.xml
XILINX_DEPS  += ../interfaces/if_flow_control_tx.xml
XILINX_DEPS  += ../interfaces/if_flow_control_tx_rtl.xml
XILINX_DEPS  += ../interfaces/if_flow_control_rx.xml
XILINX_DEPS  += ../interfaces/if_flow_control_rx_rtl.xml
XILINX_DEPS  += ../interfaces/if_ethernet_ptp.xml
XILINX_DEPS  += ../interfaces/if_ethernet_ptp_rtl.xml
XILINX_DEPS  += ../interfaces/if_axis_tx_ptp.xml
XILINX_DEPS  += ../interfaces/if_axis_tx_ptp_rtl.xml
XILINX_DEPS  += ../interfaces/if_qspi.xml
XILINX_DEPS  += ../interfaces/if_qspi_rtl.xml
XILINX_DEPS  += ../interfaces/if_sfp.xml
XILINX_DEPS  += ../interfaces/if_sfp_rtl.xml
XILINX_DEPS  += ../interfaces/if_qsfp.xml
XILINX_DEPS  += ../interfaces/if_qsfp_rtl.xml
XILINX_DEPS  += ../interfaces/if_i2c.xml
XILINX_DEPS  += ../interfaces/if_i2c_rtl.xml

XILINX_INTERFACE_DEPS += corundum/interfaces

GENERIC_DEPS += board.env

.PHONY: always-rebuild

all: board.env

board.env : always-rebuild
	echo $(BOARD) > board.tmp
	diff -N board.env board.tmp 1> /dev/null || cp board.tmp board.env
	rm -f board.tmp

include ../../scripts/library.mk

