
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_sck_o];  #CK_SCK
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_io1_i_miso]; #CK_MISO
set_property -dict {PACKAGE_PIN T12 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_io0_o_mosi  ];#CK_MOSI
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_ss_o_cs_n ]; #CK_SS

#iic - IOP
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33 PULLTYPE PULLUP }                 [get_ports iic_scl_io  ];#JA3_P
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33 PULLTYPE PULLUP}                 [get_ports iic_sda_io ]; #JA3_N

#uart -IOP
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33}                 [get_ports uart_rx  ];#JA4_P
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33}                 [get_ports uart_tx ]; #JA4_N


set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS33} [get_ports data_o]       ; ## LED0_R