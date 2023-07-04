source $ad_hdl_dir/projects/common/kv260/kv260_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

create_bd_port -dir I ap_rstn_frmbuf
create_bd_port -dir I ap_rstn_v_proc
create_bd_port -dir I csirxss_rstn

create_bd_port -dir I mipi_csi1_clk_p
create_bd_port -dir I mipi_csi1_clk_n
create_bd_port -dir I -from 3 -to 0 mipi_csi1_data_p
create_bd_port -dir I -from 3 -to 0 mipi_csi1_data_n

create_bd_port -dir I mipi_csi2_clk_p
create_bd_port -dir I mipi_csi2_clk_n
create_bd_port -dir I -from 3 -to 0 mipi_csi2_data_p
create_bd_port -dir I -from 3 -to 0 mipi_csi2_data_n

set mipi_csi2_rx_subsyst_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.2 mipi_csi2_rx_subsyst_1 ]
  set_property -dict [ list \
   CONFIG.CLK_LANE_IO_LOC {W8} \
   CONFIG.CLK_LANE_IO_LOC_NAME {IO_L1P_T0L_N0_DBC_65} \
   CONFIG.CMN_NUM_LANES {4} \
   CONFIG.CMN_PXL_FORMAT {YUV422_8bit} \
   CONFIG.C_DPHY_LANES {4} \
   CONFIG.C_HS_SETTLE_NS {153} \
   CONFIG.DATA_LANE0_IO_LOC {U9} \
   CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L2P_T0L_N2_65} \
   CONFIG.DATA_LANE1_IO_LOC {U8} \
   CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L3P_T0L_N4_AD15P_65} \
   CONFIG.DATA_LANE2_IO_LOC {R8} \
   CONFIG.DATA_LANE2_IO_LOC_NAME {IO_L4P_T0U_N6_DBC_AD7P_SMBALERT_65} \
   CONFIG.DATA_LANE3_IO_LOC {R7} \
   CONFIG.DATA_LANE3_IO_LOC_NAME {IO_L5P_T0U_N8_AD14P_65} \
   CONFIG.DPY_LINE_RATE {576} \
   CONFIG.C_EN_CSI_V2_0 {false} \
   CONFIG.CMN_INC_VFB {true} \
   CONFIG.DPY_EN_REG_IF {true} \
   CONFIG.CSI_EMB_NON_IMG {false} \
   CONFIG.VFB_TU_WIDTH {2} \
   CONFIG.HP_IO_BANK_SELECTION {65} \
   CONFIG.SupportLevel {1} \
 ] $mipi_csi2_rx_subsyst_1

set mipi_csi2_rx_subsyst_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.2 mipi_csi2_rx_subsyst_2 ]
  set_property -dict [ list \
   CONFIG.CLK_LANE_IO_LOC {L1} \
   CONFIG.CLK_LANE_IO_LOC_NAME {IO_L7P_T1L_N0_QBC_AD13P_65} \
   CONFIG.CMN_NUM_LANES {4} \
   CONFIG.CMN_PXL_FORMAT {YUV422_8bit} \
   CONFIG.C_DPHY_LANES {4} \
   CONFIG.C_HS_SETTLE_NS {153} \
   CONFIG.DATA_LANE0_IO_LOC {J1} \
   CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L8P_T1L_N2_AD5P_65} \
   CONFIG.DATA_LANE1_IO_LOC {K2} \
   CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L9P_T1L_N4_AD12P_65} \
   CONFIG.DATA_LANE2_IO_LOC {H4} \
   CONFIG.DATA_LANE2_IO_LOC_NAME {IO_L10P_T1U_N6_QBC_AD4P_65} \
   CONFIG.DATA_LANE3_IO_LOC {K4} \
   CONFIG.DATA_LANE3_IO_LOC_NAME {IO_L11P_T1U_N8_GC_65} \
   CONFIG.DPY_LINE_RATE {576} \
   CONFIG.C_EN_CSI_V2_0 {false} \
   CONFIG.CMN_INC_VFB {true} \
   CONFIG.DPY_EN_REG_IF {true} \
   CONFIG.CSI_EMB_NON_IMG {false} \
   CONFIG.VFB_TU_WIDTH {2} \
   CONFIG.HP_IO_BANK_SELECTION {65} \
   CONFIG.SupportLevel {1} \
 ] $mipi_csi2_rx_subsyst_2

set v_proc_ss_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_0 ]
set_property -dict [list \
  CONFIG.C_COLORSPACE_SUPPORT {0} \
  CONFIG.C_ENABLE_DMA {false} \
  CONFIG.C_ENABLE_INTERLACED {false} \
  CONFIG.C_MAX_DATA_WIDTH {8} \
  CONFIG.C_SAMPLES_PER_CLK {1} \
  CONFIG.C_TOPOLOGY {3} \
] [get_bd_cells v_proc_ss_0]

set v_proc_ss_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_1 ]
set_property -dict [list \
  CONFIG.C_COLORSPACE_SUPPORT {0} \
  CONFIG.C_ENABLE_DMA {false} \
  CONFIG.C_ENABLE_INTERLACED {false} \
  CONFIG.C_MAX_DATA_WIDTH {8} \
  CONFIG.C_SAMPLES_PER_CLK {1} \
  CONFIG.C_TOPOLOGY {3} \
] [get_bd_cells v_proc_ss_1]

set v_frmbuf_wr_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.4 v_frmbuf_wr_0 ]
set_property -dict [list \
   CONFIG.SAMPLES_PER_CLOCK {1} \
   CONFIG.HAS_UYVY8 {1} \
   CONFIG.HAS_YUYV8 {1} \
   CONFIG.HAS_Y_UV8 {1} \
] [get_bd_cells v_frmbuf_wr_0]

set v_frmbuf_wr_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.4 v_frmbuf_wr_1 ]
set_property -dict [list \
   CONFIG.SAMPLES_PER_CLOCK {1} \
   CONFIG.HAS_UYVY8 {1} \
   CONFIG.HAS_YUYV8 {1} \
   CONFIG.HAS_Y_UV8 {1} \
] [get_bd_cells v_frmbuf_wr_1]

ad_ip_instance clk_wiz dphy_clk_generator
ad_ip_parameter dphy_clk_generator CONFIG.PRIMITIVE PLL
ad_ip_parameter dphy_clk_generator CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dphy_clk_generator CONFIG.USE_LOCKED false
ad_ip_parameter dphy_clk_generator CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 200.000
ad_ip_parameter dphy_clk_generator CONFIG.CLKOUT1_REQUESTED_PHASE 0.000
ad_ip_parameter dphy_clk_generator CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE 50.000
ad_ip_parameter dphy_clk_generator CONFIG.PRIM_SOURCE Global_buffer
ad_ip_parameter dphy_clk_generator CONFIG.CLKIN1_UI_JITTER 0

ad_connect dphy_clk_generator/clk_in1 $sys_dma_clk
ad_connect dphy_clk_generator/resetn $sys_dma_resetn

ad_ip_instance axis_subset_converter axis_subset_cnv1
ad_ip_parameter axis_subset_cnv1 CONFIG.M_TDATA_NUM_BYTES {3}
ad_ip_parameter axis_subset_cnv1 CONFIG.S_TDATA_NUM_BYTES {2}
ad_ip_parameter axis_subset_cnv1 CONFIG.TDATA_REMAP {8'b00000000,tdata[15:0]}

ad_ip_instance axis_subset_converter axis_subset_cnv2
ad_ip_parameter axis_subset_cnv2 CONFIG.M_TDATA_NUM_BYTES {3}
ad_ip_parameter axis_subset_cnv2 CONFIG.S_TDATA_NUM_BYTES {2}
ad_ip_parameter axis_subset_cnv2 CONFIG.TDATA_REMAP {8'b00000000,tdata[15:0]}

ad_connect mipi_csi2_rx_subsyst_1/video_aclk $sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_1/video_aresetn $sys_cpu_resetn
ad_connect mipi_csi2_rx_subsyst_1/lite_aclk $sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_1/lite_aresetn $sys_cpu_resetn
ad_connect mipi_csi2_rx_subsyst_1/dphy_clk_200M dphy_clk_generator/clk_out1

ad_connect mipi_csi2_rx_subsyst_2/video_aclk $sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_2/video_aresetn $sys_cpu_resetn
ad_connect mipi_csi2_rx_subsyst_2/lite_aclk $sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_2/lite_aresetn $sys_cpu_resetn
ad_connect mipi_csi2_rx_subsyst_2/dphy_clk_200M dphy_clk_generator/clk_out1

ad_connect mipi_csi2_rx_subsyst_1/mipi_phy_if_clk_n mipi_csi1_clk_n
ad_connect mipi_csi2_rx_subsyst_1/mipi_phy_if_clk_p mipi_csi1_clk_p
ad_connect mipi_csi2_rx_subsyst_1/mipi_phy_if_data_n mipi_csi1_data_n
ad_connect mipi_csi2_rx_subsyst_1/mipi_phy_if_data_p mipi_csi1_data_p

ad_connect mipi_csi2_rx_subsyst_2/mipi_phy_if_clk_n mipi_csi2_clk_n
ad_connect mipi_csi2_rx_subsyst_2/mipi_phy_if_clk_p mipi_csi2_clk_p
ad_connect mipi_csi2_rx_subsyst_2/mipi_phy_if_data_n mipi_csi2_data_n
ad_connect mipi_csi2_rx_subsyst_2/mipi_phy_if_data_p mipi_csi2_data_p

ad_connect mipi_csi2_rx_subsyst_1/video_out axis_subset_cnv1/S_AXIS
ad_connect axis_subset_cnv1/aclk $sys_cpu_clk
ad_connect axis_subset_cnv1/aresetn ap_rstn_v_proc
ad_connect axis_subset_cnv1/M_AXIS v_proc_ss_0/s_axis
ad_connect v_proc_ss_0/aclk $sys_cpu_clk
ad_connect v_proc_ss_0/aresetn ap_rstn_v_proc
ad_connect v_proc_ss_0/m_axis v_frmbuf_wr_0/s_axis_video
ad_connect v_frmbuf_wr_0/ap_clk $sys_cpu_clk
ad_connect v_frmbuf_wr_0/ap_rst_n ap_rstn_frmbuf

ad_connect mipi_csi2_rx_subsyst_2/video_out axis_subset_cnv2/S_AXIS
ad_connect axis_subset_cnv2/aclk $sys_cpu_clk
ad_connect axis_subset_cnv2/aresetn ap_rstn_v_proc
ad_connect axis_subset_cnv2/M_AXIS v_proc_ss_1/s_axis
ad_connect v_proc_ss_1/aclk $sys_cpu_clk
ad_connect v_proc_ss_1/aresetn ap_rstn_v_proc
ad_connect v_proc_ss_1/m_axis v_frmbuf_wr_1/s_axis_video
ad_connect v_frmbuf_wr_1/ap_clk $sys_cpu_clk
ad_connect v_frmbuf_wr_1/ap_rst_n ap_rstn_frmbuf

ad_cpu_interconnect 0x44A00000  mipi_csi2_rx_subsyst_1
ad_cpu_interconnect 0x44A04000  mipi_csi2_rx_subsyst_2

ad_cpu_interconnect 0x44A10000  v_proc_ss_0
ad_cpu_interconnect 0x44A20000  v_proc_ss_1

ad_cpu_interconnect 0x44A30000  v_frmbuf_wr_0
ad_cpu_interconnect 0x44A40000  v_frmbuf_wr_1

ad_cpu_interrupt ps-15 mb-15 mipi_csi2_rx_subsyst_1/csirxss_csi_irq
ad_cpu_interrupt ps-14 mb-14 mipi_csi2_rx_subsyst_2/csirxss_csi_irq
ad_cpu_interrupt ps-13 mb-13 v_frmbuf_wr_0/interrupt
ad_cpu_interrupt ps-12 mb-12 v_frmbuf_wr_1/interrupt

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk v_frmbuf_wr_0/m_axi_mm_video
ad_mem_hp1_interconnect $sys_cpu_clk v_frmbuf_wr_1/m_axi_mm_video

source ./ptp_eth10g.tcl
