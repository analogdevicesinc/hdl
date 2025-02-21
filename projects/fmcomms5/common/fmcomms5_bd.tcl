###############################################################################
## Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

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
ad_connect $sys_cpu_resetn sys_100m_resetn

# ad9361 core (master)

ad_ip_instance axi_ad9361 axi_ad9361_0
ad_ip_parameter axi_ad9361_0 CONFIG.ID 0
ad_ip_parameter axi_ad9361_0 CONFIG.IO_DELAY_GROUP dev_0_if_delay_group
ad_connect $sys_iodelay_clk axi_ad9361_0/delay_clk
ad_connect axi_ad9361_0/l_clk axi_ad9361_0/clk
ad_connect axi_ad9361_0/dac_sync_out axi_ad9361_0/dac_sync_in
ad_connect rx_clk_in_0_p axi_ad9361_0/rx_clk_in_p
ad_connect rx_clk_in_0_n axi_ad9361_0/rx_clk_in_n
ad_connect rx_frame_in_0_p axi_ad9361_0/rx_frame_in_p
ad_connect rx_frame_in_0_n axi_ad9361_0/rx_frame_in_n
ad_connect rx_data_in_0_p axi_ad9361_0/rx_data_in_p
ad_connect rx_data_in_0_n axi_ad9361_0/rx_data_in_n
ad_connect tx_clk_out_0_p axi_ad9361_0/tx_clk_out_p
ad_connect tx_clk_out_0_n axi_ad9361_0/tx_clk_out_n
ad_connect tx_frame_out_0_p axi_ad9361_0/tx_frame_out_p
ad_connect tx_frame_out_0_n axi_ad9361_0/tx_frame_out_n
ad_connect tx_data_out_0_p axi_ad9361_0/tx_data_out_p
ad_connect tx_data_out_0_n axi_ad9361_0/tx_data_out_n
ad_connect enable_0 axi_ad9361_0/enable
ad_connect txnrx_0 axi_ad9361_0/txnrx
ad_connect up_enable_0 axi_ad9361_0/up_enable
ad_connect up_txnrx_0 axi_ad9361_0/up_txnrx
ad_connect axi_ad9361_0/tdd_sync GND

# ad9361 core (slave)

ad_ip_instance axi_ad9361 axi_ad9361_1
ad_ip_parameter axi_ad9361_1 CONFIG.ID 1
ad_ip_parameter axi_ad9361_1 CONFIG.IO_DELAY_GROUP dev_1_if_delay_group
ad_ip_parameter axi_ad9361_1 CONFIG.USE_SSI_CLK 0
ad_connect $sys_iodelay_clk axi_ad9361_1/delay_clk
ad_connect axi_ad9361_0/l_clk axi_ad9361_1/clk
ad_connect axi_ad9361_0/dac_sync_out axi_ad9361_1/dac_sync_in
ad_connect rx_clk_in_1_p axi_ad9361_1/rx_clk_in_p
ad_connect rx_clk_in_1_n axi_ad9361_1/rx_clk_in_n
ad_connect rx_frame_in_1_p axi_ad9361_1/rx_frame_in_p
ad_connect rx_frame_in_1_n axi_ad9361_1/rx_frame_in_n
ad_connect rx_data_in_1_p axi_ad9361_1/rx_data_in_p
ad_connect rx_data_in_1_n axi_ad9361_1/rx_data_in_n
ad_connect tx_clk_out_1_p axi_ad9361_1/tx_clk_out_p
ad_connect tx_clk_out_1_n axi_ad9361_1/tx_clk_out_n
ad_connect tx_frame_out_1_p axi_ad9361_1/tx_frame_out_p
ad_connect tx_frame_out_1_n axi_ad9361_1/tx_frame_out_n
ad_connect tx_data_out_1_p axi_ad9361_1/tx_data_out_p
ad_connect tx_data_out_1_n axi_ad9361_1/tx_data_out_n
ad_connect enable_1 axi_ad9361_1/enable
ad_connect txnrx_1 axi_ad9361_1/txnrx
ad_connect up_enable_1 axi_ad9361_1/up_enable
ad_connect up_txnrx_1 axi_ad9361_1/up_txnrx
ad_connect axi_ad9361_1/tdd_sync GND

# interface clock divider to generate sampling clock
# interface runs at 4x in 2r2t mode, and 2x in 1r1t mode

ad_ip_instance xlconcat util_ad9361_divclk_sel_concat
ad_ip_parameter util_ad9361_divclk_sel_concat CONFIG.NUM_PORTS 4
ad_connect axi_ad9361_0/adc_r1_mode util_ad9361_divclk_sel_concat/In0
ad_connect axi_ad9361_0/dac_r1_mode util_ad9361_divclk_sel_concat/In1
ad_connect axi_ad9361_1/adc_r1_mode util_ad9361_divclk_sel_concat/In2
ad_connect axi_ad9361_1/dac_r1_mode util_ad9361_divclk_sel_concat/In3

ad_ip_instance util_reduced_logic util_ad9361_divclk_sel
ad_ip_parameter util_ad9361_divclk_sel CONFIG.C_SIZE 4
ad_connect util_ad9361_divclk_sel_concat/dout util_ad9361_divclk_sel/Op1

ad_ip_instance util_clkdiv util_ad9361_divclk
ad_connect util_ad9361_divclk_sel/Res util_ad9361_divclk/clk_sel
ad_connect axi_ad9361_0/l_clk util_ad9361_divclk/clk

# resets at divided clock

ad_ip_instance proc_sys_reset util_ad9361_divclk_reset
ad_connect sys_rstgen/peripheral_aresetn util_ad9361_divclk_reset/ext_reset_in
ad_connect util_ad9361_divclk/clk_out util_ad9361_divclk_reset/slowest_sync_clk

# adc-path wfifo

ad_ip_instance util_wfifo util_ad9361_adc_fifo
ad_ip_parameter util_ad9361_adc_fifo CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter util_ad9361_adc_fifo CONFIG.DIN_DATA_WIDTH 16
ad_ip_parameter util_ad9361_adc_fifo CONFIG.DOUT_DATA_WIDTH 16
ad_ip_parameter util_ad9361_adc_fifo CONFIG.DIN_ADDRESS_WIDTH 4
ad_connect axi_ad9361_0/l_clk util_ad9361_adc_fifo/din_clk
ad_connect axi_ad9361_0/rst util_ad9361_adc_fifo/din_rst
ad_connect util_ad9361_divclk/clk_out util_ad9361_adc_fifo/dout_clk
ad_connect util_ad9361_divclk_reset/peripheral_aresetn util_ad9361_adc_fifo/dout_rstn
ad_connect axi_ad9361_0/adc_enable_i0 util_ad9361_adc_fifo/din_enable_0
ad_connect axi_ad9361_0/adc_valid_i0 util_ad9361_adc_fifo/din_valid_0
ad_connect axi_ad9361_0/adc_data_i0 util_ad9361_adc_fifo/din_data_0
ad_connect axi_ad9361_0/adc_enable_q0 util_ad9361_adc_fifo/din_enable_1
ad_connect axi_ad9361_0/adc_valid_q0 util_ad9361_adc_fifo/din_valid_1
ad_connect axi_ad9361_0/adc_data_q0 util_ad9361_adc_fifo/din_data_1
ad_connect axi_ad9361_0/adc_enable_i1 util_ad9361_adc_fifo/din_enable_2
ad_connect axi_ad9361_0/adc_valid_i1 util_ad9361_adc_fifo/din_valid_2
ad_connect axi_ad9361_0/adc_data_i1 util_ad9361_adc_fifo/din_data_2
ad_connect axi_ad9361_0/adc_enable_q1 util_ad9361_adc_fifo/din_enable_3
ad_connect axi_ad9361_0/adc_valid_q1 util_ad9361_adc_fifo/din_valid_3
ad_connect axi_ad9361_0/adc_data_q1 util_ad9361_adc_fifo/din_data_3
ad_connect axi_ad9361_1/adc_enable_i0 util_ad9361_adc_fifo/din_enable_4
ad_connect axi_ad9361_1/adc_valid_i0 util_ad9361_adc_fifo/din_valid_4
ad_connect axi_ad9361_1/adc_data_i0 util_ad9361_adc_fifo/din_data_4
ad_connect axi_ad9361_1/adc_enable_q0 util_ad9361_adc_fifo/din_enable_5
ad_connect axi_ad9361_1/adc_valid_q0 util_ad9361_adc_fifo/din_valid_5
ad_connect axi_ad9361_1/adc_data_q0 util_ad9361_adc_fifo/din_data_5
ad_connect axi_ad9361_1/adc_enable_i1 util_ad9361_adc_fifo/din_enable_6
ad_connect axi_ad9361_1/adc_valid_i1 util_ad9361_adc_fifo/din_valid_6
ad_connect axi_ad9361_1/adc_data_i1 util_ad9361_adc_fifo/din_data_6
ad_connect axi_ad9361_1/adc_enable_q1 util_ad9361_adc_fifo/din_enable_7
ad_connect axi_ad9361_1/adc_valid_q1 util_ad9361_adc_fifo/din_valid_7
ad_connect axi_ad9361_1/adc_data_q1 util_ad9361_adc_fifo/din_data_7
ad_connect util_ad9361_adc_fifo/din_ovf axi_ad9361_0/adc_dovf
ad_connect util_ad9361_adc_fifo/din_ovf axi_ad9361_1/adc_dovf

# adc-path channel pack

ad_ip_instance util_cpack2 util_ad9361_adc_pack { \
  NUM_OF_CHANNELS 8 \
  SAMPLE_DATA_WIDTH 16 \
}

ad_connect util_ad9361_divclk/clk_out util_ad9361_adc_pack/clk
ad_connect util_ad9361_divclk_reset/peripheral_reset util_ad9361_adc_pack/reset

ad_connect util_ad9361_adc_fifo/dout_valid_0 util_ad9361_adc_pack/fifo_wr_en
ad_connect util_ad9361_adc_pack/fifo_wr_overflow util_ad9361_adc_fifo/dout_ovf

for {set i 0} {$i < 8} {incr i} {
  ad_connect util_ad9361_adc_fifo/dout_enable_$i util_ad9361_adc_pack/enable_$i
  ad_connect util_ad9361_adc_fifo/dout_data_$i util_ad9361_adc_pack/fifo_wr_data_$i
}

# adc-path dma

ad_ip_instance axi_dmac axi_ad9361_adc_dma
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9361_adc_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9361_adc_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_ad9361_adc_dma CONFIG.CACHE_COHERENT $CACHE_COHERENCY

ad_connect util_ad9361_divclk/clk_out axi_ad9361_adc_dma/fifo_wr_clk
ad_connect util_ad9361_adc_pack/packed_fifo_wr axi_ad9361_adc_dma/fifo_wr
ad_connect util_ad9361_adc_pack/packed_sync axi_ad9361_adc_dma/sync
ad_connect $sys_dma_resetn axi_ad9361_adc_dma/m_dest_axi_aresetn

# dac-path rfifo

ad_ip_instance util_rfifo axi_ad9361_dac_fifo
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.DIN_DATA_WIDTH 16
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.DOUT_DATA_WIDTH 16
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.DIN_ADDRESS_WIDTH 4
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.NUM_OF_CHANNELS 8
ad_connect axi_ad9361_0/l_clk axi_ad9361_dac_fifo/dout_clk
ad_connect axi_ad9361_0/rst axi_ad9361_dac_fifo/dout_rst
ad_connect util_ad9361_divclk/clk_out axi_ad9361_dac_fifo/din_clk
ad_connect util_ad9361_divclk_reset/peripheral_aresetn axi_ad9361_dac_fifo/din_rstn
ad_connect axi_ad9361_dac_fifo/dout_enable_0 axi_ad9361_0/dac_enable_i0
ad_connect axi_ad9361_dac_fifo/dout_valid_0 axi_ad9361_0/dac_valid_i0
ad_connect axi_ad9361_dac_fifo/dout_data_0 axi_ad9361_0/dac_data_i0
ad_connect axi_ad9361_dac_fifo/dout_enable_1 axi_ad9361_0/dac_enable_q0
ad_connect axi_ad9361_dac_fifo/dout_valid_1 axi_ad9361_0/dac_valid_q0
ad_connect axi_ad9361_dac_fifo/dout_data_1 axi_ad9361_0/dac_data_q0
ad_connect axi_ad9361_dac_fifo/dout_enable_2 axi_ad9361_0/dac_enable_i1
ad_connect axi_ad9361_dac_fifo/dout_valid_2 axi_ad9361_0/dac_valid_i1
ad_connect axi_ad9361_dac_fifo/dout_data_2 axi_ad9361_0/dac_data_i1
ad_connect axi_ad9361_dac_fifo/dout_enable_3 axi_ad9361_0/dac_enable_q1
ad_connect axi_ad9361_dac_fifo/dout_valid_3 axi_ad9361_0/dac_valid_q1
ad_connect axi_ad9361_dac_fifo/dout_data_3 axi_ad9361_0/dac_data_q1
ad_connect axi_ad9361_dac_fifo/dout_enable_4 axi_ad9361_1/dac_enable_i0
ad_connect axi_ad9361_dac_fifo/dout_valid_4 axi_ad9361_1/dac_valid_i0
ad_connect axi_ad9361_dac_fifo/dout_data_4 axi_ad9361_1/dac_data_i0
ad_connect axi_ad9361_dac_fifo/dout_enable_5 axi_ad9361_1/dac_enable_q0
ad_connect axi_ad9361_dac_fifo/dout_valid_5 axi_ad9361_1/dac_valid_q0
ad_connect axi_ad9361_dac_fifo/dout_data_5 axi_ad9361_1/dac_data_q0
ad_connect axi_ad9361_dac_fifo/dout_enable_6 axi_ad9361_1/dac_enable_i1
ad_connect axi_ad9361_dac_fifo/dout_valid_6 axi_ad9361_1/dac_valid_i1
ad_connect axi_ad9361_dac_fifo/dout_data_6 axi_ad9361_1/dac_data_i1
ad_connect axi_ad9361_dac_fifo/dout_enable_7 axi_ad9361_1/dac_enable_q1
ad_connect axi_ad9361_dac_fifo/dout_valid_7 axi_ad9361_1/dac_valid_q1
ad_connect axi_ad9361_dac_fifo/dout_data_7 axi_ad9361_1/dac_data_q1
ad_connect axi_ad9361_dac_fifo/dout_unf axi_ad9361_0/dac_dunf
ad_connect axi_ad9361_dac_fifo/dout_unf axi_ad9361_1/dac_dunf

# dac-path channel unpack

ad_ip_instance util_upack2 util_ad9361_dac_upack { \
  NUM_OF_CHANNELS 8 \
  SAMPLE_DATA_WIDTH 16 \
}

ad_connect util_ad9361_divclk/clk_out util_ad9361_dac_upack/clk
ad_connect util_ad9361_divclk_reset/peripheral_reset util_ad9361_dac_upack/reset

ad_connect util_ad9361_dac_upack/fifo_rd_en axi_ad9361_dac_fifo/din_valid_0
ad_connect util_ad9361_dac_upack/fifo_rd_underflow axi_ad9361_dac_fifo/din_unf

for {set i 0} {$i < 8} {incr i} {
  ad_connect util_ad9361_dac_upack/enable_$i axi_ad9361_dac_fifo/din_enable_$i
  ad_connect util_ad9361_dac_upack/fifo_rd_valid axi_ad9361_dac_fifo/din_valid_in_$i
  ad_connect util_ad9361_dac_upack/fifo_rd_data_$i axi_ad9361_dac_fifo/din_data_$i
}

# dac-path dma

ad_ip_instance axi_dmac axi_ad9361_dac_dma
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9361_dac_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9361_dac_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9361_dac_dma CONFIG.CACHE_COHERENT $CACHE_COHERENCY

ad_connect $sys_dma_resetn axi_ad9361_dac_dma/m_src_axi_aresetn
ad_connect util_ad9361_divclk/clk_out axi_ad9361_dac_dma/m_axis_aclk
ad_connect axi_ad9361_dac_dma/m_axis util_ad9361_dac_upack/s_axis

# address map

ad_cpu_interconnect 0x79020000 axi_ad9361_0
ad_cpu_interconnect 0x7C420000 axi_ad9361_dac_dma
ad_cpu_interconnect 0x7C400000 axi_ad9361_adc_dma
ad_cpu_interconnect 0x79040000 axi_ad9361_1

if {$CACHE_COHERENCY} {
  ad_mem_hpc0_interconnect $sys_dma_clk sys_ps8/S_AXI_HPC0
  ad_mem_hpc0_interconnect $sys_dma_clk axi_ad9361_adc_dma/m_dest_axi
  ad_mem_hpc1_interconnect $sys_dma_clk sys_ps8/S_AXI_HPC1
  ad_mem_hpc1_interconnect $sys_dma_clk axi_ad9361_dac_dma/m_src_axi
} else {
  ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
  ad_mem_hp2_interconnect $sys_dma_clk axi_ad9361_adc_dma/m_dest_axi
  ad_mem_hp3_interconnect $sys_dma_clk sys_ps7/S_AXI_HP3
  ad_mem_hp3_interconnect $sys_dma_clk axi_ad9361_dac_dma/m_src_axi
}

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad9361_dac_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9361_adc_dma/irq
