# the board can be used at 1.8V, 2.5V, 3.3V. the default
# the vadj is set to 3.3V in this setting

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {rx_clk}]

set_property  -dict {PACKAGE_PIN  AC29  IOSTANDARD LVCMOS33} [get_ports ad9963_resetn] ; ## G33  FMC_LPC_LA31_P

set_property  -dict {PACKAGE_PIN  Y30   IOSTANDARD LVCMOS33} [get_ports adf4360_cs]    ; ## G36  FMC_LPC_LA33_P
set_property  -dict {PACKAGE_PIN  AD29  IOSTANDARD LVCMOS33} [get_ports ad9963_csn]    ; ## G34  FMC_LPC_LA31_N
set_property  -dict {PACKAGE_PIN  AE25  IOSTANDARD LVCMOS33} [get_ports spi_clk]       ; ## G30  FMC_LPC_LA29_P
set_property  -dict {PACKAGE_PIN  AF25  IOSTANDARD LVCMOS33} [get_ports spi_sdio]      ; ## G31  FMC_LPC_LA29_N

set_property  -dict {PACKAGE_PIN  AE27  IOSTANDARD LVCMOS33} [get_ports trigger_bd[0]] ; ## C22  FMC_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  AF27  IOSTANDARD LVCMOS33} [get_ports trigger_bd[1]] ; ## C23  FMC_LPC_LA18_CC_N

set_property  -dict {PACKAGE_PIN  AB27  IOSTANDARD LVCMOS33} [get_ports data_bd[0]]    ; ## D20  FMC_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN  AC27  IOSTANDARD LVCMOS33} [get_ports data_bd[1]]    ; ## D21  FMC_LPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN  AF29  IOSTANDARD LVCMOS33} [get_ports data_bd[2]]    ; ## G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  AG29  IOSTANDARD LVCMOS33} [get_ports data_bd[3]]    ; ## G28  FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN  AJ26  IOSTANDARD LVCMOS33} [get_ports data_bd[4]]    ; ## D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  AK26  IOSTANDARD LVCMOS33} [get_ports data_bd[5]]    ; ## D24  FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN  AJ30  IOSTANDARD LVCMOS33} [get_ports data_bd[6]]    ; ## D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  AK30  IOSTANDARD LVCMOS33} [get_ports data_bd[7]]    ; ## D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  AG26  IOSTANDARD LVCMOS33} [get_ports data_bd[8]]    ; ## G21  FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  AG27  IOSTANDARD LVCMOS33} [get_ports data_bd[9]]    ; ## G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  AK27  IOSTANDARD LVCMOS33} [get_ports data_bd[10]]   ; ## G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  AK28  IOSTANDARD LVCMOS33} [get_ports data_bd[11]]   ; ## G25  FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN  AH26  IOSTANDARD LVCMOS33} [get_ports data_bd[12]]   ; ## H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  AH27  IOSTANDARD LVCMOS33} [get_ports data_bd[13]]   ; ## H23  FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN  AJ28  IOSTANDARD LVCMOS33} [get_ports data_bd[14]]   ; ## C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  AJ29  IOSTANDARD LVCMOS33} [get_ports data_bd[15]]   ; ## C27  FMC_LPC_LA27_P

set_property  -dict {PACKAGE_PIN  AE13  IOSTANDARD LVCMOS33} [get_ports rx_clk]        ; ## G06  FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AH17  IOSTANDARD LVCMOS33} [get_ports rxiq]          ; ## D17  FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN  AE12  IOSTANDARD LVCMOS33} [get_ports rxd[0]]        ; ## H07  FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  AF12  IOSTANDARD LVCMOS33} [get_ports rxd[1]]        ; ## H08  FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  AJ15  IOSTANDARD LVCMOS33} [get_ports rxd[2]]        ; ## H10  FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK15  IOSTANDARD LVCMOS33} [get_ports rxd[3]]        ; ## H11  FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  AA15  IOSTANDARD LVCMOS33} [get_ports rxd[4]]        ; ## H13  FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS33} [get_ports rxd[5]]        ; ## H14  FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN  AJ16  IOSTANDARD LVCMOS33} [get_ports rxd[6]]        ; ## H16  FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  AK16  IOSTANDARD LVCMOS33} [get_ports rxd[7]]        ; ## H17  FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS33} [get_ports rxd[8]]        ; ## H19  FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN  AB14  IOSTANDARD LVCMOS33} [get_ports rxd[9]]        ; ## H20  FMC_LPC_LA15_N
set_property  -dict {PACKAGE_PIN  AF18  IOSTANDARD LVCMOS33} [get_ports rxd[10]]       ; ## C18  FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN  AF17  IOSTANDARD LVCMOS33} [get_ports rxd[11]]       ; ## C19  FMC_LPC_LA14_N

set_property  -dict {PACKAGE_PIN  AF15  IOSTANDARD LVCMOS33} [get_ports tx_clk]        ; ## D08  FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AH16  IOSTANDARD LVCMOS33} [get_ports txiq]          ; ## D18  FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN  AG12  IOSTANDARD LVCMOS33} [get_ports txd[0]]        ; ## G09  FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  AH12  IOSTANDARD LVCMOS33} [get_ports txd[1]]        ; ## G10  FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  AD14  IOSTANDARD LVCMOS33} [get_ports txd[2]]        ; ## G12  FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  AD13  IOSTANDARD LVCMOS33} [get_ports txd[3]]        ; ## G13  FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  AD16  IOSTANDARD LVCMOS33} [get_ports txd[4]]        ; ## G15  FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  AD15  IOSTANDARD LVCMOS33} [get_ports txd[5]]        ; ## G16  FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS33} [get_ports txd[6]]        ; ## G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  AE17  IOSTANDARD LVCMOS33} [get_ports txd[7]]        ; ## G19  FMC_LPC_LA16_N
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS33} [get_ports txd[8]]        ; ## C10  FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN  AC12  IOSTANDARD LVCMOS33} [get_ports txd[9]]        ; ## C11  FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN  AC14  IOSTANDARD LVCMOS33} [get_ports txd[10]]       ; ## C14  FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN  AC13  IOSTANDARD LVCMOS33} [get_ports txd[11]]       ; ## C15  FMC_LPC_LA10_N

set_property  -dict {PACKAGE_PIN  AF30  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_m2k_fmc_sda];    ## H28  FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN  AG30  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_m2k_fmc_scl];    ## H29  FMC_LPC_LA24_N

create_clock -name rx_clk    -period   10.00 [get_ports rx_clk]
create_clock -name tx_clk    -period   6.66  [get_ports tx_clk]
create_clock -name data_clk  -period   12.5  [get_ports data_bd[0]]

create_clock -name clk_fpga_0 -period 36 [get_pins "i_system_wrapper/system_i/sys_ps7/inst/PS7_i/FCLKCLK[0]"]
create_clock -name clk_fpga_1 -period 10 [get_pins "i_system_wrapper/system_i/sys_ps7/inst/PS7_i/FCLKCLK[1]"]
create_clock -name clk_fpga_3 -period 18 [get_pins "i_system_wrapper/system_i/sys_ps7/inst/PS7_i/FCLKCLK[3]"]

set_clock_groups -name exclusive_ -physically_exclusive -group [get_clocks data_clk] -group [get_clocks rx_clk]
