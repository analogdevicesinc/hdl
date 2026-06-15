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

create_bd_port -dir O -type clk i2s_mclk
create_bd_intf_port -mode Master -vlnv analog.com:interface:i2s_rtl:1.0 i2s

create_bd_port -dir I axi_fan_tacho_i
create_bd_port -dir O axi_fan_pwm_o

# i2s ip

ad_ip_instance axi_i2s_adi axi_i2s_adi
ad_ip_parameter axi_i2s_adi CONFIG.DMA_TYPE 0
ad_ip_parameter axi_i2s_adi CONFIG.S_AXI_ADDRESS_WIDTH 32

# dma

ad_ip_instance axi_dmac i2s_tx_dma
ad_ip_parameter i2s_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter i2s_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter i2s_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter i2s_tx_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter i2s_tx_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter i2s_tx_dma CONFIG.ASYNC_CLK_DEST_REQ 0
ad_ip_parameter i2s_tx_dma CONFIG.ASYNC_CLK_SRC_DEST 0
ad_ip_parameter i2s_tx_dma CONFIG.ASYNC_CLK_REQ_SRC 0
ad_ip_parameter i2s_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter i2s_tx_dma CONFIG.DMA_DATA_WIDTH_DEST 32
ad_ip_parameter i2s_tx_dma CONFIG.DMA_DATA_WIDTH_SRC 64

ad_ip_instance axi_dmac i2s_rx_dma
ad_ip_parameter i2s_rx_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter i2s_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter i2s_rx_dma CONFIG.CYCLIC 1
ad_ip_parameter i2s_rx_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter i2s_rx_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter i2s_rx_dma CONFIG.ASYNC_CLK_DEST_REQ 0
ad_ip_parameter i2s_rx_dma CONFIG.ASYNC_CLK_SRC_DEST 0
ad_ip_parameter i2s_rx_dma CONFIG.ASYNC_CLK_REQ_SRC 0
ad_ip_parameter i2s_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter i2s_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter i2s_rx_dma CONFIG.DMA_DATA_WIDTH_SRC 32

# i2s connections

ad_connect sys_cpu_clk axi_i2s_adi/s_axi_aclk
ad_connect sys_cpu_clk axi_i2s_adi/s_axis_aclk
ad_connect sys_cpu_clk axi_i2s_adi/m_axis_aclk
ad_connect sys_cpu_resetn axi_i2s_adi/s_axi_aresetn
ad_connect sys_cpu_resetn axi_i2s_adi/s_axis_aresetn
ad_connect i2s_tx_dma/m_axis axi_i2s_adi/s_axis

# not connecting tlast

ad_connect i2s_rx_dma/s_axis_data axi_i2s_adi/m_axis_tdata
ad_connect i2s_rx_dma/s_axis_valid axi_i2s_adi/m_axis_tvalid
ad_connect i2s_rx_dma/s_axis_ready axi_i2s_adi/m_axis_tready
ad_connect i2s axi_i2s_adi/I2S
ad_connect i2s_m_clk axi_i2s_adi/data_clk_i
ad_connect i2s_m_clk i2s_mclk

ad_connect sys_cpu_clk i2s_tx_dma/s_axi_aclk
ad_connect sys_cpu_clk i2s_tx_dma/m_src_axi_aclk
ad_connect sys_cpu_clk i2s_tx_dma/m_axis_aclk
ad_connect sys_cpu_resetn i2s_tx_dma/s_axi_aresetn
ad_connect sys_cpu_resetn i2s_tx_dma/m_src_axi_aresetn

ad_connect sys_cpu_clk i2s_rx_dma/s_axi_aclk
ad_connect sys_cpu_clk i2s_rx_dma/m_dest_axi_aclk
ad_connect sys_cpu_clk i2s_rx_dma/s_axis_aclk
ad_connect sys_cpu_resetn i2s_rx_dma/s_axi_aresetn
ad_connect sys_cpu_resetn i2s_rx_dma/m_dest_axi_aresetn

# fan control

ad_ip_instance axi_fan_control axi_fan_control_0
ad_ip_parameter axi_fan_control_0 CONFIG.ID 1
ad_ip_parameter axi_fan_control_0 CONFIG.PWM_FREQUENCY_HZ 1000
ad_ip_parameter axi_fan_control_0 CONFIG.INTERNAL_SYSMONE 1

ad_ip_instance ilconstant const_gnd_0
ad_ip_parameter const_gnd_0 CONFIG.CONST_WIDTH {10}
ad_ip_parameter const_gnd_0 CONFIG.CONST_VAL {0}

ad_connect axi_fan_tacho_i axi_fan_control_0/tacho
ad_connect axi_fan_pwm_o axi_fan_control_0/pwm
ad_connect const_gnd_0/dout axi_fan_control_0/temp_in

# interconnect

ad_cpu_interconnect 0x40000000 axi_fan_control_0
ad_cpu_interconnect 0x41000000 i2s_rx_dma
ad_cpu_interconnect 0x41001000 i2s_tx_dma
ad_cpu_interconnect 0x42000000 axi_i2s_adi

ad_mem_hp1_interconnect sys_cpu_clk sys_ps8/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk i2s_tx_dma/m_src_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps8/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk i2s_rx_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-6 mb-6 i2s_tx_dma/irq
ad_cpu_interrupt ps-7 mb-7 i2s_rx_dma/irq
ad_cpu_interrupt ps-14 mb-14 axi_fan_control_0/irq
