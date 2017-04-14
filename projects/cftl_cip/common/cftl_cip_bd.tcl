
global adc_spi_freq

# pmod interfaces

create_bd_port -dir O pmod_spi_cs
create_bd_port -dir I pmod_spi_miso
create_bd_port -dir O pmod_spi_clk
create_bd_port -dir O pmod_spi_convst

create_bd_port -dir I pmod_gpio

# instances

ad_ip_instance util_pmod_adc pmod_spi_core
ad_ip_parameter pmod_spi_core CONFIG.FPGA_CLOCK_MHZ 100

ad_ip_instance axi_dmac pmod_spi_dma
ad_ip_parameter pmod_spi_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter pmod_spi_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter pmod_spi_dma CONFIG.ID 0
ad_ip_parameter pmod_spi_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter pmod_spi_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter pmod_spi_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter pmod_spi_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter pmod_spi_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter pmod_spi_dma CONFIG.CYCLIC 0
ad_ip_parameter pmod_spi_dma CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter pmod_spi_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance util_pmod_fmeter pmod_gpio_core

# additional configurations
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 1

ad_connect sys_cpu_clk pmod_spi_dma/fifo_wr_clk
ad_connect sys_cpu_clk pmod_spi_core/clk
ad_connect sys_cpu_clk pmod_gpio_core/ref_clk

ad_connect pmod_spi_core/resetn sys_rstgen/peripheral_aresetn

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

