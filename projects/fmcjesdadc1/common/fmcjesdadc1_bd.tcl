
# ad9250

create_bd_port -dir I rx_ref_clk
create_bd_port -dir O rx_sync
create_bd_port -dir O rx_sysref
create_bd_port -dir I -from 3 -to 0 rx_data_p
create_bd_port -dir I -from 3 -to 0 rx_data_n

create_bd_port -dir O -from 127 -to 0 rx_gt_data
create_bd_port -dir I -from 63 -to 0 rx_gt_data_0
create_bd_port -dir I -from 63 -to 0 rx_gt_data_1

create_bd_port -dir O adc_clk
create_bd_port -dir O adc_0_enable_a
create_bd_port -dir O adc_0_valid_a
create_bd_port -dir O -from 31 -to 0 adc_0_data_a
create_bd_port -dir O adc_0_enable_b
create_bd_port -dir O adc_0_valid_b
create_bd_port -dir O -from 31 -to 0 adc_0_data_b
create_bd_port -dir O adc_1_enable_a
create_bd_port -dir O adc_1_valid_a
create_bd_port -dir O -from 31 -to 0 adc_1_data_a
create_bd_port -dir O adc_1_enable_b
create_bd_port -dir O adc_1_valid_b
create_bd_port -dir O -from 31 -to 0 adc_1_data_b
create_bd_port -dir I dma_0_wr
create_bd_port -dir I dma_0_sync
create_bd_port -dir I -from 63 -to 0 dma_0_data
create_bd_port -dir I dma_1_wr
create_bd_port -dir I dma_1_sync
create_bd_port -dir I -from 63 -to 0 dma_1_data

# adc peripherals

set axi_ad9250_0_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9250:1.0 axi_ad9250_0_core]
set axi_ad9250_1_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9250:1.0 axi_ad9250_1_core]

set axi_ad9250_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.0 axi_ad9250_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9250_jesd
set_property -dict [list CONFIG.C_LANES {4}] $axi_ad9250_jesd

set axi_ad9250_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_ad9250_gt]
set_property -dict [list CONFIG.PCORE_NUM_OF_RX_LANES {4}] $axi_ad9250_gt
set_property -dict [list CONFIG.PCORE_CPLL_FBDIV {2}] $axi_ad9250_gt
set_property -dict [list CONFIG.PCORE_RX_OUT_DIV {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.PCORE_TX_OUT_DIV {1}] $axi_ad9250_gt
set_property -dict [list CONFIG.PCORE_RX_CLK25_DIV {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.PCORE_TX_CLK25_DIV {10}] $axi_ad9250_gt
set_property -dict [list CONFIG.PCORE_PMA_RSV {0x00018480}] $axi_ad9250_gt
set_property -dict [list CONFIG.PCORE_RX_CDR_CFG {0x03000023ff20400020}] $axi_ad9250_gt

set axi_ad9250_0_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9250_0_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9250_0_dma

set axi_ad9250_1_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9250_1_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9250_1_dma

# constants for avoiding errors when validating bd

set constant_1bit   [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_1bit]
set_property -dict [list CONFIG.CONST_VAL {0}] $constant_1bit

set constant_4bit  [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_4bit]
set_property -dict [list CONFIG.CONST_WIDTH {4}] $constant_4bit
set_property -dict [list CONFIG.CONST_VAL {0}] $constant_4bit

set constant_16bit  [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_16bit]
set_property -dict [list CONFIG.CONST_WIDTH {16}] $constant_16bit
set_property -dict [list CONFIG.CONST_VAL {0}] $constant_16bit

set constant_128bit  [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_128bit]
set_property -dict [list CONFIG.CONST_WIDTH {128}] $constant_128bit
set_property -dict [list CONFIG.CONST_VAL {0}] $constant_128bit

# connections (gt)

ad_connect  axi_ad9250_gt/ref_clk_c  rx_ref_clk
ad_connect  axi_ad9250_gt/rx_data_p  rx_data_p
ad_connect  axi_ad9250_gt/rx_data_n  rx_data_n
ad_connect  axi_ad9250_gt/rx_sync    rx_sync
ad_connect  axi_ad9250_gt/rx_sysref  rx_sysref

# connections (adc)

ad_connect  axi_ad9250_gt_rx_clk  axi_ad9250_gt/rx_clk_g
ad_connect  axi_ad9250_gt_rx_clk  axi_ad9250_gt/rx_clk
ad_connect  axi_ad9250_gt_rx_clk  axi_ad9250_gt/tx_clk
ad_connect  axi_ad9250_gt_rx_clk  axi_ad9250_0_core/rx_clk
ad_connect  axi_ad9250_gt_rx_clk  axi_ad9250_1_core/rx_clk
ad_connect  axi_ad9250_gt_rx_clk  axi_ad9250_jesd/rx_core_clk
ad_connect  axi_ad9250_gt_rx_clk  adc_clk
ad_connect  axi_ad9250_gt_rx_rst  axi_ad9250_gt/rx_jesd_rst
ad_connect  axi_ad9250_gt_rx_rst  axi_ad9250_jesd/rx_reset

ad_connect  axi_ad9250_gt_rx_sysref         axi_ad9250_jesd/rx_sysref

create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_rx_gt_charisk
set_property -dict [list CONFIG.CH_DW {4}] [get_bd_cells util_bsplit_rx_gt_charisk]
set_property -dict [list CONFIG.CH_CNT {4}] [get_bd_cells util_bsplit_rx_gt_charisk]

ad_connect  util_bsplit_rx_gt_charisk/data axi_ad9250_gt/rx_gt_charisk
ad_connect  util_bsplit_rx_gt_charisk/split_data_0 axi_ad9250_jesd/gt0_rxcharisk
ad_connect  util_bsplit_rx_gt_charisk/split_data_1 axi_ad9250_jesd/gt1_rxcharisk
ad_connect  util_bsplit_rx_gt_charisk/split_data_2 axi_ad9250_jesd/gt2_rxcharisk
ad_connect  util_bsplit_rx_gt_charisk/split_data_3 axi_ad9250_jesd/gt3_rxcharisk

create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_rx_gt_disperr
set_property -dict [list CONFIG.CH_DW {4}] [get_bd_cells util_bsplit_rx_gt_disperr]
set_property -dict [list CONFIG.CH_CNT {4}] [get_bd_cells util_bsplit_rx_gt_disperr]

ad_connect  util_bsplit_rx_gt_disperr/data axi_ad9250_gt/rx_gt_disperr
ad_connect  util_bsplit_rx_gt_disperr/split_data_0 axi_ad9250_jesd/gt0_rxdisperr
ad_connect  util_bsplit_rx_gt_disperr/split_data_1 axi_ad9250_jesd/gt1_rxdisperr
ad_connect  util_bsplit_rx_gt_disperr/split_data_2 axi_ad9250_jesd/gt2_rxdisperr
ad_connect  util_bsplit_rx_gt_disperr/split_data_3 axi_ad9250_jesd/gt3_rxdisperr

create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_rx_gt_notintable
set_property -dict [list CONFIG.CH_DW {4}] [get_bd_cells util_bsplit_rx_gt_notintable]
set_property -dict [list CONFIG.CH_CNT {4}] [get_bd_cells util_bsplit_rx_gt_notintable]

ad_connect  util_bsplit_rx_gt_notintable/data axi_ad9250_gt/rx_gt_notintable
ad_connect  util_bsplit_rx_gt_notintable/split_data_0 axi_ad9250_jesd/gt0_rxnotintable
ad_connect  util_bsplit_rx_gt_notintable/split_data_1 axi_ad9250_jesd/gt1_rxnotintable
ad_connect  util_bsplit_rx_gt_notintable/split_data_2 axi_ad9250_jesd/gt2_rxnotintable
ad_connect  util_bsplit_rx_gt_notintable/split_data_3 axi_ad9250_jesd/gt3_rxnotintable

create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_rx_gt_data
set_property -dict [list CONFIG.CH_DW {32}] [get_bd_cells util_bsplit_rx_gt_data]
set_property -dict [list CONFIG.CH_CNT {4}] [get_bd_cells util_bsplit_rx_gt_data]

ad_connect  util_bsplit_rx_gt_data/data axi_ad9250_gt/rx_gt_data
ad_connect  util_bsplit_rx_gt_data/split_data_0 axi_ad9250_jesd/gt0_rxdata
ad_connect  util_bsplit_rx_gt_data/split_data_1 axi_ad9250_jesd/gt1_rxdata
ad_connect  util_bsplit_rx_gt_data/split_data_2 axi_ad9250_jesd/gt2_rxdata
ad_connect  util_bsplit_rx_gt_data/split_data_3 axi_ad9250_jesd/gt3_rxdata

ad_connect  axi_ad9250_gt/rx_rst_done       axi_ad9250_jesd/rx_reset_done
ad_connect  axi_ad9250_gt/rx_ip_comma_align axi_ad9250_jesd/rxencommaalign_out
ad_connect  axi_ad9250_gt/rx_ip_sync        axi_ad9250_jesd/rx_sync
ad_connect  axi_ad9250_gt/rx_ip_sof         axi_ad9250_jesd/rx_start_of_frame
ad_connect  axi_ad9250_gt/rx_ip_data        axi_ad9250_jesd/rx_tdata

ad_connect  axi_ad9250_gt/rx_data           rx_gt_data
ad_connect  axi_ad9250_0_core/rx_data       rx_gt_data_0
ad_connect  axi_ad9250_1_core/rx_data       rx_gt_data_1

ad_connect  axi_ad9250_0_core/adc_clk       axi_ad9250_0_dma/fifo_wr_clk
ad_connect  axi_ad9250_1_core/adc_clk       axi_ad9250_1_dma/fifo_wr_clk

ad_connect  adc_0_enable_a axi_ad9250_0_core/adc_enable_a
ad_connect  adc_0_valid_a  axi_ad9250_0_core/adc_valid_a
ad_connect  adc_0_data_a   axi_ad9250_0_core/adc_data_a
ad_connect  adc_0_enable_b axi_ad9250_0_core/adc_enable_b
ad_connect  adc_0_valid_b  axi_ad9250_0_core/adc_valid_b
ad_connect  adc_0_data_b   axi_ad9250_0_core/adc_data_b
ad_connect  adc_1_enable_a axi_ad9250_1_core/adc_enable_a
ad_connect  adc_1_valid_a  axi_ad9250_1_core/adc_valid_a
ad_connect  adc_1_data_a   axi_ad9250_1_core/adc_data_a
ad_connect  adc_1_enable_b axi_ad9250_1_core/adc_enable_b
ad_connect  adc_1_valid_b  axi_ad9250_1_core/adc_valid_b
ad_connect  adc_1_data_b   axi_ad9250_1_core/adc_data_b

ad_connect  axi_ad9250_0_dma/fifo_wr_en     dma_0_wr
ad_connect  axi_ad9250_0_dma/fifo_wr_sync   dma_0_sync
ad_connect  axi_ad9250_0_dma/fifo_wr_din    dma_0_data
ad_connect  axi_ad9250_1_dma/fifo_wr_en     dma_1_wr
ad_connect  axi_ad9250_1_dma/fifo_wr_sync   dma_1_sync
ad_connect  axi_ad9250_1_dma/fifo_wr_din    dma_1_data

ad_connect  axi_ad9250_0_core/adc_dovf      axi_ad9250_0_dma/fifo_wr_overflow
ad_connect  axi_ad9250_1_core/adc_dovf      axi_ad9250_1_dma/fifo_wr_overflow

# ila

set ila_jesd_rx_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_jesd_rx_mon]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_NUM_OF_PROBES {9}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {128}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH {32}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE2_WIDTH {32}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE3_WIDTH {32}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE4_WIDTH {32}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE5_WIDTH {1}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE6_WIDTH {1}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE7_WIDTH {1}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE8_WIDTH {1}] $ila_jesd_rx_mon

ad_connect  axi_ad9250_gt_rx_clk            ila_jesd_rx_mon/CLK
ad_connect  axi_ad9250_gt_rx_data           ila_jesd_rx_mon/PROBE0
ad_connect  axi_ad9250_0_core/adc_data_a    ila_jesd_rx_mon/PROBE1
ad_connect  axi_ad9250_0_core/adc_data_b    ila_jesd_rx_mon/PROBE2
ad_connect  axi_ad9250_1_core/adc_data_a    ila_jesd_rx_mon/PROBE3
ad_connect  axi_ad9250_1_core/adc_data_b    ila_jesd_rx_mon/PROBE4
ad_connect  axi_ad9250_0_core/adc_valid_a   ila_jesd_rx_mon/PROBE5
ad_connect  axi_ad9250_0_core/adc_valid_b   ila_jesd_rx_mon/PROBE6
ad_connect  axi_ad9250_1_core/adc_valid_a   ila_jesd_rx_mon/PROBE7
ad_connect  axi_ad9250_1_core/adc_valid_b   ila_jesd_rx_mon/PROBE8

ad_connect  constant_1bit/dout    axi_ad9250_0_core/adc_dunf
ad_connect  constant_1bit/dout    axi_ad9250_1_core/adc_dunf
ad_connect  constant_1bit/dout    axi_ad9250_gt/ref_clk_q
ad_connect  constant_1bit/dout    axi_ad9250_gt/rx_ext_sysref
ad_connect  constant_1bit/dout    axi_ad9250_gt/tx_sync
ad_connect  constant_1bit/dout    axi_ad9250_gt/tx_ext_sysref
ad_connect  constant_4bit/dout    axi_ad9250_gt/tx_ip_sof
ad_connect  constant_16bit/dout   axi_ad9250_gt/tx_gt_charisk
ad_connect  constant_128bit/dout  axi_ad9250_gt/tx_data
ad_connect  constant_128bit/dout  axi_ad9250_gt/tx_gt_data

# interconnects

ad_cpu_interconnect 0x44A10000  axi_ad9250_0_core
ad_cpu_interconnect 0x44A20000  axi_ad9250_1_core
ad_cpu_interconnect 0x44A60000  axi_ad9250_gt
ad_cpu_interconnect 0x44A91000  axi_ad9250_jesd
ad_cpu_interconnect 0x7c420000  axi_ad9250_0_dma
ad_cpu_interconnect 0x7c430000  axi_ad9250_1_dma

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_ad9250_0_dma/m_dest_axi
ad_mem_hp2_interconnect sys_200m_clk axi_ad9250_1_dma/m_dest_axi
ad_connect  sys_cpu_resetn axi_ad9250_0_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn axi_ad9250_1_dma/m_dest_axi_aresetn

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9250_gt/m_axi

#interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9250_0_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9250_1_dma/irq

