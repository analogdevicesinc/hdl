# !!!! the vadj is set to 3.3V in this setting

# clocks

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {rx_clk}]

create_clock -name rx_clk    -period   10.00 [get_ports rx_clk]
create_clock -name tx_clk    -period   6.66  [get_ports tx_clk]
create_clock -name data_clk  -period   12.5  [get_ports data_bd[0]]

set_clock_groups -name exclusive_ -physically_exclusive -group [get_clocks data_clk] -group [get_clocks rx_clk]

# m2k fmc

# ad9963

set_property -dict {PACKAGE_PIN AC29 IOSTANDARD LVCMOS33} [get_ports ad9963_resetn]                   ; ## G33  FMC_LA31_P     IO_L9P_T1_DQS_12
set_property -dict {PACKAGE_PIN AD29 IOSTANDARD LVCMOS33} [get_ports ad9963_csn]                      ; ## G34  FMC_LA31_N     IO_L9N_T1_DQS_12

# adf4360

set_property -dict {PACKAGE_PIN Y30  IOSTANDARD LVCMOS33} [get_ports adf4360_cs]                      ; ## G36  FMC_LA33_P     IO_L1P_T0_12

# trigger_bd

set_property -dict {PACKAGE_PIN AE27 IOSTANDARD LVCMOS33} [get_ports trigger_bd[0]]                   ; ## C22  FMC_LA18_CC_P  IO_L14P_T2_SRCC_12
set_property -dict {PACKAGE_PIN AF27 IOSTANDARD LVCMOS33} [get_ports trigger_bd[1]]                   ; ## C23  FMC_LA18_CC_N  IO_L14N_T2_SRCC_12

set_property -dict {PACKAGE_PIN AB27 IOSTANDARD LVCMOS33} [get_ports data_bd[0]]                      ; ## D20  FMC_LA17_CC_P  IO_L11P_T1_SRCC_12
set_property -dict {PACKAGE_PIN AC27 IOSTANDARD LVCMOS33} [get_ports data_bd[1]]                      ; ## D21  FMC_LA17_CC_N  IO_L11N_T1_SRCC_12
set_property -dict {PACKAGE_PIN AF29 IOSTANDARD LVCMOS33} [get_ports data_bd[2]]                      ; ## G27  FMC_LA25_P     IO_L15P_T2_DQS_12
set_property -dict {PACKAGE_PIN AG29 IOSTANDARD LVCMOS33} [get_ports data_bd[3]]                      ; ## G28  FMC_LA25_N     IO_L15N_T2_DQS_12
set_property -dict {PACKAGE_PIN AJ26 IOSTANDARD LVCMOS33} [get_ports data_bd[4]]                      ; ## D23  FMC_LA23_P     IO_L24P_T3_12
set_property -dict {PACKAGE_PIN AK26 IOSTANDARD LVCMOS33} [get_ports data_bd[5]]                      ; ## D24  FMC_LA23_N     IO_L24N_T3_12
set_property -dict {PACKAGE_PIN AJ30 IOSTANDARD LVCMOS33} [get_ports data_bd[6]]                      ; ## D26  FMC_LA26_P     IO_L20P_T3_12
set_property -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS33} [get_ports data_bd[7]]                      ; ## D27  FMC_LA26_N     IO_L20N_T3_12
set_property -dict {PACKAGE_PIN AG26 IOSTANDARD LVCMOS33} [get_ports data_bd[8]]                      ; ## G21  FMC_LA20_P     IO_L17P_T2_12
set_property -dict {PACKAGE_PIN AG27 IOSTANDARD LVCMOS33} [get_ports data_bd[9]]                      ; ## G22  FMC_LA20_N     IO_L17N_T2_12
set_property -dict {PACKAGE_PIN AK27 IOSTANDARD LVCMOS33} [get_ports data_bd[10]]                     ; ## G24  FMC_LA22_P     IO_L22P_T3_12
set_property -dict {PACKAGE_PIN AK28 IOSTANDARD LVCMOS33} [get_ports data_bd[11]]                     ; ## G25  FMC_LA22_N     IO_L22N_T3_12
set_property -dict {PACKAGE_PIN AH26 IOSTANDARD LVCMOS33} [get_ports data_bd[12]]                     ; ## H22  FMC_LA19_P     IO_L23P_T3_12
set_property -dict {PACKAGE_PIN AH27 IOSTANDARD LVCMOS33} [get_ports data_bd[13]]                     ; ## H23  FMC_LA19_N     IO_L23N_T3_12
set_property -dict {PACKAGE_PIN AJ28 IOSTANDARD LVCMOS33} [get_ports data_bd[14]]                     ; ## C26  FMC_LA27_P     IO_L21P_T3_DQS_12
set_property -dict {PACKAGE_PIN AJ29 IOSTANDARD LVCMOS33} [get_ports data_bd[15]]                     ; ## C27  FMC_LA27_N     IO_L21N_T3_DQS_12

# rx

set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVCMOS33} [get_ports rx_clk]                          ; ## G6   FMC_LA00_CC_P  IO_L11P_T1_SRCC_10
set_property -dict {PACKAGE_PIN AH17 IOSTANDARD LVCMOS33} [get_ports rxiq]                            ; ## D17  FMC_LA13_P     IO_L6P_T0_10
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS33} [get_ports rxd[0]]                          ; ## H7   FMC_LA02_P     IO_L7P_T1_10
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS33} [get_ports rxd[1]]                          ; ## H8   FMC_LA02_N     IO_L7N_T1_10
set_property -dict {PACKAGE_PIN AJ15 IOSTANDARD LVCMOS33} [get_ports rxd[2]]                          ; ## H10  FMC_LA04_P     IO_L5P_T0_10
set_property -dict {PACKAGE_PIN AK15 IOSTANDARD LVCMOS33} [get_ports rxd[3]]                          ; ## H11  FMC_LA04_N     IO_L5N_T0_10
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS33} [get_ports rxd[4]]                          ; ## H13  FMC_LA07_P     IO_L20P_T3_10
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33} [get_ports rxd[5]]                          ; ## H14  FMC_LA07_N     IO_L20N_T3_10
set_property -dict {PACKAGE_PIN AJ16 IOSTANDARD LVCMOS33} [get_ports rxd[6]]                          ; ## H16  FMC_LA11_P     IO_L4P_T0_10
set_property -dict {PACKAGE_PIN AK16 IOSTANDARD LVCMOS33} [get_ports rxd[7]]                          ; ## H17  FMC_LA11_N     IO_L4N_T0_10
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33} [get_ports rxd[8]]                          ; ## H19  FMC_LA15_P     IO_L22P_T3_10
set_property -dict {PACKAGE_PIN AB14 IOSTANDARD LVCMOS33} [get_ports rxd[9]]                          ; ## H20  FMC_LA15_N     IO_L22N_T3_10
set_property -dict {PACKAGE_PIN AF18 IOSTANDARD LVCMOS33} [get_ports rxd[10]]                         ; ## C18  FMC_LA14_P     IO_L15P_T2_DQS_10
set_property -dict {PACKAGE_PIN AF17 IOSTANDARD LVCMOS33} [get_ports rxd[11]]                         ; ## C19  FMC_LA14_N     IO_L15N_T2_DQS_10

# tx

set_property -dict {PACKAGE_PIN AF15 IOSTANDARD LVCMOS33} [get_ports tx_clk]                          ; ## D8   FMC_LA01_CC_P  IO_L14P_T2_SRCC_10
set_property -dict {PACKAGE_PIN AH16 IOSTANDARD LVCMOS33} [get_ports txiq]                            ; ## D18  FMC_LA13_N     IO_L6N_T0_VREF_10
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVCMOS33} [get_ports txd[0]]                          ; ## G9   FMC_LA03_P     IO_L10P_T1_10
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS33} [get_ports txd[1]]                          ; ## G10  FMC_LA03_N     IO_L10N_T1_10
set_property -dict {PACKAGE_PIN AD14 IOSTANDARD LVCMOS33} [get_ports txd[2]]                          ; ## G12  FMC_LA08_P     IO_L9P_T1_DQS_10
set_property -dict {PACKAGE_PIN AD13 IOSTANDARD LVCMOS33} [get_ports txd[3]]                          ; ## G13  FMC_LA08_N     IO_L9N_T1_DQS_10
set_property -dict {PACKAGE_PIN AD16 IOSTANDARD LVCMOS33} [get_ports txd[4]]                          ; ## G15  FMC_LA12_P     IO_L18P_T2_10
set_property -dict {PACKAGE_PIN AD15 IOSTANDARD LVCMOS33} [get_ports txd[5]]                          ; ## G16  FMC_LA12_N     IO_L18N_T2_10
set_property -dict {PACKAGE_PIN AE18 IOSTANDARD LVCMOS33} [get_ports txd[6]]                          ; ## G18  FMC_LA16_P     IO_L17P_T2_10
set_property -dict {PACKAGE_PIN AE17 IOSTANDARD LVCMOS33} [get_ports txd[7]]                          ; ## G19  FMC_LA16_N     IO_L17N_T2_10
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS33} [get_ports txd[8]]                          ; ## C10  FMC_LA06_P     IO_L21P_T3_DQS_10
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS33} [get_ports txd[9]]                          ; ## C11  FMC_LA06_N     IO_L21N_T3_DQS_10
set_property -dict {PACKAGE_PIN AC14 IOSTANDARD LVCMOS33} [get_ports txd[10]]                         ; ## C14  FMC_LA10_P     IO_L19P_T3_10
set_property -dict {PACKAGE_PIN AC13 IOSTANDARD LVCMOS33} [get_ports txd[11]]                         ; ## C15  FMC_LA10_N     IO_L19N_T3_VREF_10

# spi

set_property -dict {PACKAGE_PIN AE25 IOSTANDARD LVCMOS33} [get_ports spi_clk]                         ; ## G30  FMC_LA29_P     IO_L18P_T2_12
set_property -dict {PACKAGE_PIN AF25 IOSTANDARD LVCMOS33} [get_ports spi_sdio]                        ; ## G31  FMC_LA29_N     IO_L18N_T2_12

# i2c

set_property -dict {PACKAGE_PIN AF30 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_m2k_fmc_sda] ; ## H28  FMC_LA24_P     IO_L16P_T2_12
set_property -dict {PACKAGE_PIN AG30 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_m2k_fmc_scl] ; ## H29  FMC_LA24_N     IO_L16N_T2_12
