###############################################################################
## Copyright (C) 2017-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 adc_spi

create_bd_port -dir I adc_data_ready

ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 10
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8
ad_connect sys_cpu_clk spi_clkgen/clk

# create a SPI Engine architecture for ADC

create_bd_cell -type hier spi_adc
current_bd_instance /spi_adc

  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type clk spi_clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir I drdy
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 m_spi
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_SAMPLE

  # DATA_WIDTH is set to 32

  ad_ip_instance spi_engine_execution execution
  ad_ip_parameter execution CONFIG.DATA_WIDTH 32
  ad_ip_parameter execution CONFIG.NUM_OF_CS 1

  ad_ip_instance axi_spi_engine axi_regmap
  ad_ip_parameter axi_regmap CONFIG.DATA_WIDTH 32
  ad_ip_parameter axi_regmap CONFIG.NUM_OFFLOAD 1
  ad_ip_parameter axi_regmap CONFIG.ASYNC_SPI_CLK 1

  ad_ip_instance spi_engine_offload offload
  ad_ip_parameter offload CONFIG.DATA_WIDTH 32
  ad_ip_parameter offload CONFIG.ASYNC_TRIG 1
  ad_ip_parameter offload CONFIG.ASYNC_SPI_CLK 1

  ad_ip_instance spi_engine_interconnect interconnect
  ad_ip_parameter interconnect CONFIG.DATA_WIDTH 32

  ad_connect axi_regmap/spi_engine_offload_ctrl0 offload/spi_engine_offload_ctrl
  ad_connect offload/spi_engine_ctrl interconnect/s0_ctrl
  ad_connect axi_regmap/spi_engine_ctrl interconnect/s1_ctrl
  ad_connect interconnect/m_ctrl execution/ctrl
  ad_connect offload/offload_sdi M_AXIS_SAMPLE

  ad_connect execution/spi m_spi

  ad_connect spi_clk offload/spi_clk
  ad_connect spi_clk offload/ctrl_clk
  ad_connect spi_clk execution/clk
  ad_connect clk axi_regmap/s_axi_aclk
  ad_connect spi_clk axi_regmap/spi_clk
  ad_connect spi_clk interconnect/clk

  ad_connect axi_regmap/spi_resetn offload/spi_resetn
  ad_connect axi_regmap/spi_resetn execution/resetn
  ad_connect axi_regmap/spi_resetn interconnect/resetn

  ad_connect drdy offload/trigger

  ad_connect resetn axi_regmap/s_axi_aresetn
  ad_connect irq axi_regmap/irq


current_bd_instance /

ad_connect adc_data_ready spi_adc/drdy

# dma for the ADC

ad_ip_instance axi_dmac axi_ad77681_dma
ad_ip_parameter axi_ad77681_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad77681_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad77681_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad77681_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad77681_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad77681_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad77681_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad77681_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_ad77681_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  sys_cpu_clk spi_adc/clk
ad_connect  spi_adc/spi_clk spi_clkgen/clk_0

ad_connect  sys_cpu_resetn spi_adc/resetn
ad_connect  sys_cpu_resetn axi_ad77681_dma/m_dest_axi_aresetn

ad_connect  spi_adc/m_spi adc_spi
ad_connect  axi_ad77681_dma/s_axis spi_adc/M_AXIS_SAMPLE

# AXI address definitions

ad_cpu_interconnect 0x44a00000 spi_adc/axi_regmap
ad_cpu_interconnect 0x44a30000 axi_ad77681_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen

ad_connect spi_adc/spi_clk axi_ad77681_dma/s_axis_aclk

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" axi_ad77681_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" spi_adc/irq

# memory interconnects

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp2_interconnect sys_cpu_clk axi_ad77681_dma/m_dest_axi

