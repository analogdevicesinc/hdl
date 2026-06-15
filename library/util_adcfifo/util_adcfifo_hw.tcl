###############################################################################
## Copyright (C) 2015-2023, 2026 Analog Devices, Inc. All rights reserved.
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

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create util_adcfifo {UTIL ADC FIFO IP core}
set_module_property ELABORATION_CALLBACK p_util_adcfifo

# files

ad_ip_files util_adcfifo [list\
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/ad_axis_inf_rx.v \
  $ad_hdl_dir/library/util_cdc/sync_gray.v \
  util_adcfifo.v \
  util_adcfifo_constr.sdc]

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter FPGA_TECHNOLOGY INTEGER 1
ad_ip_parameter ADC_DATA_WIDTH INTEGER 256
ad_ip_parameter DMA_DATA_WIDTH INTEGER 64
ad_ip_parameter DMA_READY_ENABLE INTEGER 1
ad_ip_parameter DMA_ADDRESS_WIDTH INTEGER 10

# elaborate

proc p_util_adcfifo {} {

  # read parameters

  set m_device_family [get_parameter_value "DEVICE_FAMILY"]
  set m_adc_data_width [get_parameter_value "ADC_DATA_WIDTH"]
  set m_dma_addr_width [get_parameter_value "DMA_ADDRESS_WIDTH"]
  set m_dma_data_width [get_parameter_value "DMA_DATA_WIDTH"]

  # intel memory

  add_hdl_instance mem_asym intel_mem_asym 1.0
  set_instance_parameter_value mem_asym DEVICE_FAMILY $m_device_family
  set_instance_parameter_value mem_asym A_ADDRESS_WIDTH 0
  set_instance_parameter_value mem_asym A_DATA_WIDTH $m_adc_data_width
  set_instance_parameter_value mem_asym B_ADDRESS_WIDTH $m_dma_addr_width
  set_instance_parameter_value mem_asym B_DATA_WIDTH $m_dma_data_width

  # interfaces

  ad_interface clock  adc_clk   input  1
  ad_interface reset  adc_rst   input  1              if_adc_clk
  ad_interface signal adc_wr    input  1              valid
  ad_interface signal adc_wdata input  ADC_DATA_WIDTH data
  ad_interface signal adc_wovf  output 1              ovf

  ad_interface clock  dma_clk         input  1 clk
  ad_interface signal dma_xfer_req    input  1 xfer_req
  ad_interface signal dma_xfer_status output 4 xfer_status

  add_interface m_axis axi4stream start
  set_interface_property m_axis associatedClock if_dma_clk
  set_interface_property m_axis associatedReset if_adc_rst
  add_interface_port m_axis  dma_wr     tvalid Output 1
  add_interface_port m_axis  dma_wready tready Input  1
  add_interface_port m_axis  dma_wdata  tdata  Output DMA_DATA_WIDTH

}

