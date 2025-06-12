###############################################################################
## Copyright (C) 2020-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_cell -type hier corundum_hierarchy
current_bd_instance /corundum_hierarchy

create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axil_corundum
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axil_application

create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi

create_bd_pin -dir I -type clk clk_250mhz
create_bd_pin -dir I -type rst rst_250mhz

create_bd_pin -dir I sfp_rx_p
create_bd_pin -dir I sfp_rx_n
create_bd_pin -dir O sfp_tx_p
create_bd_pin -dir O sfp_tx_n
create_bd_pin -dir I sfp_mgt_refclk_p
create_bd_pin -dir I sfp_mgt_refclk_n

create_bd_pin -dir O sfp_tx_disable
create_bd_pin -dir I sfp_tx_fault
create_bd_pin -dir I sfp_rx_los
create_bd_pin -dir I sfp_mod_abs

create_bd_pin -dir O -from 1 -to 0 sfp_led

create_bd_pin -dir O -type intr irq

create_bd_pin -dir IO sfp_i2c_scl
create_bd_pin -dir IO sfp_i2c_sda

ad_ip_instance ethernet ethernet_core [list \
  IF_COUNT $IF_COUNT \
  PORTS_PER_IF $PORTS_PER_IF \
  PORT_MASK $PORT_MASK \
  PTP_TS_ENABLE $PTP_TS_ENABLE \
  ENABLE_PADDING $ENABLE_PADDING \
  ENABLE_DIC $ENABLE_DIC \
  MIN_FRAME_LENGTH $MIN_FRAME_LENGTH \
  PFC_ENABLE $PFC_ENABLE \
]

ad_ip_instance corundum_core corundum_core [list \
  FPGA_ID $FPGA_ID \
  FW_ID $FW_ID \
  FW_VER $FW_VER \
  BOARD_ID $BOARD_ID \
  BOARD_VER $BOARD_VER \
  BUILD_DATE $BUILD_DATE \
  GIT_HASH $GIT_HASH \
  RELEASE_INFO $RELEASE_INFO \
  IF_COUNT $IF_COUNT \
  PORTS_PER_IF $PORTS_PER_IF \
  SCHED_PER_IF $SCHED_PER_IF \
  PORT_COUNT $PORT_COUNT \
  CLK_PERIOD_NS_NUM $CLK_PERIOD_NS_NUM \
  CLK_PERIOD_NS_DENOM $CLK_PERIOD_NS_DENOM \
  PTP_CLOCK_PIPELINE $PTP_CLOCK_PIPELINE \
  PTP_CLOCK_CDC_PIPELINE $PTP_CLOCK_CDC_PIPELINE \
  PTP_PORT_CDC_PIPELINE $PTP_PORT_CDC_PIPELINE \
  PTP_PEROUT_ENABLE $PTP_PEROUT_ENABLE \
  PTP_PEROUT_COUNT $PTP_PEROUT_COUNT \
  EVENT_QUEUE_OP_TABLE_SIZE $EVENT_QUEUE_OP_TABLE_SIZE \
  TX_QUEUE_OP_TABLE_SIZE $TX_QUEUE_OP_TABLE_SIZE \
  RX_QUEUE_OP_TABLE_SIZE $RX_QUEUE_OP_TABLE_SIZE \
  CQ_OP_TABLE_SIZE $CQ_OP_TABLE_SIZE \
  EQN_WIDTH $EQN_WIDTH \
  TX_QUEUE_INDEX_WIDTH $TX_QUEUE_INDEX_WIDTH \
  RX_QUEUE_INDEX_WIDTH $RX_QUEUE_INDEX_WIDTH \
  CQN_WIDTH $CQN_WIDTH \
  EQ_PIPELINE $EQ_PIPELINE \
  TX_QUEUE_PIPELINE $TX_QUEUE_PIPELINE \
  RX_QUEUE_PIPELINE $RX_QUEUE_PIPELINE \
  CQ_PIPELINE $CQ_PIPELINE \
  TX_DESC_TABLE_SIZE $TX_DESC_TABLE_SIZE \
  RX_DESC_TABLE_SIZE $RX_DESC_TABLE_SIZE \
  RX_INDIR_TBL_ADDR_WIDTH $RX_INDIR_TBL_ADDR_WIDTH \
  TX_SCHEDULER_OP_TABLE_SIZE $TX_SCHEDULER_OP_TABLE_SIZE \
  TX_SCHEDULER_PIPELINE $TX_SCHEDULER_PIPELINE \
  TDMA_INDEX_WIDTH $TDMA_INDEX_WIDTH \
  PTP_TS_ENABLE $PTP_TS_ENABLE \
  TX_CPL_FIFO_DEPTH $TX_CPL_FIFO_DEPTH \
  TX_CHECKSUM_ENABLE $TX_CHECKSUM_ENABLE \
  RX_HASH_ENABLE $RX_HASH_ENABLE \
  RX_CHECKSUM_ENABLE $RX_CHECKSUM_ENABLE \
  TX_FIFO_DEPTH $TX_FIFO_DEPTH \
  RX_FIFO_DEPTH $RX_FIFO_DEPTH \
  MAX_TX_SIZE $MAX_TX_SIZE \
  MAX_RX_SIZE $MAX_RX_SIZE \
  TX_RAM_SIZE $TX_RAM_SIZE \
  RX_RAM_SIZE $RX_RAM_SIZE \
  APP_ENABLE $APP_ENABLE \
  APP_ID $APP_ID \
  APP_CTRL_ENABLE $APP_CTRL_ENABLE \
  APP_DMA_ENABLE $APP_DMA_ENABLE \
  APP_AXIS_DIRECT_ENABLE $APP_AXIS_DIRECT_ENABLE \
  APP_AXIS_SYNC_ENABLE $APP_AXIS_SYNC_ENABLE \
  APP_AXIS_IF_ENABLE $APP_AXIS_IF_ENABLE \
  APP_STAT_ENABLE $APP_STAT_ENABLE \
  AXI_DATA_WIDTH $AXI_DATA_WIDTH \
  AXI_ADDR_WIDTH $AXI_ADDR_WIDTH \
  AXI_ID_WIDTH $AXI_ID_WIDTH \
  DMA_IMM_ENABLE $DMA_IMM_ENABLE \
  DMA_IMM_WIDTH $DMA_IMM_WIDTH \
  DMA_LEN_WIDTH $DMA_LEN_WIDTH \
  DMA_TAG_WIDTH $DMA_TAG_WIDTH \
  RAM_ADDR_WIDTH $RAM_ADDR_WIDTH \
  RAM_PIPELINE $RAM_PIPELINE \
  AXI_DMA_MAX_BURST_LEN $AXI_DMA_MAX_BURST_LEN \
  IRQ_COUNT $IRQ_COUNT \
  AXIL_CTRL_DATA_WIDTH $AXIL_CTRL_DATA_WIDTH \
  AXIL_CTRL_ADDR_WIDTH $AXIL_CTRL_ADDR_WIDTH \
  AXIL_APP_CTRL_DATA_WIDTH $AXIL_APP_CTRL_DATA_WIDTH \
  AXIL_APP_CTRL_ADDR_WIDTH $AXIL_APP_CTRL_ADDR_WIDTH \
  STAT_ENABLE $STAT_ENABLE \
  STAT_DMA_ENABLE $STAT_DMA_ENABLE \
  STAT_AXI_ENABLE $STAT_AXI_ENABLE \
  STAT_INC_WIDTH $STAT_INC_WIDTH \
  STAT_ID_WIDTH $STAT_ID_WIDTH
]

ad_connect corundum_core/s_axil_ctrl s_axil_corundum
ad_connect corundum_core/m_axis_tx ethernet_core/axis_eth_tx
ad_connect corundum_core/s_axis_rx ethernet_core/axis_eth_rx
ad_connect corundum_core/flow_control_tx ethernet_core/flow_control_tx
ad_connect corundum_core/flow_control_rx ethernet_core/flow_control_rx

ad_connect corundum_core/ptp_clk ethernet_core/ptp_clk
ad_connect corundum_core/ptp_rst ethernet_core/ptp_rst
ad_connect corundum_core/ptp_sample_clk ethernet_core/ptp_sample_clk

ad_connect corundum_core/tx_ptp_ts ethernet_core/eth_tx_ptp_ts
ad_connect corundum_core/tx_ptp_ts_step ethernet_core/eth_tx_ptp_ts_step
ad_connect corundum_core/rx_ptp_ts ethernet_core/eth_rx_ptp_ts
ad_connect corundum_core/rx_ptp_ts_step ethernet_core/eth_rx_ptp_ts_step
ad_connect corundum_core/axis_tx_ptp ethernet_core/axis_tx_ptp

ad_connect corundum_core/eth_rx_clk ethernet_core/eth_rx_clk
ad_connect corundum_core/eth_rx_rst ethernet_core/eth_rx_rst

ad_connect corundum_core/m_axi m_axi

ad_connect corundum_core/clk_250mhz clk_250mhz
ad_connect corundum_core/rst_250mhz rst_250mhz

ad_connect corundum_core/tx_clk ethernet_core/eth_tx_clk
ad_connect corundum_core/tx_rst ethernet_core/eth_tx_rst

ad_connect corundum_core/irq irq

ad_connect ethernet_core/clk clk_250mhz
ad_connect ethernet_core/rst rst_250mhz

ad_connect ethernet_core/sfp_led sfp_led

ad_connect ethernet_core/sfp_rx_p sfp_rx_p
ad_connect ethernet_core/sfp_rx_n sfp_rx_n
ad_connect ethernet_core/sfp_tx_p sfp_tx_p
ad_connect ethernet_core/sfp_tx_n sfp_tx_n
ad_connect ethernet_core/sfp_mgt_refclk_p sfp_mgt_refclk_p
ad_connect ethernet_core/sfp_mgt_refclk_n sfp_mgt_refclk_n

ad_connect corundum_core/sfp_tx_disable sfp_tx_disable
ad_connect ethernet_core/sfp_mod_abs sfp_mod_abs
ad_connect ethernet_core/sfp_mod_abs_int corundum_core/sfp_mod_abs
ad_connect ethernet_core/sfp_rx_los sfp_rx_los
ad_connect ethernet_core/sfp_rx_los_int corundum_core/sfp_rx_los
ad_connect ethernet_core/sfp_tx_fault sfp_tx_fault
ad_connect ethernet_core/sfp_tx_fault_int corundum_core/sfp_tx_fault

ad_connect ethernet_core/sfp_drp_clk corundum_core/sfp_drp_clk
ad_connect ethernet_core/sfp_drp_rst corundum_core/sfp_drp_rst
ad_connect ethernet_core/sfp_drp_addr corundum_core/sfp_drp_addr
ad_connect ethernet_core/sfp_drp_di corundum_core/sfp_drp_di
ad_connect ethernet_core/sfp_drp_en corundum_core/sfp_drp_en
ad_connect ethernet_core/sfp_drp_we corundum_core/sfp_drp_we
ad_connect ethernet_core/sfp_drp_do corundum_core/sfp_drp_do
ad_connect ethernet_core/sfp_drp_rdy corundum_core/sfp_drp_rdy

ad_connect ethernet_core/sfp_tx_clk_int corundum_core/sfp_tx_clk
ad_connect ethernet_core/sfp_rx_clk_int corundum_core/sfp_rx_clk
ad_connect ethernet_core/sfp_rx_error_count_int corundum_core/sfp_rx_error_count

ad_connect ethernet_core/s_iic corundum_core/iic

ad_connect ethernet_core/sfp_i2c_scl sfp_i2c_scl
ad_connect ethernet_core/sfp_i2c_sda sfp_i2c_sda

# if {$APP_ENABLE == 1} {
#   ad_ip_instance application_core application_core [list \
#     IF_COUNT $IF_COUNT \
#     PORTS_PER_IF $PORTS_PER_IF \
#     PTP_PEROUT_COUNT $PTP_PEROUT_COUNT \
#     PTP_TS_ENABLE $PTP_TS_ENABLE \
#     APP_ID $APP_ID \
#     DMA_IMM_WIDTH $DMA_IMM_WIDTH \
#     DMA_LEN_WIDTH $DMA_LEN_WIDTH \
#     DMA_TAG_WIDTH $DMA_TAG_WIDTH \
#     RAM_ADDR_WIDTH $RAM_ADDR_WIDTH \
#     STAT_INC_WIDTH $STAT_INC_WIDTH \
#     STAT_ID_WIDTH $STAT_ID_WIDTH \
#   ]

#   ad_connect application_core/clk corundum_core/clk
#   ad_connect application_core/rst corundum_core/rst
#   ad_connect application_core/ptp_clk corundum_core/ptp_clk
#   ad_connect application_core/ptp_rst corundum_core/ptp_rst
#   ad_connect application_core/ptp_sample_clk corundum_core/ptp_sample_clk
#   ad_connect application_core/direct_tx_clk corundum_core/tx_clk
#   ad_connect application_core/direct_tx_rst corundum_core/tx_rst
#   ad_connect application_core/direct_rx_clk corundum_core/rx_clk
#   ad_connect application_core/direct_rx_rst corundum_core/rx_rst
  
#   ad_connect application_core/ptp_clock corundum_core/ptp_clock_app
#   ad_connect application_core/s_axil_ctrl s_axil_application
  
#   ad_connect application_core/input_axis_tvalid input_axis_tvalid
#   ad_connect application_core/input_axis_tdata input_axis_tdata

#   ad_connect application_core/input_enable input_enable

#   ad_connect application_core/jtag_tdi GND
#   ad_connect application_core/jtag_tms GND
#   ad_connect application_core/jtag_tck GND
#   ad_connect application_core/gpio_in GND

#   if {$APP_CTRL_ENABLE} {
#     ad_connect application_core/m_axil_ctrl corundum_core/m_axil_ctrl_app
#   }

#   if {$APP_DMA_ENABLE} {
#     ad_connect application_core/m_axis_ctrl_dma_read_desc corundum_core/m_axis_ctrl_dma_read_desc_app
#     ad_connect application_core/m_axis_ctrl_dma_write_desc corundum_core/m_axis_ctrl_dma_write_desc_app
#     ad_connect application_core/m_axis_data_dma_read_desc corundum_core/m_axis_data_dma_read_desc_app
#     ad_connect application_core/m_axis_data_dma_write_desc corundum_core/m_axis_data_dma_write_desc_app

#     ad_connect application_core/s_axis_ctrl_dma_read_desc_status corundum_core/s_axis_ctrl_dma_read_desc_status_app
#     ad_connect application_core/s_axis_ctrl_dma_write_desc_status corundum_core/s_axis_ctrl_dma_write_desc_status_app
#     ad_connect application_core/s_axis_data_dma_read_desc_status corundum_core/s_axis_data_dma_read_desc_status_app
#     ad_connect application_core/s_axis_data_dma_write_desc_status corundum_core/s_axis_data_dma_write_desc_status_app

#     ad_connect application_core/ctrl_dma_ram corundum_core/ctrl_dma_ram_app
#     ad_connect application_core/data_dma_ram corundum_core/data_dma_ram_app
#   }

#   if {$APP_AXIS_DIRECT_ENABLE} {
#     ad_connect application_core/m_axis_direct_tx corundum_core/m_axis_direct_tx_app
#     ad_connect application_core/s_axis_direct_tx corundum_core/s_axis_direct_tx_app

#     ad_connect application_core/m_axis_direct_rx corundum_core/m_axis_direct_rx_app
#     ad_connect application_core/s_axis_direct_rx corundum_core/s_axis_direct_rx_app

#     ad_connect application_core/m_axis_direct_tx_cpl corundum_core/m_axis_direct_tx_cpl_app
#     ad_connect application_core/s_axis_direct_tx_cpl corundum_core/s_axis_direct_tx_cpl_app
#   }
  
#   if {$APP_AXIS_SYNC_ENABLE} {
#     ad_connect application_core/m_axis_sync_tx corundum_core/m_axis_sync_tx_app
#     ad_connect application_core/s_axis_sync_tx corundum_core/s_axis_sync_tx_app

#     ad_connect application_core/m_axis_sync_rx corundum_core/m_axis_sync_rx_app
#     ad_connect application_core/s_axis_sync_rx corundum_core/s_axis_sync_rx_app

#     ad_connect application_core/m_axis_sync_tx_cpl corundum_core/m_axis_sync_tx_cpl_app
#     ad_connect application_core/s_axis_sync_tx_cpl corundum_core/s_axis_sync_tx_cpl_app
#   }

#   if {$APP_AXIS_IF_ENABLE} {
#     ad_connect application_core/m_axis_if_tx corundum_core/m_axis_if_tx_app
#     ad_connect application_core/s_axis_if_tx corundum_core/s_axis_if_tx_app
  
#     ad_connect application_core/m_axis_if_rx corundum_core/m_axis_if_rx_app
#     ad_connect application_core/s_axis_if_rx corundum_core/s_axis_if_rx_app

#     ad_connect application_core/m_axis_if_tx_cpl corundum_core/m_axis_if_tx_cpl_app
#     ad_connect application_core/s_axis_if_tx_cpl corundum_core/s_axis_if_tx_cpl_app
#   }

#   # if {$DDR_ENABLE} {
#   #   ad_connect application_core/ddr_clk corundum_core/ddr_clk
#   #   ad_connect application_core/ddr_rst corundum_core/ddr_rst
#   #   ad_connect application_core/ddr_status corundum_core/ddr_status

#   #   ad_connect application_core/m_axi_ddr corundum_core/m_axi_ddr_app
#   # } else {
#   #   ad_connect application_core/ddr_clk GND
#   #   ad_connect application_core/ddr_rst GND
#   #   ad_connect application_core/ddr_status GND
#   # }

#   # if {$HBM_ENABLE} {
#   #   ad_connect application_core/hbm_clk corundum_core/hbm_clk
#   #   ad_connect application_core/hbm_rst corundum_core/hbm_rst
#   #   ad_connect application_core/hbm_status corundum_core/hbm_status

#   #   ad_connect application_core/m_axi_hbm corundum_core/m_axi_hbm_app
#   # } else {
#   #   ad_connect application_core/hbm_clk GND
#   #   ad_connect application_core/hbm_rst GND
#   #   ad_connect application_core/hbm_status GND
#   # }

#   if {$APP_STAT_ENABLE} {
#     ad_connect application_core/m_axis_stat corundum_core/m_axis_stat_app
#   }

#   create_bd_pin -dir I -type clk input_clk
#   create_bd_pin -dir I -type rst input_rstn

#   ad_connect application_core/input_clk input_clk
#   ad_connect application_core/input_rstn input_rstn
# }

current_bd_instance /