###############################################################################
## Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

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

ad_ip_instance axi_ad9361 axi_ad9361
ad_ip_parameter axi_ad9361 CONFIG.ID 0

# set to 1 for CORDIC or 2 for POLYNOMIAL
ad_ip_parameter axi_ad9361 CONFIG.DAC_DDS_TYPE 1
ad_ip_parameter axi_ad9361 CONFIG.DAC_DDS_CORDIC_DW 14
ad_connect $sys_iodelay_clk axi_ad9361/delay_clk
ad_connect axi_ad9361/l_clk axi_ad9361/clk
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

# tdd-sync

ad_ip_instance util_tdd_sync util_ad9361_tdd_sync
ad_ip_parameter util_ad9361_tdd_sync CONFIG.TDD_SYNC_PERIOD 10000000
ad_connect $sys_cpu_clk util_ad9361_tdd_sync/clk
ad_connect $sys_cpu_resetn util_ad9361_tdd_sync/rstn
ad_connect util_ad9361_tdd_sync/sync_out axi_ad9361/tdd_sync
ad_connect util_ad9361_tdd_sync/sync_mode axi_ad9361/tdd_sync_cntr
ad_connect tdd_sync_t axi_ad9361/tdd_sync_cntr
ad_connect tdd_sync_o util_ad9361_tdd_sync/sync_out
ad_connect tdd_sync_i util_ad9361_tdd_sync/sync_in

# interface clock divider to generate sampling clock
# interface runs at 4x in 2r2t mode, and 2x in 1r1t mode

ad_ip_instance xlconcat util_ad9361_divclk_sel_concat
ad_ip_parameter util_ad9361_divclk_sel_concat CONFIG.NUM_PORTS 2
ad_connect axi_ad9361/adc_r1_mode util_ad9361_divclk_sel_concat/In0
ad_connect axi_ad9361/dac_r1_mode util_ad9361_divclk_sel_concat/In1

ad_ip_instance util_reduced_logic util_ad9361_divclk_sel
ad_ip_parameter util_ad9361_divclk_sel CONFIG.C_SIZE 2
ad_connect util_ad9361_divclk_sel_concat/dout util_ad9361_divclk_sel/Op1

ad_ip_instance util_clkdiv util_ad9361_divclk
ad_connect util_ad9361_divclk_sel/Res util_ad9361_divclk/clk_sel
ad_connect axi_ad9361/l_clk util_ad9361_divclk/clk

# resets at divided clock

ad_ip_instance proc_sys_reset util_ad9361_divclk_reset
ad_connect sys_rstgen/peripheral_aresetn util_ad9361_divclk_reset/ext_reset_in
ad_connect util_ad9361_divclk/clk_out util_ad9361_divclk_reset/slowest_sync_clk

# system reset for sha3
ad_ip_instance proc_sys_reset sys_rstgen_sha3
ad_connect sys_rstgen_sha3/ext_reset_in sys_ps8/pl_resetn1
ad_connect $sys_cpu_clk sys_rstgen_sha3/slowest_sync_clk

# resets at divided clock sha3
ad_ip_instance proc_sys_reset util_ad9361_divclk_reset_sha3
ad_connect sys_rstgen_sha3/peripheral_aresetn util_ad9361_divclk_reset_sha3/ext_reset_in
ad_connect util_ad9361_divclk/clk_out util_ad9361_divclk_reset_sha3/slowest_sync_clk

# adc-path wfifo

ad_ip_instance util_wfifo util_ad9361_adc_fifo
ad_ip_parameter util_ad9361_adc_fifo CONFIG.NUM_OF_CHANNELS 4
ad_ip_parameter util_ad9361_adc_fifo CONFIG.DIN_ADDRESS_WIDTH 4
ad_ip_parameter util_ad9361_adc_fifo CONFIG.DIN_DATA_WIDTH 16
ad_ip_parameter util_ad9361_adc_fifo CONFIG.DOUT_DATA_WIDTH 16
ad_connect axi_ad9361/l_clk util_ad9361_adc_fifo/din_clk
ad_connect axi_ad9361/rst util_ad9361_adc_fifo/din_rst
ad_connect util_ad9361_divclk/clk_out util_ad9361_adc_fifo/dout_clk
ad_connect util_ad9361_divclk_reset/peripheral_aresetn util_ad9361_adc_fifo/dout_rstn
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
ad_connect util_ad9361_adc_fifo/din_ovf axi_ad9361/adc_dovf

# adc-path channel pack

ad_ip_instance util_cpack2 util_ad9361_adc_pack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

ad_connect util_ad9361_divclk/clk_out util_ad9361_adc_pack/clk
ad_connect util_ad9361_divclk_reset/peripheral_reset util_ad9361_adc_pack/reset

ad_connect util_ad9361_adc_fifo/dout_valid_0 util_ad9361_adc_pack/fifo_wr_en
ad_connect util_ad9361_adc_pack/fifo_wr_overflow util_ad9361_adc_fifo/dout_ovf

for {set i 0} {$i < 4} {incr i} {
  ad_connect util_ad9361_adc_fifo/dout_enable_$i util_ad9361_adc_pack/enable_$i
  ad_connect util_ad9361_adc_fifo/dout_data_$i util_ad9361_adc_pack/fifo_wr_data_$i
}

# adc-path sha3 dma
ad_ip_instance axi_dmac axi_sha3_dma
ad_ip_parameter axi_sha3_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_sha3_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_sha3_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_sha3_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_sha3_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_sha3_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_sha3_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_sha3_dma CONFIG.DMA_SG_TRANSFER 1
ad_ip_parameter axi_sha3_dma CONFIG.DMA_DATA_WIDTH_SRC 512
ad_ip_parameter axi_sha3_dma CONFIG.DMA_DATA_WIDTH_SG 64

ad_connect util_ad9361_divclk/clk_out axi_sha3_dma/fifo_wr_clk
# ad_connect util_ad9361_adc_pack/packed_sync axi_sha3_dma/sync
ad_connect sys_rstgen_sha3/peripheral_aresetn axi_sha3_dma/s_axi_aresetn
ad_connect sys_rstgen_sha3/peripheral_aresetn axi_sha3_dma/m_dest_axi_aresetn
ad_connect sys_rstgen_sha3/peripheral_aresetn axi_sha3_dma/m_sg_axi_aresetn
# ad_connect $sys_cpu_resetn axi_sha3_dma/m_dest_axi_aresetn
# ad_connect $sys_cpu_resetn axi_sha3_dma/m_sg_axi_aresetn

#ramp-path ramp
ad_ip_instance ramp ramp_sha3
ad_connect util_ad9361_divclk/clk_out ramp_sha3/clk
ad_connect util_ad9361_divclk_reset/peripheral_reset ramp_sha3/rst

# adc-path ramp dma
ad_ip_instance axi_dmac axi_ramp_dma
ad_ip_parameter axi_ramp_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ramp_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ramp_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ramp_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ramp_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ramp_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ramp_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ramp_dma CONFIG.DMA_SG_TRANSFER 1
ad_ip_parameter axi_ramp_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ramp_dma CONFIG.DMA_DATA_WIDTH_SG 64

ad_connect util_ad9361_divclk/clk_out axi_ramp_dma/fifo_wr_clk
ad_connect ramp_sha3/data_valid axi_ramp_dma/fifo_wr_en
ad_connect ramp_sha3/data_out axi_ramp_dma/fifo_wr_din
ad_connect $sys_cpu_resetn axi_ramp_dma/m_dest_axi_aresetn
ad_connect $sys_cpu_resetn axi_ramp_dma/m_sg_axi_aresetn

# sha3-path sha3_512
set sha3_512 [ create_bd_cell -type ip -vlnv xilinx.com:hls:sha3_ip_512:1.0 sha3_512 ]
ad_connect util_ad9361_divclk/clk_out sha3_512/ap_clk
ad_connect util_ad9361_divclk_reset_sha3/peripheral_reset sha3_512/ap_rst

set gpio_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gpio_slice ]
set_property -dict [list \
  CONFIG.DIN_FROM {93} \
  CONFIG.DIN_TO {93} \
  CONFIG.DIN_WIDTH {94} \
] $gpio_slice

ad_connect gpio_slice/din sys_ps8/emio_gpio_o

#bus_mux
ad_ip_instance bus_mux ramp_sha3_mux
ad_connect ramp_sha3_mux/sel gpio_slice/dout
ad_connect ramp_sha3_mux/data_a ramp_sha3/data_out
ad_connect ramp_sha3_mux/data_a_valid ramp_sha3/data_valid
ad_connect ramp_sha3_mux/data_b util_ad9361_adc_pack/packed_fifo_wr_data
ad_connect ramp_sha3_mux/data_b_valid util_ad9361_adc_pack/packed_fifo_wr_en

# Create instance: system_ila_0, and set properties
set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
set_property -dict [list \
  CONFIG.C_DATA_DEPTH {16384} \
  CONFIG.C_MON_TYPE {NATIVE} \
  CONFIG.C_NUM_OF_PROBES {6} \
  CONFIG.C_PROBE0_WIDTH {64} \
  CONFIG.C_PROBE3_WIDTH {512} \
  CONFIG.C_PROBE_WIDTH_PROPAGATION {MANUAL} \
] $system_ila_0


# connections with ramp
# ad_connect sha3_512/msgStreamIn_dout ramp_sha3/data_out
# ad_connect sha3_512/msgStreamIn_empty_n ramp_sha3/data_valid
ad_connect sha3_512/msgStreamIn_dout ramp_sha3_mux/data_out
ad_connect sha3_512/msgStreamIn_empty_n ramp_sha3_mux/data_out_valid
ad_connect sha3_512/msgStreamIn_read ramp_sha3/ready
ad_connect sha3_512/digestStreamOut_din axi_sha3_dma/fifo_wr_din
ad_connect sha3_512/digestStreamOut_full_n VCC
ad_connect sha3_512/digestStreamOut_write axi_sha3_dma/fifo_wr_en

# connections with ADC CPACK2
# ad_connect sha3_512/msgStreamIn_dout util_ad9361_adc_pack/packed_fifo_wr_data
# ad_connect sha3_512/msgStreamIn_empty_n util_ad9361_adc_pack/packed_fifo_wr_en
# ad_connect sha3_512/digestStreamOut_din axi_sha3_dma/fifo_wr_din
# ad_connect sha3_512/digestStreamOut_full_n VCC
# ad_connect sha3_512/digestStreamOut_write axi_sha3_dma/fifo_wr_en

#connections with ILA
ad_connect util_ad9361_divclk/clk_out system_ila_0/clk
ad_connect system_ila_0/probe0 ramp_sha3_mux/data_out
ad_connect system_ila_0/probe1 ramp_sha3_mux/data_out_valid
# ad_connect system_ila_0/probe0 ramp_sha3/data_out
# ad_connect system_ila_0/probe1 ramp_sha3/data_valid
# ad_connect system_ila_0/probe0 util_ad9361_adc_pack/packed_fifo_wr_data
# ad_connect system_ila_0/probe1 util_ad9361_adc_pack/packed_fifo_wr_en
ad_connect system_ila_0/probe2 sha3_512/msgStreamIn_read
ad_connect system_ila_0/probe3 sha3_512/digestStreamOut_din
ad_connect system_ila_0/probe4 util_ad9361_divclk_reset_sha3/peripheral_reset
ad_connect system_ila_0/probe5 sha3_512/digestStreamOut_write

# adc-path dma

ad_ip_instance axi_dmac axi_ad9361_adc_dma
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9361_adc_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_SG_TRANSFER 1
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_DATA_WIDTH_SG 64

ad_connect util_ad9361_divclk/clk_out axi_ad9361_adc_dma/fifo_wr_clk
ad_connect util_ad9361_adc_pack/packed_fifo_wr axi_ad9361_adc_dma/fifo_wr
ad_connect util_ad9361_adc_pack/packed_fifo_wr_data axi_ad9361_adc_dma/fifo_wr_din
ad_connect util_ad9361_adc_pack/packed_fifo_wr_en axi_ad9361_adc_dma/fifo_wr_en
ad_connect util_ad9361_adc_pack/packed_sync axi_ad9361_adc_dma/sync
ad_connect $sys_cpu_resetn axi_ad9361_adc_dma/m_dest_axi_aresetn
ad_connect $sys_cpu_resetn axi_ad9361_adc_dma/m_sg_axi_aresetn

# dac-path rfifo

ad_ip_instance util_rfifo axi_ad9361_dac_fifo
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.DIN_DATA_WIDTH 16
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.DOUT_DATA_WIDTH 16
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.DIN_ADDRESS_WIDTH 4
ad_connect axi_ad9361/l_clk axi_ad9361_dac_fifo/dout_clk
ad_connect axi_ad9361/rst axi_ad9361_dac_fifo/dout_rst
ad_connect util_ad9361_divclk/clk_out axi_ad9361_dac_fifo/din_clk
ad_connect util_ad9361_divclk_reset/peripheral_aresetn axi_ad9361_dac_fifo/din_rstn
ad_connect axi_ad9361_dac_fifo/dout_enable_0 axi_ad9361/dac_enable_i0
ad_connect axi_ad9361_dac_fifo/dout_valid_0 axi_ad9361/dac_valid_i0
ad_connect axi_ad9361_dac_fifo/dout_data_0 axi_ad9361/dac_data_i0
ad_connect axi_ad9361_dac_fifo/dout_enable_1 axi_ad9361/dac_enable_q0
ad_connect axi_ad9361_dac_fifo/dout_valid_1 axi_ad9361/dac_valid_q0
ad_connect axi_ad9361_dac_fifo/dout_data_1 axi_ad9361/dac_data_q0
ad_connect axi_ad9361_dac_fifo/dout_enable_2 axi_ad9361/dac_enable_i1
ad_connect axi_ad9361_dac_fifo/dout_valid_2 axi_ad9361/dac_valid_i1
ad_connect axi_ad9361_dac_fifo/dout_data_2 axi_ad9361/dac_data_i1
ad_connect axi_ad9361_dac_fifo/dout_enable_3 axi_ad9361/dac_enable_q1
ad_connect axi_ad9361_dac_fifo/dout_valid_3 axi_ad9361/dac_valid_q1
ad_connect axi_ad9361_dac_fifo/dout_data_3 axi_ad9361/dac_data_q1
ad_connect axi_ad9361_dac_fifo/dout_unf axi_ad9361/dac_dunf

# dac-path channel unpack

ad_ip_instance util_upack2 util_ad9361_dac_upack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

ad_connect util_ad9361_divclk/clk_out util_ad9361_dac_upack/clk
ad_connect util_ad9361_divclk_reset/peripheral_reset util_ad9361_dac_upack/reset

ad_connect util_ad9361_dac_upack/fifo_rd_en axi_ad9361_dac_fifo/din_valid_0
ad_connect util_ad9361_dac_upack/fifo_rd_underflow axi_ad9361_dac_fifo/din_unf

for {set i 0} {$i < 4} {incr i} {
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
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_SG_TRANSFER 1
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_DATA_WIDTH_SG 64

ad_connect util_ad9361_divclk/clk_out axi_ad9361_dac_dma/m_axis_aclk
ad_connect axi_ad9361_dac_dma/m_axis util_ad9361_dac_upack/s_axis

ad_connect $sys_cpu_resetn axi_ad9361_dac_dma/m_src_axi_aresetn
ad_connect $sys_cpu_resetn axi_ad9361_dac_dma/m_sg_axi_aresetn

# interconnects

ad_cpu_interconnect 0x79020000 axi_ad9361
ad_cpu_interconnect 0x7C400000 axi_ad9361_adc_dma
ad_cpu_interconnect 0x7C420000 axi_ad9361_dac_dma
ad_cpu_interconnect 0x7C440000 axi_sha3_dma
ad_cpu_interconnect 0x7C460000 axi_ramp_dma
ad_mem_hp0_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect $sys_cpu_clk axi_ramp_dma/m_dest_axi
ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad9361_adc_dma/m_dest_axi
ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ad9361_dac_dma/m_src_axi
ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_sha3_dma/m_dest_axi

ad_mem_hp0_interconnect $sys_cpu_clk axi_ramp_dma/m_sg_axi
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad9361_adc_dma/m_sg_axi
ad_mem_hp2_interconnect $sys_cpu_clk axi_ad9361_dac_dma/m_sg_axi
ad_mem_hp3_interconnect $sys_cpu_clk axi_sha3_dma/m_sg_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_ad9361_adc_dma/irq
ad_cpu_interrupt ps-14 mb-14 axi_sha3_dma/irq
ad_cpu_interrupt ps-15 mb-15 axi_ramp_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_ad9361_dac_dma/irq

