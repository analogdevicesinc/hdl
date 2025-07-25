###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_cell -type hier corundum_hierarchy
current_bd_instance /corundum_hierarchy

create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axil_corundum
if {$APP_ENABLE == 1} {
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axil_application
}

create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi

create_bd_pin -dir I -type clk clk_corundum
create_bd_pin -dir I -type rst rst_corundum

create_bd_pin -dir O -type intr irq

if [info exists ::env(CPU)] {
  set CPU $::env(CPU)
} else {
  error "Missing CPU environment variable definition from makefile!"
}

if [info exists ::env(BOARD)] {
  set board $::env(BOARD)
  if [string equal $board VCU118] {
    create_bd_pin -dir O -from 0 -to 0 -type rst qsfp_rst
    create_bd_pin -dir O fpga_boot
    create_bd_pin -dir O -type clk qspi_clk
    create_bd_intf_pin -mode Master -vlnv analog.com:interface:if_qspi_rtl:1.0 qspi0
    create_bd_intf_pin -mode Master -vlnv analog.com:interface:if_qspi_rtl:1.0 qspi1
    create_bd_pin -dir I -type rst ptp_rst
    create_bd_pin -dir I -type clk qsfp_mgt_refclk
    create_bd_pin -dir I -type clk qsfp_mgt_refclk_bufg
    create_bd_intf_pin -mode Master -vlnv analog.com:interface:if_qsfp_rtl:1.0 qsfp
    create_bd_intf_pin -mode Master -vlnv analog.com:interface:if_i2c_rtl:1.0 i2c

    if {$DDR_ENABLE == 1} {
      create_bd_pin -dir I -type clk ddr_clk
      create_bd_pin -dir I -type rst ddr_rst
      create_bd_pin -dir I ddr_status
    }

    if {$HBM_ENABLE == 1} {
      create_bd_pin -dir I -type clk hbm_clk
      create_bd_pin -dir I -type rst hbm_rst
      create_bd_pin -dir I hbm_status
    }

    create_bd_pin -dir I -type clk clk_125mhz
    create_bd_pin -dir I -type rst rst_125mhz
  } else {
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
    create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 sfp_iic
  }
} else {
  error "Missing BOARD environment variable definition from makefile!"
}

if [string equal $board K26] {
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
    PTP_TS_FMT_TOD $PTP_TS_FMT_TOD \
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

  ad_ip_instance ethernet_k26 ethernet_core [list \
    IF_COUNT $IF_COUNT \
    PORTS_PER_IF $PORTS_PER_IF \
    PORT_MASK $PORT_MASK \
    PTP_TS_ENABLE $PTP_TS_ENABLE \
    PTP_TS_FMT_TOD $PTP_TS_FMT_TOD \
    ENABLE_PADDING $ENABLE_PADDING \
    ENABLE_DIC $ENABLE_DIC \
    MIN_FRAME_LENGTH $MIN_FRAME_LENGTH \
    PFC_ENABLE $PFC_ENABLE \
  ]
} else {
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
    PTP_CLK_PERIOD_NS_NUM $PTP_CLK_PERIOD_NS_NUM \
    PTP_CLK_PERIOD_NS_DENOM $PTP_CLK_PERIOD_NS_DENOM \
    PTP_CLOCK_PIPELINE $PTP_CLOCK_PIPELINE \
    PTP_CLOCK_CDC_PIPELINE $PTP_CLOCK_CDC_PIPELINE \
    PTP_SEPARATE_TX_CLOCK $PTP_SEPARATE_TX_CLOCK \
    PTP_SEPARATE_RX_CLOCK $PTP_SEPARATE_RX_CLOCK \
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
    PTP_TS_FMT_TOD $PTP_TS_FMT_TOD \
    PTP_TS_WIDTH $PTP_TS_WIDTH \
    TX_CPL_ENABLE $TX_CPL_ENABLE \
    TX_CPL_FIFO_DEPTH $TX_CPL_FIFO_DEPTH \
    TX_TAG_WIDTH $TX_TAG_WIDTH \
    TX_CHECKSUM_ENABLE $TX_CHECKSUM_ENABLE \
    RX_HASH_ENABLE $RX_HASH_ENABLE \
    RX_CHECKSUM_ENABLE $RX_CHECKSUM_ENABLE \
    PFC_ENABLE $PFC_ENABLE \
    LFC_ENABLE $LFC_ENABLE \
    MAC_CTRL_ENABLE $MAC_CTRL_ENABLE \
    TX_FIFO_DEPTH $TX_FIFO_DEPTH \
    RX_FIFO_DEPTH $RX_FIFO_DEPTH \
    MAX_TX_SIZE $MAX_TX_SIZE \
    MAX_RX_SIZE $MAX_RX_SIZE \
    TX_RAM_SIZE $TX_RAM_SIZE \
    RX_RAM_SIZE $RX_RAM_SIZE \
    DDR_ENABLE $DDR_ENABLE \
    DDR_CH $DDR_CH \
    DDR_GROUP_SIZE $DDR_GROUP_SIZE \
    AXI_DDR_DATA_WIDTH $AXI_DDR_DATA_WIDTH \
    AXI_DDR_ADDR_WIDTH $AXI_DDR_ADDR_WIDTH \
    AXI_DDR_STRB_WIDTH $AXI_DDR_STRB_WIDTH \
    AXI_DDR_ID_WIDTH $AXI_DDR_ID_WIDTH \
    AXI_DDR_AWUSER_ENABLE $AXI_DDR_AWUSER_ENABLE \
    AXI_DDR_WUSER_ENABLE $AXI_DDR_WUSER_ENABLE \
    AXI_DDR_BUSER_ENABLE $AXI_DDR_BUSER_ENABLE \
    AXI_DDR_ARUSER_ENABLE $AXI_DDR_ARUSER_ENABLE \
    AXI_DDR_RUSER_ENABLE $AXI_DDR_RUSER_ENABLE \
    AXI_DDR_MAX_BURST_LEN $AXI_DDR_MAX_BURST_LEN \
    AXI_DDR_NARROW_BURST $AXI_DDR_NARROW_BURST \
    AXI_DDR_FIXED_BURST $AXI_DDR_FIXED_BURST \
    AXI_DDR_WRAP_BURST $AXI_DDR_WRAP_BURST \
    HBM_ENABLE $HBM_ENABLE \
    HBM_CH $HBM_CH \
    HBM_GROUP_SIZE $HBM_GROUP_SIZE \
    AXI_HBM_DATA_WIDTH $AXI_HBM_DATA_WIDTH \
    AXI_HBM_ADDR_WIDTH $AXI_HBM_ADDR_WIDTH \
    AXI_HBM_STRB_WIDTH $AXI_HBM_STRB_WIDTH \
    AXI_HBM_ID_WIDTH $AXI_HBM_ID_WIDTH \
    AXI_HBM_AWUSER_ENABLE $AXI_HBM_AWUSER_ENABLE \
    AXI_HBM_AWUSER_WIDTH $AXI_HBM_AWUSER_WIDTH \
    AXI_HBM_WUSER_ENABLE $AXI_HBM_WUSER_ENABLE \
    AXI_HBM_WUSER_WIDTH $AXI_HBM_WUSER_WIDTH \
    AXI_HBM_BUSER_ENABLE $AXI_HBM_BUSER_ENABLE \
    AXI_HBM_BUSER_WIDTH $AXI_HBM_BUSER_WIDTH \
    AXI_HBM_ARUSER_ENABLE $AXI_HBM_ARUSER_ENABLE \
    AXI_HBM_ARUSER_WIDTH $AXI_HBM_ARUSER_WIDTH \
    AXI_HBM_RUSER_ENABLE $AXI_HBM_RUSER_ENABLE \
    AXI_HBM_RUSER_WIDTH $AXI_HBM_RUSER_WIDTH \
    AXI_HBM_MAX_BURST_LEN $AXI_HBM_MAX_BURST_LEN \
    AXI_HBM_NARROW_BURST $AXI_HBM_NARROW_BURST \
    AXI_HBM_FIXED_BURST $AXI_HBM_FIXED_BURST \
    AXI_HBM_WRAP_BURST $AXI_HBM_WRAP_BURST \
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
    AXI_STRB_WIDTH $AXI_STRB_WIDTH \
    AXI_ID_WIDTH $AXI_ID_WIDTH \
    DMA_IMM_ENABLE $DMA_IMM_ENABLE \
    DMA_IMM_WIDTH $DMA_IMM_WIDTH \
    DMA_LEN_WIDTH $DMA_LEN_WIDTH \
    DMA_TAG_WIDTH $DMA_TAG_WIDTH \
    RAM_ADDR_WIDTH $RAM_ADDR_WIDTH \
    RAM_PIPELINE $RAM_PIPELINE \
    AXI_DMA_MAX_BURST_LEN $AXI_DMA_MAX_BURST_LEN \
    AXI_DMA_READ_USE_ID $AXI_DMA_READ_USE_ID \
    AXI_DMA_WRITE_USE_ID $AXI_DMA_WRITE_USE_ID \
    AXI_DMA_READ_OP_TABLE_SIZE $AXI_DMA_READ_OP_TABLE_SIZE \
    AXI_DMA_WRITE_OP_TABLE_SIZE $AXI_DMA_WRITE_OP_TABLE_SIZE \
    IRQ_COUNT $IRQ_COUNT \
    AXIL_CTRL_DATA_WIDTH $AXIL_CTRL_DATA_WIDTH \
    AXIL_CTRL_ADDR_WIDTH $AXIL_CTRL_ADDR_WIDTH \
    AXIL_CTRL_STRB_WIDTH $AXIL_CTRL_STRB_WIDTH \
    AXIL_IF_CTRL_ADDR_WIDTH $AXIL_IF_CTRL_ADDR_WIDTH \
    AXIL_CSR_ADDR_WIDTH $AXIL_CSR_ADDR_WIDTH \
    AXIL_CSR_PASSTHROUGH_ENABLE $AXIL_CSR_PASSTHROUGH_ENABLE \
    RB_NEXT_PTR $RB_NEXT_PTR \
    AXIL_APP_CTRL_DATA_WIDTH $AXIL_APP_CTRL_DATA_WIDTH \
    AXIL_APP_CTRL_ADDR_WIDTH $AXIL_APP_CTRL_ADDR_WIDTH \
    AXIL_APP_CTRL_STRB_WIDTH $AXIL_APP_CTRL_STRB_WIDTH \
    AXIS_DATA_WIDTH $AXIS_DATA_WIDTH \
    AXIS_KEEP_WIDTH $AXIS_KEEP_WIDTH \
    AXIS_SYNC_DATA_WIDTH $AXIS_SYNC_DATA_WIDTH \
    AXIS_IF_DATA_WIDTH $AXIS_IF_DATA_WIDTH \
    AXIS_TX_USER_WIDTH $AXIS_TX_USER_WIDTH \
    AXIS_RX_USER_WIDTH $AXIS_RX_USER_WIDTH \
    AXIS_RX_USE_READY $AXIS_RX_USE_READY \
    AXIS_TX_PIPELINE $AXIS_TX_PIPELINE \
    AXIS_TX_FIFO_PIPELINE $AXIS_TX_FIFO_PIPELINE \
    AXIS_TX_TS_PIPELINE $AXIS_TX_TS_PIPELINE \
    AXIS_RX_PIPELINE $AXIS_RX_PIPELINE \
    AXIS_RX_FIFO_PIPELINE $AXIS_RX_FIFO_PIPELINE \
    STAT_ENABLE $STAT_ENABLE \
    STAT_DMA_ENABLE $STAT_DMA_ENABLE \
    STAT_AXI_ENABLE $STAT_AXI_ENABLE \
    STAT_INC_WIDTH $STAT_INC_WIDTH \
    STAT_ID_WIDTH $STAT_ID_WIDTH \
    DMA_ADDR_WIDTH_APP $DMA_ADDR_WIDTH_APP \
    RAM_SEL_WIDTH_APP $RAM_SEL_WIDTH_APP \
    RAM_SEG_COUNT_APP $RAM_SEG_COUNT_APP \
    RAM_SEG_DATA_WIDTH_APP $RAM_SEG_DATA_WIDTH_APP \
    RAM_SEG_BE_WIDTH_APP $RAM_SEG_BE_WIDTH_APP \
    RAM_SEG_ADDR_WIDTH_APP $RAM_SEG_ADDR_WIDTH_APP \
    AXIS_SYNC_KEEP_WIDTH_APP $AXIS_SYNC_KEEP_WIDTH_APP \
    AXIS_SYNC_TX_USER_WIDTH_APP $AXIS_SYNC_TX_USER_WIDTH_APP \
    AXIS_SYNC_RX_USER_WIDTH_APP $AXIS_SYNC_RX_USER_WIDTH_APP \
    AXIS_IF_KEEP_WIDTH_APP $AXIS_IF_KEEP_WIDTH_APP \
    AXIS_IF_TX_ID_WIDTH_APP $AXIS_IF_TX_ID_WIDTH_APP \
    AXIS_IF_RX_ID_WIDTH_APP $AXIS_IF_RX_ID_WIDTH_APP \
    AXIS_IF_TX_DEST_WIDTH_APP $AXIS_IF_TX_DEST_WIDTH_APP \
    AXIS_IF_RX_DEST_WIDTH_APP $AXIS_IF_RX_DEST_WIDTH_APP \
    AXIS_IF_TX_USER_WIDTH_APP $AXIS_IF_TX_USER_WIDTH_APP \
    AXIS_IF_RX_USER_WIDTH_APP $AXIS_IF_RX_USER_WIDTH_APP \
  ]

  ad_ip_instance ethernet_vcu118 ethernet_core [list \
    TDMA_BER_ENABLE $TDMA_BER_ENABLE \
    QSFP_CNT $QSFP_CNT \
    IF_COUNT $IF_COUNT \
    PORTS_PER_IF $PORTS_PER_IF \
    SCHED_PER_IF $SCHED_PER_IF \
    PORT_COUNT $PORT_COUNT \
    PORT_MASK $PORT_MASK \
    PTP_TS_WIDTH $PTP_TS_WIDTH \
    TX_TAG_WIDTH $TX_TAG_WIDTH \
    TDMA_INDEX_WIDTH $TDMA_INDEX_WIDTH \
    PTP_TS_ENABLE $PTP_TS_ENABLE \
    PTP_TS_FMT_TOD $PTP_TS_FMT_TOD \
    AXIL_CTRL_DATA_WIDTH $AXIL_CTRL_DATA_WIDTH \
    AXIL_CTRL_ADDR_WIDTH $AXIL_CTRL_ADDR_WIDTH \
    AXIL_CTRL_STRB_WIDTH $AXIL_CTRL_STRB_WIDTH \
    AXIL_CSR_ADDR_WIDTH $AXIL_CSR_ADDR_WIDTH \
    AXIL_IF_CTRL_ADDR_WIDTH $AXIL_IF_CTRL_ADDR_WIDTH \
    ETH_RX_CLK_FROM_TX $ETH_RX_CLK_FROM_TX \
    ETH_RS_FEC_ENABLE $ETH_RS_FEC_ENABLE \
    AXIS_DATA_WIDTH $AXIS_DATA_WIDTH \
    AXIS_KEEP_WIDTH $AXIS_KEEP_WIDTH \
    AXIS_TX_USER_WIDTH $AXIS_TX_USER_WIDTH \
    AXIS_RX_USER_WIDTH $AXIS_RX_USER_WIDTH
  ]
}

ad_connect corundum_core/s_axil_ctrl s_axil_corundum
ad_connect corundum_core/m_axis_tx ethernet_core/axis_eth_tx
ad_connect corundum_core/s_axis_rx ethernet_core/axis_eth_rx
ad_connect corundum_core/flow_control_tx ethernet_core/flow_control_tx
ad_connect corundum_core/flow_control_rx ethernet_core/flow_control_rx

ad_connect corundum_core/ethernet_ptp_tx ethernet_core/ethernet_ptp_tx
ad_connect corundum_core/ethernet_ptp_rx ethernet_core/ethernet_ptp_rx
ad_connect corundum_core/axis_tx_ptp ethernet_core/axis_tx_ptp

ad_connect corundum_core/rx_clk ethernet_core/eth_rx_clk
ad_connect corundum_core/rx_rst ethernet_core/eth_rx_rst
ad_connect corundum_core/tx_clk ethernet_core/eth_tx_clk
ad_connect corundum_core/tx_rst ethernet_core/eth_tx_rst

ad_connect corundum_core/m_axi m_axi

ad_connect corundum_core/clk clk_corundum
ad_connect corundum_core/rst rst_corundum

ad_connect corundum_core/irq irq

ad_connect ethernet_core/clk clk_corundum
ad_connect ethernet_core/rst rst_corundum

ad_connect ethernet_core/ctrl_reg corundum_core/ctrl_reg

if [string equal $board K26] {
  ad_connect ethernet_core/sfp_rx_p sfp_rx_p
  ad_connect ethernet_core/sfp_rx_n sfp_rx_n
  ad_connect ethernet_core/sfp_tx_p sfp_tx_p
  ad_connect ethernet_core/sfp_tx_n sfp_tx_n
  ad_connect ethernet_core/sfp_mgt_refclk_p sfp_mgt_refclk_p
  ad_connect ethernet_core/sfp_mgt_refclk_n sfp_mgt_refclk_n

  ad_connect ethernet_core/sfp_tx_disable sfp_tx_disable
  ad_connect ethernet_core/sfp_mod_abs sfp_mod_abs
  ad_connect ethernet_core/sfp_rx_los sfp_rx_los
  ad_connect ethernet_core/sfp_tx_fault sfp_tx_fault

  ad_connect ethernet_core/iic sfp_iic

  ad_connect ethernet_core/ptp_clock corundum_core/ptp_clock
  ad_connect corundum_core/ptp_clk ethernet_core/ptp_clk
  ad_connect corundum_core/ptp_rst ethernet_core/ptp_rst
  ad_connect corundum_core/ptp_sample_clk ethernet_core/ptp_sample_clk
  ad_connect corundum_core/s_axis_stat ethernet_core/m_axis_stat
} else {
  ad_connect ethernet_core/clk_125mhz clk_125mhz
  ad_connect ethernet_core/rst_125mhz rst_125mhz
  ad_connect ethernet_core/qsfp_drp_clk clk_125mhz
  ad_connect ethernet_core/qsfp_drp_rst rst_125mhz
  ad_connect ethernet_core/qsfp_mgt_refclk qsfp_mgt_refclk
  ad_connect ethernet_core/qsfp_mgt_refclk_bufg qsfp_mgt_refclk_bufg
  ad_connect ethernet_core/qsfp_rst qsfp_rst
  ad_connect ethernet_core/fpga_boot fpga_boot
  ad_connect ethernet_core/qspi_clk qspi_clk

  ad_connect ethernet_core/qspi0 qspi0
  ad_connect ethernet_core/qspi1 qspi1
  ad_connect ethernet_core/qsfp qsfp
  ad_connect ethernet_core/i2c i2c

  ad_connect corundum_core/ptp_clk qsfp_mgt_refclk_bufg
  ad_connect corundum_core/ptp_rst ptp_rst
  ad_connect corundum_core/ptp_sample_clk clk_125mhz

  if {$HBM_ENABLE == 1} {
    ad_connect corundum_core/hbm_clk hbm_clk
    ad_connect corundum_core/hbm_rst hbm_rst
    ad_connect corundum_core/hbm_status hbm_status
  }

  if {$DDR_ENABLE == 1} {
    ad_connect corundum_core/ddr_clk ddr_clk
    ad_connect corundum_core/ddr_rst ddr_rst
    ad_connect corundum_core/ddr_status ddr_status
  }

  ad_connect corundum_core/s_axis_stat_tvalid GND
}

if {$APP_ENABLE == 1} {
  ad_ip_instance application_core application_core [list \
    IF_COUNT $IF_COUNT \
    PORTS_PER_IF $PORTS_PER_IF \
    PTP_PEROUT_COUNT $PTP_PEROUT_COUNT \
    PTP_TS_ENABLE $PTP_TS_ENABLE \
    PTP_TS_FMT_TOD $PTP_TS_FMT_TOD \
    PTP_TS_WIDTH $PTP_TS_WIDTH \
    TX_TAG_WIDTH $TX_TAG_WIDTH \
    DDR_CH $DDR_CH \
    AXI_DDR_DATA_WIDTH $AXI_DDR_DATA_WIDTH \
    AXI_DDR_ADDR_WIDTH $AXI_DDR_ADDR_WIDTH \
    AXI_DDR_STRB_WIDTH $AXI_DDR_STRB_WIDTH \
    AXI_DDR_ID_WIDTH $AXI_DDR_ID_WIDTH \
    AXI_DDR_AWUSER_ENABLE $AXI_DDR_AWUSER_ENABLE \
    AXI_DDR_WUSER_ENABLE $AXI_DDR_WUSER_ENABLE \
    AXI_DDR_BUSER_ENABLE $AXI_DDR_BUSER_ENABLE \
    AXI_DDR_ARUSER_ENABLE $AXI_DDR_ARUSER_ENABLE \
    AXI_DDR_RUSER_ENABLE $AXI_DDR_RUSER_ENABLE \
    HBM_CH $HBM_CH \
    AXI_HBM_DATA_WIDTH $AXI_HBM_DATA_WIDTH \
    AXI_HBM_ADDR_WIDTH $AXI_HBM_ADDR_WIDTH \
    AXI_HBM_STRB_WIDTH $AXI_HBM_STRB_WIDTH \
    AXI_HBM_ID_WIDTH $AXI_HBM_ID_WIDTH \
    AXI_HBM_AWUSER_ENABLE $AXI_HBM_AWUSER_ENABLE \
    AXI_HBM_AWUSER_WIDTH $AXI_HBM_AWUSER_WIDTH \
    AXI_HBM_WUSER_ENABLE $AXI_HBM_WUSER_ENABLE \
    AXI_HBM_WUSER_WIDTH $AXI_HBM_WUSER_WIDTH \
    AXI_HBM_BUSER_ENABLE $AXI_HBM_BUSER_ENABLE \
    AXI_HBM_BUSER_WIDTH $AXI_HBM_BUSER_WIDTH \
    AXI_HBM_ARUSER_ENABLE $AXI_HBM_ARUSER_ENABLE \
    AXI_HBM_ARUSER_WIDTH $AXI_HBM_ARUSER_WIDTH \
    AXI_HBM_RUSER_ENABLE $AXI_HBM_RUSER_ENABLE \
    AXI_HBM_RUSER_WIDTH $AXI_HBM_RUSER_WIDTH \
    APP_ID $APP_ID \
    APP_GPIO_IN_WIDTH $APP_GPIO_IN_WIDTH \
    APP_GPIO_OUT_WIDTH $APP_GPIO_OUT_WIDTH \
    DMA_ADDR_WIDTH $DMA_ADDR_WIDTH \
    DMA_IMM_WIDTH $DMA_IMM_WIDTH \
    DMA_LEN_WIDTH $DMA_LEN_WIDTH \
    DMA_TAG_WIDTH $DMA_TAG_WIDTH \
    RAM_SEL_WIDTH $RAM_SEL_WIDTH \
    RAM_ADDR_WIDTH $RAM_ADDR_WIDTH \
    RAM_SEG_COUNT $RAM_SEG_COUNT \
    RAM_SEG_DATA_WIDTH $RAM_SEG_DATA_WIDTH \
    RAM_SEG_BE_WIDTH $RAM_SEG_BE_WIDTH \
    RAM_SEG_ADDR_WIDTH $RAM_SEG_ADDR_WIDTH \
    AXIL_CTRL_DATA_WIDTH $AXIL_CTRL_DATA_WIDTH \
    AXIL_CTRL_ADDR_WIDTH $AXIL_CTRL_ADDR_WIDTH \
    AXIL_CTRL_STRB_WIDTH $AXIL_CTRL_STRB_WIDTH \
    AXIS_DATA_WIDTH $AXIS_DATA_WIDTH \
    AXIS_KEEP_WIDTH $AXIS_KEEP_WIDTH \
    AXIS_TX_USER_WIDTH $AXIS_TX_USER_WIDTH \
    AXIS_RX_USER_WIDTH $AXIS_RX_USER_WIDTH \
    AXIS_SYNC_DATA_WIDTH $AXIS_SYNC_DATA_WIDTH \
    AXIS_SYNC_KEEP_WIDTH $AXIS_SYNC_KEEP_WIDTH \
    AXIS_SYNC_TX_USER_WIDTH $AXIS_SYNC_TX_USER_WIDTH \
    AXIS_SYNC_RX_USER_WIDTH $AXIS_SYNC_RX_USER_WIDTH \
    AXIS_IF_DATA_WIDTH $AXIS_IF_DATA_WIDTH \
    AXIS_IF_KEEP_WIDTH $AXIS_IF_KEEP_WIDTH \
    AXIS_IF_TX_ID_WIDTH $AXIS_IF_TX_ID_WIDTH \
    AXIS_IF_RX_ID_WIDTH $AXIS_IF_RX_ID_WIDTH \
    AXIS_IF_TX_DEST_WIDTH $AXIS_IF_TX_DEST_WIDTH \
    AXIS_IF_RX_DEST_WIDTH $AXIS_IF_RX_DEST_WIDTH \
    AXIS_IF_TX_USER_WIDTH $AXIS_IF_TX_USER_WIDTH \
    AXIS_IF_RX_USER_WIDTH $AXIS_IF_RX_USER_WIDTH \
    STAT_INC_WIDTH $STAT_INC_WIDTH \
    STAT_ID_WIDTH $STAT_ID_WIDTH \
    INPUT_CHANNELS $INPUT_CHANNELS \
    INPUT_SAMPLES_PER_CHANNEL $INPUT_SAMPLES_PER_CHANNEL \
    INPUT_SAMPLE_DATA_WIDTH $INPUT_SAMPLE_DATA_WIDTH \
    OUTPUT_CHANNELS $OUTPUT_CHANNELS \
    OUTPUT_SAMPLES_PER_CHANNEL $OUTPUT_SAMPLES_PER_CHANNEL \
    OUTPUT_SAMPLE_DATA_WIDTH $OUTPUT_SAMPLE_DATA_WIDTH \
  ]

  set INPUT_WIDTH [expr $INPUT_CHANNELS*$INPUT_SAMPLES_PER_CHANNEL*$INPUT_SAMPLE_DATA_WIDTH]
  set OUTPUT_WIDTH [expr $OUTPUT_CHANNELS*$OUTPUT_SAMPLES_PER_CHANNEL*$OUTPUT_SAMPLE_DATA_WIDTH]

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axil_application

  create_bd_pin -dir I -type clk input_clk
  create_bd_pin -dir I -type rst input_rstn

  create_bd_pin -dir I -type clk output_clk
  create_bd_pin -dir I -type rst output_rstn

  create_bd_pin -dir I input_axis_tvalid
  create_bd_pin -dir O input_axis_tready
  create_bd_pin -dir I -from [expr {$INPUT_WIDTH-1}] -to 0 input_axis_tdata

  create_bd_pin -dir O -type intr input_packer_reset

  create_bd_pin -dir O output_axis_tvalid
  create_bd_pin -dir I output_axis_tready
  create_bd_pin -dir O -from [expr {$OUTPUT_WIDTH-1}] -to 0 output_axis_tdata

  create_bd_pin -dir I -from [expr {$INPUT_CHANNELS-1}] -to 0 input_enable
  create_bd_pin -dir I -from [expr {$OUTPUT_CHANNELS-1}] -to 0 output_enable

  ad_connect application_core/input_clk input_clk
  ad_connect application_core/input_rstn input_rstn

  ad_connect application_core/output_clk output_clk
  ad_connect application_core/output_rstn output_rstn

  ad_connect application_core/clk corundum_core/clk
  ad_connect application_core/rst corundum_core/rst
  ad_connect application_core/ptp_clk corundum_core/ptp_clk
  ad_connect application_core/ptp_rst corundum_core/ptp_rst
  ad_connect application_core/ptp_sample_clk corundum_core/ptp_sample_clk
  ad_connect application_core/direct_tx_clk corundum_core/tx_clk
  ad_connect application_core/direct_tx_rst corundum_core/tx_rst
  ad_connect application_core/direct_rx_clk corundum_core/rx_clk
  ad_connect application_core/direct_rx_rst corundum_core/rx_rst

  ad_connect application_core/ptp_clock corundum_core/ptp_clock_app
  ad_connect application_core/s_axil_ctrl s_axil_application

  ad_connect application_core/input_axis_tvalid input_axis_tvalid
  ad_connect application_core/input_axis_tdata input_axis_tdata
  ad_connect application_core/input_axis_tready input_axis_tready

  ad_connect application_core/input_packer_reset input_packer_reset

  ad_connect application_core/output_axis_tvalid output_axis_tvalid
  ad_connect application_core/output_axis_tdata output_axis_tdata
  ad_connect application_core/output_axis_tready output_axis_tready

  ad_connect application_core/input_enable input_enable
  ad_connect application_core/output_enable output_enable

  ad_connect application_core/jtag_tdi GND
  ad_connect application_core/jtag_tms GND
  ad_connect application_core/jtag_tck GND
  ad_connect application_core/gpio_in GND

  if {$APP_CTRL_ENABLE} {
    ad_connect application_core/m_axil_ctrl corundum_core/m_axil_ctrl_app
  }

  if {$APP_DMA_ENABLE} {
    ad_connect application_core/m_axis_ctrl_dma_read_desc corundum_core/m_axis_ctrl_dma_read_desc_app
    ad_connect application_core/m_axis_ctrl_dma_write_desc corundum_core/m_axis_ctrl_dma_write_desc_app
    ad_connect application_core/m_axis_data_dma_read_desc corundum_core/m_axis_data_dma_read_desc_app
    ad_connect application_core/m_axis_data_dma_write_desc corundum_core/m_axis_data_dma_write_desc_app

    ad_connect application_core/s_axis_ctrl_dma_read_desc_status corundum_core/s_axis_ctrl_dma_read_desc_status_app
    ad_connect application_core/s_axis_ctrl_dma_write_desc_status corundum_core/s_axis_ctrl_dma_write_desc_status_app
    ad_connect application_core/s_axis_data_dma_read_desc_status corundum_core/s_axis_data_dma_read_desc_status_app
    ad_connect application_core/s_axis_data_dma_write_desc_status corundum_core/s_axis_data_dma_write_desc_status_app

    ad_connect application_core/ctrl_dma_ram corundum_core/ctrl_dma_ram_app
    ad_connect application_core/data_dma_ram corundum_core/data_dma_ram_app
  }

  if {$APP_AXIS_DIRECT_ENABLE} {
    ad_connect application_core/m_axis_direct_tx corundum_core/m_axis_direct_tx_app
    ad_connect application_core/s_axis_direct_tx corundum_core/s_axis_direct_tx_app

    ad_connect application_core/m_axis_direct_rx corundum_core/m_axis_direct_rx_app
    ad_connect application_core/s_axis_direct_rx corundum_core/s_axis_direct_rx_app

    ad_connect application_core/m_axis_direct_tx_cpl corundum_core/m_axis_direct_tx_cpl_app
    ad_connect application_core/s_axis_direct_tx_cpl corundum_core/s_axis_direct_tx_cpl_app
  }

  if {$APP_AXIS_SYNC_ENABLE} {
    ad_connect application_core/m_axis_sync_tx corundum_core/m_axis_sync_tx_app
    ad_connect application_core/s_axis_sync_tx corundum_core/s_axis_sync_tx_app

    ad_connect application_core/m_axis_sync_rx corundum_core/m_axis_sync_rx_app
    ad_connect application_core/s_axis_sync_rx corundum_core/s_axis_sync_rx_app

    ad_connect application_core/m_axis_sync_tx_cpl corundum_core/m_axis_sync_tx_cpl_app
    ad_connect application_core/s_axis_sync_tx_cpl corundum_core/s_axis_sync_tx_cpl_app
  }

  if {$APP_AXIS_IF_ENABLE} {
    ad_connect application_core/m_axis_if_tx corundum_core/m_axis_if_tx_app
    ad_connect application_core/s_axis_if_tx corundum_core/s_axis_if_tx_app

    ad_connect application_core/m_axis_if_rx corundum_core/m_axis_if_rx_app
    ad_connect application_core/s_axis_if_rx corundum_core/s_axis_if_rx_app

    ad_connect application_core/m_axis_if_tx_cpl corundum_core/m_axis_if_tx_cpl_app
    ad_connect application_core/s_axis_if_tx_cpl corundum_core/s_axis_if_tx_cpl_app
  }

  if {$DDR_ENABLE} {
    ad_connect application_core/ddr_clk corundum_core/ddr_clk
    ad_connect application_core/ddr_rst corundum_core/ddr_rst
    ad_connect application_core/ddr_status corundum_core/ddr_status

    ad_connect application_core/m_axi_ddr corundum_core/m_axi_ddr_app
  } else {
    ad_connect application_core/ddr_clk GND
    ad_connect application_core/ddr_rst GND
    ad_connect application_core/ddr_status GND
  }

  if {$HBM_ENABLE} {
    ad_connect application_core/hbm_clk corundum_core/hbm_clk
    ad_connect application_core/hbm_rst corundum_core/hbm_rst
    ad_connect application_core/hbm_status corundum_core/hbm_status

    ad_connect application_core/m_axi_hbm corundum_core/m_axi_hbm_app
  } else {
    ad_connect application_core/hbm_clk GND
    ad_connect application_core/hbm_rst GND
    ad_connect application_core/hbm_status GND
  }

  if {$APP_STAT_ENABLE} {
    ad_connect application_core/m_axis_stat corundum_core/m_axis_stat_app
  }
}

current_bd_instance /

ad_ip_instance proc_sys_reset corundum_rstgen [list \
  C_EXT_RST_WIDTH 1 \
  C_AUX_RESET_HIGH.VALUE_SRC USER \
  C_AUX_RESET_HIGH 1 \
]

ad_connect corundum_hierarchy/rst_corundum corundum_rstgen/peripheral_reset

if {![string equal $CPU Zynq]} {
  ad_ip_instance axi_gpio corundum_gpio_reset [list \
    C_ALL_OUTPUTS 1 \
    C_DOUT_DEFAULT 0x00000000 \
    C_GPIO_WIDTH 1 \
  ]

  ad_connect corundum_gpio_reset/gpio_io_o corundum_rstgen/aux_reset_in
}
