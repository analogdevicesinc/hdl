###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
################################################################################

# create board design
source $ad_hdl_dir/projects/common/xilinx/adi_fir_filter_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# default ports

create_bd_port -dir O spi0_csn
create_bd_port -dir O spi0_sclk
create_bd_port -dir O spi0_mosi
create_bd_port -dir I spi0_miso

create_bd_port -dir I -from 94 -to 0 gpio_i
create_bd_port -dir O -from 94 -to 0 gpio_o
create_bd_port -dir O -from 94 -to 0 gpio_t

# ps8

ad_ip_instance zynq_ultra_ps_e sys_ps8

ad_ip_parameter sys_ps8 CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18}
ad_ip_parameter sys_ps8 CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18}
ad_ip_parameter sys_ps8 CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18}
ad_ip_parameter sys_ps8 CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18}

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 0
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP1 0
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP2 1
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP2__DATA_WIDTH 32
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL0_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ 100
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL1_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 250
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL2_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ 500
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__IRQ0 1
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__IRQ1 1
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__SPI0__PERIPHERAL__ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__SPI0__PERIPHERAL__IO {EMIO}
ad_ip_parameter sys_ps8 CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__SPI1__PERIPHERAL__IO {MIO 18 .. 23}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ 100
ad_ip_parameter sys_ps8 CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 16 .. 17}
ad_ip_parameter sys_ps8 CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel}
ad_ip_parameter sys_ps8 CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0 AUTODIR}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD1__GRP_CD__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD1__GRP_POW__ENABLE {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD1__GRP_WP__ENABLE {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 46 .. 51}
ad_ip_parameter sys_ps8 CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75}
ad_ip_parameter sys_ps8 CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__PMU__PERIPHERAL__ENABLE {0}

# some sets of parameters must be configured at the same tine to avoid tools issues
set_property -dict [list CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
                         CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
                         CONFIG.PSU__DP__LANE_SEL {Dual Higher} \
                         CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
                         CONFIG.PSU__SATA__LANE0__ENABLE {0} \
                         CONFIG.PSU__SATA__LANE1__ENABLE {1} \
                         CONFIG.PSU__SATA__LANE1__IO {GT Lane1} \
                         CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
                         CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
                         CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane0} \
                         CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk0} \
                         CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk1} \
                         CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk2} \
                         CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
                         CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
                         CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL}  \
                         CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
                         CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
                         CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
                         CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
                         CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
] [get_bd_cells sys_ps8]

ad_ip_parameter sys_ps8 CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P}
set_property -dict [list CONFIG.SUBPRESET1 {Custom} \
                         CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1066} \
                         CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
                         CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} \
                         CONFIG.PSU__DDRC__BUS_WIDTH {32 Bit} \
                         CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
                         CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
                         CONFIG.PSU__DDRC__PARITY_ENABLE {1} \
                         CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
                         CONFIG.PSU__DDRC__T_FAW {35} \
                         CONFIG.PSU__DDRC__CWL {11} \
                         CONFIG.PSU__DDRC__CL {15} \
                         CONFIG.PSU__DDRC__ECC {Disabled} \
] [get_bd_cells sys_ps8]

ad_ip_parameter sys_ps8 CONFIG.PSU_MIO_71_PULLUPDOWN {pulldown}
ad_ip_parameter sys_ps8 CONFIG.PSU_MIO_72_PULLUPDOWN {pulldown}
ad_ip_parameter sys_ps8 CONFIG.PSU_MIO_73_PULLUPDOWN {pulldown}
ad_ip_parameter sys_ps8 CONFIG.PSU_MIO_74_PULLUPDOWN {pulldown}

ad_ip_parameter sys_ps8 CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {0}
set_property -dict [list CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
                         CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 32 .. 33} \
                         ] [get_bd_cells sys_ps8]

ad_ip_parameter sys_ps8 CONFIG.PSU__SATA__REF_CLK_FREQ {150}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__DP__REF_CLK_FREQ 108
ad_ip_parameter sys_ps8 CONFIG.PSU__USB0_COHERENCY 1

# system reset/clock definitions
# processor system reset instances for all the three system clocks

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_ip_instance proc_sys_reset sys_250m_rstgen
ad_ip_parameter sys_250m_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_ip_instance proc_sys_reset sys_500m_rstgen
ad_ip_parameter sys_500m_rstgen CONFIG.C_EXT_RST_WIDTH 1

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps8/pl_clk0
ad_connect  sys_250m_clk sys_ps8/pl_clk1
ad_connect  sys_500m_clk sys_ps8/pl_clk2

ad_connect  sys_ps8/pl_resetn0 sys_rstgen/ext_reset_in
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_ps8/pl_resetn0 sys_250m_rstgen/ext_reset_in
ad_connect  sys_250m_clk sys_250m_rstgen/slowest_sync_clk
ad_connect  sys_ps8/pl_resetn0 sys_500m_rstgen/ext_reset_in
ad_connect  sys_500m_clk sys_500m_rstgen/slowest_sync_clk

ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_250m_reset sys_250m_rstgen/peripheral_reset
ad_connect  sys_250m_resetn sys_250m_rstgen/peripheral_aresetn
ad_connect  sys_500m_reset sys_500m_rstgen/peripheral_reset
ad_connect  sys_500m_resetn sys_500m_rstgen/peripheral_aresetn

# generic system clocks&resets pointers

set sys_cpu_clk            [get_bd_nets sys_cpu_clk]
set sys_dma_clk            [get_bd_nets sys_250m_clk]
set sys_iodelay_clk        [get_bd_nets sys_500m_clk]

set sys_cpu_reset          [get_bd_nets sys_cpu_reset]
set sys_cpu_resetn         [get_bd_nets sys_cpu_resetn]
set sys_dma_reset          [get_bd_nets sys_250m_reset]
set sys_dma_resetn         [get_bd_nets sys_250m_resetn]
set sys_iodelay_reset      [get_bd_nets sys_500m_reset]
set sys_iodelay_resetn     [get_bd_nets sys_500m_resetn]

# gpio

ad_connect  gpio_i sys_ps8/emio_gpio_i
ad_connect  gpio_o sys_ps8/emio_gpio_o
ad_connect  gpio_t sys_ps8/emio_gpio_t

# spi

ad_connect  sys_ps8/emio_spi0_ss_o_n  spi0_csn
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

ad_connect  sys_concat_intc_0/In7 GND
ad_connect  sys_concat_intc_0/In6 GND
ad_connect  sys_concat_intc_0/In5 GND
ad_connect  sys_concat_intc_0/In4 GND
ad_connect  sys_concat_intc_0/In3 GND
ad_connect  sys_concat_intc_0/In2 GND
ad_connect  sys_concat_intc_0/In1 GND
ad_connect  sys_concat_intc_0/In0 GND
ad_connect  sys_concat_intc_1/In7 GND
ad_connect  sys_concat_intc_1/In6 GND
ad_connect  sys_concat_intc_1/In5 GND
ad_connect  sys_concat_intc_1/In4 GND
ad_connect  sys_concat_intc_1/In3 GND
ad_connect  sys_concat_intc_1/In2 GND
ad_connect  sys_concat_intc_1/In1 GND
ad_connect  sys_concat_intc_1/In0 GND

# adrv9001 interface

create_bd_port -dir I rx1_dclk_in_n
create_bd_port -dir I rx1_dclk_in_p
create_bd_port -dir I rx1_idata_in_n
create_bd_port -dir I rx1_idata_in_p
create_bd_port -dir I rx1_qdata_in_n
create_bd_port -dir I rx1_qdata_in_p
create_bd_port -dir I rx1_strobe_in_n
create_bd_port -dir I rx1_strobe_in_p

create_bd_port -dir I rx2_dclk_in_n
create_bd_port -dir I rx2_dclk_in_p
create_bd_port -dir I rx2_idata_in_n
create_bd_port -dir I rx2_idata_in_p
create_bd_port -dir I rx2_qdata_in_n
create_bd_port -dir I rx2_qdata_in_p
create_bd_port -dir I rx2_strobe_in_n
create_bd_port -dir I rx2_strobe_in_p

create_bd_port -dir O tx1_dclk_out_n
create_bd_port -dir O tx1_dclk_out_p
create_bd_port -dir I tx1_dclk_in_n
create_bd_port -dir I tx1_dclk_in_p
create_bd_port -dir O tx1_idata_out_n
create_bd_port -dir O tx1_idata_out_p
create_bd_port -dir O tx1_qdata_out_n
create_bd_port -dir O tx1_qdata_out_p
create_bd_port -dir O tx1_strobe_out_n
create_bd_port -dir O tx1_strobe_out_p

create_bd_port -dir O tx2_dclk_out_n
create_bd_port -dir O tx2_dclk_out_p
create_bd_port -dir I tx2_dclk_in_n
create_bd_port -dir I tx2_dclk_in_p
create_bd_port -dir O tx2_idata_out_n
create_bd_port -dir O tx2_idata_out_p
create_bd_port -dir O tx2_qdata_out_n
create_bd_port -dir O tx2_qdata_out_p
create_bd_port -dir O tx2_strobe_out_n
create_bd_port -dir O tx2_strobe_out_p

create_bd_port -dir O rx1_enable
create_bd_port -dir O rx2_enable
create_bd_port -dir O tx1_enable
create_bd_port -dir O tx2_enable

create_bd_port -dir I gpio_rx1_enable_in
create_bd_port -dir I gpio_rx2_enable_in
create_bd_port -dir I gpio_tx1_enable_in
create_bd_port -dir I gpio_tx2_enable_in

create_bd_port -dir I ref_clk
create_bd_port -dir I tx_output_enable
create_bd_port -dir I mssi_sync
create_bd_port -dir I system_sync

create_bd_port -dir I s_1p0_rf_sns_p
create_bd_port -dir I s_1p0_rf_sns_n
create_bd_port -dir I s_1p8_rf_sns_p
create_bd_port -dir I s_1p8_rf_sns_n
create_bd_port -dir I s_1p3_rf_sns_p
create_bd_port -dir I s_1p3_rf_sns_n
create_bd_port -dir I s_5v0_rf_sns_p
create_bd_port -dir I s_5v0_rf_sns_n
create_bd_port -dir I s_2v5_sns_p
create_bd_port -dir I s_2v5_sns_n
create_bd_port -dir I s_vtt_ps_ddr4_sns_p
create_bd_port -dir I s_vtt_ps_ddr4_sns_n
create_bd_port -dir I s_1v2_ps_ddr4_sns_p
create_bd_port -dir I s_1v2_ps_ddr4_sns_n
create_bd_port -dir I s_0v85_mgtravcc_sns_p
create_bd_port -dir I s_0v85_mgtravcc_sns_n
create_bd_port -dir I s_5v0_sns_p
create_bd_port -dir I s_5v0_sns_n
create_bd_port -dir I s_1v2_sns_p
create_bd_port -dir I s_1v2_sns_n
create_bd_port -dir I s_1v8_mgtravtt_sns_p
create_bd_port -dir I s_1v8_mgtravtt_sns_n

# adrv9001

ad_ip_instance axi_adrv9001 axi_adrv9001
ad_ip_parameter axi_adrv9001 CONFIG.CMOS_LVDS_N 0
ad_ip_parameter axi_adrv9001 CONFIG.USE_RX_CLK_FOR_TX 0
ad_ip_parameter axi_adrv9001 CONFIG.EXT_SYNC 1

# dma for rx1

ad_ip_instance axi_dmac axi_adrv9001_rx1_dma
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_rx1_dma CONFIG.DMA_DATA_WIDTH_SRC 64

ad_ip_instance util_cpack2 util_adc_1_pack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for rx2

ad_ip_instance axi_dmac axi_adrv9001_rx2_dma
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_rx2_dma CONFIG.DMA_DATA_WIDTH_SRC 32

ad_ip_instance util_cpack2 util_adc_2_pack { \
  NUM_OF_CHANNELS 2 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for tx1

ad_ip_instance axi_dmac axi_adrv9001_tx1_dma
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_tx1_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance util_upack2 util_dac_1_upack { \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# dma for tx2

ad_ip_instance axi_dmac axi_adrv9001_tx2_dma
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9001_tx2_dma CONFIG.DMA_DATA_WIDTH_DEST 32

ad_ip_instance util_upack2 util_dac_2_upack { \
  NUM_OF_CHANNELS 2 \
  SAMPLE_DATA_WIDTH 16 \
}
# ad9001 connections

ad_connect  $sys_iodelay_clk       axi_adrv9001/delay_clk
ad_connect  axi_adrv9001/adc_1_clk axi_adrv9001_rx1_dma/fifo_wr_clk
ad_connect  axi_adrv9001/adc_1_clk util_adc_1_pack/clk

ad_connect  axi_adrv9001/adc_2_clk axi_adrv9001_rx2_dma/fifo_wr_clk
ad_connect  axi_adrv9001/adc_2_clk util_adc_2_pack/clk

ad_connect  axi_adrv9001/dac_1_clk axi_adrv9001_tx1_dma/m_axis_aclk
ad_connect  axi_adrv9001/dac_1_clk util_dac_1_upack/clk

ad_connect  axi_adrv9001/dac_2_clk axi_adrv9001_tx2_dma/m_axis_aclk
ad_connect  axi_adrv9001/dac_2_clk util_dac_2_upack/clk

ad_connect ref_clk           axi_adrv9001/ref_clk

ad_connect tx_output_enable  axi_adrv9001/tx_output_enable

ad_connect mssi_sync         axi_adrv9001/mssi_sync

ad_connect rx1_dclk_in_n     axi_adrv9001/rx1_dclk_in_n_NC
ad_connect rx1_dclk_in_p     axi_adrv9001/rx1_dclk_in_p_dclk_in
ad_connect rx1_idata_in_n    axi_adrv9001/rx1_idata_in_n_idata0
ad_connect rx1_idata_in_p    axi_adrv9001/rx1_idata_in_p_idata1
ad_connect rx1_qdata_in_n    axi_adrv9001/rx1_qdata_in_n_qdata2
ad_connect rx1_qdata_in_p    axi_adrv9001/rx1_qdata_in_p_qdata3
ad_connect rx1_strobe_in_n   axi_adrv9001/rx1_strobe_in_n_NC
ad_connect rx1_strobe_in_p   axi_adrv9001/rx1_strobe_in_p_strobe_in

ad_connect rx2_dclk_in_n     axi_adrv9001/rx2_dclk_in_n_NC
ad_connect rx2_dclk_in_p     axi_adrv9001/rx2_dclk_in_p_dclk_in
ad_connect rx2_idata_in_n    axi_adrv9001/rx2_idata_in_n_idata0
ad_connect rx2_idata_in_p    axi_adrv9001/rx2_idata_in_p_idata1
ad_connect rx2_qdata_in_n    axi_adrv9001/rx2_qdata_in_n_qdata2
ad_connect rx2_qdata_in_p    axi_adrv9001/rx2_qdata_in_p_qdata3
ad_connect rx2_strobe_in_n   axi_adrv9001/rx2_strobe_in_n_NC
ad_connect rx2_strobe_in_p   axi_adrv9001/rx2_strobe_in_p_strobe_in

ad_connect tx1_dclk_out_n    axi_adrv9001/tx1_dclk_out_n_NC
ad_connect tx1_dclk_out_p    axi_adrv9001/tx1_dclk_out_p_dclk_out
ad_connect tx1_dclk_in_n     axi_adrv9001/tx1_dclk_in_n_NC
ad_connect tx1_dclk_in_p     axi_adrv9001/tx1_dclk_in_p_dclk_in
ad_connect tx1_idata_out_n   axi_adrv9001/tx1_idata_out_n_idata0
ad_connect tx1_idata_out_p   axi_adrv9001/tx1_idata_out_p_idata1
ad_connect tx1_qdata_out_n   axi_adrv9001/tx1_qdata_out_n_qdata2
ad_connect tx1_qdata_out_p   axi_adrv9001/tx1_qdata_out_p_qdata3
ad_connect tx1_strobe_out_n  axi_adrv9001/tx1_strobe_out_n_NC
ad_connect tx1_strobe_out_p  axi_adrv9001/tx1_strobe_out_p_strobe_out

ad_connect tx2_dclk_out_n    axi_adrv9001/tx2_dclk_out_n_NC
ad_connect tx2_dclk_out_p    axi_adrv9001/tx2_dclk_out_p_dclk_out
ad_connect tx2_dclk_in_n     axi_adrv9001/tx2_dclk_in_n_NC
ad_connect tx2_dclk_in_p     axi_adrv9001/tx2_dclk_in_p_dclk_in
ad_connect tx2_idata_out_n   axi_adrv9001/tx2_idata_out_n_idata0
ad_connect tx2_idata_out_p   axi_adrv9001/tx2_idata_out_p_idata1
ad_connect tx2_qdata_out_n   axi_adrv9001/tx2_qdata_out_n_qdata2
ad_connect tx2_qdata_out_p   axi_adrv9001/tx2_qdata_out_p_qdata3
ad_connect tx2_strobe_out_n  axi_adrv9001/tx2_strobe_out_n_NC
ad_connect tx2_strobe_out_p  axi_adrv9001/tx2_strobe_out_p_strobe_out

# RX1_RX2 - CPACK - RX_DMA1
ad_connect  axi_adrv9001/adc_1_rst       util_adc_1_pack/reset
ad_connect  axi_adrv9001/adc_1_valid_i0  util_adc_1_pack/fifo_wr_en
ad_connect  axi_adrv9001/adc_1_enable_i0 util_adc_1_pack/enable_0
ad_connect  axi_adrv9001/adc_1_data_i0   util_adc_1_pack/fifo_wr_data_0
ad_connect  axi_adrv9001/adc_1_enable_q0 util_adc_1_pack/enable_1
ad_connect  axi_adrv9001/adc_1_data_q0   util_adc_1_pack/fifo_wr_data_1
ad_connect  axi_adrv9001/adc_1_enable_i1 util_adc_1_pack/enable_2
ad_connect  axi_adrv9001/adc_1_data_i1   util_adc_1_pack/fifo_wr_data_2
ad_connect  axi_adrv9001/adc_1_enable_q1 util_adc_1_pack/enable_3
ad_connect  axi_adrv9001/adc_1_data_q1   util_adc_1_pack/fifo_wr_data_3

ad_connect  axi_adrv9001/adc_1_dovf      util_adc_1_pack/fifo_wr_overflow

ad_connect util_adc_1_pack/packed_fifo_wr axi_adrv9001_rx1_dma/fifo_wr

# RX2 - CPACK - RX_DMA2
ad_connect  axi_adrv9001/adc_2_rst       util_adc_2_pack/reset
ad_connect  axi_adrv9001/adc_2_valid_i0  util_adc_2_pack/fifo_wr_en
ad_connect  axi_adrv9001/adc_2_enable_i0 util_adc_2_pack/enable_0
ad_connect  axi_adrv9001/adc_2_data_i0   util_adc_2_pack/fifo_wr_data_0
ad_connect  axi_adrv9001/adc_2_enable_q0 util_adc_2_pack/enable_1
ad_connect  axi_adrv9001/adc_2_data_q0   util_adc_2_pack/fifo_wr_data_1

ad_connect  axi_adrv9001/adc_2_dovf       util_adc_2_pack/fifo_wr_overflow

ad_connect util_adc_2_pack/packed_fifo_wr axi_adrv9001_rx2_dma/fifo_wr

# TX_DMA1 - UPACK - TX1
ad_connect  axi_adrv9001/dac_1_rst        util_dac_1_upack/reset
ad_connect  axi_adrv9001/dac_1_valid_i0   util_dac_1_upack/fifo_rd_en
ad_connect  axi_adrv9001/dac_1_enable_i0  util_dac_1_upack/enable_0
ad_connect  axi_adrv9001/dac_1_data_i0    util_dac_1_upack/fifo_rd_data_0
ad_connect  axi_adrv9001/dac_1_enable_q0  util_dac_1_upack/enable_1
ad_connect  axi_adrv9001/dac_1_data_q0    util_dac_1_upack/fifo_rd_data_1
ad_connect  axi_adrv9001/dac_1_enable_i1  util_dac_1_upack/enable_2
ad_connect  axi_adrv9001/dac_1_data_i1    util_dac_1_upack/fifo_rd_data_2
ad_connect  axi_adrv9001/dac_1_enable_q1  util_dac_1_upack/enable_3
ad_connect  axi_adrv9001/dac_1_data_q1    util_dac_1_upack/fifo_rd_data_3

ad_connect  axi_adrv9001_tx1_dma/m_axis   util_dac_1_upack/s_axis
ad_connect  axi_adrv9001/dac_1_dunf       util_dac_1_upack/fifo_rd_underflow

# TX_DMA2 - UPACK - TX2
ad_connect  axi_adrv9001/dac_2_rst        util_dac_2_upack/reset
ad_connect  axi_adrv9001/dac_2_valid_i0   util_dac_2_upack/fifo_rd_en
ad_connect  axi_adrv9001/dac_2_enable_i0  util_dac_2_upack/enable_0
ad_connect  axi_adrv9001/dac_2_data_i0    util_dac_2_upack/fifo_rd_data_0
ad_connect  axi_adrv9001/dac_2_enable_q0  util_dac_2_upack/enable_1
ad_connect  axi_adrv9001/dac_2_data_q0    util_dac_2_upack/fifo_rd_data_1

ad_connect  axi_adrv9001_tx2_dma/m_axis   util_dac_2_upack/s_axis
ad_connect  axi_adrv9001/dac_2_dunf       util_dac_2_upack/fifo_rd_underflow

ad_connect  gpio_rx1_enable_in            axi_adrv9001/gpio_rx1_enable_in
ad_connect  gpio_rx2_enable_in            axi_adrv9001/gpio_rx2_enable_in
ad_connect  gpio_tx1_enable_in            axi_adrv9001/gpio_tx1_enable_in
ad_connect  gpio_tx2_enable_in            axi_adrv9001/gpio_tx2_enable_in

ad_connect  rx1_enable                    axi_adrv9001/rx1_enable
ad_connect  rx2_enable                    axi_adrv9001/rx2_enable
ad_connect  tx1_enable                    axi_adrv9001/tx1_enable
ad_connect  tx2_enable                    axi_adrv9001/tx2_enable

ad_connect  system_sync                   axi_adrv9001/adc_sync_in
ad_connect  system_sync                   axi_adrv9001/dac_sync_in

# system monitor

ad_ip_instance system_management_wiz pl_sysmon

set_property -dict [list \
  CONFIG.CHANNEL_ENABLE_VP_VN {false} \
  CONFIG.CHANNEL_ENABLE_VAUXP0_VAUXN0 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP1_VAUXN1 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP2_VAUXN2 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP3_VAUXN3 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP4_VAUXN4 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP5_VAUXN5 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP6_VAUXN6 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP7_VAUXN7 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP8_VAUXN8 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP9_VAUXN9 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP10_VAUXN10 {true} \
  CONFIG.CHANNEL_ENABLE_VUSER0 {true} \
  CONFIG.CHANNEL_ENABLE_VUSER1 {true} \
  CONFIG.SELECT_USER_SUPPLY1 {VCCO} \
  CONFIG.USER_SUPPLY1_BANK {26} \
  CONFIG.CHANNEL_ENABLE_TEMPERATURE {true} \
  CONFIG.CHANNEL_ENABLE_VBRAM {false} \
  CONFIG.CHANNEL_ENABLE_VCCAUX {true} \
  CONFIG.CHANNEL_ENABLE_VCCINT {true} \
  CONFIG.ENABLE_VCCPSAUX_ALARM {false} \
  CONFIG.ENABLE_VCCPSINTFP_ALARM {false} \
  CONFIG.ENABLE_VCCPSINTLP_ALARM {false} \
  CONFIG.OT_ALARM {true} \
  CONFIG.USER_TEMP_ALARM {false} \
  CONFIG.VCCAUX_ALARM {false} \
  CONFIG.VCCINT_ALARM {false} \
  CONFIG.USER_SUPPLY0_ALARM {false} \
  CONFIG.USER_SUPPLY0_BANK {66} \
  CONFIG.ANALOG_BANK_SELECTION {66} \
  CONFIG.VAUXN0_LOC {A8} \
  CONFIG.VAUXP0_LOC {A9} \
  CONFIG.VAUXN1_LOC {B8} \
  CONFIG.VAUXP1_LOC {C8} \
  CONFIG.VAUXN2_LOC {F7} \
  CONFIG.VAUXP2_LOC {G7} \
  CONFIG.VAUXN3_LOC {F8} \
  CONFIG.VAUXP3_LOC {G8} \
  CONFIG.VAUXN4_LOC {B2} \
  CONFIG.VAUXP4_LOC {B3} \
  CONFIG.VAUXN5_LOC {A2} \
  CONFIG.VAUXP5_LOC {A3} \
  CONFIG.VAUXN6_LOC {H3} \
  CONFIG.VAUXP6_LOC {H4} \
  CONFIG.VAUXN7_LOC {F3} \
  CONFIG.VAUXP7_LOC {G3} \
  CONFIG.VAUXN8_LOC {B5} \
  CONFIG.VAUXP8_LOC {C5} \
  CONFIG.VAUXN9_LOC {A5} \
  CONFIG.VAUXP9_LOC {A6} \
  CONFIG.VAUXN10_LOC {G6} \
  CONFIG.VAUXP10_LOC {H6} \
  CONFIG.UNDER_TEMP_ALARM {true} \
  CONFIG.COMMON_N_SOURCE {Vaux6}] [get_bd_cells pl_sysmon]

ad_connect  pl_sysmon/vauxp0  s_1v2_ps_ddr4_sns_p
ad_connect  pl_sysmon/vauxn0  s_1v2_ps_ddr4_sns_n
ad_connect  pl_sysmon/vauxp1  s_2v5_sns_p
ad_connect  pl_sysmon/vauxn1  s_2v5_sns_n
ad_connect  pl_sysmon/vauxp2  s_1p3_rf_sns_p
ad_connect  pl_sysmon/vauxn2  s_1p3_rf_sns_n
ad_connect  pl_sysmon/vauxp3  s_1p0_rf_sns_p
ad_connect  pl_sysmon/vauxn3  s_1p0_rf_sns_n
ad_connect  pl_sysmon/vauxp4  s_1v8_mgtravtt_sns_p
ad_connect  pl_sysmon/vauxn4  s_1v8_mgtravtt_sns_n
ad_connect  pl_sysmon/vauxp5  s_1v2_sns_p
ad_connect  pl_sysmon/vauxn5  s_1v2_sns_n
ad_connect  pl_sysmon/vauxp6  s_5v0_sns_p
ad_connect  pl_sysmon/vauxn6  s_5v0_sns_n
ad_connect  pl_sysmon/vauxp7  s_0v85_mgtravcc_sns_p
ad_connect  pl_sysmon/vauxn7  s_0v85_mgtravcc_sns_n
ad_connect  pl_sysmon/vauxp8  s_vtt_ps_ddr4_sns_p
ad_connect  pl_sysmon/vauxn8  s_vtt_ps_ddr4_sns_n
ad_connect  pl_sysmon/vauxp9  s_5v0_rf_sns_p
ad_connect  pl_sysmon/vauxn9  s_5v0_rf_sns_n
ad_connect  pl_sysmon/vauxp10 s_1p8_rf_sns_p
ad_connect  pl_sysmon/vauxn10 s_1p8_rf_sns_n

ad_connect sys_cpu_clk     pl_sysmon/s_axi_aclk
ad_connect sys_cpu_resetn  pl_sysmon/s_axi_aresetn

ad_cpu_interconnect 0x44A00000  axi_adrv9001
ad_cpu_interconnect 0x44A30000  axi_adrv9001_rx1_dma
ad_cpu_interconnect 0x44A40000  axi_adrv9001_rx2_dma
ad_cpu_interconnect 0x44A50000  axi_adrv9001_tx1_dma
ad_cpu_interconnect 0x44A60000  axi_adrv9001_tx2_dma
ad_cpu_interconnect 0x45000000  axi_sysid_0
ad_cpu_interconnect 0x44A70000  pl_sysmon

ad_mem_hp1_interconnect $sys_dma_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9001_rx1_dma/m_dest_axi
ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9001_rx2_dma/m_dest_axi
ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9001_tx1_dma/m_src_axi
ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9001_tx2_dma/m_src_axi

ad_connect $sys_dma_resetn axi_adrv9001_rx1_dma/m_dest_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_rx2_dma/m_dest_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_tx1_dma/m_src_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9001_tx2_dma/m_src_axi_aresetn

# interrupts
ad_cpu_interrupt ps-13 mb-12 axi_adrv9001_rx1_dma/irq
ad_cpu_interrupt ps-12 mb-11 axi_adrv9001_rx2_dma/irq
ad_cpu_interrupt ps-11 mb-6 axi_adrv9001_tx1_dma/irq
ad_cpu_interrupt ps-10 mb-5 axi_adrv9001_tx2_dma/irq
ad_cpu_interrupt ps-9 mb-4 pl_sysmon/ip2intc_irpt

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file
