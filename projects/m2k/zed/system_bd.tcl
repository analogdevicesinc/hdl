source ../../common/zed/zed_system_bd.tcl

set_property name sys_100m_rstgen [get_bd_cells sys_200m_rstgen]

ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ 100.0

set video_dma_clocks [list \
  axi_hp0_interconnect/aclk \
  sys_ps7/S_AXI_HP0_ACLK \
  axi_hdmi_dma/m_src_axi_aclk \
  axi_hdmi_dma/m_axis_aclk \
  axi_hdmi_core/vdma_clk
]

set video_dma_resets [list \
  axi_hp0_interconnect/aresetn \
]

source ../common/m2k_bd.tcl

ad_ip_parameter axi_hdmi_clkgen CONFIG.VCO_DIV 4
ad_ip_parameter axi_hdmi_clkgen CONFIG.VCO_MUL 37.125
ad_ip_parameter axi_hdmi_clkgen CONFIG.CLK0_DIV 6.250

ad_ip_instance proc_sys_reset video_dma_reset
ad_connect sys_ps7/FCLK_CLK1 video_dma_reset/slowest_sync_clk
ad_connect sys_rstgen/peripheral_aresetn video_dma_reset/ext_reset_in

foreach clk $video_dma_clocks {
  ad_disconnect /sys_cpu_clk $clk
  ad_connect $clk sys_ps7/FCLK_CLK1
}

foreach rst $video_dma_resets {
  ad_disconnect /sys_cpu_resetn $rst
  ad_connect $rst video_dma_reset/peripheral_aresetn
}

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring
