###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

set DAC_RESOLUTION $ad_project_params(DAC_RESOLUTION)

# bd ports

create_bd_port -dir I ad9740_clk
create_bd_port -dir O -from 13 -to 0 ad9740_data

# dma

ad_ip_instance axi_dmac ad9740_dma
ad_ip_parameter ad9740_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter ad9740_dma CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter ad9740_dma CONFIG.CYCLIC 1
ad_ip_parameter ad9740_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter ad9740_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad9740_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter ad9740_dma CONFIG.DMA_DATA_WIDTH_DEST 32

# ad9740

ad_ip_instance axi_ad9740 ad9740_dac
ad_ip_parameter ad9740_dac CONFIG.DAC_RESOLUTION $DAC_RESOLUTION
ad_ip_parameter ad9740_dac CONFIG.CLK_RATIO 2
ad_ip_parameter ad9740_dac CONFIG.DDS_CORDIC_DW 22
ad_ip_parameter ad9740_dac CONFIG.DDS_CORDIC_PHASE_DW 22

# clocks

ad_connect ad9740_clk ad9740_dac/dac_clk

# resets

ad_connect sys_rstgen/peripheral_aresetn ad9740_dma/m_src_axi_aresetn

# data path

ad_connect ad9740_dma/fifo_rd_dout ad9740_dac/dma_data
ad_connect ad9740_dma/fifo_rd_valid ad9740_dac/dma_valid
ad_connect ad9740_clk ad9740_dma/fifo_rd_clk
ad_connect ad9740_dac/dma_ready ad9740_dma/fifo_rd_en

ad_connect ad9740_dac/dac_data ad9740_data

# AXI address definitions

ad_cpu_interconnect 0x44a40000 ad9740_dma
ad_cpu_interconnect 0x44a70000 ad9740_dac

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" ad9740_dma/irq

# memory interconnects

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk ad9740_dma/m_src_axi
