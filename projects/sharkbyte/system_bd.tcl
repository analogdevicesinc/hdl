###############################################################################
## Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# create board design
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io

create_bd_port -dir O spi0_csn_2_o
create_bd_port -dir O spi0_csn_1_o
create_bd_port -dir O spi0_csn_0_o
create_bd_port -dir I spi0_csn_i
create_bd_port -dir I spi0_clk_i
create_bd_port -dir O spi0_clk_o
create_bd_port -dir I spi0_sdo_i
create_bd_port -dir O spi0_sdo_o
create_bd_port -dir I spi0_sdi_i

create_bd_port -dir I -from 17 -to 0 gpio_i
create_bd_port -dir O -from 17 -to 0 gpio_o
create_bd_port -dir O -from 17 -to 0 gpio_t

# hmcad15xx interface

create_bd_port -dir I -from 7 -to 0 data_in_a1_p
create_bd_port -dir I -from 7 -to 0 data_in_a1_n
create_bd_port -dir I -from 7 -to 0 data_in_a2_p
create_bd_port -dir I -from 7 -to 0 data_in_a2_n

create_bd_port -dir I clk_in_a1_p
create_bd_port -dir I clk_in_a1_n
create_bd_port -dir I clk_in_a2_p
create_bd_port -dir I clk_in_a2_n
create_bd_port -dir I fclk_a1_p
create_bd_port -dir I fclk_a1_n
create_bd_port -dir I fclk_a2_p
create_bd_port -dir I fclk_a2_n

# instance: sys_ps7

ad_ip_instance processing_system7 sys_ps7

# ps7 settings

ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V}
ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V}
ad_ip_parameter sys_ps7 CONFIG.PCW_PACKAGE_NAME clg225
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 1
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP2 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK1_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_RST1_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ 100.0
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ 200.0
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO 18
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI1_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C0_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_UART1_IO {MIO 12 .. 13}
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C1_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_SPI0_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_FABRIC_INTERRUPT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_IO MIO
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_IO {MIO 52}
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_INTR 1
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_MODE REVERSE
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_0_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_9_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_10_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_11_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_48_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_49_PULLUP {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_53_PULLUP {enabled}

# DDR MT41K256M16 HA-125 (32M, 16bit, 8banks)

ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF 0
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 0.048
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 0.050
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 0.241
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 0.240

ad_ip_instance xlconcat sys_concat_intc
ad_ip_parameter sys_concat_intc CONFIG.NUM_PORTS 16

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

# instance: hcmad15xx_a1 dma

ad_ip_instance axi_dmac hmcad15xx_a1_dma
ad_ip_parameter hmcad15xx_a1_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter hmcad15xx_a1_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter hmcad15xx_a1_dma CONFIG.CYCLIC 0
ad_ip_parameter hmcad15xx_a1_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter hmcad15xx_a1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter hmcad15xx_a1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter hmcad15xx_a1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter hmcad15xx_a1_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter hmcad15xx_a1_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter hmcad15xx_a1_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter hmcad15xx_a1_dma CONFIG.MAX_BYTES_PER_BURST 4096

# instance: hcmad15xx_a2 dma

ad_ip_instance axi_dmac hmcad15xx_a2_dma
ad_ip_parameter hmcad15xx_a2_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter hmcad15xx_a2_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter hmcad15xx_a2_dma CONFIG.CYCLIC 0
ad_ip_parameter hmcad15xx_a2_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter hmcad15xx_a2_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter hmcad15xx_a2_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter hmcad15xx_a2_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter hmcad15xx_a2_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter hmcad15xx_a2_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter hmcad15xx_a2_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter hmcad15xx_a2_dma CONFIG.MAX_BYTES_PER_BURST 4096

# instance: axi_hmcad15xx_a1

ad_ip_instance axi_hmcad15xx axi_hmcad15xx_a1_adc
ad_ip_parameter axi_hmcad15xx_a1_adc CONFIG.NUM_CHANNELS 4
ad_ip_parameter axi_hmcad15xx_a1_adc CONFIG.IODELAY_CTRL 0

ad_connect axi_hmcad15xx_a1_adc/s_axi_aclk    sys_cpu_clk
ad_connect axi_hmcad15xx_a1_adc/clk_in_p      clk_in_a1_p
ad_connect axi_hmcad15xx_a1_adc/clk_in_n      clk_in_a1_n
ad_connect axi_hmcad15xx_a1_adc/fclk_p        fclk_a1_p
ad_connect axi_hmcad15xx_a1_adc/fclk_n        fclk_a1_n
ad_connect axi_hmcad15xx_a1_adc/data_in_p     data_in_a1_p
ad_connect axi_hmcad15xx_a1_adc/data_in_n     data_in_a1_n
ad_connect axi_hmcad15xx_a1_adc/delay_clk     sys_ps7/FCLK_CLK1

ad_connect axi_hmcad15xx_a1_adc/adc_clk   hmcad15xx_a1_dma/fifo_wr_clk
ad_connect axi_hmcad15xx_a1_adc/adc_data  hmcad15xx_a1_dma/fifo_wr_din
ad_connect axi_hmcad15xx_a1_adc/adc_valid hmcad15xx_a1_dma/fifo_wr_en
ad_connect axi_hmcad15xx_a1_adc/adc_dovf  hmcad15xx_a1_dma/fifo_wr_overflow

# instance: axi_hmcad15xx_a2

ad_ip_instance axi_hmcad15xx axi_hmcad15xx_a2_adc
ad_ip_parameter axi_hmcad15xx_a2_adc CONFIG.NUM_CHANNELS 4
ad_ip_parameter axi_hmcad15xx_a2_adc CONFIG.IODELAY_CTRL 1

ad_connect axi_hmcad15xx_a2_adc/s_axi_aclk    sys_cpu_clk
ad_connect axi_hmcad15xx_a2_adc/clk_in_p      clk_in_a2_p
ad_connect axi_hmcad15xx_a2_adc/clk_in_n      clk_in_a2_n
ad_connect axi_hmcad15xx_a2_adc/fclk_p        fclk_a2_p
ad_connect axi_hmcad15xx_a2_adc/fclk_n        fclk_a2_n
ad_connect axi_hmcad15xx_a2_adc/data_in_p     data_in_a2_p
ad_connect axi_hmcad15xx_a2_adc/data_in_n     data_in_a2_n
ad_connect axi_hmcad15xx_a2_adc/delay_clk     sys_ps7/FCLK_CLK1

ad_connect axi_hmcad15xx_a2_adc/adc_clk   hmcad15xx_a2_dma/fifo_wr_clk
ad_connect axi_hmcad15xx_a2_adc/adc_data  hmcad15xx_a2_dma/fifo_wr_din
ad_connect axi_hmcad15xx_a2_adc/adc_valid hmcad15xx_a2_dma/fifo_wr_en
ad_connect axi_hmcad15xx_a2_adc/adc_dovf  hmcad15xx_a2_dma/fifo_wr_overflow

ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 150.0
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_RST2_PORT 1

ad_ip_instance proc_sys_reset sys_150m_rstgen
ad_ip_parameter sys_150m_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_connect  sys_ps7/FCLK_CLK2 sys_150m_rstgen/slowest_sync_clk
ad_connect  sys_150m_rstgen/ext_reset_in sys_ps7/FCLK_RESET2_N

#DMA

ad_connect  hmcad15xx_a1_dma/m_dest_axi_aresetn     sys_150m_rstgen/peripheral_aresetn
ad_connect  hmcad15xx_a2_dma/m_dest_axi_aresetn     sys_150m_rstgen/peripheral_aresetn

# system reset/clock definitions

# add external spi

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
#ad_connect sys_200m_clk sys_ps7/FCLK_CLK1
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

# interface connections

ad_connect  ddr sys_ps7/DDR
ad_connect  gpio_i sys_ps7/GPIO_I
ad_connect  gpio_o sys_ps7/GPIO_O
ad_connect  gpio_t sys_ps7/GPIO_T
ad_connect  fixed_io sys_ps7/FIXED_IO

# ps7 spi connections

ad_connect  spi0_csn_2_o sys_ps7/SPI0_SS2_O
ad_connect  spi0_csn_1_o sys_ps7/SPI0_SS1_O
ad_connect  spi0_csn_0_o sys_ps7/SPI0_SS_O
ad_connect  spi0_csn_i sys_ps7/SPI0_SS_I
ad_connect  spi0_clk_i sys_ps7/SPI0_SCLK_I
ad_connect  spi0_clk_o sys_ps7/SPI0_SCLK_O
ad_connect  spi0_sdo_i sys_ps7/SPI0_MOSI_I
ad_connect  spi0_sdo_o sys_ps7/SPI0_MOSI_O
ad_connect  spi0_sdi_i sys_ps7/SPI0_MISO_I

# interrupts

ad_connect  sys_concat_intc/dout sys_ps7/IRQ_F2P
ad_connect  sys_concat_intc/In15 GND
ad_connect  sys_concat_intc/In14 GND
ad_connect  sys_concat_intc/In13 GND
ad_connect  sys_concat_intc/In12 GND
ad_connect  sys_concat_intc/In11 GND
ad_connect  sys_concat_intc/In10 GND
ad_connect  sys_concat_intc/In9 GND
ad_connect  sys_concat_intc/In8 GND
ad_connect  sys_concat_intc/In7 GND
ad_connect  sys_concat_intc/In6 GND
ad_connect  sys_concat_intc/In5 GND
ad_connect  sys_concat_intc/In4 GND
ad_connect  sys_concat_intc/In3 GND
ad_connect  sys_concat_intc/In2 GND
ad_connect  sys_concat_intc/In1 GND
ad_connect  sys_concat_intc/In0 GND

# iic

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main

ad_ip_instance axi_iic axi_iic_main

ad_connect  iic_main axi_iic_main/iic
ad_cpu_interconnect 0x41600000 axi_iic_main
ad_cpu_interrupt ps-15 mb-15 axi_iic_main/iic2intc_irpt

# connections - working here new


# cpu / memory interconnects

ad_cpu_interconnect 0x44A00000 axi_hmcad15xx_a1_adc
ad_cpu_interconnect 0x44A30000 hmcad15xx_a1_dma
ad_cpu_interconnect 0x44A60000 axi_hmcad15xx_a2_adc
ad_cpu_interconnect 0x44A90000 hmcad15xx_a2_dma

# + doua adrese pentru celaltat hmc

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP2 {1}
ad_connect sys_cpu_clk sys_ps7/S_AXI_HP1_ACLK
ad_connect sys_cpu_clk sys_ps7/S_AXI_HP2_ACLK

ad_connect hmcad15xx_a1_dma/m_dest_axi sys_ps7/S_AXI_HP1
create_bd_addr_seg -range 0x20000000 -offset 0x00000000 \
                    [get_bd_addr_spaces hmcad15xx_a1_dma/m_dest_axi] \
                    [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] \
                    SEG_sys_ps7_HP1_DDR_LOWOCM


ad_connect hmcad15xx_a2_dma/m_dest_axi sys_ps7/S_AXI_HP2
create_bd_addr_seg -range 0x20000000 -offset 0x00000000 \
                    [get_bd_addr_spaces hmcad15xx_a2_dma/m_dest_axi] \
                    [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] \
                    SEG_sys_ps7_HP2_DDR_LOWOCM

# add axi interconnect

# ad_mem_hp1_interconnect sys_ps7/FCLK_CLK2 sys_ps7/S_AXI_HP1
# ad_mem_hp1_interconnect sys_ps7/FCLK_CLK2 hmcad15xx_a1_dma/m_dest_axi

# ad_mem_hp2_interconnect sys_ps7/FCLK_CLK2 sys_ps7/S_AXI_HP2
# ad_mem_hp2_interconnect sys_ps7/FCLK_CLK2 hmcad15xx_a2_dma/m_dest_axi

ad_connect sys_cpu_clk hmcad15xx_a1_dma/m_dest_axi_aclk
ad_connect sys_cpu_clk hmcad15xx_a2_dma/m_dest_axi_aclk

#ad_connect sys_cpu_resetn hmcad15xx_a1_dma/m_dest_axi_aresetn
#ad_connect sys_cpu_resetn hmcad15xx_a2_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-12 mb-12 hmcad15xx_a1_dma/irq
ad_cpu_interrupt ps-13 mb-12 hmcad15xx_a2_dma/irq