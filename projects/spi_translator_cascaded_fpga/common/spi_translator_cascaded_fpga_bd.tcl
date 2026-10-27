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
create_bd_port -dir O spi_eng_sclk
create_bd_port -dir O spi_eng_sdo
create_bd_port -dir O spi_eng_sdo_t
create_bd_port -dir I spi_eng_sdi
create_bd_port -dir O -from 5 -to 0 spi_eng_cs
create_bd_port -dir O spi_eng_three_wire

for {set i 1} {$i <= 12} {incr i} {
  create_bd_port -dir I spi_sn${i}_clk_i
  create_bd_port -dir I spi_sn${i}_sdo_i
  create_bd_port -dir O spi_sn${i}_sdi_o
  create_bd_port -dir I spi_sn${i}_csn_i
}

# cascaded translators, their upstream side is driven by spi_execution
# (CS 4 and 5) through system_top

for {set i 1} {$i <= 2} {incr i} {
  create_bd_port -dir I spi_slave_${i}_sclk
  create_bd_port -dir I spi_slave_${i}_sdi
  create_bd_port -dir O spi_slave_${i}_sdo
  create_bd_port -dir I spi_slave_${i}_cs

  create_bd_port -dir O spi_eng_${i}_sclk
  create_bd_port -dir O spi_eng_${i}_sdo
  create_bd_port -dir O spi_eng_${i}_sdo_t
  create_bd_port -dir I spi_eng_${i}_sdi
  create_bd_port -dir O -from 3 -to 0 spi_eng_${i}_cs
  create_bd_port -dir O spi_eng_${i}_three_wire
}

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

# SPI at 100/4 = 25 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_5
ad_ip_parameter axi_spi_subnode_5 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_5 CONFIG.C_SCK_RATIO 4
ad_ip_parameter axi_spi_subnode_5 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/8 = 12.5 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_6
ad_ip_parameter axi_spi_subnode_6 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_6 CONFIG.C_SCK_RATIO 8
ad_ip_parameter axi_spi_subnode_6 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/16 = 6.25 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_7
ad_ip_parameter axi_spi_subnode_7 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_7 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_subnode_7 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/32 = 3.125 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_8
ad_ip_parameter axi_spi_subnode_8 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_8 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_subnode_8 CONFIG.Multiples16 2
ad_ip_parameter axi_spi_subnode_8 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/4 = 25 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_9
ad_ip_parameter axi_spi_subnode_9 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_9 CONFIG.C_SCK_RATIO 4
ad_ip_parameter axi_spi_subnode_9 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/8 = 12.5 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_10
ad_ip_parameter axi_spi_subnode_10 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_10 CONFIG.C_SCK_RATIO 8
ad_ip_parameter axi_spi_subnode_10 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/16 = 6.25 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_11
ad_ip_parameter axi_spi_subnode_11 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_11 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_subnode_11 CONFIG.C_FIFO_DEPTH 256

# SPI at 100/32 = 3.125 MHz
ad_ip_instance axi_quad_spi axi_spi_subnode_12
ad_ip_parameter axi_spi_subnode_12 CONFIG.Master_mode 0
ad_ip_parameter axi_spi_subnode_12 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_subnode_12 CONFIG.Multiples16 2
ad_ip_parameter axi_spi_subnode_12 CONFIG.C_FIFO_DEPTH 256

# SPI translator
ad_ip_instance spi_translator spi_slave
ad_ip_parameter spi_slave CONFIG.NUM_OF_CS 6

ad_ip_instance spi_engine_execution spi_execution
ad_ip_parameter spi_execution CONFIG.NUM_OF_CS 6
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

for {set i 1} {$i <= 12} {incr i} {
  ad_connect axi_spi_subnode_${i}/sck_i  spi_sn${i}_clk_i
  ad_connect axi_spi_subnode_${i}/io0_i  spi_sn${i}_sdo_i
  ad_connect axi_spi_subnode_${i}/io1_o  spi_sn${i}_sdi_o
  ad_connect axi_spi_subnode_${i}/io1_i  axi_spi_subnode_${i}/io1_o
  ad_connect axi_spi_subnode_${i}/spisel spi_sn${i}_csn_i
  ad_connect axi_spi_subnode_${i}/ext_spi_clk $sys_cpu_clk
}

ad_connect $sys_cpu_clk axi_spi_host/ext_spi_clk
ad_connect $sys_cpu_clk spi_slave/clk
ad_connect $sys_cpu_clk spi_execution/clk
ad_connect $sys_cpu_resetn spi_slave/resetn
ad_connect spi_slave/spi_resetn spi_execution/resetn

# cascaded SPI translators

for {set i 1} {$i <= 2} {incr i} {
  ad_ip_instance spi_translator spi_slave_${i}
  ad_ip_parameter spi_slave_${i} CONFIG.NUM_OF_CS 4

  ad_ip_instance spi_engine_execution spi_execution_${i}
  ad_ip_parameter spi_execution_${i} CONFIG.NUM_OF_CS 4
  ad_ip_parameter spi_execution_${i} CONFIG.DATA_WIDTH 8
  ad_ip_parameter spi_execution_${i} CONFIG.NUM_OF_SDIO 1

  ad_connect spi_slave_${i}_sclk spi_slave_${i}/sclk
  ad_connect spi_slave_${i}_sdi spi_slave_${i}/sdi
  ad_connect spi_slave_${i}_sdo spi_slave_${i}/sdo
  ad_connect spi_slave_${i}_cs spi_slave_${i}/cs

  ad_connect spi_slave_${i}/spi_engine_ctrl spi_execution_${i}/ctrl
  ad_connect spi_slave_${i}/gpio_i GND

  ad_connect spi_eng_${i}_sclk spi_execution_${i}/sclk
  ad_connect spi_eng_${i}_sdo spi_execution_${i}/sdo
  ad_connect spi_eng_${i}_sdo_t spi_execution_${i}/sdo_t
  ad_connect spi_eng_${i}_sdi spi_execution_${i}/sdi
  ad_connect spi_eng_${i}_cs spi_execution_${i}/cs
  ad_connect spi_eng_${i}_three_wire spi_execution_${i}/three_wire

  ad_connect $sys_cpu_clk spi_slave_${i}/clk
  ad_connect $sys_cpu_clk spi_execution_${i}/clk
  ad_connect $sys_cpu_resetn spi_slave_${i}/resetn
  ad_connect spi_slave_${i}/spi_resetn spi_execution_${i}/resetn
}

# interconnects

ad_cpu_interconnect 0x79020000 axi_spi_host
ad_cpu_interconnect 0x79030000 axi_spi_subnode_1
ad_cpu_interconnect 0x79040000 axi_spi_subnode_2
ad_cpu_interconnect 0x79050000 axi_spi_subnode_3
ad_cpu_interconnect 0x79060000 axi_spi_subnode_4
ad_cpu_interconnect 0x79070000 axi_spi_subnode_5
ad_cpu_interconnect 0x79080000 axi_spi_subnode_6
ad_cpu_interconnect 0x79090000 axi_spi_subnode_7
ad_cpu_interconnect 0x790A0000 axi_spi_subnode_8
ad_cpu_interconnect 0x790B0000 axi_spi_subnode_9
ad_cpu_interconnect 0x790C0000 axi_spi_subnode_10
ad_cpu_interconnect 0x790D0000 axi_spi_subnode_11
ad_cpu_interconnect 0x790E0000 axi_spi_subnode_12

# interrupts

ad_cpu_interrupt ps-0 mb-0 axi_spi_host/ip2intc_irpt
ad_cpu_interrupt ps-1 mb-1 axi_spi_subnode_1/ip2intc_irpt
ad_cpu_interrupt ps-2 mb-2 axi_spi_subnode_2/ip2intc_irpt
ad_cpu_interrupt ps-3 mb-3 axi_spi_subnode_3/ip2intc_irpt
ad_cpu_interrupt ps-4 mb-4 axi_spi_subnode_4/ip2intc_irpt
ad_cpu_interrupt ps-5 mb-5 axi_spi_subnode_5/ip2intc_irpt
ad_cpu_interrupt ps-6 mb-6 axi_spi_subnode_6/ip2intc_irpt
ad_cpu_interrupt ps-7 mb-7 axi_spi_subnode_7/ip2intc_irpt
ad_cpu_interrupt ps-8 mb-8 axi_spi_subnode_8/ip2intc_irpt
ad_cpu_interrupt ps-9 mb-9 axi_spi_subnode_9/ip2intc_irpt
ad_cpu_interrupt ps-10 mb-10 axi_spi_subnode_10/ip2intc_irpt
ad_cpu_interrupt ps-12 mb-12 axi_spi_subnode_11/ip2intc_irpt
ad_cpu_interrupt ps-13 mb-13 axi_spi_subnode_12/ip2intc_irpt
