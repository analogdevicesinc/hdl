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

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 adaq7980_spi
source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set hier_spi_engine  spi_adaq7980_adc
set data_width       16
set async_spi_clk    1
set offload_en       1
set num_cs           1
set num_sdi          1
set num_sdo          1
set sdi_delay        1
set echo_sclk        0

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $offload_en $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

# axi_pwm_gen
ad_ip_instance axi_pwm_gen spi_trigger_gen
ad_ip_parameter spi_trigger_gen CONFIG.PULSE_0_PERIOD 160
ad_ip_parameter spi_trigger_gen CONFIG.PULSE_0_WIDTH 1

ad_ip_instance axi_dmac axi_adaq7980_dma
ad_ip_parameter axi_adaq7980_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_adaq7980_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adaq7980_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adaq7980_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adaq7980_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adaq7980_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_adaq7980_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adaq7980_dma CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter axi_adaq7980_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# axi_clkgen
ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8

ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

ad_connect spi_clk spi_trigger_gen/ext_clk
ad_connect $sys_cpu_clk spi_trigger_gen/s_axi_aclk
ad_connect sys_cpu_resetn spi_trigger_gen/s_axi_aresetn
ad_connect spi_trigger_gen/pwm_0 $hier_spi_engine/trigger

ad_connect axi_adaq7980_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE
ad_connect $hier_spi_engine/m_spi adaq7980_spi

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect spi_clk $hier_spi_engine/spi_clk
ad_connect spi_clk axi_adaq7980_dma/s_axis_aclk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn
ad_connect sys_cpu_resetn axi_adaq7980_dma/m_dest_axi_aresetn

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_adaq7980_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen
ad_cpu_interconnect 0x44b00000 spi_trigger_gen

ad_cpu_interrupt "ps-13" "mb-13" axi_adaq7980_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_adaq7980_dma/m_dest_axi

