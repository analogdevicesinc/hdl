###############################################################################
## Copyright (C) 2014-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# pl ddr3 (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

proc ad_dacfifo_create {dac_fifo_name dac_data_width dac_dma_data_width dac_fifo_address_width} {

  upvar ad_hdl_dir ad_hdl_dir

  ad_ip_instance proc_sys_reset axi_rstgen
  ad_ip_instance mig_7series axi_ddr_cntrl

  file copy -force $ad_hdl_dir/projects/common/zc706/zc706_plddr3_mig.prj [get_property IP_DIR \
    [get_ips [get_property CONFIG.Component_Name [get_bd_cells axi_ddr_cntrl]]]]
  ad_ip_parameter axi_ddr_cntrl CONFIG.XML_INPUT_FILE zc706_plddr3_mig.prj

  create_bd_port -dir I -type rst sys_rst
  set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports sys_rst]

  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk

  ad_connect  sys_rst axi_ddr_cntrl/sys_rst
  ad_connect  sys_clk axi_ddr_cntrl/SYS_CLK
  ad_connect  ddr3 axi_ddr_cntrl/DDR3

  ad_ip_instance axi_dacfifo $dac_fifo_name
  ad_ip_parameter $dac_fifo_name CONFIG.DAC_DATA_WIDTH $dac_data_width
  ad_ip_parameter $dac_fifo_name CONFIG.DMA_DATA_WIDTH $dac_dma_data_width
  ad_ip_parameter $dac_fifo_name CONFIG.AXI_DATA_WIDTH 512
  ad_ip_parameter $dac_fifo_name CONFIG.AXI_SIZE 6
  ad_ip_parameter $dac_fifo_name CONFIG.AXI_LENGTH 255
  ad_ip_parameter $dac_fifo_name CONFIG.AXI_ADDRESS 0x80000000
  ad_ip_parameter $dac_fifo_name CONFIG.AXI_ADDRESS_LIMIT 0xbfffffff

  ad_connect  axi_ddr_cntrl/S_AXI $dac_fifo_name/axi
  ad_connect  axi_ddr_cntrl/ui_clk $dac_fifo_name/axi_clk
  ad_connect  axi_ddr_cntrl/ui_clk axi_rstgen/slowest_sync_clk
  ad_connect  sys_cpu_resetn axi_rstgen/ext_reset_in
  ad_connect  axi_rstgen/peripheral_aresetn $dac_fifo_name/axi_resetn
  ad_connect  axi_rstgen/peripheral_aresetn axi_ddr_cntrl/aresetn
  ad_connect  axi_ddr_cntrl/device_temp_i GND

  assign_bd_address [get_bd_addr_segs -of_objects [get_bd_cells axi_ddr_cntrl]]

}
