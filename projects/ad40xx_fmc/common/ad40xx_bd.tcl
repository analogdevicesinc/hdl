###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 ad40xx_spi


## To support the 1.8MSPS (SCLK == 100 MHz), set the spi clock to 200 MHz
set_property -dict [list \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ $spi_clk_ref_frequency] [get_bd_cells sys_ps7]

# create a SPI Engine architecture

create_bd_cell -type hier spi_ad40xx
current_bd_instance /spi_ad40xx

  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir I -type clk spi_clk
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 m_spi
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_SAMPLE

  if {$ADC_RESOLUTION <= 16} {
    set data_width 16
  } else {
    set data_width 32
  };

  ad_ip_instance spi_engine_execution execution
  ad_ip_parameter execution CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter execution CONFIG.NUM_OF_CS 1
  ad_ip_parameter execution CONFIG.NUM_OF_SDI 1
  ad_ip_parameter execution CONFIG.SDO_DEFAULT 1
  ad_ip_parameter execution CONFIG.SDI_DELAY 1

  ad_ip_instance axi_spi_engine axi_regmap
  ad_ip_parameter axi_regmap CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter axi_regmap CONFIG.NUM_OFFLOAD 1
  ad_ip_parameter axi_regmap CONFIG.ASYNC_SPI_CLK 1

  ad_ip_instance spi_engine_offload offload
  ad_ip_parameter offload CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter offload CONFIG.ASYNC_SPI_CLK 1

  ad_ip_instance spi_engine_interconnect interconnect
  ad_ip_parameter interconnect CONFIG.DATA_WIDTH $data_width

  ad_ip_instance util_pulse_gen trigger_gen

  ## to setup the sample rate of the system change the PULSE_PERIOD value
  ## the acutal sample rate will be PULSE_PERIOD * (1/sys_cpu_clk)
  set sampling_cycle [expr int(ceil(double($spi_clk_ref_frequency * 1000000) / $ADC_SAMPLING_RATE))]
  ad_ip_parameter trigger_gen CONFIG.PULSE_PERIOD $sampling_cycle
  ad_ip_parameter trigger_gen CONFIG.PULSE_WIDTH 1

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
  ad_connect spi_clk trigger_gen/clk

  ad_connect axi_regmap/spi_resetn offload/spi_resetn
  ad_connect axi_regmap/spi_resetn execution/resetn
  ad_connect axi_regmap/spi_resetn interconnect/resetn
  ad_connect axi_regmap/spi_resetn trigger_gen/rstn
  ad_connect trigger_gen/load_config GND
  ad_connect trigger_gen/pulse_width GND
  ad_connect trigger_gen/pulse_period GND

  ad_connect trigger_gen/pulse offload/trigger

  ad_connect resetn axi_regmap/s_axi_aresetn
  ad_connect irq axi_regmap/irq

current_bd_instance /

# asynchronous SPI clock, to support higher SCLK
ad_connect spi_clk sys_ps7/FCLK_CLK2

# dma to receive data stream

ad_ip_instance axi_dmac axi_ad40xx_dma
ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad40xx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad40xx_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad40xx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad40xx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_2D_TRANSFER 0


ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_DATA_WIDTH_SRC $data_width
ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  sys_cpu_clk spi_ad40xx/clk
ad_connect  spi_clk axi_ad40xx_dma/s_axis_aclk
ad_connect  sys_cpu_resetn spi_ad40xx/resetn
ad_connect  sys_cpu_resetn axi_ad40xx_dma/m_dest_axi_aresetn

ad_connect  spi_clk spi_ad40xx/spi_clk

ad_connect  spi_ad40xx/m_spi ad40xx_spi

ad_connect  axi_ad40xx_dma/s_axis spi_ad40xx/M_AXIS_SAMPLE

ad_cpu_interconnect 0x44a00000 spi_ad40xx/axi_regmap
ad_cpu_interconnect 0x44a30000 axi_ad40xx_dma

ad_cpu_interrupt "ps-13" "mb-13" axi_ad40xx_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" /spi_ad40xx/irq

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad40xx_dma/m_dest_axi
