###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set adc_offload_type 0                        ; ## BRAM
set adc_offload_size [expr 2 * 1024]          ; ## 2 KB

set dac_offload_type 1                        ; ## BRAM
set dac_offload_size [expr 2*1024*1024*1024]  ; ## 2 GB

source ../common/adrv9009zu11eg_bd.tcl
source ../common/adrv2crr_fmc_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "RX:M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
TX:M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
RX_OS:M=$ad_project_params(RX_OS_JESD_M)\
L=$ad_project_params(RX_OS_JESD_L)\
S=$ad_project_params(RX_OS_JESD_S)"

sysid_gen_sys_init_file $sys_cstring

# Stingray

create_bd_port -dir O sys_clk
ad_connect sys_ps8/pl_clk0 sys_clk

# SPI and IIC for PMOD0 and PMOD1 (Stingray 0)
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

ad_connect sys_ps8/pl_clk0 axi_spi_pmod/ext_spi_clk

ad_cpu_interrupt ps-15 mb-15 axi_spi_pmod/ip2intc_irpt
ad_cpu_interconnect 0x45200000 axi_spi_pmod

# SPI and IIC for PMOD0 and PMOD1 (Stingray 1)
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_pmod_2
ad_ip_instance axi_iic axi_iic_2_pmod
ad_connect iic_pmod_2 axi_iic_2_pmod/iic

ad_cpu_interrupt ps-2 mb-2 axi_iic_2_pmod/iic2intc_irpt
ad_cpu_interconnect 0x45300000 axi_iic_2_pmod

create_bd_port -dir O -from 7 -to 0 spi_pmod_2_csn_o
create_bd_port -dir I -from 7 -to 0 spi_pmod_2_csn_i
create_bd_port -dir I spi_pmod_2_clk_i
create_bd_port -dir O spi_pmod_2_clk_o
create_bd_port -dir I spi_pmod_2_sdo_i
create_bd_port -dir O spi_pmod_2_sdo_o
create_bd_port -dir I spi_pmod_2_sdi_i

# SPI at 100/8 = 12.5 MHz
ad_ip_instance axi_quad_spi axi_spi_pmod_2
ad_ip_parameter axi_spi_pmod_2 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_pmod_2 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_pmod_2 CONFIG.C_SCK_RATIO 8

ad_connect spi_pmod_2_csn_i axi_spi_pmod_2/ss_i
ad_connect spi_pmod_2_csn_o axi_spi_pmod_2/ss_o
ad_connect spi_pmod_2_clk_i axi_spi_pmod_2/sck_i
ad_connect spi_pmod_2_clk_o axi_spi_pmod_2/sck_o
ad_connect spi_pmod_2_sdo_i axi_spi_pmod_2/io0_i
ad_connect spi_pmod_2_sdo_o axi_spi_pmod_2/io0_o
ad_connect spi_pmod_2_sdi_i axi_spi_pmod_2/io1_i

ad_connect sys_ps8/pl_clk0 axi_spi_pmod_2/ext_spi_clk

# TODO:
ad_cpu_interrupt ps-3 mb-3 axi_spi_pmod_2/ip2intc_irpt
ad_cpu_interconnect 0x45400000 axi_spi_pmod_2

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

ad_connect sys_ps8/pl_clk0 axi_spi_fmc/ext_spi_clk

ad_cpu_interrupt ps-4 mb-4 axi_spi_fmc/ip2intc_irpt

ad_cpu_interconnect 0x45500000 axi_spi_fmc

# GPIOs
create_bd_port -dir I -from 31 -to 0 fmc_gpio0_i
create_bd_port -dir O -from 31 -to 0 fmc_gpio0_o
create_bd_port -dir O -from 31 -to 0 fmc_gpio0_t

ad_ip_instance axi_gpio axi_fmc_gpio
ad_ip_parameter axi_fmc_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_fmc_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter axi_fmc_gpio CONFIG.C_INTERRUPT_PRESENT 1

ad_connect fmc_gpio0_i axi_fmc_gpio/gpio_io_i
ad_connect fmc_gpio0_o axi_fmc_gpio/gpio_io_o
ad_connect fmc_gpio0_t axi_fmc_gpio/gpio_io_t

ad_cpu_interconnect 0x46000000 axi_fmc_gpio

# interconnect (mem/dac)

ad_cpu_interrupt ps-5 mb-5 axi_fmc_gpio/ip2intc_irpt

# Connect TDD
create_bd_port -dir I tdd_sync
create_bd_port -dir O tdd_enabled
create_bd_port -dir O tdd_rx_en
create_bd_port -dir O tdd_tx_en
create_bd_port -dir O tdd_tx_stingray_en
create_bd_port -dir O tdd_channel_0
create_bd_port -dir O tdd_channel_1
create_bd_port -dir O tdd_sync_out

if {$TDD_SUPPORT} {
  set tdd_sync_in_net [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins axi_tdd_0/sync_in]]]
  set tdd_sync_in_pin [get_bd_pins axi_tdd_0/sync_in]

  ad_disconnect $tdd_sync_in_net               $tdd_sync_in_pin

  ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.SYNC_TRANSFER_START 1
  ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.DMA_LENGTH_WIDTH 30

  ad_connect axi_tdd_0/sync_in tdd_sync
  ad_connect axi_tdd_0/tdd_channel_1 axi_adrv9009_som_rx_dma/s_axis_user
  ad_connect axi_tdd_0/tdd_channel_2 tdd_enabled
  ad_connect axi_tdd_0/tdd_channel_3 tdd_rx_en
  ad_connect axi_tdd_0/tdd_channel_4 tdd_tx_en
  ad_connect axi_tdd_0/tdd_channel_5 tdd_tx_stingray_en

  ad_connect axi_tdd_0/tdd_channel_0 tdd_channel_0
  ad_connect axi_tdd_0/tdd_channel_1 tdd_channel_1
  ad_connect axi_tdd_0/sync_out      tdd_sync_out
}
