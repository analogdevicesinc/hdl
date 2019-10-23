
## constraints
## rf-gpio

set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD LVCMOS25} [get_ports gpio_rf0]           ; ## U1,U12,IO_L02_34_JX4_N,JX4,22,RF_GPIO0_BANK34
set_property  -dict {PACKAGE_PIN  U13   IOSTANDARD LVCMOS25} [get_ports gpio_rf1]           ; ## U1,U13,IO_L03_34_JX4_P,JX4,25,RF_GPIO1_BANK34
set_property  -dict {PACKAGE_PIN  T15   IOSTANDARD LVCMOS25} [get_ports gpio_rf2]           ; ## U1,T15,IO_L05_34_JX4_N,JX4,33,RF_GPIO2_BANK34
set_property  -dict {PACKAGE_PIN  R14   IOSTANDARD LVCMOS25} [get_ports gpio_rf3]           ; ## U1,R14,IO_L06_34_JX4_N,JX4,34,RF_GPIO3_BANK34
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVCMOS25} [get_ports gpio_rf4]           ; ## U1,Y16,IO_L07_34_JX4_P,JX4,35,RF_GPIO4_BANK34
set_property  -dict {PACKAGE_PIN  W14   IOSTANDARD LVCMOS25} [get_ports gpio_rf5]           ; ## U1,W14,IO_L08_34_JX4_P,JX4,36,RF_GPIO5_BANK34

## push-button

set_property  -dict {PACKAGE_PIN  P14   IOSTANDARD  LVCMOS25} [get_ports  ltc2955_kill_n]   ; ## U1,P14,IO_L06_34_JX4_P,JX4,32,SOM2C_KILL_N
set_property  -dict {PACKAGE_PIN  T14   IOSTANDARD  LVCMOS25} [get_ports  ltc2955_int_n]    ; ## U1,T14,IO_L05_34_JX4_P,JX4,31,C2SOM_KILL_N

## oled

set_property  -dict {PACKAGE_PIN  V5    IOSTANDARD  LVCMOS25} [get_ports  oled_csn]         ; ## U1,V5,IO_L06_13_JX2_P,JX2,18,OLED_CS#
set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD  LVCMOS25} [get_ports  oled_clk]         ; ## U1,V7,IO_L11_SRCC_13_JX2_N,JX2,37,OLED_SCL
set_property  -dict {PACKAGE_PIN  T9    IOSTANDARD  LVCMOS25} [get_ports  oled_mosi]        ; ## U1,T9,IO_L12_MRCC_13_JX2_P,JX2,36,OLED_SDI
set_property  -dict {PACKAGE_PIN  U7    IOSTANDARD  LVCMOS25} [get_ports  oled_rst]         ; ## U1,U7,IO_L11_SRCC_13_JX2_P,JX2,35,OLED_/RES
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD  LVCMOS25} [get_ports  oled_dc]          ; ## U1,U10,IO_L12_MRCC_13_JX2_N,JX2,38,OLED_D/C

## adp5061

set_property  -dict {PACKAGE_PIN  T11   IOSTANDARD  LVCMOS25} [get_ports  adp5061_io[0]]    ; ## U1,T11,IO_L01_34_JX4_P,JX4,19,ADP5061_IO1
set_property  -dict {PACKAGE_PIN  T10   IOSTANDARD  LVCMOS25} [get_ports  adp5061_io[1]]    ; ## U1,T10,IO_L01_34_JX4_N,JX4,21,ADP5061_IO2
set_property  -dict {PACKAGE_PIN  T12   IOSTANDARD  LVCMOS25} [get_ports  adp5061_io[2]]    ; ## U1,T12,IO_L02_34_JX4_P,JX4,20,ADP5061_IO3

## GPS (DATA-UART)
## U1,C5,PS_MIO14_500_JX4,JX4,93,GPS_TXD1_1V8
## U1,C8,PS_MIO15_500_JX4,JX4,85,GPS_RXD1_1V8

set_property  -dict {PACKAGE_PIN  U5    IOSTANDARD  LVCMOS25} [get_ports  gps_reset]        ; ## U1,U5,IO_L19_13_JX2_N,JX2,63,GPS_RESET
set_property  -dict {PACKAGE_PIN  Y12   IOSTANDARD  LVCMOS25} [get_ports  gps_force_on]     ; ## U1,Y12,IO_L20_13_JX2_P,JX2,62,GPS_FORCE_ON
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD  LVCMOS25} [get_ports  gps_standby]      ; ## U1,Y13,IO_L20_13_JX2_N,JX2,64,GPS_STANDBY
set_property  -dict {PACKAGE_PIN  T5    IOSTANDARD  LVCMOS25} [get_ports  gps_pps]          ; ## U1,T5,IO_L19_13_JX2_P,JX2,61,GPS_PPS

## imu

set_property  -dict {PACKAGE_PIN  W10   IOSTANDARD  LVCMOS25} [get_ports  imu_csn]          ; ## U1,W10,IO_L16_13_JX2_P,JX2,48,IMU_CS_N
set_property  -dict {PACKAGE_PIN  W9    IOSTANDARD  LVCMOS25} [get_ports  imu_clk]          ; ## U1,W9,IO_L16_13_JX2_N,JX2,50,IMU_SCLK
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD  LVCMOS25} [get_ports  imu_mosi]         ; ## U1,U9,IO_L17_13_JX2_P,JX2,53,IMU_DIN
set_property  -dict {PACKAGE_PIN  Y11   IOSTANDARD  LVCMOS25} [get_ports  imu_miso]         ; ## U1,Y11,IO_L18_13_JX2_N,JX2,56,IMU_DOUT
set_property  -dict {PACKAGE_PIN  W8    IOSTANDARD  LVCMOS25} [get_ports  imu_rstn]         ; ## U1,W8,IO_L15_13_JX2_N,JX2,49,IMU_RST_N
set_property  -dict {PACKAGE_PIN  W11   IOSTANDARD  LVCMOS25} [get_ports  imu_sync]         ; ## U1,W11,IO_L18_13_JX2_P,JX2,54,IMU_SYNC
set_property  -dict {PACKAGE_PIN  U8    IOSTANDARD  LVCMOS25} [get_ports  imu_ready]        ; ## U1,U8,IO_L17_13_JX2_N,JX2,55,IMU_DR

## audio

set_property  -dict {PACKAGE_PIN  Y6    IOSTANDARD  LVCMOS25} [get_ports  i2s_bclk]         ; ## U1,Y6,IO_L13_MRCC_13_JX2_N,JX2,43,AUD_BCLK
set_property  -dict {PACKAGE_PIN  Y9    IOSTANDARD  LVCMOS25} [get_ports  i2s_lrclk]        ; ## U1,Y9,IO_L14_SRCC_13_JX2_P,JX2,42,AUD_LRCLK
set_property  -dict {PACKAGE_PIN  Y7    IOSTANDARD  LVCMOS25} [get_ports  i2s_mclk]         ; ## U1,Y7,IO_L13_MRCC_13_JX2_P,JX2,41,AUD_MCLK
set_property  -dict {PACKAGE_PIN  Y8    IOSTANDARD  LVCMOS25} [get_ports  i2s_sdata_in]     ; ## U1,Y8,IO_L14_SRCC_13_JX2_N,JX2,44,AUD_SDATA_IN
set_property  -dict {PACKAGE_PIN  V8    IOSTANDARD  LVCMOS25} [get_ports  i2s_sdata_out]    ; ## U1,V8,IO_L15_13_JX2_P,JX2,47,AUD_SDATA_OUT

set_property  -dict {PACKAGE_PIN  U17   IOSTANDARD  LVCMOS25} [get_ports  mic_present_n]    ; ## U1,U17,IO_L09_34_JX4_N,JX4,43,MIC_PRESENT_N_1V8
set_property  -dict {PACKAGE_PIN  Y17   IOSTANDARD  LVCMOS25} [get_ports  ts3a227_int_n]    ; ## U1,Y17,IO_L07_34_JX4_N,JX4,37,TS3A227_INT_N

## switch-led

set_property  -dict {PACKAGE_PIN  Y14   IOSTANDARD  LVCMOS25} [get_ports  switch_led_r]     ; ## U1,Y14,IO_L08_34_JX4_N,JX4,38,SWITCH_LED_R
set_property  -dict {PACKAGE_PIN  T16   IOSTANDARD  LVCMOS25} [get_ports  switch_led_g]     ; ## U1,T16,IO_L09_34_JX4_P,JX4,41,SWITCH_LED_G
set_property  -dict {PACKAGE_PIN  V15   IOSTANDARD  LVCMOS25} [get_ports  switch_led_b]     ; ## U1,V15,IO_L10_34_JX4_P,JX4,42,SWITCH_LED_B

## power source

set_property  -dict {PACKAGE_PIN  V13   IOSTANDARD  LVCMOS25} [get_ports  pss_valid_n[0]]   ; ## U1,V13,IO_L03_34_JX4_N,JX4,27,PSS_VALID1_N
set_property  -dict {PACKAGE_PIN  V12   IOSTANDARD  LVCMOS25} [get_ports  pss_valid_n[1]]   ; ## U1,V12,IO_L04_34_JX4_P,JX4,26,PSS_VALID2_N
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD  LVCMOS25} [get_ports  pss_valid_n[2]]   ; ## U1,W13,IO_L04_34_JX4_N,JX4,28,PSS_VALID3_N

## tsw

set_property  -dict {PACKAGE_PIN  T20   IOSTANDARD  LVCMOS25} [get_ports  tsw_s1]           ; ## U1,T20,IO_L15_34_JX4_P,JX4,57,P11,2,NAV_SWITCH_S1
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD  LVCMOS25} [get_ports  tsw_s2]           ; ## U1,W20,IO_L16_34_JX4_N,JX4,60,P11,4,NAV_SWITCH_S2
set_property  -dict {PACKAGE_PIN  Y18   IOSTANDARD  LVCMOS25} [get_ports  tsw_s3]           ; ## U1,Y18,IO_L17_34_JX4_P,JX4,67,P11,6,NAV_SWITCH_S3
set_property  -dict {PACKAGE_PIN  V16   IOSTANDARD  LVCMOS25} [get_ports  tsw_s4]           ; ## U1,V16,IO_L18_34_JX4_P,JX4,68,P11,8,NAV_SWITCH_S4
set_property  -dict {PACKAGE_PIN  Y19   IOSTANDARD  LVCMOS25} [get_ports  tsw_s5]           ; ## U1,Y19,IO_L17_34_JX4_N,JX4,69,P11,10,NAV_SWITCH_S5
set_property  -dict {PACKAGE_PIN  V20   IOSTANDARD  LVCMOS25} [get_ports  tsw_a]            ; ## U1,V20,IO_L16_34_JX4_P,JX4,58,P11,1,NAV_SWITCH_A
set_property  -dict {PACKAGE_PIN  U20   IOSTANDARD  LVCMOS25} [get_ports  tsw_b]            ; ## U1,U20,IO_L15_34_JX4_N,JX4,59,P11,3,NAV_SWITCH_B

## misc

set_property  -dict {PACKAGE_PIN  W15   IOSTANDARD  LVCMOS25} [get_ports  rtc_int]          ; ## U1,W15,IO_L10_34_JX4_N,JX4,44,TIMER_INT

