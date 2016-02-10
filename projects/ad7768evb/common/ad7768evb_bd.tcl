
# ad7768 interface

create_bd_port -dir I adc_clk
create_bd_port -dir I adc_valid
create_bd_port -dir I -from 31 -to 0 adc_data
create_bd_port -dir I -from 31 -to 0 adc_gpio_0_i
create_bd_port -dir O -from 31 -to 0 adc_gpio_0_o
create_bd_port -dir O -from 31 -to 0 adc_gpio_0_t
create_bd_port -dir I -from 31 -to 0 adc_gpio_1_i
create_bd_port -dir O -from 31 -to 0 adc_gpio_1_o
create_bd_port -dir O -from 31 -to 0 adc_gpio_1_t

# instances

set ad7768_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 ad7768_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $ad7768_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $ad7768_dma
set_property -dict [list CONFIG.CYCLIC {0}] $ad7768_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $ad7768_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $ad7768_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $ad7768_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $ad7768_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {32}] $ad7768_dma

# ps7-hp1

set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7

# gpio

set ad7768_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 ad7768_gpio]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $ad7768_gpio
set_property -dict [list CONFIG.C_GPIO_WIDTH {32}] $ad7768_gpio
set_property -dict [list CONFIG.C_GPIO2_WIDTH {32}] $ad7768_gpio
set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] $ad7768_gpio

# interconnects

ad_connect  adc_clk ad7768_dma/fifo_wr_clk
ad_connect  adc_valid ad7768_dma/fifo_wr_en
ad_connect  adc_data ad7768_dma/fifo_wr_din
ad_connect  adc_gpio_0_i ad7768_gpio/gpio_io_i
ad_connect  adc_gpio_0_o ad7768_gpio/gpio_io_o
ad_connect  adc_gpio_0_t ad7768_gpio/gpio_io_t
ad_connect  adc_gpio_1_i ad7768_gpio/gpio2_io_i
ad_connect  adc_gpio_1_o ad7768_gpio/gpio2_io_o
ad_connect  adc_gpio_1_t ad7768_gpio/gpio2_io_t

# interrupts

ad_cpu_interrupt ps-13 mb-13  ad7768_dma/irq
ad_cpu_interrupt ps-12 mb-12  ad7768_gpio/ip2intc_irpt

# cpu / memory interconnects

ad_cpu_interconnect 0x7C400000 ad7768_dma
ad_cpu_interconnect 0x7C420000 ad7768_gpio

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk ad7768_dma/m_dest_axi

