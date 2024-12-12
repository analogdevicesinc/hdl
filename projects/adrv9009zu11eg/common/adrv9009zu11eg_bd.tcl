###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

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

ad_ip_instance clk_wiz dma_clk_wiz
ad_ip_parameter dma_clk_wiz CONFIG.PRIMITIVE MMCM
ad_ip_parameter dma_clk_wiz CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dma_clk_wiz CONFIG.USE_LOCKED false
ad_ip_parameter dma_clk_wiz CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 250
ad_ip_parameter dma_clk_wiz CONFIG.PRIM_SOURCE No_buffer

ad_connect sys_cpu_clk dma_clk_wiz/clk_in1
ad_connect sys_cpu_resetn dma_clk_wiz/resetn

ad_ip_instance proc_sys_reset sys_dma_rstgen
ad_ip_parameter sys_dma_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect sys_dma_clk dma_clk_wiz/clk_out1
ad_connect sys_dma_rstgen/ext_reset_in sys_rstgen/peripheral_reset
ad_connect sys_dma_clk sys_dma_rstgen/slowest_sync_clk
ad_connect sys_dma_resetn sys_dma_rstgen/peripheral_aresetn

ad_cpu_interconnect 0x45000000 axi_sysid_0

# gt uses hp0, and 100MHz clock for both DRP and AXI4

# interconnect (mem/dac)

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP3 1
ad_connect sys_dma_clk sys_ps8/saxihp1_fpd_aclk

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP4 1
ad_connect sys_dma_clk sys_ps8/saxihp2_fpd_aclk




ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP5 1
ad_connect sys_dma_clk sys_ps8/saxihp3_fpd_aclk
