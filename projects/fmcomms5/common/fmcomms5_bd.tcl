
# fmcomms5

# master

create_bd_port -dir I rx_clk_in_0_p
create_bd_port -dir I rx_clk_in_0_n
create_bd_port -dir I rx_frame_in_0_p
create_bd_port -dir I rx_frame_in_0_n
create_bd_port -dir I -from 5 -to 0 rx_data_in_0_p
create_bd_port -dir I -from 5 -to 0 rx_data_in_0_n
create_bd_port -dir O tx_clk_out_0_p
create_bd_port -dir O tx_clk_out_0_n
create_bd_port -dir O tx_frame_out_0_p
create_bd_port -dir O tx_frame_out_0_n
create_bd_port -dir O -from 5 -to 0 tx_data_out_0_p
create_bd_port -dir O -from 5 -to 0 tx_data_out_0_n

# slave

create_bd_port -dir I rx_clk_in_1_p
create_bd_port -dir I rx_clk_in_1_n
create_bd_port -dir I rx_frame_in_1_p
create_bd_port -dir I rx_frame_in_1_n
create_bd_port -dir I -from 5 -to 0 rx_data_in_1_p
create_bd_port -dir I -from 5 -to 0 rx_data_in_1_n
create_bd_port -dir O tx_clk_out_1_p
create_bd_port -dir O tx_clk_out_1_n
create_bd_port -dir O tx_frame_out_1_p
create_bd_port -dir O tx_frame_out_1_n
create_bd_port -dir O -from 5 -to 0 tx_data_out_1_p
create_bd_port -dir O -from 5 -to 0 tx_data_out_1_n

create_bd_port -dir O sys_100m_resetn

# instances

set axi_ad9361_0 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361_0]
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_ad9361_0
set_property -dict [list CONFIG.PCORE_IODELAY_GROUP {dev_0_if_delay_group}] $axi_ad9361_0

set axi_ad9361_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361_1]
set_property -dict [list CONFIG.PCORE_ID {1}] $axi_ad9361_1
set_property -dict [list CONFIG.PCORE_IODELAY_GROUP {dev_1_if_delay_group}] $axi_ad9361_1

set axi_ad9361_dac_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_dac_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {2}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CYCLIC {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {128}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {128}] $axi_ad9361_dac_dma

if {$sys_zynq == 1} {
  set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_SRC {1}] $axi_ad9361_dac_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}] $axi_ad9361_dac_dma
}

set axi_ad9361_adc_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_adc_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {128}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {128}] $axi_ad9361_adc_dma

if {$sys_zynq == 1} {
  set_property -dict [list CONFIG.C_DMA_AXI_PROTOCOL_DEST {1}] $axi_ad9361_adc_dma
  set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $axi_ad9361_adc_dma
}

set util_adc_pack_0   [create_bd_cell -type ip -vlnv analog.com:user:util_adc_pack:1.0 util_adc_pack_0]
set util_dac_unpack_0 [create_bd_cell -type ip -vlnv analog.com:user:util_dac_unpack:1.0 util_dac_unpack_0]

# constants for avoiding errors when validating bd

set constant_1bit   [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_1bit]
set_property -dict [list CONFIG.CONST_VAL {0}] $constant_1bit

set constant_32bit  [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_32bit]
set_property -dict [list CONFIG.CONST_WIDTH {32}] $constant_32bit
set_property -dict [list CONFIG.CONST_VAL {0}] $constant_32bit

# connections (ad9361)

ad_connect sys_200m_clk axi_ad9361_0/delay_clk
ad_connect sys_200m_clk axi_ad9361_1/delay_clk
ad_connect axi_ad9361_0_clk axi_ad9361_0/l_clk
ad_connect axi_ad9361_1_clk axi_ad9361_1/l_clk
ad_connect axi_ad9361_0_clk axi_ad9361_0/clk
ad_connect axi_ad9361_0_clk axi_ad9361_1/clk
ad_connect axi_ad9361_0_clk util_adc_pack_0/clk
ad_connect axi_ad9361_0_clk util_dac_unpack_0/clk
ad_connect axi_ad9361_0_clk axi_ad9361_adc_dma/fifo_wr_clk
ad_connect axi_ad9361_0_clk axi_ad9361_dac_dma/fifo_rd_clk
ad_connect sys_cpu_resetn   sys_100m_resetn
ad_connect sys_cpu_resetn   axi_ad9361_adc_dma/m_dest_axi_aresetn
ad_connect sys_cpu_resetn   axi_ad9361_dac_dma/m_src_axi_aresetn

ad_connect  axi_ad9361_0_dac_sync   axi_ad9361_0/dac_sync_out
ad_connect  axi_ad9361_0_dac_sync   axi_ad9361_0/dac_sync_in
ad_connect  axi_ad9361_0_dac_sync   axi_ad9361_1/dac_sync_in

ad_connect  rx_clk_in_0_p               axi_ad9361_0/rx_clk_in_p
ad_connect  rx_clk_in_0_n               axi_ad9361_0/rx_clk_in_n
ad_connect  rx_frame_in_0_p             axi_ad9361_0/rx_frame_in_p
ad_connect  rx_frame_in_0_n             axi_ad9361_0/rx_frame_in_n
ad_connect  rx_data_in_0_p              axi_ad9361_0/rx_data_in_p
ad_connect  rx_data_in_0_n              axi_ad9361_0/rx_data_in_n
ad_connect  tx_clk_out_0_p              axi_ad9361_0/tx_clk_out_p
ad_connect  tx_clk_out_0_n              axi_ad9361_0/tx_clk_out_n
ad_connect  tx_frame_out_0_p            axi_ad9361_0/tx_frame_out_p
ad_connect  tx_frame_out_0_n            axi_ad9361_0/tx_frame_out_n
ad_connect  tx_data_out_0_p             axi_ad9361_0/tx_data_out_p
ad_connect  tx_data_out_0_n             axi_ad9361_0/tx_data_out_n
ad_connect  rx_clk_in_1_p               axi_ad9361_1/rx_clk_in_p
ad_connect  rx_clk_in_1_n               axi_ad9361_1/rx_clk_in_n
ad_connect  rx_frame_in_1_p             axi_ad9361_1/rx_frame_in_p
ad_connect  rx_frame_in_1_n             axi_ad9361_1/rx_frame_in_n
ad_connect  rx_data_in_1_p              axi_ad9361_1/rx_data_in_p
ad_connect  rx_data_in_1_n              axi_ad9361_1/rx_data_in_n
ad_connect  tx_clk_out_1_p              axi_ad9361_1/tx_clk_out_p
ad_connect  tx_clk_out_1_n              axi_ad9361_1/tx_clk_out_n
ad_connect  tx_frame_out_1_p            axi_ad9361_1/tx_frame_out_p
ad_connect  tx_frame_out_1_n            axi_ad9361_1/tx_frame_out_n
ad_connect  tx_data_out_1_p             axi_ad9361_1/tx_data_out_p
ad_connect  tx_data_out_1_n             axi_ad9361_1/tx_data_out_n
ad_connect  axi_ad9361_0/adc_enable_i0  util_adc_pack_0/chan_enable_0
ad_connect  axi_ad9361_0/adc_valid_i0   util_adc_pack_0/chan_valid_0
ad_connect  axi_ad9361_0/adc_data_i0    util_adc_pack_0/chan_data_0
ad_connect  axi_ad9361_0/adc_enable_q0  util_adc_pack_0/chan_enable_1
ad_connect  axi_ad9361_0/adc_valid_q0   util_adc_pack_0/chan_valid_1
ad_connect  axi_ad9361_0/adc_data_q0    util_adc_pack_0/chan_data_1
ad_connect  axi_ad9361_0/adc_enable_i1  util_adc_pack_0/chan_enable_2
ad_connect  axi_ad9361_0/adc_valid_i1   util_adc_pack_0/chan_valid_2
ad_connect  axi_ad9361_0/adc_data_i1    util_adc_pack_0/chan_data_2
ad_connect  axi_ad9361_0/adc_enable_q1  util_adc_pack_0/chan_enable_3
ad_connect  axi_ad9361_0/adc_valid_q1   util_adc_pack_0/chan_valid_3
ad_connect  axi_ad9361_0/adc_data_q1    util_adc_pack_0/chan_data_3
ad_connect  axi_ad9361_1/adc_enable_i0  util_adc_pack_0/chan_enable_4
ad_connect  axi_ad9361_1/adc_valid_i0   util_adc_pack_0/chan_valid_4
ad_connect  axi_ad9361_1/adc_data_i0    util_adc_pack_0/chan_data_4
ad_connect  axi_ad9361_1/adc_enable_q0  util_adc_pack_0/chan_enable_5
ad_connect  axi_ad9361_1/adc_valid_q0   util_adc_pack_0/chan_valid_5
ad_connect  axi_ad9361_1/adc_data_q0    util_adc_pack_0/chan_data_5
ad_connect  axi_ad9361_1/adc_enable_i1  util_adc_pack_0/chan_enable_6
ad_connect  axi_ad9361_1/adc_valid_i1   util_adc_pack_0/chan_valid_6
ad_connect  axi_ad9361_1/adc_data_i1    util_adc_pack_0/chan_data_6
ad_connect  axi_ad9361_1/adc_enable_q1  util_adc_pack_0/chan_enable_7
ad_connect  axi_ad9361_1/adc_valid_q1   util_adc_pack_0/chan_valid_7
ad_connect  axi_ad9361_1/adc_data_q1    util_adc_pack_0/chan_data_7
ad_connect  util_adc_pack_0/dvalid      axi_ad9361_adc_dma/fifo_wr_en
ad_connect  util_adc_pack_0/dsync       axi_ad9361_adc_dma/fifo_wr_sync
ad_connect  util_adc_pack_0/ddata       axi_ad9361_adc_dma/fifo_wr_din
ad_connect  axi_ad9361_0/dac_enable_i0  util_dac_unpack_0/dac_enable_00
ad_connect  axi_ad9361_0/dac_valid_i0   util_dac_unpack_0/dac_valid_00
ad_connect  axi_ad9361_0/dac_data_i0    util_dac_unpack_0/dac_data_00
ad_connect  axi_ad9361_0/dac_enable_q0  util_dac_unpack_0/dac_enable_01
ad_connect  axi_ad9361_0/dac_valid_q0   util_dac_unpack_0/dac_valid_01
ad_connect  axi_ad9361_0/dac_data_q0    util_dac_unpack_0/dac_data_01
ad_connect  axi_ad9361_0/dac_enable_i1  util_dac_unpack_0/dac_enable_02
ad_connect  axi_ad9361_0/dac_valid_i1   util_dac_unpack_0/dac_valid_02

ad_connect  axi_ad9361_0/dac_data_i1      util_dac_unpack_0/dac_data_02
ad_connect  axi_ad9361_0/dac_enable_q1    util_dac_unpack_0/dac_enable_03
ad_connect  axi_ad9361_0/dac_valid_q1     util_dac_unpack_0/dac_valid_03
ad_connect  axi_ad9361_0/dac_data_q1      util_dac_unpack_0/dac_data_03
ad_connect  axi_ad9361_1/dac_enable_i0    util_dac_unpack_0/dac_enable_04
ad_connect  axi_ad9361_1/dac_valid_i0     util_dac_unpack_0/dac_valid_04
ad_connect  axi_ad9361_1/dac_data_i0      util_dac_unpack_0/dac_data_04
ad_connect  axi_ad9361_1/dac_enable_q0    util_dac_unpack_0/dac_enable_05
ad_connect  axi_ad9361_1/dac_valid_q0     util_dac_unpack_0/dac_valid_05
ad_connect  axi_ad9361_1/dac_data_q0      util_dac_unpack_0/dac_data_05
ad_connect  axi_ad9361_1/dac_enable_i1    util_dac_unpack_0/dac_enable_06
ad_connect  axi_ad9361_1/dac_valid_i1     util_dac_unpack_0/dac_valid_06
ad_connect  axi_ad9361_1/dac_data_i1      util_dac_unpack_0/dac_data_06
ad_connect  axi_ad9361_1/dac_enable_q1    util_dac_unpack_0/dac_enable_07
ad_connect  axi_ad9361_1/dac_valid_q1     util_dac_unpack_0/dac_valid_07
ad_connect  axi_ad9361_1/dac_data_q1      util_dac_unpack_0/dac_data_07
ad_connect  util_dac_unpack_0/dma_rd      axi_ad9361_dac_dma/fifo_rd_en
ad_connect  util_dac_unpack_0/dma_data    axi_ad9361_dac_dma/fifo_rd_dout
ad_connect  util_dac_unpack_0/fifo_valid  axi_ad9361_dac_dma/fifo_rd_valid
ad_connect  axi_ad9361_0/adc_dovf         axi_ad9361_adc_dma/fifo_wr_overflow
ad_connect  axi_ad9361_0/dac_dunf         axi_ad9361_dac_dma/fifo_rd_underflow

ad_connect  constant_32bit/dout axi_ad9361_0/up_dac_gpio_in
ad_connect  constant_32bit/dout axi_ad9361_0/up_adc_gpio_in
ad_connect  constant_32bit/dout axi_ad9361_1/up_dac_gpio_in
ad_connect  constant_32bit/dout axi_ad9361_1/up_adc_gpio_in
ad_connect  constant_1bit/dout  axi_ad9361_0/dac_dovf
ad_connect  constant_1bit/dout  axi_ad9361_0/adc_dunf
ad_connect  constant_1bit/dout  axi_ad9361_1/dac_dovf
ad_connect  constant_1bit/dout  axi_ad9361_1/dac_dunf
ad_connect  constant_1bit/dout  axi_ad9361_1/adc_dunf
ad_connect  constant_1bit/dout  axi_ad9361_1/adc_dovf

# address map

ad_cpu_interconnect 0x79020000 axi_ad9361_0
ad_cpu_interconnect 0x7C420000 axi_ad9361_dac_dma
ad_cpu_interconnect 0x7C400000 axi_ad9361_adc_dma
ad_cpu_interconnect 0x79040000 axi_ad9361_1
ad_mem_hp2_interconnect sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_dma_clk axi_ad9361_adc_dma/m_dest_axi
ad_mem_hp3_interconnect sys_dma_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_dma_clk axi_ad9361_dac_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad9361_dac_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9361_adc_dma/irq
