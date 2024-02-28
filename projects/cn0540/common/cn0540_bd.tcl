###############################################################################
## Copyright (C) 2017-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 adc_spi
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_cn0540
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_mux
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_vaux1
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_vaux9
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_vaux6
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_vaux15
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_vaux5
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_vaux13

create_bd_port -dir I adc_data_ready

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       1
set num_sdo       1
set sdi_delay     0
set echo_sclk     0

set hier_spi_engine spi_cn0540

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

ad_ip_instance axi_iic axi_iic_cn0540
ad_connect iic_cn0540 axi_iic_cn0540/iic

# Generate a 80MHz spi_clk for the SPI Engine (targeted SCLK is 20MHz)

ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 10
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8

# dma for the ADC

ad_ip_instance axi_dmac axi_cn0540_dma
ad_ip_parameter axi_cn0540_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_cn0540_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_cn0540_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_cn0540_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_cn0540_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_cn0540_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_cn0540_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_cn0540_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_cn0540_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

ad_connect adc_data_ready $hier_spi_engine/trigger
ad_connect axi_cn0540_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE
ad_connect $hier_spi_engine/m_spi adc_spi

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect spi_clk $hier_spi_engine/spi_clk
ad_connect spi_clk axi_cn0540_dma/s_axis_aclk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn
ad_connect sys_cpu_resetn axi_cn0540_dma/m_dest_axi_aresetn

# Xilinx's XADC

ad_ip_instance xadc_wiz xadc_in

ad_ip_parameter xadc_in CONFIG.XADC_STARUP_SELECTION channel_sequencer
ad_ip_parameter xadc_in CONFIG.SEQUENCER_MODE Continuous
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VP_VN true
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VAUXP1_VAUXN1 true
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VAUXP5_VAUXN5 true
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VAUXP6_VAUXN6 true
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VAUXP9_VAUXN9 true
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VAUXP13_VAUXN13 true
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VAUXP15_VAUXN15 true
ad_ip_parameter xadc_in CONFIG.ENABLE_VCCDDRO_ALARM false
ad_ip_parameter xadc_in CONFIG.ENABLE_VCCPAUX_ALARM false
ad_ip_parameter xadc_in CONFIG.ENABLE_VCCPINT_ALARM false
ad_ip_parameter xadc_in CONFIG.EXTERNAL_MUX_CHANNEL VP_VN
ad_ip_parameter xadc_in CONFIG.OT_ALARM false
ad_ip_parameter xadc_in CONFIG.SINGLE_CHANNEL_SELECTION TEMPERATURE
ad_ip_parameter xadc_in CONFIG.USER_TEMP_ALARM false
ad_ip_parameter xadc_in CONFIG.VCCAUX_ALARM false
ad_ip_parameter xadc_in CONFIG.VCCINT_ALARM false

ad_connect xadc_in/Vp_Vn xadc_mux
ad_connect xadc_in/Vaux1 xadc_vaux1
ad_connect xadc_in/Vaux5 xadc_vaux5
ad_connect xadc_in/Vaux6 xadc_vaux6
ad_connect xadc_in/Vaux9 xadc_vaux9
ad_connect xadc_in/Vaux13 xadc_vaux13
ad_connect xadc_in/Vaux15 xadc_vaux15

# AXI address definitions

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_cn0540_dma
ad_cpu_interconnect 0x44a40000 axi_iic_cn0540
ad_cpu_interconnect 0x44a50000 xadc_in
ad_cpu_interconnect 0x44a70000 spi_clkgen

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" axi_cn0540_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" axi_iic_cn0540/iic2intc_irpt
ad_cpu_interrupt "ps-11" "mb-11" $hier_spi_engine/irq

# memory interconnects

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_cn0540_dma/m_dest_axi
