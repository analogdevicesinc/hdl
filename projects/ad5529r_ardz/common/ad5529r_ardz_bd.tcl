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

# AD5529R SPI Engine Block Design
# 16-channel, 16-bit DAC with streaming mode support
# Target SCLK: 35 MHz (writes), 23.3 MHz (reads)

# bd ports

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 ad5529r_spi

# create a SPI Engine architecture for the DAC

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set hier_spi_engine       spi_ad5529r
set data_width            16
set async_spi_clk         1
set offload_en            1
set num_cs                1
set num_sdi               1
set num_sdo               1
set sdi_delay             1
set echo_sclk             0
set sdo_streaming         1
set cmd_mem_addr_width    4
set data_mem_addr_width   4
set sdi_fifo_addr_width   5
set sdo_fifo_addr_width   5
set sync_fifo_addr_width  4
set cmd_fifo_addr_width   4

spi_engine_create $hier_spi_engine \
    $data_width $async_spi_clk $offload_en \
    $num_cs $num_sdi $num_sdo \
    $sdi_delay $echo_sclk $sdo_streaming \
    $cmd_mem_addr_width $data_mem_addr_width \
    $sdi_fifo_addr_width $sdo_fifo_addr_width \
    $sync_fifo_addr_width $cmd_fifo_addr_width

# clkgen
# 100 MHz -> 140 MHz
# SCLK = 140 MHz / (2 * (PRESCALE + 1))
# PRESCALE=1 -> SCLK = 35 MHz

ad_ip_instance axi_clkgen axi_ad5529r_clkgen
ad_ip_parameter axi_ad5529r_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_ad5529r_clkgen CONFIG.VCO_MUL 7
ad_ip_parameter axi_ad5529r_clkgen CONFIG.CLK0_DIV 5

# dma to send sample data

ad_ip_instance axi_dmac ad5529r_dma
ad_ip_parameter ad5529r_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter ad5529r_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter ad5529r_dma CONFIG.CYCLIC 0
ad_ip_parameter ad5529r_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter ad5529r_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad5529r_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter ad5529r_dma CONFIG.DMA_DATA_WIDTH_DEST $data_width

# trigger generator

ad_ip_instance axi_pwm_gen trig_gen
ad_ip_parameter trig_gen CONFIG.N_PWMS 1
ad_ip_parameter trig_gen CONFIG.PULSE_0_PERIOD 98
ad_ip_parameter trig_gen CONFIG.PULSE_0_WIDTH 1

# Toggle pin generator (TG0-TG3)
# 4 independent PWMs for dither/ramp functions
# Max frequency: 5 MHz

ad_ip_instance axi_pwm_gen toggle_gen
ad_ip_parameter toggle_gen CONFIG.N_PWMS 4
ad_ip_parameter toggle_gen CONFIG.PULSE_0_PERIOD 28
ad_ip_parameter toggle_gen CONFIG.PULSE_0_WIDTH 14
ad_ip_parameter toggle_gen CONFIG.PULSE_1_PERIOD 28
ad_ip_parameter toggle_gen CONFIG.PULSE_1_WIDTH 14
ad_ip_parameter toggle_gen CONFIG.PULSE_2_PERIOD 28
ad_ip_parameter toggle_gen CONFIG.PULSE_2_WIDTH 14
ad_ip_parameter toggle_gen CONFIG.PULSE_3_PERIOD 28
ad_ip_parameter toggle_gen CONFIG.PULSE_3_WIDTH 14

# Create output ports for toggle pins

create_bd_port -dir O tg0
create_bd_port -dir O tg1
create_bd_port -dir O tg2
create_bd_port -dir O tg3

# connections

ad_connect trig_gen/ext_clk axi_ad5529r_clkgen/clk_0
ad_connect trig_gen/pwm_0 $hier_spi_engine/trigger

ad_connect toggle_gen/ext_clk axi_ad5529r_clkgen/clk_0
ad_connect toggle_gen/pwm_0 tg0
ad_connect toggle_gen/pwm_1 tg1
ad_connect toggle_gen/pwm_2 tg2
ad_connect toggle_gen/pwm_3 tg3

ad_connect axi_ad5529r_clkgen/clk_0 $hier_spi_engine/spi_clk
ad_connect $sys_cpu_clk axi_ad5529r_clkgen/clk
ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect axi_ad5529r_clkgen/clk_0 ad5529r_dma/m_axis_aclk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn
ad_connect sys_cpu_resetn ad5529r_dma/m_src_axi_aresetn

ad_connect $hier_spi_engine/m_spi ad5529r_spi
ad_connect ad5529r_dma/m_axis $hier_spi_engine/s_axis_sample

# AXI address definitions

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a40000 ad5529r_dma
ad_cpu_interconnect 0x44b00000 trig_gen
ad_cpu_interconnect 0x44b10000 axi_ad5529r_clkgen
ad_cpu_interconnect 0x44b20000 toggle_gen

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" ad5529r_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq

# memory interconnects

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk ad5529r_dma/m_src_axi
