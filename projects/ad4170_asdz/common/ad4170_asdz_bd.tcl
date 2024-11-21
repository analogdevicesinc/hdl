###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 adc_spi

create_bd_port -dir I adc_data_ready

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       1
set num_sdo       1
set sdi_delay     0
set echo_sclk     0

set hier_spi_engine spi_ad4170

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

# Generate a 80MHz spi_clk for the SPI Engine (targeted SCLK is 20MHz)

ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 10
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8

# trigger to RDY's negative edge

create_bd_cell -type module -reference sync_bits busy_sync
create_bd_cell -type module -reference ad_edge_detect busy_capture
set_property -dict [list CONFIG.EDGE 1] [get_bd_cells busy_capture]

ad_connect spi_clk busy_capture/clk
ad_connect busy_capture/rst GND

ad_connect busy_sync/out_resetn $hier_spi_engine/${hier_spi_engine}_axi_regmap/spi_resetn
ad_connect spi_clk busy_sync/out_clk
ad_connect busy_sync/in_bits adc_data_ready
ad_connect busy_sync/out_bits busy_capture/signal_in
ad_connect busy_capture/signal_out $hier_spi_engine/trigger

# dma for the ADC

ad_ip_instance axi_dmac axi_ad4170_dma
ad_ip_parameter axi_ad4170_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad4170_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad4170_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad4170_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad4170_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad4170_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad4170_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad4170_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_ad4170_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

ad_connect axi_ad4170_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE
ad_connect $hier_spi_engine/m_spi adc_spi

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect spi_clk $hier_spi_engine/spi_clk
ad_connect spi_clk axi_ad4170_dma/s_axis_aclk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn
ad_connect sys_cpu_resetn axi_ad4170_dma/m_dest_axi_aresetn

# AXI address definitions

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_ad4170_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" axi_ad4170_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq

# memory interconnects

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad4170_dma/m_dest_axi
