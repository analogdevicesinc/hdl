###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../common/adrv9009zu11eg_bd.tcl
source ../common/adrv2crr_fmc_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# iic

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_1
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_2

ad_ip_instance axi_iic axi_iic_1
ad_connect iic_1 axi_iic_1/iic

ad_ip_instance axi_iic axi_iic_2
ad_connect iic_2 axi_iic_2/iic

# spi

create_bd_port -dir O -from 7 -to 0 spi1_csn_o
create_bd_port -dir I -from 7 -to 0 spi1_csn_i
create_bd_port -dir I spi1_clk_i
create_bd_port -dir O spi1_clk_o
create_bd_port -dir I spi1_sdo_i
create_bd_port -dir O spi1_sdo_o
create_bd_port -dir I spi1_sdi_i

ad_ip_instance axi_quad_spi axi_spi1
ad_ip_parameter axi_spi1 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi1 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi1 CONFIG.C_SCK_RATIO 16

ad_connect spi1_csn_i axi_spi1/ss_i
ad_connect spi1_csn_o axi_spi1/ss_o
ad_connect spi1_clk_i axi_spi1/sck_i
ad_connect spi1_clk_o axi_spi1/sck_o
ad_connect spi1_sdo_i axi_spi1/io0_i
ad_connect spi1_sdo_o axi_spi1/io0_o
ad_connect spi1_sdi_i axi_spi1/io1_i

set_property -dict [list CONFIG.PSU__FPGA_PL3_ENABLE {1} CONFIG.PSU__CRL_APB__PL3_REF_CTRL__SRCSEL {IOPLL} CONFIG.PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {8}] [get_bd_cells sys_ps8]
ad_connect sys_ps8/pl_clk3 axi_spi1/ext_spi_clk

create_bd_port -dir O -from 7 -to 0 spi2_csn_o
create_bd_port -dir I -from 7 -to 0 spi2_csn_i
create_bd_port -dir I spi2_clk_i
create_bd_port -dir O spi2_clk_o
create_bd_port -dir I spi2_sdo_i
create_bd_port -dir O spi2_sdo_o
create_bd_port -dir I spi2_sdi_i

ad_ip_instance axi_quad_spi axi_spi2
ad_ip_parameter axi_spi2 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi2 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi2 CONFIG.C_SCK_RATIO 16

ad_connect spi2_csn_i axi_spi2/ss_i
ad_connect spi2_csn_o axi_spi2/ss_o
ad_connect spi2_clk_i axi_spi2/sck_i
ad_connect spi2_clk_o axi_spi2/sck_o
ad_connect spi2_sdo_i axi_spi2/io0_i
ad_connect spi2_sdo_o axi_spi2/io0_o
ad_connect spi2_sdi_i axi_spi2/io1_i

ad_connect axi_spi2/ext_spi_clk sys_ps8/pl_clk3

# gpio

create_bd_port -dir I -from 31 -to 0 xmicrowave_gpio0_i
create_bd_port -dir O -from 31 -to 0 xmicrowave_gpio0_o
create_bd_port -dir O -from 31 -to 0 xmicrowave_gpio0_t
create_bd_port -dir I -from 31 -to 0 xmicrowave_gpio1_i
create_bd_port -dir O -from 31 -to 0 xmicrowave_gpio1_o
create_bd_port -dir O -from 31 -to 0 xmicrowave_gpio1_t

ad_ip_instance axi_gpio axi_xmicrowave_gpio
ad_ip_parameter axi_xmicrowave_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter axi_xmicrowave_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_xmicrowave_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter axi_xmicrowave_gpio CONFIG.C_INTERRUPT_PRESENT 1

ad_connect  xmicrowave_gpio0_i axi_xmicrowave_gpio/gpio_io_i
ad_connect  xmicrowave_gpio0_o axi_xmicrowave_gpio/gpio_io_o
ad_connect  xmicrowave_gpio0_t axi_xmicrowave_gpio/gpio_io_t
ad_connect  xmicrowave_gpio1_i axi_xmicrowave_gpio/gpio2_io_i
ad_connect  xmicrowave_gpio1_o axi_xmicrowave_gpio/gpio2_io_o
ad_connect  xmicrowave_gpio1_t axi_xmicrowave_gpio/gpio2_io_t


# AXI address definitions

ad_cpu_interconnect 0x43000000 axi_iic_1
ad_cpu_interconnect 0x43100000 axi_iic_2
ad_cpu_interconnect 0x44000000 axi_spi1
ad_cpu_interconnect 0x44500000 axi_spi2
ad_cpu_interconnect 0x46000000 axi_xmicrowave_gpio

# interrupts

ad_cpu_interrupt "ps-1" "mb-1" axi_iic_1/iic2intc_irpt
ad_cpu_interrupt "ps-2" "mb-2" axi_iic_2/iic2intc_irpt
ad_cpu_interrupt "ps-3" "mb-3" axi_spi1/ip2intc_irpt
ad_cpu_interrupt "ps-4" "mb-4" axi_spi2/ip2intc_irpt
ad_cpu_interrupt "ps-5" "mb-5" axi_xmicrowave_gpio/ip2intc_irpt
