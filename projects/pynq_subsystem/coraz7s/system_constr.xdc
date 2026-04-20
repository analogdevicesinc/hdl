###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_sck_o];  #JA1_P
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_io1_i_miso]; #JA1_N
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_io0_o_mosi  ];#JA2_P
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_ss_o_cs_n ]; #JA2_N


#iic
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33 PULLTYPE PULLUP }                 [get_ports iic_scl_io  ];#JA3_P
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33 PULLTYPE PULLUP}                 [get_ports iic_sda_io ]; #JA3_N

#uart
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33}                 [get_ports uart_rx  ];#JA4_P
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33}                 [get_ports uart_tx ]; #JA4_N

#i3c
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33 PULLTYPE PULLUP }  [get_ports i3c_sda  ];#JB1_P
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 PULLTYPE PULLUP }  [get_ports i3c_scl  ];#JB1_N

