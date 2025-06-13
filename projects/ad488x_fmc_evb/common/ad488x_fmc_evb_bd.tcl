###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad4880 interface

create_bd_port -dir I adca_dco_p
create_bd_port -dir I adca_dco_n
create_bd_port -dir I adca_da_p
create_bd_port -dir I adca_da_n
create_bd_port -dir I adca_db_p
create_bd_port -dir I adca_db_n
create_bd_port -dir I adca_sync_n
create_bd_port -dir I adca_cnv_in_p
create_bd_port -dir I adca_cnv_in_n
create_bd_port -dir I adca_filter_data_ready_n

create_bd_port -dir I adcb_dco_p
create_bd_port -dir I adcb_dco_n
create_bd_port -dir I adcb_da_p
create_bd_port -dir I adcb_da_n
create_bd_port -dir I adcb_db_p
create_bd_port -dir I adcb_db_n
create_bd_port -dir I adcb_sync_n
create_bd_port -dir I adcb_cnv_in_p
create_bd_port -dir I adcb_cnv_in_n
create_bd_port -dir I adcb_filter_data_ready_n

create_bd_port -dir I fpga_a_ref_clk
create_bd_port -dir I fpga_b_ref_clk

create_bd_port -dir O ad4080_b_spi_csn_o
create_bd_port -dir I ad4080_b_spi_csn_i
create_bd_port -dir I ad4080_b_spi_clk_i
create_bd_port -dir O ad4080_b_spi_clk_o
create_bd_port -dir I ad4080_b_spi_sdo_i
create_bd_port -dir O ad4080_b_spi_sdo_o
create_bd_port -dir I ad4080_b_spi_sdi_i

# ad488x_clock_monitor

ad_ip_instance axi_clock_monitor ad488x_clock_monitor
ad_ip_parameter ad488x_clock_monitor CONFIG.NUM_OF_CLOCKS 2
ad_ip_parameter ad488x_clock_monitor CONFIG.DIV_RATE 4

ad_connect fpga_a_ref_clk  ad488x_clock_monitor/clock_0
ad_connect fpga_b_ref_clk  ad488x_clock_monitor/clock_1

#ad4080 AXI_SPI

ad_ip_instance axi_quad_spi ad4080_b_spi
ad_ip_parameter ad4080_b_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter ad4080_b_spi CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter ad4080_b_spi CONFIG.C_SCK_RATIO 8

ad_connect ad4080_b_spi_csn_i ad4080_b_spi/ss_i
ad_connect ad4080_b_spi_csn_o ad4080_b_spi/ss_o
ad_connect ad4080_b_spi_clk_i ad4080_b_spi/sck_i
ad_connect ad4080_b_spi_clk_o ad4080_b_spi/sck_o
ad_connect ad4080_b_spi_sdo_o ad4080_b_spi/io0_o
ad_connect ad4080_b_spi_sdi_i ad4080_b_spi/io1_i

ad_connect $sys_cpu_clk ad4080_b_spi/ext_spi_clk

# axi_ad408x

ad_ip_instance axi_ad408x axi_ad4080_adc_a

ad_ip_instance axi_ad408x axi_ad4080_adc_b
ad_ip_parameter axi_ad4080_adc_b CONFIG.IO_DELAY_GROUP adc_if_delay_group2

# dma for rx data

ad_ip_instance axi_dmac axi_ad4880_dma
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad4880_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad4880_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad4880_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad4880_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# connect interface to axi_ad4080_adc_a

ad_connect adca_dco_p                axi_ad4080_adc_a/dclk_in_p
ad_connect adca_dco_n                axi_ad4080_adc_a/dclk_in_n
ad_connect adca_da_p                 axi_ad4080_adc_a/data_a_in_p
ad_connect adca_da_n                 axi_ad4080_adc_a/data_a_in_n
ad_connect adca_db_p                 axi_ad4080_adc_a/data_b_in_p
ad_connect adca_db_n                 axi_ad4080_adc_a/data_b_in_n
ad_connect adca_sync_n               axi_ad4080_adc_a/sync_n
ad_connect adca_cnv_in_p             axi_ad4080_adc_a/cnv_in_p
ad_connect adca_cnv_in_n             axi_ad4080_adc_a/cnv_in_n
ad_connect adca_filter_data_ready_n  axi_ad4080_adc_a/filter_data_ready_n
ad_connect $sys_iodelay_clk          axi_ad4080_adc_a/delay_clk

# connect interface to axi_ad4080_adc_b

ad_connect adcb_dco_p                axi_ad4080_adc_b/dclk_in_p
ad_connect adcb_dco_n                axi_ad4080_adc_b/dclk_in_n
ad_connect adcb_da_p                 axi_ad4080_adc_b/data_a_in_p
ad_connect adcb_da_n                 axi_ad4080_adc_b/data_a_in_n
ad_connect adcb_db_p                 axi_ad4080_adc_b/data_b_in_p
ad_connect adcb_db_n                 axi_ad4080_adc_b/data_b_in_n
ad_connect adcb_sync_n               axi_ad4080_adc_b/sync_n
ad_connect adcb_cnv_in_p             axi_ad4080_adc_b/cnv_in_p
ad_connect adcb_cnv_in_n             axi_ad4080_adc_b/cnv_in_n
ad_connect adcb_filter_data_ready_n  axi_ad4080_adc_b/filter_data_ready_n
ad_connect $sys_iodelay_clk          axi_ad4080_adc_b/delay_clk

ad_ip_instance util_cpack2 util_ad4880_adc_pack { \
  NUM_OF_CHANNELS 2 \
  SAMPLE_DATA_WIDTH 32 \
}

# connect datapath

ad_connect axi_ad4080_adc_a/adc_clk    util_ad4880_adc_pack/clk
ad_connect axi_ad4080_adc_a/adc_rst    util_ad4880_adc_pack/reset
ad_connect axi_ad4080_adc_a/adc_valid  util_ad4880_adc_pack/fifo_wr_en
ad_connect axi_ad4080_adc_a/adc_data   util_ad4880_adc_pack/fifo_wr_data_0
ad_connect axi_ad4080_adc_b/adc_data   util_ad4880_adc_pack/fifo_wr_data_1
ad_connect axi_ad4080_adc_a/adc_enable util_ad4880_adc_pack/enable_0
ad_connect axi_ad4080_adc_b/adc_enable util_ad4880_adc_pack/enable_1
ad_connect axi_ad4080_adc_a/adc_dovf   util_ad4880_adc_pack/fifo_wr_overflow
ad_connect axi_ad4080_adc_b/adc_dovf   util_ad4880_adc_pack/fifo_wr_overflow

ad_connect util_ad4880_adc_pack/packed_fifo_wr   axi_ad4880_dma/fifo_wr
ad_connect util_ad4880_adc_pack/packed_sync      axi_ad4880_dma/sync

# system runs on phy's received clock

ad_connect axi_ad4080_adc_a/adc_clk axi_ad4880_dma/fifo_wr_clk

ad_connect $sys_cpu_resetn axi_ad4880_dma/m_dest_axi_aresetn

ad_cpu_interconnect 0x44A00000 axi_ad4080_adc_a
ad_cpu_interconnect 0x44A10000 axi_ad4080_adc_b
ad_cpu_interconnect 0x44A30000 axi_ad4880_dma
ad_cpu_interconnect 0x44a70000 ad4080_b_spi
ad_cpu_interconnect 0x44A80000 ad488x_clock_monitor

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad4880_dma/m_dest_axi

ad_cpu_interrupt ps-13 mb-12 axi_ad4880_dma/irq
ad_cpu_interrupt ps-10 mb-9  ad4080_b_spi/ip2intc_irpt
