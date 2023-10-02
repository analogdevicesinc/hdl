###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# PMOD JA

set_property -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33} [get_ports gain0_o]                       ; ## PMOD [2] PMOD JA1  IO_L10P_T1
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports gain1_o]                       ; ## PMOD [4] PMOD JA2  IO_L8P_T1
set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33} [get_ports led_clk_o]                     ; ## PMOD [8] PMOD JA4  IO_L11P_T1_SRCC
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33} [get_ports {spi_cs[1]}]                   ; ## PMOD [6] PMOD JA3  IO_L10N_T1
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports {spi_cs[0]}]                   ; ## PMOD [1] PMOD JA7  IO_L8N_T1
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33 PULLUP true} [get_ports spi_sdo]           ; ## PMOD [3] PMOD JA8  IO_L9P_T1_DQS
set_property -dict {PACKAGE_PIN AB9  IOSTANDARD LVCMOS33 PULLUP true} [get_ports spi_sdi]           ; ## PMOD [5] PMOD JA9  IO_L9N_T1_DQS
set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVCMOS33} [get_ports spi_sclk]                      ; ## PMOD [7] PMOD JA10 IO_L11N_T1_SRCC
