###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################


# Parameter description:
#   [TX/RX/RX_OS]_JESD_M  : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L  : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S  : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample

set MAX_RX_NUM_OF_LANES 2

set DATAPATH_WIDTH 4
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# RX parameters
set RX_NUM_OF_LANES $ad_project_params(RX_JESD_L)      ; # L
set RX_NUM_OF_CONVERTERS $ad_project_params(RX_JESD_M) ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S) ; # S
set RX_SAMPLE_WIDTH 16                                 ; # N/NP

set RX_OCTETS_PER_FRAME [expr $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_FRAME * $RX_SAMPLE_WIDTH / (8 * $RX_NUM_OF_LANES)] ; # F
set DPW [expr max(4, $RX_OCTETS_PER_FRAME)] ; #max(4, F)
set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8 * $DPW / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)] ; # L * 8 * DPW / (M* N)

set adc_dma_data_width [expr $RX_NUM_OF_LANES * 8 * $DPW]


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

create_bd_port -dir I core_clk_a

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

# create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_rtl_1
# create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_ref_1

# ad_ip_instance ip:ddr4 ddr4_1
# ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_DataWidth {32}
# ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_AxiDataWidth {256}
# ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_AxiAddressWidth {31}
# ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_InputClockPeriod {3334}
# ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_MemoryPart {MT40A512M16HA-075E}
# ad_ip_parameter ddr4_1 CONFIG.C0.BANK_GROUP_WIDTH {1}
# ad_ip_parameter ddr4_1 CONFIG.C0.DDR4_CasLatency {18}

# ad_connect ddr4_rtl_1 ddr4_1/C0_DDR4

# set_property -dict [list CONFIG.FREQ_HZ {300000000}] [get_bd_intf_ports ddr4_ref_1]
# ad_connect ddr4_ref_1 ddr4_1/C0_SYS_CLK

# create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr4_1_rstgen
# ad_connect ddr4_1_rstgen/slowest_sync_clk ddr4_1/c0_ddr4_ui_clk
# ad_connect ddr4_1/c0_ddr4_ui_clk_sync_rst ddr4_1_rstgen/ext_reset_in

# ad_connect sys_reset ddr4_1/sys_rst

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

ad_ip_instance util_adxcvr util_adrv9009_som_xcvr
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.RX_LANE_RATE 2.5
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.TX_LANE_RATE 2.5
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.TX_OUT_DIV 2
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.CPLL_FBDIV 4
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.RX_CLK25_DIV 10
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.TX_CLK25_DIV 10
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_adrv9009_som_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_xcvrpll  ref_clk_a util_adrv9009_som_xcvr/qpll_ref_clk_0
ad_xcvrpll  ref_clk_a util_adrv9009_som_xcvr/cpll_ref_clk_0
ad_xcvrpll  ref_clk_a util_adrv9009_som_xcvr/cpll_ref_clk_1

ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_qpll_rst_0
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_0
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_1
ad_connect  sys_cpu_resetn util_adrv9009_som_xcvr/up_rstn
ad_connect  sys_cpu_clk util_adrv9009_som_xcvr/up_clk

#ADRV2CRR_FMC

# Rx
ad_xcvrcon  util_adrv9009_som_xcvr axi_adrv9009_som_rx_xcvr axi_adrv9009_som_rx_jesd {} core_clk_a

# connections (adc)

ad_connect  core_clk_a rx_adrv9009_som_tpl_core/link_clk
ad_connect  core_clk_a util_som_rx_cpack/clk
ad_connect  axi_adrv9009_som_rx_dma/fifo_wr_clk core_clk_a

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

ad_connect util_som_rx_cpack/packed_fifo_wr axi_adrv9009_som_rx_dma/fifo_wr
ad_connect util_som_rx_cpack/packed_sync axi_adrv9009_som_rx_dma/sync

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

ad_connect rx_adrv9009_som_tpl_core/adc_tpl_core/adc_sync_manual_req_out rx_adrv9009_som_tpl_core/adc_tpl_core/adc_sync_manual_req_in

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 rx_adrv9009_som_tpl_core
ad_cpu_interconnect 0x44A40000 axi_adrv9009_som_rx_xcvr
ad_cpu_interconnect 0x44A50000 axi_adrv9009_som_rx_jesd
ad_cpu_interconnect 0x7c420000 axi_adrv9009_som_rx_dma
ad_cpu_interconnect 0x45000000 axi_sysid_0

# gt uses hp0, and 100MHz clock for both DRP and AXI4

ad_mem_hp0_interconnect sys_cpu_clk sys_ps8/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_adrv9009_som_rx_xcvr/m_axi

# interconnect (mem/dac)

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP4 1
ad_connect sys_dma_clk sys_ps8/saxihp2_fpd_aclk
ad_connect sys_dma_clk axi_adrv9009_som_rx_dma/m_dest_axi_aclk
ad_connect sys_dma_resetn axi_adrv9009_som_rx_dma/m_dest_axi_aresetn
ad_connect axi_adrv9009_som_rx_dma/m_dest_axi sys_ps8/S_AXI_HP2_FPD

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_adrv9009_som_rx_dma/irq
ad_cpu_interrupt ps-13 mb-12 axi_adrv9009_som_rx_jesd/irq

create_bd_addr_seg -range 0x80000000 -offset 0x00000000 \
    [get_bd_addr_spaces axi_adrv9009_som_rx_dma/m_dest_axi] [get_bd_addr_segs sys_ps8/SAXIGP4/HP2_DDR_LOW] SEG_sys_ps8_HP2_DDR_LOW
