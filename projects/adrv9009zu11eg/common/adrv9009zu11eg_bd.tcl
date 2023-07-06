###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################


# Parameter description:
#   [TX/RX/RX_OS]_JESD_M  : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L  : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S  : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample

if {[info exists FMCOMMS8]} {
  set MAX_TX_NUM_OF_LANES 16
  set MAX_RX_NUM_OF_LANES 8
  set MAX_RX_OS_NUM_OF_LANES 8
} else {
  set MAX_TX_NUM_OF_LANES 8
  set MAX_RX_NUM_OF_LANES 4
  set MAX_RX_OS_NUM_OF_LANES 4
}

set DATAPATH_WIDTH 4
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# TX parameters
set TX_NUM_OF_LANES $ad_project_params(TX_JESD_L)      ; # L
set TX_NUM_OF_CONVERTERS $ad_project_params(TX_JESD_M) ; # M
set TX_SAMPLES_PER_FRAME $ad_project_params(TX_JESD_S) ; # S
set TX_SAMPLE_WIDTH 16                                 ; # N/NP

set TX_TPL_WIDTH [ expr { [info exists ad_project_params(TX_TPL_WIDTH)] \
                          ? $ad_project_params(TX_TPL_WIDTH) : {} } ]

set TX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $TX_NUM_OF_LANES $TX_NUM_OF_CONVERTERS $TX_SAMPLES_PER_FRAME $TX_SAMPLE_WIDTH $TX_TPL_WIDTH]
set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8 * $TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

# RX parameters
set RX_NUM_OF_LANES $ad_project_params(RX_JESD_L)      ; # L
set RX_NUM_OF_CONVERTERS $ad_project_params(RX_JESD_M) ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S) ; # S
set RX_SAMPLE_WIDTH 16                                 ; # N/NP

set RX_OCTETS_PER_FRAME [expr $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_FRAME * $RX_SAMPLE_WIDTH / (8 * $RX_NUM_OF_LANES)] ; # F
set DPW [expr max(4, $RX_OCTETS_PER_FRAME)] ; #max(4, F)
set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8 * $DPW / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)] ; # L * 8 * DPW / (M* N)

set adc_dma_data_width [expr $RX_NUM_OF_LANES * 8 * $DPW]

# RX Observation parameters
set RX_OS_NUM_OF_LANES $ad_project_params(RX_OS_JESD_L)      ; # L
set RX_OS_NUM_OF_CONVERTERS $ad_project_params(RX_OS_JESD_M) ; # M
set RX_OS_SAMPLES_PER_FRAME $ad_project_params(RX_OS_JESD_S) ; # S
set RX_OS_SAMPLE_WIDTH 16                                    ; # N/NP

set RX_OS_TPL_WIDTH [ expr { [info exists ad_project_params(RX_OS_TPL_WIDTH)] \
                          ? $ad_project_params(RX_OS_TPL_WIDTH) : {} } ]

set RX_OS_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $RX_OS_NUM_OF_LANES $RX_OS_NUM_OF_CONVERTERS $RX_OS_SAMPLES_PER_FRAME $RX_OS_SAMPLE_WIDTH $RX_OS_TPL_WIDTH]
set RX_OS_SAMPLES_PER_CHANNEL [expr $RX_OS_NUM_OF_LANES * 8 * $RX_OS_DATAPATH_WIDTH / ($RX_OS_NUM_OF_CONVERTERS * $RX_OS_SAMPLE_WIDTH)]

set dac_fifo_name axi_tx_fifo
set dac_data_width [expr $TX_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_CHANNEL]

# default ports

create_bd_port -dir O -from 2 -to 0 spi0_csn
create_bd_port -dir O spi0_sclk
create_bd_port -dir O spi0_mosi
create_bd_port -dir I spi0_miso

create_bd_port -dir I -from 94 -to 0 gpio_i
create_bd_port -dir O -from 94 -to 0 gpio_o
create_bd_port -dir O -from 94 -to 0 gpio_t

create_bd_port -dir I sys_reset

create_bd_port -dir I ref_clk_a
create_bd_port -dir I ref_clk_b

create_bd_port -dir I core_clk_a
create_bd_port -dir I core_clk_b

create_bd_port -dir I dac_fifo_bypass

# instance: sys_ps8

ad_ip_instance zynq_ultra_ps_e sys_ps8

ad_ip_parameter sys_ps8 CONFIG.PSU__PSS_REF_CLK__FREQMHZ 33.333333333
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 0
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP1 0
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP2 1
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP2__DATA_WIDTH 32
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL0_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ 100
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL1_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 200
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL2_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ 12.288
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__IRQ0 1
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__IRQ1 1
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__SPI0__PERIPHERAL__ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__SPI0__PERIPHERAL__IO {EMIO}
ad_ip_parameter sys_ps8 CONFIG.PSU__SPI0__GRP_SS1__ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__SPI0__GRP_SS2__ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ 100
ad_ip_parameter sys_ps8 CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15}
ad_ip_parameter sys_ps8 CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 16 .. 17}
ad_ip_parameter sys_ps8 CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane1}
ad_ip_parameter sys_ps8 CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__ENET0__PERIPHERAL__IO {GT Lane0}
ad_ip_parameter sys_ps8 CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__PMU__PERIPHERAL__ENABLE {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel}
ad_ip_parameter sys_ps8 CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4}
ad_ip_parameter sys_ps8 CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30}
ad_ip_parameter sys_ps8 CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.SUBPRESET1 {DDR4_MICRON_MT40A256M16GE_083E}
ad_ip_parameter sys_ps8 CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit}
ad_ip_parameter sys_ps8 CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits}
ad_ip_parameter sys_ps8 CONFIG.PSU__DDRC__BG_ADDR_COUNT {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__DDRC__PARITY_ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__DDRC__ECC {Enabled}
set_property -dict [list CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} ] [get_bd_cells sys_ps8]
set_property -dict [list CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 32 .. 33}] [get_bd_cells sys_ps8]
set_property -dict [list CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {DPLL} CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {DPLL}] [get_bd_cells sys_ps8]
set_property -dict [list CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {APLL}] [get_bd_cells sys_ps8]
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {1}

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps8/pl_clk0
ad_connect  sys_200m_clk sys_ps8/pl_clk1
ad_connect  i2s_m_clk sys_ps8/pl_clk2
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_ps8/pl_resetn0 sys_rstgen/ext_reset_in

# gpio

ad_connect  gpio_i sys_ps8/emio_gpio_i
ad_connect  gpio_o sys_ps8/emio_gpio_o
ad_connect  gpio_t sys_ps8/emio_gpio_t

# spi

ad_ip_instance xlconcat spi0_csn_concat
ad_ip_parameter spi0_csn_concat CONFIG.NUM_PORTS 3
ad_connect  sys_ps8/emio_spi0_ss_o_n spi0_csn_concat/In0
ad_connect  sys_ps8/emio_spi0_ss1_o_n spi0_csn_concat/In1
ad_connect  sys_ps8/emio_spi0_ss2_o_n spi0_csn_concat/In2
ad_connect  spi0_csn_concat/dout spi0_csn
ad_connect  sys_ps8/emio_spi0_sclk_o spi0_sclk
ad_connect  sys_ps8/emio_spi0_m_o spi0_mosi
ad_connect  sys_ps8/emio_spi0_m_i spi0_miso
ad_connect  sys_ps8/emio_spi0_ss_i_n VCC
ad_connect  sys_ps8/emio_spi0_sclk_i GND
ad_connect  sys_ps8/emio_spi0_s_i GND

#system ID

ad_ip_instance axi_sysid axi_sysid_0
ad_ip_instance sysid_rom rom_sys_0

ad_connect  axi_sysid_0/rom_addr rom_sys_0/rom_addr
ad_connect  axi_sysid_0/sys_rom_data rom_sys_0/rom_data
ad_connect  sys_cpu_clk rom_sys_0/clk

# interrupts

ad_ip_instance xlconcat sys_concat_intc_0
ad_ip_parameter sys_concat_intc_0 CONFIG.NUM_PORTS 8

ad_ip_instance xlconcat sys_concat_intc_1
ad_ip_parameter sys_concat_intc_1 CONFIG.NUM_PORTS 8

ad_connect  sys_concat_intc_0/dout sys_ps8/pl_ps_irq0
ad_connect  sys_concat_intc_1/dout sys_ps8/pl_ps_irq1

ad_connect  sys_concat_intc_1/In7 GND
ad_connect  sys_concat_intc_1/In6 GND
ad_connect  sys_concat_intc_1/In5 GND
ad_connect  sys_concat_intc_1/In4 GND
ad_connect  sys_concat_intc_1/In3 GND
ad_connect  sys_concat_intc_1/In2 GND
ad_connect  sys_concat_intc_1/In1 GND
ad_connect  sys_concat_intc_1/In0 GND
ad_connect  sys_concat_intc_0/In7 GND
ad_connect  sys_concat_intc_0/In6 GND
ad_connect  sys_concat_intc_0/In5 GND
ad_connect  sys_concat_intc_0/In4 GND
ad_connect  sys_concat_intc_0/In3 GND
ad_connect  sys_concat_intc_0/In2 GND
ad_connect  sys_concat_intc_0/In1 GND
ad_connect  sys_concat_intc_0/In0 GND

# ADRV9009 Specific Connections

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_rtl_1
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_ref_1

ad_ip_instance ip:ddr4 ddr4_1
ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_DataWidth {32}
ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_AxiDataWidth {256}
ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_AxiAddressWidth {31}
ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_InputClockPeriod {3334}
ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_MemoryPart {MT40A512M16HA-075E}
ad_ip_parameter ddr4_1 CONFIG.C0.BANK_GROUP_WIDTH {1}
ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_CasLatency {18}

ad_connect ddr4_rtl_1 ddr4_1/C0_DDR4

set_property -dict [list CONFIG.FREQ_HZ {300000000}] [get_bd_intf_ports ddr4_ref_1]
ad_connect ddr4_ref_1 ddr4_1/C0_SYS_CLK

ad_ip_instance axi_dacfifo $dac_fifo_name
ad_ip_parameter $dac_fifo_name CONFIG.DAC_DATA_WIDTH $dac_data_width
ad_ip_parameter $dac_fifo_name CONFIG.DMA_DATA_WIDTH $dac_data_width
ad_ip_parameter $dac_fifo_name CONFIG.AXI_DATA_WIDTH 256
ad_ip_parameter $dac_fifo_name CONFIG.AXI_SIZE 5
ad_ip_parameter $dac_fifo_name CONFIG.AXI_LENGTH 255
ad_ip_parameter $dac_fifo_name CONFIG.AXI_ADDRESS 0x80000000

create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr4_1_rstgen
ad_connect ddr4_1_rstgen/slowest_sync_clk ddr4_1/c0_ddr4_ui_clk
ad_connect ddr4_1/c0_ddr4_ui_clk_sync_rst ddr4_1_rstgen/ext_reset_in
ad_connect ddr4_1_rstgen/peripheral_aresetn axi_tx_fifo/axi_resetn

ad_connect sys_reset ddr4_1/sys_rst

ad_ip_instance axi_adxcvr axi_adrv9009_som_tx_xcvr
ad_ip_parameter axi_adrv9009_som_tx_xcvr CONFIG.NUM_OF_LANES $MAX_TX_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_som_tx_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_adrv9009_som_tx_xcvr CONFIG.TX_OR_RX_N 1

adi_axi_jesd204_tx_create axi_adrv9009_som_tx_jesd $TX_NUM_OF_LANES
set_property -dict [list CONFIG.SYSREF_IOB {false}] [get_bd_cells axi_adrv9009_som_tx_jesd/tx]

ad_ip_instance util_upack2 util_som_tx_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

adi_tpl_jesd204_tx_create tx_adrv9009_som_tpl_core $TX_NUM_OF_LANES \
                                               $TX_NUM_OF_CONVERTERS \
                                               $TX_SAMPLES_PER_FRAME \
                                               $TX_SAMPLE_WIDTH

ad_ip_parameter tx_adrv9009_som_tpl_core/dac_tpl_core CONFIG.EXT_SYNC 1

ad_ip_instance axi_dmac axi_adrv9009_som_tx_dma
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_data_width
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.DMA_DATA_WIDTH_SRC 128

ad_ip_instance axi_adxcvr axi_adrv9009_som_rx_xcvr
ad_ip_parameter axi_adrv9009_som_rx_xcvr CONFIG.NUM_OF_LANES $MAX_RX_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_som_rx_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_adrv9009_som_rx_xcvr CONFIG.TX_OR_RX_N 0

adi_axi_jesd204_rx_create axi_adrv9009_som_rx_jesd $RX_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_som_rx_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_adrv9009_som_rx_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $DPW

ad_ip_instance util_cpack2 util_som_rx_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
  ]

adi_tpl_jesd204_rx_create rx_adrv9009_som_tpl_core $RX_NUM_OF_LANES \
                                               $RX_NUM_OF_CONVERTERS \
                                               $RX_SAMPLES_PER_FRAME \
                                               $RX_SAMPLE_WIDTH

ad_ip_parameter rx_adrv9009_som_tpl_core/adc_tpl_core CONFIG.EXT_SYNC 1

ad_ip_instance axi_dmac axi_adrv9009_som_rx_dma
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_som_rx_dma MAX_BYTES_PER_BURST 256
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_dma_data_width
ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 128

ad_ip_instance axi_adxcvr axi_adrv9009_som_obs_xcvr
ad_ip_parameter axi_adrv9009_som_obs_xcvr CONFIG.NUM_OF_LANES $MAX_RX_OS_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_som_obs_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_adrv9009_som_obs_xcvr CONFIG.TX_OR_RX_N 0

adi_axi_jesd204_rx_create axi_adrv9009_som_obs_jesd $RX_OS_NUM_OF_LANES

ad_ip_instance util_cpack2 util_som_obs_cpack [list \
  NUM_OF_CHANNELS $RX_OS_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_OS_SAMPLES_PER_CHANNEL\
  SAMPLE_DATA_WIDTH $RX_OS_SAMPLE_WIDTH \
]

adi_tpl_jesd204_rx_create obs_adrv9009_som_tpl_core $RX_OS_NUM_OF_LANES \
                                                  $RX_OS_NUM_OF_CONVERTERS \
                                                  $RX_OS_SAMPLES_PER_FRAME \
                                                  $RX_OS_SAMPLE_WIDTH

ad_ip_parameter obs_adrv9009_som_tpl_core/adc_tpl_core CONFIG.EXT_SYNC 1

ad_ip_instance axi_dmac axi_adrv9009_som_obs_dma
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_som_obs_dma MAX_BYTES_PER_BURST 256
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.DMA_DATA_WIDTH_SRC [expr 32*$RX_OS_NUM_OF_LANES]
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.DMA_DATA_WIDTH_DEST 128

ad_ip_instance util_adxcvr util_adrv9009_som_xcvr
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.RX_NUM_OF_LANES [expr $MAX_RX_NUM_OF_LANES+$MAX_RX_OS_NUM_OF_LANES]
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.TX_NUM_OF_LANES $MAX_TX_NUM_OF_LANES
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.TX_OUT_DIV 2
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.CPLL_FBDIV 4
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.RX_CLK25_DIV 10
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.TX_CLK25_DIV 10
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_xcvrpll  ref_clk_a util_adrv9009_som_xcvr/qpll_ref_clk_0
ad_xcvrpll  ref_clk_b util_adrv9009_som_xcvr/cpll_ref_clk_0
ad_xcvrpll  ref_clk_b util_adrv9009_som_xcvr/cpll_ref_clk_1
ad_xcvrpll  ref_clk_a util_adrv9009_som_xcvr/cpll_ref_clk_2
ad_xcvrpll  ref_clk_a util_adrv9009_som_xcvr/cpll_ref_clk_3
ad_xcvrpll  ref_clk_a util_adrv9009_som_xcvr/qpll_ref_clk_4
ad_xcvrpll  ref_clk_b util_adrv9009_som_xcvr/cpll_ref_clk_4
ad_xcvrpll  ref_clk_b util_adrv9009_som_xcvr/cpll_ref_clk_5
ad_xcvrpll  ref_clk_a util_adrv9009_som_xcvr/cpll_ref_clk_6
ad_xcvrpll  ref_clk_a util_adrv9009_som_xcvr/cpll_ref_clk_7

ad_xcvrpll  axi_adrv9009_som_tx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_qpll_rst_0
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_0
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_1
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_2
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_3
ad_xcvrpll  axi_adrv9009_som_tx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_qpll_rst_4
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_4
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_5
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_6
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_7
ad_connect  sys_cpu_resetn util_adrv9009_som_xcvr/up_rstn
ad_connect  sys_cpu_clk util_adrv9009_som_xcvr/up_clk

if {[info exists FMCOMMS8]} {
  #FMCOMMS8
  # Tx
  if {$TX_NUM_OF_LANES == 16} {
    ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_tx_xcvr axi_adrv9009_som_tx_jesd {} core_clk_a
  } else {
    if {$TX_NUM_OF_LANES == 8} {
      # TX_JESD_L=8 it is recommanded to use RX_OS_JESD_M=TX_JESD_M because they share the same device clock
      ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_tx_xcvr axi_adrv9009_som_tx_jesd {} core_clk_a {} $MAX_TX_NUM_OF_LANES {0 1 4 5 8 9 12 13}
    } else {
      # TX_JESD_L=4
      ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_tx_xcvr axi_adrv9009_som_tx_jesd {} core_clk_a {} $MAX_TX_NUM_OF_LANES {0 4 8 12}
    }
  }

  # Rx
  if {$RX_NUM_OF_LANES == 8} {
    ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_rx_xcvr axi_adrv9009_som_rx_jesd {0 1 4 5 8 9 12 13} core_clk_b
  } else {
    # for RX_JESD_L=4, RX_OCTETS_PER_FRAME = 8
    # {0 1 4 5 8 9 12 13} are the lanes for rx
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_out_clk_0
    ad_xcvrcon util_adrv9009_som_xcvr axi_adrv9009_som_rx_xcvr axi_adrv9009_som_rx_jesd {} adrv9009_som_rx_link_clk core_clk_b $MAX_RX_NUM_OF_LANES {0 4 8 12} 0
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_0 util_adrv9009_som_xcvr/up_es_0
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_1 util_adrv9009_som_xcvr/up_es_1
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_2 util_adrv9009_som_xcvr/up_es_4
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_3 util_adrv9009_som_xcvr/up_es_5
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_4 util_adrv9009_som_xcvr/up_es_8
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_5 util_adrv9009_som_xcvr/up_es_9
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_6 util_adrv9009_som_xcvr/up_es_12
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_7 util_adrv9009_som_xcvr/up_es_13
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_0 util_adrv9009_som_xcvr/up_rx_0
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_1 util_adrv9009_som_xcvr/up_rx_1
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_2 util_adrv9009_som_xcvr/up_rx_4
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_3 util_adrv9009_som_xcvr/up_rx_5
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_4 util_adrv9009_som_xcvr/up_rx_8
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_5 util_adrv9009_som_xcvr/up_rx_9
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_6 util_adrv9009_som_xcvr/up_rx_12
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_7 util_adrv9009_som_xcvr/up_rx_13

    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_0
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_1
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_4
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_5
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_8
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_9
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_12
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_13

    create_bd_port -dir I rx_data_0_p
    create_bd_port -dir I rx_data_0_n
    create_bd_port -dir I rx_data_1_p
    create_bd_port -dir I rx_data_1_n
    create_bd_port -dir I rx_data_4_p
    create_bd_port -dir I rx_data_4_n
    create_bd_port -dir I rx_data_5_p
    create_bd_port -dir I rx_data_5_n
    create_bd_port -dir I rx_data_8_p
    create_bd_port -dir I rx_data_8_n
    create_bd_port -dir I rx_data_9_p
    create_bd_port -dir I rx_data_9_n
    create_bd_port -dir I rx_data_12_p
    create_bd_port -dir I rx_data_12_n
    create_bd_port -dir I rx_data_13_p
    create_bd_port -dir I rx_data_13_n
    ad_connect util_adrv9009_som_xcvr/rx_0_p rx_data_0_p
    ad_connect util_adrv9009_som_xcvr/rx_0_n rx_data_0_n
    ad_connect util_adrv9009_som_xcvr/rx_1_p rx_data_1_p
    ad_connect util_adrv9009_som_xcvr/rx_1_n rx_data_1_n
    ad_connect util_adrv9009_som_xcvr/rx_4_p rx_data_4_p
    ad_connect util_adrv9009_som_xcvr/rx_4_n rx_data_4_n
    ad_connect util_adrv9009_som_xcvr/rx_5_p rx_data_5_p
    ad_connect util_adrv9009_som_xcvr/rx_5_n rx_data_5_n
    ad_connect util_adrv9009_som_xcvr/rx_8_p rx_data_8_p
    ad_connect util_adrv9009_som_xcvr/rx_8_n rx_data_8_n
    ad_connect util_adrv9009_som_xcvr/rx_9_p rx_data_9_p
    ad_connect util_adrv9009_som_xcvr/rx_9_n rx_data_9_n
    ad_connect util_adrv9009_som_xcvr/rx_12_p rx_data_12_p
    ad_connect util_adrv9009_som_xcvr/rx_12_n rx_data_12_n
    ad_connect util_adrv9009_som_xcvr/rx_13_p rx_data_13_p
    ad_connect util_adrv9009_som_xcvr/rx_13_n rx_data_13_n
  }

  # Rx - Obs
  if {$RX_OS_NUM_OF_LANES == 8} {
    ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_obs_xcvr axi_adrv9009_som_obs_jesd {2 3 6 7 10 11 14 15} core_clk_a
  } else {
    # ORX_JESD_L=4
    # {2 3 6 7 10 11 14 15} are the lanes for orx
    ad_xcvrcon util_adrv9009_som_xcvr axi_adrv9009_som_obs_xcvr axi_adrv9009_som_obs_jesd {} core_clk_a {} $MAX_RX_OS_NUM_OF_LANES {2 6 10 14} 0
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_0 util_adrv9009_som_xcvr/up_es_2
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_1 util_adrv9009_som_xcvr/up_es_3
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_2 util_adrv9009_som_xcvr/up_es_6
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_3 util_adrv9009_som_xcvr/up_es_7
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_4 util_adrv9009_som_xcvr/up_es_10
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_5 util_adrv9009_som_xcvr/up_es_11
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_6 util_adrv9009_som_xcvr/up_es_14
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_7 util_adrv9009_som_xcvr/up_es_15
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_0 util_adrv9009_som_xcvr/up_rx_2
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_1 util_adrv9009_som_xcvr/up_rx_3
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_2 util_adrv9009_som_xcvr/up_rx_6
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_3 util_adrv9009_som_xcvr/up_rx_7
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_4 util_adrv9009_som_xcvr/up_rx_10
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_5 util_adrv9009_som_xcvr/up_rx_11
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_6 util_adrv9009_som_xcvr/up_rx_14
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_7 util_adrv9009_som_xcvr/up_rx_15

    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_2
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_3
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_6
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_7
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_10
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_11
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_14
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_15

    create_bd_port -dir I rx_data_2_p
    create_bd_port -dir I rx_data_2_n
    create_bd_port -dir I rx_data_3_p
    create_bd_port -dir I rx_data_3_n
    create_bd_port -dir I rx_data_6_p
    create_bd_port -dir I rx_data_6_n
    create_bd_port -dir I rx_data_7_p
    create_bd_port -dir I rx_data_7_n
    create_bd_port -dir I rx_data_10_p
    create_bd_port -dir I rx_data_10_n
    create_bd_port -dir I rx_data_11_p
    create_bd_port -dir I rx_data_11_n
    create_bd_port -dir I rx_data_14_p
    create_bd_port -dir I rx_data_14_n
    create_bd_port -dir I rx_data_15_p
    create_bd_port -dir I rx_data_15_n
    ad_connect util_adrv9009_som_xcvr/rx_2_p rx_data_2_p
    ad_connect util_adrv9009_som_xcvr/rx_2_n rx_data_2_n
    ad_connect util_adrv9009_som_xcvr/rx_3_p rx_data_3_p
    ad_connect util_adrv9009_som_xcvr/rx_3_n rx_data_3_n
    ad_connect util_adrv9009_som_xcvr/rx_6_p rx_data_6_p
    ad_connect util_adrv9009_som_xcvr/rx_6_n rx_data_6_n
    ad_connect util_adrv9009_som_xcvr/rx_7_p rx_data_7_p
    ad_connect util_adrv9009_som_xcvr/rx_7_n rx_data_7_n
    ad_connect util_adrv9009_som_xcvr/rx_10_p rx_data_10_p
    ad_connect util_adrv9009_som_xcvr/rx_10_n rx_data_10_n
    ad_connect util_adrv9009_som_xcvr/rx_11_p rx_data_11_p
    ad_connect util_adrv9009_som_xcvr/rx_11_n rx_data_11_n
    ad_connect util_adrv9009_som_xcvr/rx_14_p rx_data_14_p
    ad_connect util_adrv9009_som_xcvr/rx_14_n rx_data_14_n
    ad_connect util_adrv9009_som_xcvr/rx_15_p rx_data_15_p
    ad_connect util_adrv9009_som_xcvr/rx_15_n rx_data_15_n
  }
} else {
  #ADRV2CRR_FMC
  # Tx
  if {$TX_NUM_OF_LANES == 8} {
    ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_tx_xcvr axi_adrv9009_som_tx_jesd {} core_clk_a
  } else {
    if {$TX_NUM_OF_LANES == 4} {
    # TX_JESD_L=4, it is recommanded to use RX_OS_JESD_M=TX_JESD_M because they share the same device clock
    ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_tx_xcvr axi_adrv9009_som_tx_jesd {} core_clk_a {} $MAX_TX_NUM_OF_LANES {0 1 4 5}
    } else {
      # TX_JESD_L=2
      ad_xcvrcon util_adrv9009_som_xcvr axi_adrv9009_som_tx_xcvr axi_adrv9009_som_tx_jesd {} core_clk_a {} $MAX_TX_NUM_OF_LANES {0 4}
    }
  }

  # Rx
  if {$RX_NUM_OF_LANES == 4} {
    ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_rx_xcvr axi_adrv9009_som_rx_jesd {0 1 4 5} core_clk_b
  } else {
    # for RX_JESD_L=2, RX_OCTETS_PER_FRAME = 8
    # {0 1 4 5} are the lanes for rx
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_out_clk_0
    ad_xcvrcon util_adrv9009_som_xcvr axi_adrv9009_som_rx_xcvr axi_adrv9009_som_rx_jesd {} adrv9009_som_rx_link_clk core_clk_b $MAX_RX_NUM_OF_LANES {0 4} 0
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_0 util_adrv9009_som_xcvr/up_es_0
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_1 util_adrv9009_som_xcvr/up_es_1
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_2 util_adrv9009_som_xcvr/up_es_4
    ad_connect axi_adrv9009_som_rx_xcvr/up_es_3 util_adrv9009_som_xcvr/up_es_5
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_0 util_adrv9009_som_xcvr/up_rx_0
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_1 util_adrv9009_som_xcvr/up_rx_1
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_2 util_adrv9009_som_xcvr/up_rx_4
    ad_connect axi_adrv9009_som_rx_xcvr/up_ch_3 util_adrv9009_som_xcvr/up_rx_5

    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_0
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_1
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_4
    ad_connect adrv9009_som_rx_link_clk util_adrv9009_som_xcvr/rx_clk_5

    create_bd_port -dir I rx_data_0_p
    create_bd_port -dir I rx_data_0_n
    create_bd_port -dir I rx_data_1_p
    create_bd_port -dir I rx_data_1_n
    create_bd_port -dir I rx_data_4_p
    create_bd_port -dir I rx_data_4_n
    create_bd_port -dir I rx_data_5_p
    create_bd_port -dir I rx_data_5_n
    ad_connect util_adrv9009_som_xcvr/rx_0_p rx_data_0_p
    ad_connect util_adrv9009_som_xcvr/rx_0_n rx_data_0_n
    ad_connect util_adrv9009_som_xcvr/rx_1_p rx_data_1_p
    ad_connect util_adrv9009_som_xcvr/rx_1_n rx_data_1_n
    ad_connect util_adrv9009_som_xcvr/rx_4_p rx_data_4_p
    ad_connect util_adrv9009_som_xcvr/rx_4_n rx_data_4_n
    ad_connect util_adrv9009_som_xcvr/rx_5_p rx_data_5_p
    ad_connect util_adrv9009_som_xcvr/rx_5_n rx_data_5_n
  }

  # Rx - Obs
  if {$RX_OS_NUM_OF_LANES == 4} {
    ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_obs_xcvr axi_adrv9009_som_obs_jesd {2 3 6 7} core_clk_a
  } else {
    # ORX_JESD_L=2
    # {2 3 6 7} are the lanes for orx
    ad_xcvrcon util_adrv9009_som_xcvr axi_adrv9009_som_obs_xcvr axi_adrv9009_som_obs_jesd {} core_clk_a {} $MAX_RX_OS_NUM_OF_LANES {2 6} 0
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_0 util_adrv9009_som_xcvr/up_es_2
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_1 util_adrv9009_som_xcvr/up_es_3
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_2 util_adrv9009_som_xcvr/up_es_6
    ad_connect axi_adrv9009_som_obs_xcvr/up_es_3 util_adrv9009_som_xcvr/up_es_7
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_0 util_adrv9009_som_xcvr/up_rx_2
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_1 util_adrv9009_som_xcvr/up_rx_3
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_2 util_adrv9009_som_xcvr/up_rx_6
    ad_connect axi_adrv9009_som_obs_xcvr/up_ch_3 util_adrv9009_som_xcvr/up_rx_7

    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_2
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_3
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_6
    ad_connect core_clk_a util_adrv9009_som_xcvr/rx_clk_7

    create_bd_port -dir I rx_data_2_p
    create_bd_port -dir I rx_data_2_n
    create_bd_port -dir I rx_data_3_p
    create_bd_port -dir I rx_data_3_n
    create_bd_port -dir I rx_data_6_p
    create_bd_port -dir I rx_data_6_n
    create_bd_port -dir I rx_data_7_p
    create_bd_port -dir I rx_data_7_n
    ad_connect util_adrv9009_som_xcvr/rx_2_p rx_data_2_p
    ad_connect util_adrv9009_som_xcvr/rx_2_n rx_data_2_n
    ad_connect util_adrv9009_som_xcvr/rx_3_p rx_data_3_p
    ad_connect util_adrv9009_som_xcvr/rx_3_n rx_data_3_n
    ad_connect util_adrv9009_som_xcvr/rx_6_p rx_data_6_p
    ad_connect util_adrv9009_som_xcvr/rx_6_n rx_data_6_n
    ad_connect util_adrv9009_som_xcvr/rx_7_p rx_data_7_p
    ad_connect util_adrv9009_som_xcvr/rx_7_n rx_data_7_n
  }
}

ad_connect  core_clk_a tx_adrv9009_som_tpl_core/link_clk
ad_connect  axi_adrv9009_som_tx_jesd/tx_data tx_adrv9009_som_tpl_core/link

ad_connect  core_clk_a util_som_tx_upack/clk
ad_connect  tx_adrv9009_som_tpl_core/dac_tpl_core/dac_rst util_som_tx_upack/reset

ad_connect  tx_adrv9009_som_tpl_core/dac_valid_0 util_som_tx_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
    ad_connect  util_som_tx_upack/fifo_rd_data_$i tx_adrv9009_som_tpl_core/dac_data_$i
    ad_connect  tx_adrv9009_som_tpl_core/dac_enable_$i  util_som_tx_upack/enable_$i
}

ad_connect tx_adrv9009_som_tpl_core/dac_dunf util_som_tx_upack/fifo_rd_underflow
ad_connect tx_sysref_0 tx_adrv9009_som_tpl_core/dac_tpl_core/dac_sync_in

# connections (adc)

ad_connect  core_clk_b rx_adrv9009_som_tpl_core/link_clk
ad_connect  core_clk_b util_som_rx_cpack/clk
ad_connect  axi_adrv9009_som_rx_dma/fifo_wr_clk core_clk_b

ad_connect  axi_adrv9009_som_rx_jesd/rx_sof rx_adrv9009_som_tpl_core/link_sof
ad_connect  axi_adrv9009_som_rx_jesd/rx_data_tdata rx_adrv9009_som_tpl_core/link_data
ad_connect  axi_adrv9009_som_rx_jesd/rx_data_tvalid rx_adrv9009_som_tpl_core/link_valid

ad_connect  rx_adrv9009_som_tpl_core/adc_tpl_core/adc_rst util_som_rx_cpack/reset
ad_connect  rx_adrv9009_som_tpl_core/adc_tpl_core/adc_sync_in rx_sysref_0

ad_connect rx_adrv9009_som_tpl_core/adc_valid_0 util_som_rx_cpack/fifo_wr_en
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_adrv9009_som_tpl_core/adc_enable_$i util_som_rx_cpack/enable_$i
  ad_connect  rx_adrv9009_som_tpl_core/adc_data_$i util_som_rx_cpack/fifo_wr_data_$i
}
ad_connect  rx_adrv9009_som_tpl_core/adc_dovf util_som_rx_cpack/fifo_wr_overflow

# connections (adc-obs)

ad_connect  core_clk_a obs_adrv9009_som_tpl_core/link_clk
ad_connect  axi_adrv9009_som_obs_jesd/rx_sof obs_adrv9009_som_tpl_core/link_sof
ad_connect  axi_adrv9009_som_obs_jesd/rx_data_tdata obs_adrv9009_som_tpl_core/link_data
ad_connect  axi_adrv9009_som_obs_jesd/rx_data_tvalid obs_adrv9009_som_tpl_core/link_valid
ad_connect  core_clk_a util_som_obs_cpack/clk
ad_connect  obs_adrv9009_som_tpl_core/adc_tpl_core/adc_rst util_som_obs_cpack/reset
ad_connect  core_clk_a axi_adrv9009_som_obs_dma/fifo_wr_clk

ad_connect  obs_adrv9009_som_tpl_core/adc_valid_0 util_som_obs_cpack/fifo_wr_en
for {set i 0} {$i < $RX_OS_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  obs_adrv9009_som_tpl_core/adc_enable_$i util_som_obs_cpack/enable_$i
  ad_connect  obs_adrv9009_som_tpl_core/adc_data_$i util_som_obs_cpack/fifo_wr_data_$i
}
ad_connect  obs_adrv9009_som_tpl_core/adc_dovf util_som_obs_cpack/fifo_wr_overflow
ad_connect  util_som_obs_cpack/packed_fifo_wr axi_adrv9009_som_obs_dma/fifo_wr

ad_connect core_clk_a axi_adrv9009_som_tx_dma/m_axis_aclk

ad_connect util_som_rx_cpack/packed_fifo_wr axi_adrv9009_som_rx_dma/fifo_wr

ad_connect axi_tx_fifo/axi ddr4_1/C0_DDR4_S_AXI
ad_connect ddr4_1/c0_ddr4_aresetn ddr4_1_rstgen/peripheral_aresetn
ad_connect core_clk_a axi_tx_fifo/dma_clk
ad_connect axi_tx_fifo/dma_rst core_clk_a_rstgen/peripheral_reset
ad_connect axi_tx_fifo/dma_valid axi_adrv9009_som_tx_dma/m_axis_valid
ad_connect axi_tx_fifo/dma_ready axi_adrv9009_som_tx_dma/m_axis_ready
ad_connect axi_adrv9009_som_tx_dma/m_axis_data axi_tx_fifo/dma_data
ad_connect axi_adrv9009_som_tx_dma/m_axis_last axi_tx_fifo/dma_xfer_last
ad_connect axi_adrv9009_som_tx_dma/m_axis_xfer_req axi_tx_fifo/dma_xfer_req
ad_connect core_clk_a axi_tx_fifo/dac_clk
ad_connect axi_tx_fifo/dac_rst core_clk_a_rstgen/peripheral_reset
ad_connect util_som_tx_upack/s_axis_data axi_tx_fifo/dac_data
ad_connect util_som_tx_upack/s_axis_ready axi_tx_fifo/dac_valid
ad_connect axi_tx_fifo/axi_clk ddr4_1/c0_ddr4_ui_clk
ad_connect dac_fifo_bypass axi_tx_fifo/bypass
ad_connect util_som_tx_upack/s_axis_valid VCC_1/dout

ad_ip_instance clk_wiz dma_clk_wiz
ad_ip_parameter dma_clk_wiz CONFIG.PRIMITIVE MMCM
ad_ip_parameter dma_clk_wiz CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dma_clk_wiz CONFIG.USE_LOCKED false
ad_ip_parameter dma_clk_wiz CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 332.9
ad_ip_parameter dma_clk_wiz CONFIG.PRIM_SOURCE No_buffer

ad_connect sys_cpu_clk dma_clk_wiz/clk_in1
ad_connect sys_cpu_resetn dma_clk_wiz/resetn

ad_ip_instance proc_sys_reset sys_dma_rstgen
ad_ip_parameter sys_dma_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect sys_dma_clk dma_clk_wiz/clk_out1
ad_connect sys_dma_rstgen/ext_reset_in sys_rstgen/peripheral_reset
ad_connect sys_dma_clk sys_dma_rstgen/slowest_sync_clk
ad_connect sys_dma_resetn sys_dma_rstgen/peripheral_aresetn

# Loop back manual sync lines for each TPL
ad_connect tx_adrv9009_som_tpl_core/dac_tpl_core/dac_sync_manual_req_out tx_adrv9009_som_tpl_core/dac_tpl_core/dac_sync_manual_req_in
ad_connect rx_adrv9009_som_tpl_core/adc_tpl_core/adc_sync_manual_req_out rx_adrv9009_som_tpl_core/adc_tpl_core/adc_sync_manual_req_in
ad_connect obs_adrv9009_som_tpl_core/adc_tpl_core/adc_sync_manual_req_out obs_adrv9009_som_tpl_core/adc_tpl_core/adc_sync_manual_req_in

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 rx_adrv9009_som_tpl_core
ad_cpu_interconnect 0x44A04000 tx_adrv9009_som_tpl_core
ad_cpu_interconnect 0x44A08000 obs_adrv9009_som_tpl_core
ad_cpu_interconnect 0x44A20000 axi_adrv9009_som_tx_xcvr
ad_cpu_interconnect 0x44A30000 axi_adrv9009_som_tx_jesd
ad_cpu_interconnect 0x44A40000 axi_adrv9009_som_rx_xcvr
ad_cpu_interconnect 0x44A50000 axi_adrv9009_som_rx_jesd
ad_cpu_interconnect 0x44A60000 axi_adrv9009_som_obs_xcvr
ad_cpu_interconnect 0x44A70000 axi_adrv9009_som_obs_jesd
ad_cpu_interconnect 0x7c400000 axi_adrv9009_som_tx_dma
ad_cpu_interconnect 0x7c420000 axi_adrv9009_som_rx_dma
ad_cpu_interconnect 0x7c440000 axi_adrv9009_som_obs_dma
ad_cpu_interconnect 0x45000000 axi_sysid_0

# gt uses hp0, and 100MHz clock for both DRP and AXI4

ad_mem_hp0_interconnect sys_cpu_clk sys_ps8/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_adrv9009_som_rx_xcvr/m_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_adrv9009_som_obs_xcvr/m_axi

# interconnect (mem/dac)

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP3 1
ad_connect sys_dma_clk sys_ps8/saxihp1_fpd_aclk
ad_connect sys_dma_clk axi_adrv9009_som_obs_dma/m_dest_axi_aclk
ad_connect sys_dma_resetn axi_adrv9009_som_obs_dma/m_dest_axi_aresetn
ad_connect axi_adrv9009_som_obs_dma/m_dest_axi sys_ps8/S_AXI_HP1_FPD

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP4 1
ad_connect sys_dma_clk sys_ps8/saxihp2_fpd_aclk
ad_connect sys_dma_clk axi_adrv9009_som_rx_dma/m_dest_axi_aclk
ad_connect sys_dma_resetn axi_adrv9009_som_rx_dma/m_dest_axi_aresetn
ad_connect axi_adrv9009_som_rx_dma/m_dest_axi sys_ps8/S_AXI_HP2_FPD

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP5 1
ad_connect sys_dma_clk sys_ps8/saxihp3_fpd_aclk
ad_connect sys_dma_clk axi_adrv9009_som_tx_dma/m_src_axi_aclk
ad_connect sys_dma_resetn axi_adrv9009_som_tx_dma/m_src_axi_aresetn
ad_connect axi_adrv9009_som_tx_dma/m_src_axi sys_ps8/S_AXI_HP3_FPD

# interrupts

ad_cpu_interrupt ps-8 mb-8 axi_adrv9009_som_obs_dma/irq
ad_cpu_interrupt ps-9 mb-9 axi_adrv9009_som_tx_dma/irq
ad_cpu_interrupt ps-10 mb-15 axi_adrv9009_som_rx_dma/irq
ad_cpu_interrupt ps-11 mb-14 axi_adrv9009_som_obs_jesd/irq
ad_cpu_interrupt ps-12 mb-13 axi_adrv9009_som_tx_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_adrv9009_som_rx_jesd/irq

create_bd_addr_seg -range 0x80000000 -offset 0x00000000 \
    [get_bd_addr_spaces axi_adrv9009_som_obs_dma/m_dest_axi] [get_bd_addr_segs sys_ps8/SAXIGP3/HP1_DDR_LOW] SEG_sys_ps8_HP1_DDR_LOW
create_bd_addr_seg -range 0x80000000 -offset 0x00000000 \
    [get_bd_addr_spaces axi_adrv9009_som_rx_dma/m_dest_axi] [get_bd_addr_segs sys_ps8/SAXIGP4/HP2_DDR_LOW] SEG_sys_ps8_HP2_DDR_LOW
create_bd_addr_seg -range 0x80000000 -offset 0x00000000 \
    [get_bd_addr_spaces axi_adrv9009_som_tx_dma/m_src_axi] [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_LOW] SEG_sys_ps8_HP3_DDR_LOW
create_bd_addr_seg -range 0x80000000 -offset 0x80000000 \
    [get_bd_addr_spaces axi_tx_fifo/axi] [get_bd_addr_segs ddr4_1/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_ddr4_1_C0_DDR4_ADDRESS_BLOCK
