###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file


source ../common/create_pynq_mb_subsystem.tcl

# -----------------------
# IOP1 Instance (with different base address)
# -----------------------
create_pynq_mb_subsystem IOP1


ad_cpu_interrupt ps-13 mb-12 IOP1/intr_req

#ad_connect sys_cpu_resetn IOP1/aux_reset_in

#ad_mem_hp0_interconnect sys_cpu_clk IOP1/M_AXI
#add SPI
create_bd_port -dir I  SPI_0_io0_i
create_bd_port -dir O  SPI_0_io0_o
create_bd_port -dir O  SPI_0_io0_t
create_bd_port -dir I  SPI_0_io1_i
create_bd_port -dir O  SPI_0_io1_o
create_bd_port -dir O  SPI_0_io1_t
create_bd_port -dir I  SPI_0_sck_i
create_bd_port -dir O  SPI_0_sck_o
create_bd_port -dir O  SPI_0_sck_t
create_bd_port -dir I  SPI_0_ss_i
create_bd_port -dir O  SPI_0_ss_o
create_bd_port -dir O  SPI_0_ss_t


ad_connect    SPI_0_io0_i   IOP1/SPI_0_io0_i
ad_connect    SPI_0_io0_o   IOP1/SPI_0_io0_o
ad_connect    SPI_0_io0_t   IOP1/SPI_0_io0_t
ad_connect    SPI_0_io1_i   IOP1/SPI_0_io1_i
ad_connect    SPI_0_io1_o   IOP1/SPI_0_io1_o
ad_connect    SPI_0_io1_t   IOP1/SPI_0_io1_t
ad_connect    SPI_0_sck_i   IOP1/SPI_0_sck_i
ad_connect    SPI_0_sck_o   IOP1/SPI_0_sck_o
ad_connect    SPI_0_sck_t   IOP1/SPI_0_sck_t
ad_connect    SPI_0_ss_i    IOP1/SPI_0_ss_i
ad_connect    SPI_0_ss_o    IOP1/SPI_0_ss_o
ad_connect    SPI_0_ss_t    IOP1/SPI_0_ss_t

#GPIO
create_bd_port -dir O  data_o
ad_connect    data_o   IOP1/data_o
