###############################################################################
## Copyright (C) 2019-2026 Analog Devices, Inc. All rights reserved.
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

create_bd_port -dir O adc_clk
create_bd_port -dir I adc_data

# ADC's DMA

ad_ip_instance axi_dmac axi_ad7405_dma
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7405_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7405_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad7405_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad7405_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_ad7405_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# MCLK generation 40 MHz

ad_ip_instance axi_clkgen axi_adc_clkgen
ad_ip_parameter axi_adc_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_adc_clkgen CONFIG.VCO_MUL 10
ad_ip_parameter axi_adc_clkgen CONFIG.CLK0_DIV 25

ad_ip_instance axi_ad7405 axi_ad7405

ad_connect adc_clk axi_adc_clkgen/clk_0
ad_connect sys_cpu_clk axi_adc_clkgen/clk
ad_connect axi_ad7405/clk_in axi_adc_clkgen/clk_0
ad_connect axi_ad7405_dma/fifo_wr_clk axi_adc_clkgen/clk_0

ad_connect adc_data axi_ad7405/adc_data_in
ad_connect axi_ad7405/adc_data_out axi_ad7405_dma/fifo_wr_din
ad_connect axi_ad7405/adc_data_en axi_ad7405_dma/fifo_wr_en

# interconnect

ad_cpu_interconnect 0x44a00000 axi_ad7405
ad_cpu_interconnect 0x44a30000 axi_ad7405_dma
ad_cpu_interconnect 0x44a40000 axi_adc_clkgen

# memory interconnect

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad7405_dma/m_dest_axi

# interrupt

ad_cpu_interrupt "ps-13" "mb-13" axi_ad7405_dma/irq
