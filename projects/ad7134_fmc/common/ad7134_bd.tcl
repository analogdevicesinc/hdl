
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 ad713x_di
create_bd_port -dir I ad713x_odr
create_bd_port -dir O ad713x_sdpclk

# create a SPI Engine architecture for the parallel data interface of AD713x
# this design supports AD7132/AD7134/AD7136

create_bd_cell -type hier dual_ad7134
current_bd_instance /dual_ad7134

  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir I odr
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_SAMPLE

  if {$adc_resolution == 16 || $adc_resolution == 24} {
    set data_width 32
  } elseif {$adc_resolution == 32} {
    set data_width 64
  };

  ad_ip_instance spi_engine_execution execution
  ad_ip_parameter execution CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter execution CONFIG.NUM_OF_CS 1
  ad_ip_parameter execution CONFIG.NUM_OF_SDI $adc_num_of_channels

  ad_ip_instance axi_spi_engine axi
  ad_ip_parameter axi CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter axi CONFIG.NUM_OF_SDI $adc_num_of_channels
  ad_ip_parameter axi CONFIG.NUM_OFFLOAD 1

  ad_ip_instance spi_engine_offload offload
  ad_ip_parameter offload CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter offload CONFIG.NUM_OF_SDI $adc_num_of_channels
  ad_ip_parameter offload CONFIG.ASYNC_TRIG 1

  ad_ip_instance spi_engine_interconnect interconnect
  ad_ip_parameter interconnect CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter interconnect CONFIG.NUM_OF_SDI $adc_num_of_channels

  ad_connect axi/spi_engine_offload_ctrl0 offload/spi_engine_offload_ctrl
  ad_connect offload/spi_engine_ctrl interconnect/s0_ctrl
  ad_connect axi/spi_engine_ctrl interconnect/s1_ctrl
  ad_connect interconnect/m_ctrl execution/ctrl
  
  ad_connect offload/offload_sdi M_AXIS_SAMPLE
  
  ad_connect execution/spi m_spi

  ad_connect clk offload/spi_clk
  ad_connect clk offload/ctrl_clk
  ad_connect clk execution/clk
  ad_connect clk axi/s_axi_aclk
  ad_connect clk axi/spi_clk
  ad_connect clk interconnect/clk

  ad_connect axi/spi_resetn offload/spi_resetn
  ad_connect axi/spi_resetn execution/resetn
  ad_connect axi/spi_resetn interconnect/resetn

  ad_connect odr offload/trigger

  ad_connect resetn axi/s_axi_aresetn
  ad_connect irq axi/irq

current_bd_instance /

# dma to receive data stream

ad_ip_instance axi_dmac axi_ad7134_dma
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7134_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7134_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad7134_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad7134_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_DATA_WIDTH_SRC [expr $data_width * $adc_num_of_channels]
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_DATA_WIDTH_DEST 128

# sdpclk clock generator - default clk0_out is 50 MHz

ad_ip_instance axi_clkgen axi_sdp_clkgen
ad_ip_parameter axi_sdp_clkgen CONFIG.CLKIN_PERIOD 10
ad_ip_parameter axi_sdp_clkgen CONFIG.VCO_MUL 12
ad_ip_parameter axi_sdp_clkgen CONFIG.VCO_DIV 2
ad_ip_parameter axi_sdp_clkgen CONFIG.CLK0_DIV 12

ad_connect  sys_cpu_clk dual_ad7134/clk
ad_connect  sys_cpu_clk axi_ad7134_dma/s_axis_aclk
ad_connect  sys_cpu_clk axi_sdp_clkgen/clk
ad_connect  sys_cpu_resetn dual_ad7134/resetn
ad_connect  sys_cpu_resetn axi_ad7134_dma/m_dest_axi_aresetn

ad_connect  dual_ad7134/m_spi ad713x_di
ad_connect  dual_ad7134/odr ad713x_odr
ad_connect  axi_ad7134_dma/s_axis dual_ad7134/M_AXIS_SAMPLE
ad_connect  ad713x_sdpclk axi_sdp_clkgen/clk_0

ad_cpu_interconnect 0x44a00000 dual_ad7134/axi
ad_cpu_interconnect 0x44a30000 axi_ad7134_dma
ad_cpu_interconnect 0x44a40000 axi_sdp_clkgen


ad_cpu_interrupt "ps-13" "mb-13" axi_ad7134_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" dual_ad7134/irq

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad7134_dma/m_dest_axi

