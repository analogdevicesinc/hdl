
global adc_spi_freq

# pmod interfaces

create_bd_port -dir O pmod_spi_cs
create_bd_port -dir I pmod_spi_miso
create_bd_port -dir O pmod_spi_clk
create_bd_port -dir O pmod_spi_convst

create_bd_port -dir I pmod_gpio

# instances

set pmod_spi_core [create_bd_cell -type ip -vlnv analog.com:user:util_pmod_adc:1.0 pmod_spi_core]
set_property -dict [list CONFIG.FPGA_CLOCK_MHZ {100}] $pmod_spi_core

set pmod_spi_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 pmod_spi_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $pmod_spi_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $pmod_spi_dma
set_property -dict [list CONFIG.PCORE_ID {0}] $pmod_spi_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $pmod_spi_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $pmod_spi_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $pmod_spi_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $pmod_spi_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $pmod_spi_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $pmod_spi_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $pmod_spi_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {16}] $pmod_spi_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {64}] $pmod_spi_dma

set pmod_gpio_core [create_bd_cell -type ip -vlnv analog.com:user:util_pmod_fmeter:1.0 pmod_gpio_core]

# additional configurations
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7

ad_connect sys_cpu_clk pmod_spi_dma/fifo_wr_clk
ad_connect sys_cpu_clk pmod_spi_core/clk
ad_connect sys_cpu_clk pmod_gpio_core/ref_clk

ad_connect pmod_spi_core/reset sys_rstgen/peripheral_reset

ad_connect  pmod_spi_core/adc_data pmod_spi_dma/fifo_wr_din
ad_connect  pmod_spi_core/adc_valid pmod_spi_dma/fifo_wr_en

ad_connect  pmod_spi_miso   pmod_spi_core/adc_sdo
ad_connect  pmod_spi_clk    pmod_spi_core/adc_sclk
ad_connect  pmod_spi_cs     pmod_spi_core/adc_cs_n
ad_connect  pmod_spi_convst pmod_spi_core/adc_convst_n

ad_connect  pmod_gpio pmod_gpio_core/square_signal

# interrupts
ad_cpu_interrupt ps-13 mb-12  pmod_spi_dma/irq


# cpu / memory interconnects

ad_cpu_interconnect 0x43010000 pmod_spi_dma
ad_cpu_interconnect 0x43C00000 pmod_gpio_core

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk pmod_spi_dma/m_dest_axi

