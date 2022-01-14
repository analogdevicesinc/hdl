# Create board design

### Create ports

# output / bit 0 from PS_0_emio_gpio_o
create_bd_port -dir O -from 0 -to 0 ap1302_rst_b
# output / constant 0
create_bd_port -dir O -from 0 -to 0 ap1302_standby
# output / constant 0
create_bd_port -dir O -from 0 -to 0 fan_en_b

# output / lrclk_out of audio_ss_0/I2S_Receiver (use to accept PCM data from external CODEC / Audio sample size of 16 or 24 bits)
create_bd_port -dir O lrclk_rx
# output / lrclk_out of audio_ss_0/I2S_Transmitter (use to output PCM data to external CODEC / Audio sample size of 16 or 24 bits)
create_bd_port -dir O lrclk_tx
# output / clock from clock_wiz_audio / 18.433 MHz
create_bd_port -dir O -type clk mclk_out_rx
# output / clock from clock_wiz_audio / 18.433 MHz
create_bd_port -dir O -type clk mclk_out_tx
# output / sclk_out of audio_ss_0/I2S_Receiver
create_bd_port -dir O sclk_rx
# output / sclk_out of audio_ss_0/I2S_Transmitter
create_bd_port -dir O sclk_tx

# input / sdata_0_in in I2S Receiver
create_bd_port -dir I sdata_rx
# output / sdata_0_out in I2S Transmitter
create_bd_port -dir O sdata_tx

###
create_bd_pin -dir I -from 91 -to 0 Din

### Instance ps8 , preset + set parameters
ad_ip_instance zynq_ultra_ps_e sys_ps8
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e \
  -config {apply_board_preset "1"} [get_bd_cells sys_ps8]

ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED 1
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO 92
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP0__DATA_WIDTH 32
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP1__DATA_WIDTH 32
ad_ip_parameter sys_ps8 CONFIG.PSU__NUM_FABRIC_RESETS 4
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP2 1 
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP1 1
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP3 1 
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP5 1
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP6 {1}

ad_ip_parameter sys_ps8 CONFIG.PSU__OVERRIDE__BASIC_CLOCK {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.242182}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {22}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__VIDEO {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.997009}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0}
  
ad_ip_parameter sys_ps8 CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18}
ad_ip_parameter sys_ps8 CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18}
ad_ip_parameter sys_ps8 CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18}

ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ 100
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL1_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 250
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL2_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ 500

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__IRQ0 {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__IRQ1 {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP2 {0}
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP0 {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP2 {1}
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__S_AXI_GP4 {1} 

### Add proc system reset IPs (check if need all of them)
ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_ip_instance proc_sys_reset sys_250m_rstgen
ad_ip_parameter sys_250m_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_ip_instance proc_sys_reset sys_500m_rstgen
ad_ip_parameter sys_500m_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_ip_instance proc_sys_reset proc_sys_reset_100MHz
ad_ip_instance proc_sys_reset proc_sys_reset_300MHz
ad_ip_instance proc_sys_reset proc_sys_reset_600MHz


### system reset/clk definition 
ad_connect sys_cpu_clk sys_ps8/pl_clk0
ad_connect sys_250m_clk sys_ps8/pl_clk1
ad_connect sys_500m_clk sys_ps8/pl_clk2
ad_connect sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect sys_250m_clk sys_250m_rstgen/slowest_sync_clk
ad_connect sys_500m_clk sys_500m_rstgen/slowest_sync_clk

ad_connect  sys_ps8/pl_resetn0 sys_rstgen/ext_reset_in
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_ps8/pl_resetn0 sys_250m_rstgen/ext_reset_in
ad_connect  sys_250m_clk sys_250m_rstgen/slowest_sync_clk
ad_connect  sys_ps8/pl_resetn0 sys_500m_rstgen/ext_reset_in
ad_connect  sys_500m_clk sys_500m_rstgen/slowest_sync_clk

ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_250m_reset sys_250m_rstgen/peripheral_reset
ad_connect  sys_500m_reset sys_500m_rstgen/peripheral_reset
### Create MIPI instance and set parameters
ad_ip_instance mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_0 
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DPHYRX_BOARD_INTERFACE {som240_1_connector_mipi_csi_isp}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CMN_NUM_PIXELS {2}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CMN_VC {0}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.CSI_BUF_DEPTH {4096}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.C_CSI_FILTER_USERDATATYPE {true}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.C_HS_LINE_RATE {896}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.C_HS_SETTLE_NS {146}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.DPY_LINE_RATE {896}
ad_ip_parameter mipi_csi2_rx_subsyst_0 CONFIG.SupportLevel {1}

### Create VCU instance and set parameters
ad_ip_instance vcu vcu_0
ad_ip_parameter vcu_0 CONFIG.DEC_COLOR_DEPTH {0}
ad_ip_parameter vcu_0 CONFIG.DEC_COLOR_FORMAT {0}
ad_ip_parameter vcu_0 CONFIG.DEC_FPS {1}
ad_ip_parameter vcu_0 CONFIG.ENABLE_DECODER {true}
ad_ip_parameter vcu_0 CONFIG.ENC_BUFFER_EN {true}
ad_ip_parameter vcu_0 CONFIG.ENC_BUFFER_MANUAL_OVERRIDE {1}
ad_ip_parameter vcu_0 CONFIG.ENC_BUFFER_SIZE {253}
ad_ip_parameter vcu_0 CONFIG.ENC_BUFFER_SIZE_ACTUAL {284}
ad_ip_parameter vcu_0 CONFIG.ENC_CODING_TYPE {1}
ad_ip_parameter vcu_0 CONFIG.ENC_COLOR_DEPTH {0}
ad_ip_parameter vcu_0 CONFIG.ENC_COLOR_FORMAT {0}
ad_ip_parameter vcu_0 CONFIG.ENC_FPS {1}
ad_ip_parameter vcu_0 CONFIG.ENC_MEM_URAM_USED {284}
ad_ip_parameter vcu_0 CONFIG.TABLE_NO {2}

ad_connect vcu_0/M_AXI_MCU axi_reg_slice_vmcu/S_AXI
ad_connect vcu_0/S_AXI_LITE axi_ic_ctrl_100/M01_AXI 

# Create VCU Encoder and VCU Decoder
ad_ip_instance axi_interconnect axi_ic_vcu_enc
ad_ip_parameter axi_ic_vcu_enc CONFIG.M00_HAS_REGSLICE {1}
ad_ip_parameter axi_ic_vcu_enc CONFIG.NUM_MI {1}
ad_ip_parameter axi_ic_vcu_enc CONFIG.NUM_MI {1}
ad_ip_parameter axi_ic_vcu_enc CONFIG.NUM_SI {2}
ad_ip_parameter axi_ic_vcu_enc CONFIG.S00_HAS_REGSLICE {1}
ad_ip_parameter axi_ic_vcu_enc CONFIG.S01_HAS_REGSLICE {1}

ad_connect axi_ic_vcu_enc/S00_AXI vcu_0/M_AXI_ENC0
ad_connect axi_ic_vcu_enc/S01_AXI vcu_0/M_AXI_ENC1 
ad_connect axi_ic_vcu_enc/M00_AXI sys_ps8/S_AXI_HPC0_FPD

ad_ip_instance axi_interconnect axi_ic_vcu_dec
ad_ip_parameter axi_ic_vcu_dec CONFIG.M00_HAS_REGSLICE {1}
ad_ip_parameter axi_ic_vcu_dec CONFIG.NUM_MI {1}
ad_ip_parameter axi_ic_vcu_dec CONFIG.NUM_SI {2}
ad_ip_parameter axi_ic_vcu_dec CONFIG.S00_HAS_REGSLICE {1}
ad_ip_parameter axi_ic_vcu_dec CONFIG.S01_HAS_REGSLICE {1}

ad_connect axi_ic_vcu_dec/S00_AXI vcu_0/M_AXI_DEC0 
ad_connect axi_ic_vcu_dec/S01_AXI vcu_0/M_AXI_DEC1 
ad_connect axi_ic_vcu_dec/M00_AXI sys_ps8/S_AXI_HP2_FPD

###

ad_ip_instance axi_register_slice axi_reg_slice_vmcu

###

ad_ip_instance xlslice xlslice_0
ad_ip_parameter xlslice_0 CONFIG.DIN_FROM {2}
ad_ip_parameter xlslice_0 CONFIG.DIN_TO {2}
ad_ip_parameter xlslice_0 CONFIG.DIN_WIDTH {92}
ad_ip_parameter xlslice_0 CONFIG.DOUT_WIDTH {1}

###

ad_ip_instance axi_interconnect axi_ic_audio_mcu
ad_ip_parameter axi_ic_audio_mcu CONFIG.M00_HAS_REGSLICE {1}
ad_ip_parameter axi_ic_audio_mcu CONFIG.NUM_MI {1}
ad_ip_parameter axi_ic_audio_mcu CONFIG.NUM_SI {3}
ad_ip_parameter axi_ic_audio_mcu CONFIG.S00_HAS_REGSLICE {1}
ad_ip_parameter axi_ic_audio_mcu CONFIG.S01_HAS_REGSLICE {1}
ad_ip_parameter axi_ic_audio_mcu CONFIG.S02_HAS_DATA_FIFO {0}
ad_ip_parameter axi_ic_audio_mcu CONFIG.S02_HAS_REGSLICE {1}

###
ad_ip_instance axi_interconnect axi_ic_ctrl_100
ad_ip_parameter axi_ic_ctrl_100 CONFIG.ENABLE_ADVANCED_OPTIONS {1}
ad_ip_parameter axi_ic_ctrl_100 CONFIG.NUM_MI {6}
ad_ip_parameter axi_ic_ctrl_100 CONFIG.S00_HAS_REGSLICE {1}

###
ad_ip_instance axi_interconnect axi_ic_ctrl_300
ad_ip_parameter axi_ic_ctrl_300 CONFIG.NUM_MI {1}

###

ad_ip_parameter axi_iic_0 CONFIG.IIC_FREQ_KHZ {400}
### create clock wizard instance

ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT1_JITTER {102.087}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT1_PHASE_ERROR {87.181}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT2_JITTER {115.833}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT2_PHASE_ERROR {87.181}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT2_USED {true}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT3_JITTER {94.863}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT3_PHASE_ERROR {87.181}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {300.000}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT3_USED {true}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT4_JITTER {132.685}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT4_PHASE_ERROR {87.181}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {50.000}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT4_USED {true}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT5_JITTER {83.769}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT5_PHASE_ERROR {87.181}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {600.000}
ad_ip_parameter clk_wiz_0 CONFIG.CLKOUT5_USED {true}
ad_ip_parameter clk_wiz_0 CONFIG.CLK_OUT1_PORT {clk_200M}
ad_ip_parameter clk_wiz_0 CONFIG.CLK_OUT2_PORT {clk_100M}
ad_ip_parameter clk_wiz_0 CONFIG.CLK_OUT3_PORT {clk_300M}
ad_ip_parameter clk_wiz_0 CONFIG.CLK_OUT4_PORT {clk_50M}
ad_ip_parameter clk_wiz_0 CONFIG.CLK_OUT5_PORT {clk_600M}
ad_ip_parameter clk_wiz_0 CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000}
ad_ip_parameter clk_wiz_0 CONFIG.MMCM_CLKOUT1_DIVIDE {12}
ad_ip_parameter clk_wiz_0 CONFIG.MMCM_CLKOUT2_DIVIDE {4}
ad_ip_parameter clk_wiz_0 CONFIG.MMCM_CLKOUT3_DIVIDE {24}
ad_ip_parameter clk_wiz_0 CONFIG.MMCM_CLKOUT4_DIVIDE {2}
ad_ip_parameter clk_wiz_0 CONFIG.MMCM_DIVCLK_DIVIDE {1}
ad_ip_parameter clk_wiz_0 CONFIG.NUM_OUT_CLKS {5}
ad_ip_parameter clk_wiz_0 CONFIG.PRIM_SOURCE {Global_buffer}
ad_ip_parameter clk_wiz_0 CONFIG.RESET_PORT {resetn}
ad_ip_parameter clk_win_0 CONFIG.RESET_TYPE {ACTIVE_LOW}

ad_ip_instance xlconcat xlconcat_0_0
ad_ip_parameter xlconcat_0_0 CONFIG.NUM_PORTS {8}

ad_ip_instance xlconstant xlconstant_0
ad_ip_parameter xlconstant_0  CONFIG.CONST_VAL {0} 

### connect async clk
ad_connect vcu_0/m_axi_dec_aclk vcu_0/m_axi_enc_aclk
ad_connect vcu_0/m_axi_mcu_aclk vcu_0/m_axi_dec_aclk
ad_connect vcu_0/m_axi_dec_aclk axi_ic_vcu_dec/ACLK 
ad_connect vcu_0/m_axi_dec_aclk axi_ic_vcu_dec/M00_ACLK
ad_connect vcu_0/m_axi_dec_aclk axi_ic_vcu_dec/S00_ACLK 
ad_connect vcu_0/m_axi_dec_aclk axi_ic_vcu_dec/S01_ACLK
ad_connect vcu_0/m_axi_dec_aclk axi_ic_vcu_enc/M00_ACLK
ad_connect vcu_0/m_axi_dec_aclk axi_ic_vcu_enc/S00_ACLK  
ad_connect vcu_0/m_axi_dec_aclk axi_ic_vcu_enc/S01_ACLK
ad_connect vcu_0/m_axi_dec_aclk axi_reg_slice_vmcu/aclk

### connect async reset 
ad_connect axi_ic_vcu_enc/ARESETN axi_ic_vcu_enc/S01_ARESETN
ad_connect axi_ic_vcu_enc/S00_ARESETN axi_ic_vcu_enc/ARESETN
ad_connect axi_ic_vcu_enc/M00_ARESETN axi_ic_vcu_enc/ARESETN
ad_connect axi_reg_slice_vmcu/aresetn axi_ic_vcu_enc/ARESETN
ad_connect axi_ic_vcu_dec/ARESETN axi_ic_vcu_enc/ARESETN
ad_connect axi_ic_vcu_dec/S00_ARESETN axi_ic_vcu_enc/ARESETN
ad_connect axi_ic_vcu_dec/M00_ARESETN axi_ic_vcu_enc/ARESETN
ad_connect axi_ic_vcu_dec/S01_ARESETN axi_ic_vcu_enc/ARESETN

ad_ip_instance axis_data_fifo axis_data_fifo_cap
ad_ip_parameter axis_data_fifo_cap CONFIG.FIFO_DEPTH {1024}

ad_ip_instance axis_subset_converter axis_subset_converter_0
ad_ip_parameter axis_subset_converter_0 CONFIG.M_TDATA_NUM_BYTES {6}
ad_ip_parameter axis_subset_converter_0 CONFIG.M_TDEST_WIDTH {1}
ad_ip_parameter axis_subset_converter_0 CONFIG.S_TDATA_NUM_BYTES {4}
ad_ip_parameter axis_subset_converter_0 CONFIG.S_TDEST_WIDTH {10}
ad_ip_parameter axis_subset_converter_0 CONFIG.TDATA_REMAP {16'b00000000,tdata[31:0]}
ad_ip_parameter axis_subset_converter_0 CONFIG.TDEST_REMAP {tdest[0:0]}

ad_ip_instance v_frmbuf_wr v_frmbuf_wr_0
ad_ip_parameter v_frmbuf_wr_0 CONFIG.AXIMM_DATA_WIDTH {128}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {128}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.HAS_Y_UV8_420 {1}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.HAS_BGR8 {0}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.HAS_BGRX8 {0}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.HAS_RGB8 {0}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.HAS_UYVY8 {0}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.HAS_YUV8 {0}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.HAS_Y_UV8 {0}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.MAX_COLS {3840}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.MAX_NR_PLANES {2}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.MAX_ROWS {2160}
ad_ip_parameter v_frmbuf_wr_0 CONFIG.SAMPLES_PER_CLOCK {2}

###
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if

###
ad_connect axi_reg_slice_vmcu/M_AXI axi_ic_audio_mcu/S00_AXI
ad_connect vcu_0/pll_ref_clk clk_wiz_0/clk_50M
ad_connect xlslice_0/Din sys_ps8/emio_gpio_o
ad_connect xlconcat_0_0/In2 vcu_0/vcu_host_interrupt
ad_connect vcu_0/vcu_resetn xlslice_0/Dout
ad_connect mipi_csi2_rx_subsyst_0/csirxss_s_axi axi_ic_ctrl_100/M00_AXI
ad_connect axi_ic_ctrl_300/M00_AXI v_frmbuf_wr_0/s_axi_CTRL
ad_connect axis_data_fifo_cap/M_AXIS axis_subset_converter_0/S_AXIS
ad_connect axis_subset_converter_0/M_AXIS v_frmbuf_wr_0/s_axis_video
ad_connect axis_data_fifo_cap/S_AXIS mipi_csi2_rx_subsyst_0/video_out
ad_connect mipi_phy_if mipi_csi2_rx_subsyst_0/mipi_phy_if
ad_connect sys_ps8/S_AXI_HP0_FPD v_frmbuf_wr_0/m_axi_mm_video
ad_connect clk_wiz_0/dphy_clk_200M mipi_csi2_rx_subsyst_0/dphy_clk_200M

ad_connect axis_subset_converter_0/aclk axis_data_fifo_cap/s_axis_aclk
ad_connect mipi_csi2_rx_subsyst_0/video_aclk axis_subset_converter_0/aclk
ad_connect v_frmbuf_wr_0/ap_clk axis_subset_converter_0/aclk
ad_connect mipi_csi2_rx_subsyst_0/csirxss_csi_irq xlconcat_0_0/In0
ad_connect xlconcat_0_0/In1 v_frmbuf_wr_0/interrupt
ad_connect xlslice_0/Dout v_frmbuf_wr_0/ap_rst_n


ad_ip_instance audio_formatter audio_formatter_0
ad_ip_instance axi_clock_converter axi_clock_converter_mm2s
ad_ip_instance axi_clock_converter axi_clock_converter_s2mm
ad_ip_instance clk_wiz clk_wiz_audio
ad_ip_parameter clk_wiz_audio CONFIG.AXI_DRP {false}
ad_ip_parameter clk_wiz_audio CONFIG.CLKIN1_JITTER_PS {100.0}
ad_ip_parameter clk_wiz_audio CONFIG.CLKOUT1_JITTER {296.069}
ad_ip_parameter clk_wiz_audio CONFIG.CLKOUT1_PHASE_ERROR {379.801}
ad_ip_parameter clk_wiz_audio CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {18.432}
ad_ip_parameter clk_wiz_audio CONFIG.CLKOUT2_JITTER {296.069}
ad_ip_parameter clk_wiz_audio CONFIG.CLKOUT2_PHASE_ERROR {379.801}
ad_ip_parameter clk_wiz_audio CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {18.432}
ad_ip_parameter clk_wiz_audio CONFIG.CLKOUT2_REQUESTED_PHASE {180.000}
ad_ip_parameter clk_wiz_audio CONFIG.CLKOUT2_USED {true}
ad_ip_parameter clk_wiz_audio CONFIG.MMCM_CLKFBOUT_MULT_F {80.000}
ad_ip_parameter clk_wiz_audio CONFIG.MMCM_CLKIN1_PERIOD {10.000}
ad_ip_parameter clk_wiz_audio CONFIG.MMCM_CLKOUT0_DIVIDE_F {62.000}
ad_ip_parameter clk_wiz_audio CONFIG.MMCM_CLKOUT1_DIVIDE {62}
ad_ip_parameter clk_wiz_audio CONFIG.MMCM_CLKOUT1_PHASE {180.000}
ad_ip_parameter clk_wiz_audio CONFIG.MMCM_DIVCLK_DIVIDE {7}
ad_ip_parameter clk_wiz_audio CONFIG.NUM_OUT_CLKS {2}
ad_ip_parameter clk_wiz_audio CONFIG.PHASE_DUTY_CONFIG {false}
ad_ip_parameter clk_wiz_audio CONFIG.PRIM_SOURCE {Global_buffer}
ad_ip_parameter clk_wiz_audio CONFIG.RESET_PORT {resetn}
ad_ip_parameter clk_wiz_audio CONFIG.RESET_TYPE {ACTIVE_LOW}
ad_ip_parameter clk_wiz_audio CONFIG.USE_DYN_RECONFIG {false}

ad_ip_instance i2s_receiver i2s_receiver_0
ad_ip_instance i2s_transmitter i2s_transmitter_0
ad_ip_instance oddr oddr_rx
ad_ip_instance oddr oddr_tx
ad_ip_instance proc_sys_reset proc_sys_reset_18MHz

ad_ip_instance axi_interconnect axi_ic_accel_ctrl
ad_ip_parameter axi_ic_accel_ctrl CONFIG.NUM_MI {1}
ad_ip_parameter axi_ic_accel_ctrl CONFIG.S00_HAS_REGSLICE {1}

ad_connect i2s_receiver_0/s_axi_ctrl axi_ic_ctrl_100/M03_AXI
ad_connect i2s_transmitter_0/s_axi_ctrl axi_ic_ctrl_100/M04_AXI
ad_connect audio_formatter_0/m_axi_mm2s axi_clock_converter_mm2s/S_AXI
ad_connect audio_formatter_0/m_axi_s2mm axi_clock_converter_s2mm/S_AXI
ad_connect audio_formatter_0/m_axis_mm2s i2s_transmitter_0/s_axis_aud
ad_connect axi_clock_converter_mm2s/M_AXI axi_ic_audio_mcu/S01_AXI
ad_connect axi_clock_converter_s2mm/M_AXI axi_ic_audio_mcu/S02_AXI
ad_connect audio_formatter_0/s_axis_s2mm i2s_receiver_0/m_axis_aud
ad_connect axi_ic_ctrl_100/M05_AXI audio_formatter_0/s_axi_lite
ad_connect audio_formatter_0/irq_mm2s xlconcat_0_0/In7
ad_connect clk_wiz_audio/clk_in1 sys_ps8/pl_clk1





ad_connect audio_formatter_0/m_axis_mm2s_aclk audio_formatter_0/aud_mclk
ad_connect axi_clock_converter_mm2s/s_axi_aclk audio_formatter_0/m_axis_mm2s_aclk
ad_connect clk_wiz_audio/clk_out1 audio_formatter_0/m_axis_mm2s_aclk
ad_connect i2s_transmitter_0/s_axis_aud_aclk i2s_transmitter_0/aud_mclk
ad_connect i2s_receiver_0/aud_mclk i2s_transmitter_0/s_axis_aud_aclk
ad_connect i2s_transmitter_0/aud_mclk clk_wiz_audio/clk_out1
ad_connect oddr_rx/clk_in clk_wiz_audio/clk_out1
ad_connect proc_sys_reset_18MHz/slowest_sync_clk clk_wiz_audio/clk_out1

ad_connect clk_wiz_audio/clk_out2 oddr_tx/clk_in
ad_connect audio_formatter_0/irq_s2mm xlconcat_0_0/In6
ad_connect i2s_receiver_0/irq xlconcat_0_0/In4
ad_connect lrclk_rx i2s_receiver_0/lrclk_out
ad_connect sclk_rx i2s_receiver_0/sclk_out
ad_connect i2s_transmitter_0/irq xlconcat_0_0/In5
ad_connect lrclk_tx i2s_transmitter_0/lrclk_out
ad_connect sclk_tx i2s_transmitter_0/sclk_out
ad_connect sdata_tx i2s_transmitter_0/sdata_0_out
ad_connect axi_clock_converter_s2mm/m_axi_aclk axi_clock_converter_mm2s/m_axi_aclk
ad_connect sys_ps8/maxihpm0_fpd_aclk vcu_0/m_axi_dec_aclk
ad_connect axi_clock_converter_mm2s/m_axi_aclk sys_ps8/maxihpm0_fpd_aclk
ad_connect axi_clock_converter_s2mm/m_axi_aresetn axi_clock_converter_mm2s/m_axi_aresetn
ad_connect axi_ic_ctrl_300/M00_ARESETN axi_ic_ctrl_300/S00_ARESETN



ad_connect ap1302_standby xlconstant_0/dout
ad_connect fan_en_b xlconstant_0/dout
ad_connect_bd_net ap1302_rst_b xlslice_0/Dout
ad_connect_bd_net mclk_out_rx oddr_rx/clk_out
ad_connect_bd_net mclk_out_tx oddr_tx/clk_out


ad_connect axi_ic_vcu_enc/ACLK vcu_0/m_axi_dec_aclk
ad_connect audio_formatter_0/s_axi_lite_aclk audio_formatter_0/s_axis_s2mm_aclk
ad_connect axi_clock_converter_s2mm/s_axi_aclk audio_formatter_0/s_axi_lite_aclk
ad_connect i2s_receiver_0/m_axis_aud_aclk i2s_receiver_0/s_axi_ctrl_aclk
ad_connect i2s_receiver_0/s_axi_ctrl_aclk audio_formatter_0/s_axi_lite_aclk
ad_connect i2s_transmitter_0/s_axi_ctrl_aclk audio_formatter_0/s_axis_s2mm_aclk
ad_connect audio_formatter_0/s_axi_lite_aresetn audio_formatter_0/s_axis_s2mm_aresetn
ad_connect axi_clock_converter_s2mm/s_axi_aresetn audio_formatter_0/s_axi_lite_aresetn
ad_connect i2s_receiver_0/m_axis_aud_aresetn i2s_receiver_0/s_axi_ctrl_aresetn
ad_connect i2s_transmitter_0/s_axi_ctrl_aresetn i2s_receiver_0/m_axis_aud_aresetn
ad_connect audio_formatter_0/s_axis_s2mm_aresetn i2s_receiver_0/m_axis_aud_aresetn

ad_connect audio_formatter_0/m_axis_mm2s_aresetn axi_clock_converter_mm2s/s_axi_aresetn
ad_connect axi_clock_converter_mm2s/s_axi_aresetn i2s_transmitter_0/s_axis_aud_aresetn
ad_connect i2s_transmitter_0/s_axis_aud_aresetn proc_sys_reset_18MHz/peripheral_aresetn
ad_connect audio_formatter_0/aud_mreset i2s_receiver_0/aud_mrst
ad_connect i2s_transmitter_0/aud_mrst audio_formatter_0/aud_mreset
ad_connect i2s_transmitter_0/aud_mrst  proc_sys_reset_18MHz/peripheral_reset
ad_connect sdata_rx i2s_receiver_0/sdata_0_in


ad_connect sys_ps8/M_AXI_HPM0_FPD axi_ic_accel_ctrl/S00_AXI]
ad_connect axi_ic_ctrl_300/S00_AXI] [get_bd_intf_pins sys_ps8/M_AXI_HPM1_FPD]
ad_connect axi_iic_0/S_AXI] -boundary_type upper [get_bd_intf_pins axi_ic_ctrl_100/M02_AXI]
ad_connect axi_ic_ctrl_100/M00_ARESETN] [get_bd_pins axi_ic_ctrl_100/M01_ARESETN] -boundary_type upper
ad_connect axi_ic_ctrl_100/M04_ARESETN] [get_bd_pins axi_ic_ctrl_100/M03_ARESETN] -boundary_type upper
ad_connect axi_ic_ctrl_100/M01_ARESETN] [get_bd_pins axi_ic_ctrl_100/M03_ARESETN] -boundary_type upper
ad_connect axi_iic_0/s_axi_aresetn] [get_bd_pins axi_ic_ctrl_100/M00_ARESETN]
ad_connect clk_wiz_0/clk_in1] [get_bd_pins sys_ps8/pl_clk0]
ad_connect clk_wiz_0/resetn] [get_bd_pins sys_ps8/pl_resetn0]
ad_connect axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0_0/In3]
ad_connect sys_ps8/maxihpm1_fpd_aclk] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect sys_ps8/saxihp0_fpd_aclk] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect sys_ps8/saxihp2_fpd_aclk] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect sys_ps8/saxihpc0_fpd_aclk] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_accel_ctrl/ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_accel_ctrl/S00_ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_accel_ctrl/M00_ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_audio_mcu/ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_audio_mcu/S00_ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_audio_mcu/M00_ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_audio_mcu/S01_ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_audio_mcu/S02_ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_ctrl_300/ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_ctrl_300/M00_ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect axi_ic_ctrl_300/S00_ACLK] [get_bd_pins axi_clock_converter_s2mm/m_axi_aclk]
ad_connect clk_wiz_0/clk_300M] [get_bd_pins axi_ic_ctrl_300/S00_ACLK]
ad_connect v_frmbuf_wr_0/ap_clk] [get_bd_pins clk_wiz_0/clk_300M]
ad_connect axi_ic_vcu_enc/S01_ACLK] [get_bd_pins clk_wiz_0/clk_300M]
ad_connect clk_wiz_audio/resetn] [get_bd_pins proc_sys_reset_18MHz/ext_reset_in]
ad_connect axi_ic_audio_mcu/ARESETN] [get_bd_pins axi_ic_accel_ctrl/ARESETN] -boundary_type upper
ad_connect axi_ic_ctrl_300/ARESETN] [get_bd_pins axi_ic_accel_ctrl/ARESETN] -boundary_type upper
ad_connect axi_ic_accel_ctrl/M00_ARESETN] [get_bd_pins axi_ic_audio_mcu/M00_ARESETN] -boundary_type upper
ad_connect axi_ic_accel_ctrl/S00_ARESETN] [get_bd_pins axi_ic_audio_mcu/M00_ARESETN] -boundary_type upper
ad_connect axis_subset_converter_0/aresetn] [get_bd_pins axi_ic_audio_mcu/M00_ARESETN]
ad_connect xlconcat_0_0/dout] [get_bd_pins sys_ps8/pl_ps_irq1]
ad_connect vcu_0/s_axi_lite_aclk] [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk]
ad_connect mipi_csi2_rx_subsyst_0/lite_aclk] [get_bd_pins i2s_receiver_0/m_axis_aud_aclk]

ad_connect axi_ic_ctrl_100/ACLK axi_ic_ctrl_100/M00_ACLK
ad_connect axi_ic_ctrl_100/S00_ACLK axi_ic_ctrl_100/ACLK
ad_connect axi_ic_ctrl_100/M01_ACLK axi_ic_ctrl_100/ACLK
ad_connect axi_ic_ctrl_100/M02_ACLK axi_ic_ctrl_100/ACLK
ad_connect axi_ic_ctrl_100/M03_ACLK axi_ic_ctrl_100/ACLK
ad_connect axi_ic_ctrl_100/M04_ACLK axi_ic_ctrl_100/ACLK
ad_connect axi_ic_ctrl_100/M05_ACLK axi_ic_ctrl_100/ACLK


ad_connect sys_ps8/maxihpm0_lpd_aclk axi_ic_ctrl_100/ACLK
ad_connect sys_ps8/saxihpc1_fpd_aclk clk_wiz_0/clk_300M
ad_connect sys_ps8/saxihp1_fpd_aclk clk_wiz_0/clk_300M
ad_connect sys_ps8/saxihp3_fpd_aclk clk_wiz_0/clk_300M
ad_connect sys_ps8/saxi_lpd_aclk clk_wiz_0/clk_300M
ad_connect vcu_0/s_axi_lite_aclk axi_ic_ctrl_100/ACLK

ad_connect axi_ic_ctrl_100/M05_ARESETN axi_ic_ctrl_100/M00_ARESETN
ad_connect axi_ic_ctrl_100/M02_ARESETN axi_ic_ctrl_100/M00_ARESETN



ad_connect sys_ps8/pl_resetn0 clk_wiz_audio/resetn
ad_connect sys_250m_rstgen/ext_reset_in sys_ps8/pl_resetn0
ad_connect sys_500m_rstgen/ext_reset_in sys_ps8/pl_resetn0
ad_connect sys_rstgen/ext_reset_in sys_ps8/pl_resetn0
ad_connect proc_sys_reset_100MHz/ext_reset_in sys_ps8/pl_resetn0
ad_connect proc_sys_reset_600MHz/ext_reset_in sys_ps8/pl_resetn0
ad_connect proc_sys_reset_100MHz/slowest_sync_clk sys_ps8/maxihpm0_lpd_aclk
ad_connect proc_sys_reset_100MHz/interconnect_aresetn axi_ic_ctrl_100/ARESETN
ad_connect proc_sys_reset_100MHz/peripheral_aresetn axi_ic_ctrl_100/M00_ARESETN
ad_connect proc_sys_reset_300MHz/ext_reset_in sys_ps8/pl_resetn0
ad_connect proc_sys_reset_300MHz/slowest_sync_clk clk_wiz_0/clk_300M
ad_connect proc_sys_reset_300MHz/interconnect_aresetn axi_ic_audio_mcu/ARESETN
ad_connect proc_sys_reset_600MHz/slowest_sync_clk clk_wiz_0/clk_600M

ad_connect clk_wiz_0/clk_100M vcu_0/s_axi_lite_aclk
ad_connect axi_iic_0/s_axi_aclk clk_wiz_0/clk_100M
