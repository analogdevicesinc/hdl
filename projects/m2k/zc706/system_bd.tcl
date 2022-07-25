source ../../common/zc706/zc706_system_bd.tcl
source ../../scripts/adi_pd.tcl

set_property name sys_100m_rstgen [get_bd_cells sys_200m_rstgen]
set_property -dict [list CONFIG.ASYNC_CLK_REQ_SRC.VALUE_SRC USER CONFIG.ASYNC_CLK_SRC_DEST.VALUE_SRC USER CONFIG.ASYNC_CLK_DEST_REQ.VALUE_SRC USER] [get_bd_cells axi_hdmi_dma]
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

create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0

set_property -dict [list \
  CONFIG.C_PROBE1_WIDTH {16} \
  CONFIG.C_PROBE0_WIDTH {2} \
  CONFIG.C_NUM_OF_PROBES {4} \
  CONFIG.C_TRIGOUT_EN {false} \
  CONFIG.C_EN_STRG_QUAL {0} \
  CONFIG.C_ADV_TRIGGER {false} \
  CONFIG.C_PROBE3_MU_CNT {2} \
  CONFIG.C_PROBE2_MU_CNT {2} \
  CONFIG.C_PROBE1_MU_CNT {2} \
  CONFIG.C_PROBE0_MU_CNT {2} \
  CONFIG.C_TRIGIN_EN {false} \
  CONFIG.ALL_PROBE_SAME_MU_CNT {2} \
  CONFIG.C_ENABLE_ILA_AXI_MON {false} \
  CONFIG.C_MONITOR_TYPE {Native}
] [get_bd_cells ila_0]

ad_connect ila_0/clk axi_ad9963/adc_clk
ad_connect ila_0/probe0 adc_trigger/trigger_o
ad_connect ila_0/probe1 adc_trigger/data_a_trig
ad_connect ila_0/probe2 adc_trigger/data_valid_a_trig
ad_connect ila_0/probe3 adc_trigger/trigger_out

# create board design
# default ports
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_m2k_fmc

ad_ip_instance axi_iic axi_iic_m2k_fmc

# interface connections
ad_connect  iic_m2k_fmc axi_iic_m2k_fmc/iic

# interrupts
ad_cpu_interrupt ps-7 mb-17 axi_iic_m2k_fmc/iic2intc_irpt

# interconnects
ad_cpu_interconnect 0x7c5e0000 axi_iic_m2k_fmc

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring
