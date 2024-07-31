###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

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

create_bd_port -dir I -from 31 -to 0 fmcxmwbr1_gpio0_i
create_bd_port -dir O -from 31 -to 0 fmcxmwbr1_gpio0_o
create_bd_port -dir O -from 31 -to 0 fmcxmwbr1_gpio0_t
create_bd_port -dir I -from 31 -to 0 fmcxmwbr1_gpio1_i
create_bd_port -dir O -from 31 -to 0 fmcxmwbr1_gpio1_o
create_bd_port -dir O -from 31 -to 0 fmcxmwbr1_gpio1_t

ad_ip_instance axi_gpio axi_fmcxmwbr1_gpio
ad_ip_parameter axi_fmcxmwbr1_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter axi_fmcxmwbr1_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_fmcxmwbr1_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter axi_fmcxmwbr1_gpio CONFIG.C_INTERRUPT_PRESENT 1

ad_connect  fmcxmwbr1_gpio0_i axi_fmcxmwbr1_gpio/gpio_io_i
ad_connect  fmcxmwbr1_gpio0_o axi_fmcxmwbr1_gpio/gpio_io_o
ad_connect  fmcxmwbr1_gpio0_t axi_fmcxmwbr1_gpio/gpio_io_t
ad_connect  fmcxmwbr1_gpio1_i axi_fmcxmwbr1_gpio/gpio2_io_i
ad_connect  fmcxmwbr1_gpio1_o axi_fmcxmwbr1_gpio/gpio2_io_o
ad_connect  fmcxmwbr1_gpio1_t axi_fmcxmwbr1_gpio/gpio2_io_t


# AXI address definitions

ad_cpu_interconnect 0x43000000 axi_iic_1
ad_cpu_interconnect 0x43100000 axi_iic_2
ad_cpu_interconnect 0x44000000 axi_spi1
ad_cpu_interconnect 0x44500000 axi_spi2
ad_cpu_interconnect 0x46000000 axi_fmcxmwbr1_gpio

# interrupts

ad_cpu_interrupt "ps-1" "mb-1" axi_iic_1/iic2intc_irpt
ad_cpu_interrupt "ps-2" "mb-2" axi_iic_2/iic2intc_irpt
ad_cpu_interrupt "ps-3" "mb-3" axi_spi1/ip2intc_irpt
ad_cpu_interrupt "ps-4" "mb-4" axi_spi2/ip2intc_irpt
ad_cpu_interrupt "ps-5" "mb-5" axi_fmcxmwbr1_gpio/ip2intc_irpt
