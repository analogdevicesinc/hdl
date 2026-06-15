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

# ad77684
add_instance axi_ad77684_adc axi_ad7768
set_instance_parameter_value axi_ad77684_adc {NUM_CHANNELS} {4}
add_interface if_clk_in_bd                         conduit end
add_interface if_ready_in_bd                       conduit end
add_interface if_data_in_bd                        conduit end

set_interface_property if_clk_in_bd                EXPORT_OF axi_ad77684_adc.if_clk_in
set_interface_property if_ready_in_bd              EXPORT_OF axi_ad77684_adc.if_ready_in
set_interface_property if_data_in_bd               EXPORT_OF axi_ad77684_adc.if_data_in

# adc-path channel pack

add_instance cn0579_adc_pack util_cpack2 
set_instance_parameter_value cn0579_adc_pack {NUM_OF_CHANNELS} {4}
set_instance_parameter_value cn0579_adc_pack {SAMPLE_DATA_WIDTH} {32}

add_connection axi_ad77684_adc.if_adc_clk   cn0579_adc_pack.clk
add_connection axi_ad77684_adc.if_adc_reset cn0579_adc_pack.reset
add_connection axi_ad77684_adc.if_adc_dovf  cn0579_adc_pack.if_fifo_wr_overflow
add_connection axi_ad77684_adc.adc_ch_0     cn0579_adc_pack.adc_ch_0    
add_connection axi_ad77684_adc.adc_ch_1     cn0579_adc_pack.adc_ch_1    
add_connection axi_ad77684_adc.adc_ch_2     cn0579_adc_pack.adc_ch_2    
add_connection axi_ad77684_adc.adc_ch_3     cn0579_adc_pack.adc_ch_3    

# adc(cn0579-dma)

add_instance cn0579_dma axi_dmac
set_instance_parameter_value cn0579_dma {ID} {0}
set_instance_parameter_value cn0579_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value cn0579_dma {DMA_DATA_WIDTH_DEST} {64}
set_instance_parameter_value cn0579_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value cn0579_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value cn0579_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value cn0579_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value cn0579_dma {CYCLIC} {0}
set_instance_parameter_value cn0579_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value cn0579_dma {DMA_TYPE_SRC} {2}

add_connection axi_ad77684_adc.if_adc_clk                 cn0579_dma.if_fifo_wr_clk
add_connection cn0579_adc_pack.if_packed_fifo_wr_en       cn0579_dma.if_fifo_wr_en
add_connection cn0579_adc_pack.if_packed_sync             cn0579_dma.if_sync
add_connection cn0579_adc_pack.if_packed_fifo_wr_data     cn0579_dma.if_fifo_wr_din
add_connection cn0579_adc_pack.if_packed_fifo_wr_overflow cn0579_dma.if_fifo_wr_overflow

#clocks

add_connection sys_clk.clk     cn0579_dma.s_axi_clock
add_connection sys_clk.clk     axi_ad77684_adc.s_axi_clock
add_connection sys_dma_clk.clk cn0579_dma.m_dest_axi_clock

#resets

add_connection sys_clk.clk_reset     axi_ad77684_adc.s_axi_reset   
add_connection sys_clk.clk_reset     cn0579_dma.s_axi_reset
add_connection sys_dma_clk.clk_reset cn0579_dma.m_dest_axi_reset

# interrupts

ad_cpu_interrupt 5 cn0579_dma.interrupt_sender

# cpu interconnects

ad_cpu_interconnect 0x00028000  cn0579_dma.s_axi
ad_cpu_interconnect 0x00030000  axi_ad77684_adc.s_axi

# mem interconnects

ad_dma_interconnect cn0579_dma.m_dest_axi 
