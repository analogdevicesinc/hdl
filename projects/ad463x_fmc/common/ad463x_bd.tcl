
## Parameter NUM_OF_SDI defines the interface mode
set ad463x_num_of_sdi $ad_project_params(NUM_OF_SDI)

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 ad463x_spi

create_bd_port -dir I ad463x_busy
create_bd_port -dir O ad463x_cnv

## To support the 2MSPS (SCLK == 80 MHz), set the spi clock to 160 MHz

ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8
ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

# create a SPI Engine architecture

create_bd_cell -type hier spi_ad463x
current_bd_instance /spi_ad463x

  ## to setup the sample rate of the system change the PULSE_PERIOD value
  ## the acutal sample rate will be PULSE_PERIOD * (1/sys_cpu_clk)
  set sampling_cycle [expr int(ceil(double($spi_clk_ref_frequency * 1000000) / $adc_sampling_rate))]

  ## ports and interfaces of the SPI Engine sub-system
  #
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir I -type clk spi_clk
  create_bd_pin -dir I trigger
  create_bd_pin -dir O cnv
  create_bd_pin -dir O irq
  create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi

  ## instantiation of the SPI Engine modules
  #
  ad_ip_instance spi_engine_execution execution
  ad_ip_parameter execution CONFIG.DATA_WIDTH 32
  ad_ip_parameter execution CONFIG.NUM_OF_CS 1
  ad_ip_parameter execution CONFIG.SDO_DEFAULT 1
  ad_ip_parameter execution CONFIG.NUM_OF_SDI $ad463x_num_of_sdi

  ad_ip_instance axi_spi_engine axi_regmap
  ad_ip_parameter axi_regmap CONFIG.DATA_WIDTH 32
  ad_ip_parameter axi_regmap CONFIG.NUM_OFFLOAD 1
  ad_ip_parameter axi_regmap CONFIG.ASYNC_SPI_CLK 1
  ad_ip_parameter axi_regmap CONFIG.NUM_OF_SDI $ad463x_num_of_sdi

  ad_ip_instance spi_engine_offload offload
  ad_ip_parameter offload CONFIG.DATA_WIDTH 32
  ad_ip_parameter offload CONFIG.ASYNC_SPI_CLK 1
  ad_ip_parameter offload CONFIG.NUM_OF_SDI $ad463x_num_of_sdi

  ad_ip_instance spi_engine_interconnect interconnect
  ad_ip_parameter interconnect CONFIG.DATA_WIDTH 32
  ad_ip_parameter interconnect CONFIG.NUM_OF_SDI $ad463x_num_of_sdi

  ad_ip_instance axi_pulse_gen cnv_generator
  ad_ip_parameter cnv_generator CONFIG.PULSE_PERIOD $sampling_cycle
  ad_ip_parameter cnv_generator CONFIG.PULSE_WIDTH 1

  create_bd_cell -type module -reference ad463x_axis_reorder data_reorder
  set_property -dict [list CONFIG.NUM_OF_SDI $ad463x_num_of_sdi] [get_bd_cells data_reorder]

  ## internal connections

  # clocks
  #
  ad_connect spi_clk offload/spi_clk
  ad_connect spi_clk offload/ctrl_clk
  ad_connect spi_clk execution/clk
  ad_connect clk axi_regmap/s_axi_aclk
  ad_connect spi_clk axi_regmap/spi_clk
  ad_connect spi_clk interconnect/clk
  ad_connect spi_clk cnv_generator/ext_clk
  ad_connect clk cnv_generator/s_axi_aclk
  ad_connect spi_clk data_reorder/axis_aclk

  # resets
  #
  ad_connect resetn axi_regmap/s_axi_aresetn
  ad_connect axi_regmap/spi_resetn offload/spi_resetn
  ad_connect axi_regmap/spi_resetn execution/resetn
  ad_connect axi_regmap/spi_resetn interconnect/resetn
  ad_connect resetn cnv_generator/s_axi_aresetn
  ad_connect axi_regmap/spi_resetn data_reorder/axis_aresetn

  # interfaces
  #
  ad_connect axi_regmap/spi_engine_offload_ctrl0 offload/spi_engine_offload_ctrl
  ad_connect offload/spi_engine_ctrl interconnect/s0_ctrl
  ad_connect axi_regmap/spi_engine_ctrl interconnect/s1_ctrl
  ad_connect interconnect/m_ctrl execution/ctrl
  ad_connect offload/offload_sdi_valid data_reorder/s_axis_valid
  ad_connect offload/offload_sdi_ready data_reorder/s_axis_ready
  ad_connect offload/offload_sdi_data data_reorder/s_axis_data
  ad_connect execution/spi m_spi

  # synchronization and interrupt
  #
  ad_connect ad463x_busy offload/trigger
  ad_connect cnv cnv_generator/pulse
  ad_connect irq axi_regmap/irq


current_bd_instance /

# dma to receive data stream

ad_ip_instance axi_dmac axi_ad463x_dma
ad_ip_parameter axi_ad463x_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad463x_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad463x_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad463x_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad463x_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad463x_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  sys_cpu_clk spi_ad463x/clk
ad_connect  spi_clk axi_ad463x_dma/s_axis_aclk
ad_connect  sys_cpu_resetn spi_ad463x/resetn
ad_connect  sys_cpu_resetn axi_ad463x_dma/m_dest_axi_aresetn

ad_connect  spi_clk spi_ad463x/spi_clk

ad_connect  spi_ad463x/m_spi ad463x_spi

ad_connect  axi_ad463x_dma/s_axis_valid spi_ad463x/data_reorder/m_axis_valid
ad_connect  axi_ad463x_dma/s_axis_ready spi_ad463x/data_reorder/m_axis_ready
ad_connect  axi_ad463x_dma/s_axis_data  spi_ad463x/data_reorder/m_axis_data

ad_connect  spi_ad463x/trigger ad463x_busy
ad_connect  spi_ad463x/cnv ad463x_cnv

ad_cpu_interconnect 0x44a00000 spi_ad463x/axi_regmap
ad_cpu_interconnect 0x44b00000 spi_ad463x/cnv_generator
ad_cpu_interconnect 0x44a30000 axi_ad463x_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen

ad_cpu_interrupt "ps-13" "mb-13" axi_ad463x_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" /spi_ad463x/irq

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad463x_dma/m_dest_axi

