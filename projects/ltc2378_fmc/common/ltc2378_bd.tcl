###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 ltc2378_spi

create_bd_port -dir O ltc2378_spi_cnv
create_bd_port -dir I ltc2378_ext_clk

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       1
set num_sdo       1
set sdi_delay     0
set echo_sclk     0

set hier_spi_engine spi_ltc2378

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

# activate internal SPI Engine Offload synchronizer
ad_ip_parameter $hier_spi_engine/${hier_spi_engine}_offload CONFIG.ASYNC_TRIG 1

# clkgen - 140 MHz
ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 7

ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

# pwm generator
ad_ip_instance axi_pwm_gen ltc2378_trigger_gen

ad_ip_parameter ltc2378_trigger_gen CONFIG.N_PWMS 2
ad_ip_parameter ltc2378_trigger_gen CONFIG.PULSE_0_PERIOD 100
ad_ip_parameter ltc2378_trigger_gen CONFIG.PULSE_0_WIDTH 2
ad_ip_parameter ltc2378_trigger_gen CONFIG.PULSE_1_PERIOD 100
ad_ip_parameter ltc2378_trigger_gen CONFIG.PULSE_1_WIDTH 2
ad_ip_parameter ltc2378_trigger_gen CONFIG.PULSE_1_OFFSET 1

ad_connect $sys_cpu_clk ltc2378_trigger_gen/s_axi_aclk
ad_connect sys_cpu_resetn ltc2378_trigger_gen/s_axi_aresetn
ad_connect ltc2378_ext_clk ltc2378_trigger_gen/ext_clk

ad_connect ltc2378_spi_cnv ltc2378_trigger_gen/pwm_0
ad_connect ltc2378_trigger_gen/pwm_1 $hier_spi_engine/${hier_spi_engine}_offload/trigger

# dma to receive data stream
ad_ip_instance axi_dmac ltc2378_dma
ad_ip_parameter ltc2378_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter ltc2378_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ltc2378_dma CONFIG.CYCLIC 0
ad_ip_parameter ltc2378_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter ltc2378_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ltc2378_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter ltc2378_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ltc2378_dma CONFIG.DMA_DATA_WIDTH_SRC $data_width
ad_ip_parameter ltc2378_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect ltc2378_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE
ad_connect $hier_spi_engine/m_spi ltc2378_spi
ad_connect spi_clk $hier_spi_engine/spi_clk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn
ad_connect spi_clk ltc2378_dma/s_axis_aclk
ad_connect sys_cpu_resetn ltc2378_dma/m_dest_axi_aresetn

# AXI address definitions
ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 ltc2378_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen
ad_cpu_interconnect 0x44b00000 ltc2378_trigger_gen

ad_cpu_interrupt "ps-13" "mb-13" ltc2378_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" /$hier_spi_engine/irq

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk ltc2378_dma/m_dest_axi
