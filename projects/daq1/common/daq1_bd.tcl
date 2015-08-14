
# daq1

create_bd_port -dir I rx_ref_clk
create_bd_port -dir O rx_sync
create_bd_port -dir I rx_sysref
create_bd_port -dir I -from 1 -to 0 rx_data_p
create_bd_port -dir I -from 1 -to 0 rx_data_n

create_bd_port -dir O dac_clk
create_bd_port -dir O dac_valid_0
create_bd_port -dir O dac_enable_0
create_bd_port -dir I -from 63 -to 0 dac_ddata_0
create_bd_port -dir O dac_valid_1
create_bd_port -dir O dac_enable_1
create_bd_port -dir I -from 63 -to 0 dac_ddata_1
create_bd_port -dir I dac_drd
create_bd_port -dir O -from 127 -to 0 dac_ddata

create_bd_port -dir O adc_clk
create_bd_port -dir O adc_enable_a
create_bd_port -dir O adc_valid_a
create_bd_port -dir O -from 31 -to 0 adc_data_a
create_bd_port -dir O adc_enable_b
create_bd_port -dir O adc_valid_b
create_bd_port -dir O -from 31 -to 0 adc_data_b
create_bd_port -dir I adc_dwr
create_bd_port -dir I adc_dsync
create_bd_port -dir I -from 63 -to 0 adc_ddata

create_bd_port -dir I tx_ref_clk_p
create_bd_port -dir I tx_ref_clk_n
create_bd_port -dir O tx_clk_p
create_bd_port -dir O tx_clk_n
create_bd_port -dir O tx_frame_p
create_bd_port -dir O tx_frame_n
create_bd_port -dir O -from 15 -to 0 tx_data_p
create_bd_port -dir O -from 15 -to 0 tx_data_n

# dac peripherals

create_bd_cell -type ip -vlnv analog.com:user:axi_ad9122:1.0 axi_ad9122_core

create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9122_dma
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {0}] [get_bd_cells axi_ad9122_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] [get_bd_cells axi_ad9122_dma]
set_property -dict [list CONFIG.PCORE_ID {1}] [get_bd_cells axi_ad9122_dma]
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] [get_bd_cells axi_ad9122_dma]
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] [get_bd_cells axi_ad9122_dma]
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] [get_bd_cells axi_ad9122_dma]
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] [get_bd_cells axi_ad9122_dma]
set_property -dict [list CONFIG.C_CYCLIC {1}] [get_bd_cells axi_ad9122_dma]
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {128}] [get_bd_cells axi_ad9122_dma]
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {128}] [get_bd_cells axi_ad9122_dma]

# adc peripherals

set axi_ad9250_core [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9250:1.0 axi_ad9250_core]

set axi_ad9250_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:6.0 axi_ad9250_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_ad9250_jesd
set_property -dict [list CONFIG.C_LANES {2}] $axi_ad9250_jesd

set axi_ad9250_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9250_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9250_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9250_dma

# dac/adc common gt/gpio

set axi_daq1_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_daq1_gt]
set_property -dict [list CONFIG.PCORE_NUM_OF_RX_LANES {2}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_NUM_OF_TX_LANES {2}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_CPLL_FBDIV {2}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_RX_OUT_DIV {1}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_TX_OUT_DIV {1}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_RX_CLK25_DIV {10}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_TX_CLK25_DIV {10}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_PMA_RSV {0x00018480}] $axi_daq1_gt
set_property -dict [list CONFIG.PCORE_RX_CDR_CFG {0x03000023ff20400020}] $axi_daq1_gt

# additions to default configuration

set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP3 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7

# connections (gt)

ad_connect  rx_ref_clk  axi_daq1_gt/ref_clk_c
ad_connect  rx_data_p   axi_daq1_gt/rx_data_p
ad_connect  rx_data_n   axi_daq1_gt/rx_data_n
ad_connect  rx_sync     axi_daq1_gt/rx_sync
ad_connect  rx_sysref   axi_daq1_gt/rx_ext_sysref

ad_connect  axi_daq1_gt/tx_clk  axi_daq1_gt/tx_clk_g

# connections (adc)

ad_connect  axi_daq1_gt/rx_clk_g axi_daq1_gt/rx_clk
ad_connect  axi_daq1_gt/rx_clk_g axi_ad9250_core/rx_clk
ad_connect  axi_daq1_gt/rx_clk_g axi_ad9250_jesd/rx_core_clk

set util_bsplit_rx_gt_charisk [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_rx_gt_charisk]
set_property -dict [list CONFIG.CH_DW {4}] [get_bd_cells util_bsplit_rx_gt_charisk]
set_property -dict [list CONFIG.CH_CNT {2}] [get_bd_cells util_bsplit_rx_gt_charisk]
ad_connect  util_bsplit_rx_gt_charisk/data axi_daq1_gt/rx_gt_charisk
ad_connect  util_bsplit_rx_gt_charisk/split_data_0 axi_ad9250_jesd/gt0_rxcharisk
ad_connect  util_bsplit_rx_gt_charisk/split_data_1 axi_ad9250_jesd/gt1_rxcharisk

set util_bsplit_gt_rxdisperr [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_gt_rxdisperr]
set_property -dict [list CONFIG.CH_DW {4}] [get_bd_cells util_bsplit_gt_rxdisperr]
set_property -dict [list CONFIG.CH_CNT {2}] [get_bd_cells util_bsplit_gt_rxdisperr]
ad_connect  util_bsplit_gt_rxdisperr/data axi_daq1_gt/rx_gt_disperr
ad_connect  util_bsplit_gt_rxdisperr/split_data_0 axi_ad9250_jesd/gt0_rxdisperr
ad_connect  util_bsplit_gt_rxdisperr/split_data_1 axi_ad9250_jesd/gt1_rxdisperr

set util_bsplit_rx_gt_notintable [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_rx_gt_notintable]
set_property -dict [list CONFIG.CH_DW {4}] [get_bd_cells util_bsplit_rx_gt_notintable]
set_property -dict [list CONFIG.CH_CNT {2}] [get_bd_cells util_bsplit_rx_gt_notintable]
ad_connect  util_bsplit_rx_gt_notintable/data axi_daq1_gt/rx_gt_notintable
ad_connect  util_bsplit_rx_gt_notintable/split_data_0 axi_ad9250_jesd/gt0_rxnotintable
ad_connect  util_bsplit_rx_gt_notintable/split_data_1 axi_ad9250_jesd/gt1_rxnotintable

set util_bsplit_rx_gt_data [create_bd_cell -type ip -vlnv analog.com:user:util_bsplit:1.0 util_bsplit_rx_gt_data]
set_property -dict [list CONFIG.CH_DW {32}] [get_bd_cells util_bsplit_rx_gt_data]
set_property -dict [list CONFIG.CH_CNT {2}] [get_bd_cells util_bsplit_rx_gt_data]
ad_connect  util_bsplit_rx_gt_data/data axi_daq1_gt/rx_gt_data
ad_connect  util_bsplit_rx_gt_data/split_data_0 axi_ad9250_jesd/gt0_rxdata
ad_connect  util_bsplit_rx_gt_data/split_data_1 axi_ad9250_jesd/gt1_rxdata

ad_connect  axi_daq1_gt/rx_jesd_rst  axi_ad9250_jesd/rx_reset
ad_connect  axi_daq1_gt/rx_sysref  axi_ad9250_jesd/rx_sysref
ad_connect  axi_daq1_gt/rx_rst_done  axi_ad9250_jesd/rx_reset_done
ad_connect  axi_daq1_gt/rx_ip_comma_align  axi_ad9250_jesd/rxencommaalign_out
ad_connect  axi_daq1_gt/rx_ip_sync  axi_ad9250_jesd/rx_sync
ad_connect  axi_daq1_gt/rx_ip_sof  axi_ad9250_jesd/rx_start_of_frame
ad_connect  axi_daq1_gt/rx_ip_data  axi_ad9250_jesd/rx_tdata
ad_connect  axi_daq1_gt/rx_data  axi_ad9250_core/rx_data
ad_connect  adc_clk  axi_ad9250_core/adc_clk
ad_connect  axi_ad9250_core/adc_clk  axi_ad9250_dma/fifo_wr_clk
ad_connect  adc_enable_a  axi_ad9250_core/adc_enable_a
ad_connect  adc_valid_a  axi_ad9250_core/adc_valid_a
ad_connect  adc_data_a  axi_ad9250_core/adc_data_a
ad_connect  adc_enable_b  axi_ad9250_core/adc_enable_b
ad_connect  adc_valid_b  axi_ad9250_core/adc_valid_b
ad_connect  adc_data_b  axi_ad9250_core/adc_data_b
ad_connect  axi_ad9250_core/adc_dovf  axi_ad9250_dma/fifo_wr_overflow
ad_connect  adc_dwr  axi_ad9250_dma/fifo_wr_en
ad_connect  adc_dsync  axi_ad9250_dma/fifo_wr_sync
ad_connect  adc_ddata  axi_ad9250_dma/fifo_wr_din

# connections (dac)

ad_connect  tx_ref_clk_p  axi_ad9122_core/dac_clk_in_p
ad_connect  tx_ref_clk_n  axi_ad9122_core/dac_clk_in_n
ad_connect  tx_clk_p  axi_ad9122_core/dac_clk_out_p
ad_connect  tx_clk_n  axi_ad9122_core/dac_clk_out_n
ad_connect  tx_frame_p  axi_ad9122_core/dac_frame_out_p
ad_connect  tx_frame_n  axi_ad9122_core/dac_frame_out_n
ad_connect  tx_data_p  axi_ad9122_core/dac_data_out_p
ad_connect  tx_data_n  axi_ad9122_core/dac_data_out_n
ad_connect  dac_clk  axi_ad9122_core/dac_div_clk
ad_connect  axi_ad9122_core/dac_div_clk  axi_ad9122_dma/fifo_rd_clk
ad_connect  dac_valid_0  axi_ad9122_core/dac_valid_0
ad_connect  dac_enable_0  axi_ad9122_core/dac_enable_0
ad_connect  dac_ddata_0  axi_ad9122_core/dac_ddata_0
ad_connect  dac_valid_1  axi_ad9122_core/dac_valid_1
ad_connect  dac_enable_1  axi_ad9122_core/dac_enable_1
ad_connect  dac_ddata_1  axi_ad9122_core/dac_ddata_1
ad_connect  dac_drd  axi_ad9122_dma/fifo_rd_en
ad_connect  dac_ddata  axi_ad9122_dma/fifo_rd_dout
ad_connect  axi_ad9122_core/dac_dunf  axi_ad9122_dma/fifo_rd_underflow

ad_connect  sys_cpu_resetn axi_ad9122_dma/m_src_axi_aresetn
ad_connect  sys_cpu_resetn axi_ad9250_dma/m_dest_axi_aresetn


# interconnect (cpu)

ad_cpu_interconnect   0x44A60000 axi_daq1_gt
ad_cpu_interconnect   0x44A00000 axi_ad9122_core
ad_cpu_interconnect   0x7c400000 axi_ad9122_dma
ad_cpu_interconnect   0x44A10000 axi_ad9250_core
ad_cpu_interconnect   0x7c420000 axi_ad9250_dma
ad_cpu_interconnect   0x44A91000 axi_ad9250_jesd

# memory interconnects

ad_mem_hp1_interconnect sys_200m_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_200m_clk axi_ad9122_dma/m_src_axi
ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_ad9250_dma/m_dest_axi
ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_daq1_gt/m_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12  axi_ad9250_dma/irq
ad_cpu_interrupt ps-12 mb-13  axi_ad9122_dma/irq

# ila

set ila_jesd_rx_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_jesd_rx_mon]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_NUM_OF_PROBES {7}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH  {64}  ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH  {1}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE2_WIDTH  {1}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE3_WIDTH  {32}  ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE4_WIDTH  {1}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE5_WIDTH  {1}   ] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE6_WIDTH  {32}  ] $ila_jesd_rx_mon

ad_connect  axi_daq1_gt/rx_clk_g  ila_jesd_rx_mon/CLK
ad_connect  axi_daq1_gt/rx_data  ila_jesd_rx_mon/PROBE0
ad_connect  axi_ad9250_core/adc_valid_a  ila_jesd_rx_mon/PROBE1
ad_connect  axi_ad9250_core/adc_enable_a  ila_jesd_rx_mon/PROBE2
ad_connect  axi_ad9250_core/adc_data_a  ila_jesd_rx_mon/PROBE3
ad_connect  axi_ad9250_core/adc_valid_b  ila_jesd_rx_mon/PROBE4
ad_connect  axi_ad9250_core/adc_enable_a  ila_jesd_rx_mon/PROBE5
ad_connect  axi_ad9250_core/adc_data_a  ila_jesd_rx_mon/PROBE6

