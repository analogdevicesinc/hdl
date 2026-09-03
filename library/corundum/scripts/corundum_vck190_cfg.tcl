###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Corundum configuration for the AMD Versal VCK190 (xcvc1902), MRMAC path.

set build_date [clock seconds]
set git_hash 00000000
set git_tag ""
set tag_ver 0.0.1

puts "Build date: ${build_date}"
puts "Git hash: ${git_hash}"
puts "Git tag: ${git_tag}"

# FW and board IDs (cosmetic; used for driver identification)
set fpga_id [expr 0x04C22093]
set fw_id [expr 0x00000000]
set fw_ver $tag_ver
set board_vendor_id [expr 0x10ee]
set board_device_id [expr 0x90C1]
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
set TDMA_BER_ENABLE "0"

# Structural configuration
# One MRMAC (one physical QSFP cage, 4 lanes bonded) => 1 x 100G MAC port.
set IF_COUNT "1"
set PORTS_PER_IF "1"
set SCHED_PER_IF $PORTS_PER_IF
set PORT_COUNT "1"
set QSFP_CNT "1"
set PORT_MASK "0"

# Clock configuration (Corundum core clock; wired to a PL/CIPS clock in the
# consumer project - nominally 250 MHz).
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
set EQN_WIDTH "5"
set TX_QUEUE_INDEX_WIDTH "8"
set RX_QUEUE_INDEX_WIDTH "8"
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
set PTP_TS_WIDTH "48"
set TX_CPL_FIFO_DEPTH "32"
set TX_TAG_WIDTH "16"
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
set RX_RAM_SIZE "131072"

# Register-block chain. corundum_core's last internal register block sets its
# "next header" pointer to this value, which is how software walking the chain finds
# the blocks that live in the ETHERNET WRAPPER rather than in the core. 0x1000 is the
# RB_BASE_ADDR ethernet_vck190.v uses for its own blocks, matching VCU118
# (corundum_vcu118_cfg.tcl:168 -- the same 0x00001000).
#
# Leaving this unset (the corundum_common_cfg.tcl default is 0x0) TERMINATES the chain
# inside the core, so the wrapper's rb_drp block is unreachable no matter how it is
# wired: software never learns its address. The two go together -- if the wrapper ever
# stops instantiating register blocks, set this back to 0x0 or software will walk into
# a region that never acks.
set RB_NEXT_PTR 0x00001000

# Application block configuration (disabled - minimal MAC swap, no app core)
set APP_ID "32'h00000000"
set APP_ENABLE "0"
set APP_CTRL_ENABLE "0"
set APP_DMA_ENABLE "0"
set APP_AXIS_DIRECT_ENABLE "0"
set APP_AXIS_SYNC_ENABLE "0"
set APP_AXIS_IF_ENABLE "0"
set APP_STAT_ENABLE "0"

# Host AXI (DMA to the CIPS/NoC host). MUST be 512b, NOT 128b - this is forced by
# two hard RTL assertions in the corundum DMA path (not a free choice):
#   * dma_if_axi_rd/wr.v: RAM_DATA_WIDTH must EQUAL AXI_DATA_WIDTH*2.
#   * dma_client_axis_source.v: RAM_DATA_WIDTH must be >= AXIS_DATA_WIDTH (512).
# => AXI_DATA_WIDTH*2 >= 512 => AXI_DATA_WIDTH >= 256. 128b synthesis-errors with
# "AXI stream interface width must not be wider than RAM interface width".
# Bandwidth also demands it: 100GE = 12.5 GB/s; 512b @ 250 MHz = 128 Gbps (ok),
# 128b @ 250 MHz = 32 Gbps (cannot carry the line). Matches the VCU118 CMAC 100G
# reference (AXI_DATA_WIDTH 512 -> RAM 1024 = 2x512). The Versal NoC handles a 512b
# AXI master natively, so the CIPS/NoC host wiring binds m_axi at 512b.
set AXI_DATA_WIDTH 512
set AXI_ADDR_WIDTH 64
set AXI_STRB_WIDTH [expr $AXI_DATA_WIDTH / 8]
set AXI_ID_WIDTH 8

# DMA interface configuration
set DMA_IMM_ENABLE "0"
set DMA_IMM_WIDTH "32"
set DMA_LEN_WIDTH "16"
set DMA_TAG_WIDTH "16"
set RAM_ADDR_WIDTH [expr int(ceil(log(max($TX_RAM_SIZE, $RX_RAM_SIZE))/log(2)))]
set RAM_PIPELINE "2"
set AXI_DMA_MAX_BURST_LEN "256"

# Segmented DMA RAM interface. RAM width = RAM_SEG_COUNT * RAM_SEG_DATA_WIDTH must
# be BOTH == AXI_DATA_WIDTH*2 (dma_if_axi_rd/wr.v) AND >= AXIS_DATA_WIDTH=512
# (dma_client_axis_source.v). With AXI_DATA_WIDTH=512 -> RAM = 1024 = 2 x 512.
# Identical to the VCU118 CMAC 100G reference. (common_cfg would derive
# RAM_SEG_DATA_WIDTH = AXI_DATA_WIDTH = 512 here anyway; set explicitly to pin it.)
set RAM_SEL_WIDTH 3
set RAM_SEG_COUNT 2
set RAM_SEG_DATA_WIDTH 512
set RAM_SEG_BE_WIDTH [expr $RAM_SEG_DATA_WIDTH / 8]
set DMA_ADDR_WIDTH 64

# Interrupt configuration
set IRQ_COUNT "8"

# AXI lite interface configuration (control)
set AXIL_CTRL_DATA_WIDTH 32
set AXIL_CTRL_ADDR_WIDTH 24

# AXI lite interface configuration (application control)
set AXIL_APP_CTRL_DATA_WIDTH 32
set AXIL_APP_CTRL_ADDR_WIDTH 24

# Ethernet interface configuration
# ETH_RX_CLK_FROM_TX: the MRMAC 100G shim runs rx/tx AXIS on the shared fabric
# AXIS clock, so rx clock is not derived from tx - leave 0. ETH_RS_FEC_ENABLE:
# 100GE CAUI-4 RS-FEC (clause 91) is configured INSIDE the MRMAC hard IP in the
# block design, not as soft logic in this wrapper - leave 0 here.
set ETH_RX_CLK_FROM_TX "0"
set ETH_RS_FEC_ENABLE "0"

set AXIS_TX_PIPELINE "0"
set AXIS_TX_FIFO_PIPELINE "2"
set AXIS_TX_TS_PIPELINE "0"
set AXIS_RX_PIPELINE "0"
set AXIS_RX_FIFO_PIPELINE "2"

# AXI Stream (MAC datapath) - 512-bit for the single 100G port
set AXIS_DATA_WIDTH 512
set AXIS_KEEP_WIDTH [expr $AXIS_DATA_WIDTH / 8]
set AXIS_TX_USER_WIDTH 17
set AXIS_RX_USER_WIDTH 49

# Statistics counter subsystem
set STAT_ENABLE "1"
set STAT_DMA_ENABLE "1"
set STAT_AXI_ENABLE "1"
set STAT_INC_WIDTH "24"
set STAT_ID_WIDTH "12"
