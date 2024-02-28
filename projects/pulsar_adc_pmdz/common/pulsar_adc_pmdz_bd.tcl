###############################################################################
## Copyright (C) 2021-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 pulsar_adc_spi
source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       1
set num_sdo       1
set sdi_delay     1
set echo_sclk     0

set hier_spi_engine spi_pulsar_adc

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8

ad_ip_instance axi_pwm_gen pulsar_adc_trigger_gen
ad_ip_parameter pulsar_adc_trigger_gen CONFIG.PULSE_0_PERIOD 120
ad_ip_parameter pulsar_adc_trigger_gen CONFIG.PULSE_0_WIDTH 1

# dma to receive data stream
ad_ip_instance axi_dmac axi_pulsar_adc_dma
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_DATA_WIDTH_SRC $data_width
ad_ip_parameter axi_pulsar_adc_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

ad_connect spi_clk pulsar_adc_trigger_gen/ext_clk
ad_connect $sys_cpu_clk pulsar_adc_trigger_gen/s_axi_aclk
ad_connect sys_cpu_resetn pulsar_adc_trigger_gen/s_axi_aresetn
ad_connect pulsar_adc_trigger_gen/pwm_0 $hier_spi_engine/trigger

ad_connect axi_pulsar_adc_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE
ad_connect $hier_spi_engine/m_spi pulsar_adc_spi

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect spi_clk $hier_spi_engine/spi_clk
ad_connect spi_clk axi_pulsar_adc_dma/s_axis_aclk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn
ad_connect sys_cpu_resetn axi_pulsar_adc_dma/m_dest_axi_aresetn

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_pulsar_adc_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen
ad_cpu_interconnect 0x44b00000 pulsar_adc_trigger_gen

ad_cpu_interrupt "ps-13" "mb-13" axi_pulsar_adc_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" /$hier_spi_engine/irq

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_pulsar_adc_dma/m_dest_axi
