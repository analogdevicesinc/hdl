
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

create_bd_port -dir O enable_0
create_bd_port -dir O txnrx_0
create_bd_port -dir I up_enable_0
create_bd_port -dir I up_txnrx_0

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

create_bd_port -dir O enable_1
create_bd_port -dir O txnrx_1
create_bd_port -dir I up_enable_1
create_bd_port -dir I up_txnrx_1

create_bd_port -dir O sys_100m_resetn

# instances

ad_ip_instance axi_ad9361 axi_ad9361_0
ad_ip_parameter axi_ad9361_0 CONFIG.ID 0
ad_ip_parameter axi_ad9361_0 CONFIG.IO_DELAY_GROUP dev_0_if_delay_group

ad_ip_instance axi_ad9361 axi_ad9361_1
ad_ip_parameter axi_ad9361_1 CONFIG.ID 1
ad_ip_parameter axi_ad9361_1 CONFIG.IO_DELAY_GROUP dev_1_if_delay_group

ad_ip_instance axi_dmac axi_ad9361_dac_dma
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter axi_ad9361_dac_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9361_dac_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_DATA_WIDTH_SRC 128

if {$sys_zynq == 1} {
  ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_AXI_PROTOCOL_SRC 1
  ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_DATA_WIDTH_SRC 64
}

ad_ip_instance axi_dmac axi_ad9361_adc_dma
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9361_adc_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9361_adc_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_DATA_WIDTH_SRC 128

if {$sys_zynq == 1} {
  ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_AXI_PROTOCOL_DEST 1
  ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_DATA_WIDTH_DEST 64
}

ad_ip_instance util_upack util_upack_dac
ad_ip_parameter util_upack_dac CONFIG.CHANNEL_DATA_WIDTH 16
ad_ip_parameter util_upack_dac CONFIG.NUM_OF_CHANNELS 8

ad_ip_instance util_cpack util_cpack_adc
ad_ip_parameter util_cpack_adc CONFIG.CHANNEL_DATA_WIDTH 16
ad_ip_parameter util_cpack_adc CONFIG.NUM_OF_CHANNELS 8

ad_ip_instance util_wfifo adc_wfifo
ad_ip_parameter adc_wfifo CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter adc_wfifo CONFIG.DIN_DATA_WIDTH 16
ad_ip_parameter adc_wfifo CONFIG.DOUT_DATA_WIDTH 16
ad_ip_parameter adc_wfifo CONFIG.DIN_ADDRESS_WIDTH 4

ad_ip_instance util_clkdiv clkdiv

ad_ip_instance proc_sys_reset clkdiv_reset

ad_ip_instance util_rfifo dac_fifo
ad_ip_parameter dac_fifo CONFIG.DIN_DATA_WIDTH 16
ad_ip_parameter dac_fifo CONFIG.DOUT_DATA_WIDTH 16
ad_ip_parameter dac_fifo CONFIG.DIN_ADDRESS_WIDTH 4
ad_ip_parameter dac_fifo CONFIG.NUM_OF_CHANNELS 8

ad_ip_instance util_reduced_logic clkdiv_sel_logic
ad_ip_parameter clkdiv_sel_logic CONFIG.C_SIZE 4

ad_ip_instance xlconcat concat_logic
ad_ip_parameter concat_logic CONFIG.NUM_PORTS 4

# connections (ad9361)

ad_connect  sys_200m_clk      axi_ad9361_0/delay_clk
ad_connect  sys_200m_clk      axi_ad9361_1/delay_clk
ad_connect  axi_ad9361_0_clk  axi_ad9361_0/l_clk
ad_connect  axi_ad9361_1_clk  axi_ad9361_1/l_clk
ad_connect  axi_ad9361_0_clk  axi_ad9361_0/clk
ad_connect  axi_ad9361_0_clk  axi_ad9361_1/clk
ad_connect  axi_ad9361_0_clk  adc_wfifo/din_clk
ad_connect  axi_ad9361_0_clk  clkdiv/clk
ad_connect  axi_ad9361_0_clk  dac_fifo/dout_clk
ad_connect  axi_ad9361_0/rst  adc_wfifo/din_rst
ad_connect  axi_ad9361_0/rst  dac_fifo/dout_rst
ad_connect  clkdiv/clk_out    axi_ad9361_adc_dma/fifo_wr_clk
ad_connect  clkdiv/clk_out    adc_wfifo/dout_clk
ad_connect  clkdiv/clk_out    util_cpack_adc/adc_clk
ad_connect  clkdiv/clk_out    axi_ad9361_dac_dma/fifo_rd_clk
ad_connect  clkdiv/clk_out    dac_fifo/din_clk
ad_connect  clkdiv/clk_out    clkdiv_reset/slowest_sync_clk
ad_connect  clkdiv/clk_out    util_upack_dac/dac_clk

ad_connect  sys_cpu_resetn    sys_100m_resetn
ad_connect  sys_cpu_resetn    axi_ad9361_adc_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn    axi_ad9361_dac_dma/m_src_axi_aresetn
ad_connect  clkdiv_reset/ext_reset_in       sys_rstgen/peripheral_aresetn
ad_connect  clkdiv_reset/peripheral_reset   util_cpack_adc/adc_rst
ad_connect  clkdiv_reset/peripheral_aresetn dac_fifo/din_rstn
ad_connect  clkdiv_reset/peripheral_aresetn adc_wfifo/dout_rstn

ad_connect  axi_ad9361_0_dac_sync axi_ad9361_0/dac_sync_out
ad_connect  axi_ad9361_0_dac_sync axi_ad9361_0/dac_sync_in
ad_connect  axi_ad9361_0_dac_sync axi_ad9361_1/dac_sync_in

ad_connect  rx_clk_in_0_p     axi_ad9361_0/rx_clk_in_p
ad_connect  rx_clk_in_0_n     axi_ad9361_0/rx_clk_in_n
ad_connect  rx_frame_in_0_p   axi_ad9361_0/rx_frame_in_p
ad_connect  rx_frame_in_0_n   axi_ad9361_0/rx_frame_in_n
ad_connect  rx_data_in_0_p    axi_ad9361_0/rx_data_in_p
ad_connect  rx_data_in_0_n    axi_ad9361_0/rx_data_in_n
ad_connect  tx_clk_out_0_p    axi_ad9361_0/tx_clk_out_p
ad_connect  tx_clk_out_0_n    axi_ad9361_0/tx_clk_out_n
ad_connect  tx_frame_out_0_p  axi_ad9361_0/tx_frame_out_p
ad_connect  tx_frame_out_0_n  axi_ad9361_0/tx_frame_out_n
ad_connect  tx_data_out_0_p   axi_ad9361_0/tx_data_out_p
ad_connect  tx_data_out_0_n   axi_ad9361_0/tx_data_out_n
ad_connect  rx_clk_in_1_p     axi_ad9361_1/rx_clk_in_p
ad_connect  rx_clk_in_1_n     axi_ad9361_1/rx_clk_in_n
ad_connect  rx_frame_in_1_p   axi_ad9361_1/rx_frame_in_p
ad_connect  rx_frame_in_1_n   axi_ad9361_1/rx_frame_in_n
ad_connect  rx_data_in_1_p    axi_ad9361_1/rx_data_in_p
ad_connect  rx_data_in_1_n    axi_ad9361_1/rx_data_in_n
ad_connect  tx_clk_out_1_p    axi_ad9361_1/tx_clk_out_p
ad_connect  tx_clk_out_1_n    axi_ad9361_1/tx_clk_out_n
ad_connect  tx_frame_out_1_p  axi_ad9361_1/tx_frame_out_p
ad_connect  tx_frame_out_1_n  axi_ad9361_1/tx_frame_out_n
ad_connect  tx_data_out_1_p   axi_ad9361_1/tx_data_out_p
ad_connect  tx_data_out_1_n   axi_ad9361_1/tx_data_out_n

ad_connect  concat_logic/In0     axi_ad9361_0/adc_r1_mode
ad_connect  concat_logic/In1     axi_ad9361_0/dac_r1_mode
ad_connect  concat_logic/In2     axi_ad9361_1/adc_r1_mode
ad_connect  concat_logic/In3     axi_ad9361_1/dac_r1_mode
ad_connect  concat_logic/dout    clkdiv_sel_logic/Op1
ad_connect  clkdiv_sel_logic/Res clkdiv/clk_sel

ad_connect  axi_ad9361_adc_dma/fifo_wr_overflow adc_wfifo/dout_ovf
ad_connect  adc_wfifo/din_ovf axi_ad9361_0/adc_dovf
ad_connect  axi_ad9361_0/adc_enable_i0  adc_wfifo/din_enable_0
ad_connect  axi_ad9361_0/adc_valid_i0   adc_wfifo/din_valid_0
ad_connect  axi_ad9361_0/adc_data_i0    adc_wfifo/din_data_0
ad_connect  axi_ad9361_0/adc_enable_q0  adc_wfifo/din_enable_1
ad_connect  axi_ad9361_0/adc_valid_q0   adc_wfifo/din_valid_1
ad_connect  axi_ad9361_0/adc_data_q0    adc_wfifo/din_data_1
ad_connect  axi_ad9361_0/adc_enable_i1  adc_wfifo/din_enable_2
ad_connect  axi_ad9361_0/adc_valid_i1   adc_wfifo/din_valid_2
ad_connect  axi_ad9361_0/adc_data_i1    adc_wfifo/din_data_2
ad_connect  axi_ad9361_0/adc_enable_q1  adc_wfifo/din_enable_3
ad_connect  axi_ad9361_0/adc_valid_q1   adc_wfifo/din_valid_3
ad_connect  axi_ad9361_0/adc_data_q1    adc_wfifo/din_data_3
ad_connect  axi_ad9361_1/adc_enable_i0  adc_wfifo/din_enable_4
ad_connect  axi_ad9361_1/adc_valid_i0   adc_wfifo/din_valid_4
ad_connect  axi_ad9361_1/adc_data_i0    adc_wfifo/din_data_4
ad_connect  axi_ad9361_1/adc_enable_q0  adc_wfifo/din_enable_5
ad_connect  axi_ad9361_1/adc_valid_q0   adc_wfifo/din_valid_5
ad_connect  axi_ad9361_1/adc_data_q0    adc_wfifo/din_data_5
ad_connect  axi_ad9361_1/adc_enable_i1  adc_wfifo/din_enable_6
ad_connect  axi_ad9361_1/adc_valid_i1   adc_wfifo/din_valid_6
ad_connect  axi_ad9361_1/adc_data_i1    adc_wfifo/din_data_6
ad_connect  axi_ad9361_1/adc_enable_q1  adc_wfifo/din_enable_7
ad_connect  axi_ad9361_1/adc_valid_q1   adc_wfifo/din_valid_7
ad_connect  axi_ad9361_1/adc_data_q1    adc_wfifo/din_data_7

ad_connect  util_cpack_adc/adc_enable_0 adc_wfifo/dout_enable_0
ad_connect  util_cpack_adc/adc_valid_0  adc_wfifo/dout_valid_0
ad_connect  util_cpack_adc/adc_data_0   adc_wfifo/dout_data_0
ad_connect  util_cpack_adc/adc_enable_1 adc_wfifo/dout_enable_1
ad_connect  util_cpack_adc/adc_valid_1  adc_wfifo/dout_valid_1
ad_connect  util_cpack_adc/adc_data_1   adc_wfifo/dout_data_1
ad_connect  util_cpack_adc/adc_enable_2 adc_wfifo/dout_enable_2
ad_connect  util_cpack_adc/adc_valid_2  adc_wfifo/dout_valid_2
ad_connect  util_cpack_adc/adc_data_2   adc_wfifo/dout_data_2
ad_connect  util_cpack_adc/adc_enable_3 adc_wfifo/dout_enable_3
ad_connect  util_cpack_adc/adc_valid_3  adc_wfifo/dout_valid_3
ad_connect  util_cpack_adc/adc_data_3   adc_wfifo/dout_data_3
ad_connect  util_cpack_adc/adc_enable_4 adc_wfifo/dout_enable_4
ad_connect  util_cpack_adc/adc_valid_4  adc_wfifo/dout_valid_4
ad_connect  util_cpack_adc/adc_data_4   adc_wfifo/dout_data_4
ad_connect  util_cpack_adc/adc_enable_5 adc_wfifo/dout_enable_5
ad_connect  util_cpack_adc/adc_valid_5  adc_wfifo/dout_valid_5
ad_connect  util_cpack_adc/adc_data_5   adc_wfifo/dout_data_5
ad_connect  util_cpack_adc/adc_enable_6 adc_wfifo/dout_enable_6
ad_connect  util_cpack_adc/adc_valid_6  adc_wfifo/dout_valid_6
ad_connect  util_cpack_adc/adc_data_6   adc_wfifo/dout_data_6
ad_connect  util_cpack_adc/adc_enable_7 adc_wfifo/dout_enable_7
ad_connect  util_cpack_adc/adc_valid_7  adc_wfifo/dout_valid_7
ad_connect  util_cpack_adc/adc_data_7   adc_wfifo/dout_data_7

ad_connect  util_cpack_adc/adc_valid    axi_ad9361_adc_dma/fifo_wr_en
ad_connect  util_cpack_adc/adc_sync     axi_ad9361_adc_dma/fifo_wr_sync
ad_connect  util_cpack_adc/adc_data     axi_ad9361_adc_dma/fifo_wr_din

ad_connect  dac_fifo/din_enable_0 util_upack_dac/dac_enable_0
ad_connect  dac_fifo/din_valid_0  util_upack_dac/dac_valid_0
ad_connect  dac_fifo/din_data_0   util_upack_dac/dac_data_0
ad_connect  dac_fifo/din_enable_1 util_upack_dac/dac_enable_1
ad_connect  dac_fifo/din_valid_1  util_upack_dac/dac_valid_1
ad_connect  dac_fifo/din_data_1   util_upack_dac/dac_data_1
ad_connect  dac_fifo/din_enable_2 util_upack_dac/dac_enable_2
ad_connect  dac_fifo/din_valid_2  util_upack_dac/dac_valid_2
ad_connect  dac_fifo/din_data_2   util_upack_dac/dac_data_2
ad_connect  dac_fifo/din_enable_3 util_upack_dac/dac_enable_3
ad_connect  dac_fifo/din_valid_3  util_upack_dac/dac_valid_3
ad_connect  dac_fifo/din_data_3   util_upack_dac/dac_data_3
ad_connect  dac_fifo/din_enable_4 util_upack_dac/dac_enable_4
ad_connect  dac_fifo/din_valid_4  util_upack_dac/dac_valid_4
ad_connect  dac_fifo/din_data_4   util_upack_dac/dac_data_4
ad_connect  dac_fifo/din_enable_5 util_upack_dac/dac_enable_5
ad_connect  dac_fifo/din_valid_5  util_upack_dac/dac_valid_5
ad_connect  dac_fifo/din_data_5   util_upack_dac/dac_data_5
ad_connect  dac_fifo/din_enable_6 util_upack_dac/dac_enable_6
ad_connect  dac_fifo/din_valid_6  util_upack_dac/dac_valid_6
ad_connect  dac_fifo/din_data_6   util_upack_dac/dac_data_6
ad_connect  dac_fifo/din_enable_7 util_upack_dac/dac_enable_7
ad_connect  dac_fifo/din_valid_7  util_upack_dac/dac_valid_7
ad_connect  dac_fifo/din_data_7   util_upack_dac/dac_data_7

ad_connect  util_upack_dac/dac_valid  axi_ad9361_dac_dma/fifo_rd_en
ad_connect  util_upack_dac/dac_data   axi_ad9361_dac_dma/fifo_rd_dout

ad_connect  axi_ad9361_0/dac_enable_i0  dac_fifo/dout_enable_0
ad_connect  axi_ad9361_0/dac_valid_i0   dac_fifo/dout_valid_0
ad_connect  axi_ad9361_0/dac_data_i0    dac_fifo/dout_data_0
ad_connect  axi_ad9361_0/dac_enable_q0  dac_fifo/dout_enable_1
ad_connect  axi_ad9361_0/dac_valid_q0   dac_fifo/dout_valid_1
ad_connect  axi_ad9361_0/dac_data_q0    dac_fifo/dout_data_1
ad_connect  axi_ad9361_0/dac_enable_i1  dac_fifo/dout_enable_2
ad_connect  axi_ad9361_0/dac_valid_i1   dac_fifo/dout_valid_2
ad_connect  axi_ad9361_0/dac_data_i1    dac_fifo/dout_data_2
ad_connect  axi_ad9361_0/dac_enable_q1  dac_fifo/dout_enable_3
ad_connect  axi_ad9361_0/dac_valid_q1   dac_fifo/dout_valid_3
ad_connect  axi_ad9361_0/dac_data_q1    dac_fifo/dout_data_3
ad_connect  axi_ad9361_1/dac_enable_i0  dac_fifo/dout_enable_4
ad_connect  axi_ad9361_1/dac_valid_i0   dac_fifo/dout_valid_4
ad_connect  axi_ad9361_1/dac_data_i0    dac_fifo/dout_data_4
ad_connect  axi_ad9361_1/dac_enable_q0  dac_fifo/dout_enable_5
ad_connect  axi_ad9361_1/dac_valid_q0   dac_fifo/dout_valid_5
ad_connect  axi_ad9361_1/dac_data_q0    dac_fifo/dout_data_5
ad_connect  axi_ad9361_1/dac_enable_i1  dac_fifo/dout_enable_6
ad_connect  axi_ad9361_1/dac_valid_i1   dac_fifo/dout_valid_6
ad_connect  axi_ad9361_1/dac_data_i1    dac_fifo/dout_data_6
ad_connect  axi_ad9361_1/dac_enable_q1  dac_fifo/dout_enable_7
ad_connect  axi_ad9361_1/dac_valid_q1   dac_fifo/dout_valid_7
ad_connect  axi_ad9361_1/dac_data_q1    dac_fifo/dout_data_7

ad_connect  axi_ad9361_0/dac_dunf dac_fifo/dout_unf
ad_connect  axi_ad9361_1/dac_dunf dac_fifo/dout_unf

ad_connect  axi_ad9361_0/up_enable      up_enable_0
ad_connect  axi_ad9361_0/up_txnrx       up_txnrx_0
ad_connect  axi_ad9361_1/up_enable      up_enable_1
ad_connect  axi_ad9361_1/up_txnrx       up_txnrx_1

ad_connect  axi_ad9361_0/enable         enable_0
ad_connect  axi_ad9361_0/txnrx          txnrx_0
ad_connect  axi_ad9361_1/enable         enable_1
ad_connect  axi_ad9361_1/txnrx          txnrx_1

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
