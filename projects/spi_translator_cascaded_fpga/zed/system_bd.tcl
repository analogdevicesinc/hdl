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

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/spi_translator_cascaded_fpga_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

# ILA
create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_spi_translator
set_property -dict [list \
  CONFIG.C_DATA_DEPTH {65536} \
  CONFIG.C_EN_STRG_QUAL {1} \
  CONFIG.C_MONITOR_TYPE {Native} \
  CONFIG.C_NUM_OF_PROBES {12} \
  CONFIG.C_PROBE0_WIDTH {1} \
  CONFIG.C_PROBE1_WIDTH {1} \
  CONFIG.C_PROBE2_WIDTH {1} \
  CONFIG.C_PROBE3_WIDTH {1} \
  CONFIG.C_PROBE4_WIDTH {1} \
  CONFIG.C_PROBE5_WIDTH {6} \
  CONFIG.C_PROBE6_WIDTH {1} \
  CONFIG.C_PROBE7_WIDTH {1} \
  CONFIG.C_PROBE8_WIDTH {4} \
  CONFIG.C_PROBE9_WIDTH {1} \
  CONFIG.C_PROBE10_WIDTH {1} \
  CONFIG.C_PROBE11_WIDTH {4} \
] [get_bd_cells ila_spi_translator]

ad_connect ila_spi_translator/clk      $sys_cpu_clk
ad_connect ila_spi_translator/probe0   axi_spi_host/sck_o
ad_connect ila_spi_translator/probe1   axi_spi_host/io0_o
ad_connect ila_spi_translator/probe2   axi_spi_host/ss_o
ad_connect ila_spi_translator/probe3   spi_execution/sclk
ad_connect ila_spi_translator/probe4   spi_execution/sdo
ad_connect ila_spi_translator/probe5   spi_execution/cs
ad_connect ila_spi_translator/probe6   spi_execution_1/sclk
ad_connect ila_spi_translator/probe7   spi_execution_1/sdo
ad_connect ila_spi_translator/probe8   spi_execution_1/cs
ad_connect ila_spi_translator/probe9   spi_execution_2/sclk
ad_connect ila_spi_translator/probe10  spi_execution_2/sdo
ad_connect ila_spi_translator/probe11  spi_execution_2/cs

sysid_gen_sys_init_file
