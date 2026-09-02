###############################################################################
## Copyright (C) 2022-2024, 2026 Analog Devices, Inc. All rights reserved.
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

#adaq8092
create_bd_port -dir I adc_clk_in_p
create_bd_port -dir I adc_clk_in_n

#interface port create 

create_bd_port -dir I adc_data_or_p
create_bd_port -dir I adc_data_or_n
create_bd_port -dir I -from 6 -to 0 adc_data_in1_p
create_bd_port -dir I -from 6 -to 0 adc_data_in1_n
create_bd_port -dir I -from 6 -to 0 adc_data_in2_p
create_bd_port -dir I -from 6 -to 0 adc_data_in2_n
 
 # adc peripheral

ad_ip_instance util_cpack2 axi_adaq8092_cpack [list \
                                             NUM_OF_CHANNELS 2 \
                                             SAMPLES_PER_CHANNEL 1 \
                                             SAMPLE_DATA_WIDTH 16 \
]


ad_ip_instance axi_dmac axi_adaq8092_dma
ad_ip_parameter axi_adaq8092_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adaq8092_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adaq8092_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adaq8092_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adaq8092_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adaq8092_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adaq8092_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adaq8092_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_adaq8092_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_adaq8092_dma CONFIG.AXI_SLICE_DEST 1

 # connections

 #adaq8092_core

ad_ip_instance axi_adaq8092 axi_adaq8092
ad_ip_parameter axi_adaq8092  CONFIG.POLARITY_MASK 28'hfffffff
ad_ip_parameter axi_adaq8092  CONFIG.OUTPUT_MODE 0

ad_connect    adc_clk_in_p         axi_adaq8092/adc_clk_in_p
ad_connect    adc_clk_in_n         axi_adaq8092/adc_clk_in_n 
ad_connect    adc_data_in1_p       axi_adaq8092/lvds_adc_data_in1_p
ad_connect    adc_data_in1_n       axi_adaq8092/lvds_adc_data_in1_n
ad_connect    adc_data_in2_p       axi_adaq8092/lvds_adc_data_in2_p
ad_connect    adc_data_in2_n       axi_adaq8092/lvds_adc_data_in2_n
ad_connect    adc_data_or_p        axi_adaq8092/lvds_adc_or_in_p
ad_connect    adc_data_or_n        axi_adaq8092/lvds_adc_or_in_n 
ad_connect    adaq8092_clk         axi_adaq8092/adc_clk
ad_connect    $sys_iodelay_clk     axi_adaq8092/delay_clk

#adaq8092_cpack

ad_connect  axi_adaq8092/adc_enable_1        axi_adaq8092_cpack/enable_0
ad_connect  axi_adaq8092/adc_data_channel1   axi_adaq8092_cpack/fifo_wr_data_0
ad_connect  axi_adaq8092/adc_enable_2        axi_adaq8092_cpack/enable_1
ad_connect  axi_adaq8092/adc_data_channel2   axi_adaq8092_cpack/fifo_wr_data_1
ad_connect  axi_adaq8092_dma/fifo_wr         axi_adaq8092_cpack/packed_fifo_wr
ad_connect  axi_adaq8092_dma/sync            axi_adaq8092_cpack/packed_sync
ad_connect  axi_adaq8092/adc_valid           axi_adaq8092_cpack/fifo_wr_en
ad_connect  axi_adaq8092/adc_dovf            axi_adaq8092_cpack/fifo_wr_overflow
ad_connect  axi_adaq8092/adc_clk             axi_adaq8092_cpack/clk
ad_connect  axi_adaq8092/adc_clk             axi_adaq8092_dma/fifo_wr_clk
ad_connect axi_adaq8092/adc_rst              axi_adaq8092_cpack/reset

# address mapping

ad_cpu_interconnect 0x44A00000 axi_adaq8092
ad_cpu_interconnect 0x44A30000 axi_adaq8092_dma

# interconnect (adc)

ad_mem_hp2_interconnect $sys_cpu_clk      sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk      axi_adaq8092_dma/m_dest_axi
ad_connect              $sys_cpu_resetn   axi_adaq8092_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_adaq8092_dma/irq
