###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

set NUM_LANES    $ad_project_params(NUM_LANES)
set ENABLE_20BIT $ad_project_params(ENABLE_20BIT)
set ENABLE_16BIT $ad_project_params(ENABLE_16BIT)
set ENABLE_14BIT $ad_project_params(ENABLE_14BIT)

# Bit depth enables and lane count are propagated to the PHY. The data bus width
# follows the same derivation as ad408x_phy: 32 bits for the 20 bit depth, and
# on two lanes for the 14 bit depth, 16 bits otherwise. On the 32 bit bus the
# 16 and 14 bit depths carry two samples per word in 16 bit slots, so the
# memory holds 16 bit samples in both cases.
set ADC_DATA_WIDTH [expr {($ENABLE_20BIT || ($ENABLE_14BIT && $NUM_LANES == 2)) ? 32 : 16}]
# util_sample_pack packs the channels. With the 20 bit depth next to a 16/14
# bit one a sample takes one or two 16 bit slots, set at run time; otherwise
# a slot is one whole sample, 32 bits for the 20 bit depth.
set SIZE_SWITCH [expr {$ENABLE_20BIT && ($ENABLE_16BIT || $ENABLE_14BIT)}]
set SLOT_WIDTH [expr {($ENABLE_20BIT && !$SIZE_SWITCH) ? 32 : 16}]
set DMA_DATA_WIDTH_SRC [expr {2 * $ADC_DATA_WIDTH}]
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
ad_ip_parameter axi_ad4080_adc_a CONFIG.NUM_LANES $NUM_LANES
ad_ip_parameter axi_ad4080_adc_a CONFIG.ENABLE_20BIT $ENABLE_20BIT
ad_ip_parameter axi_ad4080_adc_a CONFIG.ENABLE_16BIT $ENABLE_16BIT
ad_ip_parameter axi_ad4080_adc_a CONFIG.ENABLE_14BIT $ENABLE_14BIT

# axi_ad4080_adc_b
ad_ip_instance axi_ad408x axi_ad4080_adc_b
ad_ip_parameter axi_ad4080_adc_b CONFIG.IO_DELAY_GROUP adc_if_delay_group2
ad_ip_parameter axi_ad4080_adc_b CONFIG.NUM_LANES $NUM_LANES
ad_ip_parameter axi_ad4080_adc_b CONFIG.ENABLE_20BIT $ENABLE_20BIT
ad_ip_parameter axi_ad4080_adc_b CONFIG.ENABLE_16BIT $ENABLE_16BIT
ad_ip_parameter axi_ad4080_adc_b CONFIG.ENABLE_14BIT $ENABLE_14BIT



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
ad_connect adca_filter_data_ready_n  axi_ad4080_adc_a/filter_rdy_n
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
ad_connect adcb_filter_data_ready_n  axi_ad4080_adc_b/filter_rdy_n
ad_connect $sys_iodelay_clk          axi_ad4080_adc_b/delay_clk

# The join FIFO pairs the n-th words of the two channels, which run on their
# own DCOs. A 20 bit sample fills both 16 bit slots of its word, a 16/14 bit
# word holds two samples. Memory gets A B per 20 bit sample pair and
# A0 B0 A1 B1 per 16/14 bit word pair. The channel enables and the sample size
# are held during a transfer, overflow counts only during a transfer.

ad_ip_instance util_sample_pack util_ad4880_adc_pack
ad_ip_parameter util_ad4880_adc_pack CONFIG.NUM_CH 2
ad_ip_parameter util_ad4880_adc_pack CONFIG.SLOT_W $SLOT_WIDTH
ad_ip_parameter util_ad4880_adc_pack CONFIG.CH_SLOTS [expr $ADC_DATA_WIDTH / $SLOT_WIDTH]
ad_ip_parameter util_ad4880_adc_pack CONFIG.ENABLE_SAMPLE_SLOTS_SELECT $SIZE_SWITCH
ad_ip_parameter util_ad4880_adc_pack CONFIG.JOIN_FIFO_ENABLE 1
ad_ip_parameter util_ad4880_adc_pack CONFIG.XFER_REQ_ENABLE 1
ad_ip_parameter util_ad4880_adc_pack CONFIG.OVERFLOW_XFER_REQ 1
ad_ip_parameter util_ad4880_adc_pack CONFIG.CONFIG_XFER_HOLD 1

ad_connect adca_sync_n               util_ad4880_adc_pack/async_resetn
ad_connect axi_ad4080_adc_a/adc_clk  util_ad4880_adc_pack/clk
ad_connect axi_ad4080_adc_a/adc_rst  util_ad4880_adc_pack/reset

foreach {ch adc} {0 a 1 b} {
  ad_connect axi_ad4080_adc_$adc/adc_clk    util_ad4880_adc_pack/clk_$ch
  ad_connect axi_ad4080_adc_$adc/adc_rst    util_ad4880_adc_pack/reset_$ch
  ad_connect axi_ad4080_adc_$adc/adc_valid  util_ad4880_adc_pack/valid_$ch
  ad_connect axi_ad4080_adc_$adc/adc_data   util_ad4880_adc_pack/data_$ch
  ad_connect axi_ad4080_adc_$adc/adc_enable util_ad4880_adc_pack/enable_$ch
  ad_connect axi_ad4080_adc_$adc/adc_dovf   util_ad4880_adc_pack/overflow_$ch
}

if {$SIZE_SWITCH} {
  ad_connect axi_ad4080_adc_a/adc_sample_slots_select util_ad4880_adc_pack/sample_slots_select
}

ad_connect util_ad4880_adc_pack/packed_fifo_wr axi_ad4880_dma/fifo_wr
ad_connect util_ad4880_adc_pack/packed_sync    axi_ad4880_dma/sync

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
