###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 ad4134_di
create_bd_port -dir O ad4134_odr

# create a SPI Engine architecture for ADC

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       4
set num_sdo       0
set sdi_delay     0
set echo_sclk     0

set hier_spi_engine spi_ad4134

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

# clkgen

ad_ip_instance axi_clkgen axi_ad4134_clkgen
ad_ip_parameter axi_ad4134_clkgen CONFIG.VCO_DIV 5
ad_ip_parameter axi_ad4134_clkgen CONFIG.VCO_MUL 48
ad_ip_parameter axi_ad4134_clkgen CONFIG.CLK0_DIV 10

# dma to receive data stream

ad_ip_instance axi_dmac axi_ad4134_dma
ad_ip_parameter axi_ad4134_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad4134_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad4134_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad4134_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad4134_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad4134_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad4134_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# odr generator

ad_ip_instance axi_pwm_gen odr_generator
ad_ip_parameter odr_generator CONFIG.N_PWMS 2
ad_ip_parameter odr_generator CONFIG.PULSE_0_PERIOD 85
ad_ip_parameter odr_generator CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter odr_generator CONFIG.PULSE_0_OFFSET 3
ad_ip_parameter odr_generator CONFIG.PULSE_1_PERIOD 85
ad_ip_parameter odr_generator CONFIG.PULSE_1_WIDTH 13

ad_connect odr_generator/ext_clk axi_ad4134_clkgen/clk_0
ad_connect odr_generator/pwm_0 $hier_spi_engine/trigger
ad_connect odr_generator/pwm_1 ad4134_odr

ad_connect  axi_ad4134_clkgen/clk_0 $hier_spi_engine/spi_clk
ad_connect  $sys_cpu_clk axi_ad4134_clkgen/clk
ad_connect  $sys_cpu_clk $hier_spi_engine/clk
ad_connect  axi_ad4134_clkgen/clk_0 axi_ad4134_dma/s_axis_aclk
ad_connect  sys_cpu_resetn $hier_spi_engine/resetn
ad_connect  sys_cpu_resetn axi_ad4134_dma/m_dest_axi_aresetn

ad_connect  $hier_spi_engine/m_spi ad4134_di
ad_connect  axi_ad4134_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE

# AXI address definitions

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_ad4134_dma
ad_cpu_interconnect 0x44b00000 odr_generator
ad_cpu_interconnect 0x44b10000 axi_ad4134_clkgen

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" axi_ad4134_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq

# memory interconnects

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad4134_dma/m_dest_axi
