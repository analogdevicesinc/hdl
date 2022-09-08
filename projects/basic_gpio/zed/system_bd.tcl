source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

create_bd_port -dir O tdd_clk
create_bd_port -dir O -from 3 -to 0 tdd_out
create_bd_port -dir I tdd_sync_in
create_bd_port -dir O tdd_sync_out

ad_ip_instance axi_tdd tdd
ad_ip_parameter tdd CONFIG.CHANNEL_COUNT 4
ad_ip_parameter tdd CONFIG.SYNC_COUNT_WIDTH 32
ad_connect tdd/tdd_channel tdd_out
ad_connect sys_200m_clk tdd/clk
ad_connect sys_200m_clk tdd_clk
ad_connect sys_200m_resetn tdd/resetn
ad_connect sys_cpu_clk tdd/s_axi_aclk
ad_connect sys_cpu_resetn tdd/s_axi_aresetn
ad_connect tdd_sync_in tdd/sync_in
ad_connect tdd/sync_out tdd_sync_out

ad_cpu_interconnect 0x44a00000 tdd

