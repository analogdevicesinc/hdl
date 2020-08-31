
# ad7768 interface

create_bd_port -dir I adc_clk
create_bd_port -dir I adc_valid
create_bd_port -dir I adc_valid_pp
create_bd_port -dir I adc_sync
create_bd_port -dir I -from 31 -to 0 adc_data
create_bd_port -dir I -from 31 -to 0 adc_data_0
create_bd_port -dir I -from 31 -to 0 adc_data_1
create_bd_port -dir I -from 31 -to 0 adc_data_2
create_bd_port -dir I -from 31 -to 0 adc_data_3
create_bd_port -dir I -from 31 -to 0 adc_data_4
create_bd_port -dir I -from 31 -to 0 adc_data_5
create_bd_port -dir I -from 31 -to 0 adc_data_6
create_bd_port -dir I -from 31 -to 0 adc_data_7
create_bd_port -dir I -from 31 -to 0 adc_gpio_0_i
create_bd_port -dir O -from 31 -to 0 adc_gpio_0_o
create_bd_port -dir O -from 31 -to 0 adc_gpio_0_t
create_bd_port -dir I -from 31 -to 0 adc_gpio_1_i
create_bd_port -dir O -from 31 -to 0 adc_gpio_1_o
create_bd_port -dir O -from 31 -to 0 adc_gpio_1_t

# instances

ad_ip_instance axi_dmac ad7768_dma
ad_ip_parameter ad7768_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad7768_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad7768_dma CONFIG.CYCLIC 0
ad_ip_parameter ad7768_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad7768_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad7768_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad7768_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad7768_dma CONFIG.DMA_DATA_WIDTH_SRC 32

ad_ip_instance axi_dmac ad7768_dma_2
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad7768_dma_2 CONFIG.CYCLIC 0
ad_ip_parameter ad7768_dma_2 CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad7768_dma_2 CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad7768_dma_2 CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_DATA_WIDTH_SRC 256

# ps7-hp1

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 1

# gpio

ad_ip_instance axi_gpio ad7768_gpio
ad_ip_parameter ad7768_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter ad7768_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter ad7768_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter ad7768_gpio CONFIG.C_INTERRUPT_PRESENT 1

# adc-path channel pack

ad_ip_instance util_cpack2 util_ad7768_adc_pack
ad_ip_parameter util_ad7768_adc_pack CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter util_ad7768_adc_pack CONFIG.SAMPLE_DATA_WIDTH 32

ad_connect adc_clk util_ad7768_adc_pack/clk
ad_connect sys_rstgen/peripheral_reset util_ad7768_adc_pack/reset
ad_connect adc_valid_pp util_ad7768_adc_pack/fifo_wr_en

for {set i 0} {$i < 8} {incr i} {
  ad_connect adc_data_$i util_ad7768_adc_pack/fifo_wr_data_$i
}

# axi_generic_adc

ad_ip_instance axi_generic_adc axi_ad7768_adc
ad_ip_parameter axi_ad7768_adc CONFIG.NUM_OF_CHANNELS 8

for {set i 0} {$i < 8} {incr i} {
  ad_ip_instance xlslice xlslice_$i
  set_property -dict [list CONFIG.DIN_FROM $i CONFIG.DIN_WIDTH {8} CONFIG.DOUT_WIDTH {1} CONFIG.DIN_TO $i] [get_bd_cells xlslice_$i]
  ad_connect axi_ad7768_adc/adc_enable xlslice_$i/Din
  ad_connect xlslice_$i/Dout util_ad7768_adc_pack/enable_$i
}

# interconnects

ad_connect  sys_cpu_resetn ad7768_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn ad7768_dma_2/m_dest_axi_aresetn
ad_connect  adc_clk ad7768_dma/fifo_wr_clk
ad_connect  adc_valid ad7768_dma/fifo_wr_en
ad_connect  adc_sync ad7768_dma/fifo_wr_sync
ad_connect  adc_data ad7768_dma/fifo_wr_din
ad_connect  adc_clk ad7768_dma_2/fifo_wr_clk
ad_connect  util_ad7768_adc_pack/packed_fifo_wr ad7768_dma_2/fifo_wr
ad_connect  util_ad7768_adc_pack/fifo_wr_overflow axi_ad7768_adc/adc_dovf
ad_connect  adc_clk axi_ad7768_adc/adc_clk
ad_connect  sys_ps7/FCLK_CLK0 axi_ad7768_adc/s_axi_aclk
ad_connect  adc_gpio_0_i ad7768_gpio/gpio_io_i
ad_connect  adc_gpio_0_o ad7768_gpio/gpio_io_o
ad_connect  adc_gpio_0_t ad7768_gpio/gpio_io_t
ad_connect  adc_gpio_1_i ad7768_gpio/gpio2_io_i
ad_connect  adc_gpio_1_o ad7768_gpio/gpio2_io_o
ad_connect  adc_gpio_1_t ad7768_gpio/gpio2_io_t

# interrupts

ad_cpu_interrupt ps-13 mb-13  ad7768_dma/irq
ad_cpu_interrupt ps-12 mb-12  ad7768_gpio/ip2intc_irpt
ad_cpu_interrupt ps-10 mb-10  ad7768_dma_2/irq

# cpu / memory interconnects

ad_cpu_interconnect 0x7C400000 ad7768_dma
ad_cpu_interconnect 0x7C420000 ad7768_gpio
ad_cpu_interconnect 0x7C480000 ad7768_dma_2
ad_cpu_interconnect 0x43c00000 axi_ad7768_adc

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk ad7768_dma/m_dest_axi
ad_mem_hp1_interconnect sys_cpu_clk ad7768_dma_2/m_dest_axi

