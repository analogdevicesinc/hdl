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

# ad4880_clock_monitor

ad_ip_instance axi_clock_monitor ad4880_clock_monitor
ad_ip_parameter ad4880_clock_monitor CONFIG.NUM_OF_CLOCKS 2
ad_ip_parameter ad4880_clock_monitor CONFIG.DIV_RATE 4

ad_connect fpga_a_ref_clk  ad4880_clock_monitor/clock_0
ad_connect fpga_b_ref_clk  ad4880_clock_monitor/clock_1

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

# Cross-channel alignment: absorb the phase difference between adca_dco and
# adcb_dco (same source chip, same nominal freq, unknown FPGA phase) with a
# pair of async FIFOs and a paired read. Both channels reach the cpack in
# the same clock cycle on adc_a's clock, giving cycle-accurate alignment.
# NOTE: this requires axi_ad408x/adc_clk to be on a global BUFG (BUFR output
# is clock-region-local and cannot bridge Bank 34 <-> Bank 35 on Zynq-7020).
# The BUFG cascade is instantiated inside ad408x_phy.v (7-series branch).
ad_ip_instance util_axis_fifo cha_align_fifo
ad_ip_parameter cha_align_fifo CONFIG.ASYNC_CLK 1
ad_ip_parameter cha_align_fifo CONFIG.DATA_WIDTH $SAMPLE_DATA_WIDTH
ad_ip_parameter cha_align_fifo CONFIG.ADDRESS_WIDTH 4
ad_ip_parameter cha_align_fifo CONFIG.TLAST_EN 0
ad_ip_parameter cha_align_fifo CONFIG.TKEEP_EN 0
ad_ip_parameter cha_align_fifo CONFIG.M_AXIS_REGISTERED 1

ad_ip_instance util_axis_fifo chb_align_fifo
ad_ip_parameter chb_align_fifo CONFIG.ASYNC_CLK 1
ad_ip_parameter chb_align_fifo CONFIG.DATA_WIDTH $SAMPLE_DATA_WIDTH
ad_ip_parameter chb_align_fifo CONFIG.ADDRESS_WIDTH 4
ad_ip_parameter chb_align_fifo CONFIG.TLAST_EN 0
ad_ip_parameter chb_align_fifo CONFIG.TKEEP_EN 0
ad_ip_parameter chb_align_fifo CONFIG.M_AXIS_REGISTERED 1

# Pop from both FIFOs only when both have data -> paired sample delivery.
# Per-channel valid is already gated by sync_status inside ad408x_phy so
# pre-lock samples never enter the FIFO -> paired-pop stays aligned by
# construction after both channels lock.
ad_ip_instance util_vector_logic align_both_valid
ad_ip_parameter align_both_valid CONFIG.C_OPERATION and
ad_ip_parameter align_both_valid CONFIG.C_SIZE 1


# connect datapath

# ADC-A write side: native adc_clk -> fifo write (adc_valid is already
# gated by sync_status inside the PHY, so no pre-lock garbage enters).
ad_connect axi_ad4080_adc_a/adc_clk    cha_align_fifo/s_axis_aclk
ad_connect sys_cpu_resetn              cha_align_fifo/s_axis_aresetn
ad_connect axi_ad4080_adc_a/adc_valid  cha_align_fifo/s_axis_valid
ad_connect axi_ad4080_adc_a/adc_data   cha_align_fifo/s_axis_data

# ADC-B write side: native adc_clk -> fifo write
ad_connect axi_ad4080_adc_b/adc_clk    chb_align_fifo/s_axis_aclk
ad_connect sys_cpu_resetn              chb_align_fifo/s_axis_aresetn
ad_connect axi_ad4080_adc_b/adc_valid  chb_align_fifo/s_axis_valid
ad_connect axi_ad4080_adc_b/adc_data   chb_align_fifo/s_axis_data

# Common read side: ADC-A's adc_clk drains both fifos
ad_connect axi_ad4080_adc_a/adc_clk    cha_align_fifo/m_axis_aclk
ad_connect sys_cpu_resetn              cha_align_fifo/m_axis_aresetn
ad_connect axi_ad4080_adc_a/adc_clk    chb_align_fifo/m_axis_aclk
ad_connect sys_cpu_resetn              chb_align_fifo/m_axis_aresetn

# both_valid = m_axis_valid_a & m_axis_valid_b : gates the paired pop
ad_connect cha_align_fifo/m_axis_valid align_both_valid/Op1
ad_connect chb_align_fifo/m_axis_valid align_both_valid/Op2
ad_connect align_both_valid/Res        cha_align_fifo/m_axis_ready
ad_connect align_both_valid/Res        chb_align_fifo/m_axis_ready

# Feed cpack: single common clock, paired data, common write enable
ad_connect axi_ad4080_adc_a/adc_clk    util_ad4880_adc_pack/clk
ad_connect axi_ad4080_adc_a/adc_rst    util_ad4880_adc_pack/reset
ad_connect align_both_valid/Res        util_ad4880_adc_pack/fifo_wr_en
ad_connect cha_align_fifo/m_axis_data  util_ad4880_adc_pack/fifo_wr_data_0
ad_connect chb_align_fifo/m_axis_data  util_ad4880_adc_pack/fifo_wr_data_1
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
ad_cpu_interconnect 0x44A80000 ad4880_clock_monitor

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad4880_dma/m_dest_axi

ad_cpu_interrupt ps-13 mb-12 axi_ad4880_dma/irq
