# Default constraints have LVCMOS25, overwite it
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports iic_scl]                                           ; ## IO_L5P_T0_13
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports iic_sda]                                           ; ## IO_L5N_T0_13

# USB_FX3

set_property  -dict {PACKAGE_PIN  J11   IOSTANDARD LVCMOS18} [get_ports data[0]]        ; ## IO_L01_34_JX4_P
set_property  -dict {PACKAGE_PIN  H11   IOSTANDARD LVCMOS18} [get_ports data[1]]        ; ## IO_L01_34_JX4_N
set_property  -dict {PACKAGE_PIN  H9    IOSTANDARD LVCMOS18} [get_ports data[2]]        ; ## IO_L03_34_JX4_P
set_property  -dict {PACKAGE_PIN  G9    IOSTANDARD LVCMOS18} [get_ports data[3]]        ; ## IO_L03_34_JX4_N
set_property  -dict {PACKAGE_PIN  J10   IOSTANDARD LVCMOS18} [get_ports data[4]]        ; ## IO_L05_34_JX4_P
set_property  -dict {PACKAGE_PIN  J9    IOSTANDARD LVCMOS18} [get_ports data[5]]        ; ## IO_L05_34_JX4_N
set_property  -dict {PACKAGE_PIN  F5    IOSTANDARD LVCMOS18} [get_ports data[6]]        ; ## IO_L07_34_JX4_P
set_property  -dict {PACKAGE_PIN  E5    IOSTANDARD LVCMOS18} [get_ports data[7]]        ; ## IO_L07_34_JX4_N
set_property  -dict {PACKAGE_PIN  F9    IOSTANDARD LVCMOS18} [get_ports data[8]]        ; ## IO_L09_34_JX4_P
set_property  -dict {PACKAGE_PIN  E8    IOSTANDARD LVCMOS18} [get_ports data[9]]        ; ## IO_L09_34_JX4_N
set_property  -dict {PACKAGE_PIN  F8    IOSTANDARD LVCMOS18} [get_ports data[10]]       ; ## IO_L11_SRCC_34_JX4_P
set_property  -dict {PACKAGE_PIN  E7    IOSTANDARD LVCMOS18} [get_ports data[11]]       ; ## IO_L11_SRCC_34_JX4_N
set_property  -dict {PACKAGE_PIN  C8    IOSTANDARD LVCMOS18} [get_ports data[12]]       ; ## IO_L13_MRCC_34_JX4_P
set_property  -dict {PACKAGE_PIN  C7    IOSTANDARD LVCMOS18} [get_ports data[13]]       ; ## IO_L13_MRCC_34_JX4_N
set_property  -dict {PACKAGE_PIN  C9    IOSTANDARD LVCMOS18} [get_ports data[14]]       ; ## IO_L15_34_JX4_P
set_property  -dict {PACKAGE_PIN  B9    IOSTANDARD LVCMOS18} [get_ports data[15]]       ; ## IO_L15_34_JX4_N
set_property  -dict {PACKAGE_PIN  J8    IOSTANDARD LVCMOS18} [get_ports data[16]]       ; ## IO_L06_34_JX4_P
set_property  -dict {PACKAGE_PIN  H8    IOSTANDARD LVCMOS18} [get_ports data[17]]       ; ## IO_L06_34_JX4_N
set_property  -dict {PACKAGE_PIN  D9    IOSTANDARD LVCMOS18} [get_ports data[18]]       ; ## IO_L08_34_JX4_P
set_property  -dict {PACKAGE_PIN  D8    IOSTANDARD LVCMOS18} [get_ports data[19]]       ; ## IO_L08_34_JX4_N
set_property  -dict {PACKAGE_PIN  E6    IOSTANDARD LVCMOS18} [get_ports data[20]]       ; ## IO_L10_34_JX4_P
set_property  -dict {PACKAGE_PIN  D5    IOSTANDARD LVCMOS18} [get_ports data[21]]       ; ## IO_L10_34_JX4_N
set_property  -dict {PACKAGE_PIN  G7    IOSTANDARD LVCMOS18} [get_ports data[22]]       ; ## IO_L12_MRCC_34_JX4_P
set_property  -dict {PACKAGE_PIN  F7    IOSTANDARD LVCMOS18} [get_ports data[23]]       ; ## IO_L12_MRCC_34_JX4_N
set_property  -dict {PACKAGE_PIN  D6    IOSTANDARD LVCMOS18} [get_ports data[24]]       ; ## IO_L14_SRCC_34_JX4_P
set_property  -dict {PACKAGE_PIN  C6    IOSTANDARD LVCMOS18} [get_ports data[25]]       ; ## IO_L14_SRCC_34_JX4_N
set_property  -dict {PACKAGE_PIN  B10   IOSTANDARD LVCMOS18} [get_ports data[26]]       ; ## IO_L16_34_JX4_P
set_property  -dict {PACKAGE_PIN  A10   IOSTANDARD LVCMOS18} [get_ports data[27]]       ; ## IO_L16_34_JX4_N
set_property  -dict {PACKAGE_PIN  B7    IOSTANDARD LVCMOS18} [get_ports data[28]]       ; ## IO_L18_34_JX4_P
set_property  -dict {PACKAGE_PIN  A7    IOSTANDARD LVCMOS18} [get_ports data[29]]       ; ## IO_L18_34_JX4_N
set_property  -dict {PACKAGE_PIN  B5    IOSTANDARD LVCMOS18} [get_ports data[30]]       ; ## IO_L20_34_JX4_P
set_property  -dict {PACKAGE_PIN  B4    IOSTANDARD LVCMOS18} [get_ports data[31]]       ; ## IO_L20_34_JX4_N

set_property  -dict {PACKAGE_PIN  A9    IOSTANDARD LVCMOS18} [get_ports pclk]           ; ## IO_L17_34_JX4_P

set_property  -dict {PACKAGE_PIN  G6    IOSTANDARD LVCMOS18} [get_ports addr[0]]        ; ## IO_L02_34_JX4_P
set_property  -dict {PACKAGE_PIN  AD18  IOSTANDARD LVCMOS18} [get_ports addr[1]]        ; ## IO_L17_13_JX2_P
#set_property  -dict {PACKAGE_PIN  AD29  IOSTANDARD LVCMOS18} [get_ports addr[2]]        ; ## G34   FMC_LPC_LA31_N
#set_property  -dict {PACKAGE_PIN  AC29  IOSTANDARD LVCMOS18} [get_ports addr[3]]        ; ## G33   FMC_LPC_LA31_P
#set_property  -dict {PACKAGE_PIN  AF25  IOSTANDARD LVCMOS18} [get_ports addr[4]]        ; ## G31   FMC_LPC_LA29_N

set_property  -dict {PACKAGE_PIN  A8    IOSTANDARD LVCMOS18} [get_ports slcs_n]         ; ## IO_L17_34_JX4_N
set_property  -dict {PACKAGE_PIN  C4    IOSTANDARD LVCMOS18} [get_ports slwr_n]         ; ## IO_L19_34_JX4_P
set_property  -dict {PACKAGE_PIN  C3    IOSTANDARD LVCMOS18} [get_ports sloe_n]         ; ## IO_L19_34_JX4_N
set_property  -dict {PACKAGE_PIN  B6    IOSTANDARD LVCMOS18} [get_ports slrd_n]         ; ## IO_L21_34_JX4_P
set_property  -dict {PACKAGE_PIN  AD20  IOSTANDARD LVCMOS18} [get_ports pktend_n]       ; ## IO_L13_MRCC_13_JX2_P

set_property  -dict {PACKAGE_PIN  AC22  IOSTANDARD LVCMOS18} [get_ports usb_fx3_uart_tx] ; ## IO_L14_SRCC_13_JX2_N
set_property  -dict {PACKAGE_PIN  AE20  IOSTANDARD LVCMOS18} [get_ports usb_fx3_uart_rx] ; ## IO_L16_13_JX2_P

set_property  -dict {PACKAGE_PIN  A5    IOSTANDARD LVCMOS18} [get_ports fifo_rdy[0]]       ; ## IO_L21_34_JX4_N
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS18} [get_ports fifo_rdy[1]]       ; ## IO_L11_SRCC_13_JX2_P
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS18} [get_ports fifo_rdy[2]]       ; ## IO_L11_SRCC_13_JX2_N
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS18} [get_ports fifo_rdy[3]]       ; ## IO_L13_MRCC_13_JX2_N

set_property  -dict {PACKAGE_PIN  G5    IOSTANDARD LVCMOS18} [get_ports pmode[0]]       ; ## IO_L02_34_JX4_N
set_property  -dict {PACKAGE_PIN  H7    IOSTANDARD LVCMOS18} [get_ports pmode[1]]       ; ## IO_L04_34_JX4_P
