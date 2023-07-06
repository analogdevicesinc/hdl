###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../ad9083_evb/common/ad9083_evb_bd.tcl

# add spi interfaces

create_bd_port -dir O -from 1 -to 0 spi_bus1_csn_o
create_bd_port -dir I -from 1 -to 0 spi_bus1_csn_i
create_bd_port -dir I spi_bus1_clk_i
create_bd_port -dir O spi_bus1_clk_o
create_bd_port -dir I spi_bus1_sdo_i
create_bd_port -dir O spi_bus1_sdo_o
create_bd_port -dir I spi_bus1_sdi_i

create_bd_port -dir O -from 3 -to 0 spi_adl5960_1_csn_o
create_bd_port -dir I -from 3 -to 0 spi_adl5960_1_csn_i
create_bd_port -dir I spi_adl5960_1_clk_i
create_bd_port -dir O spi_adl5960_1_clk_o
create_bd_port -dir I spi_adl5960_1_sdo_i
create_bd_port -dir O spi_adl5960_1_sdo_o
create_bd_port -dir I spi_adl5960_1_sdi_i

create_bd_port -dir O -from 3 -to 0 spi_adl5960_2_csn_o
create_bd_port -dir I -from 3 -to 0 spi_adl5960_2_csn_i
create_bd_port -dir I spi_adl5960_2_clk_i
create_bd_port -dir O spi_adl5960_2_clk_o
create_bd_port -dir I spi_adl5960_2_sdo_i
create_bd_port -dir O spi_adl5960_2_sdo_o
create_bd_port -dir I spi_adl5960_2_sdi_i

# spi instances

ad_ip_instance axi_quad_spi axi_spi_bus1
ad_ip_parameter axi_spi_bus1 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_bus1 CONFIG.C_NUM_SS_BITS 2
ad_ip_parameter axi_spi_bus1 CONFIG.C_SCK_RATIO 8

ad_ip_instance axi_quad_spi axi_spi_adl5960_1
ad_ip_parameter axi_spi_adl5960_1 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_adl5960_1 CONFIG.C_NUM_SS_BITS 4
ad_ip_parameter axi_spi_adl5960_1 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_adl5960_1 CONFIG.Multiples16 8

ad_ip_instance axi_quad_spi axi_spi_adl5960_2
ad_ip_parameter axi_spi_adl5960_2 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_adl5960_2 CONFIG.C_NUM_SS_BITS 4
ad_ip_parameter axi_spi_adl5960_2 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_adl5960_2 CONFIG.Multiples16 8

# spi connections

ad_connect  sys_cpu_clk  axi_spi_bus1/ext_spi_clk
ad_connect  spi_bus1_csn_i  axi_spi_bus1/ss_i
ad_connect  spi_bus1_csn_o  axi_spi_bus1/ss_o
ad_connect  spi_bus1_clk_i  axi_spi_bus1/sck_i
ad_connect  spi_bus1_clk_o  axi_spi_bus1/sck_o
ad_connect  spi_bus1_sdo_i  axi_spi_bus1/io0_i
ad_connect  spi_bus1_sdo_o  axi_spi_bus1/io0_o
ad_connect  spi_bus1_sdi_i  axi_spi_bus1/io1_i

ad_connect  sys_cpu_clk  axi_spi_adl5960_1/ext_spi_clk
ad_connect  spi_adl5960_1_csn_i  axi_spi_adl5960_1/ss_i
ad_connect  spi_adl5960_1_csn_o  axi_spi_adl5960_1/ss_o
ad_connect  spi_adl5960_1_clk_i  axi_spi_adl5960_1/sck_i
ad_connect  spi_adl5960_1_clk_o  axi_spi_adl5960_1/sck_o
ad_connect  spi_adl5960_1_sdo_i  axi_spi_adl5960_1/io0_i
ad_connect  spi_adl5960_1_sdo_o  axi_spi_adl5960_1/io0_o
ad_connect  spi_adl5960_1_sdi_i  axi_spi_adl5960_1/io1_i

ad_connect  sys_cpu_clk  axi_spi_adl5960_2/ext_spi_clk
ad_connect  spi_adl5960_2_csn_i  axi_spi_adl5960_2/ss_i
ad_connect  spi_adl5960_2_csn_o  axi_spi_adl5960_2/ss_o
ad_connect  spi_adl5960_2_clk_i  axi_spi_adl5960_2/sck_i
ad_connect  spi_adl5960_2_clk_o  axi_spi_adl5960_2/sck_o
ad_connect  spi_adl5960_2_sdo_i  axi_spi_adl5960_2/io0_i
ad_connect  spi_adl5960_2_sdo_o  axi_spi_adl5960_2/io0_o
ad_connect  spi_adl5960_2_sdi_i  axi_spi_adl5960_2/io1_i

ad_cpu_interconnect 0x48000000 axi_spi_bus1
ad_cpu_interconnect 0x48100000 axi_spi_adl5960_1
ad_cpu_interconnect 0x48200000 axi_spi_adl5960_2

# interrupts

ad_cpu_interrupt ps-9 mb-8   axi_spi_bus1/ip2intc_irpt
ad_cpu_interrupt ps-10 mb-15 axi_spi_adl5960_1/ip2intc_irpt
ad_cpu_interrupt ps-11 mb-14 axi_spi_adl5960_2/ip2intc_irpt
