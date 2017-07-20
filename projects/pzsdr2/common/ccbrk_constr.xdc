
## constraints (ccbrk.c + ccbrk_lb.a)
## ad9361 clkout forward

set_property  -dict {PACKAGE_PIN  A7      IOSTANDARD  LVCMOS18} [get_ports  clkout_out]   ; ## (lb: gpio_bd[15])  U1,A7,IO_L18_34_JX4_N,JX4,70,IO_L18_34_JX4_N,P7,32

## push-buttons- led- dip-switches- loopbacks- (ps7 gpio)

set_property  -dict {PACKAGE_PIN  J3      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[0]]   ; ## (lb: gpio_bd[4])   U1,J3,IO_L12_MRCC_33_JX1_N,JX1,83,PB_GPIO_0,P4,31
set_property  -dict {PACKAGE_PIN  D8      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[1]]   ; ## (lb: gpio_bd[5])   U1,D8,IO_L08_34_JX4_N,JX4,38,PB_GPIO_1,P6,19
set_property  -dict {PACKAGE_PIN  F9      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[2]]   ; ## (lb: gpio_bd[6])   U1,F9,IO_L09_34_JX4_P,JX4,41,PB_GPIO_2,P6,26
set_property  -dict {PACKAGE_PIN  E8      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[3]]   ; ## (lb: gpio_bd[12])  U1,E8,IO_L09_34_JX4_N,JX4,43,PB_GPIO_3,P6,28
set_property  -dict {PACKAGE_PIN  A8      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[4]]   ; ## (lb: gpio_bd[0])   U1,A8,IO_L17_34_JX4_N,JX4,69,LED_GPIO_0,P7,16
set_property  -dict {PACKAGE_PIN  W14     IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[5]]   ; ## (lb: gpio_bd[1])   U1,W17,IO_25_12_JX4,JX4,16,LED_GPIO_2,P13,3
set_property  -dict {PACKAGE_PIN  W17     IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[6]]   ; ## (lb: gpio_bd[2])   U1,W14,IO_00_12_JX4,JX4,14,LED_GPIO_1,P13,4
set_property  -dict {PACKAGE_PIN  Y16     IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[7]]   ; ## (lb: i2c_scl)      U1,Y16,IO_L23_12_JX2_P,JX2,97,LED_GPIO_3,P2,4 (U1,AF24,SCL,JX2,17,I2C_SCL,P2,14)
set_property  -dict {PACKAGE_PIN  Y15     IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[8]]   ; ## (lb: none)         U1,Y15,IO_L23_12_JX2_N,JX2,99,DIP_GPIO_0
set_property  -dict {PACKAGE_PIN  W16     IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[9]]   ; ## (lb: none)         U1,W16,IO_L24_12_JX4_P,JX4,13,DIP_GPIO_1
set_property  -dict {PACKAGE_PIN  W15     IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[10]]  ; ## (lb: none)         U1,W15,IO_L24_12_JX4_N,JX4,15,DIP_GPIO_2
set_property  -dict {PACKAGE_PIN  V19     IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[11]]  ; ## (lb: none)         U1,V19,IO_00_13_JX2,JX2,13,DIP_GPIO_3

## orphans- io- (ps7 gpio)

set_property  -dict {PACKAGE_PIN  V18     IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[12]]  ; ## (lb: gpio_bd[3])   U1,V18,IO_25_13_JX2,JX2,14,IO_25_13_JX2,P2,3
set_property  -dict {PACKAGE_PIN  AB24    IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[13]]  ; ## (lb: i2c_sda)      U1,AB24,IO_L06_13_JX2_N,JX2,20,IO_L06_13_JX2_N,P2,15 (U1,AF25,SDA,JX2,19,I2C_SDA,P2,16)
set_property  -dict {PACKAGE_PIN  AA24    IOSTANDARD  LVCMOS25} [get_ports  gpio_bd[14]]  ; ## (lb: none)         U1,AA24,IO_L06_13_JX2_P,JX2,18,IO_L06_13_JX2_P
set_property  -dict {PACKAGE_PIN  N8      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[15]]  ; ## (lb: clkout_out)   U1,N8,IO_25_33_JX1,JX1,10,IO_25_33_JX1,P7,31

## ps7- fixed io- to- fpga regular io (ps7 gpio)

set_property  -dict {PACKAGE_PIN  K3      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[16]]  ; ## U1,K3,IO_L11_SRCC_33_JX1_N,JX1,76,IO_L11_SRCC_33_JX1_N,P4,32 (U1,E26,PS_MIO00_500_JX4,JX4,97,PS_MIO00_500_JX4,P5,21)
set_property  -dict {PACKAGE_PIN  A9      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[17]]  ; ## U1,A9,IO_L17_34_JX4_P,JX4,67,IO_L17_34_JX4_P,P6,9            (U1,B20,PS_MIO51_501_JX4,JX4,100,PS_MIO51_501_JX4,P6,11)
set_property  -dict {PACKAGE_PIN  E5      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[18]]  ; ## U1,E5,IO_L07_34_JX4_N,JX4,37,IO_L07_34_JX4_N,P6,20           (U1,C24,PS_MIO15_500_JX4,JX4,85,PS_MIO15_500_JX4,P6,21)
set_property  -dict {PACKAGE_PIN  E6      IOSTANDARD  LVCMOS18} [get_ports  gpio_bd[19]]  ; ## U1,E6,IO_L10_34_JX4_P,JX4,42,IO_L10_34_JX4_P,P6,25           (U1,A25,PS_MIO10_500_JX4,JX4,87,PS_MIO10_500_JX4,P6,23)

## ps7- fixed io- to- ps7- fixed io (reference only)
## U1,B19,PS_MIO47_501_JX4,JX4,94,PS_MIO47_501_JX4,P7,24 == U1,E17,PS_MIO46_501_JX4,JX4,92,PS_MIO46_501_JX4,P7,22

## ps7- fixed io- orphans (reference only)
## U1,B25,PS_MIO13_500_JX4,JX4,91,PS_MIO13_500_JX4,P5,9
## U1,D23,PS_MIO14_500_JX4,JX4,93,PS_MIO14_500_JX4,P5,11
## U1,B26,PS_MIO11_500_JX4,JX4,88,PS_MIO11_500_JX4,P7,12

## fpga- regular io

set_property  -dict {PACKAGE_PIN  AA25    IOSTANDARD  LVCMOS25} [get_ports  gp_out[0]]    ; ## U1,AA25,IO_L01_13_JX2_P,JX2,1,IO_L01_13_JX2_P,P2,6
set_property  -dict {PACKAGE_PIN  AB26    IOSTANDARD  LVCMOS25} [get_ports  gp_in[0]]     ; ## U1,AB26,IO_L02_13_JX2_P,JX2,2,IO_L02_13_JX2_P,P2,5
set_property  -dict {PACKAGE_PIN  AB25    IOSTANDARD  LVCMOS25} [get_ports  gp_out[1]]    ; ## U1,AB25,IO_L01_13_JX2_N,JX2,3,IO_L01_13_JX2_N,P2,8
set_property  -dict {PACKAGE_PIN  AC26    IOSTANDARD  LVCMOS25} [get_ports  gp_in[1]]     ; ## U1,AC26,IO_L02_13_JX2_N,JX2,4,IO_L02_13_JX2_N,P2,7
set_property  -dict {PACKAGE_PIN  AE25    IOSTANDARD  LVCMOS25} [get_ports  gp_out[2]]    ; ## U1,AE25,IO_L03_13_JX2_P,JX2,5,IO_L03_13_JX2_P,P2,10
set_property  -dict {PACKAGE_PIN  AD25    IOSTANDARD  LVCMOS25} [get_ports  gp_in[2]]     ; ## U1,AD25,IO_L04_13_JX2_P,JX2,6,IO_L04_13_JX2_P,P2,9
set_property  -dict {PACKAGE_PIN  AE26    IOSTANDARD  LVCMOS25} [get_ports  gp_out[3]]    ; ## U1,AE26,IO_L03_13_JX2_N,JX2,7,IO_L03_13_JX2_N,P2,12
set_property  -dict {PACKAGE_PIN  AD26    IOSTANDARD  LVCMOS25} [get_ports  gp_in[3]]     ; ## U1,AD26,IO_L04_13_JX2_N,JX2,8,IO_L04_13_JX2_N,P2,11
set_property  -dict {PACKAGE_PIN  AE22    IOSTANDARD  LVCMOS25} [get_ports  gp_out[4]]    ; ## U1,AE22,IO_L07_13_JX2_P,JX2,23,IO_L07_13_JX2_P,P2,20
set_property  -dict {PACKAGE_PIN  AE23    IOSTANDARD  LVCMOS25} [get_ports  gp_in[4]]     ; ## U1,AE23,IO_L08_13_JX2_P,JX2,24,IO_L08_13_JX2_P,P2,19
set_property  -dict {PACKAGE_PIN  AF22    IOSTANDARD  LVCMOS25} [get_ports  gp_out[5]]    ; ## U1,AF22,IO_L07_13_JX2_N,JX2,25,IO_L07_13_JX2_N,P2,22
set_property  -dict {PACKAGE_PIN  AF23    IOSTANDARD  LVCMOS25} [get_ports  gp_in[5]]     ; ## U1,AF23,IO_L08_13_JX2_N,JX2,26,IO_L08_13_JX2_N,P2,21
set_property  -dict {PACKAGE_PIN  AB21    IOSTANDARD  LVCMOS25} [get_ports  gp_out[6]]    ; ## U1,AB21,IO_L09_13_JX2_P,JX2,29,IO_L09_13_JX2_P,P2,24
set_property  -dict {PACKAGE_PIN  AA22    IOSTANDARD  LVCMOS25} [get_ports  gp_in[6]]     ; ## U1,AA22,IO_L10_13_JX2_P,JX2,30,IO_L10_13_JX2_P,P2,23
set_property  -dict {PACKAGE_PIN  AB22    IOSTANDARD  LVCMOS25} [get_ports  gp_out[7]]    ; ## U1,AB22,IO_L09_13_JX2_N,JX2,31,IO_L09_13_JX2_N,P2,26
set_property  -dict {PACKAGE_PIN  AA23    IOSTANDARD  LVCMOS25} [get_ports  gp_in[7]]     ; ## U1,AA23,IO_L10_13_JX2_N,JX2,32,IO_L10_13_JX2_N,P2,25
set_property  -dict {PACKAGE_PIN  AD23    IOSTANDARD  LVCMOS25} [get_ports  gp_out[8]]    ; ## U1,AD23,IO_L11_SRCC_13_JX2_P,JX2,35,IO_L11_SRCC_13_JX2_P,P2,28
set_property  -dict {PACKAGE_PIN  AC23    IOSTANDARD  LVCMOS25} [get_ports  gp_in[8]]     ; ## U1,AC23,IO_L12_MRCC_13_JX2_P,JX2,36,IO_L12_MRCC_13_JX2_P,P2,27
set_property  -dict {PACKAGE_PIN  AD24    IOSTANDARD  LVCMOS25} [get_ports  gp_out[9]]    ; ## U1,AD24,IO_L11_SRCC_13_JX2_N,JX2,37,IO_L11_SRCC_13_JX2_N,P2,30
set_property  -dict {PACKAGE_PIN  AC24    IOSTANDARD  LVCMOS25} [get_ports  gp_in[9]]     ; ## U1,AC24,IO_L12_MRCC_13_JX2_N,JX2,38,IO_L12_MRCC_13_JX2_N,P2,29
set_property  -dict {PACKAGE_PIN  AD20    IOSTANDARD  LVCMOS25} [get_ports  gp_out[10]]   ; ## U1,AD20,IO_L13_MRCC_13_JX2_P,JX2,41,IO_L13_MRCC_13_JX2_P,P2,32
set_property  -dict {PACKAGE_PIN  AC21    IOSTANDARD  LVCMOS25} [get_ports  gp_in[10]]    ; ## U1,AC21,IO_L14_SRCC_13_JX2_P,JX2,42,IO_L14_SRCC_13_JX2_P,P2,31
set_property  -dict {PACKAGE_PIN  AD21    IOSTANDARD  LVCMOS25} [get_ports  gp_out[11]]   ; ## U1,AD21,IO_L13_MRCC_13_JX2_N,JX2,43,IO_L13_MRCC_13_JX2_N,P2,34
set_property  -dict {PACKAGE_PIN  AC22    IOSTANDARD  LVCMOS25} [get_ports  gp_in[11]]    ; ## U1,AC22,IO_L14_SRCC_13_JX2_N,JX2,44,IO_L14_SRCC_13_JX2_N,P2,33
set_property  -dict {PACKAGE_PIN  AF19    IOSTANDARD  LVCMOS25} [get_ports  gp_out[12]]   ; ## U1,AF19,IO_L15_13_JX2_P,JX2,47,IO_L15_13_JX2_P,P2,38
set_property  -dict {PACKAGE_PIN  AE20    IOSTANDARD  LVCMOS25} [get_ports  gp_in[12]]    ; ## U1,AE20,IO_L16_13_JX2_P,JX2,48,IO_L16_13_JX2_P,P2,37
set_property  -dict {PACKAGE_PIN  AF20    IOSTANDARD  LVCMOS25} [get_ports  gp_out[13]]   ; ## U1,AF20,IO_L15_13_JX2_N,JX2,49,IO_L15_13_JX2_N,P2,40
set_property  -dict {PACKAGE_PIN  AE21    IOSTANDARD  LVCMOS25} [get_ports  gp_in[13]]    ; ## U1,AE21,IO_L16_13_JX2_N,JX2,50,IO_L16_13_JX2_N,P2,39
set_property  -dict {PACKAGE_PIN  AD18    IOSTANDARD  LVCMOS25} [get_ports  gp_out[14]]   ; ## U1,AD18,IO_L17_13_JX2_P,JX2,53,IO_L17_13_JX2_P,P2,42
set_property  -dict {PACKAGE_PIN  AE18    IOSTANDARD  LVCMOS25} [get_ports  gp_in[14]]    ; ## U1,AE18,IO_L18_13_JX2_P,JX2,54,IO_L18_13_JX2_P,P2,41
set_property  -dict {PACKAGE_PIN  AD19    IOSTANDARD  LVCMOS25} [get_ports  gp_out[15]]   ; ## U1,AD19,IO_L17_13_JX2_N,JX2,55,IO_L17_13_JX2_N,P2,44
set_property  -dict {PACKAGE_PIN  AF18    IOSTANDARD  LVCMOS25} [get_ports  gp_in[15]]    ; ## U1,AF18,IO_L18_13_JX2_N,JX2,56,IO_L18_13_JX2_N,P2,43
set_property  -dict {PACKAGE_PIN  W20     IOSTANDARD  LVCMOS25} [get_ports  gp_out[16]]   ; ## U1,W20,IO_L19_13_JX2_P,JX2,61,IO_L19_13_JX2_P,P2,46
set_property  -dict {PACKAGE_PIN  AA20    IOSTANDARD  LVCMOS25} [get_ports  gp_in[16]]    ; ## U1,AA20,IO_L20_13_JX2_P,JX2,62,IO_L20_13_JX2_P,P2,45
set_property  -dict {PACKAGE_PIN  Y20     IOSTANDARD  LVCMOS25} [get_ports  gp_out[17]]   ; ## U1,Y20,IO_L19_13_JX2_N,JX2,63,IO_L19_13_JX2_N,P2,48
set_property  -dict {PACKAGE_PIN  AB20    IOSTANDARD  LVCMOS25} [get_ports  gp_in[17]]    ; ## U1,AB20,IO_L20_13_JX2_N,JX2,64,IO_L20_13_JX2_N,P2,47
set_property  -dict {PACKAGE_PIN  AC18    IOSTANDARD  LVCMOS25} [get_ports  gp_out[18]]   ; ## U1,AC18,IO_L21_13_JX2_P,JX2,67,IO_L21_13_JX2_P,P2,52
set_property  -dict {PACKAGE_PIN  AA19    IOSTANDARD  LVCMOS25} [get_ports  gp_in[18]]    ; ## U1,AA19,IO_L22_13_JX2_P,JX2,68,IO_L22_13_JX2_P,P2,51
set_property  -dict {PACKAGE_PIN  AC19    IOSTANDARD  LVCMOS25} [get_ports  gp_out[19]]   ; ## U1,AC19,IO_L21_13_JX2_N,JX2,69,IO_L21_13_JX2_N,P2,54
set_property  -dict {PACKAGE_PIN  AB19    IOSTANDARD  LVCMOS25} [get_ports  gp_in[19]]    ; ## U1,AB19,IO_L22_13_JX2_N,JX2,70,IO_L22_13_JX2_N,P2,53
set_property  -dict {PACKAGE_PIN  W18     IOSTANDARD  LVCMOS25} [get_ports  gp_out[20]]   ; ## U1,W18,IO_L23_13_JX2_P,JX2,73,IO_L23_13_JX2_P,P2,56
set_property  -dict {PACKAGE_PIN  Y18     IOSTANDARD  LVCMOS25} [get_ports  gp_in[20]]    ; ## U1,Y18,IO_L24_13_JX2_P,JX2,74,IO_L24_13_JX2_P,P2,55
set_property  -dict {PACKAGE_PIN  W19     IOSTANDARD  LVCMOS25} [get_ports  gp_out[21]]   ; ## U1,W19,IO_L23_13_JX2_N,JX2,75,IO_L23_13_JX2_N,P2,58
set_property  -dict {PACKAGE_PIN  AA18    IOSTANDARD  LVCMOS25} [get_ports  gp_in[21]]    ; ## U1,AA18,IO_L24_13_JX2_N,JX2,76,IO_L24_13_JX2_N,P2,57
set_property  -dict {PACKAGE_PIN  G4      IOSTANDARD  LVCMOS18} [get_ports  gp_out[22]]   ; ## U1,G4,IO_L01_33_JX1_P,JX1,35,IO_L01_33_JX1_P,P4,2
set_property  -dict {PACKAGE_PIN  D4      IOSTANDARD  LVCMOS18} [get_ports  gp_in[22]]    ; ## U1,D4,IO_L02_33_JX1_P,JX1,41,IO_L02_33_JX1_P,P4,1
set_property  -dict {PACKAGE_PIN  F4      IOSTANDARD  LVCMOS18} [get_ports  gp_out[23]]   ; ## U1,F4,IO_L01_33_JX1_N,JX1,37,IO_L01_33_JX1_N,P4,4
set_property  -dict {PACKAGE_PIN  D3      IOSTANDARD  LVCMOS18} [get_ports  gp_in[23]]    ; ## U1,D3,IO_L02_33_JX1_N,JX1,43,IO_L02_33_JX1_N,P4,3
set_property  -dict {PACKAGE_PIN  G2      IOSTANDARD  LVCMOS18} [get_ports  gp_out[24]]   ; ## U1,G2,IO_L03_33_JX1_P,JX1,42,IO_L03_33_JX1_P,P4,6
set_property  -dict {PACKAGE_PIN  D1      IOSTANDARD  LVCMOS18} [get_ports  gp_in[24]]    ; ## U1,D1,IO_L04_33_JX1_P,JX1,47,IO_L04_33_JX1_P,P4,5
set_property  -dict {PACKAGE_PIN  F2      IOSTANDARD  LVCMOS18} [get_ports  gp_out[25]]   ; ## U1,F2,IO_L03_33_JX1_N,JX1,44,IO_L03_33_JX1_N,P4,8
set_property  -dict {PACKAGE_PIN  C1      IOSTANDARD  LVCMOS18} [get_ports  gp_in[25]]    ; ## U1,C1,IO_L04_33_JX1_N,JX1,49,IO_L04_33_JX1_N,P4,7
set_property  -dict {PACKAGE_PIN  E2      IOSTANDARD  LVCMOS18} [get_ports  gp_out[26]]   ; ## U1,E2,IO_L05_33_JX1_P,JX1,54,IO_L05_33_JX1_P,P4,14
set_property  -dict {PACKAGE_PIN  F3      IOSTANDARD  LVCMOS18} [get_ports  gp_in[26]]    ; ## U1,F3,IO_L06_33_JX1_P,JX1,61,IO_L06_33_JX1_P,P4,13
set_property  -dict {PACKAGE_PIN  E1      IOSTANDARD  LVCMOS18} [get_ports  gp_out[27]]   ; ## U1,E1,IO_L05_33_JX1_N,JX1,56,IO_L05_33_JX1_N,P4,16
set_property  -dict {PACKAGE_PIN  E3      IOSTANDARD  LVCMOS18} [get_ports  gp_in[27]]    ; ## U1,E3,IO_L06_33_JX1_N,JX1,63,IO_L06_33_JX1_N,P4,15
set_property  -dict {PACKAGE_PIN  J1      IOSTANDARD  LVCMOS18} [get_ports  gp_out[28]]   ; ## U1,J1,IO_L07_33_JX1_P,JX1,62,IO_L07_33_JX1_P,P4,18
set_property  -dict {PACKAGE_PIN  H4      IOSTANDARD  LVCMOS18} [get_ports  gp_in[28]]    ; ## U1,H4,IO_L08_33_JX1_P,JX1,67,IO_L08_33_JX1_P,P4,17
set_property  -dict {PACKAGE_PIN  H1      IOSTANDARD  LVCMOS18} [get_ports  gp_out[29]]   ; ## U1,H1,IO_L07_33_JX1_N,JX1,64,IO_L07_33_JX1_N,P4,20
set_property  -dict {PACKAGE_PIN  H3      IOSTANDARD  LVCMOS18} [get_ports  gp_in[29]]    ; ## U1,H3,IO_L08_33_JX1_N,JX1,69,IO_L08_33_JX1_N,P4,19
set_property  -dict {PACKAGE_PIN  K2      IOSTANDARD  LVCMOS18} [get_ports  gp_out[30]]   ; ## U1,K2,IO_L09_33_JX1_P,JX1,68,IO_L09_33_JX1_P,P4,26
set_property  -dict {PACKAGE_PIN  H2      IOSTANDARD  LVCMOS18} [get_ports  gp_in[30]]    ; ## U1,H2,IO_L10_33_JX1_P,JX1,73,IO_L10_33_JX1_P,P4,25
set_property  -dict {PACKAGE_PIN  K1      IOSTANDARD  LVCMOS18} [get_ports  gp_out[31]]   ; ## U1,K1,IO_L09_33_JX1_N,JX1,70,IO_L09_33_JX1_N,P4,28
set_property  -dict {PACKAGE_PIN  G1      IOSTANDARD  LVCMOS18} [get_ports  gp_in[31]]    ; ## U1,G1,IO_L10_33_JX1_N,JX1,75,IO_L10_33_JX1_N,P4,27
set_property  -dict {PACKAGE_PIN  L3      IOSTANDARD  LVCMOS18} [get_ports  gp_out[32]]   ; ## U1,L3,IO_L11_SRCC_33_JX1_P,JX1,74,IO_L11_SRCC_33_JX1_P,P4,30
set_property  -dict {PACKAGE_PIN  J4      IOSTANDARD  LVCMOS18} [get_ports  gp_in[32]]    ; ## U1,J4,IO_L12_MRCC_33_JX1_P,JX1,81,IO_L12_MRCC_33_JX1_P,P4,29
set_property  -dict {PACKAGE_PIN  M2      IOSTANDARD  LVCMOS18} [get_ports  gp_out[33]]   ; ## U1,M2,IO_L16_33_JX1_P,JX1,11,IO_L16_33_JX1_P,P5,2
set_property  -dict {PACKAGE_PIN  N4      IOSTANDARD  LVCMOS18} [get_ports  gp_in[33]]    ; ## U1,N4,IO_L17_33_JX1_P,JX1,12,IO_L17_33_JX1_P,P5,1
set_property  -dict {PACKAGE_PIN  L2      IOSTANDARD  LVCMOS18} [get_ports  gp_out[34]]   ; ## U1,L2,IO_L16_33_JX1_N,JX1,13,IO_L16_33_JX1_N,P5,4
set_property  -dict {PACKAGE_PIN  M4      IOSTANDARD  LVCMOS18} [get_ports  gp_in[34]]    ; ## U1,M4,IO_L17_33_JX1_N,JX1,14,IO_L17_33_JX1_N,P5,3
set_property  -dict {PACKAGE_PIN  N1      IOSTANDARD  LVCMOS18} [get_ports  gp_out[35]]   ; ## U1,N1,IO_L18_33_JX1_P,JX1,17,IO_L18_33_JX1_P,P5,6
set_property  -dict {PACKAGE_PIN  M7      IOSTANDARD  LVCMOS18} [get_ports  gp_in[35]]    ; ## U1,M7,IO_L19_33_JX1_P,JX1,18,IO_L19_33_JX1_P,P5,5
set_property  -dict {PACKAGE_PIN  M1      IOSTANDARD  LVCMOS18} [get_ports  gp_out[36]]   ; ## U1,M1,IO_L18_33_JX1_N,JX1,19,IO_L18_33_JX1_N,P5,8
set_property  -dict {PACKAGE_PIN  L7      IOSTANDARD  LVCMOS18} [get_ports  gp_in[36]]    ; ## U1,L7,IO_L19_33_JX1_N,JX1,20,IO_L19_33_JX1_N,P5,7
set_property  -dict {PACKAGE_PIN  M8      IOSTANDARD  LVCMOS18} [get_ports  gp_out[37]]   ; ## U1,M8,IO_L21_33_JX1_P,JX1,24,IO_L21_33_JX1_P,P5,14
set_property  -dict {PACKAGE_PIN  K5      IOSTANDARD  LVCMOS18} [get_ports  gp_in[37]]    ; ## U1,K5,IO_L20_33_JX1_P,JX1,23,IO_L20_33_JX1_P,P5,13
set_property  -dict {PACKAGE_PIN  L8      IOSTANDARD  LVCMOS18} [get_ports  gp_out[38]]   ; ## U1,L8,IO_L21_33_JX1_N,JX1,26,IO_L21_33_JX1_N,P5,16
set_property  -dict {PACKAGE_PIN  J5      IOSTANDARD  LVCMOS18} [get_ports  gp_in[38]]    ; ## U1,J5,IO_L20_33_JX1_N,JX1,25,IO_L20_33_JX1_N,P5,15
set_property  -dict {PACKAGE_PIN  N7      IOSTANDARD  LVCMOS18} [get_ports  gp_out[39]]   ; ## U1,N7,IO_L23_33_JX1_P,JX1,30,IO_L23_33_JX1_P,P5,18
set_property  -dict {PACKAGE_PIN  K6      IOSTANDARD  LVCMOS18} [get_ports  gp_in[39]]    ; ## U1,K6,IO_L22_33_JX1_P,JX1,29,IO_L22_33_JX1_P,P5,17
set_property  -dict {PACKAGE_PIN  N6      IOSTANDARD  LVCMOS18} [get_ports  gp_out[40]]   ; ## U1,N6,IO_L23_33_JX1_N,JX1,32,IO_L23_33_JX1_N,P5,20
set_property  -dict {PACKAGE_PIN  J6      IOSTANDARD  LVCMOS18} [get_ports  gp_in[40]]    ; ## U1,J6,IO_L22_33_JX1_N,JX1,31,IO_L22_33_JX1_N,P5,19
set_property  -dict {PACKAGE_PIN  D5      IOSTANDARD  LVCMOS18} [get_ports  gp_out[41]]   ; ## U1,D5,IO_L10_34_JX4_N,JX4,44,IO_L10_34_JX4_N,P6,27
set_property  -dict {PACKAGE_PIN  K10     IOSTANDARD  LVCMOS18} [get_ports  gp_in[41]]    ; ## U1,K10,IO_25_34_JX4,JX4,64,IO_25_34_JX4,P5,23
set_property  -dict {PACKAGE_PIN  K8      IOSTANDARD  LVCMOS18} [get_ports  gp_out[42]]   ; ## U1,K8,IO_L24_33_JX1_P,JX1,36,IO_L24_33_JX1_P,P5,26
set_property  -dict {PACKAGE_PIN  L5      IOSTANDARD  LVCMOS18} [get_ports  gp_in[42]]    ; ## U1,L5,IO_L14_SRCC_33_JX1_P,JX1,48,IO_L14_SRCC_33_JX1_P,P5,25
set_property  -dict {PACKAGE_PIN  K7      IOSTANDARD  LVCMOS18} [get_ports  gp_out[43]]   ; ## U1,K7,IO_L24_33_JX1_N,JX1,38,IO_L24_33_JX1_N,P5,28
set_property  -dict {PACKAGE_PIN  L4      IOSTANDARD  LVCMOS18} [get_ports  gp_in[43]]    ; ## U1,L4,IO_L14_SRCC_33_JX1_N,JX1,50,IO_L14_SRCC_33_JX1_N,P5,27
set_property  -dict {PACKAGE_PIN  N3      IOSTANDARD  LVCMOS18} [get_ports  gp_out[44]]   ; ## U1,N3,IO_L15_33_JX1_P,JX1,53,IO_L15_33_JX1_P,P5,30
set_property  -dict {PACKAGE_PIN  M6      IOSTANDARD  LVCMOS18} [get_ports  gp_in[44]]    ; ## U1,M6,IO_L13_MRCC_33_JX1_P,JX1,82,IO_L13_MRCC_33_JX1_P,P5,29
set_property  -dict {PACKAGE_PIN  N2      IOSTANDARD  LVCMOS18} [get_ports  gp_out[45]]   ; ## U1,N2,IO_L15_33_JX1_N,JX1,55,IO_L15_33_JX1_N,P5,32
set_property  -dict {PACKAGE_PIN  M5      IOSTANDARD  LVCMOS18} [get_ports  gp_in[45]]    ; ## U1,M5,IO_L13_MRCC_33_JX1_N,JX1,84,IO_L13_MRCC_33_JX1_N,P5,31
set_property  -dict {PACKAGE_PIN  J11     IOSTANDARD  LVCMOS18} [get_ports  gp_out[46]]   ; ## U1,J11,IO_L01_34_JX4_P,JX4,19,IO_L01_34_JX4_P,P6,2
set_property  -dict {PACKAGE_PIN  G6      IOSTANDARD  LVCMOS18} [get_ports  gp_in[46]]    ; ## U1,G6,IO_L02_34_JX4_P,JX4,20,IO_L02_34_JX4_P,P6,1
set_property  -dict {PACKAGE_PIN  H11     IOSTANDARD  LVCMOS18} [get_ports  gp_out[47]]   ; ## U1,H11,IO_L01_34_JX4_N,JX4,21,IO_L01_34_JX4_N,P6,4
set_property  -dict {PACKAGE_PIN  G5      IOSTANDARD  LVCMOS18} [get_ports  gp_in[47]]    ; ## U1,G5,IO_L02_34_JX4_N,JX4,22,IO_L02_34_JX4_N,P6,3
set_property  -dict {PACKAGE_PIN  H9      IOSTANDARD  LVCMOS18} [get_ports  gp_out[48]]   ; ## U1,H9,IO_L03_34_JX4_P,JX4,25,IO_L03_34_JX4_P,P6,6
set_property  -dict {PACKAGE_PIN  H7      IOSTANDARD  LVCMOS18} [get_ports  gp_in[48]]    ; ## U1,H7,IO_L04_34_JX4_P,JX4,26,IO_L04_34_JX4_P,P6,5
set_property  -dict {PACKAGE_PIN  G9      IOSTANDARD  LVCMOS18} [get_ports  gp_out[49]]   ; ## U1,G9,IO_L03_34_JX4_N,JX4,27,IO_L03_34_JX4_N,P6,8
set_property  -dict {PACKAGE_PIN  H6      IOSTANDARD  LVCMOS18} [get_ports  gp_in[49]]    ; ## U1,H6,IO_L04_34_JX4_N,JX4,28,IO_L04_34_JX4_N,P6,7
set_property  -dict {PACKAGE_PIN  J10     IOSTANDARD  LVCMOS18} [get_ports  gp_out[50]]   ; ## U1,J10,IO_L05_34_JX4_P,JX4,31,IO_L05_34_JX4_P,P6,14
set_property  -dict {PACKAGE_PIN  J8      IOSTANDARD  LVCMOS18} [get_ports  gp_in[50]]    ; ## U1,J8,IO_L06_34_JX4_P,JX4,32,IO_L06_34_JX4_P,P6,13
set_property  -dict {PACKAGE_PIN  J9      IOSTANDARD  LVCMOS18} [get_ports  gp_out[51]]   ; ## U1,J9,IO_L05_34_JX4_N,JX4,33,IO_L05_34_JX4_N,P6,16
set_property  -dict {PACKAGE_PIN  H8      IOSTANDARD  LVCMOS18} [get_ports  gp_in[51]]    ; ## U1,H8,IO_L06_34_JX4_N,JX4,34,IO_L06_34_JX4_N,P6,15
set_property  -dict {PACKAGE_PIN  F5      IOSTANDARD  LVCMOS18} [get_ports  gp_out[52]]   ; ## U1,F5,IO_L07_34_JX4_P,JX4,35,IO_L07_34_JX4_P,P6,18
set_property  -dict {PACKAGE_PIN  D9      IOSTANDARD  LVCMOS18} [get_ports  gp_in[52]]    ; ## U1,D9,IO_L08_34_JX4_P,JX4,36,IO_L08_34_JX4_P,P6,17
set_property  -dict {PACKAGE_PIN  F8      IOSTANDARD  LVCMOS18} [get_ports  gp_out[53]]   ; ## U1,F8,IO_L11_SRCC_34_JX4_P,JX4,45,IO_L11_SRCC_34_JX4_P,P6,30
set_property  -dict {PACKAGE_PIN  G7      IOSTANDARD  LVCMOS18} [get_ports  gp_in[53]]    ; ## U1,G7,IO_L12_MRCC_34_JX4_P,JX4,46,IO_L12_MRCC_34_JX4_P,P6,29
set_property  -dict {PACKAGE_PIN  E7      IOSTANDARD  LVCMOS18} [get_ports  gp_out[54]]   ; ## U1,E7,IO_L11_SRCC_34_JX4_N,JX4,47,IO_L11_SRCC_34_JX4_N,P6,32
set_property  -dict {PACKAGE_PIN  F7      IOSTANDARD  LVCMOS18} [get_ports  gp_in[54]]    ; ## U1,F7,IO_L12_MRCC_34_JX4_N,JX4,48,IO_L12_MRCC_34_JX4_N,P6,31
set_property  -dict {PACKAGE_PIN  C8      IOSTANDARD  LVCMOS18} [get_ports  gp_out[55]]   ; ## U1,C8,IO_L13_MRCC_34_JX4_P,JX4,51,IO_L13_MRCC_34_JX4_P,P7,2
set_property  -dict {PACKAGE_PIN  D6      IOSTANDARD  LVCMOS18} [get_ports  gp_in[55]]    ; ## U1,D6,IO_L14_SRCC_34_JX4_P,JX4,52,IO_L14_SRCC_34_JX4_P,P7,1
set_property  -dict {PACKAGE_PIN  C7      IOSTANDARD  LVCMOS18} [get_ports  gp_out[56]]   ; ## U1,C7,IO_L13_MRCC_34_JX4_N,JX4,53,IO_L13_MRCC_34_JX4_N,P7,4
set_property  -dict {PACKAGE_PIN  C6      IOSTANDARD  LVCMOS18} [get_ports  gp_in[56]]    ; ## U1,C6,IO_L14_SRCC_34_JX4_N,JX4,54,IO_L14_SRCC_34_JX4_N,P7,3
set_property  -dict {PACKAGE_PIN  C9      IOSTANDARD  LVCMOS18} [get_ports  gp_out[57]]   ; ## U1,C9,IO_L15_34_JX4_P,JX4,57,IO_L15_34_JX4_P,P7,6
set_property  -dict {PACKAGE_PIN  B10     IOSTANDARD  LVCMOS18} [get_ports  gp_in[57]]    ; ## U1,B10,IO_L16_34_JX4_P,JX4,58,IO_L16_34_JX4_P,P7,5
set_property  -dict {PACKAGE_PIN  B9      IOSTANDARD  LVCMOS18} [get_ports  gp_out[58]]   ; ## U1,B9,IO_L15_34_JX4_N,JX4,59,IO_L15_34_JX4_N,P7,8
set_property  -dict {PACKAGE_PIN  A10     IOSTANDARD  LVCMOS18} [get_ports  gp_in[58]]    ; ## U1,A10,IO_L16_34_JX4_N,JX4,60,IO_L16_34_JX4_N,P7,7
set_property  -dict {PACKAGE_PIN  C4      IOSTANDARD  LVCMOS18} [get_ports  gp_out[59]]   ; ## U1,C4,IO_L19_34_JX4_P,JX4,73,IO_L19_34_JX4_P,P7,18
set_property  -dict {PACKAGE_PIN  B5      IOSTANDARD  LVCMOS18} [get_ports  gp_in[59]]    ; ## U1,B5,IO_L20_34_JX4_P,JX4,74,IO_L20_34_JX4_P,P7,17
set_property  -dict {PACKAGE_PIN  C3      IOSTANDARD  LVCMOS18} [get_ports  gp_out[60]]   ; ## U1,C3,IO_L19_34_JX4_N,JX4,75,IO_L19_34_JX4_N,P7,20
set_property  -dict {PACKAGE_PIN  B4      IOSTANDARD  LVCMOS18} [get_ports  gp_in[60]]    ; ## U1,B4,IO_L20_34_JX4_N,JX4,76,IO_L20_34_JX4_N,P7,19
set_property  -dict {PACKAGE_PIN  B6      IOSTANDARD  LVCMOS18} [get_ports  gp_out[61]]   ; ## U1,B6,IO_L21_34_JX4_P,JX4,77,IO_L21_34_JX4_P,P7,26
set_property  -dict {PACKAGE_PIN  A4      IOSTANDARD  LVCMOS18} [get_ports  gp_in[61]]    ; ## U1,A4,IO_L22_34_JX4_P,JX4,78,IO_L22_34_JX4_P,P7,25
set_property  -dict {PACKAGE_PIN  A5      IOSTANDARD  LVCMOS18} [get_ports  gp_out[62]]   ; ## U1,A5,IO_L21_34_JX4_N,JX4,79,IO_L21_34_JX4_N,P7,28
set_property  -dict {PACKAGE_PIN  A3      IOSTANDARD  LVCMOS18} [get_ports  gp_in[62]]    ; ## U1,A3,IO_L22_34_JX4_N,JX4,80,IO_L22_34_JX4_N,P7,27
set_property  -dict {PACKAGE_PIN  B7      IOSTANDARD  LVCMOS18} [get_ports  gp_out[63]]   ; ## U1,B7,IO_L18_34_JX4_P,JX4,68,IO_L18_34_JX4_P,P7,30
set_property  -dict {PACKAGE_PIN  L9      IOSTANDARD  LVCMOS18} [get_ports  gp_in[63]]    ; ## U1,L9,IO_00_33_JX1,JX1,9,IO_00_33_JX1,P7,29
set_property  -dict {PACKAGE_PIN  AD15    IOSTANDARD  LVCMOS25} [get_ports  gp_out[64]]   ; ## U1,AD15,IO_L15_12_JX3_N,JX3,99,IO_L15_12_JX3_N,P13,6
set_property  -dict {PACKAGE_PIN  AF14    IOSTANDARD  LVCMOS25} [get_ports  gp_in[64]]    ; ## U1,AF14,IO_L16_12_JX3_N,JX3,100,IO_L16_12_JX3_N,P13,5
set_property  -dict {PACKAGE_PIN  AD16    IOSTANDARD  LVCMOS25} [get_ports  gp_out[65]]   ; ## U1,AD16,IO_L15_12_JX3_P,JX3,97,IO_L15_12_JX3_P,P13,8
set_property  -dict {PACKAGE_PIN  AF15    IOSTANDARD  LVCMOS25} [get_ports  gp_in[65]]    ; ## U1,AF15,IO_L16_12_JX3_P,JX3,98,IO_L16_12_JX3_P,P13,7
set_property  -dict {PACKAGE_PIN  AD14    IOSTANDARD  LVCMOS25} [get_ports  gp_out[66]]   ; ## U1,AD14,IO_L13_MRCC_12_JX3_N,JX3,93,IO_L13_MRCC_12_JX3_N,P13,10
set_property  -dict {PACKAGE_PIN  AB14    IOSTANDARD  LVCMOS25} [get_ports  gp_in[66]]    ; ## U1,AB14,IO_L14_SRCC_12_JX3_N,JX3,94,IO_L14_SRCC_12_JX3_N,P13,9
set_property  -dict {PACKAGE_PIN  AC14    IOSTANDARD  LVCMOS25} [get_ports  gp_out[67]]   ; ## U1,AC14,IO_L13_MRCC_12_JX3_P,JX3,91,IO_L13_MRCC_12_JX3_P,P13,12
set_property  -dict {PACKAGE_PIN  AB15    IOSTANDARD  LVCMOS25} [get_ports  gp_in[67]]    ; ## U1,AB15,IO_L14_SRCC_12_JX3_P,JX3,92,IO_L14_SRCC_12_JX3_P,P13,11
set_property  -dict {PACKAGE_PIN  AD11    IOSTANDARD  LVCMOS25} [get_ports  gp_out[68]]   ; ## U1,AD11,IO_L11_SRCC_12_JX3_N,JX3,87,IO_L11_SRCC_12_JX3_N,P13,14
set_property  -dict {PACKAGE_PIN  AD13    IOSTANDARD  LVCMOS25} [get_ports  gp_in[68]]    ; ## U1,AD13,IO_L12_MRCC_12_JX3_N,JX3,88,IO_L12_MRCC_12_JX3_N,P13,13
set_property  -dict {PACKAGE_PIN  AC12    IOSTANDARD  LVCMOS25} [get_ports  gp_out[69]]   ; ## U1,AC12,IO_L11_SRCC_12_JX3_P,JX3,85,IO_L11_SRCC_12_JX3_P,P13,16
set_property  -dict {PACKAGE_PIN  AC13    IOSTANDARD  LVCMOS25} [get_ports  gp_in[69]]    ; ## U1,AC13,IO_L12_MRCC_12_JX3_P,JX3,86,IO_L12_MRCC_12_JX3_P,P13,15
set_property  -dict {PACKAGE_PIN  AF10    IOSTANDARD  LVCMOS25} [get_ports  gp_out[70]]   ; ## U1,AF10,IO_L09_12_JX3_N,JX3,81,IO_L09_12_JX3_N,P13,20
set_property  -dict {PACKAGE_PIN  AF13    IOSTANDARD  LVCMOS25} [get_ports  gp_in[70]]    ; ## U1,AF13,IO_L10_12_JX3_N,JX3,82,IO_L10_12_JX3_N,P13,19
set_property  -dict {PACKAGE_PIN  AE11    IOSTANDARD  LVCMOS25} [get_ports  gp_out[71]]   ; ## U1,AE11,IO_L09_12_JX3_P,JX3,79,IO_L09_12_JX3_P,P13,22
set_property  -dict {PACKAGE_PIN  AE13    IOSTANDARD  LVCMOS25} [get_ports  gp_in[71]]    ; ## U1,AE13,IO_L10_12_JX3_P,JX3,80,IO_L10_12_JX3_P,P13,21
set_property  -dict {PACKAGE_PIN  AD10    IOSTANDARD  LVCMOS25} [get_ports  gp_out[72]]   ; ## U1,AD10,IO_L07_12_JX3_N,JX3,75,IO_L07_12_JX3_N,P13,24
set_property  -dict {PACKAGE_PIN  AF12    IOSTANDARD  LVCMOS25} [get_ports  gp_in[72]]    ; ## U1,AF12,IO_L08_12_JX3_N,JX3,76,IO_L08_12_JX3_N,P13,23
set_property  -dict {PACKAGE_PIN  AE10    IOSTANDARD  LVCMOS25} [get_ports  gp_out[73]]   ; ## U1,AE10,IO_L07_12_JX3_P,JX3,73,IO_L07_12_JX3_P,P13,26
set_property  -dict {PACKAGE_PIN  AE12    IOSTANDARD  LVCMOS25} [get_ports  gp_in[73]]    ; ## U1,AE12,IO_L08_12_JX3_P,JX3,74,IO_L08_12_JX3_P,P13,25
set_property  -dict {PACKAGE_PIN  Y13     IOSTANDARD  LVCMOS25} [get_ports  gp_out[74]]   ; ## U1,Y13,IO_L05_12_JX3_N,JX3,44,IO_L05_12_JX3_N,P13,28
set_property  -dict {PACKAGE_PIN  AA12    IOSTANDARD  LVCMOS25} [get_ports  gp_in[74]]    ; ## U1,AA12,IO_L06_12_JX3_N,JX3,66,IO_L06_12_JX3_N,P13,27
set_property  -dict {PACKAGE_PIN  W13     IOSTANDARD  LVCMOS25} [get_ports  gp_out[75]]   ; ## U1,W13,IO_L05_12_JX3_P,JX3,42,IO_L05_12_JX3_P,P13,30
set_property  -dict {PACKAGE_PIN  AA13    IOSTANDARD  LVCMOS25} [get_ports  gp_in[75]]    ; ## U1,AA13,IO_L06_12_JX3_P,JX3,64,IO_L06_12_JX3_P,P13,29
set_property  -dict {PACKAGE_PIN  AA10    IOSTANDARD  LVCMOS25} [get_ports  gp_out[76]]   ; ## U1,AA10,IO_L03_12_JX3_N,JX3,28,IO_L03_12_JX3_N,P13,32
set_property  -dict {PACKAGE_PIN  AB10    IOSTANDARD  LVCMOS25} [get_ports  gp_in[76]]    ; ## U1,AB10,IO_L04_12_JX3_N,JX3,33,IO_L04_12_JX3_N,P13,31
set_property  -dict {PACKAGE_PIN  Y10     IOSTANDARD  LVCMOS25} [get_ports  gp_out[77]]   ; ## U1,Y10,IO_L03_12_JX3_P,JX3,26,IO_L03_12_JX3_P,P13,34
set_property  -dict {PACKAGE_PIN  AB11    IOSTANDARD  LVCMOS25} [get_ports  gp_in[77]]    ; ## U1,AB11,IO_L04_12_JX3_P,JX3,31,IO_L04_12_JX3_P,P13,33
set_property  -dict {PACKAGE_PIN  Y11     IOSTANDARD  LVCMOS25} [get_ports  gp_out[78]]   ; ## U1,Y11,IO_L01_12_JX3_N,JX3,22,IO_L01_12_JX3_N,P13,36
set_property  -dict {PACKAGE_PIN  AC11    IOSTANDARD  LVCMOS25} [get_ports  gp_in[78]]    ; ## U1,AC11,IO_L02_12_JX3_N,JX3,27,IO_L02_12_JX3_N,P13,35
set_property  -dict {PACKAGE_PIN  Y12     IOSTANDARD  LVCMOS25} [get_ports  gp_out[79]]   ; ## U1,Y12,IO_L01_12_JX3_P,JX3,20,IO_L01_12_JX3_P,P13,38
set_property  -dict {PACKAGE_PIN  AB12    IOSTANDARD  LVCMOS25} [get_ports  gp_in[79]]    ; ## U1,AB12,IO_L02_12_JX3_P,JX3,25,IO_L02_12_JX3_P,P13,37
set_property  -dict {PACKAGE_PIN  AE16    IOSTANDARD  LVCMOS25} [get_ports  gp_out[80]]   ; ## U1,AE16,IO_L17_12_JX2_P,JX2,82,IO_L17_12_JX2_P,P13,42
set_property  -dict {PACKAGE_PIN  AE17    IOSTANDARD  LVCMOS25} [get_ports  gp_in[80]]    ; ## U1,AE17,IO_L18_12_JX2_P,JX2,81,IO_L18_12_JX2_P,P13,41
set_property  -dict {PACKAGE_PIN  AE15    IOSTANDARD  LVCMOS25} [get_ports  gp_out[81]]   ; ## U1,AE15,IO_L17_12_JX2_N,JX2,84,IO_L17_12_JX2_N,P13,44
set_property  -dict {PACKAGE_PIN  AF17    IOSTANDARD  LVCMOS25} [get_ports  gp_in[81]]    ; ## U1,AF17,IO_L18_12_JX2_N,JX2,83,IO_L18_12_JX2_N,P13,43
set_property  -dict {PACKAGE_PIN  Y17     IOSTANDARD  LVCMOS25} [get_ports  gp_out[82]]   ; ## U1,Y17,IO_L19_12_JX2_P,JX2,88,IO_L19_12_JX2_P,P13,46
set_property  -dict {PACKAGE_PIN  AB17    IOSTANDARD  LVCMOS25} [get_ports  gp_in[82]]    ; ## U1,AB17,IO_L20_12_JX2_P,JX2,87,IO_L20_12_JX2_P,P13,45
set_property  -dict {PACKAGE_PIN  AA17    IOSTANDARD  LVCMOS25} [get_ports  gp_out[83]]   ; ## U1,AA17,IO_L19_12_JX2_N,JX2,90,IO_L19_12_JX2_N,P13,48
set_property  -dict {PACKAGE_PIN  AB16    IOSTANDARD  LVCMOS25} [get_ports  gp_in[83]]    ; ## U1,AB16,IO_L20_12_JX2_N,JX2,89,IO_L20_12_JX2_N,P13,47
set_property  -dict {PACKAGE_PIN  AC17    IOSTANDARD  LVCMOS25} [get_ports  gp_out[84]]   ; ## U1,AC17,IO_L21_12_JX2_P,JX2,93,IO_L21_12_JX2_P,P13,50
set_property  -dict {PACKAGE_PIN  AA15    IOSTANDARD  LVCMOS25} [get_ports  gp_in[84]]    ; ## U1,AA15,IO_L22_12_JX2_P,JX2,94,IO_L22_12_JX2_P,P13,49
set_property  -dict {PACKAGE_PIN  AC16    IOSTANDARD  LVCMOS25} [get_ports  gp_out[85]]   ; ## U1,AC16,IO_L21_12_JX2_N,JX2,95,IO_L21_12_JX2_N,P13,52
set_property  -dict {PACKAGE_PIN  AA14    IOSTANDARD  LVCMOS25} [get_ports  gp_in[85]]    ; ## U1,AA14,IO_L22_12_JX2_N,JX2,96,IO_L22_12_JX2_N,P13,51

## transceiver loop-backs (on-ccbrk)

set_property  -dict {PACKAGE_PIN  R6}     [get_ports  gt_ref_clk_p]   ; ## U1,R6,MGTREFCLK0_112_JX1_P (JX1,87)
set_property  -dict {PACKAGE_PIN  R5}     [get_ports  gt_ref_clk_n]   ; ## U1,R5,MGTREFCLK0_112_JX1_N (JX1,89)
set_property  -dict {PACKAGE_PIN  AB4}    [get_ports  gt_rx_p[0]]     ; ## U1,AB4,MGTXRX0_112_JX1_P   (JX1,88)
set_property  -dict {PACKAGE_PIN  AB3}    [get_ports  gt_rx_n[0]]     ; ## U1,AB3,MGTXRX0_112_JX1_N   (JX1,90)
set_property  -dict {PACKAGE_PIN  Y4}     [get_ports  gt_rx_p[1]]     ; ## U1,Y4,MGTXRX1_112_JX1_P    (JX1,91)
set_property  -dict {PACKAGE_PIN  Y3}     [get_ports  gt_rx_n[1]]     ; ## U1,Y3,MGTXRX1_112_JX1_N    (JX1,93)
set_property  -dict {PACKAGE_PIN  V4}     [get_ports  gt_rx_p[2]]     ; ## U1,V4,MGTXRX2_112_JX1_P    (JX1,92)
set_property  -dict {PACKAGE_PIN  V3}     [get_ports  gt_rx_n[2]]     ; ## U1,V3,MGTXRX2_112_JX1_N    (JX1,94)
set_property  -dict {PACKAGE_PIN  T4}     [get_ports  gt_rx_p[3]]     ; ## U1,T4,MGTXRX3_112_JX1_P    (JX1,97)
set_property  -dict {PACKAGE_PIN  T3}     [get_ports  gt_rx_n[3]]     ; ## U1,T3,MGTXRX3_112_JX1_N    (JX1,99)
set_property  -dict {PACKAGE_PIN  AA2}    [get_ports  gt_tx_p[0]]     ; ## U1,AA2,MGTXTX0_112_JX3_P   (JX3,8)
set_property  -dict {PACKAGE_PIN  AA1}    [get_ports  gt_tx_n[0]]     ; ## U1,AA1,MGTXTX0_112_JX3_N   (JX3,10)
set_property  -dict {PACKAGE_PIN  W2}     [get_ports  gt_tx_p[1]]     ; ## U1,W2,MGTXTX1_112_JX3_P    (JX3,13)
set_property  -dict {PACKAGE_PIN  W1}     [get_ports  gt_tx_n[1]]     ; ## U1,W1,MGTXTX1_112_JX3_N    (JX3,15)
set_property  -dict {PACKAGE_PIN  U2}     [get_ports  gt_tx_p[2]]     ; ## U1,U2,MGTXTX2_112_JX3_P    (JX3,14)
set_property  -dict {PACKAGE_PIN  U1}     [get_ports  gt_tx_n[2]]     ; ## U1,U1,MGTXTX2_112_JX3_N    (JX3,16)
set_property  -dict {PACKAGE_PIN  R2}     [get_ports  gt_tx_p[3]]     ; ## U1,R2,MGTXTX3_112_JX3_P    (JX3,19)
set_property  -dict {PACKAGE_PIN  R1}     [get_ports  gt_tx_n[3]]     ; ## U1,R1,MGTXTX3_112_JX3_N    (JX3,21)

## clocks

create_clock -name ref_clk      -period  4.00 [get_ports gt_ref_clk_p]
create_clock -name xcvr_clk_0   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pz_xcvrlb/inst/g_lanes[0].i_xcvrlb_1/i_xch/i_gtxe2_channel/RXOUTCLK]
create_clock -name xcvr_clk_1   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pz_xcvrlb/inst/g_lanes[1].i_xcvrlb_1/i_xch/i_gtxe2_channel/RXOUTCLK]
create_clock -name xcvr_clk_2   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pz_xcvrlb/inst/g_lanes[2].i_xcvrlb_1/i_xch/i_gtxe2_channel/RXOUTCLK]
create_clock -name xcvr_clk_3   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pz_xcvrlb/inst/g_lanes[3].i_xcvrlb_1/i_xch/i_gtxe2_channel/RXOUTCLK]


