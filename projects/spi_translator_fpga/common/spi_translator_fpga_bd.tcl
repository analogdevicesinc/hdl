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
create_bd_port -dir I spi_sn1_clk_i
create_bd_port -dir I spi_sn1_sdo_i
create_bd_port -dir O spi_sn1_sdi_o
create_bd_port -dir I spi_sn1_csn_i

create_bd_port -dir I spi_sn2_clk_i
create_bd_port -dir I spi_sn2_sdo_i
create_bd_port -dir O spi_sn2_sdi_o
create_bd_port -dir I spi_sn2_csn_i

create_bd_port -dir I spi_sn3_clk_i
create_bd_port -dir I spi_sn3_sdo_i
create_bd_port -dir O spi_sn3_sdi_o
create_bd_port -dir I spi_sn3_csn_i

create_bd_port -dir I spi_sn4_clk_i
create_bd_port -dir I spi_sn4_sdo_i
create_bd_port -dir O spi_sn4_sdi_o
create_bd_port -dir I spi_sn4_csn_i

create_bd_port -dir O spi_eng_sclk
create_bd_port -dir O spi_eng_sdo
create_bd_port -dir O spi_eng_sdo_t
create_bd_port -dir I spi_eng_sdi
create_bd_port -dir O -from 3 -to 0 spi_eng_cs
create_bd_port -dir O spi_eng_three_wire

# SPI at 100/8 = 12.5 MHz
ad_ip_instance axi_quad_spi axi_spi_host
ad_ip_parameter axi_spi_host CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_host CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter axi_spi_host CONFIG.C_SCK_RATIO 8
ad_ip_parameter axi_spi_host CONFIG.C_FIFO_DEPTH 256

# SPI at 100/4 = 25 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_1
ad_ip_parameter axi_spi_subnode_1 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_1 CONFIG.C_SCK_RATIO 4
ad_ip_parameter axi_spi_subnode_1 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/8 = 12.5 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_2
ad_ip_parameter axi_spi_subnode_2 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_2 CONFIG.C_SCK_RATIO 8
ad_ip_parameter axi_spi_subnode_2 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/16 = 6.25 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_3
ad_ip_parameter axi_spi_subnode_3 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_3 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_subnode_3 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/32 = 3.125 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_4
ad_ip_parameter axi_spi_subnode_4 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_4 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_subnode_4 CONFIG.Multiples16 2
ad_ip_parameter axi_spi_subnode_4 CONFIG.C_FIFO_DEPTH 256

# SPI translator
ad_ip_instance spi_translator spi_slave

ad_ip_instance spi_engine_execution spi_execution
ad_ip_parameter spi_execution CONFIG.NUM_OF_CS 4
ad_ip_parameter spi_execution CONFIG.DATA_WIDTH 8
ad_ip_parameter spi_execution CONFIG.NUM_OF_SDIO 1

ad_connect axi_spi_host/sck_o spi_slave/sclk
ad_connect axi_spi_host/sck_i axi_spi_host/sck_o
ad_connect axi_spi_host/io0_o spi_slave/sdi
ad_connect axi_spi_host/io0_i axi_spi_host/io0_o
ad_connect axi_spi_host/io1_i spi_slave/sdo
ad_connect axi_spi_host/ss_o  spi_slave/cs
ad_connect axi_spi_host/ss_i  axi_spi_host/ss_o

ad_connect spi_slave/spi_engine_ctrl spi_execution/ctrl
ad_connect spi_slave/gpio_i GND

ad_connect spi_execution/sclk spi_eng_sclk
ad_connect spi_execution/sdo spi_eng_sdo
ad_connect spi_execution/sdo_t spi_eng_sdo_t
ad_connect spi_execution/sdi spi_eng_sdi
ad_connect spi_execution/cs spi_eng_cs
ad_connect spi_execution/three_wire spi_eng_three_wire

ad_connect axi_spi_subnode_1/sck_i  spi_sn1_clk_i
ad_connect axi_spi_subnode_1/io0_i  spi_sn1_sdo_i
ad_connect axi_spi_subnode_1/io1_o  spi_sn1_sdi_o
ad_connect axi_spi_subnode_1/io1_i  axi_spi_subnode_1/io1_o
ad_connect axi_spi_subnode_1/spisel spi_sn1_csn_i

ad_connect axi_spi_subnode_2/sck_i  spi_sn2_clk_i
ad_connect axi_spi_subnode_2/io0_i  spi_sn2_sdo_i
ad_connect axi_spi_subnode_2/io1_o  spi_sn2_sdi_o
ad_connect axi_spi_subnode_2/io1_i  axi_spi_subnode_2/io1_o
ad_connect axi_spi_subnode_2/spisel spi_sn2_csn_i

ad_connect axi_spi_subnode_3/sck_i  spi_sn3_clk_i
ad_connect axi_spi_subnode_3/io0_i  spi_sn3_sdo_i
ad_connect axi_spi_subnode_3/io1_o  spi_sn3_sdi_o
ad_connect axi_spi_subnode_3/io1_i  axi_spi_subnode_3/io1_o
ad_connect axi_spi_subnode_3/spisel spi_sn3_csn_i

ad_connect axi_spi_subnode_4/sck_i  spi_sn4_clk_i
ad_connect axi_spi_subnode_4/io0_i  spi_sn4_sdo_i
ad_connect axi_spi_subnode_4/io1_o  spi_sn4_sdi_o
ad_connect axi_spi_subnode_4/io1_i  axi_spi_subnode_4/io1_o
ad_connect axi_spi_subnode_4/spisel spi_sn4_csn_i

ad_connect $sys_cpu_clk axi_spi_host/ext_spi_clk
ad_connect $sys_cpu_clk axi_spi_subnode_1/ext_spi_clk
ad_connect $sys_cpu_clk axi_spi_subnode_2/ext_spi_clk
ad_connect $sys_cpu_clk axi_spi_subnode_3/ext_spi_clk
ad_connect $sys_cpu_clk axi_spi_subnode_4/ext_spi_clk
ad_connect $sys_cpu_clk spi_slave/clk
ad_connect $sys_cpu_clk spi_execution/clk
ad_connect $sys_cpu_resetn spi_slave/resetn
ad_connect spi_slave/spi_resetn spi_execution/resetn

# interconnects

ad_cpu_interconnect 0x79020000 axi_spi_host
ad_cpu_interconnect 0x79030000 axi_spi_subnode_1
ad_cpu_interconnect 0x79040000 axi_spi_subnode_2
ad_cpu_interconnect 0x79050000 axi_spi_subnode_3
ad_cpu_interconnect 0x79060000 axi_spi_subnode_4

# interrupts

ad_cpu_interrupt ps-8 mb-8 axi_spi_host/ip2intc_irpt
ad_cpu_interrupt ps-0 mb-0 axi_spi_subnode_1/ip2intc_irpt
ad_cpu_interrupt ps-1 mb-1 axi_spi_subnode_2/ip2intc_irpt
ad_cpu_interrupt ps-2 mb-2 axi_spi_subnode_3/ip2intc_irpt
ad_cpu_interrupt ps-3 mb-3 axi_spi_subnode_4/ip2intc_irpt
