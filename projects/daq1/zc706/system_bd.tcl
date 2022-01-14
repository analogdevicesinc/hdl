
set adc_fifo_address_width 18
set adc_data_width 64
set adc_dma_data_width 64

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
#source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_adcfifo_bd.tcl
source ../common/daq1_bd.tcl

set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {250}] [get_bd_cells sys_ps7]
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
connect_bd_net [get_bd_pins sys_ps7/FCLK_CLK2] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins sys_ps7/FCLK_RESET2_N] [get_bd_pins proc_sys_reset_0/ext_reset_in]
disconnect_bd_net /sys_200m_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
connect_bd_net [get_bd_pins sys_ps7/FCLK_CLK2] [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
disconnect_bd_net /sys_200m_clk [get_bd_pins axi_ad9684_dma/m_dest_axi_aclk]
disconnect_bd_net /sys_200m_clk [get_bd_pins axi_ad9122_dma/m_src_axi_aclk]
disconnect_bd_net /sys_200m_clk [get_bd_pins sys_ps7/S_AXI_HP1_ACLK]
connect_bd_net [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] [get_bd_pins sys_ps7/FCLK_CLK2]
connect_bd_net [get_bd_pins axi_ad9684_dma/m_dest_axi_aclk] [get_bd_pins sys_ps7/FCLK_CLK2]
connect_bd_net [get_bd_pins axi_ad9122_dma/m_src_axi_aclk] [get_bd_pins sys_ps7/FCLK_CLK2]
disconnect_bd_net /sys_200m_resetn [get_bd_pins axi_ad9122_dma/m_src_axi_aresetn]
delete_bd_objs [get_bd_nets sys_200m_resetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_ad9122_dma/m_src_axi_aresetn]
connect_bd_net [get_bd_pins axi_ad9684_dma/m_dest_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]

# System ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

#set sys_cstring "ADC_OFFLOAD_TYPE=$adc_offload_type\nDAC_OFFLOAD_TYPE=$dac_offload_type"
#sysid_gen_sys_init_file $sys_cstring
sysid_gen_sys_init_file
