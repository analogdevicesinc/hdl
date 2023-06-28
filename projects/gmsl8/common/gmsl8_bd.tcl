# gmsl8 common bd file

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

create_bd_port -dir I mipi_csi_ch0_clk_p
create_bd_port -dir I mipi_csi_ch0_clk_n
create_bd_port -dir I mipi_csi_ch1_clk_p
create_bd_port -dir I mipi_csi_ch1_clk_n
create_bd_port -dir I -from 3 -to 0 mipi_csi_ch0_data_p
create_bd_port -dir I -from 3 -to 0 mipi_csi_ch0_data_n

create_bd_port -dir I bg3_pin6_nc

create_bd_port -dir I ap_rstn_frmbuf
create_bd_port -dir I csirxss_rstn

# mipi rx subsystem instances

ad_ip_instance mipi_csi2_rx_subsystem mipi_csi_ch0
ad_ip_parameter mipi_csi_ch0 CONFIG.C_CSI_EN_CRC {false}
ad_ip_parameter mipi_csi_ch0 CONFIG.CMN_PXL_FORMAT {YUV422_8bit}
ad_ip_parameter mipi_csi_ch0 CONFIG.CMN_INC_VFB {true}
ad_ip_parameter mipi_csi_ch0 CONFIG.CMN_NUM_LANES {4}
ad_ip_parameter mipi_csi_ch0 CONFIG.VFB_TU_WIDTH {1}
ad_ip_parameter mipi_csi_ch0 CONFIG.CMN_NUM_PIXELS {1}
ad_ip_parameter mipi_csi_ch0 CONFIG.C_HS_LINE_RATE {1500}
ad_ip_parameter mipi_csi_ch0 CONFIG.C_HS_SETTLE_NS {149}
ad_ip_parameter mipi_csi_ch0 CONFIG.DPY_LINE_RATE {1500}
ad_ip_parameter mipi_csi_ch0 CONFIG.C_EN_CSI_V2_0 {false}
ad_ip_parameter mipi_csi_ch0 CONFIG.DPY_EN_REG_IF {true}
ad_ip_parameter mipi_csi_ch0 CONFIG.CSI_EMB_NON_IMG {false}

set_property -dict [list \
  CONFIG.CLK_LANE_IO_LOC {AJ6} \
  CONFIG.DATA_LANE0_IO_LOC {AH2} \
  CONFIG.DATA_LANE1_IO_LOC {AG3} \
  CONFIG.DATA_LANE2_IO_LOC {AH4} \
  CONFIG.DATA_LANE3_IO_LOC {AE2} \
  CONFIG.HP_IO_BANK_SELECTION {65} \
] [get_bd_cells mipi_csi_ch0]

ad_ip_parameter mipi_csi_ch0 CONFIG.SupportLevel {1}
ad_ip_parameter mipi_csi_ch0 CONFIG.C_CSI_FILTER_USERDATATYPE {false}

# dphy_clk_200M generator

ad_ip_instance clk_wiz dphy_clk_generator
ad_ip_parameter dphy_clk_generator CONFIG.PRIMITIVE PLL
ad_ip_parameter dphy_clk_generator CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dphy_clk_generator CONFIG.USE_LOCKED false
ad_ip_parameter dphy_clk_generator CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 200.000
ad_ip_parameter dphy_clk_generator CONFIG.CLKOUT1_REQUESTED_PHASE 0.000
ad_ip_parameter dphy_clk_generator CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE 50.000
ad_ip_parameter dphy_clk_generator CONFIG.PRIM_SOURCE Global_buffer
ad_ip_parameter dphy_clk_generator CONFIG.CLKIN1_UI_JITTER 0
ad_ip_parameter dphy_clk_generator CONFIG.PRIM_IN_FREQ 250.000

set v_frmbuf_wr_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.4 v_frmbuf_wr_0 ]
set_property -dict [list \
  CONFIG.HAS_UYVY8 {1} \
  CONFIG.HAS_YUYV8 {1} \
  CONFIG.HAS_Y_UV8 {1} \
  CONFIG.SAMPLES_PER_CLOCK {1} \
] [get_bd_cells v_frmbuf_wr_0]

ad_ip_instance axis_subset_converter axis_subset_cnv
ad_ip_parameter axis_subset_cnv CONFIG.M_TDATA_NUM_BYTES {3}
ad_ip_parameter axis_subset_cnv CONFIG.S_TDATA_NUM_BYTES {2}
ad_ip_parameter axis_subset_cnv CONFIG.TDATA_REMAP {8'b00000000,tdata[15:0]}
ad_ip_parameter axis_subset_cnv CONFIG.TKEEP_REMAP {1'b0}
ad_ip_parameter axis_subset_cnv CONFIG.TSTRB_REMAP {1'b0}

# MIPI receiver's connections

ad_connect mipi_csi_ch0/mipi_phy_if_clk_n mipi_csi_ch0_clk_n
ad_connect mipi_csi_ch0/mipi_phy_if_clk_p mipi_csi_ch0_clk_p
ad_connect mipi_csi_ch0/mipi_phy_if_data_n mipi_csi_ch0_data_n
ad_connect mipi_csi_ch0/mipi_phy_if_data_p mipi_csi_ch0_data_p

ad_connect mipi_csi_ch0/video_out axis_subset_cnv/S_AXIS
ad_connect axis_subset_cnv/aclk $sys_cpu_clk
ad_connect axis_subset_cnv/aresetn ap_rstn_frmbuf
ad_connect axis_subset_cnv/M_AXIS v_frmbuf_wr_0/s_axis_video
ad_connect v_frmbuf_wr_0/ap_clk $sys_cpu_clk
ad_connect v_frmbuf_wr_0/ap_rst_n ap_rstn_frmbuf

ad_connect dphy_clk_generator/clk_in1 $sys_dma_clk
ad_connect dphy_clk_generator/resetn $sys_dma_resetn

ad_connect mipi_csi_ch0/video_aclk $sys_cpu_clk
ad_connect mipi_csi_ch0/video_aresetn csirxss_rstn
ad_connect mipi_csi_ch0/lite_aclk $sys_cpu_clk
ad_connect mipi_csi_ch0/lite_aresetn $sys_cpu_resetn 
ad_connect mipi_csi_ch0/dphy_clk_200M dphy_clk_generator/clk_out1
ad_connect mipi_csi_ch0/bg3_pin6_nc bg3_pin6_nc

# Interconnects

ad_cpu_interconnect 0x44A00000  mipi_csi_ch0
ad_cpu_interconnect 0x44A20000  v_frmbuf_wr_0

ad_mem_hp1_interconnect $sys_cpu_clk  sys_ps8/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk  v_frmbuf_wr_0/m_axi_mm_video

# Interrrupts

ad_cpu_interrupt ps-13 mb-12 mipi_csi_ch0/csirxss_csi_irq
ad_cpu_interrupt ps-11 mb-6 v_frmbuf_wr_0/interrupt

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file
