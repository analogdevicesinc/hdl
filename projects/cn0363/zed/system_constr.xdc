###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# PMOD JA

set_property -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33} [get_ports gain0_o]                       ; ## PMOD JA1  
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports gain1_o]                       ; ## PMOD JA2 
set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33} [get_ports led_clk_o]                     ; ## PMOD JA4 
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33} [get_ports {spi_cs[1]}]                   ; ## PMOD JA3 
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports {spi_cs[0]}]                   ; ## PMOD JA7 
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33 PULLUP true} [get_ports spi_sdo]           ; ## PMOD JA8 
set_property -dict {PACKAGE_PIN AB9  IOSTANDARD LVCMOS33 PULLUP true} [get_ports spi_sdi]           ; ## PMOD JA9 
set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVCMOS33} [get_ports spi_sclk]                      ; ## PMOD JA10
