
# constraints (pzsdr2.e)
# ad9361

set_property  -dict {PACKAGE_PIN  G14  IOSTANDARD LVCMOS18} [get_ports enable]                            ; ## IO_L11P_T1_SRCC_35           U1,G14,IO_L11_35_ENABLE
set_property  -dict {PACKAGE_PIN  F14  IOSTANDARD LVCMOS18} [get_ports txnrx]                             ; ## IO_L11N_T1_SRCC_35           U1,F14,IO_L11_35_TXNRX

set_property  -dict {PACKAGE_PIN  D13  IOSTANDARD LVCMOS18} [get_ports gpio_status[0]]                    ; ## IO_L19P_T3_35                U1,D13,IO_L19_35_CTRL_OUT0
set_property  -dict {PACKAGE_PIN  C13  IOSTANDARD LVCMOS18} [get_ports gpio_status[1]]                    ; ## IO_L19N_T3_VREF_35           U1,C13,IO_L19_35_CTRL_OUT1
set_property  -dict {PACKAGE_PIN  C14  IOSTANDARD LVCMOS18} [get_ports gpio_status[2]]                    ; ## IO_L20P_T3_AD6P_35           U1,C14,IO_L20_35_CTRL_OUT2
set_property  -dict {PACKAGE_PIN  B14  IOSTANDARD LVCMOS18} [get_ports gpio_status[3]]                    ; ## IO_L20N_T3_AD6N_35           U1,B14,IO_L20_35_CTRL_OUT3
set_property  -dict {PACKAGE_PIN  A15  IOSTANDARD LVCMOS18} [get_ports gpio_status[4]]                    ; ## IO_L21P_T3_DQS_AD14P_35      U1,A15,IO_L21_35_CTRL_OUT4
set_property  -dict {PACKAGE_PIN  A14  IOSTANDARD LVCMOS18} [get_ports gpio_status[5]]                    ; ## IO_L21N_T3_DQS_AD14N_35      U1,A14,IO_L21_35_CTRL_OUT5
set_property  -dict {PACKAGE_PIN  C12  IOSTANDARD LVCMOS18} [get_ports gpio_status[6]]                    ; ## IO_L22P_T3_AD7P_35           U1,C12,IO_L22_35_CTRL_OUT6
set_property  -dict {PACKAGE_PIN  B12  IOSTANDARD LVCMOS18} [get_ports gpio_status[7]]                    ; ## IO_L22N_T3_AD7N_35           U1,B12,IO_L22_35_CTRL_OUT7
set_property  -dict {PACKAGE_PIN  C2   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[0]]                       ; ## IO_L23P_T3_34                U1,C2,IO_L23_34_CTRL_IN0
set_property  -dict {PACKAGE_PIN  B1   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[1]]                       ; ## IO_L23N_T3_34                U1,B1,IO_L23_34_CTRL_IN1
set_property  -dict {PACKAGE_PIN  B2   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[2]]                       ; ## IO_L24P_T3_34                U1,B2,IO_L24_34_CTRL_IN2
set_property  -dict {PACKAGE_PIN  A2   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[3]]                       ; ## IO_L24N_T3_34                U1,A2,IO_L24_34_CTRL_IN3
set_property  -dict {PACKAGE_PIN  G16  IOSTANDARD LVCMOS18} [get_ports gpio_en_agc]                       ; ## IO_L10P_T1_AD11P_35          U1,G16,IO_L10_35_EN_AGC
set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVCMOS18} [get_ports gpio_sync]                         ; ## IO_L10N_T1_AD11N_35          U1,G15,IO_L10_35_SYNC_IN
set_property  -dict {PACKAGE_PIN  H16  IOSTANDARD LVCMOS18} [get_ports gpio_resetb]                       ; ## IO_0_VRN_35                  U1,H16,IO_00_35_AD9361_RST
set_property  -dict {PACKAGE_PIN  K11  IOSTANDARD LVCMOS18} [get_ports gpio_clksel]                       ; ## IO_0_VRN_34                  U1,K11,IO_00_34_AD9361_CLKSEL

set_property  -dict {PACKAGE_PIN  C11  IOSTANDARD LVCMOS18  PULLTYPE PULLUP} [get_ports spi_csn]          ; ## IO_L23P_T3_35                U1,C11,IO_L23_35_SPI_ENB
set_property  -dict {PACKAGE_PIN  B11  IOSTANDARD LVCMOS18} [get_ports spi_clk]                           ; ## IO_L23N_T3_35                U1,B11,IO_L23_35_SPI_CLK
set_property  -dict {PACKAGE_PIN  A13  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                          ; ## IO_L24P_T3_AD15P_35          U1,A13,IO_L24_35_SPI_DI
set_property  -dict {PACKAGE_PIN  A12  IOSTANDARD LVCMOS18} [get_ports spi_miso]                          ; ## IO_L24N_T3_AD15N_35          U1,A12,IO_L24_35_SPI_DO

set_property  -dict {PACKAGE_PIN  K12  IOSTANDARD LVCMOS18} [get_ports clkout_in]                         ; ## IO_25_VRP_35                 U1,K12,IO_25_35_AD9361_CLKOUT

# iic (ccbrk with loopback drives i2c back to the FPGA)

set_property  -dict {PACKAGE_PIN  AF24 IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_scl]           ; ## IO_L5P_T0_13                 U1,AF24,SCL,JX2,17,I2C_SCL,P2,14,P2,4,U1,Y16,IO_L23_12_JX2_P,JX2,97,LED_GPIO_3,P2,4
set_property  -dict {PACKAGE_PIN  AF25 IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_sda]           ; ## IO_L5N_T0_13                 U1,AF25,SDA,JX2,19,I2C_SDA,P2,16,P2,15,U1,AB24,IO_L06_13_JX2_N,JX2,20,IO_L06_13_JX2_N,P2,15

##    reference-only
##    --------------
##    ad9361 (optional rf-card)
##    --------------------------
##    JX4,1,GPO0
##    JX4,2,GPO1
##    JX4,3,GPO2
##    JX4,4,GPO3
##    JX4,7,AUXADC
##    JX4,8,AUXDAC1
##    JX4,10,AUXDAC2
##    JX4,63,AD9361_CLK

##    fixed-io (ps7) (som only, others are carrier specific)
##    ------------------------------------------------------
##    U1,D26,PS_MIO01_500_QSPI0_SS_B
##    U1,F23,PS_MIO06_500_QSPI0_SCLK
##    U1,E25,PS_MIO02_500_QSPI0_IO0
##    U1,D25,PS_MIO03_500_QSPI0_IO1
##    U1,F24,PS_MIO04_500_QSPI0_IO2
##    U1,C26,PS_MIO05_500_QSPI0_IO3
##    U1,A24,PS_MIO08_500_ETH0_RESETN               (magnetics-RJ45- JX3,47,ETH_PHY_LED0)
##    U1,A19,PS_MIO53_501_ETH0_MDIO                 (magnetics-RJ45- JX3,48,ETH_PHY_LED1)
##    U1,A20,PS_MIO52_501_ETH0_MDC                  (magnetics-RJ45- JX3,51,ETH_MD1_P)
##    U1,G22,PS_MIO22_501_ETH0_RX_CLK               (magnetics-RJ45- JX3,53,ETH_MD1_N)
##    U1,F18,PS_MIO27_501_ETH0_RX_CTL               (magnetics-RJ45- JX3,52,ETH_MD2_P)
##    U1,F20,PS_MIO23_501_ETH0_RX_D0                (magnetics-RJ45- JX3,54,ETH_MD2_N)
##    U1,J19,PS_MIO24_501_ETH0_RX_D1                (magnetics-RJ45- JX3,57,ETH_MD3_P)
##    U1,F19,PS_MIO25_501_ETH0_RX_D2                (magnetics-RJ45- JX3,59,ETH_MD3_N)
##    U1,H17,PS_MIO26_501_ETH0_RX_D3                (magnetics-RJ45- JX3,58,ETH_MD4_P)
##    U1,G21,PS_MIO16_501_ETH0_TX_CLK               (magnetics-RJ45- JX3,60,ETH_MD4_N)
##    U1,F22,PS_MIO21_501_ETH0_TX_CTL
##    U1,G17,PS_MIO17_501_ETH0_TX_D0
##    U1,G20,PS_MIO18_501_ETH0_TX_D1
##    U1,G19,PS_MIO19_501_ETH0_TX_D2
##    U1,H19,PS_MIO20_501_ETH0_TX_D3
##    U1,B21,PS_MIO48_501_JX4,JX4,99,USB_UART_RXD
##    U1,A18,PS_MIO49_501_JX4,JX4,98,USB_UART_TXD
##    U1,C22,PS_MIO40_501_SD0_CLK                   (off-board- JX3,43,SDIO_CLKB1)
##    U1,C19,PS_MIO41_501_SD0_CMD                   (off-board- JX3,34,SDIO_CMDB1)
##    U1,F17,PS_MIO42_501_SD0_DATA0                 (off-board- JX3,37,SDIO_DAT0B1)
##    U1,D18,PS_MIO43_501_SD0_DATA1                 (off-board- JX3,36,SDIO_DAT1B1)
##    U1,E18,PS_MIO44_501_SD0_DATA2                 (off-board- JX3,39,SDIO_DAT2B1)
##    U1,C18,PS_MIO45_501_SD0_DATA3                 (off-board- JX3,38,SDIO_DAT3B1)
##    U1,B22,PS_MIO50_501_SD0_CD                    (off-board- JX3,41,JX3_SD1_CDN)
##    U1,E23,PS_MIO07_500_USB_RESET_B               (usb- JX3,63,USB_ID)
##    U1,D24,PS_MIO09_500_USB_CLK_PD                (usb- JX3,67,USB_OTG_P)
##    U1,E20,PS_MIO29_501_USB0_DIR                  (usb- JX3,69,USB_OTG_N)
##    U1,K19,PS_MIO30_501_USB0_STP                  (usb- JX3,68,USB_VBUS_OTG)
##    U1,E21,PS_MIO31_501_USB0_NXT                  (usb- JX3,70,USB_OTG_CPEN)
##    U1,K16,PS_MIO36_501_USB0_CLK
##    U1,K17,PS_MIO32_501_USB0_D0
##    U1,E22,PS_MIO33_501_USB0_D1
##    U1,J16,PS_MIO34_501_USB0_D2
##    U1,D19,PS_MIO35_501_USB0_D3
##    U1,J18,PS_MIO28_501_USB0_D4
##    U1,D20,PS_MIO37_501_USB0_D5
##    U1,D21,PS_MIO38_501_USB0_D6
##    U1,C21,PS_MIO39_501_USB0_D7
##    U1,A23,UNNAMED_3_ICXC7Z035_I94_PSMIO12        (JX4,86,PS_MIO12_500_JX4)

##    ddr (fixed-io)
##    --------------
##    U1,H24,DDR3_DQS0_P
##    U1,G25,DDR3_DQS0_N
##    U1,L24,DDR3_DQS1_P
##    U1,L25,DDR3_DQS1_N
##    U1,P25,DDR3_DQS2_P
##    U1,R25,DDR3_DQS2_N
##    U1,W24,DDR3_DQS3_P
##    U1,W25,DDR3_DQS3_N
##    U1,J26,DDR3_DQ0
##    U1,F25,DDR3_DQ1
##    U1,J25,DDR3_DQ2
##    U1,G26,DDR3_DQ3
##    U1,H26,DDR3_DQ4
##    U1,H23,DDR3_DQ5
##    U1,J24,DDR3_DQ6
##    U1,J23,DDR3_DQ7
##    U1,K26,DDR3_DQ8
##    U1,L23,DDR3_DQ9
##    U1,M26,DDR3_DQ10
##    U1,K23,DDR3_DQ11
##    U1,M25,DDR3_DQ12
##    U1,N24,DDR3_DQ13
##    U1,M24,DDR3_DQ14
##    U1,N23,DDR3_DQ15
##    U1,R26,DDR3_DQ16
##    U1,P24,DDR3_DQ17
##    U1,N26,DDR3_DQ18
##    U1,P23,DDR3_DQ19
##    U1,T24,DDR3_DQ20
##    U1,T25,DDR3_DQ21
##    U1,T23,DDR3_DQ22
##    U1,R23,DDR3_DQ23
##    U1,V24,DDR3_DQ24
##    U1,U26,DDR3_DQ25
##    U1,U24,DDR3_DQ26
##    U1,U25,DDR3_DQ27
##    U1,W26,DDR3_DQ28
##    U1,Y25,DDR3_DQ29
##    U1,Y26,DDR3_DQ30
##    U1,W23,DDR3_DQ31
##    U1,G24,DDR3_DM0
##    U1,K25,DDR3_DM1
##    U1,P26,DDR3_DM2
##    U1,V26,DDR3_DM3
##    U1,K22,DDR3_A0
##    U1,K20,DDR3_A1
##    U1,N21,DDR3_A2
##    U1,L22,DDR3_A3
##    U1,M20,DDR3_A4
##    U1,N22,DDR3_A5
##    U1,L20,DDR3_A6
##    U1,J21,DDR3_A7
##    U1,T20,DDR3_A8
##    U1,U20,DDR3_A9
##    U1,M22,DDR3_A10
##    U1,H21,DDR3_A11
##    U1,P20,DDR3_A12
##    U1,J20,DDR3_A13
##    U1,R20,DDR3_A14
##    U1,U22,DDR3_BA0
##    U1,T22,DDR3_BA1
##    U1,R22,DDR3_BA2
##    U1,R21,DDR3_CK_P
##    U1,P21,DDR3_CK_N
##    U1,U21,DDR3_CKE
##    U1,H22,DDR3_RST#
##    U1,Y21,DDR3_CS#
##    U1,V22,DDR3_WE#
##    U1,V23,DDR3_RAS#
##    U1,Y23,DDR3_CAS#
##    U1,Y22,DDR3_ODT

##    resets, clock and power controls
##    --------------------------------
##    U1,B24,UNNAMED_3_ICXC7Z035_I94_PSCLK50,33.33MEGHZ
##    U1,A22,PS-SRST#
##    U1,C23,PWR_GD_1.35V
##    JX2,10,PG_1P8V
##    JX2,11,PG_MODULE
##    JX1,5,PWR_ENABLE
##    JX1,6,CARRIER_RESET

##    JTAG
##    ----
##    U1,W11,JTAG_TMS,JX1,2,JTAG_TMS
##    U1,W12,JTAG_TCK,JX1,1,JTAG_TCK
##    U1,V11,JTAG_TDI,JX1,4,FPGA_TDI,JTAG_TDI
##    U1,W9,FPGA_DONE,JX1,8,CFG_DONE

##    GBT I/O (clocks)
##    ----------------
##    U1,R5,UNNAMED_7_CAP_I125_N2 (JX1,87,MGTREFCLK0_112_JX1_P)
##    U1,R6,UNNAMED_7_CAP_I123_N2 (JX1,89,MGTREFCLK0_112_JX1_N)
##    U1,U6,UNNAMED_7_CAP_I126_N2 (JX3,2,MGTREFCLK1_112_JX3_P)
##    U1,U5,UNNAMED_7_CAP_I124_N2 (JX3,4,MGTREFCLK1_112_JX3_N)

