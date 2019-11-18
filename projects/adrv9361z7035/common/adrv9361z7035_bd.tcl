
# create board design
# default ports

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main
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

create_bd_port -dir O spi1_csn_2_o
create_bd_port -dir O spi1_csn_1_o
create_bd_port -dir O spi1_csn_0_o
create_bd_port -dir I spi1_csn_i
create_bd_port -dir I spi1_clk_i
create_bd_port -dir O spi1_clk_o
create_bd_port -dir I spi1_sdo_i
create_bd_port -dir O spi1_sdo_o
create_bd_port -dir I spi1_sdi_i

create_bd_port -dir I -from 63 -to 0 gpio_i
create_bd_port -dir O -from 63 -to 0 gpio_o
create_bd_port -dir O -from 63 -to 0 gpio_t

# otg

set otg_vbusoc      [create_bd_port -dir I otg_vbusoc]

# instance: sys_ps7

ad_ip_instance processing_system7 sys_ps7
ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK0_VOLTAGE "LVCMOS 1.8V"
ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK1_VOLTAGE "LVCMOS 1.8V"
ad_ip_parameter sys_ps7 CONFIG.PCW_PACKAGE_NAME fbg676
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_ENET0_IO "MIO 16 .. 27"
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_IO "MIO 52 .. 53"
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET_RESET_SELECT "Separate reset pins"
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_RESET_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_RESET_IO "MIO 8"
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_RESET_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_RESET_IO "MIO 51"
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_GRP_CD_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_GRP_CD_IO "MIO 50"
ad_ip_parameter sys_ps7 CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ 50
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_IO "MIO 7"
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_PARTNO "MT41K256M16 RE-125"
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH "32 Bit"
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF 0
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 -0.053
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 -0.059
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 0.065
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 0.066
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 0.264
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 0.265
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 0.330
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 0.330
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK1_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_RST1_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_RST2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ 100.0
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ 200.0
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 200.0
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_FABRIC_INTERRUPT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_INTR 1
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO 64
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_MODE REVERSE
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_SPI0_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI1_SPI1_IO EMIO

ad_ip_instance axi_iic axi_iic_main
ad_ip_parameter axi_iic_main CONFIG.USE_BOARD_FLOW true
ad_ip_parameter axi_iic_main CONFIG.IIC_BOARD_INTERFACE Custom

ad_ip_instance xlconcat sys_concat_intc
ad_ip_parameter sys_concat_intc CONFIG.NUM_PORTS 16

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_ip_instance util_vector_logic sys_logic_inv
ad_ip_parameter sys_logic_inv CONFIG.C_SIZE 1
ad_ip_parameter sys_logic_inv CONFIG.C_OPERATION not

# system reset/clock definitions

ad_connect sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect sys_200m_clk sys_ps7/FCLK_CLK1
ad_connect sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

# interface connections

ad_connect ddr sys_ps7/DDR
ad_connect gpio_i sys_ps7/GPIO_I
ad_connect gpio_o sys_ps7/GPIO_O
ad_connect gpio_t sys_ps7/GPIO_T
ad_connect fixed_io sys_ps7/FIXED_IO
ad_connect iic_main axi_iic_main/iic
ad_connect sys_logic_inv/Res sys_ps7/USB0_VBUS_PWRFAULT
ad_connect sys_logic_inv/Op1 otg_vbusoc

# spi connections

ad_connect spi0_csn_2_o sys_ps7/SPI0_SS2_O
ad_connect spi0_csn_1_o sys_ps7/SPI0_SS1_O
ad_connect spi0_csn_0_o sys_ps7/SPI0_SS_O
ad_connect spi0_csn_i sys_ps7/SPI0_SS_I
ad_connect spi0_clk_i sys_ps7/SPI0_SCLK_I
ad_connect spi0_clk_o sys_ps7/SPI0_SCLK_O
ad_connect spi0_sdo_i sys_ps7/SPI0_MOSI_I
ad_connect spi0_sdo_o sys_ps7/SPI0_MOSI_O
ad_connect spi0_sdi_i sys_ps7/SPI0_MISO_I

ad_connect spi1_csn_2_o sys_ps7/SPI1_SS2_O
ad_connect spi1_csn_1_o sys_ps7/SPI1_SS1_O
ad_connect spi1_csn_0_o sys_ps7/SPI1_SS_O
ad_connect spi1_csn_i sys_ps7/SPI1_SS_I
ad_connect spi1_clk_i sys_ps7/SPI1_SCLK_I
ad_connect spi1_clk_o sys_ps7/SPI1_SCLK_O
ad_connect spi1_sdo_i sys_ps7/SPI1_MOSI_I
ad_connect spi1_sdo_o sys_ps7/SPI1_MOSI_O
ad_connect spi1_sdi_i sys_ps7/SPI1_MISO_I

# system id

ad_ip_instance axi_sysid axi_sysid_0
ad_ip_instance sysid_rom rom_sys_0

ad_connect  axi_sysid_0/rom_addr   	rom_sys_0/rom_addr
ad_connect  axi_sysid_0/sys_rom_data   	rom_sys_0/rom_data
ad_connect  sys_cpu_clk                 rom_sys_0/clk

# interrupts

ad_connect sys_concat_intc/dout sys_ps7/IRQ_F2P
ad_connect sys_concat_intc/In15 GND
ad_connect sys_concat_intc/In14 axi_iic_main/iic2intc_irpt
ad_connect sys_concat_intc/In13 GND
ad_connect sys_concat_intc/In12 GND
ad_connect sys_concat_intc/In11 GND
ad_connect sys_concat_intc/In10 GND
ad_connect sys_concat_intc/In9  GND
ad_connect sys_concat_intc/In8  GND
ad_connect sys_concat_intc/In7  GND
ad_connect sys_concat_intc/In6  GND
ad_connect sys_concat_intc/In5  GND
ad_connect sys_concat_intc/In4  GND
ad_connect sys_concat_intc/In3  GND
ad_connect sys_concat_intc/In2  GND
ad_connect sys_concat_intc/In1  GND
ad_connect sys_concat_intc/In0  GND

# interconnects

ad_cpu_interconnect 0x45000000 axi_sysid_0
ad_cpu_interconnect 0x41600000 axi_iic_main

# ad9361

create_bd_port -dir O enable
create_bd_port -dir O txnrx
create_bd_port -dir I up_enable
create_bd_port -dir I up_txnrx

create_bd_port -dir O tdd_sync_o
create_bd_port -dir I tdd_sync_i
create_bd_port -dir O tdd_sync_t
create_bd_port -dir I gps_pps

# ad9361 core

ad_ip_instance axi_ad9361 axi_ad9361
ad_ip_parameter axi_ad9361 CONFIG.ID 0
ad_ip_parameter axi_ad9361 CONFIG.DAC_IODELAY_ENABLE 1
ad_connect sys_200m_clk axi_ad9361/delay_clk
ad_connect axi_ad9361/l_clk axi_ad9361/clk
ad_connect enable axi_ad9361/enable
ad_connect txnrx axi_ad9361/txnrx
ad_connect up_enable axi_ad9361/up_enable
ad_connect up_txnrx axi_ad9361/up_txnrx

# tdd-sync

ad_ip_instance util_tdd_sync util_ad9361_tdd_sync
ad_ip_parameter util_ad9361_tdd_sync CONFIG.TDD_SYNC_PERIOD 10000000
ad_connect sys_cpu_clk util_ad9361_tdd_sync/clk
ad_connect sys_cpu_resetn util_ad9361_tdd_sync/rstn
ad_connect util_ad9361_tdd_sync/sync_out axi_ad9361/tdd_sync
ad_connect util_ad9361_tdd_sync/sync_mode axi_ad9361/tdd_sync_cntr
ad_connect tdd_sync_t axi_ad9361/tdd_sync_cntr
ad_connect tdd_sync_o util_ad9361_tdd_sync/sync_out
ad_connect tdd_sync_i util_ad9361_tdd_sync/sync_in
ad_connect gps_pps axi_ad9361/gps_pps

# interface clock divider to generate sampling clock
# interface runs at 4x in 2r2t mode, and 2x in 1r1t mode

ad_ip_instance xlconcat util_ad9361_divclk_sel_concat
ad_ip_parameter util_ad9361_divclk_sel_concat CONFIG.NUM_PORTS 2
ad_connect axi_ad9361/adc_r1_mode util_ad9361_divclk_sel_concat/In0
ad_connect axi_ad9361/dac_r1_mode util_ad9361_divclk_sel_concat/In1

ad_ip_instance util_reduced_logic util_ad9361_divclk_sel
ad_ip_parameter util_ad9361_divclk_sel CONFIG.C_SIZE 2
ad_connect util_ad9361_divclk_sel_concat/dout util_ad9361_divclk_sel/Op1

ad_ip_instance util_clkdiv util_ad9361_divclk
ad_connect util_ad9361_divclk_sel/Res util_ad9361_divclk/clk_sel
ad_connect axi_ad9361/l_clk util_ad9361_divclk/clk

# resets at divided clock

ad_ip_instance proc_sys_reset util_ad9361_divclk_reset
ad_connect sys_rstgen/peripheral_aresetn util_ad9361_divclk_reset/ext_reset_in
ad_connect util_ad9361_divclk/clk_out util_ad9361_divclk_reset/slowest_sync_clk

# adc-path wfifo

ad_ip_instance util_wfifo util_ad9361_adc_fifo
ad_ip_parameter util_ad9361_adc_fifo CONFIG.NUM_OF_CHANNELS 4
ad_ip_parameter util_ad9361_adc_fifo CONFIG.DIN_ADDRESS_WIDTH 4
ad_ip_parameter util_ad9361_adc_fifo CONFIG.DIN_DATA_WIDTH 16
ad_ip_parameter util_ad9361_adc_fifo CONFIG.DOUT_DATA_WIDTH 16
ad_connect axi_ad9361/l_clk util_ad9361_adc_fifo/din_clk
ad_connect axi_ad9361/rst util_ad9361_adc_fifo/din_rst
ad_connect util_ad9361_divclk/clk_out util_ad9361_adc_fifo/dout_clk
ad_connect util_ad9361_divclk_reset/peripheral_aresetn util_ad9361_adc_fifo/dout_rstn
ad_connect axi_ad9361/adc_enable_i0 util_ad9361_adc_fifo/din_enable_0
ad_connect axi_ad9361/adc_valid_i0 util_ad9361_adc_fifo/din_valid_0
ad_connect axi_ad9361/adc_data_i0 util_ad9361_adc_fifo/din_data_0
ad_connect axi_ad9361/adc_enable_q0 util_ad9361_adc_fifo/din_enable_1
ad_connect axi_ad9361/adc_valid_q0 util_ad9361_adc_fifo/din_valid_1
ad_connect axi_ad9361/adc_data_q0 util_ad9361_adc_fifo/din_data_1
ad_connect axi_ad9361/adc_enable_i1 util_ad9361_adc_fifo/din_enable_2
ad_connect axi_ad9361/adc_valid_i1 util_ad9361_adc_fifo/din_valid_2
ad_connect axi_ad9361/adc_data_i1 util_ad9361_adc_fifo/din_data_2
ad_connect axi_ad9361/adc_enable_q1 util_ad9361_adc_fifo/din_enable_3
ad_connect axi_ad9361/adc_valid_q1 util_ad9361_adc_fifo/din_valid_3
ad_connect axi_ad9361/adc_data_q1 util_ad9361_adc_fifo/din_data_3
ad_connect util_ad9361_adc_fifo/din_ovf axi_ad9361/adc_dovf

# adc-path channel pack

ad_ip_instance util_cpack2 util_ad9361_adc_pack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

ad_connect util_ad9361_divclk/clk_out util_ad9361_adc_pack/clk
ad_connect util_ad9361_divclk_reset/peripheral_reset util_ad9361_adc_pack/reset

ad_connect util_ad9361_adc_fifo/dout_valid_0 util_ad9361_adc_pack/fifo_wr_en
ad_connect util_ad9361_adc_pack/fifo_wr_overflow util_ad9361_adc_fifo/dout_ovf

for {set i 0} {$i < 4} {incr i} {
  ad_connect util_ad9361_adc_fifo/dout_enable_${i} util_ad9361_adc_pack/enable_${i}
  ad_connect util_ad9361_adc_fifo/dout_data_${i} util_ad9361_adc_pack/fifo_wr_data_${i}
}

# adc-path dma

ad_ip_instance axi_dmac axi_ad9361_adc_dma
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9361_adc_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9361_adc_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_connect util_ad9361_divclk/clk_out axi_ad9361_adc_dma/fifo_wr_clk
ad_connect util_ad9361_adc_pack/packed_fifo_wr axi_ad9361_adc_dma/fifo_wr
ad_connect sys_cpu_resetn axi_ad9361_adc_dma/m_dest_axi_aresetn

# dac-path rfifo

ad_ip_instance util_rfifo axi_ad9361_dac_fifo
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.DIN_DATA_WIDTH 16
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.DOUT_DATA_WIDTH 16
ad_ip_parameter axi_ad9361_dac_fifo CONFIG.DIN_ADDRESS_WIDTH 4
ad_connect axi_ad9361/l_clk axi_ad9361_dac_fifo/dout_clk
ad_connect axi_ad9361/rst axi_ad9361_dac_fifo/dout_rst
ad_connect util_ad9361_divclk/clk_out axi_ad9361_dac_fifo/din_clk
ad_connect util_ad9361_divclk_reset/peripheral_aresetn axi_ad9361_dac_fifo/din_rstn
ad_connect axi_ad9361_dac_fifo/dout_enable_0 axi_ad9361/dac_enable_i0
ad_connect axi_ad9361_dac_fifo/dout_valid_0 axi_ad9361/dac_valid_i0
ad_connect axi_ad9361_dac_fifo/dout_data_0 axi_ad9361/dac_data_i0
ad_connect axi_ad9361_dac_fifo/dout_enable_1 axi_ad9361/dac_enable_q0
ad_connect axi_ad9361_dac_fifo/dout_valid_1 axi_ad9361/dac_valid_q0
ad_connect axi_ad9361_dac_fifo/dout_data_1 axi_ad9361/dac_data_q0
ad_connect axi_ad9361_dac_fifo/dout_enable_2 axi_ad9361/dac_enable_i1
ad_connect axi_ad9361_dac_fifo/dout_valid_2 axi_ad9361/dac_valid_i1
ad_connect axi_ad9361_dac_fifo/dout_data_2 axi_ad9361/dac_data_i1
ad_connect axi_ad9361_dac_fifo/dout_enable_3 axi_ad9361/dac_enable_q1
ad_connect axi_ad9361_dac_fifo/dout_valid_3 axi_ad9361/dac_valid_q1
ad_connect axi_ad9361_dac_fifo/dout_data_3 axi_ad9361/dac_data_q1
ad_connect axi_ad9361_dac_fifo/dout_unf axi_ad9361/dac_dunf

# dac-path channel unpack

ad_ip_instance util_upack2 util_ad9361_dac_upack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

ad_connect util_ad9361_divclk/clk_out util_ad9361_dac_upack/clk
ad_connect util_ad9361_divclk_reset/peripheral_reset util_ad9361_dac_upack/reset

ad_connect util_ad9361_dac_upack/fifo_rd_en axi_ad9361_dac_fifo/din_valid_0
ad_connect util_ad9361_dac_upack/fifo_rd_underflow axi_ad9361_dac_fifo/din_unf

for {set i 0} {$i < 4} {incr i} {
  ad_connect util_ad9361_dac_upack/enable_$i axi_ad9361_dac_fifo/din_enable_$i
  ad_connect util_ad9361_dac_upack/fifo_rd_valid axi_ad9361_dac_fifo/din_valid_in_$i
  ad_connect util_ad9361_dac_upack/fifo_rd_data_$i axi_ad9361_dac_fifo/din_data_$i
}

# dac-path dma

ad_ip_instance axi_dmac axi_ad9361_dac_dma
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9361_dac_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9361_dac_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9361_dac_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect util_ad9361_divclk/clk_out axi_ad9361_dac_dma/m_axis_aclk
ad_connect axi_ad9361_dac_dma/m_axis util_ad9361_dac_upack/s_axis

ad_connect sys_cpu_resetn axi_ad9361_dac_dma/m_src_axi_aresetn

# interconnects

ad_cpu_interconnect 0x79020000 axi_ad9361
ad_cpu_interconnect 0x7C400000 axi_ad9361_adc_dma
ad_cpu_interconnect 0x7C420000 axi_ad9361_dac_dma
ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9361_adc_dma/m_dest_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9361_dac_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ad9361_adc_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9361_dac_dma/irq
ad_cpu_interrupt ps-11 mb-11 axi_ad9361/gps_pps_irq

## customization of core to disable data path logic (less resources)
## interface type - 1R1T (1) or 2R2T (0) (default is 2R2T)
## 2R2T supports 1R1T as a run time option.
## 1R1T allows core to run at a lower rate (1/2 of 2R2T)

set_property CONFIG.MODE_1R1T 0 [get_bd_cells axi_ad9361]

## interface type - CMOS (1) or LVDS (0) (default is LVDS)
## CMOS allows core to run at a lower rate (1/2 of LVDS)

set_property CONFIG.CMOS_OR_LVDS_N 0  [get_bd_cells axi_ad9361]

## data-path disable (global control)- allows removal of DSP functions within the core.
## also removes the corresponding AXI control interface registers

set_property CONFIG.ADC_DATAPATH_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.DAC_DATAPATH_DISABLE 0  [get_bd_cells axi_ad9361]

## data-path disable (individual control)- effective ONLY if DATAPATH_DISABLE is 0x0.

set_property CONFIG.ADC_DATAFORMAT_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.ADC_DCFILTER_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.ADC_IQCORRECTION_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.ADC_USERPORTS_DISABLE 0 [get_bd_cells axi_ad9361]

set_property CONFIG.DAC_DDS_DISABLE 0 [get_bd_cells axi_ad9361]
set_property CONFIG.DAC_IQCORRECTION_DISABLE 0  [get_bd_cells axi_ad9361]
set_property CONFIG.DAC_USERPORTS_DISABLE 0 [get_bd_cells axi_ad9361]

## tdd-disable (control is moved exclusively to GPIO)

set_property CONFIG.TDD_DISABLE 0 [get_bd_cells axi_ad9361]

## lvds/cmos configuration
## core digital interface -- cmos (1) or lvds (0)

proc cfg_ad9361_interface {cmos_or_lvds} {

  if {$cmos_or_lvds eq "LVDS"} {

    set_property CONFIG.CMOS_OR_LVDS_N 0 [get_bd_cells axi_ad9361]

    create_bd_port -dir I rx_clk_in_p
    create_bd_port -dir I rx_clk_in_n
    create_bd_port -dir I rx_frame_in_p
    create_bd_port -dir I rx_frame_in_n
    create_bd_port -dir I -from 5 -to 0 rx_data_in_p
    create_bd_port -dir I -from 5 -to 0 rx_data_in_n

    create_bd_port -dir O tx_clk_out_p
    create_bd_port -dir O tx_clk_out_n
    create_bd_port -dir O tx_frame_out_p
    create_bd_port -dir O tx_frame_out_n
    create_bd_port -dir O -from 5 -to 0 tx_data_out_p
    create_bd_port -dir O -from 5 -to 0 tx_data_out_n

    ad_connect rx_clk_in_p axi_ad9361/rx_clk_in_p
    ad_connect rx_clk_in_n axi_ad9361/rx_clk_in_n
    ad_connect rx_frame_in_p axi_ad9361/rx_frame_in_p
    ad_connect rx_frame_in_n axi_ad9361/rx_frame_in_n
    ad_connect rx_data_in_p axi_ad9361/rx_data_in_p
    ad_connect rx_data_in_n axi_ad9361/rx_data_in_n
    ad_connect tx_clk_out_p axi_ad9361/tx_clk_out_p
    ad_connect tx_clk_out_n axi_ad9361/tx_clk_out_n
    ad_connect tx_frame_out_p axi_ad9361/tx_frame_out_p
    ad_connect tx_frame_out_n axi_ad9361/tx_frame_out_n
    ad_connect tx_data_out_p axi_ad9361/tx_data_out_p
    ad_connect tx_data_out_n axi_ad9361/tx_data_out_n

    return
  }

  if {$cmos_or_lvds eq "CMOS"} {

    set_property CONFIG.CMOS_OR_LVDS_N 1 [get_bd_cells axi_ad9361]

    create_bd_port -dir I rx_clk_in
    create_bd_port -dir I rx_frame_in
    create_bd_port -dir I -from 11 -to 0 rx_data_in
    create_bd_port -dir O tx_clk_out
    create_bd_port -dir O tx_frame_out
    create_bd_port -dir O -from 11 -to 0 tx_data_out

    ad_connect rx_clk_in axi_ad9361/rx_clk_in
    ad_connect rx_frame_in axi_ad9361/rx_frame_in
    ad_connect rx_data_in axi_ad9361/rx_data_in
    ad_connect tx_clk_out axi_ad9361/tx_clk_out
    ad_connect tx_frame_out axi_ad9361/tx_frame_out
    ad_connect tx_data_out axi_ad9361/tx_data_out

    return
  }

}


