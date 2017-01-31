set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS33} [get_ports otg_vbusoc]

set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVCMOS33} [get_ports gpio_bd[0]]       ; ## BTNC
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVCMOS33} [get_ports gpio_bd[1]]       ; ## BTND
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[2]]       ; ## BTNL
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS33} [get_ports gpio_bd[3]]       ; ## BTNR
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD LVCMOS33} [get_ports gpio_bd[4]]       ; ## BTNU

set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[11]]      ; ## SW0
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[12]]      ; ## SW1
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[13]]      ; ## SW2
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[14]]      ; ## SW3
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD LVCMOS33} [get_ports gpio_bd[15]]      ; ## SW4
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVCMOS33} [get_ports gpio_bd[16]]      ; ## SW5
set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVCMOS33} [get_ports gpio_bd[17]]      ; ## SW6
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[18]]      ; ## SW7

set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS33} [get_ports gpio_bd[31]]      ; ## OTG-RESETN

set_property  -dict {PACKAGE_PIN  A16   IOSTANDARD LVCMOS33} [get_ports en_power_analog]        ; ## A16  FMC_LPC_LA28_P
set_property  -dict {PACKAGE_PIN  B16   IOSTANDARD LVCMOS33} [get_ports ad9963_resetn]           ; ## G33  FMC_LPC_LA31_P

set_property  -dict {PACKAGE_PIN  B21  IOSTANDARD LVCMOS33} [get_ports adf4360_cs]               ; ## G36  FMC_LPC_LA33_P
set_property  -dict {PACKAGE_PIN  B17  IOSTANDARD LVCMOS33} [get_ports ad9963_csn]               ; ## G34  FMC_LPC_LA31_N
set_property  -dict {PACKAGE_PIN  C17  IOSTANDARD LVCMOS33} [get_ports spi_clk]                  ; ## G30  FMC_LPC_LA29_P
set_property  -dict {PACKAGE_PIN  C18  IOSTANDARD LVCMOS33} [get_ports spi_sdio]                 ; ## G31  FMC_LPC_LA29_N

set_property  -dict {PACKAGE_PIN  D20  IOSTANDARD LVCMOS33 } [get_ports trigger_bd[0]]            ; ## C22  FMC_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  C20  IOSTANDARD LVCMOS33 } [get_ports trigger_bd[1]]            ; ## C23  FMC_LPC_LA18_CC_N

set_property  -dict {PACKAGE_PIN  B19  IOSTANDARD LVCMOS33 } [get_ports data_bd[0]]               ; ## D20  FMC_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN  B20  IOSTANDARD LVCMOS33 } [get_ports data_bd[1]]               ; ## D21  FMC_LPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN  D22  IOSTANDARD LVCMOS33 } [get_ports data_bd[2]]               ; ## D17  FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN  C22  IOSTANDARD LVCMOS33 } [get_ports data_bd[3]]               ; ## D18  FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN  E15  IOSTANDARD LVCMOS33 } [get_ports data_bd[4]]               ; ## D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  D15  IOSTANDARD LVCMOS33 } [get_ports data_bd[5]]               ; ## D24  FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN  F18  IOSTANDARD LVCMOS33 } [get_ports data_bd[6]]               ; ## D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  E18  IOSTANDARD LVCMOS33 } [get_ports data_bd[7]]               ; ## D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  G20  IOSTANDARD LVCMOS33 } [get_ports data_bd[8]]               ; ## C10  FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN  G21  IOSTANDARD LVCMOS33 } [get_ports data_bd[9]]               ; ## C11  FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN  G19  IOSTANDARD LVCMOS33 } [get_ports data_bd[10]]              ; ## C14  FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN  F19  IOSTANDARD LVCMOS33 } [get_ports data_bd[11]]              ; ## C15  FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVCMOS33 } [get_ports data_bd[12]]              ; ## C18  FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN  G16  IOSTANDARD LVCMOS33 } [get_ports data_bd[13]]              ; ## C19  FMC_LPC_LA14_N
set_property  -dict {PACKAGE_PIN  E21  IOSTANDARD LVCMOS33 } [get_ports data_bd[14]]              ; ## C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  D21  IOSTANDARD LVCMOS33 } [get_ports data_bd[15]]              ; ## C27  FMC_LPC_LA27_P

set_property  -dict {PACKAGE_PIN  M19  IOSTANDARD LVCMOS33} [get_ports rx_clk]                   ; ## G07  FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  L17  IOSTANDARD LVCMOS33} [get_ports rxiq]                     ; ## G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  P17  IOSTANDARD LVCMOS33} [get_ports rxd[0]]                   ; ## H07  FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  P18  IOSTANDARD LVCMOS33} [get_ports rxd[1]]                   ; ## H08  FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  M21  IOSTANDARD LVCMOS33} [get_ports rxd[2]]                   ; ## H10  FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  M22  IOSTANDARD LVCMOS33} [get_ports rxd[3]]                   ; ## H11  FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  T16  IOSTANDARD LVCMOS33} [get_ports rxd[4]]                   ; ## H13  FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  T17  IOSTANDARD LVCMOS33} [get_ports rxd[5]]                   ; ## H14  FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN  N17  IOSTANDARD LVCMOS33} [get_ports rxd[6]]                   ; ## H16  FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  N18  IOSTANDARD LVCMOS33} [get_ports rxd[7]]                   ; ## H17  FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  J16  IOSTANDARD LVCMOS33} [get_ports rxd[8]]                   ; ## H19  FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN  J17  IOSTANDARD LVCMOS33} [get_ports rxd[9]]                   ; ## H20  FMC_LPC_LA15_N
set_property  -dict {PACKAGE_PIN  K19  IOSTANDARD LVCMOS33} [get_ports rxd[10]]                  ; ## H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  K20  IOSTANDARD LVCMOS33} [get_ports rxd[11]]                  ; ## H23  FMC_LPC_LA19_N

set_property  -dict {PACKAGE_PIN  N19  IOSTANDARD LVCMOS33} [get_ports tx_clk]                   ; ## G06  FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  M17  IOSTANDARD LVCMOS33} [get_ports txiq]                     ; ## G28  FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN  N22  IOSTANDARD LVCMOS33} [get_ports txd[0]]                   ; ## G09  FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  P22  IOSTANDARD LVCMOS33} [get_ports txd[1]]                   ; ## G10  FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  J21  IOSTANDARD LVCMOS33} [get_ports txd[2]]                   ; ## G12  FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  J22  IOSTANDARD LVCMOS33} [get_ports txd[3]]                   ; ## G13  FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  P20  IOSTANDARD LVCMOS33} [get_ports txd[4]]                   ; ## G15  FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  P21  IOSTANDARD LVCMOS33} [get_ports txd[5]]                   ; ## G16  FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  J20  IOSTANDARD LVCMOS33} [get_ports txd[6]]                   ; ## G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  K21  IOSTANDARD LVCMOS33} [get_ports txd[7]]                   ; ## G19  FMC_LPC_LA16_N
set_property  -dict {PACKAGE_PIN  L21  IOSTANDARD LVCMOS33} [get_ports txd[8]]                   ; ## G21  FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  L22  IOSTANDARD LVCMOS33} [get_ports txd[9]]                   ; ## G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  R19  IOSTANDARD LVCMOS33} [get_ports txd[10]]                  ; ## G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  T19  IOSTANDARD LVCMOS33} [get_ports txd[11]]                  ; ## G25  FMC_LPC_LA22_N

create_clock -name rx_clk       -period   10.00 [get_ports rx_clk]
create_clock -name trigger_clk  -period   12.5  [get_ports trigger_bd[0]]
create_clock -name data_clk     -period   12.5  [get_ports data_bd[0]]
