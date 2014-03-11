
source $ad_hdl_dir/projects/common/zc702/zc702_system_bd.tcl
source ../common/fmcomms1_bd.tcl

create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces axi_ad9643_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces axi_ad9122_dma/m_src_axi]   [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm

