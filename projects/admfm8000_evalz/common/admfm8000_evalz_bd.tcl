###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set ADC_N_BITS $ad_project_params(ADC_N_BITS)
if {$ADC_N_BITS <=16} {
   set SAMPLE_DATA_WIDTH 16
   set DMA_DATA_WIDTH_SRC 32
} else {
   set SAMPLE_DATA_WIDTH 32
   set DMA_DATA_WIDTH_SRC 64
}

create_bd_port -dir I dds_sync_clk
create_bd_port -dir O dds_drctrl
create_bd_port -dir O dds_drhold
create_bd_port -dir I dds_drover
create_bd_port -dir O -from 2 -to 0 dds_profile
create_bd_port -dir I dds_ram_swp_ovr
create_bd_port -dir I dds_pdclk
create_bd_port -dir O -from 15 -to 0 db_o
create_bd_port -dir O -from 1 -to 0 f_o
create_bd_port -dir O dds_txenable

# AD9910 control + parallel-data

ad_ip_instance axi_ad9910 axi_ad9910_0
ad_ip_parameter axi_ad9910_0 CONFIG.DELAY_REFCLK_FREQ 200
ad_ip_parameter axi_ad9910_0 CONFIG.IODELAY_ENABLE 0
ad_ip_parameter axi_ad9910_0 CONFIG.ID 0

# ad4880 interface

create_bd_port -dir I adca_dco_p
create_bd_port -dir I adca_dco_n
create_bd_port -dir I adca_da_p
create_bd_port -dir I adca_da_n
create_bd_port -dir I adca_sync_n
create_bd_port -dir I adca_filter_data_ready_n

create_bd_port -dir I adcb_dco_p
create_bd_port -dir I adcb_dco_n
create_bd_port -dir I adcb_da_p
create_bd_port -dir I adcb_da_n
create_bd_port -dir I adcb_sync_n
create_bd_port -dir I adcb_filter_data_ready_n

create_bd_port -dir O ad4080_a_spi_csn_o
create_bd_port -dir I ad4080_a_spi_csn_i
create_bd_port -dir I ad4080_a_spi_clk_i
create_bd_port -dir O ad4080_a_spi_clk_o
create_bd_port -dir I ad4080_a_spi_sdo_i
create_bd_port -dir O ad4080_a_spi_sdo_o
create_bd_port -dir I ad4080_a_spi_sdi_i

create_bd_port -dir O ad4080_b_spi_csn_o
create_bd_port -dir I ad4080_b_spi_csn_i
create_bd_port -dir I ad4080_b_spi_clk_i
create_bd_port -dir O ad4080_b_spi_clk_o
create_bd_port -dir I ad4080_b_spi_sdo_i
create_bd_port -dir O ad4080_b_spi_sdo_o
create_bd_port -dir I ad4080_b_spi_sdi_i

# DMA
ad_ip_instance axi_dmac axi_ad9910_dma
ad_ip_parameter axi_ad9910_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9910_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9910_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9910_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9910_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9910_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9910_dma CONFIG.ASYNC_CLK_DEST_REQ 0
ad_ip_parameter axi_ad9910_dma CONFIG.ASYNC_CLK_SRC_DEST 0
ad_ip_parameter axi_ad9910_dma CONFIG.ASYNC_CLK_REQ_SRC 0
ad_ip_parameter axi_ad9910_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9910_dma CONFIG.DMA_SG_TRANSFER 1
ad_ip_parameter axi_ad9910_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9910_dma CONFIG.DMA_DATA_WIDTH_DEST 16
ad_ip_parameter axi_ad9910_dma CONFIG.DMA_DATA_WIDTH_SG 64
ad_ip_parameter axi_ad9910_dma CONFIG.CACHE_COHERENT $CACHE_COHERENCY

# dma for rx data

ad_ip_instance axi_dmac axi_ad4880_dma
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad4880_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad4880_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad4880_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad4880_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_DATA_WIDTH_SRC $DMA_DATA_WIDTH_SRC
ad_ip_parameter axi_ad4880_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# Core clock/reset connections
ad_connect $sys_iodelay_clk axi_ad9910_0/delay_clk

ad_connect sys_cpu_clk axi_ad9910_0/s_axi_aclk
ad_connect sys_cpu_resetn axi_ad9910_0/s_axi_aresetn
ad_connect sys_cpu_clk axi_ad9910_0/s_axis_aclk
ad_connect sys_cpu_resetn axi_ad9910_0/s_axis_aresetn

ad_connect sys_cpu_clk axi_ad9910_dma/s_axi_aclk
ad_connect sys_cpu_resetn axi_ad9910_dma/s_axi_aresetn
ad_connect sys_cpu_clk axi_ad9910_dma/m_src_axi_aclk
ad_connect sys_cpu_resetn axi_ad9910_dma/m_src_axi_aresetn
ad_connect sys_cpu_clk axi_ad9910_dma/m_sg_axi_aclk
ad_connect sys_cpu_resetn axi_ad9910_dma/m_sg_axi_aresetn
ad_connect sys_cpu_clk axi_ad9910_dma/m_axis_aclk

ad_connect $sys_cpu_resetn axi_ad4880_dma/m_dest_axi_aresetn

# Device-side connections
ad_connect dds_sync_clk axi_ad9910_0/sync_clk
ad_connect dds_pdclk axi_ad9910_0/pd_clk_in
ad_connect dds_drover axi_ad9910_0/drover
ad_connect dds_ram_swp_ovr axi_ad9910_0/ram_swp_ovr

ad_connect axi_ad9910_0/drctl dds_drctrl
ad_connect axi_ad9910_0/drhold dds_drhold
ad_connect axi_ad9910_0/tx_enable dds_txenable

ad_connect axi_ad9910_0/db_o db_o
ad_connect axi_ad9910_0/f_o f_o

ad_connect axi_ad9910_0/profile dds_profile

ad_connect axi_ad9910_dma/m_axis axi_ad9910_0/s_axis

# ad4080 AXI_SPI

ad_ip_instance axi_quad_spi ad4080_a_spi
ad_ip_parameter ad4080_a_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter ad4080_a_spi CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter ad4080_a_spi CONFIG.C_SCK_RATIO 8

ad_connect ad4080_a_spi_csn_i ad4080_a_spi/ss_i
ad_connect ad4080_a_spi_csn_o ad4080_a_spi/ss_o
ad_connect ad4080_a_spi_clk_i ad4080_a_spi/sck_i
ad_connect ad4080_a_spi_clk_o ad4080_a_spi/sck_o
ad_connect ad4080_a_spi_sdo_o ad4080_a_spi/io0_o
ad_connect ad4080_a_spi_sdi_i ad4080_a_spi/io1_i

ad_connect $sys_cpu_clk ad4080_a_spi/ext_spi_clk

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

# axi_ad4080_adc_a
ad_ip_instance axi_ad408x axi_ad4080_adc_a
ad_ip_parameter axi_ad4080_adc_a CONFIG.ADC_N_BITS $ADC_N_BITS
ad_ip_parameter axi_ad4080_adc_a CONFIG.NUM_LANES 1

# axi_ad4080_adc_b
ad_ip_instance axi_ad408x axi_ad4080_adc_b
ad_ip_parameter axi_ad4080_adc_b CONFIG.IO_DELAY_GROUP adc_if_delay_group2
ad_ip_parameter axi_ad4080_adc_b CONFIG.ADC_N_BITS $ADC_N_BITS
ad_ip_parameter axi_ad4080_adc_b CONFIG.NUM_LANES 1

# connect interface to axi_ad4080_adc_a

ad_connect adca_dco_p                axi_ad4080_adc_a/dclk_in_p
ad_connect adca_dco_n                axi_ad4080_adc_a/dclk_in_n
ad_connect adca_da_p                 axi_ad4080_adc_a/data_a_in_p
ad_connect adca_da_n                 axi_ad4080_adc_a/data_a_in_n
ad_connect adca_sync_n               axi_ad4080_adc_a/sync_n
ad_connect adca_filter_data_ready_n  axi_ad4080_adc_a/filter_data_ready_n
ad_connect $sys_iodelay_clk          axi_ad4080_adc_a/delay_clk

# connect interface to axi_ad4080_adc_b

ad_connect adcb_dco_p                axi_ad4080_adc_b/dclk_in_p
ad_connect adcb_dco_n                axi_ad4080_adc_b/dclk_in_n
ad_connect adcb_da_p                 axi_ad4080_adc_b/data_a_in_p
ad_connect adcb_da_n                 axi_ad4080_adc_b/data_a_in_n
ad_connect adcb_sync_n               axi_ad4080_adc_b/sync_n
ad_connect adcb_filter_data_ready_n  axi_ad4080_adc_b/filter_data_ready_n
ad_connect $sys_iodelay_clk          axi_ad4080_adc_b/delay_clk

ad_ip_instance util_cpack2 util_ad4880_adc_pack
ad_ip_parameter util_ad4880_adc_pack CONFIG.NUM_OF_CHANNELS 2
ad_ip_parameter util_ad4880_adc_pack CONFIG.SAMPLE_DATA_WIDTH $SAMPLE_DATA_WIDTH

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

#ad4880 system runs on phy's received clock
ad_connect axi_ad4080_adc_a/adc_clk axi_ad4880_dma/fifo_wr_clk

# interconnects
ad_cpu_interconnect 0x44A00000 axi_ad9910_0
ad_cpu_interconnect 0x44A10000 axi_ad9910_dma
ad_cpu_interconnect 0x44A20000 axi_ad4080_adc_a
ad_cpu_interconnect 0x44A30000 axi_ad4080_adc_b
ad_cpu_interconnect 0x44A40000 axi_ad4880_dma
ad_cpu_interconnect 0x44A60000 ad4080_a_spi
ad_cpu_interconnect 0x44A70000 ad4080_b_spi

ad_mem_hp0_interconnect sys_cpu_clk axi_ad9910_dma/m_src_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_ad9910_dma/m_sg_axi
ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad4880_dma/m_dest_axi

# interrupts
ad_cpu_interrupt ps-0 mb-0 axi_ad9910_dma/irq
ad_cpu_interrupt ps-1 mb-1 axi_ad9910_0/irq
ad_cpu_interrupt ps-2 mb-2 axi_ad4880_dma/irq
ad_cpu_interrupt ps-3 mb-3  ad4080_a_spi/ip2intc_irpt
ad_cpu_interrupt ps-4 mb-4  ad4080_b_spi/ip2intc_irpt
