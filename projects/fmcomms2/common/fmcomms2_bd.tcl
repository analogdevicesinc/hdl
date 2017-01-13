
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
create_bd_port -dir I up_enable
create_bd_port -dir I up_txnrx

create_bd_port -dir O tdd_sync_o
create_bd_port -dir I tdd_sync_i
create_bd_port -dir O tdd_sync_t

# ad9361 core

set axi_ad9361 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361]
set_property -dict [list CONFIG.ID {0}] $axi_ad9361

set axi_ad9361_dac_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_dac_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.CYCLIC {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_ad9361_dac_dma

set util_ad9361_dac_upack [create_bd_cell -type ip -vlnv analog.com:user:util_upack:1.0 util_ad9361_dac_upack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9361_dac_upack
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_ad9361_dac_upack

set axi_ad9361_adc_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_adc_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}]  $axi_ad9361_adc_dma

set util_ad9361_adc_pack [create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 util_ad9361_adc_pack]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9361_adc_pack
set_property -dict [list CONFIG.CHANNEL_DATA_WIDTH {16}] $util_ad9361_adc_pack

set util_ad9361_adc_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 util_ad9361_adc_fifo]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {4}] $util_ad9361_adc_fifo
set_property -dict [list CONFIG.DIN_ADDRESS_WIDTH {4}] $util_ad9361_adc_fifo
set_property -dict [list CONFIG.DIN_DATA_WIDTH {16}] $util_ad9361_adc_fifo
set_property -dict [list CONFIG.DOUT_DATA_WIDTH {16}] $util_ad9361_adc_fifo

set util_ad9361_tdd_sync [create_bd_cell -type ip -vlnv analog.com:user:util_tdd_sync:1.0 util_ad9361_tdd_sync]
set_property -dict [list CONFIG.TDD_SYNC_PERIOD {10000000}] $util_ad9361_tdd_sync

set clkdiv [ create_bd_cell -type ip -vlnv analog.com:user:util_clkdiv:1.0 clkdiv ]

set clkdiv_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 clkdiv_reset]

set dac_fifo [create_bd_cell -type ip -vlnv analog.com:user:util_rfifo:1.0 dac_fifo]
set_property -dict [list CONFIG.DIN_DATA_WIDTH {16}] $dac_fifo
set_property -dict [list CONFIG.DOUT_DATA_WIDTH {16}] $dac_fifo
set_property -dict [list CONFIG.DIN_ADDRESS_WIDTH {4}] $dac_fifo

set clkdiv_sel_logic [create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 clkdiv_sel_logic]
set_property -dict [list CONFIG.C_SIZE {2}] $clkdiv_sel_logic

set concat_logic [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_logic]
set_property -dict [list CONFIG.NUM_PORTS {2}] $concat_logic

# connections

ad_connect sys_200m_clk axi_ad9361/delay_clk
ad_connect axi_ad9361_clk axi_ad9361/l_clk
ad_connect axi_ad9361_clk axi_ad9361/clk
ad_connect rx_clk_in_p axi_ad9361/rx_clk_in_p
ad_connect rx_clk_in_n axi_ad9361/rx_clk_in_n
ad_connect rx_frame_in_p axi_ad9361/rx_frame_in_p
ad_connect rx_frame_in_n axi_ad9361/rx_frame_in_n
ad_connect rx_data_in_p axi_ad9361/rx_data_in_p
ad_connect rx_data_in_n axi_ad9361/rx_data_in_n
ad_connect tx_clk_out_p axi_ad9361/tx_clk_out_p
ad_connect tx_clk_out_n axi_ad9361/tx_clk_out_n
ad_connect tx_frame_out_p axi_ad9361/tx_frame_out_p
ad_connect tx_frame_out_n axi_ad9361/tx_frame_out_n
ad_connect tx_data_out_p axi_ad9361/tx_data_out_p
ad_connect tx_data_out_n axi_ad9361/tx_data_out_n
ad_connect enable axi_ad9361/enable
ad_connect txnrx axi_ad9361/txnrx
ad_connect up_enable axi_ad9361/up_enable
ad_connect up_txnrx axi_ad9361/up_txnrx
ad_connect axi_ad9361_clk util_ad9361_adc_fifo/din_clk
ad_connect axi_ad9361/rst util_ad9361_adc_fifo/din_rst
ad_connect axi_ad9361/adc_enable_i0 util_ad9361_adc_fifo/din_enable_0
ad_connect axi_ad9361/adc_valid_i0 util_ad9361_adc_fifo/din_valid_0
ad_connect axi_ad9361/adc_data_i0 util_ad9361_adc_fifo/din_data_0
ad_connect axi_ad9361/adc_enable_q0 util_ad9361_adc_fifo/din_enable_1
ad_connect axi_ad9361/adc_valid_q0 util_ad9361_adc_fifo/din_valid_1
ad_connect axi_ad9361/adc_data_q0 util_ad9361_adc_fifo/din_data_1
ad_connect axi_ad9361/adc_enable_i1 util_ad9361_adc_fifo/din_enable_2
ad_connect axi_ad9361/adc_valid_i1 util_ad9361_adc_fifo/din_valid_2
ad_connect axi_ad9361/adc_data_i1 util_ad9361_adc_fifo/din_data_2
ad_connect axi_ad9361/adc_enable_q1 util_ad9361_adc_fifo/din_enable_3
ad_connect axi_ad9361/adc_valid_q1 util_ad9361_adc_fifo/din_valid_3
ad_connect axi_ad9361/adc_data_q1 util_ad9361_adc_fifo/din_data_3
ad_connect util_ad9361_adc_fifo/dout_enable_0 util_ad9361_adc_pack/adc_enable_0
ad_connect util_ad9361_adc_fifo/dout_valid_0 util_ad9361_adc_pack/adc_valid_0
ad_connect util_ad9361_adc_fifo/dout_data_0 util_ad9361_adc_pack/adc_data_0
ad_connect util_ad9361_adc_fifo/dout_enable_1 util_ad9361_adc_pack/adc_enable_1
ad_connect util_ad9361_adc_fifo/dout_valid_1 util_ad9361_adc_pack/adc_valid_1
ad_connect util_ad9361_adc_fifo/dout_data_1 util_ad9361_adc_pack/adc_data_1
ad_connect util_ad9361_adc_fifo/dout_enable_2 util_ad9361_adc_pack/adc_enable_2
ad_connect util_ad9361_adc_fifo/dout_valid_2 util_ad9361_adc_pack/adc_valid_2
ad_connect util_ad9361_adc_fifo/dout_data_2 util_ad9361_adc_pack/adc_data_2
ad_connect util_ad9361_adc_fifo/dout_enable_3 util_ad9361_adc_pack/adc_enable_3
ad_connect util_ad9361_adc_fifo/dout_valid_3 util_ad9361_adc_pack/adc_valid_3
ad_connect util_ad9361_adc_fifo/dout_data_3 util_ad9361_adc_pack/adc_data_3
ad_connect util_ad9361_adc_pack/adc_valid axi_ad9361_adc_dma/fifo_wr_en
ad_connect util_ad9361_adc_pack/adc_sync axi_ad9361_adc_dma/fifo_wr_sync
ad_connect util_ad9361_adc_pack/adc_data axi_ad9361_adc_dma/fifo_wr_din
ad_connect axi_ad9361_adc_dma/fifo_wr_overflow util_ad9361_adc_fifo/dout_ovf
ad_connect util_ad9361_adc_fifo/din_ovf axi_ad9361/adc_dovf
ad_connect axi_ad9361_clk clkdiv/clk

ad_connect axi_ad9361/adc_r1_mode concat_logic/In0
ad_connect axi_ad9361/dac_r1_mode concat_logic/In1
ad_connect concat_logic/dout clkdiv_sel_logic/Op1
ad_connect clkdiv/clk_sel clkdiv_sel_logic/Res

ad_connect clkdiv/clk_out axi_ad9361_adc_dma/fifo_wr_clk
ad_connect clkdiv/clk_out util_ad9361_adc_fifo/dout_clk
ad_connect clkdiv/clk_out util_ad9361_adc_pack/adc_clk
ad_connect clkdiv_reset/ext_reset_in sys_rstgen/peripheral_aresetn
ad_connect clkdiv_reset/slowest_sync_clk clkdiv/clk_out
ad_connect util_ad9361_adc_pack/adc_rst clkdiv_reset/peripheral_reset
ad_connect util_ad9361_adc_fifo/dout_rstn clkdiv_reset/peripheral_aresetn
ad_connect util_ad9361_dac_upack/dac_valid axi_ad9361_dac_dma/fifo_rd_en
ad_connect util_ad9361_dac_upack/dac_data axi_ad9361_dac_dma/fifo_rd_dout
ad_connect clkdiv/clk_out axi_ad9361_dac_dma/fifo_rd_clk
ad_connect axi_ad9361/dac_dunf dac_fifo/dout_unf
ad_connect dac_fifo/din_clk clkdiv/clk_out
ad_connect dac_fifo/din_rstn clkdiv_reset/peripheral_aresetn
ad_connect axi_ad9361_clk dac_fifo/dout_clk
ad_connect dac_fifo/dout_rst axi_ad9361/rst
ad_connect util_ad9361_dac_upack/dac_clk clkdiv/clk_out
ad_connect dac_fifo/din_enable_0 util_ad9361_dac_upack/dac_enable_0
ad_connect dac_fifo/din_valid_0 util_ad9361_dac_upack/dac_valid_0
ad_connect dac_fifo/din_enable_1 util_ad9361_dac_upack/dac_enable_1
ad_connect dac_fifo/din_valid_1 util_ad9361_dac_upack/dac_valid_1
ad_connect dac_fifo/din_enable_2 util_ad9361_dac_upack/dac_enable_2
ad_connect dac_fifo/din_valid_2 util_ad9361_dac_upack/dac_valid_2
ad_connect dac_fifo/din_enable_3 util_ad9361_dac_upack/dac_enable_3
ad_connect dac_fifo/din_valid_3 util_ad9361_dac_upack/dac_valid_3
ad_connect util_ad9361_dac_upack/dac_data_0 dac_fifo/din_data_0
ad_connect util_ad9361_dac_upack/dac_data_1 dac_fifo/din_data_1
ad_connect util_ad9361_dac_upack/dac_data_2 dac_fifo/din_data_2
ad_connect util_ad9361_dac_upack/dac_data_3 dac_fifo/din_data_3
ad_connect axi_ad9361/dac_enable_i0 dac_fifo/dout_enable_0
ad_connect axi_ad9361/dac_valid_i0 dac_fifo/dout_valid_0
ad_connect axi_ad9361/dac_enable_q0 dac_fifo/dout_enable_1
ad_connect axi_ad9361/dac_valid_q0 dac_fifo/dout_valid_1
ad_connect axi_ad9361/dac_enable_i1 dac_fifo/dout_enable_2
ad_connect axi_ad9361/dac_valid_i1 dac_fifo/dout_valid_2
ad_connect axi_ad9361/dac_enable_q1 dac_fifo/dout_enable_3
ad_connect axi_ad9361/dac_valid_q1 dac_fifo/dout_valid_3
ad_connect dac_fifo/dout_data_0 axi_ad9361/dac_data_i0
ad_connect dac_fifo/dout_data_1 axi_ad9361/dac_data_q0
ad_connect dac_fifo/dout_data_2 axi_ad9361/dac_data_i1
ad_connect dac_fifo/dout_data_3 axi_ad9361/dac_data_q1
ad_connect sys_cpu_clk util_ad9361_tdd_sync/clk
ad_connect sys_cpu_resetn util_ad9361_tdd_sync/rstn
ad_connect util_ad9361_tdd_sync/sync_out axi_ad9361/tdd_sync
ad_connect util_ad9361_tdd_sync/sync_mode axi_ad9361/tdd_sync_cntr
ad_connect tdd_sync_t axi_ad9361/tdd_sync_cntr
ad_connect tdd_sync_o util_ad9361_tdd_sync/sync_out
ad_connect tdd_sync_i util_ad9361_tdd_sync/sync_in

# interconnects

ad_cpu_interconnect 0x79020000 axi_ad9361
ad_cpu_interconnect 0x7C400000 axi_ad9361_adc_dma
ad_cpu_interconnect 0x7C420000 axi_ad9361_dac_dma
ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9361_adc_dma/m_dest_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9361_dac_dma/m_src_axi
ad_connect  sys_cpu_resetn axi_ad9361_adc_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn axi_ad9361_dac_dma/m_src_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad9361_adc_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_ad9361_dac_dma/irq

