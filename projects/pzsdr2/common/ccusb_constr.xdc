# Default constraints have LVCMOS25, overwite it
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports iic_scl]                             ;
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports iic_sda]                             ;

# USB_FX3

set_property  -dict {PACKAGE_PIN  J11   IOSTANDARD LVCMOS18} [get_ports data[30]]         ;
set_property  -dict {PACKAGE_PIN  H11   IOSTANDARD LVCMOS18} [get_ports data[31]]         ;
set_property  -dict {PACKAGE_PIN  H9    IOSTANDARD LVCMOS18} [get_ports data[24]]         ;
set_property  -dict {PACKAGE_PIN  G9    IOSTANDARD LVCMOS18} [get_ports data[27]]         ;
set_property  -dict {PACKAGE_PIN  J10   IOSTANDARD LVCMOS18} [get_ports data[26]]         ;
set_property  -dict {PACKAGE_PIN  J9    IOSTANDARD LVCMOS18} [get_ports data[21]]         ;
set_property  -dict {PACKAGE_PIN  F5    IOSTANDARD LVCMOS18} [get_ports data[18]]         ;
set_property  -dict {PACKAGE_PIN  E5    IOSTANDARD LVCMOS18} [get_ports data[19]]         ;
set_property  -dict {PACKAGE_PIN  F9    IOSTANDARD LVCMOS18} [get_ports data[23]]         ;
set_property  -dict {PACKAGE_PIN  E8    IOSTANDARD LVCMOS18} [get_ports data[20]]         ;
set_property  -dict {PACKAGE_PIN  E7    IOSTANDARD LVCMOS18} [get_ports data[2]]          ;
set_property  -dict {PACKAGE_PIN  C8    IOSTANDARD LVCMOS18} [get_ports data[14]]         ;
set_property  -dict {PACKAGE_PIN  C7    IOSTANDARD LVCMOS18} [get_ports data[13]]         ;
set_property  -dict {PACKAGE_PIN  C9    IOSTANDARD LVCMOS18} [get_ports data[9]]          ;
set_property  -dict {PACKAGE_PIN  B9    IOSTANDARD LVCMOS18} [get_ports data[12]]         ;
set_property  -dict {PACKAGE_PIN  A9    IOSTANDARD LVCMOS18} [get_ports data[8]]          ;
set_property  -dict {PACKAGE_PIN  A8    IOSTANDARD LVCMOS18} [get_ports data[7]]          ;
set_property  -dict {PACKAGE_PIN  C4    IOSTANDARD LVCMOS18} [get_ports data[3]]          ;
set_property  -dict {PACKAGE_PIN  C3    IOSTANDARD LVCMOS18} [get_ports data[0]]          ;
set_property  -dict {PACKAGE_PIN  B6    IOSTANDARD LVCMOS18} [get_ports data[4]]          ;
set_property  -dict {PACKAGE_PIN  A5    IOSTANDARD LVCMOS18} [get_ports data[5]]          ;
set_property  -dict {PACKAGE_PIN  G6    IOSTANDARD LVCMOS18} [get_ports data[28]]         ;
set_property  -dict {PACKAGE_PIN  H7    IOSTANDARD LVCMOS18} [get_ports data[29]]         ;
set_property  -dict {PACKAGE_PIN  J8    IOSTANDARD LVCMOS18} [get_ports data[25]]         ;
set_property  -dict {PACKAGE_PIN  D9    IOSTANDARD LVCMOS18} [get_ports data[22]]         ;
set_property  -dict {PACKAGE_PIN  E6    IOSTANDARD LVCMOS18} [get_ports data[16]]         ;
set_property  -dict {PACKAGE_PIN  G7    IOSTANDARD LVCMOS18} [get_ports data[17]]         ;
set_property  -dict {PACKAGE_PIN  D6    IOSTANDARD LVCMOS18} [get_ports data[15]]         ;
set_property  -dict {PACKAGE_PIN  B10   IOSTANDARD LVCMOS18} [get_ports data[11]]         ;
set_property  -dict {PACKAGE_PIN  B7    IOSTANDARD LVCMOS18} [get_ports data[10]]         ;
set_property  -dict {PACKAGE_PIN  B5    IOSTANDARD LVCMOS18} [get_ports data[6]]          ;
set_property  -dict {PACKAGE_PIN  A4    IOSTANDARD LVCMOS18} [get_ports data[1]]          ;

set_property  -dict {PACKAGE_PIN  F8    IOSTANDARD LVCMOS18} [get_ports pclk]             ;

set_property  -dict {PACKAGE_PIN  A7    IOSTANDARD LVCMOS18} [get_ports addr[0]]          ;
set_property  -dict {PACKAGE_PIN  A3    IOSTANDARD LVCMOS18} [get_ports addr[1]]          ;
set_property  -dict {PACKAGE_PIN  AD19  IOSTANDARD LVCMOS18} [get_ports addr[2]]          ;
set_property  -dict {PACKAGE_PIN  AD20  IOSTANDARD LVCMOS18} [get_ports addr[3]]          ;
set_property  -dict {PACKAGE_PIN  AC22  IOSTANDARD LVCMOS18} [get_ports addr[4]]          ;

set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS18} [get_ports slcs_n]           ;
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVCMOS18} [get_ports slwr_n]           ;
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS18} [get_ports sloe_n]           ;
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS18} [get_ports slrd_n]           ;
set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS18} [get_ports pktend_n]         ;

set_property  -dict {PACKAGE_PIN  H8    IOSTANDARD LVCMOS18} [get_ports usb_fx3_uart_tx]  ;
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVCMOS18} [get_ports usb_fx3_uart_rx]  ;

set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS18} [get_ports fifo_rdy[0]]      ;
set_property  -dict {PACKAGE_PIN  AC21  IOSTANDARD LVCMOS18} [get_ports fifo_rdy[1]]      ;
set_property  -dict {PACKAGE_PIN  G5    IOSTANDARD LVCMOS18} [get_ports fifo_rdy[2]]      ;
set_property  -dict {PACKAGE_PIN  H6    IOSTANDARD LVCMOS18} [get_ports fifo_rdy[3]]      ;
set_property  -dict {PACKAGE_PIN  D8    IOSTANDARD LVCMOS18} [get_ports fifo_rdy[4]]      ;
set_property  -dict {PACKAGE_PIN  D5    IOSTANDARD LVCMOS18} [get_ports fifo_rdy[5]]      ;
set_property  -dict {PACKAGE_PIN  F7    IOSTANDARD LVCMOS18} [get_ports fifo_rdy[6]]      ;
set_property  -dict {PACKAGE_PIN  C6    IOSTANDARD LVCMOS18} [get_ports fifo_rdy[7]]      ;

set_property  -dict {PACKAGE_PIN  AE20  IOSTANDARD LVCMOS18} [get_ports flag_a]      ;
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS18} [get_ports flag_b]      ;

set_property  -dict {PACKAGE_PIN  A10   IOSTANDARD LVCMOS18} [get_ports pmode[0]]        ;
set_property  -dict {PACKAGE_PIN  K10   IOSTANDARD LVCMOS18} [get_ports pmode[1]]        ;
set_property  -dict {PACKAGE_PIN  B4    IOSTANDARD LVCMOS18} [get_ports pmode[2]]        ;

set_property  -dict {PACKAGE_PIN  AC23  IOSTANDARD LVCMOS18} [get_ports reset_n]         ;
set_property  -dict {PACKAGE_PIN  AD18  IOSTANDARD LVCMOS18} [get_ports epswitch_n]      ;
