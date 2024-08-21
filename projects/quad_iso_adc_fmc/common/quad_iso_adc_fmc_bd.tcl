source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 qadc_spi

create_bd_port -dir I -from 3 -to 0 qadc_drdy
create_bd_port -dir I               qadc_mclk_refclk
create_bd_port -dir O               qadc_xtal2_mclk

set data_width    32
set async_spi_clk 1
set num_cs        4
set num_sdi       4
set num_sdo       1
set sdi_delay     1
set echo_sclk     0

set hier_spi_engine quad_iso_adc

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk


ad_ip_instance axi_clkgen mclk_clkgen
ad_ip_parameter mclk_clkgen CONFIG.CLK0_DIV 60
ad_ip_parameter mclk_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter mclk_clkgen CONFIG.VCO_MUL 30
# dma to receive data stream
ad_ip_instance axi_dmac axi_qadc_dma
ad_ip_parameter axi_qadc_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_qadc_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_qadc_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_qadc_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_qadc_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_qadc_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_qadc_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_qadc_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_qadc_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect qadc_mclk_refclk mclk_clkgen/clk
ad_connect qadc_xtal2_mclk mclk_clkgen/clk_0



ad_connect axi_qadc_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE
ad_connect $hier_spi_engine/m_spi qadc_spi

ad_connect $sys_cpu_clk $hier_spi_engine/clk
ad_connect mclk_clkgen/clk_0 $hier_spi_engine/spi_clk
ad_connect mclk_clkgen/clk_0 axi_qadc_dma/s_axis_aclk
ad_connect sys_cpu_resetn $hier_spi_engine/resetn
ad_connect sys_cpu_resetn axi_qadc_dma/m_dest_axi_aresetn

ad_ip_instance util_reduced_logic drdy_buf
ad_ip_parameter drdy_buf CONFIG.C_OPERATION {and}
ad_ip_parameter drdy_buf CONFIG.C_SIZE 4

ad_connect qadc_drdy drdy_buf/Op1
ad_connect drdy_buf/Res $hier_spi_engine/trigger

ad_ip_instance util_reduced_logic drdy_chk
ad_ip_parameter drdy_chk CONFIG.C_OPERATION {xor}
ad_ip_parameter drdy_chk CONFIG.C_SIZE 4

ad_connect qadc_drdy drdy_chk/Op1

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_qadc_dma
ad_cpu_interconnect 0x44a70000 mclk_clkgen

ad_cpu_interrupt "ps-13" "mb-13" axi_qadc_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq

ad_mem_hp0_interconnect sys_cpu_clk axi_qadc_dma/m_dest_axi
