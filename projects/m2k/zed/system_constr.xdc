# the board can be used at 1.8V, 2.5V, 3.3V. 3.3V is the recommended setting
# given that the zedboard default configuration is for 2.5V, this voltage is used in the constraint file

set_property  -dict {PACKAGE_PIN  A16  IOSTANDARD LVCMOS25} [get_ports en_power_analog]          ; ## A16  FMC_LPC_LA28_P
set_property  -dict {PACKAGE_PIN  B16  IOSTANDARD LVCMOS25} [get_ports ad9963_resetn]            ; ## G33  FMC_LPC_LA31_P

set_property  -dict {PACKAGE_PIN  B21  IOSTANDARD LVCMOS25} [get_ports adf4360_cs]               ; ## G36  FMC_LPC_LA33_P
set_property  -dict {PACKAGE_PIN  B17  IOSTANDARD LVCMOS25} [get_ports ad9963_csn]               ; ## G34  FMC_LPC_LA31_N
set_property  -dict {PACKAGE_PIN  C17  IOSTANDARD LVCMOS25} [get_ports spi_clk]                  ; ## G30  FMC_LPC_LA29_P
set_property  -dict {PACKAGE_PIN  C18  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                 ; ## G31  FMC_LPC_LA29_N

set_property  -dict {PACKAGE_PIN  D20  IOSTANDARD LVCMOS25} [get_ports trigger_bd[0]]            ; ## C22  FMC_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  C20  IOSTANDARD LVCMOS25} [get_ports trigger_bd[1]]            ; ## C23  FMC_LPC_LA18_CC_N

set_property  -dict {PACKAGE_PIN  B19  IOSTANDARD LVCMOS25} [get_ports data_bd[0]]               ; ## D20  FMC_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN  B20  IOSTANDARD LVCMOS25} [get_ports data_bd[1]]               ; ## D21  FMC_LPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN  D22  IOSTANDARD LVCMOS25} [get_ports data_bd[2]]               ; ## D17  FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN  C22  IOSTANDARD LVCMOS25} [get_ports data_bd[3]]               ; ## D18  FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN  E15  IOSTANDARD LVCMOS25} [get_ports data_bd[4]]               ; ## D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  D15  IOSTANDARD LVCMOS25} [get_ports data_bd[5]]               ; ## D24  FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN  F18  IOSTANDARD LVCMOS25} [get_ports data_bd[6]]               ; ## D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  E18  IOSTANDARD LVCMOS25} [get_ports data_bd[7]]               ; ## D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  G20  IOSTANDARD LVCMOS25} [get_ports data_bd[8]]               ; ## C10  FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN  G21  IOSTANDARD LVCMOS25} [get_ports data_bd[9]]               ; ## C11  FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN  G19  IOSTANDARD LVCMOS25} [get_ports data_bd[10]]              ; ## C14  FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN  F19  IOSTANDARD LVCMOS25} [get_ports data_bd[11]]              ; ## C15  FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVCMOS25} [get_ports data_bd[12]]              ; ## C18  FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN  G16  IOSTANDARD LVCMOS25} [get_ports data_bd[13]]              ; ## C19  FMC_LPC_LA14_N
set_property  -dict {PACKAGE_PIN  E21  IOSTANDARD LVCMOS25} [get_ports data_bd[14]]              ; ## C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  D21  IOSTANDARD LVCMOS25} [get_ports data_bd[15]]              ; ## C27  FMC_LPC_LA27_P

set_property  -dict {PACKAGE_PIN  M19  IOSTANDARD LVCMOS25} [get_ports rx_clk]                   ; ## G07  FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  L17  IOSTANDARD LVCMOS25} [get_ports rxiq]                     ; ## G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  P17  IOSTANDARD LVCMOS25} [get_ports rxd[0]]                   ; ## H07  FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  P18  IOSTANDARD LVCMOS25} [get_ports rxd[1]]                   ; ## H08  FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  M21  IOSTANDARD LVCMOS25} [get_ports rxd[2]]                   ; ## H10  FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  M22  IOSTANDARD LVCMOS25} [get_ports rxd[3]]                   ; ## H11  FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  T16  IOSTANDARD LVCMOS25} [get_ports rxd[4]]                   ; ## H13  FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  T17  IOSTANDARD LVCMOS25} [get_ports rxd[5]]                   ; ## H14  FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN  N17  IOSTANDARD LVCMOS25} [get_ports rxd[6]]                   ; ## H16  FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  N18  IOSTANDARD LVCMOS25} [get_ports rxd[7]]                   ; ## H17  FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  J16  IOSTANDARD LVCMOS25} [get_ports rxd[8]]                   ; ## H19  FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN  J17  IOSTANDARD LVCMOS25} [get_ports rxd[9]]                   ; ## H20  FMC_LPC_LA15_N
set_property  -dict {PACKAGE_PIN  K19  IOSTANDARD LVCMOS25} [get_ports rxd[10]]                  ; ## H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  K20  IOSTANDARD LVCMOS25} [get_ports rxd[11]]                  ; ## H23  FMC_LPC_LA19_N

set_property  -dict {PACKAGE_PIN  N19  IOSTANDARD LVCMOS25} [get_ports tx_clk]                   ; ## G06  FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  M17  IOSTANDARD LVCMOS25} [get_ports txiq]                     ; ## G28  FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN  N22  IOSTANDARD LVCMOS25} [get_ports txd[0]]                   ; ## G09  FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  P22  IOSTANDARD LVCMOS25} [get_ports txd[1]]                   ; ## G10  FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  J21  IOSTANDARD LVCMOS25} [get_ports txd[2]]                   ; ## G12  FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  J22  IOSTANDARD LVCMOS25} [get_ports txd[3]]                   ; ## G13  FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  P20  IOSTANDARD LVCMOS25} [get_ports txd[4]]                   ; ## G15  FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  P21  IOSTANDARD LVCMOS25} [get_ports txd[5]]                   ; ## G16  FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  J20  IOSTANDARD LVCMOS25} [get_ports txd[6]]                   ; ## G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  K21  IOSTANDARD LVCMOS25} [get_ports txd[7]]                   ; ## G19  FMC_LPC_LA16_N
set_property  -dict {PACKAGE_PIN  L21  IOSTANDARD LVCMOS25} [get_ports txd[8]]                   ; ## G21  FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  L22  IOSTANDARD LVCMOS25} [get_ports txd[9]]                   ; ## G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  R19  IOSTANDARD LVCMOS25} [get_ports txd[10]]                  ; ## G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  T19  IOSTANDARD LVCMOS25} [get_ports txd[11]]                  ; ## G25  FMC_LPC_LA22_N

create_clock -name rx_clk       -period   10.00 [get_ports rx_clk]
create_clock -name tx_clk       -period   6.66  [get_ports tx_clk]

create_clock -name trigger_clk  -period   12.5  [get_ports trigger_bd[0]]
create_clock -name data_clk     -period   12.5  [get_ports data_bd[0]]

set_clock_groups -name exclusive_ -physically_exclusive \
-group  [get_clocks mmcm_clk_0_s_1] -group  [get_clocks mmcm_clk_0_s_2] -group [get_clocks mmcm_clk_0_s_3]

set_false_path -from [get_clocks data_clk] -to [get_pins {i_system_wrapper/system_i/logic_analyzer/inst/data_m1_reg[0]/D}]
set_false_path -from [get_clocks trigger_clk] -to [get_pins {i_system_wrapper/system_i/logic_analyzer/inst/trigger_m1_reg[0]/D}]
