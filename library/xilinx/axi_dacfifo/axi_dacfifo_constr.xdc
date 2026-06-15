###############################################################################
## Copyright (C) 2016-2023, 2026 Analog Devices, Inc. All rights reserved.
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

set_property ASYNC_REG TRUE \
  [get_cells -hier *dma_mem_*_m*] \
  [get_cells -hier *axi_xfer_*_m*] \
  [get_cells -hier *axi_mem_*_m*] \
  [get_cells -hier *axi_dma_*_m*] \
  [get_cells -hier *dac_mem_*_m*] \
  [get_cells -hier *dac_xfer_*_m*] \
  [get_cells -hier *dac_last_*_m*] \
  [get_cells -hier *dac_bypass_m*]

# AXI clk to DMA clk
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_raddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dma_mem_raddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_last_read_toggle* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dma_mem_last_read_toggle_m_* && IS_SEQUENTIAL}]

# DAC clk to DMA clk
set_false_path -from [get_cells  -hier -filter {name =~ */dac_mem_raddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dma_mem_raddr_m1_* && IS_SEQUENTIAL}]
set_false_path -to   [get_cells  -hier -filter {name =~ */dma_rst_m1_reg && IS_SEQUENTIAL}]


# DMA clk to AXI clk
set_false_path -from [get_cells  -hier -filter {name =~ */dma_last_beats* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */axi_dma_last_beats_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */dma_mem_waddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */axi_mem_waddr_m1* && IS_SEQUENTIAL}]
#ignore timing only on the data, the synchronous reset of the FF is connected to the same clock domain
set_false_path -through [get_pins  -hier -filter {name =~ */axi_xfer_req_m_reg[0]/D}]

# DAC clk to AXI clk
set_false_path -from [get_cells  -hier -filter {name =~ */dac_mem_raddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */axi_mem_raddr_m1* && IS_SEQUENTIAL}]

# DMA clk to DAC clk
set_false_path -from [get_cells  -hier -filter {name =~ */dma_mem_waddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_mem_waddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */dma_last_beats* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_last_beats_m* && IS_SEQUENTIAL}]
#ignore timing only on the data, the synchronous reset of the FF is connected to the same clock domain
set_false_path -through [get_pins  -hier -filter {name =~ */dac_xfer_out_m1_reg*/D}]

# AXI clk to DAC clk
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_laddr* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_mem_laddr* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_laddr_toggle* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_mem_laddr_toggle_m* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hier -filter {name =~ */axi_mem_waddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hier -filter {name =~ */dac_mem_waddr_m1* && IS_SEQUENTIAL}]
#ignore timing only on the data, the synchronous reset of the FF is connected to the same clock domain
set_false_path -through [get_pins  -hier -filter {name =~ */dac_xfer_req_m_reg[0]/D}]

