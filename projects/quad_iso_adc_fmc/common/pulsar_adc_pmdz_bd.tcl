source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 qadc_spi

create_bd_port -dir I -from 3 -to 0 qadc_drdy

#create_bd_port -dir O -from 1 -to 0 qadc_muxa
#create_bd_port -dir O -from 1 -to 0 qadc_muxb
#create_bd_port -dir O -from 1 -to 0 qadc_muxc
#create_bd_port -dir O -from 1 -to 0 qadc_muxd

create_bd_port -dir I qadc_mclk_refclk
create_bd_port -dir O qadc_xtal2_mclk
#create_bd_port -dir O qadc_sync

set data_width    32
set async_spi_clk 1
set num_cs        4
set num_sdi       4
set sdi_delay     1
set hier_spi_engine spi_pulsar_adc

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $sdi_delay

ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8

ad_ip_instance axi_clkgen mclk_clkgen
ad_ip_parameter mclk_clkgen CONFIG.CLK0_DIV 60
ad_ip_parameter mclk_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter mclk_clkgen CONFIG.VCO_MUL 30

#ad_ip_instance axi_pwm_gen pulsar_adc_trigger_gen
#ad_ip_parameter pulsar_adc_trigger_gen CONFIG.PULSE_0_PERIOD 120
#ad_ip_parameter pulsar_adc_trigger_gen CONFIG.PULSE_0_WIDTH 1

# dma to receive data stream
ad_ip_instance axi_dmac axi_pulsar_adc_dma
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect qadc_mclk_refclk mclk_clkgen/clk
ad_connect qadc_xtal2_mclk mclk_clkgen/clk_0

ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

#ad_connect spi_clk pulsar_adc_trigger_gen/ext_clk
#ad_connect $sys_cpu_clk pulsar_adc_trigger_gen/s_axi_aclk
#ad_connect sys_cpu_resetn pulsar_adc_trigger_gen/s_axi_aresetn
#ad_connect pulsar_adc_trigger_gen/pwm_0  $hier_spi_engine/offload/trigger

ad_connect axi_pulsar_adc_dma/s_axis spi_pulsar_adc/M_AXIS_SAMPLE
ad_connect spi_pulsar_adc/m_spi qadc_spi

ad_connect $sys_cpu_clk spi_pulsar_adc/clk
ad_connect spi_clk spi_pulsar_adc/spi_clk
ad_connect spi_clk axi_pulsar_adc_dma/s_axis_aclk
ad_connect sys_cpu_resetn spi_pulsar_adc/resetn
ad_connect sys_cpu_resetn axi_pulsar_adc_dma/m_dest_axi_aresetn

ad_ip_instance util_reduced_logic drdy_buf
ad_ip_parameter drdy_buf CONFIG.C_OPERATION {and}
ad_ip_parameter drdy_buf CONFIG.C_SIZE 4

ad_connect qadc_drdy drdy_buf/Op1
ad_connect drdy_buf/Res $hier_spi_engine/offload/trigger

ad_ip_instance util_reduced_logic drdy_chk
ad_ip_parameter drdy_chk CONFIG.C_OPERATION {xor}
ad_ip_parameter drdy_chk CONFIG.C_SIZE 4

ad_connect qadc_drdy drdy_chk/Op1
#ad_connect drdy_buf/Res $hier_spi_engine/offload/trigger

ad_cpu_interconnect 0x44a00000 spi_pulsar_adc/axi_regmap
ad_cpu_interconnect 0x44a30000 axi_pulsar_adc_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen
ad_cpu_interconnect 0x44b00000 mclk_clkgen
#ad_cpu_interconnect 0x44b00000 pulsar_adc_trigger_gen

ad_cpu_interrupt "ps-13" "mb-13" axi_pulsar_adc_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" /spi_pulsar_adc/irq

ad_mem_hp0_interconnect sys_cpu_clk axi_pulsar_adc_dma/m_dest_axi
