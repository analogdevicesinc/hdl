source $ad_hdl_dir/projects/common/kv260/kv260_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0
create_bd_port -dir I ap_rstn_frmbuf_0
create_bd_port -dir I ap_rstn_frmbuf_1
create_bd_port -dir I ap_rstn_frmbuf_2
create_bd_port -dir I ap_rstn_frmbuf_3
create_bd_port -dir I csirxss_rstn

ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ 300

ad_ip_instance mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_0
set_property -dict [ list \
   CONFIG.CLK_LANE_IO_LOC {D7} \
   CONFIG.CLK_LANE_IO_LOC_NAME {IO_L13P_T2L_N0_GC_QBC_66} \
   CONFIG.DPHYRX_BOARD_INTERFACE {som240_1_connector_mipi_csi_raspi} \
   CONFIG.CMN_NUM_LANES {2} \
   CONFIG.CMN_PXL_FORMAT {YUV422_8bit} \
   CONFIG.C_CLK_LANE_IO_POSITION {26} \
   CONFIG.C_CSI_EN_ACTIVELANES {false} \
   CONFIG.C_DATA_LANE0_IO_POSITION {28} \
   CONFIG.C_DATA_LANE1_IO_POSITION {30} \
   CONFIG.C_DPHY_LANES {2} \
   CONFIG.C_EN_BG0_PIN0 {false} \
   CONFIG.C_EN_BG1_PIN0 {false} \
   CONFIG.C_EN_CSI_V2_0 {false} \
   CONFIG.C_HS_SETTLE_NS {153} \
   CONFIG.DATA_LANE0_IO_LOC {E5} \
   CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L14P_T2L_N2_GC_66} \
   CONFIG.DATA_LANE1_IO_LOC {G6} \
   CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L15P_T2L_N4_AD11P_66} \
   CONFIG.DPY_LINE_RATE {2500} \
   CONFIG.C_EN_CSI_V2_0 {false} \
   CONFIG.CMN_NUM_PIXELS {2} \
   CONFIG.CMN_INC_VFB {true} \
   CONFIG.DPY_EN_REG_IF {true} \
   CONFIG.CSI_EMB_NON_IMG {false} \
   CONFIG.VFB_TU_WIDTH {2} \
   CONFIG.HP_IO_BANK_SELECTION {66} \
   CONFIG.SupportLevel {1} \
] [get_bd_cells mipi_csi2_rx_subsyst_0]

ad_ip_instance axis_switch axis_switch_0
set_property -dict [list \
  CONFIG.HAS_TLAST {1} \
  CONFIG.NUM_MI {4} \
  CONFIG.NUM_SI {1} \
  CONFIG.TDATA_NUM_BYTES {4} \
  CONFIG.TDEST_WIDTH {4} \
  CONFIG.TUSER_WIDTH {2} \
] [get_bd_cells axis_switch_0]

ad_ip_instance v_frmbuf_wr v_frmbuf_wr_0
set_property -dict [list \
  CONFIG.HAS_UYVY8 {1} \
  CONFIG.HAS_YUYV8 {1} \
  CONFIG.HAS_Y_UV8 {1} \
  CONFIG.SAMPLES_PER_CLOCK {2} \
] [get_bd_cells v_frmbuf_wr_0]

ad_ip_instance v_frmbuf_wr v_frmbuf_wr_1
set_property -dict [list \
 CONFIG.HAS_UYVY8 {1} \
 CONFIG.HAS_YUYV8 {1} \
 CONFIG.HAS_Y_UV8 {1} \
 CONFIG.SAMPLES_PER_CLOCK {2} \
] [get_bd_cells v_frmbuf_wr_1]

ad_ip_instance v_frmbuf_wr v_frmbuf_wr_2
set_property -dict [list \
  CONFIG.HAS_UYVY8 {1} \
  CONFIG.HAS_YUYV8 {1} \
  CONFIG.HAS_Y_UV8 {1} \
  CONFIG.SAMPLES_PER_CLOCK {2} \
] [get_bd_cells v_frmbuf_wr_2]

ad_ip_instance v_frmbuf_wr v_frmbuf_wr_3
set_property -dict [list \
  CONFIG.HAS_UYVY8 {1} \
  CONFIG.AXIMM_DATA_WIDTH {32} \
  CONFIG.HAS_YUYV8 {1} \
  CONFIG.HAS_Y_UV8 {1} \
  CONFIG.SAMPLES_PER_CLOCK {2} \
] [get_bd_cells v_frmbuf_wr_3]

connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_ports mipi_phy_if_0] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]

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

ad_ip_instance axi_iic axi_iic_mipi
ad_ip_parameter axi_iic_mipi CONFIG.IIC_BOARD_INTERFACE {som240_1_connector_hda_iic_switch}
ad_ip_parameter axi_iic_mipi CONFIG.IIC_FREQ_KHZ {95}

make_bd_intf_pins_external [get_bd_intf_pins axi_iic_mipi/IIC]

ad_connect dphy_clk_generator/clk_in1 $sys_dma_clk
ad_connect dphy_clk_generator/resetn $sys_dma_resetn

ad_connect mipi_csi2_rx_subsyst_0/video_aclk $sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_0/video_aresetn csirxss_rstn
ad_connect mipi_csi2_rx_subsyst_0/lite_aclk $sys_cpu_clk
ad_connect mipi_csi2_rx_subsyst_0/lite_aresetn $sys_cpu_resetn
ad_connect mipi_csi2_rx_subsyst_0/dphy_clk_200M dphy_clk_generator/clk_out1

ad_connect mipi_csi2_rx_subsyst_0/video_out axis_switch_0/S00_AXIS
ad_connect axis_switch_0/M00_AXIS axis_subset_cnv_0/S_AXIS
ad_connect axis_switch_0/M01_AXIS axis_subset_cnv_1/S_AXIS
ad_connect axis_switch_0/M02_AXIS axis_subset_cnv_2/S_AXIS
ad_connect axis_switch_0/M03_AXIS axis_subset_cnv_3/S_AXIS

ad_connect axis_switch_0/aclk $sys_cpu_clk
ad_connect axis_switch_0/aresetn csirxss_rstn
ad_connect axis_subset_cnv_0/aclk $sys_cpu_clk
ad_connect axis_subset_cnv_0/aresetn ap_rstn_frmbuf_0
ad_connect axis_subset_cnv_1/aclk $sys_cpu_clk
ad_connect axis_subset_cnv_1/aresetn ap_rstn_frmbuf_1
ad_connect axis_subset_cnv_2/aclk $sys_cpu_clk
ad_connect axis_subset_cnv_2/aresetn ap_rstn_frmbuf_2
ad_connect axis_subset_cnv_3/aclk $sys_cpu_clk
ad_connect axis_subset_cnv_3/aresetn ap_rstn_frmbuf_3
ad_connect axis_subset_cnv_0/M_AXIS v_frmbuf_wr_0/s_axis_video
ad_connect axis_subset_cnv_1/M_AXIS v_frmbuf_wr_1/s_axis_video
ad_connect axis_subset_cnv_2/M_AXIS v_frmbuf_wr_2/s_axis_video
ad_connect axis_subset_cnv_3/M_AXIS v_frmbuf_wr_3/s_axis_video
ad_connect v_frmbuf_wr_0/ap_clk $sys_cpu_clk
ad_connect v_frmbuf_wr_0/ap_rst_n ap_rstn_frmbuf_0
ad_connect v_frmbuf_wr_1/ap_clk $sys_cpu_clk
ad_connect v_frmbuf_wr_1/ap_rst_n ap_rstn_frmbuf_1
ad_connect v_frmbuf_wr_2/ap_clk $sys_cpu_clk
ad_connect v_frmbuf_wr_2/ap_rst_n ap_rstn_frmbuf_2
ad_connect v_frmbuf_wr_3/ap_clk $sys_cpu_clk
ad_connect v_frmbuf_wr_3/ap_rst_n ap_rstn_frmbuf_3

ad_connect axi_iic_mipi/s_axi_aclk $sys_cpu_clk
ad_connect axi_iic_mipi/s_axi_aresetn $sys_cpu_resetn

ad_cpu_interconnect 0x44A00000  mipi_csi2_rx_subsyst_0
ad_cpu_interconnect 0x44A20000  axi_iic_mipi
ad_cpu_interconnect 0x44A40000  v_frmbuf_wr_0
ad_cpu_interconnect 0x44A60000  v_frmbuf_wr_1
ad_cpu_interconnect 0x44A80000  v_frmbuf_wr_2
ad_cpu_interconnect 0x44AA0000  v_frmbuf_wr_3

ad_mem_hp0_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP0
ad_mem_hp0_interconnect $sys_cpu_clk v_frmbuf_wr_0/m_axi_mm_video
ad_mem_hp1_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk v_frmbuf_wr_1/m_axi_mm_video
ad_mem_hp2_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk v_frmbuf_wr_2/m_axi_mm_video
ad_mem_hp3_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk v_frmbuf_wr_3/m_axi_mm_video

ad_cpu_interrupt ps-13 mb-13 mipi_csi2_rx_subsyst_0/csirxss_csi_irq
ad_cpu_interrupt ps-12 mb-12 axi_iic_mipi/iic2intc_irpt
ad_cpu_interrupt ps-11 mb-11 v_frmbuf_wr_0/interrupt
ad_cpu_interrupt ps-10 mb-10 v_frmbuf_wr_1/interrupt
ad_cpu_interrupt ps-9 mb-9 v_frmbuf_wr_2/interrupt
ad_cpu_interrupt ps-8 mb-8 v_frmbuf_wr_3/interrupt

#system ID

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

