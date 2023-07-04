create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sfp_ref_clk_0
set_property CONFIG.FREQ_HZ 156250000 [get_bd_intf_ports /sfp_ref_clk_0]

create_bd_port -dir O pps_out
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 sfp_txr
#create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 pl_iic

# ps8
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 {1}
ad_connect sys_cpu_clk sys_ps8/maxihpm0_fpd_aclk

# qpll reset gpio
ad_ip_instance axi_gpio axi_gpio_0_qpll_rst
ad_ip_parameter axi_gpio_0_qpll_rst CONFIG.C_IS_DUAL 0
ad_ip_parameter axi_gpio_0_qpll_rst CONFIG.C_GPIO_WIDTH 1

#ad_ip_instance axi_iic axi_pl_iic

ad_ip_instance xxv_ethernet xxv_ethernet_0
ad_ip_parameter xxv_ethernet_0 CONFIG.ADD_GT_CNTRL_STS_PORTS {0}
ad_ip_parameter xxv_ethernet_0 CONFIG.BASE_R_KR {BASE-R}
ad_ip_parameter xxv_ethernet_0 CONFIG.ENABLE_PIPELINE_REG {0}
ad_ip_parameter xxv_ethernet_0 CONFIG.ENABLE_TIME_STAMPING {1}
ad_ip_parameter xxv_ethernet_0 CONFIG.GT_REF_CLK_FREQ {156.25}
ad_ip_parameter xxv_ethernet_0 CONFIG.INCLUDE_AXI4_INTERFACE {1}
ad_ip_parameter xxv_ethernet_0 CONFIG.SYS_CLK {10000}
ad_ip_parameter xxv_ethernet_0 CONFIG.ENABLE_TIME_STAMPING {1}
ad_ip_parameter xxv_ethernet_0 CONFIG.PTP_OPERATION_MODE {2}

#
ad_ip_instance ptp_1588_timer_syncer ptp_1588_timer_syncer_0
ad_ip_parameter ptp_1588_timer_syncer_0 CONFIG.AXI4LITE_FREQ {156.25}
ad_ip_parameter ptp_1588_timer_syncer_0 CONFIG.CORE_CONFIGURATION {1}
ad_ip_parameter ptp_1588_timer_syncer_0 CONFIG.CORE_MODE {Timer_Syncer}
ad_ip_parameter ptp_1588_timer_syncer_0 CONFIG.ENABLE_HIGH_ACCURACY_MODE {0}
ad_ip_parameter ptp_1588_timer_syncer_0 CONFIG.RESYNC_CLK_PERIOD {2560}
ad_ip_parameter ptp_1588_timer_syncer_0 CONFIG.TIMER_FORMAT {Time_of_Day}
ad_ip_parameter ptp_1588_timer_syncer_0 CONFIG.TOD_SEC_CLK_FREQ {100.00}
ad_ip_parameter ptp_1588_timer_syncer_0 CONFIG.TS_CLK_PERIOD {4.0000}

ad_ip_instance tdest_mapper tdest_mapper_1
ad_ip_instance hw_master_top hw_master_top_1

# copied
ad_ip_instance axi_register_slice axi_register_slice_0
ad_ip_parameter axi_register_slice_0 CONFIG.ADDR_WIDTH {64}
ad_ip_parameter axi_register_slice_0 CONFIG.AWUSER_WIDTH {4}
ad_ip_parameter axi_register_slice_0 CONFIG.ID_WIDTH {1}

ad_ip_instance util_vector_logic util_vector_logic_0
ad_ip_parameter util_vector_logic_0 CONFIG.C_SIZE {1}

ad_ip_instance util_vector_logic util_vector_logic_1
ad_ip_parameter util_vector_logic_1 CONFIG.C_SIZE {1}

ad_ip_instance util_vector_logic util_vector_logic_2
ad_ip_parameter util_vector_logic_2 CONFIG.C_SIZE {1}

ad_ip_instance util_vector_logic util_vector_logic_3
ad_ip_parameter util_vector_logic_3 CONFIG.C_SIZE {1}

ad_ip_instance util_vector_logic dma_rx_reset
ad_ip_parameter dma_rx_reset CONFIG.C_SIZE {1}
ad_ip_parameter dma_rx_reset CONFIG.C_OPERATION {not}

ad_ip_instance util_vector_logic dma_tx_reset
ad_ip_parameter dma_tx_reset CONFIG.C_SIZE {1}
ad_ip_parameter dma_tx_reset CONFIG.C_OPERATION {not}

ad_ip_instance util_vector_logic rx_reset_n
ad_ip_parameter rx_reset_n CONFIG.C_SIZE {1}
ad_ip_parameter rx_reset_n CONFIG.C_OPERATION {not}

ad_ip_instance util_vector_logic tx_reset_n
ad_ip_parameter tx_reset_n CONFIG.C_SIZE {1}
ad_ip_parameter tx_reset_n CONFIG.C_OPERATION {not}

ad_ip_instance util_reduced_logic util_reduced_logic_0
ad_ip_parameter util_reduced_logic_0 CONFIG.C_OPERATION {or}
ad_ip_parameter util_reduced_logic_0 CONFIG.C_SIZE {16}

ad_ip_instance util_reduced_logic util_reduced_logic_1
ad_ip_parameter util_reduced_logic_1 CONFIG.C_OPERATION {or}
ad_ip_parameter util_reduced_logic_1 CONFIG.C_SIZE {16}

#ad_ip_instance util_reduced_logic reset_invert_led
#ad_ip_parameter reset_invert_led CONFIG.C_SIZE {1}

ad_ip_instance xlconcat xlconcat_0
ad_ip_parameter xlconcat_0 CONFIG.NUM_PORTS {16}

ad_ip_instance xlconcat xlconcat_1
ad_ip_parameter xlconcat_1 CONFIG.NUM_PORTS {16}

ad_ip_instance xlconcat concat_rx_ns_s
ad_ip_parameter concat_rx_ns_s CONFIG.IN0_WIDTH {32}
ad_ip_parameter concat_rx_ns_s CONFIG.IN1_WIDTH {48}

ad_ip_instance xlconcat concat_tx_ns_s
ad_ip_parameter concat_tx_ns_s CONFIG.IN0_WIDTH {32}
ad_ip_parameter concat_tx_ns_s CONFIG.IN1_WIDTH {48}

ad_ip_instance fifo_generator fifo_generator_0
ad_ip_parameter fifo_generator_0 CONFIG.Input_Data_Width {80}
ad_ip_parameter fifo_generator_0 CONFIG.Input_Depth {512}
ad_ip_parameter fifo_generator_0 CONFIG.Performance_Options {First_Word_Fall_Through}
ad_ip_parameter fifo_generator_0 Programmable_Full_Type {Single_Programmable_Full_Threshold_Constant}

ad_ip_instance fifo_generator fifo_generator_1
ad_ip_parameter fifo_generator_1 CONFIG.Input_Data_Width {16}
ad_ip_parameter fifo_generator_1 CONFIG.Input_Depth {512}
ad_ip_parameter fifo_generator_1 CONFIG.Performance_Options {First_Word_Fall_Through}
ad_ip_parameter fifo_generator_1 Programmable_Full_Type {Single_Programmable_Full_Threshold_Constant}

ad_ip_instance xlconstant Default_mcdma_chn
ad_ip_parameter Default_mcdma_chn CONFIG.CONST_VAL {0x0}
ad_ip_parameter Default_mcdma_chn CONFIG.CONST_WIDTH {4}

ad_ip_instance xlconstant Enable_TDest
ad_ip_parameter Enable_TDest CONFIG.CONST_VAL {0x1}
ad_ip_parameter Enable_TDest CONFIG.CONST_WIDTH {1}

ad_ip_instance xlconstant tie_gnd
ad_ip_parameter tie_gnd CONFIG.CONST_VAL {0}
ad_ip_parameter tie_gnd CONFIG.CONST_WIDTH {56}

ad_ip_instance axi_mcdma axi_mcdma_0
ad_ip_parameter axi_mcdma_0 CONFIG.c_group1_mm2s {1111111111111111}
ad_ip_parameter axi_mcdma_0 CONFIG.c_group1_s2mm {1111111111111111}
ad_ip_parameter axi_mcdma_0 CONFIG.c_include_mm2s_dre {1}
ad_ip_parameter axi_mcdma_0 CONFIG.c_include_s2mm_dre {1}
ad_ip_parameter axi_mcdma_0 CONFIG.c_m_axi_mm2s_data_width {64}
ad_ip_parameter axi_mcdma_0 CONFIG.c_m_axi_s2mm_data_width {64}
ad_ip_parameter axi_mcdma_0 CONFIG.c_m_axis_mm2s_tdata_width {64}
ad_ip_parameter axi_mcdma_0 CONFIG.c_mm2s_burst_size {64}
ad_ip_parameter axi_mcdma_0 CONFIG.c_mm2s_scheduler {1}
ad_ip_parameter axi_mcdma_0 CONFIG.c_num_mm2s_channels {16}
ad_ip_parameter axi_mcdma_0 CONFIG.c_num_s2mm_channels {16}
ad_ip_parameter axi_mcdma_0 CONFIG.c_prmry_is_aclk_async {1}
ad_ip_parameter axi_mcdma_0 CONFIG.c_s2mm_burst_size {64}
ad_ip_parameter axi_mcdma_0 CONFIG.c_sg_include_stscntrl_strm {1}
ad_ip_parameter axi_mcdma_0 CONFIG.c_sg_length_width {23}

ad_ip_instance axis_data_fifo axis_data_fifo_0
ad_ip_parameter axis_data_fifo_0 CONFIG.FIFO_MODE {2}
ad_ip_parameter axis_data_fifo_0 CONFIG.HAS_WR_DATA_COUNT {0}
ad_ip_parameter axis_data_fifo_0 CONFIG.TDATA_NUM_BYTES {4}

ad_ip_instance axis_data_fifo axis_data_fifo_1
ad_ip_parameter axis_data_fifo_1 CONFIG.FIFO_DEPTH {16384}
ad_ip_parameter axis_data_fifo_1 CONFIG.HAS_PROG_FULL {0}
ad_ip_parameter axis_data_fifo_1 CONFIG.HAS_WR_DATA_COUNT {0}
ad_ip_parameter axis_data_fifo_1 CONFIG.IS_ACLK_ASYNC {1}

ad_ip_instance axis_data_fifo axis_rxd_fifo
ad_ip_parameter axis_rxd_fifo CONFIG.FIFO_DEPTH {16384}
ad_ip_parameter axis_rxd_fifo CONFIG.FIFO_MODE {2}
ad_ip_parameter axis_rxd_fifo CONFIG.HAS_PROG_FULL {1}
ad_ip_parameter axis_rxd_fifo CONFIG.HAS_TKEEP {1}
ad_ip_parameter axis_rxd_fifo CONFIG.HAS_WR_DATA_COUNT {0}
ad_ip_parameter axis_rxd_fifo CONFIG.IS_ACLK_ASYNC {0}
ad_ip_parameter axis_rxd_fifo CONFIG.PROG_FULL_THRESH {15000}
ad_ip_parameter axis_rxd_fifo CONFIG.TDATA_NUM_BYTES {8}
ad_ip_parameter axis_rxd_fifo CONFIG.TUSER_WIDTH {1}

ad_ip_instance axis_data_fifo axis_txd_fifo
ad_ip_parameter axis_txd_fifo CONFIG.FIFO_DEPTH {16384}
ad_ip_parameter axis_txd_fifo CONFIG.FIFO_MODE {2}
ad_ip_parameter axis_txd_fifo CONFIG.HAS_TKEEP {1}
ad_ip_parameter axis_txd_fifo CONFIG.IS_ACLK_ASYNC {0}
ad_ip_parameter axis_txd_fifo CONFIG.TUSER_WIDTH {16}

#ad_ip_instance axis_data_fifo axis_txd_fifo
#ad_ip_parameter axis_txd_fifo CONFIG.FIFO_DEPTH {16384}
#ad_ip_parameter axis_txd_fifo CONFIG.FIFO_MODE {2}
#ad_ip_parameter axis_txd_fifo CONFIG.HAS_TKEEP {1}
#ad_ip_parameter axis_txd_fifo CONFIG.IS_ACLK_ASYNC {0}
#ad_ip_parameter axis_txd_fifo CONFIG.TUSER_WIDTH {16}

ad_ip_instance axi_bram_ctrl axi_bram_ctrl_0

ad_ip_instance blk_mem_gen axi_bram_ctrl_0_bram
ad_ip_parameter axi_bram_ctrl_0_bram CONFIG.Enable_B {Use_ENB_Pin}
ad_ip_parameter axi_bram_ctrl_0_bram CONFIG.Memory_Type {True_Dual_Port_RAM}
ad_ip_parameter axi_bram_ctrl_0_bram CONFIG.Port_B_Clock {100}
ad_ip_parameter axi_bram_ctrl_0_bram CONFIG.Port_B_Enable_Rate {100}
ad_ip_parameter axi_bram_ctrl_0_bram CONFIG.Port_B_Write_Rate {50}
ad_ip_parameter axi_bram_ctrl_0_bram CONFIG.Use_RSTB_Pin {true}
ad_ip_parameter axi_bram_ctrl_0_bram CONFIG.EN_SAFETY_CKT {false}

# bram interconnect
ad_ip_instance axi_interconnect axi_mem_intercon
ad_ip_parameter axi_mem_intercon CONFIG.NUM_MI {1}
ad_ip_parameter axi_mem_intercon CONFIG.NUM_SI {1}

# led blink stuff
#ad_ip_instance c_counter_binary c_counter_binary_0
#ad_ip_parameter c_counter_binary_0 CONFIG.Output_Width {32}
#ad_ip_parameter c_counter_binary_0 CONFIG.Restrict_Count {false}

#ad_ip_instance xlslice xlslice_0
#ad_ip_parameter xlslice_0 CONFIG.DIN_FROM {24}
#ad_ip_parameter xlslice_0 CONFIG.DIN_TO {24}
#ad_ip_parameter xlslice_0 CONFIG.DOUT_WIDTH {1}
#

ad_ip_instance axi_timer axi_timer_1
ad_ip_instance RX_PTP_TS_PREPEND RX_PTP_TS_PREPEND_0
ad_ip_instance RX_PTP_PKT_DETECT_one_step RX_PTP_PKT_DETECT_on_0

# /copied

#ad_ip_instance util_vector_logic util_not_0
#ad_ip_parameter util_not_0 CONFIG.C_SIZE 1
#ad_ip_parameter util_not_0 CONFIG.C_OPERATION not

#ad_ip_instance util_vector_logic util_not_1
#ad_ip_parameter util_not_1 CONFIG.C_SIZE 1
#ad_ip_parameter util_not_1 CONFIG.C_OPERATION not

#ad_ip_instance util_vector_logic util_not_2
#ad_ip_parameter util_not_2 CONFIG.C_SIZE 1
#ad_ip_parameter util_not_2 CONFIG.C_OPERATION not

#ad_ip_instance util_vector_logic util_not_3
#ad_ip_parameter util_not_3 CONFIG.C_SIZE 1
#ad_ip_parameter util_not_3 CONFIG.C_OPERATION not

#ad_ip_instance util_vector_logic util_not_4
#ad_ip_parameter util_not_4 CONFIG.C_SIZE 1
#ad_ip_parameter util_not_4 CONFIG.C_OPERATION not

ad_ip_instance xlconstant constant_101b
ad_ip_parameter constant_101b CONFIG.CONST_WIDTH {3}
ad_ip_parameter constant_101b CONFIG.CONST_VAL {5}

#

#ad_connect  sys_ps8/emio_spi1_ss_i_n VCC
#ad_connect  sys_ps8/emio_spi1_sclk_i GND

#ad_connect axi_pl_iic/IIC pl_iic

ad_connect sfp_txr xxv_ethernet_0/gt_serial_port
ad_connect sfp_ref_clk_0 xxv_ethernet_0/gt_ref_clk

ad_connect xxv_ethernet_0/tx_preamblein_0 tie_gnd/dout
ad_connect xxv_ethernet_0/pm_tick_0 GND
ad_connect xxv_ethernet_0/gtwiz_reset_rx_datapath_0 GND
ad_connect xxv_ethernet_0/gtwiz_reset_tx_datapath_0 GND
ad_connect xxv_ethernet_0/ctl_tx_send_idle_0 GND
ad_connect xxv_ethernet_0/ctl_tx_send_lfi_0 GND
ad_connect xxv_ethernet_0/ctl_tx_send_rfi_0 GND

ad_connect constant_101b/dout xxv_ethernet_0/rxoutclksel_in_0
ad_connect constant_101b/dout xxv_ethernet_0/txoutclksel_in_0

ad_connect axi_gpio_0_qpll_rst/gpio_io_o xxv_ethernet_0/qpllreset_in_0
ad_connect sys_cpu_reset xxv_ethernet_0/sys_reset
ad_connect dma_tx_reset/Res xxv_ethernet_0/tx_reset_0
ad_connect axi_mcdma_0/mm2s_prmry_reset_out_n dma_tx_reset/Op1
ad_connect dma_rx_reset/Res xxv_ethernet_0/rx_reset_0
ad_connect axi_mcdma_0/s2mm_prmry_reset_out_n dma_rx_reset/Op1

# eth user_tx_reset_0
ad_connect tx_reset_n/Op1 xxv_ethernet_0/user_tx_reset_0
ad_connect tx_reset_n/Res tdest_mapper_1/reset
ad_connect tx_reset_n/Res axis_data_fifo_0/s_axis_aresetn
ad_connect tx_reset_n/Res axis_txd_fifo/s_axis_aresetn
ad_connect tx_reset_n/Res hw_master_top_1/s_axis_resetn
ad_connect tx_reset_n/Res hw_master_top_1/m00_axi_aresetn
ad_connect tx_reset_n/Res axi_register_slice_0/aresetn

# eth user_rx_reset_0
ad_connect xxv_ethernet_0/user_rx_reset_0 fifo_generator_0/srst
ad_connect xxv_ethernet_0/user_rx_reset_0 fifo_generator_1/srst
ad_connect rx_reset_n/Op1 xxv_ethernet_0/user_rx_reset_0
ad_connect rx_reset_n/Res axis_rxd_fifo/s_axis_aresetn
ad_connect rx_reset_n/Res axis_data_fifo_1/s_axis_aresetn
ad_connect rx_reset_n/Res RX_PTP_TS_PREPEND_0/rx_axis_reset_in
ad_connect rx_reset_n/Res RX_PTP_PKT_DETECT_on_0/rx_axis_reset_in




# clocks
ad_connect sys_cpu_clk xxv_ethernet_0/dclk

ad_connect xxv_ethernet_0/rx_clk_out_0 xxv_ethernet_0/rx_core_clk_0
ad_connect xxv_ethernet_0/rx_clk_out_0 axis_rxd_fifo/s_axis_aclk
ad_connect xxv_ethernet_0/rx_clk_out_0 axis_data_fifo_1/s_axis_aclk
ad_connect xxv_ethernet_0/rx_clk_out_0 RX_PTP_TS_PREPEND_0/rx_axis_clk_in
ad_connect xxv_ethernet_0/rx_clk_out_0 RX_PTP_PKT_DETECT_on_0/rx_axis_clk_in
ad_connect xxv_ethernet_0/rx_clk_out_0 fifo_generator_0/clk
ad_connect xxv_ethernet_0/rx_clk_out_0 fifo_generator_1/clk


ad_connect xxv_ethernet_0/tx_clk_out_0 axis_data_fifo_1/m_axis_aclk
ad_connect xxv_ethernet_0/tx_clk_out_0 axis_data_fifo_0/s_axis_aclk
ad_connect xxv_ethernet_0/tx_clk_out_0 tdest_mapper_1/clk
ad_connect xxv_ethernet_0/tx_clk_out_0 axi_mcdma_0/m_axi_mm2s_aclk
ad_connect xxv_ethernet_0/tx_clk_out_0 axi_mcdma_0/m_axi_s2mm_aclk
ad_connect xxv_ethernet_0/tx_clk_out_0 axis_txd_fifo/s_axis_aclk
ad_connect xxv_ethernet_0/tx_clk_out_0 axi_register_slice_0/aclk
ad_connect xxv_ethernet_0/tx_clk_out_0 hw_master_top_1/s_axis_clk
ad_connect xxv_ethernet_0/tx_clk_out_0 hw_master_top_1/m00_axi_aclk
#ad_connect xxv_ethernet_0/tx_clk_out_0 axi_interconnect_0/ 3x



# eth axis_rx_0
ad_connect xxv_ethernet_0/axis_rx_0 axis_rxd_fifo/S_AXIS
ad_connect xxv_ethernet_0/rx_axis_tdata_0 axis_rxd_fifo/s_axis_tdata
ad_connect xxv_ethernet_0/rx_axis_tdata_0 RX_PTP_PKT_DETECT_on_0/s_axis_tdata

ad_connect xxv_ethernet_0/rx_axis_tkeep_0 axis_rxd_fifo/s_axis_tkeep
ad_connect xxv_ethernet_0/rx_axis_tkeep_0 RX_PTP_PKT_DETECT_on_0/s_axis_tkeep

ad_connect xxv_ethernet_0/rx_axis_tlast_0 axis_rxd_fifo/s_axis_tlast
ad_connect xxv_ethernet_0/rx_axis_tlast_0 RX_PTP_PKT_DETECT_on_0/s_axis_tlast
ad_connect xxv_ethernet_0/rx_axis_tlast_0 RX_PTP_TS_PREPEND_0/mrmac_last

ad_connect xxv_ethernet_0/rx_axis_tuser_0 axis_rxd_fifo/s_axis_tuser

ad_connect xxv_ethernet_0/rx_axis_tvalid_0 RX_PTP_TS_PREPEND_0/mrmac_valid
ad_connect xxv_ethernet_0/rx_axis_tvalid_0 util_vector_logic_2/Op1

  ad_connect RX_PTP_TS_PREPEND_0/fifo_valid util_vector_logic_2/Op2
  ad_connect RX_PTP_TS_PREPEND_0/fifo_valid util_vector_logic_3/Op2

  ad_connect util_vector_logic_2/Res RX_PTP_PKT_DETECT_on_0/s_axis_tvalid
  ad_connect util_vector_logic_2/Res axis_rxd_fifo/s_axis_tvalid

#
ad_connect xxv_ethernet_0/rx_ptp_tstamp_valid_out_0 util_vector_logic_3/Op1

# eth axis_tx_0
ad_connect axis_txd_fifo/m_axis_tdata xxv_ethernet_0/tx_axis_tdata_0
ad_connect axis_txd_fifo/m_axis_tkeep xxv_ethernet_0/tx_axis_tkeep_0
ad_connect axis_txd_fifo/m_axis_tlast xxv_ethernet_0/tx_axis_tlast_0
ad_connect axis_txd_fifo/m_axis_tlast hw_master_top_1/s_axis_mm2s_tlast

ad_connect xxv_ethernet_0/tx_axis_tready_0 hw_master_top_1/mrmac_tx_tready
ad_connect xxv_ethernet_0/tx_axis_tready_0 util_vector_logic_0/Op1
ad_connect hw_master_top_1/data_ready util_vector_logic_0/Op2
ad_connect util_vector_logic_0/Res axis_txd_fifo/m_axis_tready

ad_connect axis_txd_fifo/m_axis_tuser xxv_ethernet_0/tx_axis_tuser_0

ad_connect util_vector_logic_1/Res xxv_ethernet_0/tx_axis_tvalid_0
ad_connect axis_txd_fifo/m_axis_tvalid util_vector_logic_1/Op1
ad_connect axis_txd_fifo/m_axis_tvalid hw_master_top_1/s_axis_mm2s_tvalid
ad_connect hw_master_top_1/data_valid util_vector_logic_1/Op2

# PTP core
ad_connect ptp_1588_timer_syncer_0/ts_clk sys_250m_clk
ad_connect ptp_1588_timer_syncer_0/ts_rst sys_250m_reset

ad_connect xxv_ethernet_0/user_tx_reset_0 ptp_1588_timer_syncer_0/tx_phy_rst_0
ad_connect xxv_ethernet_0/user_rx_reset_0 ptp_1588_timer_syncer_0/rx_phy_rst_0

ad_connect xxv_ethernet_0/tx_clk_out_0 ptp_1588_timer_syncer_0/tx_phy_clk_0
ad_connect xxv_ethernet_0/rx_clk_out_0 ptp_1588_timer_syncer_0/rx_phy_clk_0

ad_connect xxv_ethernet_0/tx_period_ns_0 ptp_1588_timer_syncer_0/core_tx0_period_0
ad_connect xxv_ethernet_0/rx_period_ns_0 ptp_1588_timer_syncer_0/core_rx0_period_0

ad_connect ptp_1588_timer_syncer_0/tx_tod_ns_0 concat_tx_ns_s/In0
ad_connect ptp_1588_timer_syncer_0/tx_tod_sec_0 concat_tx_ns_s/In1
ad_connect concat_tx_ns_s/dout xxv_ethernet_0/ctl_tx_systemtimerin_0

ad_connect ptp_1588_timer_syncer_0/rx_tod_ns_0 concat_rx_ns_s/In0
ad_connect ptp_1588_timer_syncer_0/rx_tod_sec_0 concat_rx_ns_s/In1
ad_connect concat_rx_ns_s/dout xxv_ethernet_0/ctl_rx_systemtimerin_0
ad_connect ptp_1588_timer_syncer_0/sys_timer_1pps_out pps_out

# mcdma
ad_connect tdest_mapper_1/M_AXIS axi_mcdma_0/S_AXIS_S2MM
ad_connect tdest_mapper_1/m_axis_s2mm_tdest axi_mcdma_0/s_axis_s2mm_tdest
ad_connect tdest_mapper_1/m_axis_s2mm_tdata axi_mcdma_0/s_axis_s2mm_tdata
ad_connect tdest_mapper_1/m_axis_s2mm_tkeep axi_mcdma_0/s_axis_s2mm_tkeep

ad_connect tdest_mapper_1/m_axis_s2mm_tlast axi_mcdma_0/s_axis_s2mm_tlast
ad_connect tdest_mapper_1/m_axis_s2mm_tlast hw_master_top_1/s_axis_s2mm_tlast

ad_connect tdest_mapper_1/m_axis_s2mm_tready axi_mcdma_0/s_axis_s2mm_tready
ad_connect tdest_mapper_1/m_axis_s2mm_tready hw_master_top_1/m_axis_s2mm_tready

ad_connect tdest_mapper_1/m_axis_s2mm_tuser axi_mcdma_0/s_axis_s2mm_tuser

ad_connect tdest_mapper_1/m_axis_s2mm_tvalid axi_mcdma_0/s_axis_s2mm_tvalid
ad_connect tdest_mapper_1/m_axis_s2mm_tvalid hw_master_top_1/s_axis_s2mm_tvalid
#

ad_connect axi_mcdma_0/S_AXIS_STS hw_master_top_1/m_axis_sts
#ad_connect axi_mcdma_0/m_axi_sg_aclk axi_mcdma_0/s_axi_lite_aclk

for {set i 0} {$i < 16} {incr i} {
  ad_connect axi_mcdma_0/mm2s_ch[expr ($i+1)]_introut xlconcat_0/in$i
  ad_connect axi_mcdma_0/s2mm_ch[expr ($i+1)]_introut xlconcat_1/in$i
}

ad_connect xlconcat_0/dout util_reduced_logic_0/Op1
ad_connect xlconcat_1/dout util_reduced_logic_1/Op1

# rxd fifo
ad_connect axis_rxd_fifo/M_AXIS RX_PTP_TS_PREPEND_0/s_axis
#ad_connect axis_rxd_fifo/m_axis_tdata RX_PTP_TS_PREPEND_0/s_axis_tdata
#ad_connect axis_rxd_fifo/m_axis_tkeep RX_PTP_TS_PREPEND_0/s_axis_tkeep
#ad_connect axis_rxd_fifo/m_axis_tlast RX_PTP_TS_PREPEND_0/s_axis_tlast
#ad_connect axis_rxd_fifo/m_axis_tready RX_PTP_TS_PREPEND_0/s_axis_tready
#ad_connect axis_rxd_fifo/m_axis_tvalid RX_PTP_TS_PREPEND_0/s_axis_tvalid
ad_connect axis_rxd_fifo/prog_full RX_PTP_TS_PREPEND_0/fifo_full
ad_connect axis_rxd_fifo/s_axis_tready  RX_PTP_PKT_DETECT_on_0/s_axis_tready
ad_connect axis_rxd_fifo/s_axis_tready  RX_PTP_PKT_DETECT_on_0/s_axis_tready_fifo

# txd fifo
ad_connect axi_mcdma_0/M_AXIS_MM2S axis_txd_fifo/S_AXIS

# axis data fifo 0
ad_connect axi_mcdma_0/M_AXIS_CNTRL axis_data_fifo_0/S_AXIS
ad_connect axis_data_fifo_0/M_AXIS hw_master_top_1/s_axis_cntrl

# axis data fifo 1
ad_connect RX_PTP_TS_PREPEND_0/m_axis axis_data_fifo_1/S_AXIS
ad_connect axis_data_fifo_1/M_AXIS tdest_mapper_1/S_AXIS

# fifo gen 0
ad_connect xxv_ethernet_0/rx_ptp_tstamp_out_0 fifo_generator_0/din
ad_connect util_vector_logic_3/Res fifo_generator_0/wr_en
ad_connect fifo_generator_0/dout RX_PTP_TS_PREPEND_0/rx_timestamp_tod
ad_connect RX_PTP_TS_PREPEND_0/rd_en fifo_generator_0/rd_en

# fifo gen 1
ad_connect RX_PTP_PKT_DETECT_on_0/wr_data fifo_generator_1/din
ad_connect RX_PTP_PKT_DETECT_on_0/wr_en fifo_generator_1/wr_en
ad_connect fifo_generator_1/empty RX_PTP_TS_PREPEND_0/empty
ad_connect fifo_generator_1/dout RX_PTP_TS_PREPEND_0/rd_data
ad_connect RX_PTP_TS_PREPEND_0/rd_en fifo_generator_1/rd_en

# bram
ad_connect sys_cpu_clk axi_bram_ctrl_0/s_axi_aclk
ad_connect sys_cpu_resetn axi_bram_ctrl_0/s_axi_aresetn

#ad_connect sys_ps8/M_AXI_HPM0_FPD axi_bram_ctrl_0/S_AXI

# xilinx design uses interconnect
ad_connect sys_ps8/M_AXI_HPM0_FPD axi_mem_intercon/S00_AXI
ad_connect sys_cpu_clk axi_mem_intercon/ACLK
ad_connect sys_cpu_clk axi_mem_intercon/S00_ACLK
ad_connect sys_cpu_clk axi_mem_intercon/M00_ACLK
ad_connect sys_cpu_resetn axi_mem_intercon/ARESETN
ad_connect sys_cpu_resetn axi_mem_intercon/S00_ARESETN
ad_connect sys_cpu_resetn axi_mem_intercon/M00_ARESETN
ad_connect axi_mem_intercon/M00_AXI axi_bram_ctrl_0/S_AXI

ad_connect axi_bram_ctrl_0/BRAM_PORTA axi_bram_ctrl_0_bram/BRAM_PORTA
ad_connect axi_bram_ctrl_0/BRAM_PORTB axi_bram_ctrl_0_bram/BRAM_PORTB

# hw_master_top_1
ad_connect xxv_ethernet_0/tx_ptp_tstamp_out_0 hw_master_top_1/tx_timestamp_tod
ad_connect xxv_ethernet_0/tx_ptp_tstamp_valid_out_0 hw_master_top_1/tx_timestamp_tod_valid
ad_connect xxv_ethernet_0/tx_ptp_tstamp_tag_out_0 hw_master_top_1/tx_ptp_tstamp_tag_in
ad_connect hw_master_top_1/m00_axi axi_register_slice_0/S_AXI
ad_connect hw_master_top_1/tx_ptp_1588op_in xxv_ethernet_0/tx_ptp_1588op_in_0
ad_connect hw_master_top_1/tx_ptp_tstamp_tag_out xxv_ethernet_0/tx_ptp_tag_field_in_0

# tdest_mapper_1
ad_connect Enable_TDest/dout tdest_mapper_1/tdest_mapper_en
ad_connect Default_mcdma_chn/dout tdest_mapper_1/default_mcdma_ch

# RX_PTP_PKT_DETECT_on_0
#ad_connect Default_mcdma_chn/dout tdest_mapper_1/default_mcdma_ch


# axi ite interconnect

ad_cpu_interconnect 0x82100000 xxv_ethernet_0
ad_cpu_interconnect 0x82200000 axi_mcdma_0
ad_cpu_interconnect 0x82300000 ptp_1588_timer_syncer_0
ad_cpu_interconnect 0x82400000 axi_gpio_0_qpll_rst
#ad_cpu_interconnect 0x82500000 axi_pl_iic
ad_cpu_interconnect 0x82600000 axi_timer_1

ad_cpu_interrupt ps-0 mb-0 util_reduced_logic_0/Res
ad_cpu_interrupt ps-1 mb-1 util_reduced_logic_1/Res
ad_cpu_interrupt ps-2 mb-2 axi_timer_1/interrupt
ad_cpu_interrupt ps-3 mb-3 ptp_1588_timer_syncer_0/tod_intr
ad_cpu_interrupt ps-4 mb-4 hw_master_top_1/interrupt

# Xilinx design uses axi interconnect with NOT eth user_tx_reset_0 as reset signal
ad_mem_hp0_interconnect sys_cpu_clk sys_ps8/S_AXI_HP0
ad_mem_hp0_interconnect xxv_ethernet_0/tx_clk_out_0 axi_register_slice_0/M_AXI
ad_mem_hp0_interconnect sys_cpu_clk axi_mcdma_0/M_AXI_SG
ad_mem_hp0_interconnect xxv_ethernet_0/tx_clk_out_0 axi_mcdma_0/M_AXI_MM2S
ad_mem_hp0_interconnect xxv_ethernet_0/tx_clk_out_0 axi_mcdma_0/M_AXI_S2MM

#
assign_bd_address -target_address_space /sys_ps8/Data [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force

exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_LPS_OCM]
exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_MM2S] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_LPS_OCM]
exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_S2MM] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_LPS_OCM]

assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces hw_master_top_1/m00_axi] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_LPS_OCM] -force
