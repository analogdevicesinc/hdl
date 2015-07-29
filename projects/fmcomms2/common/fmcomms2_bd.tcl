
# fmcomms2

create_bd_port -dir I rx_clk_in_p
create_bd_port -dir I rx_clk_in_n
create_bd_port -dir I rx_frame_in_p
create_bd_port -dir I rx_frame_in_n
create_bd_port -dir I -from 5 -to 0 rx_data_in_p
create_bd_port -dir I -from 5 -to 0 rx_data_in_n

create_bd_port -dir O tx_clk_out_p
create_bd_port -dir O tx_clk_out_n
create_bd_port -dir O tx_frame_out_p
create_bd_port -dir O tx_frame_out_n
create_bd_port -dir O -from 5 -to 0 tx_data_out_p
create_bd_port -dir O -from 5 -to 0 tx_data_out_n

create_bd_port -dir O enable
create_bd_port -dir O txnrx

create_bd_port -dir O tdd_enable

create_bd_port -dir I tdd_sync_i
create_bd_port -dir O tdd_sync_o
create_bd_port -dir O tdd_sync_t

# ad9361 core

set axi_ad9361 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361]
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9361

set axi_ad9361_dac_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_dac_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CYCLIC {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9361_dac_dma

set util_dac_unpack [create_bd_cell -type ip -vlnv analog.com:user:util_dac_unpack:1.0 util_dac_unpack]
set_property -dict [list CONFIG.CHANNELS {4}] $util_dac_unpack

set axi_ad9361_adc_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_adc_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}]  $axi_ad9361_adc_dma

set util_adc_pack [create_bd_cell -type ip -vlnv analog.com:user:util_adc_pack:1.0 util_adc_pack]
set_property -dict [list CONFIG.CHANNELS {4}] $util_adc_pack

# connections

ad_connect  sys_200m_clk axi_ad9361/delay_clk
ad_connect  axi_ad9361_clk axi_ad9361/l_clk
ad_connect  axi_ad9361_clk axi_ad9361/clk
ad_connect  axi_ad9361_clk axi_ad9361_adc_dma/fifo_wr_clk
ad_connect  axi_ad9361_clk axi_ad9361_dac_dma/fifo_rd_clk
ad_connect  rx_clk_in_p axi_ad9361/rx_clk_in_p
ad_connect  rx_clk_in_n axi_ad9361/rx_clk_in_n
ad_connect  rx_frame_in_p axi_ad9361/rx_frame_in_p
ad_connect  rx_frame_in_n axi_ad9361/rx_frame_in_n
ad_connect  rx_data_in_p axi_ad9361/rx_data_in_p
ad_connect  rx_data_in_n axi_ad9361/rx_data_in_n
ad_connect  tx_clk_out_p axi_ad9361/tx_clk_out_p
ad_connect  tx_clk_out_n axi_ad9361/tx_clk_out_n
ad_connect  tx_frame_out_p axi_ad9361/tx_frame_out_p
ad_connect  tx_frame_out_n axi_ad9361/tx_frame_out_n
ad_connect  tx_data_out_p axi_ad9361/tx_data_out_p
ad_connect  tx_data_out_n axi_ad9361/tx_data_out_n
ad_connect  enable axi_ad9361/enable
ad_connect  txnrx axi_ad9361/txnrx
ad_connect  tdd_sync_i axi_ad9361/tdd_sync_i
ad_connect  tdd_sync_o axi_ad9361/tdd_sync_o
ad_connect  tdd_sync_t axi_ad9361/tdd_sync_t
ad_connect  tdd_enable axi_ad9361/tdd_enable
ad_connect  axi_ad9361_clk util_adc_pack/clk
ad_connect  axi_ad9361/adc_valid_i0 util_adc_pack/chan_valid_0
ad_connect  axi_ad9361/adc_valid_q0 util_adc_pack/chan_valid_1
ad_connect  axi_ad9361/adc_valid_i1 util_adc_pack/chan_valid_2
ad_connect  axi_ad9361/adc_valid_q1 util_adc_pack/chan_valid_3
ad_connect  axi_ad9361/adc_enable_i0 util_adc_pack/chan_enable_0
ad_connect  axi_ad9361/adc_enable_q0 util_adc_pack/chan_enable_1
ad_connect  axi_ad9361/adc_enable_i1 util_adc_pack/chan_enable_2
ad_connect  axi_ad9361/adc_enable_q1 util_adc_pack/chan_enable_3
ad_connect  axi_ad9361/adc_data_i0 util_adc_pack/chan_data_0
ad_connect  axi_ad9361/adc_data_q0 util_adc_pack/chan_data_1
ad_connect  axi_ad9361/adc_data_i1 util_adc_pack/chan_data_2
ad_connect  axi_ad9361/adc_data_q1 util_adc_pack/chan_data_3
ad_connect  sys_cpu_resetn axi_ad9361_dac_dma/m_src_axi_aresetn
ad_connect  util_adc_pack/dvalid axi_ad9361_adc_dma/fifo_wr_en
ad_connect  util_adc_pack/dsync axi_ad9361_adc_dma/fifo_wr_sync
ad_connect  util_adc_pack/ddata axi_ad9361_adc_dma/fifo_wr_din
ad_connect  axi_ad9361/adc_dovf axi_ad9361_adc_dma/fifo_wr_overflow
ad_connect  axi_ad9361_clk util_dac_unpack/clk
ad_connect  util_dac_unpack/dac_valid_00 axi_ad9361/dac_valid_i0
ad_connect  util_dac_unpack/dac_valid_01 axi_ad9361/dac_valid_q0
ad_connect  util_dac_unpack/dac_valid_02 axi_ad9361/dac_valid_i1
ad_connect  util_dac_unpack/dac_valid_03 axi_ad9361/dac_valid_q1
ad_connect  util_dac_unpack/dac_enable_00 axi_ad9361/dac_enable_i0
ad_connect  util_dac_unpack/dac_enable_01 axi_ad9361/dac_enable_q0
ad_connect  util_dac_unpack/dac_enable_02 axi_ad9361/dac_enable_i1
ad_connect  util_dac_unpack/dac_enable_03 axi_ad9361/dac_enable_q1
ad_connect  util_dac_unpack/dac_data_00 axi_ad9361/dac_data_i0
ad_connect  util_dac_unpack/dac_data_01 axi_ad9361/dac_data_q0
ad_connect  util_dac_unpack/dac_data_02 axi_ad9361/dac_data_i1
ad_connect  util_dac_unpack/dac_data_03 axi_ad9361/dac_data_q1
ad_connect  sys_cpu_resetn axi_ad9361_adc_dma/m_dest_axi_aresetn
ad_connect  util_dac_unpack/dma_data axi_ad9361_dac_dma/fifo_rd_dout
ad_connect  util_dac_unpack/fifo_valid axi_ad9361_dac_dma/fifo_rd_valid
ad_connect  util_dac_unpack/dma_rd axi_ad9361_dac_dma/fifo_rd_en
ad_connect  axi_ad9361/dac_dunf axi_ad9361_dac_dma/fifo_rd_underflow

# interconnects

ad_cpu_interconnect 0x79020000 axi_ad9361
ad_cpu_interconnect 0x7C400000 axi_ad9361_adc_dma
ad_cpu_interconnect 0x7C420000 axi_ad9361_dac_dma
ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9361_adc_dma/m_dest_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9361_dac_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad9361_adc_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_ad9361_dac_dma/irq

# ila (adc)

set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_adc]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc
set_property -dict [list CONFIG.C_NUM_OF_PROBES {8}] $ila_adc
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_adc
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc
set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] $ila_adc
set_property -dict [list CONFIG.C_PROBE2_WIDTH {1}] $ila_adc
set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] $ila_adc
set_property -dict [list CONFIG.C_PROBE4_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE5_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE6_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE7_WIDTH {16}] $ila_adc

p_sys_wfifo [current_bd_instance .] sys_wfifo_0 16 16
p_sys_wfifo [current_bd_instance .] sys_wfifo_1 16 16
p_sys_wfifo [current_bd_instance .] sys_wfifo_2 16 16
p_sys_wfifo [current_bd_instance .] sys_wfifo_3 16 16

ad_connect  axi_ad9361_clk sys_wfifo_0/adc_clk
ad_connect  axi_ad9361_clk sys_wfifo_1/adc_clk
ad_connect  axi_ad9361_clk sys_wfifo_2/adc_clk
ad_connect  axi_ad9361_clk sys_wfifo_3/adc_clk
ad_connect  sys_wfifo_0/adc_wr axi_ad9361/adc_valid_i0
ad_connect  sys_wfifo_1/adc_wr axi_ad9361/adc_valid_q0
ad_connect  sys_wfifo_2/adc_wr axi_ad9361/adc_valid_i1
ad_connect  sys_wfifo_3/adc_wr axi_ad9361/adc_valid_q1
ad_connect  sys_wfifo_0/adc_wdata axi_ad9361/adc_data_i0
ad_connect  sys_wfifo_1/adc_wdata axi_ad9361/adc_data_q0
ad_connect  sys_wfifo_2/adc_wdata axi_ad9361/adc_data_i1
ad_connect  sys_wfifo_3/adc_wdata axi_ad9361/adc_data_q1
ad_connect  sys_cpu_clk ila_adc/clk
ad_connect  sys_cpu_clk sys_wfifo_0/dma_clk
ad_connect  sys_cpu_clk sys_wfifo_1/dma_clk
ad_connect  sys_cpu_clk sys_wfifo_2/dma_clk
ad_connect  sys_cpu_clk sys_wfifo_3/dma_clk
ad_connect  sys_wfifo_0/dma_wr ila_adc/probe0
ad_connect  sys_wfifo_1/dma_wr ila_adc/probe1
ad_connect  sys_wfifo_2/dma_wr ila_adc/probe2
ad_connect  sys_wfifo_3/dma_wr ila_adc/probe3
ad_connect  sys_wfifo_0/dma_wdata ila_adc/probe4
ad_connect  sys_wfifo_1/dma_wdata ila_adc/probe5
ad_connect  sys_wfifo_2/dma_wdata ila_adc/probe6
ad_connect  sys_wfifo_3/dma_wdata ila_adc/probe7

