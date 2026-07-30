###############################################################################
## Copyright (C) 2019-2024,2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints

# gpio

set_property  -dict {PACKAGE_PIN  D20   IOSTANDARD LVCMOS33} [get_ports btn[0]]       ; ## BTN0
set_property  -dict {PACKAGE_PIN  D19   IOSTANDARD LVCMOS33} [get_ports btn[1]]       ; ## BTN1
set_property  -dict {PACKAGE_PIN  L15   IOSTANDARD LVCMOS33} [get_ports led[0]]       ; ## LED0_B
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS33} [get_ports led[1]]       ; ## LED0_R
set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS33} [get_ports led[2]]       ; ## LED0_G
set_property  -dict {PACKAGE_PIN  G14   IOSTANDARD LVCMOS33} [get_ports led[3]]       ; ## LED1_B
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS33} [get_ports led[4]]       ; ## LED1_R
set_property  -dict {PACKAGE_PIN  L14   IOSTANDARD LVCMOS33} [get_ports led[5]]       ; ## LED1_G

# iic

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports iic_ard_scl] ; ## Arduino_SCL
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports iic_ard_sda] ; ## Arduino_SDA



#  qspi interface

set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports {qspi_data[0] }]; #IO_L17P_T2_34 Sch=ja_p[1]
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports {qspi_data[1] }]; #IO_L17N_T2_34 Sch=ja_n[1]
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports {qspi_data[2] }]; #IO_L7P_T1_34 Sch=ja_p[2]
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports {qspi_data[3] }]; #IO_L7N_T1_34 Sch=ja_n[2]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports {sclk }]; #IO_L12P_T1_MRCC_34 Sch=ja_p[3]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {cs_n }]; #IO_L12N_T1_MRCC_34 Sch=ja_n[3]
