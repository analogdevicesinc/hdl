###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../common/adsy2301_3_udc_bd.tcl

# Chip2chip

ad_ip_instance axi_chip2chip axi_chip2chip [list \
  C_MASTER_FPGA 0 \
  C_INTERFACE_MODE 1 \
  C_INTERFACE_TYPE 3 \
  C_AXI_DATA_WIDTH 32 \
  C_AXI_STB_WIDTH 16 \
  C_M_AXI_WUSER_WIDTH 0 \
  C_M_AXI_ID_WIDTH 0 \
  C_INCLUDE_AXILITE 0 \
]

# Aurora

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_diff_refclk
create_bd_intf_port -mode Slave -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_RX_rtl:1.0 gt_serial_rx
create_bd_intf_port -mode Master -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_TX_rtl:1.0 gt_serial_tx

set_property -dict [list CONFIG.FREQ_HZ {156250000}] [get_bd_intf_ports gt_diff_refclk]

ad_ip_instance aurora_8b10b aurora_8b10b [list \
  SupportLevel 1 \
  C_AURORA_LANES 2 \
  C_LINE_RATE 3.125 \
  C_REFCLK_FREQUENCY 156.250 \
  interface_mode {Streaming} \
  SINGLEEND_INITCLK {true} \
  C_INIT_CLK 100 \
  DRP_FREQ 100 \
  C_GT_LOC_11 2 \
]

ad_connect sys_cpu_clk axi_chip2chip/m_aclk
ad_connect sys_cpu_resetn axi_chip2chip/m_aresetn

ad_connect axi_smartconnect/S00_AXI axi_chip2chip/m_axi

ad_connect gt_diff_refclk aurora_8b10b/GT_DIFF_REFCLK1
ad_connect gt_serial_rx aurora_8b10b/GT_SERIAL_RX
ad_connect gt_serial_tx aurora_8b10b/GT_SERIAL_TX

ad_connect axi_chip2chip/axi_c2c_phy_clk aurora_8b10b/user_clk_out
ad_connect axi_chip2chip/axi_c2c_aurora_channel_up aurora_8b10b/channel_up
ad_connect sys_cpu_clk axi_chip2chip/aurora_init_clk
ad_connect axi_chip2chip/aurora_mmcm_not_locked aurora_8b10b/pll_not_locked_out
ad_connect axi_chip2chip/AXIS_TX aurora_8b10b/USER_DATA_S_AXI_TX
ad_connect axi_chip2chip/AXIS_RX aurora_8b10b/USER_DATA_M_AXI_RX
ad_connect axi_chip2chip/aurora_pma_init_in sys_cpu_reset
ad_connect sys_cpu_clk aurora_8b10b/drpclk_in
ad_connect sys_cpu_clk aurora_8b10b/init_clk_in
ad_connect aurora_8b10b/reset axi_chip2chip/aurora_reset_pb
ad_connect aurora_8b10b/gt_reset sys_cpu_reset
ad_connect axi_intc/irq axi_chip2chip/axi_c2c_s2m_intr_in

# Address segments

assign_bd_address

set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_axi_intc_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_axi_gpio0_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_axi_gpio1_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_bf_spi_01_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_bf_spi_02_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_bf_spi_03_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_bf_spi_04_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_rf_fl_spi_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_lo_spi_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_tx_spi_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_rx_spi_Reg}]
set_property range 4K [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_axi_udc_iic_Reg}]

set_property offset 0x90000000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_axi_intc_Reg}]
set_property offset 0x90001000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_axi_gpio0_Reg}]
set_property offset 0x90002000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_axi_gpio1_Reg}]
set_property offset 0x90003000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_bf_spi_01_Reg}]
set_property offset 0x90004000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_bf_spi_02_Reg}]
set_property offset 0x90005000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_bf_spi_03_Reg}]
set_property offset 0x90006000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_bf_spi_04_Reg}]
set_property offset 0x9000B000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_rf_fl_spi_Reg}]
set_property offset 0x9000C000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_lo_spi_Reg}]
set_property offset 0x9000D000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_tx_spi_Reg}]
set_property offset 0x9000E000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_rx_spi_Reg}]
set_property offset 0x9000F000 [get_bd_addr_segs {axi_chip2chip/MAXI/SEG_axi_udc_iic_Reg}]
