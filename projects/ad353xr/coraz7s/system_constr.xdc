###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# DAC SPI interface
set_property -dict {PACKAGE_PIN U15  IOSTANDARD LVCMOS33} [get_ports spi_csb]; #Sch=ck_io[10]
set_property -dict {PACKAGE_PIN K18  IOSTANDARD LVCMOS33} [get_ports spi_sdo]; #Sch=ck_io[11]
set_property -dict {PACKAGE_PIN J18  IOSTANDARD LVCMOS33} [get_ports spi_sdi]; #Sch=ck_io[12]
set_property -dict {PACKAGE_PIN G15  IOSTANDARD LVCMOS33} [get_ports spi_sck]; #Sch=ck_io[13]

# DAC GPIO interface
set_property -dict {PACKAGE_PIN N18  IOSTANDARD LVCMOS33} [get_ports dac_resetb]; #Sch=ck_io[8]
set_property -dict {PACKAGE_PIN R17  IOSTANDARD LVCMOS33} [get_ports dac_ldacb]; #Sch=ck_io[6]
