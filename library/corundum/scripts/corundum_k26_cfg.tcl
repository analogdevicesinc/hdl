###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set build_date [clock seconds]
set git_hash 00000000
set git_tag ""
set tag_ver 0.0.1

puts "Build date: ${build_date}"
puts "Git hash: ${git_hash}"
puts "Git tag: ${git_tag}"

# FW and board IDs
set fpga_id [expr 0x4A49093]
set fw_id [expr 0x00000000]
set fw_ver $tag_ver
set board_vendor_id [expr 0x10ee]
set board_device_id [expr 0x9104]
set board_ver 1.0
set release_info [expr 0x00000000]

# FW ID block
set FPGA_ID [format "32'h%08x" $fpga_id]
set FW_ID [format "32'h%08x" $fw_id]
set FW_VER [format "32'h%02x%02x%02x%02x" {*}[split $fw_ver .-] 0 0 0 0]
set BOARD_ID [format "32'h%04x%04x" $board_vendor_id $board_device_id]
set BOARD_VER [format "32'h%02x%02x%02x%02x" {*}[split $board_ver .-] 0 0 0 0]
set BUILD_DATE  "32'd${build_date}"
set GIT_HASH  "32'h${git_hash}"
set RELEASE_INFO  [format "32'h%08x" $release_info]

# Board configuration
set  TDMA_BER_ENABLE "0"

# Structural configuration
set IF_COUNT "1"
set PORTS_PER_IF "1"
set PORT_COUNT "1"
set SCHED_PER_IF $PORTS_PER_IF
set PORT_MASK "0"

# Clock configuration
set CLK_PERIOD_NS_NUM "4"
set CLK_PERIOD_NS_DENOM "1"

# PTP configuration
set PTP_CLOCK_PIPELINE "0"
set PTP_CLOCK_CDC_PIPELINE "0"
set PTP_PORT_CDC_PIPELINE "0"
set PTP_PEROUT_ENABLE "1"
set PTP_PEROUT_COUNT "1"

# Queue manager configuration
set EVENT_QUEUE_OP_TABLE_SIZE "32"
set TX_QUEUE_OP_TABLE_SIZE "32"
set RX_QUEUE_OP_TABLE_SIZE "32"
set CQ_OP_TABLE_SIZE "32"
set EQN_WIDTH "2"
set TX_QUEUE_INDEX_WIDTH "5"
set RX_QUEUE_INDEX_WIDTH "5"
set CQN_WIDTH [expr max($TX_QUEUE_INDEX_WIDTH, $RX_QUEUE_INDEX_WIDTH) + 1]
set TX_QUEUE_PIPELINE [expr 3 + max($TX_QUEUE_INDEX_WIDTH - 12, 0)]
set RX_QUEUE_PIPELINE [expr 3 + max($RX_QUEUE_INDEX_WIDTH - 12, 0)]
set EQ_PIPELINE "3"
set CQ_PIPELINE [expr 3 + max($CQN_WIDTH - 12, 0)]

# TX and RX engine configuration
set TX_DESC_TABLE_SIZE "32"
set RX_DESC_TABLE_SIZE "32"
set RX_INDIR_TBL_ADDR_WIDTH [expr min($RX_QUEUE_INDEX_WIDTH, 8)]

# Scheduler configuration
set TX_SCHEDULER_OP_TABLE_SIZE $TX_DESC_TABLE_SIZE
set TX_SCHEDULER_PIPELINE $TX_QUEUE_PIPELINE
set TDMA_INDEX_WIDTH "6"

# Interface configuration
set PTP_TS_ENABLE "1"
set PTP_TS_FMT_TOD "0"
set TX_CPL_FIFO_DEPTH "32"
set TX_CHECKSUM_ENABLE "1"
set RX_HASH_ENABLE "1"
set RX_CHECKSUM_ENABLE "1"
set PFC_ENABLE "1"
set LFC_ENABLE $PFC_ENABLE
set ENABLE_PADDING "1"
set ENABLE_DIC "1"
set MIN_FRAME_LENGTH "64"
set TX_FIFO_DEPTH "32768"
set RX_FIFO_DEPTH "65536"
set MAX_TX_SIZE "9214"
set MAX_RX_SIZE "9214"
set TX_RAM_SIZE "32768"
set RX_RAM_SIZE "32768"

# Application block configuration
set APP_ID "32'h00000000"
set APP_ENABLE "0"
set APP_CTRL_ENABLE "0"
set APP_DMA_ENABLE "0"
set APP_AXIS_DIRECT_ENABLE "0"
set APP_AXIS_SYNC_ENABLE "0"
set APP_AXIS_IF_ENABLE "0"
set APP_STAT_ENABLE "0"

# AXI DMA interface configuration
# dict set params AXI_ADDR_WIDTH [get_property CONFIG.ADDR_WIDTH $s_axi_dma]
set AXI_ADDR_WIDTH 64
set AXI_ID_WIDTH 8

# DMA interface configuration
set DMA_IMM_ENABLE "0"
set DMA_IMM_WIDTH "32"
set DMA_LEN_WIDTH "16"
set DMA_TAG_WIDTH "16"
set RAM_ADDR_WIDTH [expr int(ceil(log(max($TX_RAM_SIZE, $RX_RAM_SIZE))/log(2)))]
set RAM_PIPELINE "2"
# NOTE: Querying the BD top-level interface port (or even the ZynqMP's interface
#       pin) yields 256 for the maximum burst length, instead of 16, which is
#       the actually supported length (due to ZynqMP using AXI3 internally).
#dict set params AXI_DMA_MAX_BURST_LEN [get_property CONFIG.MAX_BURST_LENGTH $s_axi_dma]
set AXI_DMA_MAX_BURST_LEN "16"

# AXI lite interface configuration (control)
set AXIL_CTRL_DATA_WIDTH 32
set AXIL_CTRL_ADDR_WIDTH 24

# AXI lite interface configuration (application control)
set AXIL_APP_CTRL_DATA_WIDTH 32
set AXIL_APP_CTRL_ADDR_WIDTH 24

set AXI_DATA_WIDTH 128
set AXI_ADDR_WIDTH 64
set AXI_ID_WIDTH 8

# Interrupt configuration
set IRQ_COUNT "8"
set IRQ_STRETCH "10"

# Ethernet interface configuration
set AXIS_ETH_TX_PIPELINE "0"
set AXIS_ETH_TX_FIFO_PIPELINE "2"
set AXIS_ETH_TX_TS_PIPELINE "0"
set AXIS_ETH_RX_PIPELINE "0"
set AXIS_ETH_RX_FIFO_PIPELINE "2"

# Statistics counter subsystem
set STAT_ENABLE "0"
set STAT_DMA_ENABLE "0"
set STAT_AXI_ENABLE "0"
set STAT_INC_WIDTH "24"
set STAT_ID_WIDTH "12"
