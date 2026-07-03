###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_sck_o];  #JA1 Pmod 
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_io1_i_miso]; #JA2
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_io0_o_mosi  ];#JA3 
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33}                 [get_ports SPI_0_ss_o_cs_n ]; #JA4

#iic
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33 PULLTYPE PULLUP }                 [get_ports iic_scl_io  ];#JA7
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33 PULLTYPE PULLUP}                 [get_ports iic_sda_io ]; #JA8

#uart
set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS33}                 [get_ports uart_rx  ];#JA9
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33}                 [get_ports uart_tx ]; #JA10


#GPIO
set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVCMOS33} [get_ports data_o]