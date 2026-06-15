###############################################################################
## Copyright (C) 2023-2024, 2026 Analog Devices, Inc. All rights reserved.
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

# ad7768-4 interface

create_bd_port -dir I clk_in
create_bd_port -dir I ready_in
create_bd_port -dir I -from 7 -to 0 data_in

# adc(cn0579-dma)

ad_ip_instance axi_dmac cn0579_dma
ad_ip_parameter cn0579_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter cn0579_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter cn0579_dma CONFIG.CYCLIC 0
ad_ip_parameter cn0579_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter cn0579_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter cn0579_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter cn0579_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter cn0579_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter cn0579_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# axi_ad77684

ad_ip_instance axi_ad7768 axi_ad77684_adc
ad_ip_parameter axi_ad77684_adc CONFIG.NUM_CHANNELS 4

# adc-path channel pack

ad_ip_instance util_cpack2 cn0579_adc_pack
ad_ip_parameter cn0579_adc_pack CONFIG.NUM_OF_CHANNELS 4
ad_ip_parameter cn0579_adc_pack CONFIG.SAMPLE_DATA_WIDTH 32

# connections

for {set i 0} {$i < 4} {incr i} {
  ad_connect axi_ad77684_adc/adc_enable_$i  cn0579_adc_pack/enable_$i
  ad_connect axi_ad77684_adc/adc_data_$i    cn0579_adc_pack/fifo_wr_data_$i
}

ad_connect axi_ad77684_adc/s_axi_aclk          sys_ps7/FCLK_CLK0 
ad_connect axi_ad77684_adc/clk_in              clk_in
ad_connect axi_ad77684_adc/ready_in            ready_in
ad_connect axi_ad77684_adc/data_in             data_in
ad_connect axi_ad77684_adc/adc_valid           cn0579_adc_pack/fifo_wr_en
ad_connect axi_ad77684_adc/adc_clk             cn0579_adc_pack/clk
ad_connect axi_ad77684_adc/adc_reset           cn0579_adc_pack/reset
ad_connect axi_ad77684_adc/adc_dovf            cn0579_adc_pack/fifo_wr_overflow 

ad_connect  cn0579_dma/m_dest_axi_aresetn       sys_cpu_resetn                   
ad_connect  cn0579_dma/fifo_wr_clk              axi_ad77684_adc/adc_clk                
ad_connect  cn0579_dma/fifo_wr                  cn0579_adc_pack/packed_fifo_wr   
ad_connect  cn0579_dma/sync                     cn0579_adc_pack/packed_sync

# interrupts

ad_cpu_interrupt "ps-12" "mb-12"  cn0579_dma/irq

# cpu / memory interconnects

ad_cpu_interconnect 0x44a00000 axi_ad77684_adc 
ad_cpu_interconnect 0x44a30000 cn0579_dma

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk cn0579_dma/m_dest_axi
