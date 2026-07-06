###############################################################################
## Copyright (C) 2022-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports cn0561_spi_sdi]     ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports cn0561_spi_sdo]     ; ## FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports cn0561_spi_sclk]    ; ## FMC_LPC_LA01_P_CC
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports cn0561_spi_cs]      ; ## FMC_LPC_LA05_P

set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports cn0561_dclk]        ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports cn0561_din[0]]      ; ## FMC_LPC_LA00_N_CC
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports cn0561_din[1]]      ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports cn0561_din[2]]      ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports cn0561_din[3]]      ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports cn0561_odr]         ; ## FMC_LPC_LA00_P_CC

set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports cn0561_pdn]         ; ## FMC_LPC_LA07_P

# Virtual clock representing DCLK/SCLK as seen by the AD4134
create_clock -period 20.0 -name cn0561_dclk_virt

# DOUTx input delay relative to DCLK
set_input_delay -clock cn0561_dclk_virt -max 8.2 [get_ports cn0561_din[*]]
set_input_delay -clock cn0561_dclk_virt -min 0.0 [get_ports cn0561_din[*]]

# SDO input delay relative to SCLK falling
set_input_delay -clock cn0561_dclk_virt -clock_fall -max 8.0 [get_ports cn0561_spi_sdi]
set_input_delay -clock cn0561_dclk_virt -clock_fall -min 0.0 [get_ports cn0561_spi_sdi]

set_false_path -from [get_clocks cn0561_dclk_virt] -to [get_clocks mmcm_clk_0_s]
