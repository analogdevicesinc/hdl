# ad9434 interface

set adc_clk_p   [create_bd_port -dir I adc_clk_p]
set adc_clk_n   [create_bd_port -dir I adc_clk_n]
set adc_data_p  [create_bd_port -dir I -from 11 -to 0 adc_data_p]
set adc_data_n  [create_bd_port -dir I -from 11 -to 0 adc_data_n]
set adc_or_p    [create_bd_port -dir I adc_or_p]
set adc_or_n    [create_bd_port -dir I adc_or_n]

# spi interface

set spi_clk_i       [create_bd_port -dir I spi_clk_i]
set spi_clk_o       [create_bd_port -dir O spi_clk_o]
set spi_csn_i       [create_bd_port -dir I spi_csn_i]
set spi_csn_adc_o   [create_bd_port -dir O spi_csn_adc_o]
set spi_csn_clk_o   [create_bd_port -dir O spi_csn_clk_o]
set spi_mosi_i      [create_bd_port -dir I spi_mosi_i]
set spi_mosi_o      [create_bd_port -dir O spi_mosi_o]
set spi_miso_i      [create_bd_port -dir I spi_miso_i]

# ad9434

set axi_ad9434  [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9434:1.0 axi_ad9434]

# dma for ad9434

set axi_ad9434_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9434_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_SRC_DEST {1}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_REQ_SRC {1}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_ad9434_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {64}]  $axi_ad9434_dma

# dma interconnect

set axi_ad9434_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ad9434_dma_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_ad9434_dma_interconnect

# additions to default configuration

set_property -dict [list CONFIG.NUM_MI {9}] $axi_cpu_interconnect

set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {15}] $sys_ps7

set_property LEFT 14 [get_bd_ports GPIO_I]
set_property LEFT 14 [get_bd_ports GPIO_O]
set_property LEFT 14 [get_bd_ports GPIO_T]

# spi connections

connect_bd_net -net spi_csn_i       [get_bd_ports spi_csn_i]      [get_bd_pins sys_ps7/SPI0_SS_I]
connect_bd_net -net spi_csn_adc_o   [get_bd_ports spi_csn_adc_o]  [get_bd_pins sys_ps7/SPI0_SS_O]
connect_bd_net -net spi_csn_clk_o   [get_bd_ports spi_csn_clk_o]  [get_bd_pins sys_ps7/SPI0_SS1_O]
connect_bd_net -net spi_clk_i       [get_bd_ports spi_clk_i]      [get_bd_pins sys_ps7/SPI0_SCLK_I]
connect_bd_net -net spi_clk_o       [get_bd_ports spi_clk_o]      [get_bd_pins sys_ps7/SPI0_SCLK_O]
connect_bd_net -net spi_mosi_i      [get_bd_ports spi_mosi_i]     [get_bd_pins sys_ps7/SPI0_MOSI_I]
connect_bd_net -net spi_mosi_o      [get_bd_ports spi_mosi_o]     [get_bd_pins sys_ps7/SPI0_MOSI_O]
connect_bd_net -net spi_miso_i      [get_bd_ports spi_miso_i]     [get_bd_pins sys_ps7/SPI0_MISO_I]

# ad9434 connections

connect_bd_net -net sys_200m_clk          [get_bd_pins axi_ad9434/delay_clk]
connect_bd_net -net axi_ad9434_clk        [get_bd_pins axi_ad9434/adc_clk]
connect_bd_net -net axi_ad9434_clk        [get_bd_pins axi_ad9434_dma/fifo_wr_clk]

connect_bd_net -net axi_ad9434_clk_in_p   [get_bd_ports adc_clk_p]            [get_bd_pins axi_ad9434/adc_clk_in_p]
connect_bd_net -net axi_ad9434_clk_in_n   [get_bd_ports adc_clk_n]            [get_bd_pins axi_ad9434/adc_clk_in_n]
connect_bd_net -net axi_ad9434_data_in_p  [get_bd_ports adc_data_p]           [get_bd_pins axi_ad9434/adc_data_in_p]
connect_bd_net -net axi_ad9434_data_in_n  [get_bd_ports adc_data_n]           [get_bd_pins axi_ad9434/adc_data_in_n]
connect_bd_net -net axi_ad9434_or_in_p    [get_bd_ports adc_or_p]             [get_bd_pins axi_ad9434/adc_or_in_p]
connect_bd_net -net axi_ad9434_or_in_n    [get_bd_ports adc_or_n]             [get_bd_pins axi_ad9434/adc_or_in_n]

connect_bd_net -net axi_ad9434_denable    [get_bd_pins axi_ad9434/adc_valid]  [get_bd_pins axi_ad9434_dma/fifo_wr_en]
connect_bd_net -net axi_ad9434_data       [get_bd_pins axi_ad9434/adc_data]   [get_bd_pins axi_ad9434_dma/fifo_wr_din]
connect_bd_net -net axi_ad9434_ovf        [get_bd_pins axi_ad9434/adc_dovf]   [get_bd_pins axi_ad9434_dma/fifo_wr_overflow]

connect_bd_net -net axi_ad9434_dma_irq    [get_bd_pins axi_ad9434_dma/irq]    [get_bd_pins sys_concat_intc/In2]

# cpu interconnect

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_ad9434/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_ad9434_dma/s_axi]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9434/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9434_dma/s_axi_aclk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9434/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9434_dma/s_axi_aresetn]

# memory inteconnect

set dma_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]
connect_bd_net -net dma_clk $dma_clk_source

connect_bd_intf_net -intf_net axi_ad9434_dma_interconnect_s00_axi [get_bd_intf_pins axi_ad9434_dma_interconnect/S00_AXI] [get_bd_intf_pins axi_ad9434_dma/m_dest_axi]
connect_bd_intf_net -intf_net axi_ad9434_dma_interconnect_m00_axi [get_bd_intf_pins axi_ad9434_dma_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
connect_bd_net -net dma_clk [get_bd_pins axi_ad9434_dma_interconnect/ACLK] $dma_clk_source
connect_bd_net -net dma_clk [get_bd_pins axi_ad9434_dma_interconnect/M00_ACLK] $dma_clk_source
connect_bd_net -net dma_clk [get_bd_pins axi_ad9434_dma_interconnect/S00_ACLK] $dma_clk_source
connect_bd_net -net dma_clk [get_bd_pins axi_ad9434_dma/m_dest_axi_aclk]
connect_bd_net -net dma_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9434_dma_interconnect/ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9434_dma_interconnect/M00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9434_dma_interconnect/S00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9434_dma/m_dest_axi_aresetn] $sys_100m_resetn_source

# address map

create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9434/s_axi/axi_lite]      SEG_data_ad9434_core
create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9434_dma/s_axi/axi_lite]  SEG_data_ad9434_dma
create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_ad9434_dma/m_dest_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm

