
# SPI interface

set_property -dict {PACKAGE_PIN J17  IOSTANDARD LVCMOS25} [get_ports spi_sclk]            ; ## FMC_LPC_LA15_N
set_property -dict {PACKAGE_PIN N18  IOSTANDARD LVCMOS25} [get_ports spi_sdi]             ; ## FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN J16  IOSTANDARD LVCMOS25} [get_ports spi_cs]              ; ## FMC_LPC_LA15_P

# GPIO signals

set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[0]]    ; ## FMC_LPC_LA21_P
set_property -dict {PACKAGE_PIN F18  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[1]]    ; ## FMC_LPC_LA26_P
set_property -dict {PACKAGE_PIN F19  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[2]]    ; ## FMC_LPC_LA22_N
set_property -dict {PACKAGE_PIN E21  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[3]]    ; ## FMC_LPC_LA27_P
set_property -dict {PACKAGE_PIN E20  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[4]]    ; ## FMC_LPC_LA21_N
set_property -dict {PACKAGE_PIN E18  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[5]]    ; ## FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN D22  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[6]]    ; ## FMC_LPC_LA25_P
set_property -dict {PACKAGE_PIN D21  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[7]]    ; ## FMC_LPC_LA27_N

# REF_PD and RBUF_PD

set_property -dict {PACKAGE_PIN A16  IOSTANDARD LVCMOS25} [get_ports adaq7980_ref_pd]     ; ## FMC_LPC_LA28_P
set_property -dict {PACKAGE_PIN C17  IOSTANDARD LVCMOS25} [get_ports adaq7980_rbuf_pd]    ; ## FMC_LPC_LA29_P

