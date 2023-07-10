###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# coraz7s
# ad719x spi connections

set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {adc_spi_sclk}];      # IO_L7N_T1_34  Sch=ja_n[2]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {adc_spi_miso_rdyn}]; # IO_L7P_T1_34  Sch=ja_p[2]; AD719X sch=DOUT/RDY_N
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {adc_spi_mosi}];      # IO_L17N_T2_34 Sch=ja_n[1]; AD719X sch=DIN
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {adc_spi_csn}];       # IO_L17P_T2_34 Sch=ja_p[1]
