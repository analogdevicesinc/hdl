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

# SPI Connections
create_bd_port -dir O spi_pmod_csn_o
create_bd_port -dir I spi_pmod_csn_i
create_bd_port -dir I spi_pmod_clk_i
create_bd_port -dir O spi_pmod_clk_o
create_bd_port -dir I spi_pmod_sdo_i
create_bd_port -dir O spi_pmod_sdo_o
create_bd_port -dir O spi_pmod_sdi_o

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 spi_eng

# SPI at 100/8 = 12.5 MHz
ad_ip_instance axi_quad_spi axi_spi_host
ad_ip_parameter axi_spi_host CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_host CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter axi_spi_host CONFIG.C_SCK_RATIO 8

ad_connect spi_pmod_csn_i axi_spi_host/ss_i
ad_connect spi_pmod_csn_o axi_spi_host/ss_o
ad_connect spi_pmod_clk_i axi_spi_host/sck_i
ad_connect spi_pmod_clk_o axi_spi_host/sck_o
ad_connect spi_pmod_sdo_i axi_spi_host/io0_i
ad_connect spi_pmod_sdo_o axi_spi_host/io0_o

# SPI translator
ad_ip_instance spi_translator spi_slave

ad_ip_instance spi_engine_execution spi_execution
ad_ip_parameter spi_execution CONFIG.NUM_OF_CS 4
ad_ip_parameter spi_execution CONFIG.DATA_WIDTH 8
ad_ip_parameter spi_execution CONFIG.NUM_OF_SDIO 1

ad_connect axi_spi_host/sck_o spi_slave/sclk
ad_connect axi_spi_host/io0_o spi_slave/sdi
ad_connect axi_spi_host/io1_i spi_slave/sdo
ad_connect spi_pmod_sdi_o spi_slave/sdo
ad_connect axi_spi_host/ss_o  spi_slave/cs

ad_connect spi_slave/spi_engine_ctrl spi_execution/ctrl
ad_connect spi_execution/spi spi_eng

# the response stream is not returned upstream yet, drain it
ad_connect spi_slave/resp_ready VCC

ad_connect $sys_cpu_clk axi_spi_host/ext_spi_clk
ad_connect $sys_cpu_clk spi_slave/clk
ad_connect $sys_cpu_clk spi_execution/clk
ad_connect $sys_cpu_resetn spi_slave/resetn
ad_connect spi_slave/spi_resetn spi_execution/resetn

# interconnects

ad_cpu_interconnect 0x79020000 axi_spi_host

# interrupts

ad_cpu_interrupt ps-8 mb-8 axi_spi_host/ip2intc_irpt
ad_cpu_interrupt ps-13 mb-13 spi_slave/irq
