###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set FMCOMMS8 1
source ../common/adrv9009zu11eg_bd.tcl
source ../common/adrv2crr_fmc_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

create_bd_port -dir I ref_clk_c
create_bd_port -dir I ref_clk_d

create_bd_port -dir I core_clk_c
create_bd_port -dir I core_clk_d

create_bd_port -dir I -from 31 -to 0 fmcomms8_gpio0_i
create_bd_port -dir O -from 31 -to 0 fmcomms8_gpio0_o
create_bd_port -dir O -from 31 -to 0 fmcomms8_gpio0_t
create_bd_port -dir I -from 31 -to 0 fmcomms8_gpio1_i
create_bd_port -dir O -from 31 -to 0 fmcomms8_gpio1_o
create_bd_port -dir O -from 31 -to 0 fmcomms8_gpio1_t

create_bd_port -dir O -from 2 -to 0 spi1_csn
create_bd_port -dir O spi1_sclk
create_bd_port -dir O spi1_mosi
create_bd_port -dir I spi1_miso

# spi

set_property -dict [list CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {1} CONFIG.PSU__SPI1__PERIPHERAL__IO {EMIO}] [get_bd_cells sys_ps8]
set_property -dict [list CONFIG.PSU__SPI1__GRP_SS1__ENABLE {1} CONFIG.PSU__SPI1__GRP_SS2__ENABLE {1}] [get_bd_cells sys_ps8]

ad_ip_instance xlconcat spi1_csn_concat
ad_ip_parameter spi1_csn_concat CONFIG.NUM_PORTS 3
ad_connect  sys_ps8/emio_spi1_ss_o_n spi1_csn_concat/In0
ad_connect  sys_ps8/emio_spi1_ss1_o_n spi1_csn_concat/In1
ad_connect  sys_ps8/emio_spi1_ss2_o_n spi1_csn_concat/In2
ad_connect  spi1_csn_concat/dout spi1_csn
ad_connect  sys_ps8/emio_spi1_sclk_o spi1_sclk
ad_connect  sys_ps8/emio_spi1_m_o spi1_mosi
ad_connect  sys_ps8/emio_spi1_m_i spi1_miso
ad_connect  sys_ps8/emio_spi1_ss_i_n VCC
ad_connect  sys_ps8/emio_spi1_sclk_i GND
ad_connect  sys_ps8/emio_spi1_s_i GND

ad_ip_instance axi_gpio axi_fmcomms8_gpio
ad_ip_parameter axi_fmcomms8_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter axi_fmcomms8_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_fmcomms8_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter axi_fmcomms8_gpio CONFIG.C_INTERRUPT_PRESENT 1

ad_connect  fmcomms8_gpio0_i axi_fmcomms8_gpio/gpio_io_i
ad_connect  fmcomms8_gpio0_o axi_fmcomms8_gpio/gpio_io_o
ad_connect  fmcomms8_gpio0_t axi_fmcomms8_gpio/gpio_io_t
ad_connect  fmcomms8_gpio1_i axi_fmcomms8_gpio/gpio2_io_i
ad_connect  fmcomms8_gpio1_o axi_fmcomms8_gpio/gpio2_io_o
ad_connect  fmcomms8_gpio1_t axi_fmcomms8_gpio/gpio2_io_t

ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/qpll_ref_clk_8
ad_xcvrpll  ref_clk_d util_adrv9009_som_xcvr/cpll_ref_clk_8
ad_xcvrpll  ref_clk_d util_adrv9009_som_xcvr/cpll_ref_clk_9
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/cpll_ref_clk_10
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/cpll_ref_clk_11
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/qpll_ref_clk_12
ad_xcvrpll  ref_clk_d util_adrv9009_som_xcvr/cpll_ref_clk_12
ad_xcvrpll  ref_clk_d util_adrv9009_som_xcvr/cpll_ref_clk_13
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/cpll_ref_clk_14
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/cpll_ref_clk_15

ad_xcvrpll  axi_adrv9009_som_tx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_qpll_rst_8
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_8
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_9
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_10
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_11
ad_xcvrpll  axi_adrv9009_som_tx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_qpll_rst_12
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_12
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_13
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_14
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_15

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_cpu_interconnect 0x46000000 axi_fmcomms8_gpio

# interconnect (mem/dac)

ad_cpu_interrupt ps-4 mb-4 axi_fmcomms8_gpio/ip2intc_irpt
