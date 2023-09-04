###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad3552r_fmc SPI interface

set_property -dict {PACKAGE_PIN AD2 IOSTANDARD LVCMOS18} [get_ports {ad3552r_spi_sdio[0]}] ; #FMC1_LA02_P 
set_property -dict {PACKAGE_PIN AD1 IOSTANDARD LVCMOS18} [get_ports {ad3552r_spi_sdio[1]}] ; #FMC1_LA02_N
set_property -dict {PACKAGE_PIN AH1 IOSTANDARD LVCMOS18} [get_ports {ad3552r_spi_sdio[2]}] ; #FMC1_LA03_P
set_property -dict {PACKAGE_PIN AJ1 IOSTANDARD LVCMOS18} [get_ports {ad3552r_spi_sdio[3]}] ; #FMC1_LA03_N

set_property -dict {PACKAGE_PIN AE5 IOSTANDARD LVCMOS18} [get_ports ad3552r_spi_sclk]      ; #FMC1_LA00_CC_P
set_property -dict {PACKAGE_PIN AF5 IOSTANDARD LVCMOS18} [get_ports ad3552r_spi_cs]        ; #FMC1_LA00_CC_N

set_property -dict {PACKAGE_PIN AG3 IOSTANDARD LVCMOS18} [get_ports ad3552r_ldacn]         ; #FMC1_LA05_P
set_property -dict {PACKAGE_PIN AH3 IOSTANDARD LVCMOS18} [get_ports ad3552r_resetn]        ; #FMC1_LA05_N
set_property -dict {PACKAGE_PIN AF2 IOSTANDARD LVCMOS18} [get_ports ad3552r_alertn]        ; #FMC1_LA04_P
set_property -dict {PACKAGE_PIN AF1 IOSTANDARD LVCMOS18} [get_ports ad3552r_qspi_sel]      ; #FMC1_LA04_N

set_property -dict {PACKAGE_PIN AH2 IOSTANDARD LVCMOS18} [get_ports ad3552r_gpio_6]        ; #FMC1_LA06_P
set_property -dict {PACKAGE_PIN AJ2 IOSTANDARD LVCMOS18} [get_ports ad3552r_gpio_7]        ; #FMC1_LA06_N
set_property -dict {PACKAGE_PIN AD4 IOSTANDARD LVCMOS18} [get_ports ad3552r_gpio_8]        ; #FMC1_LA07_P
set_property -dict {PACKAGE_PIN AE4 IOSTANDARD LVCMOS18} [get_ports ad3552r_gpio_9]        ; #FMC1_LA07_N


####### SWITCH PINS ############
## FMC signals : RESET_N/GPIO0/GPIO1/GPIO2/GPIO3/TIMER1/TIMER2/TIMER3

set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS18} [get_ports tsn_gpio0]              ; #FMC0_LA10_P
set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS18} [get_ports tsn_gpio1]              ; #FMC0_LA10_N
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS18} [get_ports tsn_gpio2]             ; #FMC0_LA11_P
set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS18} [get_ports tsn_gpio3]             ; #FMC0_LA11_N

set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS18} [get_ports tsn_timer1]             ; #FMC0_LA12_N
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS18} [get_ports tsn_timer2]            ; #FMC0_LA13_P
set_property -dict {PACKAGE_PIN AC8 IOSTANDARD LVCMOS18} [get_ports tsn_timer3]            ; #FMC0_LA13_N

set_property -dict {PACKAGE_PIN AC7 IOSTANDARD LVCMOS18} [get_ports tsn_rst_n]             ; #FMC0_LA14_P

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tsn_timer2_IBUF_inst/O]

create_clock -period 32.000 -name ref_clk [get_ports tsn_timer2]
