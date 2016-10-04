
# constraints
# USB_FX3

set_property  -dict {PACKAGE_PIN  AG17  IOSTANDARD LVCMOS25} [get_ports data[0]]        ; ## H04   FMC_LPC_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AE12  IOSTANDARD LVCMOS25} [get_ports data[1]]        ; ## H07   FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  AF12  IOSTANDARD LVCMOS25} [get_ports data[2]]        ; ## H08   FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  AJ15  IOSTANDARD LVCMOS25} [get_ports data[3]]        ; ## H10   FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK15  IOSTANDARD LVCMOS25} [get_ports data[4]]        ; ## H11   FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  AA15  IOSTANDARD LVCMOS25} [get_ports data[5]]        ; ## H13   FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS25} [get_ports data[6]]        ; ## H14   FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN  AJ16  IOSTANDARD LVCMOS25} [get_ports data[7]]        ; ## H16   FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  AK16  IOSTANDARD LVCMOS25} [get_ports data[8]]        ; ## H17   FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS25} [get_ports data[9]]        ; ## H19   FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN  AB14  IOSTANDARD LVCMOS25} [get_ports data[10]]       ; ## H20   FMC_LPC_LA15_N
set_property  -dict {PACKAGE_PIN  AH26  IOSTANDARD LVCMOS25} [get_ports data[11]]       ; ## H22   FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  AH27  IOSTANDARD LVCMOS25} [get_ports data[12]]       ; ## H23   FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN  AH28  IOSTANDARD LVCMOS25} [get_ports data[13]]       ; ## H25   FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN  AH29  IOSTANDARD LVCMOS25} [get_ports data[14]]       ; ## H26   FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN  AF30  IOSTANDARD LVCMOS25} [get_ports data[15]]       ; ## H28   FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN  AG30  IOSTANDARD LVCMOS25} [get_ports data[16]]       ; ## H29   FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN  AD25  IOSTANDARD LVCMOS25} [get_ports data[17]]       ; ## H31   FMC_LPC_LA28_P
set_property  -dict {PACKAGE_PIN  AE26  IOSTANDARD LVCMOS25} [get_ports data[18]]       ; ## H32   FMC_LPC_LA28_N
set_property  -dict {PACKAGE_PIN  AB29  IOSTANDARD LVCMOS25} [get_ports data[19]]       ; ## H34   FMC_LPC_LA30_P
set_property  -dict {PACKAGE_PIN  AB30  IOSTANDARD LVCMOS25} [get_ports data[20]]       ; ## H35   FMC_LPC_LA30_N
set_property  -dict {PACKAGE_PIN  Y26   IOSTANDARD LVCMOS25} [get_ports data[21]]       ; ## H37   FMC_LPC_LA32_P
set_property  -dict {PACKAGE_PIN  Y27   IOSTANDARD LVCMOS25} [get_ports data[22]]       ; ## H38   FMC_LPC_LA32_N
set_property  -dict {PACKAGE_PIN  AC28  IOSTANDARD LVCMOS25} [get_ports data[23]]       ; ## G02   FMC_LPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AD28  IOSTANDARD LVCMOS25} [get_ports data[24]]       ; ## G03   FMC_LPC_CLK1_M2C_N
set_property  -dict {PACKAGE_PIN  AG12  IOSTANDARD LVCMOS25} [get_ports data[25]]       ; ## G09   FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  AH12  IOSTANDARD LVCMOS25} [get_ports data[26]]       ; ## G10   FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  AD14  IOSTANDARD LVCMOS25} [get_ports data[27]]       ; ## G12   FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  AD13  IOSTANDARD LVCMOS25} [get_ports data[28]]       ; ## G13   FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  AD16  IOSTANDARD LVCMOS25} [get_ports data[29]]       ; ## G15   FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  AD15  IOSTANDARD LVCMOS25} [get_ports data[30]]       ; ## G16   FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS25} [get_ports data[31]]       ; ## G18   FMC_LPC_LA16_P

set_property  -dict {PACKAGE_PIN  AE13  IOSTANDARD LVCMOS25} [get_ports pclk]           ; ## G06   FMC_LPC_LA00_CC_P

set_property  -dict {PACKAGE_PIN  AA30  IOSTANDARD LVCMOS25} [get_ports addr[0]]        ; ## G37   FMC_LPC_LA33_N
set_property  -dict {PACKAGE_PIN  Y30   IOSTANDARD LVCMOS25} [get_ports addr[1]]        ; ## G36   FMC_LPC_LA33_P
#set_property  -dict {PACKAGE_PIN  AD29  IOSTANDARD LVCMOS25} [get_ports addr[2]]        ; ## G34   FMC_LPC_LA31_N
#set_property  -dict {PACKAGE_PIN  AC29  IOSTANDARD LVCMOS25} [get_ports addr[3]]        ; ## G33   FMC_LPC_LA31_P
#set_property  -dict {PACKAGE_PIN  AF25  IOSTANDARD LVCMOS33} [get_ports addr[4]]        ; ## G31   FMC_LPC_LA29_N

set_property  -dict {PACKAGE_PIN  AE17  IOSTANDARD LVCMOS25} [get_ports slcs_n]         ; ## G19   FMC_LPC_LA16_N
set_property  -dict {PACKAGE_PIN  AG26  IOSTANDARD LVCMOS25} [get_ports slwr_n]         ; ## G21   FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  AG27  IOSTANDARD LVCMOS25} [get_ports sloe_n]         ; ## G22   FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  AK27  IOSTANDARD LVCMOS25} [get_ports slrd_n]         ; ## G24   FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  AE25  IOSTANDARD LVCMOS25} [get_ports pktend_n]       ; ## G30   FMC_LPC_LA29_P

set_property  -dict {PACKAGE_PIN  AJ21  IOSTANDARD LVCMOS25} [get_ports usb_fx3_uart_tx] ; ## PMOD1_0, Connector J58 pin 1, 3.3V through level shifter
set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD LVCMOS25} [get_ports usb_fx3_uart_rx] ; ## PMOD1_4, Connector J58 pin 2, 3.3V through level shifter

set_property  -dict {PACKAGE_PIN  AK28  IOSTANDARD LVCMOS25} [get_ports fifo_rdy[0]]       ; ## G25   FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN  AF29  IOSTANDARD LVCMOS25} [get_ports fifo_rdy[1]]       ; ## G27   FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  AG29  IOSTANDARD LVCMOS25} [get_ports fifo_rdy[2]]       ; ## G28   FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN  AF25  IOSTANDARD LVCMOS25} [get_ports fifo_rdy[3]]       ; ## G31   FMC_LPC_LA29_N
#set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS33} [get_ports fifo_rdy[4]]       ; ## G18   FMC_LPC_LA16_P
#set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS33} [get_ports fifo_rdy[5]]       ; ## G18   FMC_LPC_LA16_P
#set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS33} [get_ports fifo_rdy[6]]       ; ## G18   FMC_LPC_LA16_P
#set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS33} [get_ports fifo_rdy[7]]       ; ## G18   FMC_LPC_LA16_P
#set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS33} [get_ports fifo_rdy[8]]       ; ## G18   FMC_LPC_LA16_P
#set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS33} [get_ports fifo_rdy[9]]       ; ## G18   FMC_LPC_LA16_P
#set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS33} [get_ports fifo_rdy[10]]      ; ## G18   FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  AE16  IOSTANDARD LVCMOS25} [get_ports pmode[0]]       ; ## D11   FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN  AE15  IOSTANDARD LVCMOS25} [get_ports pmode[1]]       ; ## D12   FMC_LPC_LA05_N
