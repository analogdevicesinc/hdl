
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl


ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 200
set_property name sys_200m_rstgen [get_bd_cells sys_250m_rstgen]
set_property name sys_200m_clk [get_bd_nets sys_250m_clk]
set_property name sys_200m_reset [get_bd_nets sys_250m_reset]
set_property name sys_200m_resetn [get_bd_nets sys_250m_resetn]

source ../common/ad4858_fmcz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

disconnect_bd_net /sys_200m_clk [get_bd_pins axi_ad4858_0/delay_clk]
disconnect_bd_net /sys_200m_clk [get_bd_pins axi_ad4858_1/delay_clk]
ad_connect sys_ps8/pl_clk2 axi_ad4858_0/delay_clk
ad_connect sys_ps8/pl_clk2 axi_ad4858_1/delay_clk

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

