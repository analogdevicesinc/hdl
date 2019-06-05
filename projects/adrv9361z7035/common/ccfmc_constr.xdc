
# rf-board

set_property  -dict {PACKAGE_PIN  AA20  IOSTANDARD LVCMOS25} [get_ports gpio_rf0]                     ; ## U1,AA20,IO_L20_13_JX2_P,JX2,62,RF_GPIO0_BANK13
set_property  -dict {PACKAGE_PIN  AB20  IOSTANDARD LVCMOS25} [get_ports gpio_rf1]                     ; ## U1,AB20,IO_L20_13_JX2_N,JX2,64,RF_GPIO1_BANK13
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS25} [get_ports gpio_rf2]                     ; ## U1,AA14,IO_L22_12_JX2_N,JX2,96,RF_GPIO2_BANK12
set_property  -dict {PACKAGE_PIN  J9    IOSTANDARD LVCMOS18} [get_ports gpio_rf3]                     ; ## U1,J9,IO_L05_34_JX4_N,JX4,33,RF_GPIO3_BANK34
set_property  -dict {PACKAGE_PIN  K10   IOSTANDARD LVCMOS18} [get_ports gpio_rf4]                     ; ## U1,K10,IO_25_34_JX4,JX4,64,RF_GPIO4_BANK34
set_property  -dict {PACKAGE_PIN  A9    IOSTANDARD LVCMOS18} [get_ports gpio_rf5]                     ; ## U1,A9,IO_L17_34_JX4_P,JX4,67,RF_GPIO5_BANK34
set_property  -dict {PACKAGE_PIN  W19   IOSTANDARD LVCMOS25} [get_ports tdd_sync]                     ; ## U1,W19,IO_L23_13_JX2_N,JX2,75,PMOD0_D5,R105,1

# ethernet-1 (U1,B20,PS_MIO51_501_JX4,JX4,100,ETH1_RESETN)

set_property  -dict {PACKAGE_PIN  B10   IOSTANDARD LVCMOS18} [get_ports eth1_mdc]                     ; ## U1,B10,IO_L16_34_JX4_P,JX4,58,ETH1_MDC
set_property  -dict {PACKAGE_PIN  A10   IOSTANDARD LVCMOS18} [get_ports eth1_mdio]                    ; ## U1,A10,IO_L16_34_JX4_N,JX4,60,ETH1_MDIO
set_property  -dict {PACKAGE_PIN  G7    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxclk]             ; ## U1,G7,IO_L12_MRCC_34_JX4_P,JX4,46,ETH1_RX_CLK
set_property  -dict {PACKAGE_PIN  F7    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxctl]             ; ## U1,F7,IO_L12_MRCC_34_JX4_N,JX4,48,ETH1_RX_CTRL
set_property  -dict {PACKAGE_PIN  E6    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxdata[0]]         ; ## U1,E6,IO_L10_34_JX4_P,JX4,42,ETH1_RXD0
set_property  -dict {PACKAGE_PIN  D5    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxdata[1]]         ; ## U1,D5,IO_L10_34_JX4_N,JX4,44,ETH1_RXD1
set_property  -dict {PACKAGE_PIN  F8    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxdata[2]]         ; ## U1,F8,IO_L11_SRCC_34_JX4_P,JX4,45,ETH1_RXD2
set_property  -dict {PACKAGE_PIN  E7    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxdata[3]]         ; ## U1,E7,IO_L11_SRCC_34_JX4_N,JX4,47,ETH1_RXD3
set_property  -dict {PACKAGE_PIN  C8    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txclk]             ; ## U1,C8,IO_L13_MRCC_34_JX4_P,JX4,51,ETH1_TX_CLK
set_property  -dict {PACKAGE_PIN  C7    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txctl]             ; ## U1,C7,IO_L13_MRCC_34_JX4_N,JX4,53,ETH1_TX_CTRL
set_property  -dict {PACKAGE_PIN  D6    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txdata[0]]         ; ## U1,D6,IO_L14_SRCC_34_JX4_P,JX4,52,ETH1_TXD0
set_property  -dict {PACKAGE_PIN  C6    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txdata[1]]         ; ## U1,C6,IO_L14_SRCC_34_JX4_N,JX4,54,ETH1_TXD1
set_property  -dict {PACKAGE_PIN  C9    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txdata[2]]         ; ## U1,C9,IO_L15_34_JX4_P,JX4,57,ETH1_TXD2
set_property  -dict {PACKAGE_PIN  B9    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txdata[3]]         ; ## U1,B9,IO_L15_34_JX4_N,JX4,59,ETH1_TXD3

# hdmi

set_property  -dict {PACKAGE_PIN  L3    IOSTANDARD LVCMOS18}             [get_ports hdmi_out_clk]     ; ## U1,L3,IO_L11_SRCC_33_JX1_P,JX1,74,HDMI_CLK
set_property  -dict {PACKAGE_PIN  D4    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_vsync]       ; ## U1,D4,IO_L02_33_JX1_P,JX1,41,HDMI_VSYNC
set_property  -dict {PACKAGE_PIN  D3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_hsync]       ; ## U1,D3,IO_L02_33_JX1_N,JX1,43,HDMI_HSYNC
set_property  -dict {PACKAGE_PIN  K3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data_e]      ; ## U1,K3,IO_L11_SRCC_33_JX1_N,JX1,76,HDMI_DE
set_property  -dict {PACKAGE_PIN  G2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[0]]     ; ## U1,G2,IO_L03_33_JX1_P,JX1,42,HDMI_D20
set_property  -dict {PACKAGE_PIN  F2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[1]]     ; ## U1,F2,IO_L03_33_JX1_N,JX1,44,HDMI_D21
set_property  -dict {PACKAGE_PIN  D1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[2]]     ; ## U1,D1,IO_L04_33_JX1_P,JX1,47,HDMI_D22
set_property  -dict {PACKAGE_PIN  C1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[3]]     ; ## U1,C1,IO_L04_33_JX1_N,JX1,49,HDMI_D23
set_property  -dict {PACKAGE_PIN  E2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[4]]     ; ## U1,E2,IO_L05_33_JX1_P,JX1,54,HDMI_D24
set_property  -dict {PACKAGE_PIN  E1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[5]]     ; ## U1,E1,IO_L05_33_JX1_N,JX1,56,HDMI_D25
set_property  -dict {PACKAGE_PIN  F3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[6]]     ; ## U1,F3,IO_L06_33_JX1_P,JX1,61,HDMI_D26
set_property  -dict {PACKAGE_PIN  E3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[7]]     ; ## U1,E3,IO_L06_33_JX1_N,JX1,63,HDMI_D27
set_property  -dict {PACKAGE_PIN  J1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[8]]     ; ## U1,J1,IO_L07_33_JX1_P,JX1,62,HDMI_D28
set_property  -dict {PACKAGE_PIN  H1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[9]]     ; ## U1,H1,IO_L07_33_JX1_N,JX1,64,HDMI_D29
set_property  -dict {PACKAGE_PIN  H4    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[10]]    ; ## U1,H4,IO_L08_33_JX1_P,JX1,67,HDMI_D30
set_property  -dict {PACKAGE_PIN  H3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[11]]    ; ## U1,H3,IO_L08_33_JX1_N,JX1,69,HDMI_D31
set_property  -dict {PACKAGE_PIN  K2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[12]]    ; ## U1,K2,IO_L09_33_JX1_P,JX1,68,HDMI_D32
set_property  -dict {PACKAGE_PIN  K1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[13]]    ; ## U1,K1,IO_L09_33_JX1_N,JX1,70,HDMI_D33
set_property  -dict {PACKAGE_PIN  H2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[14]]    ; ## U1,H2,IO_L10_33_JX1_P,JX1,73,HDMI_D34
set_property  -dict {PACKAGE_PIN  G1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[15]]    ; ## U1,G1,IO_L10_33_JX1_N,JX1,75,HDMI_D35
set_property  -dict {PACKAGE_PIN  L9    IOSTANDARD LVCMOS18}             [get_ports hdmi_pd]          ; ## U1,L9,IO_00_33_JX1,JX1,9,HDMI_PD
set_property  -dict {PACKAGE_PIN  N8    IOSTANDARD LVCMOS18}             [get_ports hdmi_intn]        ; ## U1,N8,IO_25_33_JX1,JX1,10,HDMI_INTN

# hdmi-spdif

set_property  -dict {PACKAGE_PIN  G4    IOSTANDARD LVCMOS18} [get_ports spdif]                        ; ## U1,G4,IO_L01_33_JX1_P,JX1,35,HDMI_SPDIF
set_property  -dict {PACKAGE_PIN  F4    IOSTANDARD LVCMOS18} [get_ports spdif_in]                     ; ## U1,F4,IO_L01_33_JX1_N,JX1,37,HDMI_SPDIF_OUT

# audio

set_property  -dict {PACKAGE_PIN  J8    IOSTANDARD LVCMOS18} [get_ports i2s_mclk]                     ; ## U1,J8,IO_L06_34_JX4_P,JX4,32,I2S_MCLK
set_property  -dict {PACKAGE_PIN  H8    IOSTANDARD LVCMOS18} [get_ports i2s_bclk]                     ; ## U1,H8,IO_L06_34_JX4_N,JX4,34,I2S_BCLK
set_property  -dict {PACKAGE_PIN  F5    IOSTANDARD LVCMOS18} [get_ports i2s_lrclk]                    ; ## U1,F5,IO_L07_34_JX4_P,JX4,35,I2S_LRCLK
set_property  -dict {PACKAGE_PIN  E5    IOSTANDARD LVCMOS18} [get_ports i2s_sdata_out]                ; ## U1,E5,IO_L07_34_JX4_N,JX4,37,I2S_SDATA_OUT
set_property  -dict {PACKAGE_PIN  D9    IOSTANDARD LVCMOS18} [get_ports i2s_sdata_in]                 ; ## U1,D9,IO_L08_34_JX4_P,JX4,36,I2S_SDATA_IN

# ad9517

set_property  -dict {PACKAGE_PIN  B4    IOSTANDARD LVCMOS18} [get_ports ad9517_csn]                   ; ## U1,B4,IO_L20_34_JX4_N,JX4,76,PMOD1_D3
set_property  -dict {PACKAGE_PIN  C4    IOSTANDARD LVCMOS18} [get_ports ad9517_clk]                   ; ## U1,C4,IO_L19_34_JX4_P,JX4,73,PMOD1_D0
set_property  -dict {PACKAGE_PIN  C3    IOSTANDARD LVCMOS18} [get_ports ad9517_mosi]                  ; ## U1,C3,IO_L19_34_JX4_N,JX4,75,PMOD1_D1
set_property  -dict {PACKAGE_PIN  B5    IOSTANDARD LVCMOS18} [get_ports ad9517_miso]                  ; ## U1,B5,IO_L20_34_JX4_P,JX4,74,PMOD1_D2
set_property  -dict {PACKAGE_PIN  B6    IOSTANDARD LVCMOS18} [get_ports ad9517_pdn]                   ; ## U1,B6,IO_L21_34_JX4_P,JX4,77,PMOD1_D4
set_property  -dict {PACKAGE_PIN  A5    IOSTANDARD LVCMOS18} [get_ports ad9517_ref_sel]               ; ## U1,A5,IO_L21_34_JX4_N,JX4,79,PMOD1_D5
set_property  -dict {PACKAGE_PIN  A4    IOSTANDARD LVCMOS18} [get_ports ad9517_ld]                    ; ## U1,A4,IO_L22_34_JX4_P,JX4,78,PMOD1_D6
set_property  -dict {PACKAGE_PIN  A3    IOSTANDARD LVCMOS18} [get_ports ad9517_status]                ; ## U1,A3,IO_L22_34_JX4_N,JX4,80,PMOD1_D7

# clocks

create_clock -period 8.000 -name eth1_rgmii_rxclk [get_ports eth1_rgmii_rxclk]

# bad ip- we have to do this

set_property IDELAY_VALUE 16 \
  [get_cells -hier -filter {name =~ *delay_rgmii_rxd*}] \
  [get_cells -hier -filter {name =~ *delay_rgmii_rx_ctl}]

set_property IODELAY_GROUP gmii2rgmii_iodelay_group\
  [get_cells -hier -filter {name =~ *idelayctrl}] \
  [get_cells -hier -filter {name =~ *delay_rgmii_rxd*}] \
  [get_cells -hier -filter {name =~ *delay_rgmii_rx_ctl}]

# fan control/sense

set_property  -dict {PACKAGE_PIN  B7    IOSTANDARD LVCMOS18} [get_ports fan_pwm]                      ; ## U1,B7,IO_L18_34_JX4_P,JX4,68,FAN_PWM
set_property  -dict {PACKAGE_PIN  A7    IOSTANDARD LVCMOS18} [get_ports fan_tach]                     ; ## U1,A7,IO_L18_34_JX4_N,JX4,70,FAN_TACH

## led, push buttons, dip switches

set_property  -dict {PACKAGE_PIN  J3    IOSTANDARD LVCMOS18} [get_ports gpio_bd[0]]                   ; ## U1,J3,IO_L12_MRCC_33_JX1_N,JX1,83,PB_GPIO_0
set_property  -dict {PACKAGE_PIN  D8    IOSTANDARD LVCMOS18} [get_ports gpio_bd[1]]                   ; ## U1,D8,IO_L08_34_JX4_N,JX4,38,PB_GPIO_1
set_property  -dict {PACKAGE_PIN  F9    IOSTANDARD LVCMOS18} [get_ports gpio_bd[2]]                   ; ## U1,F9,IO_L09_34_JX4_P,JX4,41,PB_GPIO_2
set_property  -dict {PACKAGE_PIN  E8    IOSTANDARD LVCMOS18} [get_ports gpio_bd[3]]                   ; ## U1,E8,IO_L09_34_JX4_N,JX4,43,PB_GPIO_3
set_property  -dict {PACKAGE_PIN  A8    IOSTANDARD LVCMOS18} [get_ports gpio_bd[4]]                   ; ## U1,A8,IO_L17_34_JX4_N,JX4,69,LED_GPIO_0
set_property  -dict {PACKAGE_PIN  W14   IOSTANDARD LVCMOS25} [get_ports gpio_bd[5]]                   ; ## U1,W14,IO_00_12_JX4,JX4,14,LED_GPIO_1
set_property  -dict {PACKAGE_PIN  W17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[6]]                   ; ## U1,W17,IO_25_12_JX4,JX4,16,LED_GPIO_2
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVCMOS25} [get_ports gpio_bd[7]]                   ; ## U1,Y16,IO_L23_12_JX2_P,JX2,97,LED_GPIO_3
set_property  -dict {PACKAGE_PIN  Y15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[8]]                   ; ## U1,Y15,IO_L23_12_JX2_N,JX2,99,DIP_GPIO_0
set_property  -dict {PACKAGE_PIN  W16   IOSTANDARD LVCMOS25} [get_ports gpio_bd[9]]                   ; ## U1,W16,IO_L24_12_JX4_P,JX4,13,DIP_GPIO_1
set_property  -dict {PACKAGE_PIN  W15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[10]]                  ; ## U1,W15,IO_L24_12_JX4_N,JX4,15,DIP_GPIO_2
set_property  -dict {PACKAGE_PIN  V19   IOSTANDARD LVCMOS25} [get_ports gpio_bd[11]]                  ; ## U1,V19,IO_00_13_JX2,JX2,13,DIP_GPIO_3

## orphans (ps7- gpio)

set_property  -dict {PACKAGE_PIN  V18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[12]]                  ; ## U1,V18,IO_25_13_JX2,JX2,14,FMC_PRSNT
set_property  -dict {PACKAGE_PIN  AC19  IOSTANDARD LVCMOS25} [get_ports gpio_bd[13]]                  ; ## U1,AC19,IO_L21_13_JX2_N,JX2,69,PMOD0_D1,R103,1
set_property  -dict {PACKAGE_PIN  Y17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[14]]                  ; ## U1,Y17,IO_L19_12_JX2_P,JX2,88,SFP_GPIO_0
set_property  -dict {PACKAGE_PIN  AA17  IOSTANDARD LVCMOS25} [get_ports gpio_bd[15]]                  ; ## U1,AA17,IO_L19_12_JX2_N,JX2,90,SFP_GPIO_1
set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVCMOS25} [get_ports gpio_bd[16]]                  ; ## U1,AB17,IO_L20_12_JX2_P,JX2,87,SFP_GPIO_2
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVCMOS25} [get_ports gpio_bd[17]]                  ; ## U1,AB16,IO_L20_12_JX2_N,JX2,89,SFP_GPIO_3
set_property  -dict {PACKAGE_PIN  AC17  IOSTANDARD LVCMOS25} [get_ports gpio_bd[18]]                  ; ## U1,AC17,IO_L21_12_JX2_P,JX2,93,SFP_GPIO_4
set_property  -dict {PACKAGE_PIN  AC16  IOSTANDARD LVCMOS25} [get_ports gpio_bd[19]]                  ; ## U1,AC16,IO_L21_12_JX2_N,JX2,95,SFP_GPIO_5
set_property  -dict {PACKAGE_PIN  AA15  IOSTANDARD LVCMOS25} [get_ports gpio_bd[20]]                  ; ## U1,AA15,IO_L22_12_JX2_P,JX2,94,SFP_GPIO_6

# unused io (clocks & gt)

set_property  -dict {PACKAGE_PIN  AC14  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports clk_0_p]        ; ## U1,AC14,IO_L13_MRCC_12_JX3_P,JX3,91,FMC_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AD14  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports clk_0_n]        ; ## U1,AD14,IO_L13_MRCC_12_JX3_N,JX3,93,FMC_CLK0_M2C_N
set_property  -dict {PACKAGE_PIN  AD20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports clk_1_p]        ; ## U1,AD20,IO_L13_MRCC_13_JX2_P,JX2,41,FMC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports clk_1_n]        ; ## U1,AD21,IO_L13_MRCC_13_JX2_N,JX2,43,FMC_CLK1_M2C_N

set_property  -dict {PACKAGE_PIN  R6}   [get_ports gt_ref_clk_0_p]                                    ; ## U1,R6,UNNAMED_7_CAP_I123_N2,JX1,87,MGTREFCLK0_112_JX1_P
set_property  -dict {PACKAGE_PIN  R5}   [get_ports gt_ref_clk_0_n]                                    ; ## U1,R5,UNNAMED_7_CAP_I125_N2,JX1,89,MGTREFCLK0_112_JX1_N
set_property  -dict {PACKAGE_PIN  U6}   [get_ports gt_ref_clk_1_p]                                    ; ## U1,U6,UNNAMED_7_CAP_I126_N2,JX3,2,MGTREFCLK1_112_JX3_P
set_property  -dict {PACKAGE_PIN  U5}   [get_ports gt_ref_clk_1_n]                                    ; ## U1,U5,UNNAMED_7_CAP_I124_N2,JX3,4,MGTREFCLK1_112_JX3_N
set_property  -dict {PACKAGE_PIN  AA2}  [get_ports gt_tx_p[0]]                                        ; ## U1,AA2,MGTXTX0_112_JX3_P,JX3,8,FMC_GBT_TX_P,P2,C2
set_property  -dict {PACKAGE_PIN  AA1}  [get_ports gt_tx_n[0]]                                        ; ## U1,AA1,MGTXTX0_112_JX3_N,JX3,10,FMC_GBT_TX_N,P2,C3
set_property  -dict {PACKAGE_PIN  AB4}  [get_ports gt_rx_p[0]]                                        ; ## U1,AB4,MGTXRX0_112_JX1_P,JX1,88,FMC_GBT_RX_P,P2,C6
set_property  -dict {PACKAGE_PIN  AB3}  [get_ports gt_rx_n[0]]                                        ; ## U1,AB3,MGTXRX0_112_JX1_N,JX1,90,FMC_GBT_RX_N,P2,C7
set_property  -dict {PACKAGE_PIN  AF4}  [get_ports gt_tx_p[1]]                                        ; ## U1,Y4,MGTXRX1_112_JX1_P,JX1,91,SFP_GBT_RX_P,P1,13
set_property  -dict {PACKAGE_PIN  AF3}  [get_ports gt_tx_n[1]]                                        ; ## U1,Y3,MGTXRX1_112_JX1_N,JX1,93,SFP_GBT_RX_N,P1,12
set_property  -dict {PACKAGE_PIN  AE6}  [get_ports gt_rx_p[1]]                                        ; ## U1,W2,MGTXTX1_112_JX3_P,JX3,13,SFP_GBT_TX_P,P1,18
set_property  -dict {PACKAGE_PIN  AE5}  [get_ports gt_rx_n[1]]                                        ; ## U1,W1,MGTXTX1_112_JX3_N,JX3,15,SFP_GBT_TX_N,P1,19

## clocks

create_clock -name ref_clk_0      -period  4.00 [get_ports gt_ref_clk_0_p]
create_clock -name ref_clk_1      -period  4.00 [get_ports gt_ref_clk_1_p]
create_clock -name clk0           -period  4.00 [get_ports clk_0_p]
create_clock -name clk1           -period  4.00 [get_ports clk_1_p]
create_clock -name xcvr_clk_0     -period  8.00 [get_pins i_system_wrapper/system_i/axi_pz_xcvrlb/inst/g_lanes[0].i_xcvrlb_1/i_xch/i_gtxe2_channel/RXOUTCLK]
create_clock -name xcvr_clk_1     -period  8.00 [get_pins i_system_wrapper/system_i/axi_pz_xcvrlb/inst/g_lanes[1].i_xcvrlb_1/i_xch/i_gtxe2_channel/RXOUTCLK]

## loopback (regular io- fmc)

set_property  -dict {PACKAGE_PIN  AC13  IOSTANDARD LVCMOS25} [get_ports gp_out[0]]                    ; ## U1,AC13,IO_L12_MRCC_12_JX3_P,JX3,86,FMC_LA00_CC_P,P2,G6
set_property  -dict {PACKAGE_PIN  AD13  IOSTANDARD LVCMOS25} [get_ports gp_out[1]]                    ; ## U1,AD13,IO_L12_MRCC_12_JX3_N,JX3,88,FMC_LA00_CC_N,P2,G7
set_property  -dict {PACKAGE_PIN  AC12  IOSTANDARD LVCMOS25} [get_ports gp_out[2]]                    ; ## U1,AC12,IO_L11_SRCC_12_JX3_P,JX3,85,FMC_LA01_CC_P,P2,D8
set_property  -dict {PACKAGE_PIN  AD11  IOSTANDARD LVCMOS25} [get_ports gp_out[3]]                    ; ## U1,AD11,IO_L11_SRCC_12_JX3_N,JX3,87,FMC_LA01_CC_N,P2,D9
set_property  -dict {PACKAGE_PIN  Y12   IOSTANDARD LVCMOS25} [get_ports gp_out[4]]                    ; ## U1,Y12,IO_L01_12_JX3_P,JX3,20,FMC_LA02_P,P2,H7
set_property  -dict {PACKAGE_PIN  Y11   IOSTANDARD LVCMOS25} [get_ports gp_out[5]]                    ; ## U1,Y11,IO_L01_12_JX3_N,JX3,22,FMC_LA02_N,P2,H8
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS25} [get_ports gp_out[6]]                    ; ## U1,AB12,IO_L02_12_JX3_P,JX3,25,FMC_LA03_P,P2,G9
set_property  -dict {PACKAGE_PIN  AC11  IOSTANDARD LVCMOS25} [get_ports gp_out[7]]                    ; ## U1,AC11,IO_L02_12_JX3_N,JX3,27,FMC_LA03_N,P2,G10
set_property  -dict {PACKAGE_PIN  Y10   IOSTANDARD LVCMOS25} [get_ports gp_out[8]]                    ; ## U1,Y10,IO_L03_12_JX3_P,JX3,26,FMC_LA04_P,P2,H10
set_property  -dict {PACKAGE_PIN  AA10  IOSTANDARD LVCMOS25} [get_ports gp_out[9]]                    ; ## U1,AA10,IO_L03_12_JX3_N,JX3,28,FMC_LA04_N,P2,H11
set_property  -dict {PACKAGE_PIN  AB11  IOSTANDARD LVCMOS25} [get_ports gp_out[10]]                   ; ## U1,AB11,IO_L04_12_JX3_P,JX3,31,FMC_LA05_P,P2,D11
set_property  -dict {PACKAGE_PIN  AB10  IOSTANDARD LVCMOS25} [get_ports gp_out[11]]                   ; ## U1,AB10,IO_L04_12_JX3_N,JX3,33,FMC_LA05_N,P2,D12
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD LVCMOS25} [get_ports gp_out[12]]                   ; ## U1,W13,IO_L05_12_JX3_P,JX3,42,FMC_LA06_P,P2,C10
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD LVCMOS25} [get_ports gp_out[13]]                   ; ## U1,Y13,IO_L05_12_JX3_N,JX3,44,FMC_LA06_N,P2,C11
set_property  -dict {PACKAGE_PIN  AA13  IOSTANDARD LVCMOS25} [get_ports gp_out[14]]                   ; ## U1,AA13,IO_L06_12_JX3_P,JX3,64,FMC_LA07_P,P2,H13
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS25} [get_ports gp_out[15]]                   ; ## U1,AA12,IO_L06_12_JX3_N,JX3,66,FMC_LA07_N,P2,H14
set_property  -dict {PACKAGE_PIN  AE10  IOSTANDARD LVCMOS25} [get_ports gp_out[16]]                   ; ## U1,AE10,IO_L07_12_JX3_P,JX3,73,FMC_LA08_P,P2,G12
set_property  -dict {PACKAGE_PIN  AD10  IOSTANDARD LVCMOS25} [get_ports gp_out[17]]                   ; ## U1,AD10,IO_L07_12_JX3_N,JX3,75,FMC_LA08_N,P2,G13
set_property  -dict {PACKAGE_PIN  AE12  IOSTANDARD LVCMOS25} [get_ports gp_out[18]]                   ; ## U1,AE12,IO_L08_12_JX3_P,JX3,74,FMC_LA09_P,P2,D14
set_property  -dict {PACKAGE_PIN  AF12  IOSTANDARD LVCMOS25} [get_ports gp_out[19]]                   ; ## U1,AF12,IO_L08_12_JX3_N,JX3,76,FMC_LA09_N,P2,D15
set_property  -dict {PACKAGE_PIN  AE11  IOSTANDARD LVCMOS25} [get_ports gp_out[20]]                   ; ## U1,AE11,IO_L09_12_JX3_P,JX3,79,FMC_LA10_P,P2,C14
set_property  -dict {PACKAGE_PIN  AF10  IOSTANDARD LVCMOS25} [get_ports gp_out[21]]                   ; ## U1,AF10,IO_L09_12_JX3_N,JX3,81,FMC_LA10_N,P2,C15
set_property  -dict {PACKAGE_PIN  AE13  IOSTANDARD LVCMOS25} [get_ports gp_out[22]]                   ; ## U1,AE13,IO_L10_12_JX3_P,JX3,80,FMC_LA11_P,P2,H16
set_property  -dict {PACKAGE_PIN  AF13  IOSTANDARD LVCMOS25} [get_ports gp_out[23]]                   ; ## U1,AF13,IO_L10_12_JX3_N,JX3,82,FMC_LA11_N,P2,H17
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS25} [get_ports gp_out[24]]                   ; ## U1,AB15,IO_L14_SRCC_12_JX3_P,JX3,92,FMC_LA12_P,P2,G15
set_property  -dict {PACKAGE_PIN  AB14  IOSTANDARD LVCMOS25} [get_ports gp_out[25]]                   ; ## U1,AB14,IO_L14_SRCC_12_JX3_N,JX3,94,FMC_LA12_N,P2,G16
set_property  -dict {PACKAGE_PIN  AD16  IOSTANDARD LVCMOS25} [get_ports gp_out[26]]                   ; ## U1,AD16,IO_L15_12_JX3_P,JX3,97,FMC_LA13_P,P2,D17
set_property  -dict {PACKAGE_PIN  AD15  IOSTANDARD LVCMOS25} [get_ports gp_out[27]]                   ; ## U1,AD15,IO_L15_12_JX3_N,JX3,99,FMC_LA13_N,P2,D18
set_property  -dict {PACKAGE_PIN  AF15  IOSTANDARD LVCMOS25} [get_ports gp_out[28]]                   ; ## U1,AF15,IO_L16_12_JX3_P,JX3,98,FMC_LA14_P,P2,C18
set_property  -dict {PACKAGE_PIN  AF14  IOSTANDARD LVCMOS25} [get_ports gp_out[29]]                   ; ## U1,AF14,IO_L16_12_JX3_N,JX3,100,FMC_LA14_N,P2,C19
set_property  -dict {PACKAGE_PIN  AE16  IOSTANDARD LVCMOS25} [get_ports gp_out[30]]                   ; ## U1,AE16,IO_L17_12_JX2_P,JX2,82,FMC_LA15_P,P2,H19
set_property  -dict {PACKAGE_PIN  AE15  IOSTANDARD LVCMOS25} [get_ports gp_out[31]]                   ; ## U1,AE15,IO_L17_12_JX2_N,JX2,84,FMC_LA15_N,P2,H20
set_property  -dict {PACKAGE_PIN  AE17  IOSTANDARD LVCMOS25} [get_ports gp_out[32]]                   ; ## U1,AE17,IO_L18_12_JX2_P,JX2,81,FMC_LA16_P,P2,G18
set_property  -dict {PACKAGE_PIN  AF17  IOSTANDARD LVCMOS25} [get_ports gp_out[33]]                   ; ## U1,AF17,IO_L18_12_JX2_N,JX2,83,FMC_LA16_N,P2,G19
set_property  -dict {PACKAGE_PIN  AC23  IOSTANDARD LVCMOS25} [get_ports gp_in[0]]                     ; ## U1,AC23,IO_L12_MRCC_13_JX2_P,JX2,36,FMC_LA17_CC_P,P2,D20
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVCMOS25} [get_ports gp_in[1]]                     ; ## U1,AC24,IO_L12_MRCC_13_JX2_N,JX2,38,FMC_LA17_CC_N,P2,D21
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports gp_in[2]]                     ; ## U1,AD23,IO_L11_SRCC_13_JX2_P,JX2,35,FMC_LA18_CC_P,P2,C22
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS25} [get_ports gp_in[3]]                     ; ## U1,AD24,IO_L11_SRCC_13_JX2_N,JX2,37,FMC_LA18_CC_N,P2,C23
set_property  -dict {PACKAGE_PIN  AA25  IOSTANDARD LVCMOS25} [get_ports gp_in[4]]                     ; ## U1,AA25,IO_L01_13_JX2_P,JX2,1,FMC_LA19_P,P2,H22
set_property  -dict {PACKAGE_PIN  AB25  IOSTANDARD LVCMOS25} [get_ports gp_in[5]]                     ; ## U1,AB25,IO_L01_13_JX2_N,JX2,3,FMC_LA19_N,P2,H23
set_property  -dict {PACKAGE_PIN  AB26  IOSTANDARD LVCMOS25} [get_ports gp_in[6]]                     ; ## U1,AB26,IO_L02_13_JX2_P,JX2,2,FMC_LA20_P,P2,G21
set_property  -dict {PACKAGE_PIN  AC26  IOSTANDARD LVCMOS25} [get_ports gp_in[7]]                     ; ## U1,AC26,IO_L02_13_JX2_N,JX2,4,FMC_LA20_N,P2,G22
set_property  -dict {PACKAGE_PIN  AE25  IOSTANDARD LVCMOS25} [get_ports gp_in[8]]                     ; ## U1,AE25,IO_L03_13_JX2_P,JX2,5,FMC_LA21_P,P2,H25
set_property  -dict {PACKAGE_PIN  AE26  IOSTANDARD LVCMOS25} [get_ports gp_in[9]]                     ; ## U1,AE26,IO_L03_13_JX2_N,JX2,7,FMC_LA21_N,P2,H26
set_property  -dict {PACKAGE_PIN  AD25  IOSTANDARD LVCMOS25} [get_ports gp_in[10]]                    ; ## U1,AD25,IO_L04_13_JX2_P,JX2,6,FMC_LA22_P,P2,G24
set_property  -dict {PACKAGE_PIN  AD26  IOSTANDARD LVCMOS25} [get_ports gp_in[11]]                    ; ## U1,AD26,IO_L04_13_JX2_N,JX2,8,FMC_LA22_N,P2,G25
set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD LVCMOS25} [get_ports gp_in[12]]                    ; ## U1,AA24,IO_L06_13_JX2_P,JX2,18,FMC_LA23_P,P2,D23
set_property  -dict {PACKAGE_PIN  AB24  IOSTANDARD LVCMOS25} [get_ports gp_in[13]]                    ; ## U1,AB24,IO_L06_13_JX2_N,JX2,20,FMC_LA23_N,P2,D24
set_property  -dict {PACKAGE_PIN  AE22  IOSTANDARD LVCMOS25} [get_ports gp_in[14]]                    ; ## U1,AE22,IO_L07_13_JX2_P,JX2,23,FMC_LA24_P,P2,H28
set_property  -dict {PACKAGE_PIN  AF22  IOSTANDARD LVCMOS25} [get_ports gp_in[15]]                    ; ## U1,AF22,IO_L07_13_JX2_N,JX2,25,FMC_LA24_N,P2,H29
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports gp_in[16]]                    ; ## U1,AE23,IO_L08_13_JX2_P,JX2,24,FMC_LA25_P,P2,G27
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS25} [get_ports gp_in[17]]                    ; ## U1,AF23,IO_L08_13_JX2_N,JX2,26,FMC_LA25_N,P2,G28
set_property  -dict {PACKAGE_PIN  AB21  IOSTANDARD LVCMOS25} [get_ports gp_in[18]]                    ; ## U1,AB21,IO_L09_13_JX2_P,JX2,29,FMC_LA26_P,P2,D26
set_property  -dict {PACKAGE_PIN  AB22  IOSTANDARD LVCMOS25} [get_ports gp_in[19]]                    ; ## U1,AB22,IO_L09_13_JX2_N,JX2,31,FMC_LA26_N,P2,D27
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS25} [get_ports gp_in[20]]                    ; ## U1,AA22,IO_L10_13_JX2_P,JX2,30,FMC_LA27_P,P2,C26
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVCMOS25} [get_ports gp_in[21]]                    ; ## U1,AA23,IO_L10_13_JX2_N,JX2,32,FMC_LA27_N,P2,C27
set_property  -dict {PACKAGE_PIN  AC21  IOSTANDARD LVCMOS25} [get_ports gp_in[22]]                    ; ## U1,AC21,IO_L14_SRCC_13_JX2_P,JX2,42,FMC_LA28_P,P2,H31
set_property  -dict {PACKAGE_PIN  AC22  IOSTANDARD LVCMOS25} [get_ports gp_in[23]]                    ; ## U1,AC22,IO_L14_SRCC_13_JX2_N,JX2,44,FMC_LA28_N,P2,H32
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports gp_in[24]]                    ; ## U1,AF19,IO_L15_13_JX2_P,JX2,47,FMC_LA29_P,P2,G30
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVCMOS25} [get_ports gp_in[25]]                    ; ## U1,AF20,IO_L15_13_JX2_N,JX2,49,FMC_LA29_N,P2,G31
set_property  -dict {PACKAGE_PIN  AE20  IOSTANDARD LVCMOS25} [get_ports gp_in[26]]                    ; ## U1,AE20,IO_L16_13_JX2_P,JX2,48,FMC_LA30_P,P2,H34
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports gp_in[27]]                    ; ## U1,AE21,IO_L16_13_JX2_N,JX2,50,FMC_LA30_N,P2,H35
set_property  -dict {PACKAGE_PIN  AD18  IOSTANDARD LVCMOS25} [get_ports gp_in[28]]                    ; ## U1,AD18,IO_L17_13_JX2_P,JX2,53,FMC_LA31_P,P2,G33
set_property  -dict {PACKAGE_PIN  AD19  IOSTANDARD LVCMOS25} [get_ports gp_in[29]]                    ; ## U1,AD19,IO_L17_13_JX2_N,JX2,55,FMC_LA31_N,P2,G34
set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS25} [get_ports gp_in[30]]                    ; ## U1,AE18,IO_L18_13_JX2_P,JX2,54,FMC_LA32_P,P2,H37
set_property  -dict {PACKAGE_PIN  AF18  IOSTANDARD LVCMOS25} [get_ports gp_in[31]]                    ; ## U1,AF18,IO_L18_13_JX2_N,JX2,56,FMC_LA32_N,P2,H38
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD LVCMOS25} [get_ports gp_in[32]]                    ; ## U1,W20,IO_L19_13_JX2_P,JX2,61,FMC_LA33_P,P2,G36
set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD LVCMOS25} [get_ports gp_in[33]]                    ; ## U1,Y20,IO_L19_13_JX2_N,JX2,63,FMC_LA33_N,P2,G37

## loopback (regular io- pmod)
## U1,C24,PS_MIO15_500_JX4,JX4,85,PMOD_MIO_D0
## U1,A25,PS_MIO10_500_JX4,JX4,87,PMOD_MIO_D1
## U1,B26,PS_MIO11_500_JX4,JX4,88,PMOD_MIO_D3
## U1,B25,PS_MIO13_500_JX4,JX4,91,PMOD_MIO_D4
## U1,D23,PS_MIO14_500_JX4,JX4,93,PMOD_MIO_D5
## U1,E17,PS_MIO46_501_JX4,JX4,92,PMOD_MIO_D6
## U1,B19,PS_MIO47_501_JX4,JX4,94,PMOD_MIO_D7

set_property  -dict {PACKAGE_PIN  AC18  IOSTANDARD LVCMOS25} [get_ports gp_out[34]]                   ; ## U1,AC18,IO_L21_13_JX2_P,JX2,67,PMOD0_D0,R95,1
set_property  -dict {PACKAGE_PIN  AA19  IOSTANDARD LVCMOS25} [get_ports gp_out[35]]                   ; ## U1,AA19,IO_L22_13_JX2_P,JX2,68,PMOD0_D2,R96,1
set_property  -dict {PACKAGE_PIN  AB19  IOSTANDARD LVCMOS25} [get_ports gp_out[36]]                   ; ## U1,AB19,IO_L22_13_JX2_N,JX2,70,PMOD0_D3,R104,1
set_property  -dict {PACKAGE_PIN  W18   IOSTANDARD LVCMOS25} [get_ports gp_in[34]]                    ; ## U1,W18,IO_L23_13_JX2_P,JX2,73,PMOD0_D4,R97,1
set_property  -dict {PACKAGE_PIN  Y18   IOSTANDARD LVCMOS25} [get_ports gp_in[35]]                    ; ## U1,Y18,IO_L24_13_JX2_P,JX2,74,PMOD0_D6,R98,1
set_property  -dict {PACKAGE_PIN  AA18  IOSTANDARD LVCMOS25} [get_ports gp_in[36]]                    ; ## U1,AA18,IO_L24_13_JX2_N,JX2,76,PMOD0_D7,R106,1

## loopback (regular io- camera)

set_property  -dict {PACKAGE_PIN  G6    IOSTANDARD LVCMOS18} [get_ports gp_out[37]]                   ; ## U1,G6,IO_L02_34_JX4_P,JX4,20,CAM_GPIO_2,P9,B23
set_property  -dict {PACKAGE_PIN  G5    IOSTANDARD LVCMOS18} [get_ports gp_out[38]]                   ; ## U1,G5,IO_L02_34_JX4_N,JX4,22,CAM_GPIO_3,P9,B24
set_property  -dict {PACKAGE_PIN  H7    IOSTANDARD LVCMOS18} [get_ports gp_out[39]]                   ; ## U1,H7,IO_L04_34_JX4_P,JX4,26,CAM_GPIO_6,P9,B27
set_property  -dict {PACKAGE_PIN  H6    IOSTANDARD LVCMOS18} [get_ports gp_out[40]]                   ; ## U1,H6,IO_L04_34_JX4_N,JX4,28,CAM_GPIO_7,P9,B29
set_property  -dict {PACKAGE_PIN  N3    IOSTANDARD LVCMOS18} [get_ports gp_out[41]]                   ; ## U1,N3,IO_L15_33_JX1_P,JX1,53,CAM_DATA0_P,P9,A7
set_property  -dict {PACKAGE_PIN  N2    IOSTANDARD LVCMOS18} [get_ports gp_out[42]]                   ; ## U1,N2,IO_L15_33_JX1_N,JX1,55,CAM_DATA0_N,P9,A8
set_property  -dict {PACKAGE_PIN  N4    IOSTANDARD LVCMOS18} [get_ports gp_out[43]]                   ; ## U1,N4,IO_L17_33_JX1_P,JX1,12,CAM_DATA2_P,P9,A13
set_property  -dict {PACKAGE_PIN  M4    IOSTANDARD LVCMOS18} [get_ports gp_out[44]]                   ; ## U1,M4,IO_L17_33_JX1_N,JX1,14,CAM_DATA2_N,P9,A14
set_property  -dict {PACKAGE_PIN  M7    IOSTANDARD LVCMOS18} [get_ports gp_out[45]]                   ; ## U1,M7,IO_L19_33_JX1_P,JX1,18,CAM_DATA4_P,P9,A19
set_property  -dict {PACKAGE_PIN  L7    IOSTANDARD LVCMOS18} [get_ports gp_out[46]]                   ; ## U1,L7,IO_L19_33_JX1_N,JX1,20,CAM_DATA4_N,P9,A20
set_property  -dict {PACKAGE_PIN  M8    IOSTANDARD LVCMOS18} [get_ports gp_out[47]]                   ; ## U1,M8,IO_L21_33_JX1_P,JX1,24,CAM_DATA6_P,P9,A25
set_property  -dict {PACKAGE_PIN  L8    IOSTANDARD LVCMOS18} [get_ports gp_out[48]]                   ; ## U1,L8,IO_L21_33_JX1_N,JX1,26,CAM_DATA6_N,P9,A26
set_property  -dict {PACKAGE_PIN  L5    IOSTANDARD LVCMOS18} [get_ports gp_out[49]]                   ; ## U1,L5,IO_L14_SRCC_33_JX1_P,JX1,48,CAM_SYNC_P,P9,A31
set_property  -dict {PACKAGE_PIN  L4    IOSTANDARD LVCMOS18} [get_ports gp_out[50]]                   ; ## U1,L4,IO_L14_SRCC_33_JX1_N,JX1,50,CAM_SYNC_N,P9,A32
set_property  -dict {PACKAGE_PIN  K8    IOSTANDARD LVCMOS18} [get_ports gp_out[51]]                   ; ## U1,K8,IO_L24_33_JX1_P,JX1,36,CAM_SPI_MISO,P9,B15
set_property  -dict {PACKAGE_PIN  K7    IOSTANDARD LVCMOS18} [get_ports gp_out[52]]                   ; ## U1,K7,IO_L24_33_JX1_N,JX1,38,CAM_SPI_MOSI,P9,B18
set_property  -dict {PACKAGE_PIN  J10   IOSTANDARD LVCMOS18} [get_ports gp_out[53]]                   ; ## U1,J10,IO_L05_34_JX4_P,JX4,31,CAM_GPIO_8,P9,B30
set_property  -dict {PACKAGE_PIN  J11   IOSTANDARD LVCMOS18} [get_ports gp_in[37]]                    ; ## U1,J11,IO_L01_34_JX4_P,JX4,19,CAM_GPIO_0,P9,B20
set_property  -dict {PACKAGE_PIN  H11   IOSTANDARD LVCMOS18} [get_ports gp_in[38]]                    ; ## U1,H11,IO_L01_34_JX4_N,JX4,21,CAM_GPIO_1,P9,B21
set_property  -dict {PACKAGE_PIN  H9    IOSTANDARD LVCMOS18} [get_ports gp_in[39]]                    ; ## U1,H9,IO_L03_34_JX4_P,JX4,25,CAM_GPIO_4,P9,B25
set_property  -dict {PACKAGE_PIN  G9    IOSTANDARD LVCMOS18} [get_ports gp_in[40]]                    ; ## U1,G9,IO_L03_34_JX4_N,JX4,27,CAM_GPIO_5,P9,B26
set_property  -dict {PACKAGE_PIN  M6    IOSTANDARD LVCMOS18} [get_ports gp_in[41]]                    ; ## U1,M6,IO_L13_MRCC_33_JX1_P,JX1,82,CAM_CLK_P,P9,A4
set_property  -dict {PACKAGE_PIN  M5    IOSTANDARD LVCMOS18} [get_ports gp_in[42]]                    ; ## U1,M5,IO_L13_MRCC_33_JX1_N,JX1,84,CAM_CLK_N,P9,A5
set_property  -dict {PACKAGE_PIN  M2    IOSTANDARD LVCMOS18} [get_ports gp_in[43]]                    ; ## U1,M2,IO_L16_33_JX1_P,JX1,11,CAM_DATA1_P,P9,A10
set_property  -dict {PACKAGE_PIN  L2    IOSTANDARD LVCMOS18} [get_ports gp_in[44]]                    ; ## U1,L2,IO_L16_33_JX1_N,JX1,13,CAM_DATA1_N,P9,A11
set_property  -dict {PACKAGE_PIN  N1    IOSTANDARD LVCMOS18} [get_ports gp_in[45]]                    ; ## U1,N1,IO_L18_33_JX1_P,JX1,17,CAM_DATA3_P,P9,A16
set_property  -dict {PACKAGE_PIN  M1    IOSTANDARD LVCMOS18} [get_ports gp_in[46]]                    ; ## U1,M1,IO_L18_33_JX1_N,JX1,19,CAM_DATA3_N,P9,A17
set_property  -dict {PACKAGE_PIN  K5    IOSTANDARD LVCMOS18} [get_ports gp_in[47]]                    ; ## U1,K5,IO_L20_33_JX1_P,JX1,23,CAM_DATA5_P,P9,A22
set_property  -dict {PACKAGE_PIN  J5    IOSTANDARD LVCMOS18} [get_ports gp_in[48]]                    ; ## U1,J5,IO_L20_33_JX1_N,JX1,25,CAM_DATA5_N,P9,A23
set_property  -dict {PACKAGE_PIN  K6    IOSTANDARD LVCMOS18} [get_ports gp_in[49]]                    ; ## U1,K6,IO_L22_33_JX1_P,JX1,29,CAM_DATA7_P,P9,A28
set_property  -dict {PACKAGE_PIN  J6    IOSTANDARD LVCMOS18} [get_ports gp_in[50]]                    ; ## U1,J6,IO_L22_33_JX1_N,JX1,31,CAM_DATA7_N,P9,A29
set_property  -dict {PACKAGE_PIN  N7    IOSTANDARD LVCMOS18} [get_ports gp_in[51]]                    ; ## U1,N7,IO_L23_33_JX1_P,JX1,30,CAM_SPI_EN,P9,B14
set_property  -dict {PACKAGE_PIN  N6    IOSTANDARD LVCMOS18} [get_ports gp_in[52]]                    ; ## U1,N6,IO_L23_33_JX1_N,JX1,32,CAM_SPI_CLK,P9,B12
set_property  -dict {PACKAGE_PIN  J4    IOSTANDARD LVCMOS18} [get_ports gp_in[53]]                    ; ## U1,J4,IO_L12_MRCC_33_JX1_P,JX1,81,CAM_REFCLK,P9,A2

