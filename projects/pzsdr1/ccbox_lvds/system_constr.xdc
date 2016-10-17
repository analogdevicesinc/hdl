
# pzsr1 (rev.b) + ccbox (rev.a)
# rf-gpio

set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD  LVCMOS25} [get_ports  gpio_rf[0]]       ; ## JX4.22   IO_L2N_T0_34
set_property  -dict {PACKAGE_PIN  U13   IOSTANDARD  LVCMOS25} [get_ports  gpio_rf[1]]       ; ## JX4.25   IO_L3P_T0_DQS_PUDC_B_34
set_property  -dict {PACKAGE_PIN  T15   IOSTANDARD  LVCMOS25} [get_ports  gpio_rf[2]]       ; ## JX4.33   IO_L5N_T0_34
set_property  -dict {PACKAGE_PIN  R14   IOSTANDARD  LVCMOS25} [get_ports  gpio_rf[3]]       ; ## JX4.34   IO_L6N_T0_VREF_34
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD  LVCMOS25} [get_ports  gpio_rf[4]]       ; ## JX4.35   IO_L7P_T1_34
set_property  -dict {PACKAGE_PIN  W14   IOSTANDARD  LVCMOS25} [get_ports  gpio_rf[5]]       ; ## JX4.36   IO_L8P_T1_34

# push-button

set_property  -dict {PACKAGE_PIN  P14   IOSTANDARD  LVCMOS25} [get_ports  ltc2955_kill_n]   ; ## JX4.32   IO_L6P_T0_34
set_property  -dict {PACKAGE_PIN  T14   IOSTANDARD  LVCMOS25} [get_ports  ltc2955_int_n]    ; ## JX4.31   IO_L5P_T0_34

# oled

set_property  -dict {PACKAGE_PIN  V5    IOSTANDARD  LVCMOS25} [get_ports  oled_cs_n]        ; ## JX2.18   IO_L6N_T0_VREF_13
set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD  LVCMOS25} [get_ports  oled_scl]         ; ## JX2.37   IO_L11N_T1_SRCC_13
set_property  -dict {PACKAGE_PIN  T9    IOSTANDARD  LVCMOS25} [get_ports  oled_sdi]         ; ## JX2.36   IO_L12P_T1_MRCC_13
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD  LVCMOS25} [get_ports  oled_d_c]         ; ## JX2.38   IO_L12N_T1_MRCC_13
set_property  -dict {PACKAGE_PIN  U7    IOSTANDARD  LVCMOS25} [get_ports  oled_res          ; ## JX2.35   IO_L11P_T1_SRCC_13

# adp5061

set_property  -dict {PACKAGE_PIN  T11   IOSTANDARD  LVCMOS25} [get_ports  adp5061_io1]      ; ## JX4.19   IO_L1P_T0_34
set_property  -dict {PACKAGE_PIN  T10   IOSTANDARD  LVCMOS25} [get_ports  adp5061_io2]      ; ## JX4.21   IO_L1N_T0_34
set_property  -dict {PACKAGE_PIN  T12   IOSTANDARD  LVCMOS25} [get_ports  adp5061_io3]      ; ## JX4.20   IO_L2P_T0_34

# GPS

set_property  -dict {PACKAGE_PIN  U5    IOSTANDARD  LVCMOS25} [get_ports  gps_reset]        ; ## JX2,63   IO_L19N_T3_VREF_13
set_property  -dict {PACKAGE_PIN  Y12   IOSTANDARD  LVCMOS25} [get_ports  gps_force_on]     ; ## JX2,62   IO_L20P_T3_13
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD  LVCMOS25} [get_ports  gps_standby]      ; ## JX2,64   IO_L20N_T3_13
set_property  -dict {PACKAGE_PIN  T5    IOSTANDARD  LVCMOS25} [get_ports  gps_pps]          ; ## JX2,61   IO_L19P_T3_13

# imu

set_property  -dict {PACKAGE_PIN  W8    IOSTANDARD  LVCMOS25} [get_ports  imu_rst_n]        ; ## JX2,49   IO_L15N_T2_DQS_13
set_property  -dict {PACKAGE_PIN  W10   IOSTANDARD  LVCMOS25} [get_ports  imu_cs_n]         ; ## JX2,48   IO_L16P_T2_13
set_property  -dict {PACKAGE_PIN  W9    IOSTANDARD  LVCMOS25} [get_ports  imu_sclk]         ; ## JX2,50   IO_L16N_T2_13
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD  LVCMOS25} [get_ports  imu_din]          ; ## JX2,53   IO_L17P_T2_13
set_property  -dict {PACKAGE_PIN  Y11   IOSTANDARD  LVCMOS25} [get_ports  imu_dout]         ; ## JX2,56   IO_L18N_T2_13
set_property  -dict {PACKAGE_PIN  U8    IOSTANDARD  LVCMOS25} [get_ports  imu_dr]           ; ## JX2,55   IO_L17N_T2_13
set_property  -dict {PACKAGE_PIN  W11   IOSTANDARD  LVCMOS25} [get_ports  imu_sync]         ; ## JX2,54   IO_L18P_T2_13

# audio

set_property  -dict {PACKAGE_PIN  Y6    IOSTANDARD  LVCMOS25} [get_ports  i2s_bclk]         ; ## JX2,43   IO_L13N_T2_MRCC_13
set_property  -dict {PACKAGE_PIN  Y9    IOSTANDARD  LVCMOS25} [get_ports  i2s_lrclk]        ; ## JX2,42   IO_L14P_T2_SRCC_13
set_property  -dict {PACKAGE_PIN  Y7    IOSTANDARD  LVCMOS25} [get_ports  i2s_mclk]         ; ## JX2,41   IO_L13P_T2_MRCC_13
set_property  -dict {PACKAGE_PIN  Y8    IOSTANDARD  LVCMOS25} [get_ports  i2s_sdata_in]     ; ## JX2,44   IO_L14N_T2_SRCC_13
set_property  -dict {PACKAGE_PIN  V8    IOSTANDARD  LVCMOS25} [get_ports  i2s_sdata_out]    ; ## JX2,47   IO_L15P_T2_DQS_13

set_property  -dict {PACKAGE_PIN  U17   IOSTANDARD  LVCMOS25} [get_ports  mic_present_n]    ; ## JX4,43   IO_L9N_T1_DQS_34
set_property  -dict {PACKAGE_PIN  Y17   IOSTANDARD  LVCMOS25} [get_ports  ts3a227_int_n]    ; ## JX4,37   IO_L7N_T1_34

# switch-led

set_property  -dict {PACKAGE_PIN  Y14   IOSTANDARD  LVCMOS25} [get_ports  switch_led_r]     ; ## JX4,38   IO_L8N_T1_34
set_property  -dict {PACKAGE_PIN  T16   IOSTANDARD  LVCMOS25} [get_ports  switch_led_g]     ; ## JX4,41   IO_L9P_T1_DQS_34
set_property  -dict {PACKAGE_PIN  V15   IOSTANDARD  LVCMOS25} [get_ports  switch_led_b]     ; ## JX4,42   IO_L10P_T1_34

# power source

set_property  -dict {PACKAGE_PIN  V13   IOSTANDARD  LVCMOS25} [get_ports  pss_valid1_n]     ; ## JX4,27   IO_L3N_T0_DQS_34
set_property  -dict {PACKAGE_PIN  V12   IOSTANDARD  LVCMOS25} [get_ports  pss_valid2_n]     ; ## JX4,26   IO_L4P_T0_34
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD  LVCMOS25} [get_ports  pss_valid3_n]     ; ## JX4,28   IO_L4N_T0_34


