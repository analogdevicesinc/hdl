# create board design
# default ports

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

create_bd_port -dir I -from 16 -to 0 gpio_i
create_bd_port -dir O -from 16 -to 0 gpio_o
create_bd_port -dir O -from 16 -to 0 gpio_t

# interrupts

create_bd_port -dir I -type intr ps_intr_00
create_bd_port -dir I -type intr ps_intr_01
create_bd_port -dir I -type intr ps_intr_02
create_bd_port -dir I -type intr ps_intr_03
create_bd_port -dir I -type intr ps_intr_04
create_bd_port -dir I -type intr ps_intr_05
create_bd_port -dir I -type intr ps_intr_06
create_bd_port -dir I -type intr ps_intr_07
create_bd_port -dir I -type intr ps_intr_08
create_bd_port -dir I -type intr ps_intr_09
create_bd_port -dir I -type intr ps_intr_10
create_bd_port -dir I -type intr ps_intr_11
create_bd_port -dir I -type intr ps_intr_12
create_bd_port -dir I -type intr ps_intr_13
create_bd_port -dir I -type intr ps_intr_14
create_bd_port -dir I -type intr ps_intr_15

# instance: sys_ps7

set sys_ps7  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 sys_ps7]

# ps7 settings

set_property -dict [list CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V}] $sys_ps7
set_property -dict [list CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V}] $sys_ps7
set_property -dict [list CONFIG.PCW_PACKAGE_NAME {clg225}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {17}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART1_UART1_IO {MIO 12 .. 13}] $sys_ps7
set_property -dict [list CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_RESET_IO {MIO 52}] $sys_ps7
set_property -dict [list CONFIG.PCW_USB0_RESET_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_INTR {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_MODE {REVERSE}] $sys_ps7

# DDR MT41K256M16 HA-125 (32M, 16bit, 8banks)

set_property -dict [list CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.048}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.050}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.241}] $sys_ps7
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.240}] $sys_ps7

set sys_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {16}] $sys_concat_intc

set sys_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $sys_rstgen

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect  sys_200m_clk sys_ps7/FCLK_CLK1
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

# spi connections

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
ad_connect  sys_concat_intc/In15 ps_intr_15
ad_connect  sys_concat_intc/In14 ps_intr_14
ad_connect  sys_concat_intc/In13 ps_intr_13
ad_connect  sys_concat_intc/In12 ps_intr_12
ad_connect  sys_concat_intc/In11 ps_intr_11
ad_connect  sys_concat_intc/In10 ps_intr_10
ad_connect  sys_concat_intc/In9 ps_intr_09
ad_connect  sys_concat_intc/In8 ps_intr_08
ad_connect  sys_concat_intc/In7 ps_intr_07
ad_connect  sys_concat_intc/In6 ps_intr_06
ad_connect  sys_concat_intc/In5 ps_intr_05
ad_connect  sys_concat_intc/In4 ps_intr_04
ad_connect  sys_concat_intc/In3 ps_intr_03
ad_connect  sys_concat_intc/In2 ps_intr_02
ad_connect  sys_concat_intc/In1 ps_intr_01
ad_connect  sys_concat_intc/In0 ps_intr_00

# iic

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main

set axi_iic_main [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_main]

ad_connect  iic_main axi_iic_main/iic
ad_cpu_interconnect 0x41600000 axi_iic_main
ad_cpu_interrupt ps-15 mb-15 axi_iic_main/iic2intc_irpt

# ad9361

create_bd_port -dir I rx_clk_in
create_bd_port -dir I rx_frame_in
create_bd_port -dir I -from 11 -to 0 rx_data_in

create_bd_port -dir O tx_clk_out
create_bd_port -dir O tx_frame_out
create_bd_port -dir O -from 11 -to 0 tx_data_out

create_bd_port -dir O enable
create_bd_port -dir O txnrx
create_bd_port -dir I up_enable
create_bd_port -dir I up_txnrx

# ad9361 core(s)

set axi_ad9361 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361]
set_property -dict [list CONFIG.ID {0}] $axi_ad9361
set_property -dict [list CONFIG.CMOS_OR_LVDS_N {1}] $axi_ad9361
set_property -dict [list CONFIG.MODE_1R1T {1}] $axi_ad9361

set axi_ad9361_dac_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_dac_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.CYCLIC {1}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9361_dac_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {32}] $axi_ad9361_dac_dma

set fir_interpolator [ create_bd_cell -type ip -vlnv analog.com:user:util_fir_int:1.0 fir_interpolator ]
set interp_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 interp_slice ]

set axi_ad9361_adc_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_adc_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {2}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad9361_adc_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {32}]  $axi_ad9361_adc_dma

set fir_decimator [ create_bd_cell -type ip -vlnv analog.com:user:util_fir_dec:1.0 fir_decimator ]
set decim_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 decim_slice ]

# connections

ad_connect  rx_clk_in axi_ad9361/rx_clk_in
ad_connect  rx_frame_in axi_ad9361/rx_frame_in
ad_connect  rx_data_in axi_ad9361/rx_data_in
ad_connect  tx_clk_out axi_ad9361/tx_clk_out
ad_connect  tx_frame_out axi_ad9361/tx_frame_out
ad_connect  tx_data_out axi_ad9361/tx_data_out
ad_connect  enable axi_ad9361/enable
ad_connect  txnrx axi_ad9361/txnrx
ad_connect  up_enable axi_ad9361/up_enable
ad_connect  up_txnrx axi_ad9361/up_txnrx

ad_connect  axi_ad9361/tdd_sync GND
ad_connect  sys_200m_clk axi_ad9361/delay_clk
ad_connect  axi_ad9361/l_clk axi_ad9361/clk

ad_connect axi_ad9361/l_clk fir_decimator/aclk
ad_connect axi_ad9361/adc_data_i0 fir_decimator/channel_0
ad_connect axi_ad9361/adc_data_q0 fir_decimator/channel_1
ad_connect axi_ad9361/adc_valid_i0 fir_decimator/s_axis_data_tvalid
ad_connect axi_ad9361_adc_dma/fifo_wr_din fir_decimator/m_axis_data_tdata
ad_connect axi_ad9361_adc_dma/fifo_wr_en fir_decimator/m_axis_data_tvalid
ad_connect axi_ad9361/up_adc_gpio_out decim_slice/Din
ad_connect fir_decimator/decimate decim_slice/Dout

ad_connect axi_ad9361/l_clk fir_interpolator/aclk
ad_connect axi_ad9361_dac_dma/fifo_rd_dout fir_interpolator/s_axis_data_tdata
ad_connect axi_ad9361_dac_dma/fifo_rd_valid fir_interpolator/s_axis_data_tvalid
ad_connect axi_ad9361/dac_valid_i0 fir_interpolator/dac_read
ad_connect axi_ad9361_dac_dma/fifo_rd_en fir_interpolator/s_axis_data_tready
ad_connect axi_ad9361/dac_data_i0 fir_interpolator/channel_0
ad_connect axi_ad9361/dac_data_q0 fir_interpolator/channel_1
ad_connect axi_ad9361/up_dac_gpio_out interp_slice/Din
ad_connect fir_interpolator/interpolate interp_slice/Dout

ad_connect  axi_ad9361/l_clk axi_ad9361_adc_dma/fifo_wr_clk
ad_connect  axi_ad9361_adc_dma/fifo_wr_overflow axi_ad9361/adc_dovf
ad_connect  axi_ad9361/l_clk axi_ad9361_dac_dma/fifo_rd_clk
ad_connect  axi_ad9361_dac_dma/fifo_rd_underflow axi_ad9361/dac_dunf
ad_connect  axi_ad9361/dac_data_i1 GND
ad_connect  axi_ad9361/dac_data_q1 GND

# interconnects

ad_cpu_interconnect 0x79020000 axi_ad9361
ad_cpu_interconnect 0x7C400000 axi_ad9361_adc_dma
ad_cpu_interconnect 0x7C420000 axi_ad9361_dac_dma
ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9361_adc_dma/m_dest_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9361_dac_dma/m_src_axi
ad_connect  sys_cpu_resetn axi_ad9361_adc_dma/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn axi_ad9361_dac_dma/m_src_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9361_adc_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9361_dac_dma/irq


