###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

# ad4880_clock_monitor

ad_ip_instance axi_clock_monitor ad4880_clock_monitor
ad_ip_parameter ad4880_clock_monitor CONFIG.NUM_OF_CLOCKS 2
ad_ip_parameter ad4880_clock_monitor CONFIG.DIV_RATE 4

ad_connect fpga_a_ref_clk  ad4880_clock_monitor/clock_0
ad_connect fpga_b_ref_clk  ad4880_clock_monitor/clock_1

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

### axi_ad408x

# axi_ad4080_adc_a
ad_ip_instance axi_ad408x axi_ad4080_adc_a
ad_ip_parameter axi_ad4080_adc_a CONFIG.ADC_N_BITS $ADC_N_BITS

# axi_ad4080_adc_b
ad_ip_instance axi_ad408x axi_ad4080_adc_b
ad_ip_parameter axi_ad4080_adc_b CONFIG.IO_DELAY_GROUP adc_if_delay_group2
ad_ip_parameter axi_ad4080_adc_b CONFIG.ADC_N_BITS $ADC_N_BITS



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

ad_ip_instance util_cpack2 util_ad4880_adc_pack
ad_ip_parameter util_ad4880_adc_pack CONFIG.NUM_OF_CHANNELS 2
ad_ip_parameter util_ad4880_adc_pack CONFIG.SAMPLE_DATA_WIDTH $SAMPLE_DATA_WIDTH

# Channel B clock-domain crossing.
#
# ADC A and ADC B each recover their own data clock (adca_dco / adcb_dco).
# The packer and the DMA run entirely in the ADC A clock domain, so ADC B's
# parallel data has to be resynchronized from the adcb_dco domain into the
# adca_dco domain before it is packed. Wiring adc_b/adc_data straight into the
# packer samples a multi-bit bus across unrelated clocks and corrupts the
# low-order bits of channel B. An asynchronous FIFO performs the CDC: it is
# written on ADC B's clock/valid and read out one sample per ADC A valid, so
# the two channels stay sample-aligned.

ad_ip_instance util_vector_logic adc_a_resetn
ad_ip_parameter adc_a_resetn CONFIG.C_SIZE 1
ad_ip_parameter adc_a_resetn CONFIG.C_OPERATION {not}

ad_ip_instance util_vector_logic adc_b_resetn
ad_ip_parameter adc_b_resetn CONFIG.C_SIZE 1
ad_ip_parameter adc_b_resetn CONFIG.C_OPERATION {not}

ad_connect axi_ad4080_adc_a/adc_rst adc_a_resetn/Op1
ad_connect axi_ad4080_adc_b/adc_rst adc_b_resetn/Op1

ad_ip_instance util_axis_fifo adc_b_cdc_fifo
ad_ip_parameter adc_b_cdc_fifo CONFIG.DATA_WIDTH $SAMPLE_DATA_WIDTH
ad_ip_parameter adc_b_cdc_fifo CONFIG.ADDRESS_WIDTH 4
ad_ip_parameter adc_b_cdc_fifo CONFIG.ASYNC_CLK 1
ad_ip_parameter adc_b_cdc_fifo CONFIG.ALMOST_EMPTY_THRESHOLD 2
ad_ip_parameter adc_b_cdc_fifo CONFIG.TLAST_EN 0
ad_ip_parameter adc_b_cdc_fifo CONFIG.TKEEP_EN 0

# write side: ADC B native domain (adcb_dco)
ad_connect axi_ad4080_adc_b/adc_clk   adc_b_cdc_fifo/s_axis_aclk
ad_connect adc_b_resetn/Res           adc_b_cdc_fifo/s_axis_aresetn
ad_connect axi_ad4080_adc_b/adc_valid adc_b_cdc_fifo/s_axis_valid
ad_connect axi_ad4080_adc_b/adc_data  adc_b_cdc_fifo/s_axis_data

# read side: ADC A / packer domain (adca_dco)
ad_connect axi_ad4080_adc_a/adc_clk   adc_b_cdc_fifo/m_axis_aclk
ad_connect adc_a_resetn/Res           adc_b_cdc_fifo/m_axis_aresetn

# Prime / underflow guard.
#
# Read the FIFO only once it holds more than ALMOST_EMPTY_THRESHOLD words.
# Both channels run at the same conversion rate, so once primed the occupancy
# stays constant: the read never races ahead of the write and channel B is
# never sampled while empty (no stale data), and the resulting inter-channel
# offset is a fixed, repeatable number of samples. The same gate drives the
# packer write-enable, so channel A and the channel-B read stay paired - both
# are held off together during the short startup priming window.

ad_ip_instance util_vector_logic adc_b_fifo_ready
ad_ip_parameter adc_b_fifo_ready CONFIG.C_SIZE 1
ad_ip_parameter adc_b_fifo_ready CONFIG.C_OPERATION {not}
ad_connect adc_b_cdc_fifo/m_axis_almost_empty adc_b_fifo_ready/Op1

ad_ip_instance util_vector_logic adc_pack_wr_en
ad_ip_parameter adc_pack_wr_en CONFIG.C_SIZE 1
ad_ip_parameter adc_pack_wr_en CONFIG.C_OPERATION {and}
ad_connect axi_ad4080_adc_a/adc_valid adc_pack_wr_en/Op1
ad_connect adc_b_fifo_ready/Res       adc_pack_wr_en/Op2

ad_connect adc_pack_wr_en/Res adc_b_cdc_fifo/m_axis_ready


# connect datapath

ad_connect axi_ad4080_adc_a/adc_clk    util_ad4880_adc_pack/clk
ad_connect axi_ad4080_adc_a/adc_rst    util_ad4880_adc_pack/reset
ad_connect adc_pack_wr_en/Res          util_ad4880_adc_pack/fifo_wr_en
ad_connect axi_ad4080_adc_a/adc_data   util_ad4880_adc_pack/fifo_wr_data_0
ad_connect adc_b_cdc_fifo/m_axis_data  util_ad4880_adc_pack/fifo_wr_data_1
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
ad_cpu_interconnect 0x44A80000 ad4880_clock_monitor

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad4880_dma/m_dest_axi

ad_cpu_interrupt ps-13 mb-12 axi_ad4880_dma/irq
ad_cpu_interrupt ps-10 mb-9  ad4080_b_spi/ip2intc_irpt
