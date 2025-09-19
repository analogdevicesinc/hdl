###############################################################################
## Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# coraz7s
# ad719x spi connections

# connect through the Arduino header

set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports adc_spi_sclk];        # IO_L19N_T3_VREF_35 Sch=ck_io[13]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports adc_spi_miso_rdyn];   # IO_L14P_T2_AD4P_SRCC_35 Sch=ck_io[12]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports adc_spi_mosi];        # IO_L12N_T1_MRCC_35 Sch=ck_io[11]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports adc_spi_csn];         # IO_L11N_T1_SRCC_34 Sch=ck_io[10]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports adc_syncn];           # IO_L21P_T3_DQS_34 Sch=ck_io[4]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports adc_int];             # IO_L5P_T0_34 Sch=ck_io[2]
