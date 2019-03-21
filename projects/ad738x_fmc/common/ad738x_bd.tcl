
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 spi

# create a SPI Engine architecture

create_bd_cell -type hier spi
current_bd_instance /spi

  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_SAMPLE

  ad_ip_instance spi_engine_execution execution
  ad_ip_parameter execution CONFIG.DATA_WIDTH $adc_resolution
  ad_ip_parameter execution CONFIG.NUM_OF_CS 1
  ad_ip_parameter execution CONFIG.NUM_OF_SDI $adc_num_of_channels

  ad_ip_instance axi_spi_engine axi
  ad_ip_parameter axi CONFIG.DATA_WIDTH $adc_resolution
  ad_ip_parameter axi CONFIG.NUM_OF_SDI $adc_num_of_channels
  ad_ip_parameter axi CONFIG.NUM_OFFLOAD 1

  ad_ip_instance spi_engine_offload offload
  ad_ip_parameter offload CONFIG.DATA_WIDTH $adc_resolution
  ad_ip_parameter offload CONFIG.NUM_OF_SDI $adc_num_of_channels

  ad_ip_instance spi_engine_interconnect interconnect
  ad_ip_parameter interconnect CONFIG.DATA_WIDTH $adc_resolution
  ad_ip_parameter interconnect CONFIG.NUM_OF_SDI $adc_num_of_channels

  ad_ip_instance util_pulse_gen trigger_gen

  ## to setup the sample rate of the system change the PULSE_PERIOD value
  ## the acutal sample rate will be PULSE_PERIOD * (1/sys_cpu_clk)
  ## fsys_cpu_clk is defined to 100 MHZ
  set cycle_per_sec_100mhz 100000000
  set sampling_cycle [expr int(ceil(double($cycle_per_sec_100mhz) / $adc_sampling_rate))]
  ad_ip_parameter trigger_gen CONFIG.PULSE_PERIOD $sampling_cycle
  ad_ip_parameter trigger_gen CONFIG.PULSE_WIDTH 1

  if {$adc_resolution < 16} {
    ad_ip_instance util_axis_upscale axis_upscaler
    ad_ip_parameter axis_upscaler CONFIG.NUM_OF_CHANNELS $adc_num_of_channels
    ad_ip_parameter axis_upscaler CONFIG.DATA_WIDTH $adc_resolution
    ad_ip_parameter axis_upscaler CONFIG.UDATA_WIDTH 16
    ad_connect clk axis_upscaler/clk
    ad_connect axi/spi_resetn axis_upscaler/resetn
    ad_connect offload/offload_sdi axis_upscaler/s_axis
    ad_connect axis_upscaler/m_axis M_AXIS_SAMPLE
    ad_connect axis_upscaler/dfmt_enable GND
    ad_connect axis_upscaler/dfmt_type GND
    ad_connect axis_upscaler/dfmt_se GND
  } else {
    ad_connect offload/offload_sdi M_AXIS_SAMPLE
  }

  ad_connect axi/spi_engine_offload_ctrl0 offload/spi_engine_offload_ctrl
  ad_connect offload/spi_engine_ctrl interconnect/s0_ctrl
  ad_connect axi/spi_engine_ctrl interconnect/s1_ctrl
  ad_connect interconnect/m_ctrl execution/ctrl

  ad_connect execution/spi m_spi

  ad_connect clk offload/spi_clk
  ad_connect clk offload/ctrl_clk
  ad_connect clk execution/clk
  ad_connect clk axi/s_axi_aclk
  ad_connect clk axi/spi_clk
  ad_connect clk interconnect/clk
  ad_connect clk trigger_gen/clk

  ad_connect axi/spi_resetn offload/spi_resetn
  ad_connect axi/spi_resetn execution/resetn
  ad_connect axi/spi_resetn interconnect/resetn
  ad_connect axi/spi_resetn trigger_gen/rstn
  ad_connect trigger_gen/load_config GND
  ad_connect trigger_gen/pulse_width GND
  ad_connect trigger_gen/pulse_period GND

  ad_connect trigger_gen/pulse offload/trigger

  ad_connect resetn axi/s_axi_aresetn
  ad_connect irq axi/irq

current_bd_instance /

ad_ip_instance axi_dmac axi_ad738x_dma
ad_ip_parameter axi_ad738x_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad738x_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad738x_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad738x_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad738x_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad738x_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad738x_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad738x_dma CONFIG.DMA_DATA_WIDTH_SRC [expr $adc_num_of_channels * 16]
ad_ip_parameter axi_ad738x_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  sys_cpu_clk spi/clk
ad_connect  sys_cpu_resetn spi/resetn
ad_connect  sys_cpu_resetn axi_ad738x_dma/m_dest_axi_aresetn

ad_connect  spi/m_spi spi
ad_connect  axi_ad738x_dma/s_axis spi/M_AXIS_SAMPLE

ad_cpu_interconnect 0x44a00000 spi/axi
ad_cpu_interconnect 0x44a30000 axi_ad738x_dma

ad_connect sys_cpu_clk axi_ad738x_dma/s_axis_aclk

ad_cpu_interrupt "ps-13" "mb-13" axi_ad738x_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" spi/irq

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad738x_dma/m_dest_axi

