
## constraints
## rf-gpio

set_property  -dict {PACKAGE_PIN  G5    IOSTANDARD LVCMOS18} [get_ports gpio_rf0]                      ; ## U1,G5,IO_L02_34_JX4_N,JX4,22,RF_GPIO0_BANK34
set_property  -dict {PACKAGE_PIN  H9    IOSTANDARD LVCMOS18} [get_ports gpio_rf1]                      ; ## U1,H9,IO_L03_34_JX4_P,JX4,25,RF_GPIO1_BANK34
set_property  -dict {PACKAGE_PIN  J9    IOSTANDARD LVCMOS18} [get_ports gpio_rf2]                      ; ## U1,J9,IO_L05_34_JX4_N,JX4,33,RF_GPIO2_BANK34
set_property  -dict {PACKAGE_PIN  H8    IOSTANDARD LVCMOS18} [get_ports gpio_rf3]                      ; ## U1,H8,IO_L06_34_JX4_N,JX4,34,RF_GPIO3_BANK34
set_property  -dict {PACKAGE_PIN  F5    IOSTANDARD LVCMOS18} [get_ports gpio_rf4]                      ; ## U1,F5,IO_L07_34_JX4_P,JX4,35,RF_GPIO4_BANK34
set_property  -dict {PACKAGE_PIN  D9    IOSTANDARD LVCMOS18} [get_ports gpio_rf5]                      ; ## U1,D9,IO_L08_34_JX4_P,JX4,36,RF_GPIO5_BANK34

## push-button

set_property  -dict {PACKAGE_PIN  J8    IOSTANDARD  LVCMOS18} [get_ports  ltc2955_kill_n]              ; ## U1,J8,IO_L06_34_JX4_P,JX4,32,SOM2C_KILL_N
set_property  -dict {PACKAGE_PIN  J10   IOSTANDARD  LVCMOS18} [get_ports  ltc2955_int_n]               ; ## U1,J10,IO_L05_34_JX4_P,JX4,31,C2SOM_KILL_N

## oled

set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD  LVCMOS25} [get_ports  oled_csn]                    ; ## U1,AA24,IO_L06_13_JX2_P,JX2,18,OLED_CS#
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD  LVCMOS25} [get_ports  oled_clk]                    ; ## U1,AD24,IO_L11_SRCC_13_JX2_N,JX2,37,OLED_SCL
set_property  -dict {PACKAGE_PIN  AC23  IOSTANDARD  LVCMOS25} [get_ports  oled_mosi]                   ; ## U1,AC23,IO_L12_MRCC_13_JX2_P,JX2,36,OLED_SDI
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD  LVCMOS25} [get_ports  oled_rst]                    ; ## U1,AD23,IO_L11_SRCC_13_JX2_P,JX2,35,OLED_/RES
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD  LVCMOS25} [get_ports  oled_dc]                     ; ## U1,AC24,IO_L12_MRCC_13_JX2_N,JX2,38,OLED_D/C

## adp5061

set_property  -dict {PACKAGE_PIN  J11   IOSTANDARD  LVCMOS18} [get_ports  adp5061_io[0]]               ; ## U1,J11,IO_L01_34_JX4_P,JX4,19,ADP5061_IO1
set_property  -dict {PACKAGE_PIN  H11   IOSTANDARD  LVCMOS18} [get_ports  adp5061_io[1]]               ; ## U1,H11,IO_L01_34_JX4_N,JX4,21,ADP5061_IO2
set_property  -dict {PACKAGE_PIN  G6    IOSTANDARD  LVCMOS18} [get_ports  adp5061_io[2]]               ; ## U1,G6,IO_L02_34_JX4_P,JX4,20,ADP5061_IO3

## GPS (DATA-UART)
## U1,D23,PS_MIO14_500_JX4,JX4,93,GPS_TXD1_1V8
## U1,C24,PS_MIO15_500_JX4,JX4,85,GPS_RXD1_1V8

set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD  LVCMOS25} [get_ports  gps_reset]                   ; ## U1,Y20,IO_L19_13_JX2_N,JX2,63,GPS_RESET
set_property  -dict {PACKAGE_PIN  AA20  IOSTANDARD  LVCMOS25} [get_ports  gps_force_on]                ; ## U1,AA20,IO_L20_13_JX2_P,JX2,62,GPS_FORCE_ON
set_property  -dict {PACKAGE_PIN  AB20  IOSTANDARD  LVCMOS25} [get_ports  gps_standby]                 ; ## U1,AB20,IO_L20_13_JX2_N,JX2,64,GPS_STANDBY
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD  LVCMOS25} [get_ports  gps_pps]                     ; ## U1,W20,IO_L19_13_JX2_P,JX2,61,GPS_PPS

## imu

set_property  -dict {PACKAGE_PIN  AE20  IOSTANDARD  LVCMOS25} [get_ports  imu_csn]                     ; ## U1,AE20,IO_L16_13_JX2_P,JX2,48,IMU_CS_N
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD  LVCMOS25} [get_ports  imu_clk]                     ; ## U1,AE21,IO_L16_13_JX2_N,JX2,50,IMU_SCLK
set_property  -dict {PACKAGE_PIN  AD18  IOSTANDARD  LVCMOS25} [get_ports  imu_mosi]                    ; ## U1,AD18,IO_L17_13_JX2_P,JX2,53,IMU_DIN
set_property  -dict {PACKAGE_PIN  AF18  IOSTANDARD  LVCMOS25} [get_ports  imu_miso]                    ; ## U1,AF18,IO_L18_13_JX2_N,JX2,56,IMU_DOUT
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD  LVCMOS25} [get_ports  imu_rstn]                    ; ## U1,AF20,IO_L15_13_JX2_N,JX2,49,IMU_RST_N
set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD  LVCMOS25} [get_ports  imu_sync]                    ; ## U1,AE18,IO_L18_13_JX2_P,JX2,54,IMU_SYNC
set_property  -dict {PACKAGE_PIN  AD19  IOSTANDARD  LVCMOS25} [get_ports  imu_ready]                   ; ## U1,AD19,IO_L17_13_JX2_N,JX2,55,IMU_DR

## audio

set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD  LVCMOS25} [get_ports  i2s_bclk]                    ; ## U1,AD21,IO_L13_MRCC_13_JX2_N,JX2,43,AUD_BCLK
set_property  -dict {PACKAGE_PIN  AC21  IOSTANDARD  LVCMOS25} [get_ports  i2s_lrclk]                   ; ## U1,AC21,IO_L14_SRCC_13_JX2_P,JX2,42,AUD_LRCLK
set_property  -dict {PACKAGE_PIN  AD20  IOSTANDARD  LVCMOS25} [get_ports  i2s_mclk]                    ; ## U1,AD20,IO_L13_MRCC_13_JX2_P,JX2,41,AUD_MCLK
set_property  -dict {PACKAGE_PIN  AC22  IOSTANDARD  LVCMOS25} [get_ports  i2s_sdata_in]                ; ## U1,AC22,IO_L14_SRCC_13_JX2_N,JX2,44,AUD_SDATA_IN
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD  LVCMOS25} [get_ports  i2s_sdata_out]               ; ## U1,AF19,IO_L15_13_JX2_P,JX2,47,AUD_SDATA_OUT

set_property  -dict {PACKAGE_PIN  E8    IOSTANDARD  LVCMOS18} [get_ports  mic_present_n]               ; ## U1,E8,IO_L09_34_JX4_N,JX4,43,MIC_PRESENT_N_1V8
set_property  -dict {PACKAGE_PIN  E5    IOSTANDARD  LVCMOS18} [get_ports  ts3a227_int_n]               ; ## U1,E5,IO_L07_34_JX4_N,JX4,37,TS3A227_INT_N

## switch-led

set_property  -dict {PACKAGE_PIN  D8    IOSTANDARD  LVCMOS18} [get_ports  switch_led_r]                ; ## U1,D8,IO_L08_34_JX4_N,JX4,38,SWITCH_LED_R
set_property  -dict {PACKAGE_PIN  F9    IOSTANDARD  LVCMOS18} [get_ports  switch_led_g]                ; ## U1,F9,IO_L09_34_JX4_P,JX4,41,SWITCH_LED_G
set_property  -dict {PACKAGE_PIN  E6    IOSTANDARD  LVCMOS18} [get_ports  switch_led_b]                ; ## U1,E6,IO_L10_34_JX4_P,JX4,42,SWITCH_LED_B

## power source

set_property  -dict {PACKAGE_PIN  G9    IOSTANDARD  LVCMOS18} [get_ports  pss_valid_n[0]]              ; ## U1,G9,IO_L03_34_JX4_N,JX4,27,PSS_VALID1_N
set_property  -dict {PACKAGE_PIN  H7    IOSTANDARD  LVCMOS18} [get_ports  pss_valid_n[1]]              ; ## U1,H7,IO_L04_34_JX4_P,JX4,26,PSS_VALID2_N
set_property  -dict {PACKAGE_PIN  H6    IOSTANDARD  LVCMOS18} [get_ports  pss_valid_n[2]]              ; ## U1,H6,IO_L04_34_JX4_N,JX4,28,PSS_VALID3_N

## tsw

set_property  -dict {PACKAGE_PIN  C9    IOSTANDARD  LVCMOS18} [get_ports  tsw_s1]                      ; ## U1,C9,IO_L15_34_JX4_P,JX4,57,P11,2,NAV_SWITCH_S1
set_property  -dict {PACKAGE_PIN  A10   IOSTANDARD  LVCMOS18} [get_ports  tsw_s2]                      ; ## U1,A10,IO_L16_34_JX4_N,JX4,60,P11,4,NAV_SWITCH_S2
set_property  -dict {PACKAGE_PIN  A9    IOSTANDARD  LVCMOS18} [get_ports  tsw_s3]                      ; ## U1,A9,IO_L17_34_JX4_P,JX4,67,P11,6,NAV_SWITCH_S3
set_property  -dict {PACKAGE_PIN  B7    IOSTANDARD  LVCMOS18} [get_ports  tsw_s4]                      ; ## U1,B7,IO_L18_34_JX4_P,JX4,68,P11,8,NAV_SWITCH_S4
set_property  -dict {PACKAGE_PIN  A8    IOSTANDARD  LVCMOS18} [get_ports  tsw_s5]                      ; ## U1,A8,IO_L17_34_JX4_N,JX4,69,P11,10,NAV_SWITCH_S5
set_property  -dict {PACKAGE_PIN  B10   IOSTANDARD  LVCMOS18} [get_ports  tsw_a]                       ; ## U1,B10,IO_L16_34_JX4_P,JX4,58,P11,1,NAV_SWITCH_A
set_property  -dict {PACKAGE_PIN  B9    IOSTANDARD  LVCMOS18} [get_ports  tsw_b]                       ; ## U1,B9,IO_L15_34_JX4_N,JX4,59,P11,3,NAV_SWITCH_B

## misc

set_property  -dict {PACKAGE_PIN  AC16  IOSTANDARD  LVCMOS25} [get_ports  otg_ctrl]                    ; ## U1,AC16,IO_L21_12_JX2_N,JX2,95,OTG_CTRL
set_property  -dict {PACKAGE_PIN  AC17  IOSTANDARD  LVCMOS25 PULLTYPE PULLDOWN} [get_ports adp1614_en] ; ## U1,AC17,IO_L21_12_JX2_P,JX2,93,ADP1614_EN
set_property  -dict {PACKAGE_PIN  D5    IOSTANDARD  LVCMOS18} [get_ports  rtc_int]                     ; ## U1,D5,IO_L10_34_JX4_N,JX4,44,TIMER_INT

