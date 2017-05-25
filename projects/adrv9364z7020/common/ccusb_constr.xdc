# Default constraints have LVCMOS25, overwite it
#set_property  -dict {IOSTANDARD LVCMOS18} [get_ports iic_scl]                             ;
#set_property  -dict {IOSTANDARD LVCMOS18} [get_ports iic_sda]                             ;

# USB_FX3

set_property  -dict {PACKAGE_PIN  T11   IOSTANDARD LVCMOS25} [get_ports data[30]]         ;
set_property  -dict {PACKAGE_PIN  T10   IOSTANDARD LVCMOS25} [get_ports data[31]]         ;
set_property  -dict {PACKAGE_PIN  U13   IOSTANDARD LVCMOS25} [get_ports data[24]]         ;
set_property  -dict {PACKAGE_PIN  V13   IOSTANDARD LVCMOS25} [get_ports data[27]]         ;
set_property  -dict {PACKAGE_PIN  T14   IOSTANDARD LVCMOS25} [get_ports data[26]]         ;
set_property  -dict {PACKAGE_PIN  T15   IOSTANDARD LVCMOS25} [get_ports data[21]]         ;
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVCMOS25} [get_ports data[18]]         ;
set_property  -dict {PACKAGE_PIN  Y17   IOSTANDARD LVCMOS25} [get_ports data[19]]         ;
set_property  -dict {PACKAGE_PIN  T16   IOSTANDARD LVCMOS25} [get_ports data[23]]         ;
set_property  -dict {PACKAGE_PIN  U17   IOSTANDARD LVCMOS25} [get_ports data[20]]         ;
set_property  -dict {PACKAGE_PIN  U15   IOSTANDARD LVCMOS25} [get_ports data[2]]          ;
set_property  -dict {PACKAGE_PIN  N18   IOSTANDARD LVCMOS25} [get_ports data[14]]         ;
set_property  -dict {PACKAGE_PIN  P19   IOSTANDARD LVCMOS25} [get_ports data[13]]         ;
set_property  -dict {PACKAGE_PIN  T20   IOSTANDARD LVCMOS25} [get_ports data[9]]          ;
set_property  -dict {PACKAGE_PIN  U20   IOSTANDARD LVCMOS25} [get_ports data[12]]         ;
set_property  -dict {PACKAGE_PIN  Y18   IOSTANDARD LVCMOS25} [get_ports data[8]]          ;
set_property  -dict {PACKAGE_PIN  Y19   IOSTANDARD LVCMOS25} [get_ports data[7]]          ;
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVCMOS25} [get_ports data[3]]          ;
set_property  -dict {PACKAGE_PIN  R17   IOSTANDARD LVCMOS25} [get_ports data[0]]          ;
set_property  -dict {PACKAGE_PIN  V17   IOSTANDARD LVCMOS25} [get_ports data[4]]          ;
set_property  -dict {PACKAGE_PIN  V18   IOSTANDARD LVCMOS25} [get_ports data[5]]          ;
set_property  -dict {PACKAGE_PIN  T12   IOSTANDARD LVCMOS25} [get_ports data[28]]         ;
set_property  -dict {PACKAGE_PIN  V12   IOSTANDARD LVCMOS25} [get_ports data[29]]         ;
set_property  -dict {PACKAGE_PIN  P14   IOSTANDARD LVCMOS25} [get_ports data[25]]         ;
set_property  -dict {PACKAGE_PIN  W14   IOSTANDARD LVCMOS25} [get_ports data[22]]         ;
set_property  -dict {PACKAGE_PIN  V15   IOSTANDARD LVCMOS25} [get_ports data[16]]         ;
set_property  -dict {PACKAGE_PIN  U18   IOSTANDARD LVCMOS25} [get_ports data[17]]         ;
set_property  -dict {PACKAGE_PIN  N20   IOSTANDARD LVCMOS25} [get_ports data[15]]         ;
set_property  -dict {PACKAGE_PIN  V20   IOSTANDARD LVCMOS25} [get_ports data[11]]         ;
set_property  -dict {PACKAGE_PIN  V16   IOSTANDARD LVCMOS25} [get_ports data[10]]         ;
set_property  -dict {PACKAGE_PIN  T17   IOSTANDARD LVCMOS25} [get_ports data[6]]          ;
set_property  -dict {PACKAGE_PIN  W18   IOSTANDARD LVCMOS25} [get_ports data[1]]          ;

set_property  -dict {PACKAGE_PIN  U14   IOSTANDARD LVCMOS25} [get_ports pclk]             ;

set_property  -dict {PACKAGE_PIN  W16   IOSTANDARD LVCMOS25} [get_ports addr[0]]          ;
set_property  -dict {PACKAGE_PIN  W19   IOSTANDARD LVCMOS25} [get_ports addr[1]]          ;
set_property  -dict {PACKAGE_PIN  U8    IOSTANDARD LVCMOS25} [get_ports addr[2]]          ;
set_property  -dict {PACKAGE_PIN  Y7    IOSTANDARD LVCMOS25} [get_ports addr[3]]          ;
set_property  -dict {PACKAGE_PIN  Y8    IOSTANDARD LVCMOS25} [get_ports addr[4]]          ;

set_property  -dict {PACKAGE_PIN  Y6    IOSTANDARD LVCMOS25} [get_ports slcs_n]           ;
set_property  -dict {PACKAGE_PIN  W8    IOSTANDARD LVCMOS25} [get_ports slwr_n]           ;
set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD LVCMOS25} [get_ports sloe_n]           ;
set_property  -dict {PACKAGE_PIN  U7    IOSTANDARD LVCMOS25} [get_ports slrd_n]           ;
set_property  -dict {PACKAGE_PIN  W11   IOSTANDARD LVCMOS25} [get_ports pktend_n]         ;

set_property  -dict {PACKAGE_PIN  R14   IOSTANDARD LVCMOS25} [get_ports usb_fx3_uart_tx]  ;
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS25} [get_ports usb_fx3_uart_rx]  ;

set_property  -dict {PACKAGE_PIN  V8    IOSTANDARD LVCMOS25} [get_ports fifo_rdy[0]]      ;
set_property  -dict {PACKAGE_PIN  Y9    IOSTANDARD LVCMOS25} [get_ports fifo_rdy[1]]      ;
set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD LVCMOS25} [get_ports fifo_rdy[2]]      ;
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD LVCMOS25} [get_ports fifo_rdy[3]]      ;
set_property  -dict {PACKAGE_PIN  Y14   IOSTANDARD LVCMOS25} [get_ports fifo_rdy[4]]      ;
set_property  -dict {PACKAGE_PIN  W15   IOSTANDARD LVCMOS25} [get_ports fifo_rdy[5]]      ;
set_property  -dict {PACKAGE_PIN  U19   IOSTANDARD LVCMOS25} [get_ports fifo_rdy[6]]      ;
set_property  -dict {PACKAGE_PIN  P20   IOSTANDARD LVCMOS25} [get_ports fifo_rdy[7]]      ;

set_property  -dict {PACKAGE_PIN  W10   IOSTANDARD LVCMOS25} [get_ports flag_a]      ;
set_property  -dict {PACKAGE_PIN  W9    IOSTANDARD LVCMOS25} [get_ports flag_b]      ;


set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD LVCMOS25} [get_ports pmode[0]]         ;
set_property  -dict {PACKAGE_PIN  T19   IOSTANDARD LVCMOS25} [get_ports pmode[1]]         ;
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS25} [get_ports pmode[2]]         ;

set_property  -dict {PACKAGE_PIN  T9    IOSTANDARD LVCMOS25} [get_ports reset_n]          ;
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS25} [get_ports epswitch_n]       ;
