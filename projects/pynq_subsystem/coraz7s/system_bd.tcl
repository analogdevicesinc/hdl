###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/coraz7s/coraz7s_system_bd.tcl
source ../common/pynq_subsystem_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_cpu_interconnect 0x45020000  IOP1/mb_bram_ctrl
set_property range 128K [get_bd_addr_segs {sys_ps7/Data/mb_bram_ctrl}]

ad_cpu_interconnect 0x45010000  system_interrupts
ad_cpu_interconnect 0x45040000 i3c/host_interface

ad_cpu_interconnect 0x45050000 i3c_offload_dma
ad_cpu_interconnect 0x45060000 i3c_offload_pwm

ad_cpu_interrupt "ps-0" "mb-0"  system_interrupts/irq

ad_cpu_interrupt "ps-13" "mb-13" i3c_offload_dma/irq

ad_cpu_interrupt "ps-12" "mb-12" i3c/irq