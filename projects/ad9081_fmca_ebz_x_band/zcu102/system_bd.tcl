###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

ad_mem_hp0_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP0

source $ad_hdl_dir/projects/ad9081_fmca_ebz/common/ad9081_fmca_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# Parameters for 15.5Gpbs lane rate

ad_ip_parameter util_mxfe_xcvr CONFIG.RX_CLK25_DIV 31
ad_ip_parameter util_mxfe_xcvr CONFIG.TX_CLK25_DIV 31
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG0 0x1fa
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG1 0x23
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_CFG2 0x2
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_mxfe_xcvr CONFIG.A_TXDIFFCTRL 0xc
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG0 0x3
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG2_GEN2 0x265
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG2_GEN4 0x164
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3 0x1A
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN2 0x1A
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN3 0x1A
ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12
ad_ip_parameter util_mxfe_xcvr CONFIG.CH_HSPMUX 0x6868
ad_ip_parameter util_mxfe_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG0 0x4
ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG1 0x0
ad_ip_parameter util_mxfe_xcvr CONFIG.TXPI_CFG 0x0
ad_ip_parameter util_mxfe_xcvr CONFIG.TX_PI_BIASSET 3

ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_mxfe_xcvr CONFIG.POR_CFG 0x0
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CFG4 0x45
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_mxfe_xcvr CONFIG.PPF0_CFG 0xF00
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CP 0xFF
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_CP_G3 0xF
ad_ip_parameter util_mxfe_xcvr CONFIG.QPLL_LPF 0x2FF

# Overwrite parameter for lower lane rates which use CPLL
if {$ad_project_params(RX_LANE_RATE) < 12} {
  ad_ip_parameter util_mxfe_xcvr CONFIG.RX_WIDEMODE_CDR 0x0
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG0 0x200
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXPI_CFG1 0xFD

  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN2 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN3 0x12
  ad_ip_parameter util_mxfe_xcvr CONFIG.RXCDR_CFG3_GEN4 0x12
}

create_bd_port -dir O sys_clk
ad_connect sys_ps8/pl_clk0 sys_clk

# SPI and IIC for PMOD0 and PMOD1
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_pmod
ad_ip_instance axi_iic axi_iic_pmod
ad_connect iic_pmod axi_iic_pmod/iic

ad_cpu_interrupt ps-14 mb-8 axi_iic_pmod/iic2intc_irpt

ad_cpu_interconnect 0x45100000 axi_iic_pmod

create_bd_port -dir O -from 7 -to 0 spi_pmod_csn_o
create_bd_port -dir I -from 7 -to 0 spi_pmod_csn_i
create_bd_port -dir I spi_pmod_clk_i
create_bd_port -dir O spi_pmod_clk_o
create_bd_port -dir I spi_pmod_sdo_i
create_bd_port -dir O spi_pmod_sdo_o
create_bd_port -dir I spi_pmod_sdi_i

# SPI at 100/8 = 12.5 MHz
ad_ip_instance axi_quad_spi axi_spi_pmod
ad_ip_parameter axi_spi_pmod CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_pmod CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_pmod CONFIG.C_SCK_RATIO 8

ad_connect spi_pmod_csn_i axi_spi_pmod/ss_i
ad_connect spi_pmod_csn_o axi_spi_pmod/ss_o
ad_connect spi_pmod_clk_i axi_spi_pmod/sck_i
ad_connect spi_pmod_clk_o axi_spi_pmod/sck_o
ad_connect spi_pmod_sdo_i axi_spi_pmod/io0_i
ad_connect spi_pmod_sdo_o axi_spi_pmod/io0_o
ad_connect spi_pmod_sdi_i axi_spi_pmod/io1_i

ad_connect $sys_cpu_clk axi_spi_pmod/ext_spi_clk

ad_cpu_interrupt ps-15 mb-7 axi_spi_pmod/ip2intc_irpt

ad_cpu_interconnect 0x45200000 axi_spi_pmod

# SPI for FMC interposer
create_bd_port -dir O -from 7 -to 0 spi_fmc_csn_o
create_bd_port -dir I -from 7 -to 0 spi_fmc_csn_i
create_bd_port -dir I spi_fmc_clk_i
create_bd_port -dir O spi_fmc_clk_o
create_bd_port -dir I spi_fmc_sdo_i
create_bd_port -dir O spi_fmc_sdo_o
create_bd_port -dir I spi_fmc_sdi_i

# SPI at 100/16 = 6.25 MHz
ad_ip_instance axi_quad_spi axi_spi_fmc
ad_ip_parameter axi_spi_fmc CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_fmc CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_fmc CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_fmc CONFIG.Multiples16 1

ad_connect spi_fmc_csn_i axi_spi_fmc/ss_i
ad_connect spi_fmc_csn_o axi_spi_fmc/ss_o
ad_connect spi_fmc_clk_i axi_spi_fmc/sck_i
ad_connect spi_fmc_clk_o axi_spi_fmc/sck_o
ad_connect spi_fmc_sdo_i axi_spi_fmc/io0_i
ad_connect spi_fmc_sdo_o axi_spi_fmc/io0_o
ad_connect spi_fmc_sdi_i axi_spi_fmc/io1_i

ad_connect $sys_cpu_clk axi_spi_fmc/ext_spi_clk

ad_cpu_interrupt ps-9 mb-7 axi_spi_fmc/ip2intc_irpt

ad_cpu_interconnect 0x45300000 axi_spi_fmc

# Connect TDD
create_bd_port -dir I tdd_sync
create_bd_port -dir O tdd_enabled
create_bd_port -dir O tdd_rx_mxfe_en
create_bd_port -dir O tdd_tx_mxfe_en
create_bd_port -dir O tdd_tx_stingray_en

set tdd_sync_in_net [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins axi_tdd_0/sync_in]]]
set tdd_sync_in_pin [get_bd_pins axi_tdd_0/sync_in]
ad_disconnect $tdd_sync_in_net $tdd_sync_in_pin
ad_connect axi_tdd_0/sync_in tdd_sync
ad_connect axi_tdd_0/tdd_channel_2 tdd_enabled
ad_connect axi_tdd_0/tdd_channel_3 tdd_rx_mxfe_en
ad_connect axi_tdd_0/tdd_channel_4 tdd_tx_mxfe_en
ad_connect axi_tdd_0/tdd_channel_5 tdd_tx_stingray_en

