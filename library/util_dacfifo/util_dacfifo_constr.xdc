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

set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {name =~ *dac_waddr_m*}] \
  [get_cells -hierarchical -filter {name =~ *dac_lastaddr_m*}] \
  [get_cells -hierarchical -filter {name =~ *dac_xfer_out_*}] \
  [get_cells -hierarchical -filter {name =~ *dma_bypass*}] \
  [get_cells -hierarchical -filter {name =~ *dac_bypass*}] \
  [get_cells -hierarchical -filter {name =~ *dac_xfer_req_m*}]

set_false_path -from [get_cells -hierarchical -filter {name =~ *dma_waddr_g* && IS_SEQUENTIAL}] \
               -to [get_cells -hierarchical -filter {name =~ *dac_waddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hierarchical -filter {name =~ *dma_lastaddr_g* && IS_SEQUENTIAL}] \
               -to [get_cells -hierarchical -filter {name =~ *dac_lastaddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hierarchical -filter {name =~ *dma_xfer_out_fifo* && IS_SEQUENTIAL}] \
               -to [get_cells -hierarchical -filter {name =~ *dac_xfer_out_fifo_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hierarchical -filter {name =~ *dac_bypass_m1* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hierarchical -filter {name =~ *dma_bypass_m1* && IS_SEQUENTIAL}]

# util_dacfifo_bypass CDC false-paths

set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {name =~ *dac_mem_*_m*}] \
  [get_cells -hierarchical -filter {name =~ *dma_mem_*_m*}] \
  [get_cells -hierarchical -filter {name =~ *dma_rst_m1*}] \

set_false_path -from [get_cells  -hierarchical -filter {name =~ */dma_mem_waddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hierarchical -filter {name =~ */dac_mem_waddr_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hierarchical -filter {name =~ */dac_mem_raddr_g* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hierarchical -filter {name =~ */dma_mem_raddr_m1* && IS_SEQUENTIAL}]
set_false_path -to   [get_cells  -hierarchical -filter {name =~ */dma_rst_m1_reg && IS_SEQUENTIAL}]
set_false_path -to   [get_cells  -hierarchical -filter {name =~ */dac_xfer_req_m1_reg && IS_SEQUENTIAL}]
set_false_path -from [get_cells  -hierarchical -filter {name =~ */dma_xfer_req* && IS_SEQUENTIAL}] \
               -to   [get_cells  -hierarchical -filter {name =~ */dac_mem_waddr_m1* && IS_SEQUENTIAL}]

