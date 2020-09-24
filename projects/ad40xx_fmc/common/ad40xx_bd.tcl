
source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set data_width    $ad_project_params(DATA_WIDTH)
set async_spi_clk $ad_project_params(ASYNC_SPI_CLK)
set num_cs        $ad_project_params(NUM_CS)
set num_sdi       $ad_project_params(NUM_SDI)
set sdi_delay     $ad_project_params(SDI_DELAY)

set hier_spi_engine spi_ad40xx

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $sdi_delay

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 ad40xx_spi

# To support the 1.8MSPS (SCLK == 100 MHz), set the spi clock to 200 MHz
#current_bd_instance /

#puts [current_bd_instance]

set_property -dict [list \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ $spi_clk_ref_frequency] [get_bd_cells sys_ps7]

set spi_clk sys_ps7/FCLK_CLK2

ad_ip_instance util_pulse_gen trigger_gen

## to setup the sample rate of the system change the PULSE_PERIOD value
## the acutal sample rate will be PULSE_PERIOD * (1/sys_cpu_clk)
set sampling_cycle [expr int(ceil(double($spi_clk_ref_frequency * 1000000) / $adc_sampling_rate))]
ad_ip_parameter trigger_gen CONFIG.PULSE_PERIOD $sampling_cycle
ad_ip_parameter trigger_gen CONFIG.PULSE_WIDTH 1

ad_connect $spi_clk trigger_gen/clk
ad_connect $hier_spi_engine/axi_regmap/spi_resetn trigger_gen/rstn
ad_connect trigger_gen/load_config GND
ad_connect trigger_gen/pulse_width GND
ad_connect trigger_gen/pulse_period GND
ad_connect trigger_gen/pulse $hier_spi_engine/trigger

# asynchronous SPI clock, to support higher SCLK

# dma to receive data stream
ad_ip_instance axi_dmac axi_ad40xx_dma
ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad40xx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad40xx_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad40xx_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad40xx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_2D_TRANSFER 0

ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_ad40xx_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  sys_cpu_clk $hier_spi_engine/clk
ad_connect  $spi_clk axi_ad40xx_dma/s_axis_aclk
ad_connect  sys_cpu_resetn $hier_spi_engine/resetn
ad_connect  sys_cpu_resetn axi_ad40xx_dma/m_dest_axi_aresetn
ad_connect  $spi_clk $hier_spi_engine/spi_clk
ad_connect  $hier_spi_engine/m_spi ad40xx_spi
ad_connect  axi_ad40xx_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/axi_regmap
ad_cpu_interconnect 0x44a30000 axi_ad40xx_dma

ad_cpu_interrupt "ps-13" "mb-13" axi_ad40xx_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" /$hier_spi_engine/irq

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad40xx_dma/m_dest_axi
