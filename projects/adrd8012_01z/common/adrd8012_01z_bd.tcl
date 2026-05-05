###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/library/corundum/scripts/corundum_k26_cfg.tcl
source $ad_hdl_dir/library/corundum/scripts/corundum.tcl

# GMSL
create_bd_port -dir I ap_rstn_frmbuf_0
create_bd_port -dir I ap_rstn_frmbuf_1

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

set s_axis_video_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video_0 ]
set_property -dict [ list \
  CONFIG.FREQ_HZ {250000000} \
  CONFIG.HAS_TKEEP {1} \
  CONFIG.HAS_TLAST {1} \
  CONFIG.HAS_TREADY {1} \
  CONFIG.HAS_TSTRB {1} \
  CONFIG.LAYERED_METADATA {undef} \
  CONFIG.TDATA_NUM_BYTES {12} \
  CONFIG.TDEST_WIDTH {1} \
  CONFIG.TID_WIDTH {1} \
  CONFIG.TUSER_WIDTH {1} \
] $s_axis_video_0

set m_axi_mm_video_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video_0 ]
set_property -dict [ list \
  CONFIG.ADDR_WIDTH {32} \
  CONFIG.DATA_WIDTH {256} \
  CONFIG.FREQ_HZ {250000000} \
  CONFIG.HAS_BURST {0} \
  CONFIG.NUM_READ_OUTSTANDING {2} \
  CONFIG.NUM_WRITE_OUTSTANDING {4} \
  CONFIG.PROTOCOL {AXI4} \
] $m_axi_mm_video_0

set s_axis_video_1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video_1 ]
set_property -dict [ list \
  CONFIG.FREQ_HZ {250000000} \
  CONFIG.HAS_TKEEP {1} \
  CONFIG.HAS_TLAST {1} \
  CONFIG.HAS_TREADY {1} \
  CONFIG.HAS_TSTRB {1} \
  CONFIG.LAYERED_METADATA {undef} \
  CONFIG.TDATA_NUM_BYTES {12} \
  CONFIG.TDEST_WIDTH {1} \
  CONFIG.TID_WIDTH {1} \
  CONFIG.TUSER_WIDTH {1} \
] $s_axis_video_1

set m_axi_mm_video_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video_1 ]
set_property -dict [ list \
  CONFIG.ADDR_WIDTH {32} \
  CONFIG.DATA_WIDTH {256} \
  CONFIG.FREQ_HZ {250000000} \
  CONFIG.HAS_BURST {0} \
  CONFIG.NUM_READ_OUTSTANDING {2} \
  CONFIG.NUM_WRITE_OUTSTANDING {4} \
  CONFIG.PROTOCOL {AXI4} \
] $m_axi_mm_video_1

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

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 sfp_iic

create_bd_port -dir O ref_clk0

create_bd_port -dir O -from 1 -to 0 led

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
  CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ 250 \
  CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 250 \
  CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ 250 \
  CONFIG.PSU__USE__M_AXI_GP0 {1} \
  CONFIG.PSU__USE__S_AXI_GP0 {1} \
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
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CMN_NUM_PIXELS {4}
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
ad_ip_parameter mipi_csi2_rx_subsyst_1 CONFIG.CMN_NUM_PIXELS {4}
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
  CONFIG.TDATA_NUM_BYTES {8} \
  CONFIG.TDEST_WIDTH {4} \
  CONFIG.TUSER_WIDTH {2} \
] $axis_switch_0

set axis_switch_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_1 ]
set_property -dict [list \
  CONFIG.HAS_TLAST {1} \
  CONFIG.NUM_MI {4} \
  CONFIG.NUM_SI {1} \
  CONFIG.TDATA_NUM_BYTES {8} \
  CONFIG.TDEST_WIDTH {4} \
  CONFIG.TUSER_WIDTH {2} \
] $axis_switch_1

ad_ip_instance rtp_engine rtp_engine_0
ad_ip_parameter rtp_engine_0 CONFIG.SSRC_ID 0
ad_ip_instance rtp_engine rtp_engine_1
ad_ip_parameter rtp_engine_0 CONFIG.SSRC_ID 1
ad_ip_instance rtp_engine rtp_engine_2
ad_ip_parameter rtp_engine_0 CONFIG.SSRC_ID 2
ad_ip_instance rtp_engine rtp_engine_3
ad_ip_parameter rtp_engine_0 CONFIG.SSRC_ID 3
ad_ip_instance rtp_engine rtp_engine_4
ad_ip_parameter rtp_engine_0 CONFIG.SSRC_ID 4
ad_ip_instance rtp_engine rtp_engine_5
ad_ip_parameter rtp_engine_0 CONFIG.SSRC_ID 5
ad_ip_instance rtp_engine rtp_engine_6
ad_ip_parameter rtp_engine_0 CONFIG.SSRC_ID 6
ad_ip_instance rtp_engine rtp_engine_7
ad_ip_parameter rtp_engine_0 CONFIG.SSRC_ID 7

ad_ip_instance rtp_session_mux rtp_session_mux
ad_ip_parameter rtp_session_mux CONFIG.SESSION_NUMBER 8

ad_ip_instance rtp_video_transm_handler rtp_video_transm_handler 
ad_ip_parameter rtp_video_transm_handler CONFIG.TX_DESC_TABLE_SIZE $TX_DESC_TABLE_SIZE 

ad_ip_instance v_frmbuf_wr v_frmbuf_0
ad_ip_parameter v_frmbuf_0 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_0 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_0 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_0 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_0 CONFIG.MAX_COLS {2880}
ad_ip_parameter v_frmbuf_0 CONFIG.MAX_ROWS {1860}
ad_ip_parameter v_frmbuf_0 CONFIG.SAMPLES_PER_CLOCK {4}

ad_ip_instance v_frmbuf_wr v_frmbuf_1
ad_ip_parameter v_frmbuf_1 CONFIG.HAS_UYVY8 {1}
ad_ip_parameter v_frmbuf_1 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_1 CONFIG.HAS_YUYV8 {0}
ad_ip_parameter v_frmbuf_1 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_1 CONFIG.MAX_COLS {2880}
ad_ip_parameter v_frmbuf_1 CONFIG.MAX_ROWS {1860}
ad_ip_parameter v_frmbuf_1 CONFIG.SAMPLES_PER_CLOCK {4}

ad_ip_instance axi_pwm_gen axi_pwm_gen_0
ad_ip_parameter axi_pwm_gen_0 CONFIG.N_PWMS {8}

ad_connect v_frmbuf_0/ap_rst_n ap_rstn_frmbuf_0
ad_connect v_frmbuf_1/ap_rst_n ap_rstn_frmbuf_1

connect_bd_intf_net -intf_net v_frmbuf_1_m_axi_mm_video [get_bd_intf_ports m_axi_mm_video_1] [get_bd_intf_pins v_frmbuf_1/m_axi_mm_video]
connect_bd_intf_net -intf_net v_frmbuf_0_m_axi_mm_video [get_bd_intf_ports m_axi_mm_video_0] [get_bd_intf_pins v_frmbuf_0/m_axi_mm_video]
connect_bd_intf_net -intf_net s_axis_video_0_1 [get_bd_intf_ports s_axis_video_0] [get_bd_intf_pins v_frmbuf_0/s_axis_video]
connect_bd_intf_net -intf_net s_axis_video_1_1 [get_bd_intf_ports s_axis_video_1] [get_bd_intf_pins v_frmbuf_1/s_axis_video]

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

ad_connect rtp_engine_0/aclk sys_cpu_clk
ad_connect rtp_engine_0/aresetn sys_cpu_resetn
ad_connect rtp_engine_1/aclk sys_cpu_clk
ad_connect rtp_engine_1/aresetn sys_cpu_resetn
ad_connect rtp_engine_2/aclk sys_cpu_clk
ad_connect rtp_engine_2/aresetn sys_cpu_resetn
ad_connect rtp_engine_3/aclk sys_cpu_clk
ad_connect rtp_engine_3/aresetn sys_cpu_resetn
ad_connect rtp_engine_4/aclk sys_cpu_clk
ad_connect rtp_engine_4/aresetn sys_cpu_resetn
ad_connect rtp_engine_5/aclk sys_cpu_clk
ad_connect rtp_engine_5/aresetn sys_cpu_resetn
ad_connect rtp_engine_6/aclk sys_cpu_clk
ad_connect rtp_engine_6/aresetn sys_cpu_resetn
ad_connect rtp_engine_7/aclk sys_cpu_clk
ad_connect rtp_engine_7/aresetn sys_cpu_resetn

ad_connect rtp_session_mux/aclk sys_cpu_clk
ad_connect rtp_session_mux/aresetn sys_cpu_resetn

ad_connect rtp_video_transm_handler/aclk sys_cpu_clk
ad_connect rtp_video_transm_handler/areset sys_cpu_reset

ad_connect mipi_csi2_rx_subsyst_0/video_out axis_switch_0/S00_AXIS
ad_connect rtp_engine_0/rtp_engine_slave axis_switch_0/M00_AXIS
ad_connect rtp_engine_1/rtp_engine_slave axis_switch_0/M01_AXIS
ad_connect rtp_engine_2/rtp_engine_slave axis_switch_0/M02_AXIS
ad_connect rtp_engine_3/rtp_engine_slave axis_switch_0/M03_AXIS

ad_connect mipi_csi2_rx_subsyst_1/video_out axis_switch_1/S00_AXIS
ad_connect rtp_engine_4/rtp_engine_slave axis_switch_1/M00_AXIS
ad_connect rtp_engine_5/rtp_engine_slave axis_switch_1/M01_AXIS
ad_connect rtp_engine_6/rtp_engine_slave axis_switch_1/M02_AXIS
ad_connect rtp_engine_7/rtp_engine_slave axis_switch_1/M03_AXIS

ad_connect rtp_engine_0/rtp_engine_master rtp_session_mux/rtp_session_0
ad_connect rtp_engine_1/rtp_engine_master rtp_session_mux/rtp_session_1
ad_connect rtp_engine_2/rtp_engine_master rtp_session_mux/rtp_session_2
ad_connect rtp_engine_3/rtp_engine_master rtp_session_mux/rtp_session_3
ad_connect rtp_engine_4/rtp_engine_master rtp_session_mux/rtp_session_4
ad_connect rtp_engine_5/rtp_engine_master rtp_session_mux/rtp_session_5
ad_connect rtp_engine_6/rtp_engine_master rtp_session_mux/rtp_session_6
ad_connect rtp_engine_7/rtp_engine_master rtp_session_mux/rtp_session_7

ad_connect rtp_session_mux/rtp_master rtp_video_transm_handler/transm_s1

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
ad_cpu_interconnect 0x44AA0000 rtp_engine_0
ad_cpu_interconnect 0x44AB0000 rtp_engine_1
ad_cpu_interconnect 0x44AC0000 rtp_engine_2
ad_cpu_interconnect 0x44AD0000 rtp_engine_3
ad_cpu_interconnect 0x44AE0000 rtp_engine_4
ad_cpu_interconnect 0x44AF0000 rtp_engine_5
ad_cpu_interconnect 0x44B00000 rtp_engine_6
ad_cpu_interconnect 0x44B10000 rtp_engine_7
ad_cpu_interconnect 0x44B20000 rtp_session_mux
ad_cpu_interconnect 0x44B60000 axi_pwm_gen_0

# Interrrupts
ad_cpu_interrupt ps-15 mb-15 mipi_csi2_rx_subsyst_0/csirxss_csi_irq
ad_cpu_interrupt ps-14 mb-14 mipi_csi2_rx_subsyst_1/csirxss_csi_irq
ad_cpu_interrupt ps-13 mb-13 axi_iic_mipi/iic2intc_irpt
ad_cpu_interrupt ps-12 mb-12 v_frmbuf_0/interrupt
ad_cpu_interrupt ps-11 mb-11 v_frmbuf_1/interrupt

# Corundum NIC

ad_ip_instance clk_wiz clk10_gen
ad_ip_parameter clk10_gen CONFIG.CLKIN1_UI_JITTER {0}
ad_ip_parameter clk10_gen CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE {50.000}
ad_ip_parameter clk10_gen CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {10.000}
ad_ip_parameter clk10_gen CONFIG.CLKOUT1_REQUESTED_PHASE {0.000}
ad_ip_parameter clk10_gen CONFIG.PRIMITIVE {PLL}
ad_ip_parameter clk10_gen CONFIG.PRIM_SOURCE {Global_buffer}
ad_ip_parameter clk10_gen CONFIG.RESET_TYPE {ACTIVE_LOW}
ad_ip_parameter clk10_gen CONFIG.USE_LOCKED {false}

connect_bd_net [get_bd_ports led] [get_bd_pins corundum_hierarchy/ethernet_core/led]

ad_connect corundum_hierarchy/clk_corundum $sys_cpu_clk
ad_ip_parameter corundum_rstgen CONFIG.C_AUX_RESET_HIGH {0}
ad_connect corundum_rstgen/slowest_sync_clk $sys_cpu_clk
ad_connect corundum_rstgen/ext_reset_in sys_ps8/pl_resetn0
ad_connect clk10_gen/clk_in1 $sys_dma_clk
ad_connect clk10_gen/resetn $sys_dma_resetn

ad_connect corundum_hierarchy/sfp_rx_p sfp_rx_p
ad_connect corundum_hierarchy/sfp_rx_n sfp_rx_n
ad_connect corundum_hierarchy/sfp_tx_p sfp_tx_p
ad_connect corundum_hierarchy/sfp_tx_n sfp_tx_n
ad_connect corundum_hierarchy/sfp_mgt_refclk_p sfp_mgt_refclk_p
ad_connect corundum_hierarchy/sfp_mgt_refclk_n sfp_mgt_refclk_n

ad_connect corundum_hierarchy/sfp_tx_disable sfp_tx_disable
ad_connect corundum_hierarchy/sfp_mod_abs sfp_mod_abs
ad_connect corundum_hierarchy/sfp_rx_los sfp_rx_los
ad_connect corundum_hierarchy/sfp_tx_fault sfp_tx_fault
ad_connect corundum_hierarchy/sfp_iic sfp_iic

ad_connect rtp_video_transm_handler/transm_s0 corundum_hierarchy/application_core/output_axis
ad_connect rtp_video_transm_handler/transm_master corundum_hierarchy/application_core/input_axis
ad_connect rtp_session_mux/start_video_transfer corundum_hierarchy/application_core/start_video_transfer

ad_connect clk10_gen/clk_out1 ref_clk0

ad_ip_instance axi_interconnect smartconnect_corundum
ad_ip_parameter smartconnect_corundum CONFIG.NUM_MI 2
ad_ip_parameter smartconnect_corundum CONFIG.NUM_SI 1

ad_connect smartconnect_corundum/ARESETN sys_rstgen/interconnect_aresetn
ad_connect smartconnect_corundum/S00_ARESETN sys_rstgen/interconnect_aresetn
ad_connect smartconnect_corundum/M00_ARESETN sys_rstgen/interconnect_aresetn
ad_connect smartconnect_corundum/M01_ARESETN sys_rstgen/interconnect_aresetn

ad_connect smartconnect_corundum/ACLK $sys_cpu_clk
ad_connect smartconnect_corundum/S00_ACLK $sys_cpu_clk
ad_connect smartconnect_corundum/M00_ACLK $sys_cpu_clk
ad_connect smartconnect_corundum/M01_ACLK $sys_cpu_clk

ad_connect smartconnect_corundum/M00_AXI corundum_hierarchy/s_axil_corundum

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 1
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP0__DATA_WIDTH 32
ad_connect smartconnect_corundum/S00_AXI sys_ps8/M_AXI_HPM0_FPD
ad_connect sys_ps8/maxihpm0_fpd_aclk $sys_cpu_clk

assign_bd_address -offset 0xA000_0000 [get_bd_addr_segs \
  corundum_hierarchy/corundum_core/s_axil_ctrl/Reg
] -target_address_space sys_ps8/Data

ad_ip_instance ilreduced_logic util_reduced_logic_0
ad_ip_parameter util_reduced_logic_0 CONFIG.C_OPERATION {or}
ad_ip_parameter util_reduced_logic_0 CONFIG.C_SIZE {8}

ad_connect util_reduced_logic_0/Op1 corundum_hierarchy/irq

ad_cpu_interrupt ps-4 mb-4 util_reduced_logic_0/Res

ad_mem_hpc0_interconnect $sys_cpu_clk sys_ps8/S_AXI_HPC0_FPD
ad_mem_hpc0_interconnect $sys_cpu_clk corundum_hierarchy/m_axi

assign_bd_address [get_bd_addr_segs { \
  sys_ps8/SAXIGP0/HPC0_LPS_OCM \
  sys_ps8/SAXIGP0/HPC0_QSPI \
  sys_ps8/SAXIGP0/HPC0_DDR_LOW \
  sys_ps8/SAXIGP0/HPC0_DDR_HIGH \
}]
