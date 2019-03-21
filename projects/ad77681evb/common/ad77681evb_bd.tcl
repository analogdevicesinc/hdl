
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 adc1_spi
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 adc2_spi

create_bd_port -dir I adc1_data_ready
create_bd_port -dir I adc2_data_ready

# create a SPI Engine architecture for both ADCs

create_bd_cell -type hier spi_adc1
current_bd_instance /spi_adc1

  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir I drdy
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_SAMPLE

  # DATA_WIDTH is set to 8, so the granularity of the transaction will be 8 bit
  # So we can to support 16bit 24bit and 32bit transfers

  ad_ip_instance spi_engine_execution execution
  ad_ip_parameter execution CONFIG.DATA_WIDTH 8
  ad_ip_parameter execution CONFIG.NUM_OF_CS 1

  ad_ip_instance axi_spi_engine axi_1
  ad_ip_parameter axi_1 CONFIG.DATA_WIDTH 8
  ad_ip_parameter axi_1 CONFIG.NUM_OFFLOAD 1

  ad_ip_instance spi_engine_offload offload
  ad_ip_parameter offload CONFIG.DATA_WIDTH 8
  ad_ip_parameter offload CONFIG.ASYNC_TRIG 1

  ad_ip_instance spi_engine_interconnect interconnect
  ad_ip_parameter interconnect CONFIG.DATA_WIDTH 8

  # to convert the 8bit AXI stream to 24bit AXI stream
  ad_ip_instance axis_dwidth_converter m_axis_samples_24
  ad_ip_parameter m_axis_samples_24 CONFIG.M_TDATA_NUM_BYTES 3

  # upscale the data to 32bit, samples should be multiple of 16bit
  ad_ip_instance util_axis_upscale axis_upscaler
  ad_ip_parameter axis_upscaler CONFIG.NUM_OF_CHANNELS 1
  ad_ip_parameter axis_upscaler CONFIG.DATA_WIDTH 24
  ad_ip_parameter axis_upscaler CONFIG.UDATA_WIDTH 32
  ad_connect axis_upscaler/dfmt_enable GND
  ad_connect axis_upscaler/dfmt_type GND
  ad_connect axis_upscaler/dfmt_se GND

  ad_connect axi_1/spi_engine_offload_ctrl0 offload/spi_engine_offload_ctrl
  ad_connect offload/spi_engine_ctrl interconnect/s0_ctrl
  ad_connect axi_1/spi_engine_ctrl interconnect/s1_ctrl
  ad_connect interconnect/m_ctrl execution/ctrl
  ad_connect offload/offload_sdi m_axis_samples_24/S_AXIS
  ad_connect m_axis_samples_24/M_AXIS axis_upscaler/s_axis
  ad_connect axis_upscaler/m_axis M_AXIS_SAMPLE

  ad_connect execution/spi m_spi

  ad_connect clk offload/spi_clk
  ad_connect clk offload/ctrl_clk
  ad_connect clk execution/clk
  ad_connect clk axi_1/s_axi_aclk
  ad_connect clk axi_1/spi_clk
  ad_connect clk interconnect/clk
  ad_connect clk m_axis_samples_24/aclk
  ad_connect clk axis_upscaler/clk

  ad_connect axi_1/spi_resetn offload/spi_resetn
  ad_connect axi_1/spi_resetn execution/resetn
  ad_connect axi_1/spi_resetn interconnect/resetn
  ad_connect axi_1/spi_resetn m_axis_samples_24/aresetn
  ad_connect axi_1/spi_resetn axis_upscaler/resetn

  ad_connect drdy offload/trigger

  ad_connect resetn axi_1/s_axi_aresetn
  ad_connect irq axi_1/irq

current_bd_instance /

create_bd_cell -type hier spi_adc2
current_bd_instance /spi_adc2

  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir I drdy
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_SAMPLE

  ad_ip_instance spi_engine_execution execution
  ad_ip_parameter execution CONFIG.DATA_WIDTH 8
  ad_ip_parameter execution CONFIG.NUM_OF_CS 1

  ad_ip_instance axi_spi_engine axi_2
  ad_ip_parameter axi_2 CONFIG.DATA_WIDTH 8
  ad_ip_parameter axi_2 CONFIG.NUM_OFFLOAD 1

  ad_ip_instance spi_engine_offload offload
  ad_ip_parameter offload CONFIG.DATA_WIDTH 8
  ad_ip_parameter offload CONFIG.ASYNC_TRIG 1

  ad_ip_instance spi_engine_interconnect interconnect
  ad_ip_parameter interconnect CONFIG.DATA_WIDTH 8

  # to convert the 8bit AXI stream to 24bit AXI stream
  ad_ip_instance axis_dwidth_converter m_axis_samples_24
  ad_ip_parameter m_axis_samples_24 CONFIG.M_TDATA_NUM_BYTES 3

  # upscale the data to 32bit, samples should be multiple of 16bit
  ad_ip_instance util_axis_upscale axis_upscaler
  ad_ip_parameter axis_upscaler CONFIG.NUM_OF_CHANNELS 1
  ad_ip_parameter axis_upscaler CONFIG.DATA_WIDTH 24
  ad_ip_parameter axis_upscaler CONFIG.UDATA_WIDTH 32
  ad_connect axis_upscaler/dfmt_enable GND
  ad_connect axis_upscaler/dfmt_type GND
  ad_connect axis_upscaler/dfmt_se GND

  ad_connect axi_2/spi_engine_offload_ctrl0 offload/spi_engine_offload_ctrl
  ad_connect offload/spi_engine_ctrl interconnect/s0_ctrl
  ad_connect axi_2/spi_engine_ctrl interconnect/s1_ctrl
  ad_connect interconnect/m_ctrl execution/ctrl
  ad_connect offload/offload_sdi m_axis_samples_24/S_AXIS
  ad_connect m_axis_samples_24/M_AXIS axis_upscaler/s_axis
  ad_connect axis_upscaler/m_axis M_AXIS_SAMPLE

  ad_connect execution/spi m_spi

  ad_connect clk offload/spi_clk
  ad_connect clk offload/ctrl_clk
  ad_connect clk execution/clk
  ad_connect clk axi_2/s_axi_aclk
  ad_connect clk axi_2/spi_clk
  ad_connect clk interconnect/clk
  ad_connect clk m_axis_samples_24/aclk
  ad_connect clk axis_upscaler/clk

  ad_connect axi_2/spi_resetn offload/spi_resetn
  ad_connect axi_2/spi_resetn execution/resetn
  ad_connect axi_2/spi_resetn interconnect/resetn
  ad_connect axi_2/spi_resetn m_axis_samples_24/aresetn
  ad_connect axi_2/spi_resetn axis_upscaler/resetn

  ad_connect drdy offload/trigger

  ad_connect resetn axi_2/s_axi_aresetn
  ad_connect irq axi_2/irq

current_bd_instance /

ad_connect adc1_data_ready spi_adc1/drdy
ad_connect adc2_data_ready spi_adc2/drdy

# dma for the ADC1

ad_ip_instance axi_dmac axi_ad77681_dma_1
ad_ip_parameter axi_ad77681_dma_1 CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad77681_dma_1 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad77681_dma_1 CONFIG.CYCLIC 0
ad_ip_parameter axi_ad77681_dma_1 CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad77681_dma_1 CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad77681_dma_1 CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad77681_dma_1 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad77681_dma_1 CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_ad77681_dma_1 CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  sys_cpu_clk spi_adc1/clk
ad_connect  sys_cpu_resetn spi_adc1/resetn
ad_connect  sys_cpu_resetn axi_ad77681_dma_1/m_dest_axi_aresetn

ad_connect  spi_adc1/m_spi adc1_spi
ad_connect  axi_ad77681_dma_1/s_axis spi_adc1/M_AXIS_SAMPLE

# dma for the ADC2

ad_ip_instance axi_dmac axi_ad77681_dma_2
ad_ip_parameter axi_ad77681_dma_2 CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad77681_dma_2 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad77681_dma_2 CONFIG.CYCLIC 0
ad_ip_parameter axi_ad77681_dma_2 CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad77681_dma_2 CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad77681_dma_2 CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad77681_dma_2 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad77681_dma_2 CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_ad77681_dma_2 CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  sys_cpu_clk spi_adc2/clk
ad_connect  sys_cpu_resetn spi_adc2/resetn
ad_connect  sys_cpu_resetn axi_ad77681_dma_2/m_dest_axi_aresetn

ad_connect  spi_adc2/m_spi adc2_spi
ad_connect  axi_ad77681_dma_2/s_axis spi_adc2/M_AXIS_SAMPLE

# AXI address definitions

ad_cpu_interconnect 0x44a00000 spi_adc1/axi_1
ad_cpu_interconnect 0x44b00000 spi_adc2/axi_2
ad_cpu_interconnect 0x44a30000 axi_ad77681_dma_1
ad_cpu_interconnect 0x44b30000 axi_ad77681_dma_2

ad_connect sys_cpu_clk axi_ad77681_dma_1/s_axis_aclk
ad_connect sys_cpu_clk axi_ad77681_dma_2/s_axis_aclk

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" axi_ad77681_dma_1/irq
ad_cpu_interrupt "ps-12" "mb-12" axi_ad77681_dma_2/irq
ad_cpu_interrupt "ps-11" "mb-11" spi_adc1/irq
ad_cpu_interrupt "ps-10" "mb-10" spi_adc2/irq

# memory interconnects

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad77681_dma_1/m_dest_axi

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad77681_dma_2/m_dest_axi

