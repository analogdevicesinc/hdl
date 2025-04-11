###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# DAC SPI interface
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { spi_csb }]  ; #IO_L11N_T1_SRCC_34 Sch=ck_io[10]
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { spi_sdo }]  ; #IO_L12N_T1_MRCC_35 Sch=ck_io[11]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { spi_sdi }]  ; #IO_L14P_T2_AD4P_SRCC_35 Sch=ck_io[12]
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { spi_sclk }] ; #IO_L19N_T3_VREF_35 Sch=ck_io[13]

# DAC GPIO interface
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { shdn }]     ; #IO_L6N_T0_VREF_34 Sch=ck_io[7]
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports { resetb }]   ; #IO_L13P_T2_MRCC_34 Sch=ck_io[8]
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { ldacb_tgp }]; #IO_L8N_T1_AD10N_35 Sch=ck_io[9]

# gpio (switches, leds and such)
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports led[0]]; 
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports led[1]]; 
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports led[2]]; 
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports led[3]]; 
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports led[4]]; 
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports led[5]]; 
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports btn[0]]; 
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports btn[1]];