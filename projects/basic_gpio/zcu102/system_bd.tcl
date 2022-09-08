source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl

source $ad_hdl_dir/projects/basic_gpio/common/basic_gpio_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# ad_mem_hp0_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP0

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

create_bd_port -dir O -from 7 -to 0 tdd_out

ad_ip_instance axi_tdd tdd
ad_connect tdd/tdd_channel tdd_out
ad_connect sys_ps8/pl_clk1 tdd/clk
ad_connect sys_250m_rstgen/peripheral_aresetn tdd/resetn
ad_connect sys_cpu_clk tdd/s_axi_aclk 
ad_connect sys_cpu_resetn tdd/s_axi_aresetn
ad_connect GND tdd/sync_in

ad_cpu_interconnect 0x44a00000 tdd

