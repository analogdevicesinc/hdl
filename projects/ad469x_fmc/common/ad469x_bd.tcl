###############################################################################
## Copyright (C) 2020-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 ad469x_spi
create_bd_port -dir O ad469x_spi_cnv
create_bd_port -dir I ad469x_spi_busy

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       1
set num_sdo       1
set sdi_delay     1
set echo_sclk     0

set hier_spi_engine spi_ad469x

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

# To support the 1MSPS (SCLK == 80 MHz), set the spi clock to 160 MHz

ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8
ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

## to setup the sample rate of the system change the PULSE_PERIOD value
## the acutal sample rate will be PULSE_PERIOD * (1/sys_cpu_clk)
set sampling_cycle [expr int(ceil(double($spi_clk_ref_frequency * 1000000) / $adc_sampling_rate))]

ad_ip_instance axi_pwm_gen ad469x_trigger_gen

ad_ip_parameter ad469x_trigger_gen CONFIG.PULSE_0_PERIOD $sampling_cycle
ad_ip_parameter ad469x_trigger_gen CONFIG.PULSE_0_WIDTH 1

ad_connect spi_clk ad469x_trigger_gen/ext_clk
ad_connect $sys_cpu_clk ad469x_trigger_gen/s_axi_aclk
ad_connect sys_cpu_resetn ad469x_trigger_gen/s_axi_aresetn

# trigger to BUSY's negative edge

create_bd_cell -type module -reference sync_bits busy_sync
create_bd_cell -type module -reference ad_edge_detect busy_capture
set_property -dict [list CONFIG.EDGE 1] [get_bd_cells busy_capture]

ad_connect spi_clk busy_capture/clk
ad_connect busy_capture/rst GND

ad_connect busy_sync/out_resetn $hier_spi_engine/${hier_spi_engine}_axi_regmap/spi_resetn
ad_connect spi_clk busy_sync/out_clk
ad_connect busy_sync/in_bits ad469x_spi_busy
ad_connect busy_sync/out_bits busy_capture/signal_in
ad_connect busy_capture/signal_out $hier_spi_engine/trigger

# dma to receive data stream

ad_ip_instance axi_dmac axi_ad469x_dma
ad_ip_parameter axi_ad469x_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad469x_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad469x_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad469x_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad469x_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad469x_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad469x_dma CONFIG.DMA_2D_TRANSFER 0

ad_ip_parameter axi_ad469x_dma CONFIG.DMA_DATA_WIDTH_SRC $data_width
ad_ip_parameter axi_ad469x_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect sys_cpu_clk $hier_spi_engine/clk
ad_connect spi_clk axi_ad469x_dma/s_axis_aclk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn
ad_connect sys_cpu_resetn axi_ad469x_dma/m_dest_axi_aresetn

ad_connect spi_clk $hier_spi_engine/spi_clk
ad_connect $hier_spi_engine/m_spi ad469x_spi
ad_connect axi_ad469x_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE

ad_ip_instance util_vector_logic cnv_gate
ad_ip_parameter cnv_gate CONFIG.C_SIZE 1
ad_ip_parameter cnv_gate CONFIG.C_OPERATION {and}

ad_connect cnv_gate/Op1 axi_ad469x_dma/s_axis_xfer_req
ad_connect cnv_gate/Op2 ad469x_trigger_gen/pwm_0
ad_connect cnv_gate/Res ad469x_spi_cnv

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_ad469x_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen
ad_cpu_interconnect 0x44b00000 ad469x_trigger_gen

ad_cpu_interrupt "ps-13" "mb-13" axi_ad469x_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad469x_dma/m_dest_axi
