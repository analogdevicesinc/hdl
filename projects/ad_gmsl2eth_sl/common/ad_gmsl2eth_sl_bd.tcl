###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# GMSL
create_bd_port -dir I ap_rstn_frmbuf_0
create_bd_port -dir I ap_rstn_frmbuf_1
create_bd_port -dir I ap_rstn_frmbuf_2
create_bd_port -dir I ap_rstn_frmbuf_3
create_bd_port -dir I ap_rstn_frmbuf_4
create_bd_port -dir I ap_rstn_frmbuf_5
create_bd_port -dir I ap_rstn_frmbuf_6
create_bd_port -dir I ap_rstn_frmbuf_7

create_bd_port -dir I csirxss_rstn

create_bd_port -dir O mfp_0_p1
create_bd_port -dir O mfp_1_p1
create_bd_port -dir O mfp_2_p1
create_bd_port -dir O mfp_3_p1
create_bd_port -dir O mfp_0_p2
create_bd_port -dir O mfp_1_p2
create_bd_port -dir O mfp_2_p2
create_bd_port -dir O mfp_3_p2

set mipi_phy_if_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0 ]
set mipi_phy_if_1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_1 ]

# Corundum NIC
create_bd_port -dir I sfp_rx_p
create_bd_port -dir I sfp_rx_n
create_bd_port -dir O sfp_tx_p
create_bd_port -dir O sfp_tx_n
create_bd_port -dir I sfp_mgt_refclk_p
create_bd_port -dir I sfp_mgt_refclk_n

create_bd_port -dir O sfp_tx_disable
create_bd_port -dir I sfp_tx_fault
create_bd_port -dir I sfp_rx_los
create_bd_port -dir I sfp_mod_abs

create_bd_port -dir O ref_clk0

create_bd_port -dir O -from 1 -to 0 led
create_bd_port -dir O -from 1 -to 0 sfp_led

# GSML

set_property CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {0} [get_bd_cells sys_ps8]

set_property -dict [list \
  CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 36 .. 37} \
] [get_bd_cells sys_ps8]

ad_ip_parameter sys_ps8 CONFIG.PSU__SD0__PERIPHERAL__ENABLE {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 38 .. 44}
ad_ip_parameter sys_ps8 CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1}

set_property -dict [list \
  CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ 300 \
  CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 250 \
  CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ 250 \
  CONFIG.PSU__USE__M_AXI_GP0 {1} \
  CONFIG.PSU__USE__S_AXI_GP0 {1} \
  CONFIG.PSU__USE__S_AXI_GP2 {1} \
  CONFIG.PSU__USE__S_AXI_GP3 {1} \
] [get_bd_cell sys_ps8]

# mipi rx subsystem instances
ad_ip_instance mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_0
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.HP_IO_BANK_SELECTION {65}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CLK_LANE_IO_LOC {W8}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CLK_LANE_IO_LOC_NAME {IO_L1P_T0L_N0_DBC_65}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CMN_NUM_LANES {4}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CMN_PXL_FORMAT {YUV422_8bit}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.C_CSI_EN_ACTIVELANES {false}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.C_DPHY_LANES {4}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.C_EN_CSI_V2_0 {false}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.C_HS_LINE_RATE {1500}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.C_HS_SETTLE_NS {170}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DATA_LANE0_IO_LOC {U9}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L2P_T0L_N2_65}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DATA_LANE1_IO_LOC {U8}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L3P_T0L_N4_AD15P_65}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DATA_LANE2_IO_LOC {R8}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DATA_LANE2_IO_LOC_NAME {IO_L4P_T0U_N6_DBC_AD7P_SMBALERT_65}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DATA_LANE3_IO_LOC {R7}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DATA_LANE3_IO_LOC_NAME {IO_L5P_T0U_N8_AD14P_65}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DPY_LINE_RATE {1500}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CMN_NUM_PIXELS {2}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CMN_INC_VFB {true}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DPY_EN_REG_IF {true}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CSI_EMB_NON_IMG {false}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.VFB_TU_WIDTH {2}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.SupportLevel {1}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CSI_BUF_DEPTH {2048}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.C_CSI_EN_CRC {false}

ad_ip_instance mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_1
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.HP_IO_BANK_SELECTION {65}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.CLK_LANE_IO_LOC {L1}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.CLK_LANE_IO_LOC_NAME {IO_L7P_T1L_N0_QBC_AD13P_65}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.CMN_NUM_LANES {4}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.CMN_PXL_FORMAT {YUV422_8bit}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.C_CSI_EN_ACTIVELANES {false}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.C_DPHY_LANES {4}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.C_EN_CSI_V2_0 {false}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.C_HS_LINE_RATE {1500}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.C_HS_SETTLE_NS {170}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DATA_LANE0_IO_LOC {J1}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L8P_T1L_N2_AD5P_65}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DATA_LANE1_IO_LOC {K2}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L9P_T1L_N4_AD12P_65}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DATA_LANE2_IO_LOC {H4}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DATA_LANE2_IO_LOC_NAME {IO_L10P_T1U_N6_QBC_AD4P_65}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DATA_LANE3_IO_LOC {K4}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DATA_LANE3_IO_LOC_NAME {IO_L11P_T1U_N8_GC_65}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DPY_LINE_RATE {1500}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.CMN_NUM_PIXELS {2}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.CMN_INC_VFB {true}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.DPY_EN_REG_IF {true}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.CSI_EMB_NON_IMG {false}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.VFB_TU_WIDTH {2}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.SupportLevel {1}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.CSI_BUF_DEPTH {2048}
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.C_CSI_EN_CRC {false}

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

set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]
set_property -dict [list \
  CONFIG.HAS_TLAST {1} \
  CONFIG.NUM_MI {4} \
  CONFIG.NUM_SI {1} \
  CONFIG.TDATA_NUM_BYTES {4} \
  CONFIG.TDEST_WIDTH {4} \
  CONFIG.TUSER_WIDTH {2} \
] $axis_switch_0

set axis_switch_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_1 ]
set_property -dict [list \
  CONFIG.HAS_TLAST {1} \
  CONFIG.NUM_MI {4} \
  CONFIG.NUM_SI {1} \
  CONFIG.TDATA_NUM_BYTES {4} \
  CONFIG.TDEST_WIDTH {4} \
  CONFIG.TUSER_WIDTH {2} \
] $axis_switch_1

ad_ip_instance v_frmbuf_wr v_frmbuf_0
ad_ip_parameter v_frmbuf_0 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_0 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_0 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_0 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_0 CONFIG.MAX_COLS {1920}
ad_ip_parameter v_frmbuf_0 CONFIG.MAX_ROWS {1080}
ad_ip_parameter v_frmbuf_0 CONFIG.SAMPLES_PER_CLOCK {2}

ad_ip_instance v_frmbuf_wr v_frmbuf_1
ad_ip_parameter v_frmbuf_1 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_1 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_1 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_1 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_1 CONFIG.MAX_COLS {1920}
ad_ip_parameter v_frmbuf_1 CONFIG.MAX_ROWS {1080}
ad_ip_parameter v_frmbuf_1 CONFIG.SAMPLES_PER_CLOCK {2}

ad_ip_instance v_frmbuf_wr v_frmbuf_2
ad_ip_parameter v_frmbuf_2 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_2 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_2 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_2 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_2 CONFIG.MAX_COLS {1920}
ad_ip_parameter v_frmbuf_2 CONFIG.MAX_ROWS {1080}
ad_ip_parameter v_frmbuf_2 CONFIG.SAMPLES_PER_CLOCK {2}

ad_ip_instance v_frmbuf_wr v_frmbuf_3
ad_ip_parameter v_frmbuf_3 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_3 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_3 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_3 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_3 CONFIG.MAX_COLS {1920}
ad_ip_parameter v_frmbuf_3 CONFIG.MAX_ROWS {1080}
ad_ip_parameter v_frmbuf_3 CONFIG.SAMPLES_PER_CLOCK {2}

ad_ip_instance v_frmbuf_wr v_frmbuf_4
ad_ip_parameter v_frmbuf_4 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_4 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_4 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_4 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_4 CONFIG.MAX_COLS {1920}
ad_ip_parameter v_frmbuf_4 CONFIG.MAX_ROWS {1080}
ad_ip_parameter v_frmbuf_4 CONFIG.SAMPLES_PER_CLOCK {2}

ad_ip_instance v_frmbuf_wr v_frmbuf_5
ad_ip_parameter v_frmbuf_5 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_5 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_5 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_5 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_5 CONFIG.MAX_COLS {1920}
ad_ip_parameter v_frmbuf_5 CONFIG.MAX_ROWS {1080}
ad_ip_parameter v_frmbuf_5 CONFIG.SAMPLES_PER_CLOCK {2}

ad_ip_instance v_frmbuf_wr v_frmbuf_6
ad_ip_parameter v_frmbuf_6 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_6 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_6 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_6 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_6 CONFIG.MAX_COLS {1920}
ad_ip_parameter v_frmbuf_6 CONFIG.MAX_ROWS {1080}
ad_ip_parameter v_frmbuf_6 CONFIG.SAMPLES_PER_CLOCK {2}

ad_ip_instance v_frmbuf_wr v_frmbuf_7
ad_ip_parameter v_frmbuf_7 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_7 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_7 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_7 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_7 CONFIG.MAX_COLS {1920}
ad_ip_parameter v_frmbuf_7 CONFIG.MAX_ROWS {1080}
ad_ip_parameter v_frmbuf_7 CONFIG.SAMPLES_PER_CLOCK {2}

ad_ip_instance axi_pwm_gen axi_pwm_gen_0
ad_ip_parameter axi_pwm_gen_0 CONFIG.N_PWMS {8}

ad_ip_instance axis_subset_converter axis_subset_cnv_0
ad_ip_parameter axis_subset_cnv_0 CONFIG.M_TDATA_NUM_BYTES {6}
ad_ip_parameter axis_subset_cnv_0 CONFIG.S_TDATA_NUM_BYTES {4}
ad_ip_parameter axis_subset_cnv_0 CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[31:0]}
ad_ip_parameter axis_subset_cnv_0 CONFIG.TKEEP_REMAP {1'b0}
ad_ip_parameter axis_subset_cnv_0 CONFIG.TSTRB_REMAP {1'b0}

ad_ip_instance axis_subset_converter axis_subset_cnv_1
ad_ip_parameter axis_subset_cnv_1 CONFIG.M_TDATA_NUM_BYTES {6}
ad_ip_parameter axis_subset_cnv_1 CONFIG.S_TDATA_NUM_BYTES {4}
ad_ip_parameter axis_subset_cnv_1 CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[31:0]}
ad_ip_parameter axis_subset_cnv_1 CONFIG.TKEEP_REMAP {1'b0}
ad_ip_parameter axis_subset_cnv_1 CONFIG.TSTRB_REMAP {1'b0}

ad_ip_instance axis_subset_converter axis_subset_cnv_2
ad_ip_parameter axis_subset_cnv_2 CONFIG.M_TDATA_NUM_BYTES {6}
ad_ip_parameter axis_subset_cnv_2 CONFIG.S_TDATA_NUM_BYTES {4}
ad_ip_parameter axis_subset_cnv_2 CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[31:0]}
ad_ip_parameter axis_subset_cnv_2 CONFIG.TKEEP_REMAP {1'b0}
ad_ip_parameter axis_subset_cnv_2 CONFIG.TSTRB_REMAP {1'b0}

ad_ip_instance axis_subset_converter axis_subset_cnv_3
ad_ip_parameter axis_subset_cnv_3 CONFIG.M_TDATA_NUM_BYTES {6}
ad_ip_parameter axis_subset_cnv_3 CONFIG.S_TDATA_NUM_BYTES {4}
ad_ip_parameter axis_subset_cnv_3 CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[31:0]}
ad_ip_parameter axis_subset_cnv_3 CONFIG.TKEEP_REMAP {1'b0}
ad_ip_parameter axis_subset_cnv_3 CONFIG.TSTRB_REMAP {1'b0}

ad_ip_instance axis_subset_converter axis_subset_cnv_4
ad_ip_parameter axis_subset_cnv_4 CONFIG.M_TDATA_NUM_BYTES {6}
ad_ip_parameter axis_subset_cnv_4 CONFIG.S_TDATA_NUM_BYTES {4}
ad_ip_parameter axis_subset_cnv_4 CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[31:0]}
ad_ip_parameter axis_subset_cnv_4 CONFIG.TKEEP_REMAP {1'b0}
ad_ip_parameter axis_subset_cnv_4 CONFIG.TSTRB_REMAP {1'b0}

ad_ip_instance axis_subset_converter axis_subset_cnv_5
ad_ip_parameter axis_subset_cnv_5 CONFIG.M_TDATA_NUM_BYTES {6}
ad_ip_parameter axis_subset_cnv_5 CONFIG.S_TDATA_NUM_BYTES {4}
ad_ip_parameter axis_subset_cnv_5 CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[31:0]}
ad_ip_parameter axis_subset_cnv_5 CONFIG.TKEEP_REMAP {1'b0}
ad_ip_parameter axis_subset_cnv_5 CONFIG.TSTRB_REMAP {1'b0}

ad_ip_instance axis_subset_converter axis_subset_cnv_6
ad_ip_parameter axis_subset_cnv_6 CONFIG.M_TDATA_NUM_BYTES {6}
ad_ip_parameter axis_subset_cnv_6 CONFIG.S_TDATA_NUM_BYTES {4}
ad_ip_parameter axis_subset_cnv_6 CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[31:0]}
ad_ip_parameter axis_subset_cnv_6 CONFIG.TKEEP_REMAP {1'b0}
ad_ip_parameter axis_subset_cnv_6 CONFIG.TSTRB_REMAP {1'b0}

ad_ip_instance axis_subset_converter axis_subset_cnv_7
ad_ip_parameter axis_subset_cnv_7 CONFIG.M_TDATA_NUM_BYTES {6}
ad_ip_parameter axis_subset_cnv_7 CONFIG.S_TDATA_NUM_BYTES {4}
ad_ip_parameter axis_subset_cnv_7 CONFIG.TDATA_REMAP {16'b0000000000000000,tdata[31:0]}
ad_ip_parameter axis_subset_cnv_7 CONFIG.TKEEP_REMAP {1'b0}
ad_ip_parameter axis_subset_cnv_7 CONFIG.TSTRB_REMAP {1'b0}

ad_ip_instance smartconnect axi_hp0_interconnect
ad_ip_parameter axi_hp0_interconnect CONFIG.NUM_MI {1}
ad_ip_parameter axi_hp0_interconnect CONFIG.NUM_SI {4}

ad_ip_instance smartconnect axi_hp1_interconnect
ad_ip_parameter axi_hp1_interconnect CONFIG.NUM_MI {1}
ad_ip_parameter axi_hp1_interconnect CONFIG.NUM_SI {4}

ad_connect axi_hp0_interconnect/M00_AXI  sys_ps8/S_AXI_HP0_FPD
ad_connect axi_hp0_interconnect/aclk sys_cpu_clk
ad_connect axi_hp0_interconnect/aresetn sys_cpu_resetn

ad_connect axi_hp1_interconnect/M00_AXI  sys_ps8/S_AXI_HP1_FPD
ad_connect axi_hp1_interconnect/aclk sys_cpu_clk
ad_connect axi_hp1_interconnect/aresetn sys_cpu_resetn

ad_connect sys_ps8/saxihp0_fpd_aclk sys_cpu_clk
ad_connect sys_ps8/saxihp1_fpd_aclk sys_cpu_clk

ad_connect axis_subset_cnv_0/aclk sys_cpu_clk
ad_connect axis_subset_cnv_0/aresetn ap_rstn_frmbuf_0
ad_connect axis_subset_cnv_1/aclk sys_cpu_clk
ad_connect axis_subset_cnv_1/aresetn ap_rstn_frmbuf_1
ad_connect axis_subset_cnv_2/aclk sys_cpu_clk
ad_connect axis_subset_cnv_2/aresetn ap_rstn_frmbuf_2
ad_connect axis_subset_cnv_3/aclk sys_cpu_clk
ad_connect axis_subset_cnv_3/aresetn ap_rstn_frmbuf_3
ad_connect axis_subset_cnv_4/aclk sys_cpu_clk
ad_connect axis_subset_cnv_4/aresetn ap_rstn_frmbuf_4
ad_connect axis_subset_cnv_5/aclk sys_cpu_clk
ad_connect axis_subset_cnv_5/aresetn ap_rstn_frmbuf_5
ad_connect axis_subset_cnv_6/aclk sys_cpu_clk
ad_connect axis_subset_cnv_6/aresetn ap_rstn_frmbuf_6
ad_connect axis_subset_cnv_7/aclk sys_cpu_clk
ad_connect axis_subset_cnv_7/aresetn ap_rstn_frmbuf_7

ad_connect v_frmbuf_0/ap_rst_n ap_rstn_frmbuf_0
ad_connect v_frmbuf_1/ap_rst_n ap_rstn_frmbuf_1
ad_connect v_frmbuf_2/ap_rst_n ap_rstn_frmbuf_2
ad_connect v_frmbuf_3/ap_rst_n ap_rstn_frmbuf_3
ad_connect v_frmbuf_4/ap_rst_n ap_rstn_frmbuf_4
ad_connect v_frmbuf_5/ap_rst_n ap_rstn_frmbuf_5
ad_connect v_frmbuf_6/ap_rst_n ap_rstn_frmbuf_6
ad_connect v_frmbuf_7/ap_rst_n ap_rstn_frmbuf_7

ad_connect v_frmbuf_0/m_axi_mm_video axi_hp0_interconnect/S00_AXI
ad_connect v_frmbuf_1/m_axi_mm_video axi_hp0_interconnect/S01_AXI
ad_connect v_frmbuf_2/m_axi_mm_video axi_hp0_interconnect/S02_AXI
ad_connect v_frmbuf_3/m_axi_mm_video axi_hp0_interconnect/S03_AXI

ad_connect v_frmbuf_4/m_axi_mm_video axi_hp1_interconnect/S00_AXI
ad_connect v_frmbuf_5/m_axi_mm_video axi_hp1_interconnect/S01_AXI
ad_connect v_frmbuf_6/m_axi_mm_video axi_hp1_interconnect/S02_AXI
ad_connect v_frmbuf_7/m_axi_mm_video axi_hp1_interconnect/S03_AXI

ad_connect axis_subset_cnv_0/M_AXIS v_frmbuf_0/s_axis_video
ad_connect axis_subset_cnv_1/M_AXIS v_frmbuf_1/s_axis_video
ad_connect axis_subset_cnv_2/M_AXIS v_frmbuf_2/s_axis_video
ad_connect axis_subset_cnv_3/M_AXIS v_frmbuf_3/s_axis_video
ad_connect axis_subset_cnv_4/M_AXIS v_frmbuf_4/s_axis_video
ad_connect axis_subset_cnv_5/M_AXIS v_frmbuf_5/s_axis_video
ad_connect axis_subset_cnv_6/M_AXIS v_frmbuf_6/s_axis_video
ad_connect axis_subset_cnv_7/M_AXIS v_frmbuf_7/s_axis_video

connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_ports mipi_phy_if_0] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
connect_bd_intf_net -intf_net mipi_phy_if_1_1 [get_bd_intf_ports mipi_phy_if_1] [get_bd_intf_pins mipi_csi2_rx_subsyst_1/mipi_phy_if]

ad_connect dphy_clk_generator/clk_in1 $sys_dma_clk
ad_connect dphy_clk_generator/resetn $sys_dma_resetn

ad_connect mipi_csi2_rx_subsyst_0/video_aclk sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_0/video_aresetn csirxss_rstn
ad_connect mipi_csi2_rx_subsyst_0/lite_aclk sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_0/dphy_clk_200M dphy_clk_generator/clk_out1

ad_connect mipi_csi2_rx_subsyst_1/video_aclk sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_1/video_aresetn csirxss_rstn
ad_connect mipi_csi2_rx_subsyst_1/lite_aclk sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_1/dphy_clk_200M dphy_clk_generator/clk_out1

ad_connect mipi_csi2_rx_subsyst_0/video_out axis_switch_0/S00_AXIS
ad_connect axis_switch_0/M00_AXIS axis_subset_cnv_0/S_AXIS
ad_connect axis_switch_0/M01_AXIS axis_subset_cnv_1/S_AXIS
ad_connect axis_switch_0/M02_AXIS axis_subset_cnv_2/S_AXIS
ad_connect axis_switch_0/M03_AXIS axis_subset_cnv_3/S_AXIS

ad_connect mipi_csi2_rx_subsyst_1/video_out axis_switch_1/S00_AXIS
ad_connect axis_switch_1/M00_AXIS axis_subset_cnv_4/S_AXIS
ad_connect axis_switch_1/M01_AXIS axis_subset_cnv_5/S_AXIS
ad_connect axis_switch_1/M02_AXIS axis_subset_cnv_6/S_AXIS
ad_connect axis_switch_1/M03_AXIS axis_subset_cnv_7/S_AXIS

ad_connect axis_switch_0/aclk sys_cpu_clk
ad_connect axis_switch_0/aresetn csirxss_rstn
ad_connect axis_switch_1/aclk sys_cpu_clk
ad_connect axis_switch_1/aresetn csirxss_rstn

ad_connect axi_pwm_gen_0/pwm_0 mfp_0_p1
ad_connect axi_pwm_gen_0/pwm_1 mfp_1_p1
ad_connect axi_pwm_gen_0/pwm_2 mfp_2_p1
ad_connect axi_pwm_gen_0/pwm_3 mfp_3_p1
ad_connect axi_pwm_gen_0/pwm_4 mfp_0_p2
ad_connect axi_pwm_gen_0/pwm_5 mfp_1_p2
ad_connect axi_pwm_gen_0/pwm_6 mfp_2_p2
ad_connect axi_pwm_gen_0/pwm_7 mfp_3_p2
ad_connect axi_pwm_gen_0/ext_clk sys_cpu_clk

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 tca_iic

ad_ip_instance axi_iic axi_iic_mipi

ad_connect tca_iic axi_iic_mipi/iic

ad_ip_parameter axi_iic_mipi CONFIG.IIC_FREQ_KHZ {95}

# Interconnects
ad_cpu_interconnect 0x44A00000 mipi_csi2_rx_subsyst_0
ad_cpu_interconnect 0x44A20000 mipi_csi2_rx_subsyst_1
ad_cpu_interconnect 0x44A40000 axi_iic_mipi
ad_cpu_interconnect 0x44A60000 v_frmbuf_0
ad_cpu_interconnect 0x44A80000 v_frmbuf_1
ad_cpu_interconnect 0x44Aa0000 v_frmbuf_2
ad_cpu_interconnect 0x44Ac0000 v_frmbuf_3
ad_cpu_interconnect 0x44Ae0000 v_frmbuf_4
ad_cpu_interconnect 0x44B00000 v_frmbuf_5
ad_cpu_interconnect 0x44B20000 v_frmbuf_6
ad_cpu_interconnect 0x44B40000 v_frmbuf_7
ad_cpu_interconnect 0x44B60000 axi_pwm_gen_0

assign_bd_address [get_bd_addr_segs { \
  sys_ps8/SAXIGP3/HP1_DDR_LOW \
  sys_ps8/SAXIGP3/HP1_DDR_LOW \
  sys_ps8/SAXIGP3/HP1_DDR_LOW \
  sys_ps8/SAXIGP3/HP1_DDR_LOW \
  sys_ps8/SAXIGP3/HP1_DDR_LOW \
  sys_ps8/SAXIGP3/HP0_DDR_LOW \
  sys_ps8/SAXIGP2/HP0_DDR_LOW \
  sys_ps8/SAXIGP2/HP0_DDR_LOW \
  sys_ps8/SAXIGP3/HP0_DDR_LOW \
}]

# Interrrupts
ad_cpu_interrupt ps-15 mb-15 mipi_csi2_rx_subsyst_0/csirxss_csi_irq
ad_cpu_interrupt ps-14 mb-14 mipi_csi2_rx_subsyst_1/csirxss_csi_irq
ad_cpu_interrupt ps-13 mb-13 axi_iic_mipi/iic2intc_irpt
ad_cpu_interrupt ps-12 mb-12 v_frmbuf_0/interrupt
ad_cpu_interrupt ps-11 mb-11 v_frmbuf_1/interrupt
ad_cpu_interrupt ps-10 mb-10 v_frmbuf_2/interrupt
ad_cpu_interrupt ps-9  mb-9  v_frmbuf_3/interrupt
ad_cpu_interrupt ps-8  mb-8  v_frmbuf_4/interrupt
ad_cpu_interrupt ps-7  mb-7 v_frmbuf_5/interrupt
ad_cpu_interrupt ps-6  mb-6 v_frmbuf_6/interrupt
ad_cpu_interrupt ps-5  mb-5 v_frmbuf_7/interrupt

# Corundum NIC

ad_ip_instance corundum corundum

# collect build information
set build_date [clock seconds]
set git_hash 00000000
catch {
  set git_hash [exec git rev-parse --short=8 HEAD]
}
set tag_ver 0.0.0

# FW and board IDs
set fpga_id [expr 0x4A49093]
set fw_id [expr 0x00000000]
set fw_ver $tag_ver
set board_vendor_id [expr 0x10ee]
set board_device_id [expr 0x9104]
set board_ver 1.0
set release_info [expr 0x00000000]

# General variables
set IRQ_SIZE 8
set PORTS_PER_IF "1"
set TX_QUEUE_INDEX_WIDTH "5"
set RX_QUEUE_INDEX_WIDTH "5"
set CQN_WIDTH [expr max($TX_QUEUE_INDEX_WIDTH, $RX_QUEUE_INDEX_WIDTH) + 1]
set TX_QUEUE_PIPELINE [expr 3 + max($TX_QUEUE_INDEX_WIDTH - 12, 0)]
set RX_QUEUE_PIPELINE [expr 3 + max($RX_QUEUE_INDEX_WIDTH - 12, 0)]
set TX_DESC_TABLE_SIZE "32"
set RX_DESC_TABLE_SIZE "32"
set TX_RAM_SIZE "32768"
set RX_RAM_SIZE "32768"

# FW ID block
ad_ip_parameter corundum CONFIG.FPGA_ID [format "32'h%08x" $fpga_id]
ad_ip_parameter corundum CONFIG.FW_ID [format "32'h%08x" $fw_id]
ad_ip_parameter corundum CONFIG.FW_VER [format "32'h%02x%02x%02x%02x" {*}[split $fw_ver .-] 0 0 0 0]
ad_ip_parameter corundum CONFIG.BOARD_ID [format "32'h%04x%04x" $board_vendor_id $board_device_id]
ad_ip_parameter corundum CONFIG.BOARD_VER [format "32'h%02x%02x%02x%02x" {*}[split $board_ver .-] 0 0 0 0]
ad_ip_parameter corundum CONFIG.BUILD_DATE  "32'd${build_date}"
ad_ip_parameter corundum CONFIG.GIT_HASH  "32'h${git_hash}"
ad_ip_parameter corundum CONFIG.RELEASE_INFO  [format "32'h%08x" $release_info]

# Board configuration
ad_ip_parameter corundum CONFIG.TDMA_BER_ENABLE "0"

# Structural configuration
ad_ip_parameter corundum CONFIG.IF_COUNT "1"
ad_ip_parameter corundum CONFIG.PORTS_PER_IF $PORTS_PER_IF
ad_ip_parameter corundum CONFIG.SCHED_PER_IF $PORTS_PER_IF
ad_ip_parameter corundum CONFIG.PORT_MASK "0"

# Clock configuration
ad_ip_parameter corundum CONFIG.CLK_PERIOD_NS_NUM "4"
ad_ip_parameter corundum CONFIG.CLK_PERIOD_NS_DENOM "1"

# PTP configuration
ad_ip_parameter corundum CONFIG.PTP_CLOCK_PIPELINE "0"
ad_ip_parameter corundum CONFIG.PTP_CLOCK_CDC_PIPELINE "0"
ad_ip_parameter corundum CONFIG.PTP_PORT_CDC_PIPELINE "0"
ad_ip_parameter corundum CONFIG.PTP_PEROUT_ENABLE "1"
ad_ip_parameter corundum CONFIG.PTP_PEROUT_COUNT "1"

# Queue manager configuration
ad_ip_parameter corundum CONFIG.EVENT_QUEUE_OP_TABLE_SIZE "32"
ad_ip_parameter corundum CONFIG.TX_QUEUE_OP_TABLE_SIZE "32"
ad_ip_parameter corundum CONFIG.RX_QUEUE_OP_TABLE_SIZE "32"
ad_ip_parameter corundum CONFIG.CQ_OP_TABLE_SIZE "32"
ad_ip_parameter corundum CONFIG.EQN_WIDTH "2"
ad_ip_parameter corundum CONFIG.TX_QUEUE_INDEX_WIDTH $TX_QUEUE_INDEX_WIDTH
ad_ip_parameter corundum CONFIG.RX_QUEUE_INDEX_WIDTH $RX_QUEUE_INDEX_WIDTH
ad_ip_parameter corundum CONFIG.CQN_WIDTH $CQN_WIDTH
ad_ip_parameter corundum CONFIG.EQ_PIPELINE "3"
ad_ip_parameter corundum CONFIG.TX_QUEUE_PIPELINE $TX_QUEUE_PIPELINE
ad_ip_parameter corundum CONFIG.RX_QUEUE_PIPELINE $RX_QUEUE_PIPELINE
ad_ip_parameter corundum CONFIG.CQ_PIPELINE [expr 3 + max($CQN_WIDTH - 12, 0)]

# TX and RX engine configuration
ad_ip_parameter corundum CONFIG.TX_DESC_TABLE_SIZE $TX_DESC_TABLE_SIZE
ad_ip_parameter corundum CONFIG.RX_DESC_TABLE_SIZE $RX_DESC_TABLE_SIZE
ad_ip_parameter corundum CONFIG.RX_INDIR_TBL_ADDR_WIDTH [expr min($RX_QUEUE_INDEX_WIDTH, 8)]

# Scheduler configuration
ad_ip_parameter corundum CONFIG.TX_SCHEDULER_OP_TABLE_SIZE $TX_DESC_TABLE_SIZE
ad_ip_parameter corundum CONFIG.TX_SCHEDULER_PIPELINE $TX_QUEUE_PIPELINE
ad_ip_parameter corundum CONFIG.TDMA_INDEX_WIDTH "6"

# Interface configuration
ad_ip_parameter corundum CONFIG.PTP_TS_ENABLE "1"
ad_ip_parameter corundum CONFIG.TX_CPL_FIFO_DEPTH "32"
ad_ip_parameter corundum CONFIG.TX_CHECKSUM_ENABLE "1"
ad_ip_parameter corundum CONFIG.RX_HASH_ENABLE "1"
ad_ip_parameter corundum CONFIG.RX_CHECKSUM_ENABLE "1"
ad_ip_parameter corundum CONFIG.TX_FIFO_DEPTH "32768"
ad_ip_parameter corundum CONFIG.RX_FIFO_DEPTH "32768"
ad_ip_parameter corundum CONFIG.MAX_TX_SIZE "9214"
ad_ip_parameter corundum CONFIG.MAX_RX_SIZE "9214"
ad_ip_parameter corundum CONFIG.TX_RAM_SIZE $TX_RAM_SIZE
ad_ip_parameter corundum CONFIG.RX_RAM_SIZE $RX_RAM_SIZE

# Application block configuration
ad_ip_parameter corundum CONFIG.APP_ID "32'h00000000"
ad_ip_parameter corundum CONFIG.APP_ENABLE "0"
ad_ip_parameter corundum CONFIG.APP_CTRL_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_DMA_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_AXIS_DIRECT_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_AXIS_SYNC_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_AXIS_IF_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_STAT_ENABLE "1"

# AXI DMA interface configuration
ad_ip_parameter corundum CONFIG.AXI_DATA_WIDTH [get_property CONFIG.PSU__SAXIGP0__DATA_WIDTH [get_bd_cells sys_ps8]]
ad_ip_parameter corundum CONFIG.AXI_ADDR_WIDTH 64
ad_ip_parameter corundum CONFIG.AXI_ID_WIDTH 6

# DMA interface configuration
ad_ip_parameter corundum CONFIG.DMA_IMM_ENABLE "0"
ad_ip_parameter corundum CONFIG.DMA_IMM_WIDTH "32"
ad_ip_parameter corundum CONFIG.DMA_LEN_WIDTH "16"
ad_ip_parameter corundum CONFIG.DMA_TAG_WIDTH "16"
ad_ip_parameter corundum CONFIG.RAM_ADDR_WIDTH [expr int(ceil(log(max($TX_RAM_SIZE, $RX_RAM_SIZE))/log(2)))]
ad_ip_parameter corundum CONFIG.RAM_PIPELINE "2"
ad_ip_parameter corundum CONFIG.AXI_DMA_MAX_BURST_LEN 16

# AXI lite interface configuration (control)
ad_ip_parameter corundum CONFIG.AXIL_CTRL_DATA_WIDTH 32
ad_ip_parameter corundum CONFIG.AXIL_CTRL_ADDR_WIDTH 24

# AXI lite interface configuration (application control)
ad_ip_parameter corundum CONFIG.AXIL_APP_CTRL_DATA_WIDTH 32
ad_ip_parameter corundum CONFIG.AXIL_APP_CTRL_ADDR_WIDTH 24

# Interrupt configuration
ad_ip_parameter corundum CONFIG.IRQ_COUNT $IRQ_SIZE
ad_ip_parameter corundum CONFIG.IRQ_STRETCH "10"

# Ethernet interface configuration
ad_ip_parameter corundum CONFIG.AXIS_ETH_TX_PIPELINE "0"
ad_ip_parameter corundum CONFIG.AXIS_ETH_TX_FIFO_PIPELINE "2"
ad_ip_parameter corundum CONFIG.AXIS_ETH_TX_TS_PIPELINE "0"
ad_ip_parameter corundum CONFIG.AXIS_ETH_RX_PIPELINE "0"
ad_ip_parameter corundum CONFIG.AXIS_ETH_RX_FIFO_PIPELINE "2"

# Statistics counter subsystem
ad_ip_parameter corundum CONFIG.STAT_ENABLE "1"
ad_ip_parameter corundum CONFIG.STAT_DMA_ENABLE "1"
ad_ip_parameter corundum CONFIG.STAT_AXI_ENABLE "1"
ad_ip_parameter corundum CONFIG.STAT_INC_WIDTH "24"
ad_ip_parameter corundum CONFIG.STAT_ID_WIDTH "12"

ad_ip_instance clk_wiz clk10_gen
ad_ip_parameter clk10_gen CONFIG.CLKIN1_UI_JITTER {0}
ad_ip_parameter clk10_gen CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE {50.000}
ad_ip_parameter clk10_gen CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {10.000}
ad_ip_parameter clk10_gen CONFIG.CLKOUT1_REQUESTED_PHASE {0.000}
ad_ip_parameter clk10_gen CONFIG.PRIMITIVE {PLL}
ad_ip_parameter clk10_gen CONFIG.PRIM_SOURCE {Global_buffer}
ad_ip_parameter clk10_gen CONFIG.RESET_TYPE {ACTIVE_LOW}
ad_ip_parameter clk10_gen CONFIG.USE_LOCKED {false}

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 sfp_iic
ad_connect sfp_iic corundum/iic

ad_connect led corundum/led
ad_connect sfp_led corundum/sfp_led

set_property verilog_define {APP_CUSTOM_PORTS_ENABLE APP_CUSTOM_PARAMS_ENABLE} [get_filesets sources_1]

ad_connect clk10_gen/clk_in1 $sys_dma_clk
ad_connect clk10_gen/resetn $sys_dma_resetn

ad_connect corundum/clk $sys_dma_clk
ad_connect corundum/rst $sys_dma_reset

ad_connect corundum/sfp_rx_p sfp_rx_p
ad_connect corundum/sfp_rx_n sfp_rx_n
ad_connect corundum/sfp_tx_p sfp_tx_p
ad_connect corundum/sfp_tx_n sfp_tx_n
ad_connect corundum/sfp_mgt_refclk_p sfp_mgt_refclk_p
ad_connect corundum/sfp_mgt_refclk_n sfp_mgt_refclk_n

ad_connect corundum/sfp_tx_disable sfp_tx_disable
ad_connect corundum/sfp_mod_abs sfp_mod_abs
ad_connect corundum/sfp_rx_los sfp_rx_los
ad_connect corundum/sfp_tx_fault sfp_tx_fault

ad_connect clk10_gen/clk_out1 ref_clk0

set fifo_num_bytes 4
set fifo_tdest_width 4
set fifo_tuser_width 2

set axi_clk_freq [get_property CONFIG.FREQ_HZ [get_bd_pins sys_ps8/pl_clk1]]
set_property CONFIG.FREQ_HZ $axi_clk_freq [get_bd_intf_pins corundum/m_axi_dma]
set_property CONFIG.FREQ_HZ $axi_clk_freq [get_bd_intf_pins corundum/s_axil_app_ctrl]
set_property CONFIG.FREQ_HZ $axi_clk_freq [get_bd_intf_pins corundum/s_axil_ctrl]

ad_ip_instance axi_interconnect smartconnect_corundum
ad_ip_parameter smartconnect_corundum CONFIG.NUM_MI 2
ad_ip_parameter smartconnect_corundum CONFIG.NUM_SI 1

ad_connect  sys_250m_interconnect_resetn sys_250m_rstgen/interconnect_aresetn
set  sys_dma_interconnect_resetn     [get_bd_nets sys_250m_interconnect_resetn]

ad_connect smartconnect_corundum/ARESETN $sys_dma_interconnect_resetn
ad_connect smartconnect_corundum/S00_ARESETN $sys_dma_interconnect_resetn
ad_connect smartconnect_corundum/M00_ARESETN $sys_dma_interconnect_resetn
ad_connect smartconnect_corundum/M01_ARESETN $sys_dma_interconnect_resetn

ad_connect smartconnect_corundum/ACLK $sys_dma_clk
ad_connect smartconnect_corundum/S00_ACLK $sys_dma_clk
ad_connect smartconnect_corundum/M00_ACLK $sys_dma_clk
ad_connect smartconnect_corundum/M01_ACLK $sys_dma_clk

ad_connect smartconnect_corundum/M00_AXI corundum/s_axil_ctrl
ad_connect smartconnect_corundum/M01_AXI corundum/s_axil_app_ctrl

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 1
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP0__DATA_WIDTH 32
ad_connect smartconnect_corundum/S00_AXI sys_ps8/M_AXI_HPM0_FPD
ad_connect sys_ps8/maxihpm0_fpd_aclk $sys_dma_clk

assign_bd_address -offset 0xA000_0000 [get_bd_addr_segs \
  corundum/s_axil_ctrl/Reg
] -target_address_space sys_ps8/Data
assign_bd_address -offset 0xA800_0000 [get_bd_addr_segs \
  corundum/s_axil_app_ctrl/Reg
] -target_address_space sys_ps8/Data

ad_ip_instance util_reduced_logic util_reduced_logic_0
ad_ip_parameter util_reduced_logic_0 CONFIG.C_OPERATION {or}
ad_ip_parameter util_reduced_logic_0 CONFIG.C_SIZE $IRQ_SIZE

ad_connect util_reduced_logic_0/Op1 corundum/core_irq

ad_cpu_interrupt ps-4 mb-4 util_reduced_logic_0/Res

ad_mem_hpc0_interconnect $sys_dma_clk sys_ps8/S_AXI_HPC0_FPD
ad_mem_hpc0_interconnect $sys_dma_clk corundum/m_axi_dma

assign_bd_address [get_bd_addr_segs { \
  sys_ps8/SAXIGP0/HPC0_LPS_OCM \
  sys_ps8/SAXIGP0/HPC0_QSPI \
  sys_ps8/SAXIGP0/HPC0_DDR_LOW \
  sys_ps8/SAXIGP0/HPC0_DDR_HIGH \
}]
