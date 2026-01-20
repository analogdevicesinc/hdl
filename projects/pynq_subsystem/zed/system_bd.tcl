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

# Connect IOP1 signals
# Note: IOP1 data pins are left unconnected (not connected to physical pins)
# Only IOP0 is connected to the physical data_bd pins
# IOP1 can still be used for internal processing, DDR access, etc.
ad_cpu_interrupt ps-13 mb-12 IOP1/intr_req

# Create AXI interconnect for IOP M_AXI connections to HP0
#ad_ip_instance axi_interconnect axi_iop_hp0_interconnect
#ad_ip_parameter axi_iop_hp0_interconnect CONFIG.NUM_MI 1
#ad_ip_parameter axi_iop_hp0_interconnect CONFIG.NUM_SI 2

#ad_connect sys_cpu_clk axi_iop_hp0_interconnect/ACLK
# ad_connect sys_cpu_clk axi_iop_hp0_interconnect/S00_ACLK
# ad_connect sys_cpu_clk axi_iop_hp0_interconnect/S01_ACLK
# ad_connect sys_cpu_clk axi_iop_hp0_interconnect/M00_ACLK
# ad_connect sys_cpu_resetn axi_iop_hp0_interconnect/ARESETN
# ad_connect sys_cpu_resetn axi_iop_hp0_interconnect/S00_ARESETN
# ad_connect sys_cpu_resetn axi_iop_hp0_interconnect/S01_ARESETN


#ad_ip_parameter axi_hp0_interconnect CONFIG.NUM_SI 2


# Connect reset signals

ad_connect sys_cpu_resetn IOP1/aux_reset_in


# Connect IOP1 M_AXI to interconnect for HP0 memory access
ad_mem_hp0_interconnect sys_cpu_clk IOP1/M_AXI
#ad_connect IOP1/M_AXI axi_hp0_interconnect/S01_AXI

# Create address segment for IOP1 to access DDR memory
create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces IOP1/IOP1_mb/Data] \
                    [get_bd_addr_segs sys_ps7/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_sys_ps7_HP0_DDR_LOWOCM