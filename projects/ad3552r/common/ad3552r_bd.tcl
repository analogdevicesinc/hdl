
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 ad3552r_dac_spi

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       4
set num_sdo       4
set sdi_delay     1
set hier_spi_engine spi_ad3552r_dac

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay

ad_ip_instance axi_dds spi_dds
ad_connect spi_clk spi_dds/spi_clk

#ad_connect $hier_spi_engine/offload/offload_sdo spi_dds/m_axis_dds

#ad_connect spi_dds/dac_dunf GND
#ad_connect spi_dds/dac_data GND
#ad_connect spi_dds/dac_sync_in_0 GND

ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 10
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 12

ad_ip_instance axi_pwm_gen pulsar_adc_trigger_gen
ad_ip_parameter pulsar_adc_trigger_gen CONFIG.PULSE_0_PERIOD 120
ad_ip_parameter pulsar_adc_trigger_gen CONFIG.PULSE_0_WIDTH 1

#ad_ip_instance axis_interconnect axis_interconnect_0
#ad_ip_parameter axis_interconnect_0 CONFIG.NUM_SI 2
#ad_ip_parameter axis_interconnect_0 CONFIG.NUM_MI 1
#ad_ip_parameter axis_interconnect_0 CONFIG.ROUTING_MODE 1

ad_ip_instance axi_dmac axi_dac_dma
ad_ip_parameter axi_dac_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_dac_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_dac_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_dac_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_dac_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_dac_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_dac_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_dac_dma CONFIG.DMA_DATA_WIDTH_SRC 32 ;#$data_width
ad_ip_parameter axi_dac_dma CONFIG.DMA_DATA_WIDTH_DEST 32

#ad_ip_instance proc_sys_reset spi_120m_rstgen
#ad_ip_parameter spi_120m_rstgen CONFIG.C_EXT_RST_WIDTH 1

#ad_connect spi_resetn spi_120m_rstgen/peripheral_aresetn
#ad_connect spi_clk spi_120m_rstgen/slowest_sync_clk
#ad_connect sys_ps7/FCLK_RESET0_N spi_120m_rstgen/ext_reset_in

ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

ad_connect spi_clk pulsar_adc_trigger_gen/ext_clk
ad_connect $sys_cpu_clk pulsar_adc_trigger_gen/s_axi_aclk
ad_connect sys_cpu_resetn pulsar_adc_trigger_gen/s_axi_aresetn
ad_connect pulsar_adc_trigger_gen/pwm_0  $hier_spi_engine/trigger

ad_connect $hier_spi_engine/m_spi ad3552r_dac_spi

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect spi_clk $hier_spi_engine/spi_clk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn
ad_connect sys_cpu_resetn axi_dac_dma/m_src_axi_aresetn
ad_connect spi_clk axi_dac_dma/m_axis_aclk

ad_connect $hier_spi_engine/s_axis_sample_0 axi_dac_dma/m_axis
ad_connect $hier_spi_engine/s_axis_sample_1 spi_dds/m_axis_dds

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_dac_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen
ad_cpu_interconnect 0x44b00000 pulsar_adc_trigger_gen
ad_cpu_interconnect 0x44c00000 spi_dds
#ad_cpu_interconnect 0x44d00000 axis_interconnect_0

ad_cpu_interrupt "ps-13" "mb-13" axi_dac_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" /$hier_spi_engine/irq

ad_mem_hp0_interconnect sys_cpu_clk axi_dac_dma/m_src_axi
