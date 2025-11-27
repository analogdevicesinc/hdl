###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# receive dma

add_instance axi_dmac_0 axi_dmac
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_SRC} {1}
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_dmac_0 {CYCLIC} {0}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_SRC} {32}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_DEST} {128}

# util_sigma_delta_spi

add_instance util_sigma_delta_spi util_sigma_delta_spi
set_instance_parameter_value util_sigma_delta_spi {NUM_OF_CS} {1}

# spi engine
source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set spi_engine_hier spi_ad411x_ad717x

set data_width 32
set async_spi_clk 1
set num_cs 1
set num_sdi 1
set num_sdo 1
set sdi_delay 0
set echo_sclk 0
set sdo_streaming 0

set axi_clk sys_clk.clk
set axi_reset sys_clk.clk_reset
set spi_clk sys_dma_clk.clk

spi_engine_create $spi_engine_hier $axi_clk $axi_reset $spi_clk $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk $sdo_streaming
set_instance_parameter_value ${spi_engine_hier}_offload {ASYNC_TRIG}    {1}

# exported interface

add_interface ad411x_spi_sclk       clock source
add_interface ad411x_spi_cs         conduit end
add_interface ad411x_spi_sdi        conduit end
add_interface ad411x_spi_sdo        conduit end
add_interface ad411x_spi_trigger    conduit end
add_interface ad411x_spi_resetn     reset source

set_interface_property ad411x_spi_cs      EXPORT_OF util_sigma_delta_spi.if_m_cs
set_interface_property ad411x_spi_sclk    EXPORT_OF util_sigma_delta_spi.if_m_sclk
set_interface_property ad411x_spi_sdi     EXPORT_OF util_sigma_delta_spi.if_m_sdi
set_interface_property ad411x_spi_sdo     EXPORT_OF util_sigma_delta_spi.if_m_sdo
set_interface_property ad411x_spi_trigger EXPORT_OF util_sigma_delta_spi.if_data_ready

# clocks

add_connection sys_clk.clk axi_dmac_0.s_axi_clock

add_connection sys_dma_clk.clk axi_dmac_0.if_s_axis_aclk
add_connection sys_dma_clk.clk axi_dmac_0.m_dest_axi_clock

# util_sigma_delta_connection

add_connection sys_dma_clk.clk util_sigma_delta_spi.if_clk
add_connection sys_clk.clk_reset util_sigma_delta_spi.if_resetn

add_connection ${spi_engine_hier}_execution.if_cs util_sigma_delta_spi.if_s_cs
add_connection ${spi_engine_hier}_execution.if_sclk util_sigma_delta_spi.if_s_sclk
add_connection ${spi_engine_hier}_execution.if_sdi util_sigma_delta_spi.if_s_sdi
add_connection ${spi_engine_hier}_execution.if_sdo util_sigma_delta_spi.if_s_sdo
add_connection ${spi_engine_hier}_execution.if_sdo_t util_sigma_delta_spi.if_s_sdo_t
add_connection ${spi_engine_hier}_offload.if_trigger util_sigma_delta_spi.if_data_ready

# resets

add_connection sys_clk.clk_reset axi_dmac_0.s_axi_reset

add_connection sys_dma_clk.clk_reset axi_dmac_0.m_dest_axi_reset

# interfaces

add_connection ${spi_engine_hier}_offload.offload_sdi axi_dmac_0.s_axis

# cpu interconnects

ad_cpu_interconnect 0x00020000 axi_dmac_0.s_axi
ad_cpu_interconnect 0x00030000 ${spi_engine_hier}_axi_regmap.s_axi

# dma interconnect
ad_dma_interconnect axi_dmac_0.m_dest_axi

# interrupts

ad_cpu_interrupt 4 axi_dmac_0.interrupt_sender
ad_cpu_interrupt 5 ${spi_engine_hier}_axi_regmap.interrupt_sender
