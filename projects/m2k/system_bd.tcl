###############################################################################
## Copyright (C) 2014-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_msg_config -id {PSU-1} -new_severity {WARNING}

add_files -norecurse  $ad_hdl_dir/library/util_cdc/sync_bits.v
add_files -norecurse  $ad_hdl_dir/library/util_cdc/sync_event.v

set DEBUG_BUILD 0
set DISABLE_DMAC_DEBUG [expr !$DEBUG_BUILD]

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

create_bd_port -dir I -from 16 -to 0 gpio_i
create_bd_port -dir O -from 16 -to 0 gpio_o
create_bd_port -dir O -from 16 -to 0 gpio_t

create_bd_port -dir I -from 15 -to 0  data_i
create_bd_port -dir I -from  1 -to 0  trigger_i

create_bd_port -dir O -from 15 -to 0 data_o
create_bd_port -dir O -from 15 -to 0 data_t
create_bd_port -dir O -from  1 -to 0 trigger_o
create_bd_port -dir O -from  1 -to 0 trigger_t

create_bd_port -dir I rx_clk
create_bd_port -dir I rxiq
create_bd_port -dir I -from 11 -to 0 rxd
create_bd_port -dir I tx_clk
create_bd_port -dir O txiq
create_bd_port -dir O -from 11 -to 0 txd

# instance: sys_ps7

ad_ip_instance processing_system7 sys_ps7

ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V}
ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V}
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_PACKAGE_NAME {clg225}
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP2 {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO {17}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_UART1_IO {MIO 12 .. 13}
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_SPI0_IO {EMIO}
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_FABRIC_INTERRUPT {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO}
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_IO {MIO 52}
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_ENABLE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_INTR {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_MODE {REVERSE}

# Clock the whole system of the DDR PLL, disable ARM and IO PLL
# * PLL: 1000 MHz
# * DDR: 500 MHz (2.0Gb/s),
# * CPU: 500 MHz (downclocked to 250 MHz when idle)

ad_ip_parameter sys_ps7 CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_UART_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {DDR PLL}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {500}
ad_ip_parameter sys_ps7 CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {500}
ad_ip_parameter sys_ps7 CONFIG.PCW_OVERRIDE_BASIC_CLOCK {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5}
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {20}
ad_ip_parameter sys_ps7 CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {16}
ad_ip_parameter sys_ps7 CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {6}
ad_ip_parameter sys_ps7 CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {40}
ad_ip_parameter sys_ps7 CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {40}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {6}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {6}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {6}
ad_ip_parameter sys_ps7 CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {3}
ad_ip_parameter sys_ps7 CONFIG.PCW_IOPLL_CTRL_FBDIV {30}
ad_ip_parameter sys_ps7 CONFIG.PCW_ARMPLL_CTRL_FBDIV {30}
ad_ip_parameter sys_ps7 CONFIG.PCW_DDRPLL_CTRL_FBDIV {30}

# AXI control interface and logic analyzer DMA (FCLK0): 27.8 MHz
# Converter DMA (FCLK3): 55.6 MHz

ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK3_PORT {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {27.778}
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {55.556}

# DDR MT41K256M16 HA-125 (32M, 16bit, 8banks)

ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.048}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.050}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.241}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.240}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {500.0}

# add instances

ad_ip_instance axi_iic axi_iic_main

ad_ip_instance ilconcat sys_concat_intc
ad_ip_parameter sys_concat_intc CONFIG.NUM_PORTS 16

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

ad_connect converter_dma_clk sys_ps7/FCLK_CLK3

# interface connections

ad_connect  ddr sys_ps7/DDR
ad_connect  gpio_i sys_ps7/GPIO_I
ad_connect  gpio_o sys_ps7/GPIO_O
ad_connect  gpio_t sys_ps7/GPIO_T
ad_connect  fixed_io sys_ps7/FIXED_IO
ad_connect  iic_main axi_iic_main/iic

# add instances

ad_ip_instance axi_logic_analyzer logic_analyzer

ad_ip_instance util_var_fifo la_trigger_fifo
ad_ip_parameter la_trigger_fifo CONFIG.DATA_WIDTH 16
ad_ip_parameter la_trigger_fifo CONFIG.ADDRESS_WIDTH 13

ad_ip_instance blk_mem_gen bram_la
ad_ip_parameter bram_la CONFIG.use_bram_block {Stand_Alone}
ad_ip_parameter bram_la CONFIG.Memory_Type {Simple_Dual_Port_RAM}
ad_ip_parameter bram_la CONFIG.Assume_Synchronous_Clk {true}
ad_ip_parameter bram_la CONFIG.Algorithm {Low_Power}
ad_ip_parameter bram_la CONFIG.Use_Byte_Write_Enable {false}
ad_ip_parameter bram_la CONFIG.Operating_Mode_A {NO_CHANGE}
ad_ip_parameter bram_la CONFIG.Register_PortB_Output_of_Memory_Primitives {true}
ad_ip_parameter bram_la CONFIG.Port_B_Clock {100}
ad_ip_parameter bram_la CONFIG.Port_B_Enable_Rate {100}
ad_ip_parameter bram_la CONFIG.Write_Width_A {16}
ad_ip_parameter bram_la CONFIG.Write_Width_B {16}
ad_ip_parameter bram_la CONFIG.Read_Width_B {16}
ad_ip_parameter bram_la CONFIG.Write_Depth_A {8192}

ad_ip_instance axi_dmac logic_analyzer_dmac
ad_ip_parameter logic_analyzer_dmac CONFIG.DMA_DATA_WIDTH_SRC 16
ad_ip_parameter logic_analyzer_dmac CONFIG.DMA_AXI_PROTOCOL_DEST 1
ad_ip_parameter logic_analyzer_dmac CONFIG.SYNC_TRANSFER_START true
ad_ip_parameter logic_analyzer_dmac CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_dmac pattern_generator_dmac
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_TYPE_DEST 2
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter pattern_generator_dmac CONFIG.MAX_BYTES_PER_BURST 128
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_AXI_PROTOCOL_SRC 1
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_DATA_WIDTH_DEST 16
ad_ip_parameter pattern_generator_dmac CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter pattern_generator_dmac CONFIG.CYCLIC true
ad_ip_parameter pattern_generator_dmac CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_ad9963 axi_ad9963
ad_ip_parameter axi_ad9963 CONFIG.DAC_DATAPATH_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_USERPORTS_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_DATAFORMAT_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_DCFILTER_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_IQCORRECTION_DISABLE 1
ad_ip_parameter axi_ad9963 CONFIG.ADC_SCALECORRECTION_ONLY 1

ad_ip_instance util_var_fifo adc_trigger_fifo
ad_ip_parameter adc_trigger_fifo CONFIG.DATA_WIDTH 32
ad_ip_parameter adc_trigger_fifo CONFIG.ADDRESS_WIDTH 13

ad_ip_instance blk_mem_gen bram_adc
ad_ip_parameter bram_adc CONFIG.use_bram_block {Stand_Alone}
ad_ip_parameter bram_adc CONFIG.Memory_Type {Simple_Dual_Port_RAM}
ad_ip_parameter bram_adc CONFIG.Assume_Synchronous_Clk true
ad_ip_parameter bram_adc CONFIG.Algorithm {Low_Power}
ad_ip_parameter bram_adc CONFIG.Enable_32bit_Address false
ad_ip_parameter bram_adc CONFIG.Use_Byte_Write_Enable false
ad_ip_parameter bram_adc CONFIG.Operating_Mode_A {NO_CHANGE}
ad_ip_parameter bram_adc CONFIG.Register_PortB_Output_of_Memory_Primitives true
ad_ip_parameter bram_adc CONFIG.Port_B_Clock 100
ad_ip_parameter bram_adc CONFIG.Port_B_Enable_Rate 100
ad_ip_parameter bram_adc CONFIG.Write_Width_A 32
ad_ip_parameter bram_adc CONFIG.Write_Width_B 32
ad_ip_parameter bram_adc CONFIG.Read_Width_B 32
ad_ip_parameter bram_adc CONFIG.Write_Depth_A 8192

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat ad9963_adc_concat

ad_ip_instance axi_dmac ad9963_adc_dmac
ad_ip_parameter ad9963_adc_dmac CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter ad9963_adc_dmac CONFIG.DMA_AXI_PROTOCOL_DEST 1
ad_ip_parameter ad9963_adc_dmac CONFIG.SYNC_TRANSFER_START true
ad_ip_parameter ad9963_adc_dmac CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_dmac ad9963_dac_dmac_a
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_AXI_PROTOCOL_SRC 1
ad_ip_parameter ad9963_dac_dmac_a CONFIG.MAX_BYTES_PER_BURST 128
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_DATA_WIDTH_DEST 16
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter ad9963_dac_dmac_a CONFIG.CYCLIC {true}
ad_ip_parameter ad9963_dac_dmac_a CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_dmac ad9963_dac_dmac_b
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_AXI_PROTOCOL_SRC 1
ad_ip_parameter ad9963_dac_dmac_b CONFIG.MAX_BYTES_PER_BURST 128
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_DATA_WIDTH_DEST 16
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter ad9963_dac_dmac_b CONFIG.CYCLIC {true}
ad_ip_parameter ad9963_dac_dmac_b CONFIG.DISABLE_DEBUG_REGISTERS $DISABLE_DMAC_DEBUG

ad_ip_instance axi_adc_trigger adc_trigger

ad_ip_instance axi_adc_decimate axi_adc_decimate
ad_ip_parameter axi_adc_decimate CONFIG.CORRECTION_DISABLE {0}

ad_ip_instance axi_dac_interpolate axi_dac_interpolate
ad_ip_parameter axi_dac_interpolate CONFIG.CORRECTION_DISABLE {0}

ad_ip_instance proc_sys_reset logic_analyzer_reset

ad_ip_instance axi_rd_wr_combiner axi_rd_wr_combiner_logic
ad_ip_instance axi_rd_wr_combiner axi_rd_wr_combiner_converter

create_bd_cell -type module -reference sync_event cdc_adc_trig_sync
create_bd_cell -type module -reference sync_event cdc_la_trig_sync

# logic analyzer & la_trigger_fifo connections

ad_connect data_i     logic_analyzer/data_i
ad_connect trigger_i  logic_analyzer/trigger_i
ad_connect data_o     logic_analyzer/data_o
ad_connect data_t     logic_analyzer/data_t

ad_connect axi_ad9963/adc_clk logic_analyzer/clk
ad_connect logic_analyzer_clk logic_analyzer/clk_out

ad_connect logic_analyzer_clk pattern_generator_dmac/fifo_rd_clk

ad_connect logic_analyzer_clk la_trigger_fifo/clk
ad_connect logic_analyzer_clk bram_la/clkb
ad_connect logic_analyzer_clk bram_la/clka
ad_connect logic_analyzer_clk logic_analyzer_dmac/fifo_wr_clk
ad_connect logic_analyzer_clk logic_analyzer_reset/slowest_sync_clk
ad_connect logic_analyzer_reset/ext_reset_in sys_rstgen/peripheral_aresetn
ad_connect logic_analyzer_reset/bus_struct_reset la_trigger_fifo/rst

ad_connect la_trigger_fifo/data_in        logic_analyzer/adc_data
ad_connect la_trigger_fifo/data_in_valid  logic_analyzer/adc_valid

ad_connect bram_la/addra                    la_trigger_fifo/addr_w
ad_connect bram_la/dina                     la_trigger_fifo/din_w
ad_connect bram_la/ena                      la_trigger_fifo/en_w
ad_connect bram_la/wea                      la_trigger_fifo/wea_w
ad_connect bram_la/addrb                    la_trigger_fifo/addr_r
ad_connect bram_la/doutb                    la_trigger_fifo/dout_r
ad_connect bram_la/enb                      la_trigger_fifo/en_r

ad_connect logic_analyzer_dmac/fifo_wr_din  la_trigger_fifo/data_out
ad_connect logic_analyzer_dmac/fifo_wr_en   la_trigger_fifo/data_out_valid

ad_connect logic_analyzer/fifo_depth la_trigger_fifo/depth

ad_connect logic_analyzer/trigger_out logic_analyzer_dmac/sync
ad_connect logic_analyzer/trigger_in adc_trigger/trigger_out_la

ad_connect pattern_generator_dmac/fifo_rd_en      logic_analyzer/dac_read
ad_connect pattern_generator_dmac/fifo_rd_dout    logic_analyzer/dac_data
ad_connect pattern_generator_dmac/fifo_rd_valid   logic_analyzer/dac_valid

# axi_ad9963 connections

ad_connect axi_ad9963/adc_clk  adc_trigger_fifo/clk
ad_connect axi_adc_decimate/adc_clk axi_ad9963/adc_clk
ad_connect axi_adc_decimate/adc_rst axi_ad9963/adc_rst

ad_connect ad9963_adc_dmac/fifo_wr_clk     axi_ad9963/adc_clk
ad_connect bram_adc/clka                   axi_ad9963/adc_clk
ad_connect bram_adc/clkb                   axi_ad9963/adc_clk

ad_connect axi_ad9963/adc_rst    adc_trigger_fifo/rst

ad_connect axi_adc_decimate/adc_data_a axi_ad9963/adc_data_i
ad_connect axi_adc_decimate/adc_data_b axi_ad9963/adc_data_q
ad_connect axi_adc_decimate/adc_valid_a axi_ad9963/adc_valid_i
ad_connect axi_adc_decimate/adc_valid_b axi_ad9963/adc_valid_q

# adc_trigger_fifo connections

ad_connect adc_trigger_fifo/din_w       bram_adc/dina
ad_connect adc_trigger_fifo/en_w        bram_adc/ena
ad_connect adc_trigger_fifo/wea_w       bram_adc/wea
ad_connect adc_trigger_fifo/addr_w      bram_adc/addra
ad_connect bram_adc/addrb               adc_trigger_fifo/addr_r
ad_connect bram_adc/doutb               adc_trigger_fifo/dout_r
ad_connect bram_adc/enb                 adc_trigger_fifo/en_r

ad_connect adc_trigger/data_a_trig       ad9963_adc_concat/In0
ad_connect adc_trigger/data_b_trig       ad9963_adc_concat/In1
ad_connect adc_trigger/data_valid_a_trig adc_trigger_fifo/data_in_valid
ad_connect ad9963_adc_concat/dout        adc_trigger_fifo/data_in
ad_connect axi_ad9963/adc_rst            adc_trigger/reset

ad_connect adc_trigger_fifo/depth        adc_trigger/fifo_depth

ad_connect adc_trigger/trigger_in        logic_analyzer/trigger_out_adc

ad_connect adc_trigger_fifo/data_out        ad9963_adc_dmac/fifo_wr_din
ad_connect adc_trigger/trigger_out          ad9963_adc_dmac/sync
ad_connect adc_trigger_fifo/data_out_valid  ad9963_adc_dmac/fifo_wr_en

# axi_dac_interpolate & ad9963_dac_dmac connections

ad_connect axi_dac_interpolate/dac_clk      axi_ad9963/dac_clk
ad_connect axi_dac_interpolate/dac_rst      axi_ad9963/dac_rst

ad_connect axi_dac_interpolate/dac_valid_a      axi_ad9963/dac_valid_i
ad_connect axi_dac_interpolate/dac_valid_b      axi_ad9963/dac_valid_q
ad_connect axi_dac_interpolate/dac_int_data_a   axi_ad9963/dac_data_i
ad_connect axi_dac_interpolate/dac_int_data_b   axi_ad9963/dac_data_q

ad_connect ad9963_dac_dmac_a/m_axis_aclk axi_ad9963/dac_clk
ad_connect ad9963_dac_dmac_b/m_axis_aclk axi_ad9963/dac_clk

ad_connect axi_dac_interpolate/dac_data_a     ad9963_dac_dmac_a/m_axis_data
ad_connect axi_dac_interpolate/dma_ready_a    ad9963_dac_dmac_a/m_axis_ready
ad_connect axi_dac_interpolate/dac_enable_a   axi_ad9963/dac_enable_i
ad_connect ad9963_dac_dmac_a/m_axis_valid     axi_dac_interpolate/dma_valid_a
ad_connect axi_dac_interpolate/dac_data_b     ad9963_dac_dmac_b/m_axis_data
ad_connect axi_dac_interpolate/dma_ready_b    ad9963_dac_dmac_b/m_axis_ready
ad_connect axi_dac_interpolate/dac_enable_b   axi_ad9963/dac_enable_q
ad_connect ad9963_dac_dmac_b/m_axis_valid     axi_dac_interpolate/dma_valid_b

ad_connect axi_dac_interpolate/trigger_i   trigger_i

ad_connect axi_ad9963/dac_clk  cdc_adc_trig_sync/out_clk
ad_connect axi_ad9963/adc_clk  cdc_adc_trig_sync/in_clk
ad_connect adc_trigger/trigger_out_la  cdc_adc_trig_sync/in_event
ad_connect axi_dac_interpolate/trigger_adc  cdc_adc_trig_sync/out_event

ad_connect axi_ad9963/dac_clk  cdc_la_trig_sync/out_clk
ad_connect axi_ad9963/adc_clk  cdc_la_trig_sync/in_clk
ad_connect logic_analyzer/trigger_out_adc  cdc_la_trig_sync/in_event
ad_connect axi_dac_interpolate/trigger_la  cdc_la_trig_sync/out_event

ad_connect axi_dac_interpolate/dac_valid_out_a  axi_ad9963/dma_valid_i
ad_connect axi_dac_interpolate/dac_valid_out_b  axi_ad9963/dma_valid_q

ad_connect axi_dac_interpolate/last_a           ad9963_dac_dmac_a/m_axis_last
ad_connect axi_dac_interpolate/last_b           ad9963_dac_dmac_b/m_axis_last

# axi_ad9963 interface connections

ad_connect /axi_ad9963/tx_data    txd
ad_connect /axi_ad9963/tx_iq      txiq
ad_connect /axi_ad9963/tx_clk     tx_clk
ad_connect /axi_ad9963/trx_data   rxd
ad_connect /axi_ad9963/trx_clk    rx_clk
ad_connect /axi_ad9963/trx_iq     rxiq

ad_connect adc_trigger/data_a axi_adc_decimate/adc_dec_data_a
ad_connect adc_trigger/data_valid_a axi_adc_decimate/adc_dec_valid_a
ad_connect adc_trigger/data_b axi_adc_decimate/adc_dec_data_b
ad_connect adc_trigger/data_valid_b axi_adc_decimate/adc_dec_valid_b

ad_connect axi_adc_decimate/adc_dec_valid_a  logic_analyzer/external_valid
ad_connect axi_adc_decimate/adc_data_rate  logic_analyzer/external_rate
ad_connect axi_adc_decimate/adc_oversampling_en  logic_analyzer/external_decimation_en

ad_connect adc_trigger/clk axi_ad9963/adc_clk
ad_connect trigger_i adc_trigger/trigger_i
ad_connect trigger_o adc_trigger/trigger_o
ad_connect trigger_t adc_trigger/trigger_t

ad_connect axi_ad9963/dac_sync_in axi_ad9963/dac_sync_out
ad_connect axi_ad9963/adc_dovf    ad9963_adc_dmac/fifo_wr_overflow
ad_connect axi_ad9963/dac_dunf    axi_dac_interpolate/underflow

# Logic analyzer DMA

ad_connect sys_cpu_clk axi_rd_wr_combiner_logic/clk
ad_connect sys_cpu_clk logic_analyzer_dmac/m_dest_axi_aclk
ad_connect sys_cpu_clk pattern_generator_dmac/m_src_axi_aclk

ad_connect logic_analyzer_dmac/m_dest_axi axi_rd_wr_combiner_logic/s_wr_axi
ad_connect pattern_generator_dmac/m_src_axi axi_rd_wr_combiner_logic/s_rd_axi

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 {1}
ad_connect sys_cpu_clk sys_ps7/S_AXI_HP1_ACLK
ad_connect axi_rd_wr_combiner_logic/m_axi sys_ps7/S_AXI_HP1

# Converter DMA

ad_connect converter_dma_clk axi_rd_wr_combiner_converter/clk
ad_connect converter_dma_clk ad9963_adc_dmac/m_dest_axi_aclk
ad_connect converter_dma_clk ad9963_dac_dmac_a/m_src_axi_aclk

ad_connect ad9963_adc_dmac/m_dest_axi axi_rd_wr_combiner_converter/s_wr_axi
ad_connect ad9963_dac_dmac_a/m_src_axi axi_rd_wr_combiner_converter/s_rd_axi

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP2 {1}
ad_connect converter_dma_clk sys_ps7/S_AXI_HP2_ACLK
ad_connect axi_rd_wr_combiner_converter/m_axi sys_ps7/S_AXI_HP2

# Only 16-bit we can run at a slower clock

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP3 {1}

ad_connect sys_cpu_clk sys_ps7/S_AXI_HP3_ACLK
ad_connect sys_cpu_clk ad9963_dac_dmac_b/m_src_axi_aclk
ad_connect ad9963_dac_dmac_b/m_src_axi sys_ps7/S_AXI_HP3

create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces ad9963_dac_dmac_b/m_src_axi] \
                    [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_sys_ps7_HP3_DDR_LOWOCM
create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_rd_wr_combiner_converter/m_axi] \
                    [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_HP2_DDR_LOWOCM
create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_rd_wr_combiner_logic/m_axi] \
                    [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_HP1_DDR_LOWOCM

# Map rd-wr combiner

assign_bd_address [get_bd_addr_segs { \
  axi_rd_wr_combiner_converter/s_rd_axi/reg0 \
  axi_rd_wr_combiner_converter/s_wr_axi/reg0 \
  axi_rd_wr_combiner_logic/s_rd_axi/reg0 \
  axi_rd_wr_combiner_logic/s_wr_axi/reg0 \
}]

set_property range 512M [get_bd_addr_segs { \
  ad9963_dac_dmac_a/m_src_axi/SEG_axi_rd_wr_combiner_converter_reg0 \
  ad9963_adc_dmac/m_dest_axi/SEG_axi_rd_wr_combiner_converter_reg0 \
  pattern_generator_dmac/m_src_axi/SEG_axi_rd_wr_combiner_logic_reg0 \
  logic_analyzer_dmac/m_dest_axi/SEG_axi_rd_wr_combiner_logic_reg0 \
}]

ad_connect  sys_cpu_resetn logic_analyzer_dmac/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn pattern_generator_dmac/m_src_axi_aresetn
ad_connect  sys_cpu_resetn ad9963_adc_dmac/m_dest_axi_aresetn
ad_connect  sys_cpu_resetn ad9963_dac_dmac_a/m_src_axi_aresetn
ad_connect  sys_cpu_resetn ad9963_dac_dmac_b/m_src_axi_aresetn

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
ad_connect  sys_concat_intc/In15 GND
ad_connect  sys_concat_intc/In14 axi_iic_main/iic2intc_irpt
ad_connect  sys_concat_intc/In13 logic_analyzer_dmac/irq
ad_connect  sys_concat_intc/In12 pattern_generator_dmac/irq
ad_connect  sys_concat_intc/In11 GND
ad_connect  sys_concat_intc/In10 ad9963_adc_dmac/irq
ad_connect  sys_concat_intc/In9 ad9963_dac_dmac_a/irq
ad_connect  sys_concat_intc/In8 ad9963_dac_dmac_b/irq
ad_connect  sys_concat_intc/In7 GND
ad_connect  sys_concat_intc/In6 GND
ad_connect  sys_concat_intc/In5 GND
ad_connect  sys_concat_intc/In4 GND
ad_connect  sys_concat_intc/In3 GND
ad_connect  sys_concat_intc/In2 GND
ad_connect  sys_concat_intc/In1 GND
ad_connect  sys_concat_intc/In0 GND

# interconnects

ad_cpu_interconnect 0x41600000 axi_iic_main
ad_cpu_interconnect 0x70100000 logic_analyzer
ad_cpu_interconnect 0x70200000 axi_ad9963
ad_cpu_interconnect 0x7C400000 logic_analyzer_dmac
ad_cpu_interconnect 0x7C420000 pattern_generator_dmac
ad_cpu_interconnect 0x7C440000 ad9963_adc_dmac
ad_cpu_interconnect 0x7C460000 ad9963_dac_dmac_b
ad_cpu_interconnect 0x7C480000 ad9963_dac_dmac_a
ad_cpu_interconnect 0x7C4c0000 adc_trigger
ad_cpu_interconnect 0x7C500000 axi_adc_decimate
ad_cpu_interconnect 0x7C5a0000 axi_dac_interpolate
