###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
##--------------------------------------------------------------

# system level parameter

set INTF $ad_project_params(INTF)
set NUM_OF_SDI $ad_project_params(NUM_OF_SDI)

puts "build parameters: INTF: $INTF"
puts "build parameters: NUM_OF_SDI: $NUM_OF_SDI"

# control lines

create_bd_port -dir O rx_cnvst
create_bd_port -dir I rx_busy

# instantiation

# dma

ad_ip_instance axi_dmac axi_ad7616_dma
ad_ip_parameter axi_ad7616_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7616_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7616_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7616_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# axi_pwm_gen

ad_ip_instance axi_pwm_gen ad7616_pwm_gen
ad_ip_parameter ad7616_pwm_gen CONFIG.PULSE_0_PERIOD 100
ad_ip_parameter ad7616_pwm_gen CONFIG.PULSE_0_WIDTH 5
ad_ip_parameter ad7616_pwm_gen CONFIG.ASYNC_CLK_EN 0

# trigger to BUSY's negative edge

create_bd_cell -type module -reference sync_bits busy_sync
create_bd_cell -type module -reference ad_edge_detect busy_capture
set_property -dict [list CONFIG.EDGE 1] [get_bd_cells busy_capture]

ad_connect $sys_cpu_clk busy_capture/clk
ad_connect busy_capture/rst GND
ad_connect $sys_cpu_clk busy_sync/out_clk
ad_connect busy_sync/in_bits rx_busy
ad_connect busy_sync/out_bits busy_capture/signal_in

if {$INTF == 1} {
  create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 ad7616_spi

  source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

  set data_width    16
  set async_spi_clk 1
  set num_cs        1
  set num_sdi       $NUM_OF_SDI
  set sdi_delay     1
  set hier_spi_engine spi_ad7616

  spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $sdi_delay

  ad_ip_parameter axi_ad7616_dma CONFIG.DMA_DATA_WIDTH_SRC [expr $data_width * $num_sdi]
  ad_ip_parameter axi_ad7616_dma CONFIG.DMA_TYPE_SRC 1
  ad_ip_parameter axi_ad7616_dma CONFIG.SYNC_TRANSFER_START 0
  ad_ip_parameter axi_ad7616_dma CONFIG.AXI_SLICE_SRC 0
  ad_ip_parameter axi_ad7616_dma CONFIG.AXI_SLICE_DEST 1

  # interface connections

  ad_connect  $sys_cpu_clk $hier_spi_engine/clk
  ad_connect  $sys_cpu_clk $hier_spi_engine/spi_clk

  ad_connect  sys_cpu_resetn $hier_spi_engine/resetn
  ad_connect  $hier_spi_engine/m_spi ad7616_spi

  ad_connect  $sys_cpu_clk axi_ad7616_dma/s_axis_aclk
  ad_connect  axi_ad7616_dma/s_axis $hier_spi_engine/m_axis_sample

  ad_connect  busy_sync/out_resetn $hier_spi_engine/${hier_spi_engine}_axi_regmap/spi_resetn
  ad_connect  busy_capture/signal_out $hier_spi_engine/${hier_spi_engine}_offload/trigger

  ad_ip_parameter ad7616_pwm_gen CONFIG.ASYNC_CLK_EN 1
  ad_connect $sys_cpu_clk ad7616_pwm_gen/ext_clk

  # interconnect

  ad_cpu_interconnect  0x44A00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap

  # interrupts

  ad_cpu_interrupt ps-12 mb-12 /$hier_spi_engine/irq

} else {
  # data interfaces

  create_bd_port -dir O -from 15 -to 0 rx_db_o
  create_bd_port -dir I -from 15 -to 0 rx_db_i
  create_bd_port -dir O rx_db_t
  create_bd_port -dir O rx_rd_n
  create_bd_port -dir O rx_wr_n
  create_bd_port -dir O rx_cs_n

  ad_ip_parameter axi_ad7616_dma CONFIG.DMA_DATA_WIDTH_SRC 256
  ad_ip_parameter axi_ad7616_dma CONFIG.DMA_TYPE_SRC 2
  ad_ip_parameter axi_ad7616_dma CONFIG.SYNC_TRANSFER_START 1

  ad_ip_instance axi_ad7616 axi_ad7616

  # cpack

  ad_ip_instance util_cpack2 ad7616_adc_pack
  ad_ip_parameter ad7616_adc_pack CONFIG.NUM_OF_CHANNELS 16
  ad_ip_parameter ad7616_adc_pack CONFIG.SAMPLE_DATA_WIDTH 16;

  # interface connections

  ad_connect  rx_db_o axi_ad7616/rx_db_o
  ad_connect  rx_db_i axi_ad7616/rx_db_i
  ad_connect  rx_db_t axi_ad7616/rx_db_t
  ad_connect  rx_rd_n axi_ad7616/rx_rd_n
  ad_connect  rx_wr_n axi_ad7616/rx_wr_n
  ad_connect  rx_cs_n axi_ad7616/rx_cs_n

  ad_connect  axi_ad7616/adc_clk axi_ad7616_dma/fifo_wr_clk

  ad_connect  axi_ad7616/adc_clk ad7616_adc_pack/clk
  ad_connect  axi_ad7616/adc_reset ad7616_adc_pack/reset
  ad_connect  axi_ad7616/adc_valid ad7616_adc_pack/fifo_wr_en

  ad_connect ad7616_adc_pack/packed_fifo_wr axi_ad7616_dma/fifo_wr
  ad_connect ad7616_adc_pack/packed_sync axi_ad7616_dma/sync
  ad_connect ad7616_adc_pack/fifo_wr_overflow axi_ad7616/adc_dovf

  for {set i 0} {$i < 16} {incr i} {
    ad_connect axi_ad7616/adc_data_$i ad7616_adc_pack/fifo_wr_data_$i
    ad_connect axi_ad7616/adc_enable_$i ad7616_adc_pack/enable_$i
  }

  ad_connect busy_capture/signal_out axi_ad7616/rx_trigger
  ad_connect busy_sync/out_resetn sys_cpu_resetn

  # interconnect

  ad_cpu_interconnect  0x44A80000 axi_ad7616

}

# interface connections

ad_connect  ad7616_pwm_gen/pwm_0 rx_cnvst
ad_connect  $sys_cpu_clk ad7616_pwm_gen/s_axi_aclk
ad_connect  sys_cpu_resetn ad7616_pwm_gen/s_axi_aresetn
ad_connect  $sys_cpu_clk axi_ad7616_dma/s_axi_aclk
ad_connect  sys_cpu_resetn axi_ad7616_dma/m_dest_axi_aresetn

# interconnect

ad_cpu_interconnect  0x44A30000 axi_ad7616_dma
ad_cpu_interconnect  0x44B00000 ad7616_pwm_gen

# memory interconnect

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad7616_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad7616_dma/irq
