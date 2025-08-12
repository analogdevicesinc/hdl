###############################################################################
## Copyright (C) 2025 Analog Devices } Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

if { ![info exists FPGA_ID] } { set FPGA_ID 0xDEADBEEF }
if { ![info exists FW_ID] } { set FW_ID 0x00000000 }
if { ![info exists FW_VER] } { set FW_VER 0x00_00_01_00 }
if { ![info exists BOARD_ID] } { set BOARD_ID 0x1234_0000 }
if { ![info exists BOARD_VER] } { set BOARD_VER 0x01_00_00_00 }
if { ![info exists BUILD_DATE] } { set BUILD_DATE 602976000 }
if { ![info exists GIT_HASH] } { set GIT_HASH 0xdce357bf }
if { ![info exists RELEASE_INFO] } { set RELEASE_INFO 0x00000000 }

if { ![info exists IF_COUNT] } { set IF_COUNT 1 }
if { ![info exists PORTS_PER_IF] } { set PORTS_PER_IF 1 }
if { ![info exists SCHED_PER_IF] } { set SCHED_PER_IF $PORTS_PER_IF }

if { ![info exists PORT_COUNT] } { set PORT_COUNT [$IF_COUNT*$PORTS_PER_IF] }

if { ![info exists CLK_PERIOD_NS_NUM] } { set CLK_PERIOD_NS_NUM 4 }
if { ![info exists CLK_PERIOD_NS_DENOM] } { set CLK_PERIOD_NS_DENOM 1 }

if { ![info exists PTP_CLK_PERIOD_NS_NUM] } { set PTP_CLK_PERIOD_NS_NUM 4 }
if { ![info exists PTP_CLK_PERIOD_NS_DENOM] } { set PTP_CLK_PERIOD_NS_DENOM 1 }
if { ![info exists PTP_CLOCK_PIPELINE] } { set PTP_CLOCK_PIPELINE 0 }
if { ![info exists PTP_CLOCK_CDC_PIPELINE] } { set PTP_CLOCK_CDC_PIPELINE 0 }
if { ![info exists PTP_SEPARATE_TX_CLOCK] } { set PTP_SEPARATE_TX_CLOCK 0 }
if { ![info exists PTP_SEPARATE_RX_CLOCK] } { set PTP_SEPARATE_RX_CLOCK 0 }
if { ![info exists PTP_PORT_CDC_PIPELINE] } { set PTP_PORT_CDC_PIPELINE 0 }
if { ![info exists PTP_PEROUT_ENABLE] } { set PTP_PEROUT_ENABLE 0 }
if { ![info exists PTP_PEROUT_COUNT] } { set PTP_PEROUT_COUNT 1 }

if { ![info exists EVENT_QUEUE_OP_TABLE_SIZE] } { set EVENT_QUEUE_OP_TABLE_SIZE 32 }
if { ![info exists TX_QUEUE_OP_TABLE_SIZE] } { set TX_QUEUE_OP_TABLE_SIZE 32 }
if { ![info exists RX_QUEUE_OP_TABLE_SIZE] } { set RX_QUEUE_OP_TABLE_SIZE 32 }
if { ![info exists CQ_OP_TABLE_SIZE] } { set CQ_OP_TABLE_SIZE 32 }
if { ![info exists EQN_WIDTH] } { set EQN_WIDTH 5 }
if { ![info exists TX_QUEUE_INDEX_WIDTH] } { set TX_QUEUE_INDEX_WIDTH 13 }
if { ![info exists RX_QUEUE_INDEX_WIDTH] } { set RX_QUEUE_INDEX_WIDTH 8 }
if { ![info exists CQN_WIDTH] } { set CQN_WIDTH [expr max($TX_QUEUE_INDEX_WIDTH, $RX_QUEUE_INDEX_WIDTH) + 1] }
if { ![info exists EQ_PIPELINE] } { set EQ_PIPELINE 3 }
if { ![info exists TX_QUEUE_PIPELINE] } { set TX_QUEUE_PIPELINE [expr 3 + max($TX_QUEUE_INDEX_WIDTH - 12, 0)] }
if { ![info exists RX_QUEUE_PIPELINE] } { set RX_QUEUE_PIPELINE [expr 3 + max($RX_QUEUE_INDEX_WIDTH - 12, 0)] }
if { ![info exists CQ_PIPELINE] } { set CQ_PIPELINE [expr 3 + max($CQN_WIDTH - 12, 0)] }

if { ![info exists TX_DESC_TABLE_SIZE] } { set TX_DESC_TABLE_SIZE 32 }
if { ![info exists RX_DESC_TABLE_SIZE] } { set RX_DESC_TABLE_SIZE 32 }
if { ![info exists RX_INDIR_TBL_ADDR_WIDTH] } { set RX_INDIR_TBL_ADDR_WIDTH [expr min($RX_QUEUE_INDEX_WIDTH, 8)] }

if { ![info exists TX_SCHEDULER_OP_TABLE_SIZE] } { set TX_SCHEDULER_OP_TABLE_SIZE $TX_DESC_TABLE_SIZE }
if { ![info exists TX_SCHEDULER_PIPELINE] } { set TX_SCHEDULER_PIPELINE $TX_QUEUE_PIPELINE }
if { ![info exists TDMA_INDEX_WIDTH] } { set TDMA_INDEX_WIDTH 6 }

if { ![info exists PTP_TS_ENABLE] } { set PTP_TS_ENABLE 1 }
if { ![info exists PTP_TS_FMT_TOD] } { set PTP_TS_FMT_TOD 1 }
if { ![info exists PTP_TS_WIDTH] } { set PTP_TS_WIDTH [expr {$PTP_TS_FMT_TOD == 1 ? 96 : 64}] }
if { ![info exists TX_CPL_ENABLE] } { set TX_CPL_ENABLE $PTP_TS_ENABLE }
if { ![info exists TX_CPL_FIFO_DEPTH] } { set TX_CPL_FIFO_DEPTH 32 }
if { ![info exists TX_TAG_WIDTH] } { set TX_TAG_WIDTH [expr int(ceil(log($TX_DESC_TABLE_SIZE) / log(2))) + 1] }
if { ![info exists TX_CHECKSUM_ENABLE] } { set TX_CHECKSUM_ENABLE 1 }
if { ![info exists RX_HASH_ENABLE] } { set RX_HASH_ENABLE 1 }
if { ![info exists RX_CHECKSUM_ENABLE] } { set RX_CHECKSUM_ENABLE 1 }
if { ![info exists PFC_ENABLE] } { set PFC_ENABLE 1 }
if { ![info exists LFC_ENABLE] } { set LFC_ENABLE $PFC_ENABLE }
if { ![info exists MAC_CTRL_ENABLE] } { set MAC_CTRL_ENABLE 0 }
if { ![info exists TX_FIFO_DEPTH] } { set TX_FIFO_DEPTH 32768 }
if { ![info exists RX_FIFO_DEPTH] } { set RX_FIFO_DEPTH 32768 }
if { ![info exists MAX_TX_SIZE] } { set MAX_TX_SIZE 9214 }
if { ![info exists MAX_RX_SIZE] } { set MAX_RX_SIZE 9214 }
if { ![info exists TX_RAM_SIZE] } { set TX_RAM_SIZE 32768 }
if { ![info exists RX_RAM_SIZE] } { set RX_RAM_SIZE 32768 }

if { ![info exists DDR_CH] } { set DDR_CH 1 }
if { ![info exists DDR_ENABLE] } { set DDR_ENABLE 0 }
if { ![info exists DDR_GROUP_SIZE] } { set DDR_GROUP_SIZE 1 }
if { ![info exists AXI_DDR_DATA_WIDTH] } { set AXI_DDR_DATA_WIDTH 256 }
if { ![info exists AXI_DDR_ADDR_WIDTH] } { set AXI_DDR_ADDR_WIDTH 32 }
if { ![info exists AXI_DDR_STRB_WIDTH] } { set AXI_DDR_STRB_WIDTH [expr $AXI_DDR_DATA_WIDTH / 8] }
if { ![info exists AXI_DDR_ID_WIDTH] } { set AXI_DDR_ID_WIDTH 8 }
if { ![info exists AXI_DDR_AWUSER_ENABLE] } { set AXI_DDR_AWUSER_ENABLE 0 }
if { ![info exists AXI_DDR_AWUSER_WIDTH] } { set AXI_DDR_AWUSER_WIDTH 1 }
if { ![info exists AXI_DDR_WUSER_ENABLE] } { set AXI_DDR_WUSER_ENABLE 0 }
if { ![info exists AXI_DDR_WUSER_WIDTH] } { set AXI_DDR_WUSER_WIDTH 1 }
if { ![info exists AXI_DDR_BUSER_ENABLE] } { set AXI_DDR_BUSER_ENABLE 0 }
if { ![info exists AXI_DDR_BUSER_WIDTH] } { set AXI_DDR_BUSER_WIDTH 1 }
if { ![info exists AXI_DDR_ARUSER_ENABLE] } { set AXI_DDR_ARUSER_ENABLE 0 }
if { ![info exists AXI_DDR_ARUSER_WIDTH] } { set AXI_DDR_ARUSER_WIDTH 1 }
if { ![info exists AXI_DDR_RUSER_ENABLE] } { set AXI_DDR_RUSER_ENABLE 0 }
if { ![info exists AXI_DDR_RUSER_WIDTH] } { set AXI_DDR_RUSER_WIDTH 1 }
if { ![info exists AXI_DDR_MAX_BURST_LEN] } { set AXI_DDR_MAX_BURST_LEN 256 }
if { ![info exists AXI_DDR_NARROW_BURST] } { set AXI_DDR_NARROW_BURST 0 }
if { ![info exists AXI_DDR_FIXED_BURST] } { set AXI_DDR_FIXED_BURST 0 }
if { ![info exists AXI_DDR_WRAP_BURST] } { set AXI_DDR_WRAP_BURST 0 }

if { ![info exists HBM_CH] } { set HBM_CH 1 }
if { ![info exists HBM_ENABLE] } { set HBM_ENABLE 0 }
if { ![info exists HBM_GROUP_SIZE] } { set HBM_GROUP_SIZE 1 }
if { ![info exists AXI_HBM_DATA_WIDTH] } { set AXI_HBM_DATA_WIDTH 256 }
if { ![info exists AXI_HBM_ADDR_WIDTH] } { set AXI_HBM_ADDR_WIDTH 32 }
if { ![info exists AXI_HBM_STRB_WIDTH] } { set AXI_HBM_STRB_WIDTH [expr $AXI_HBM_DATA_WIDTH / 8] }
if { ![info exists AXI_HBM_ID_WIDTH] } { set AXI_HBM_ID_WIDTH 8 }
if { ![info exists AXI_HBM_AWUSER_ENABLE] } { set AXI_HBM_AWUSER_ENABLE 0 }
if { ![info exists AXI_HBM_AWUSER_WIDTH] } { set AXI_HBM_AWUSER_WIDTH 1 }
if { ![info exists AXI_HBM_WUSER_ENABLE] } { set AXI_HBM_WUSER_ENABLE 0 }
if { ![info exists AXI_HBM_WUSER_WIDTH] } { set AXI_HBM_WUSER_WIDTH 1 }
if { ![info exists AXI_HBM_BUSER_ENABLE] } { set AXI_HBM_BUSER_ENABLE 0 }
if { ![info exists AXI_HBM_BUSER_WIDTH] } { set AXI_HBM_BUSER_WIDTH 1 }
if { ![info exists AXI_HBM_ARUSER_ENABLE] } { set AXI_HBM_ARUSER_ENABLE 0 }
if { ![info exists AXI_HBM_ARUSER_WIDTH] } { set AXI_HBM_ARUSER_WIDTH 1 }
if { ![info exists AXI_HBM_RUSER_ENABLE] } { set AXI_HBM_RUSER_ENABLE 0 }
if { ![info exists AXI_HBM_RUSER_WIDTH] } { set AXI_HBM_RUSER_WIDTH 1 }
if { ![info exists AXI_HBM_MAX_BURST_LEN] } { set AXI_HBM_MAX_BURST_LEN 256 }
if { ![info exists AXI_HBM_NARROW_BURST] } { set AXI_HBM_NARROW_BURST 0 }
if { ![info exists AXI_HBM_FIXED_BURST] } { set AXI_HBM_FIXED_BURST 0 }
if { ![info exists AXI_HBM_WRAP_BURST] } { set AXI_HBM_WRAP_BURST 0 }

if { ![info exists APP_ID] } { set APP_ID 0x00000000 }
if { ![info exists APP_ENABLE] } { set APP_ENABLE 0 }
if { ![info exists APP_CTRL_ENABLE] } { set APP_CTRL_ENABLE 1 }
if { ![info exists APP_DMA_ENABLE] } { set APP_DMA_ENABLE 1 }
if { ![info exists APP_AXIS_DIRECT_ENABLE] } { set APP_AXIS_DIRECT_ENABLE 1 }
if { ![info exists APP_AXIS_SYNC_ENABLE] } { set APP_AXIS_SYNC_ENABLE 1 }
if { ![info exists APP_AXIS_IF_ENABLE] } { set APP_AXIS_IF_ENABLE 1 }
if { ![info exists APP_STAT_ENABLE] } { set APP_STAT_ENABLE 1 }

if { ![info exists AXI_DATA_WIDTH] } { set AXI_DATA_WIDTH 128 }
if { ![info exists AXI_ADDR_WIDTH] } { set AXI_ADDR_WIDTH 64 }
if { ![info exists AXI_STRB_WIDTH] } { set AXI_STRB_WIDTH [expr $AXI_DATA_WIDTH / 8] }
if { ![info exists AXI_ID_WIDTH] } { set AXI_ID_WIDTH 8 }

if { ![info exists DMA_IMM_ENABLE] } { set DMA_IMM_ENABLE 0 }
if { ![info exists DMA_IMM_WIDTH] } { set DMA_IMM_WIDTH 32 }
if { ![info exists DMA_LEN_WIDTH] } { set DMA_LEN_WIDTH 16 }
if { ![info exists DMA_TAG_WIDTH] } { set DMA_TAG_WIDTH 16 }
if { ![info exists RAM_ADDR_WIDTH] } { set RAM_ADDR_WIDTH [expr int(ceil(log(max($TX_RAM_SIZE, $RX_RAM_SIZE)) / log(2)))] }
if { ![info exists RAM_PIPELINE] } { set RAM_PIPELINE 2 }
if { ![info exists AXI_DMA_MAX_BURST_LEN] } { set AXI_DMA_MAX_BURST_LEN 256 }
if { ![info exists AXI_DMA_READ_USE_ID] } { set AXI_DMA_READ_USE_ID 0 }
if { ![info exists AXI_DMA_WRITE_USE_ID] } { set AXI_DMA_WRITE_USE_ID 1 }
if { ![info exists AXI_DMA_READ_OP_TABLE_SIZE] } { set AXI_DMA_READ_OP_TABLE_SIZE [expr 2 ** $AXI_ID_WIDTH] }
if { ![info exists AXI_DMA_WRITE_OP_TABLE_SIZE] } { set AXI_DMA_WRITE_OP_TABLE_SIZE [expr 2 ** $AXI_ID_WIDTH] }

if { ![info exists IRQ_COUNT] } { set IRQ_COUNT 32 }

if { ![info exists AXIL_CTRL_DATA_WIDTH] } { set AXIL_CTRL_DATA_WIDTH 32 }
if { ![info exists AXIL_CTRL_ADDR_WIDTH] } { set AXIL_CTRL_ADDR_WIDTH 24 }
if { ![info exists AXIL_CTRL_STRB_WIDTH] } { set AXIL_CTRL_STRB_WIDTH [expr $AXIL_CTRL_DATA_WIDTH / 8] }
if { ![info exists AXIL_IF_CTRL_ADDR_WIDTH] } { set AXIL_IF_CTRL_ADDR_WIDTH [expr $AXIL_CTRL_ADDR_WIDTH - int(ceil(log($IF_COUNT) / log(2)))] }
if { ![info exists AXIL_CSR_ADDR_WIDTH] } { set AXIL_CSR_ADDR_WIDTH [expr $AXIL_IF_CTRL_ADDR_WIDTH - 5 - int(ceil(log(($SCHED_PER_IF + 4 + 7) / 8) / log(2)))] }
if { ![info exists AXIL_CSR_PASSTHROUGH_ENABLE] } { set AXIL_CSR_PASSTHROUGH_ENABLE 0 }
if { ![info exists RB_NEXT_PTR] } { set RB_NEXT_PTR 0x0 }

if { ![info exists AXIL_APP_CTRL_DATA_WIDTH] } { set AXIL_APP_CTRL_DATA_WIDTH $AXIL_CTRL_DATA_WIDTH }
if { ![info exists AXIL_APP_CTRL_ADDR_WIDTH] } { set AXIL_APP_CTRL_ADDR_WIDTH 24 }
if { ![info exists AXIL_APP_CTRL_STRB_WIDTH] } { set AXIL_APP_CTRL_STRB_WIDTH [expr $AXIL_APP_CTRL_DATA_WIDTH / 8] }

if { ![info exists AXIS_DATA_WIDTH] } { set AXIS_DATA_WIDTH 64 }
if { ![info exists AXIS_KEEP_WIDTH] } { set AXIS_KEEP_WIDTH [expr $AXIS_DATA_WIDTH / 8] }
if { ![info exists AXIS_SYNC_DATA_WIDTH] } { set AXIS_SYNC_DATA_WIDTH $AXIS_DATA_WIDTH }
if { ![info exists AXIS_IF_DATA_WIDTH] } { set AXIS_IF_DATA_WIDTH [expr $AXIS_SYNC_DATA_WIDTH * 2 ** int(ceil(log($PORTS_PER_IF) / log(2)))] }
if { ![info exists AXIS_TX_USER_WIDTH] } { set AXIS_TX_USER_WIDTH [expr $TX_TAG_WIDTH + 1] }
if { ![info exists AXIS_RX_USER_WIDTH] } { set AXIS_RX_USER_WIDTH [expr { $PTP_TS_ENABLE == 1 ? $PTP_TS_WIDTH : 0 } + 1] }
if { ![info exists AXIS_RX_USE_READY] } { set AXIS_RX_USE_READY 0 }
if { ![info exists AXIS_TX_PIPELINE] } { set AXIS_TX_PIPELINE 0 }
if { ![info exists AXIS_TX_FIFO_PIPELINE] } { set AXIS_TX_FIFO_PIPELINE 2 }
if { ![info exists AXIS_TX_TS_PIPELINE] } { set AXIS_TX_TS_PIPELINE 0 }
if { ![info exists AXIS_RX_PIPELINE] } { set AXIS_RX_PIPELINE 0 }
if { ![info exists AXIS_RX_FIFO_PIPELINE] } { set AXIS_RX_FIFO_PIPELINE 2 }

if { ![info exists STAT_ENABLE] } { set STAT_ENABLE 1 }
if { ![info exists STAT_DMA_ENABLE] } { set STAT_DMA_ENABLE 1 }
if { ![info exists STAT_AXI_ENABLE] } { set STAT_AXI_ENABLE 1 }
if { ![info exists STAT_INC_WIDTH] } { set STAT_INC_WIDTH 24 }
if { ![info exists STAT_ID_WIDTH] } { set STAT_ID_WIDTH 12 }

# Application-Corundum core interfacing configuration
if { ![info exists DMA_ADDR_WIDTH] } { set DMA_ADDR_WIDTH $AXI_ADDR_WIDTH }
if { ![info exists RAM_SEL_WIDTH] } { set RAM_SEL_WIDTH [expr int(ceil(log($IF_COUNT + ( $APP_ENABLE && $APP_DMA_ENABLE ? 1 : 0 )))) + 2] }
if { ![info exists RAM_SEG_COUNT] } { set RAM_SEG_COUNT 2 }
if { ![info exists RAM_SEG_DATA_WIDTH] } { set RAM_SEG_DATA_WIDTH $AXI_DATA_WIDTH }
if { ![info exists RAM_SEG_BE_WIDTH] } { set RAM_SEG_BE_WIDTH [expr $RAM_SEG_DATA_WIDTH / 8] }
if { ![info exists RAM_SEG_ADDR_WIDTH] } { set RAM_SEG_ADDR_WIDTH [expr $RAM_ADDR_WIDTH - int(ceil(log(2 * $RAM_SEG_BE_WIDTH)))] }
if { ![info exists AXIS_SYNC_KEEP_WIDTH] } { set AXIS_SYNC_KEEP_WIDTH [expr $AXIS_SYNC_DATA_WIDTH / ($AXIS_DATA_WIDTH / $AXIS_KEEP_WIDTH)] }
if { ![info exists AXIS_SYNC_TX_USER_WIDTH] } { set AXIS_SYNC_TX_USER_WIDTH $AXIS_TX_USER_WIDTH }
if { ![info exists AXIS_SYNC_RX_USER_WIDTH] } { set AXIS_SYNC_RX_USER_WIDTH $AXIS_RX_USER_WIDTH }
if { ![info exists AXIS_IF_KEEP_WIDTH] } { set AXIS_IF_KEEP_WIDTH [expr $AXIS_IF_DATA_WIDTH / ($AXIS_DATA_WIDTH / $AXIS_KEEP_WIDTH)] }
if { ![info exists AXIS_IF_TX_ID_WIDTH] } { set AXIS_IF_TX_ID_WIDTH $TX_QUEUE_INDEX_WIDTH }
if { ![info exists AXIS_IF_RX_ID_WIDTH] } { set AXIS_IF_RX_ID_WIDTH [expr max(int(ceil(log($PORTS_PER_IF) / log(2))), 1)] }
if { ![info exists AXIS_IF_TX_DEST_WIDTH] } { set AXIS_IF_TX_DEST_WIDTH [expr int(ceil(log($PORTS_PER_IF) / log(2))) + 4] }
if { ![info exists AXIS_IF_RX_DEST_WIDTH] } { set AXIS_IF_RX_DEST_WIDTH [expr $RX_QUEUE_INDEX_WIDTH + 1] }
if { ![info exists AXIS_IF_TX_USER_WIDTH] } { set AXIS_IF_TX_USER_WIDTH $AXIS_TX_USER_WIDTH }
if { ![info exists AXIS_IF_RX_USER_WIDTH] } { set AXIS_IF_RX_USER_WIDTH $AXIS_RX_USER_WIDTH }
