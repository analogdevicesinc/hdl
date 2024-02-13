###############################################################################
## Copyright (C) 2020-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN  G15 IOSTANDARD LVCMOS33 IOB TRUE}                  [get_ports cn0540_spi_sclk]    ; ## CK_IO13
set_property -dict {PACKAGE_PIN  J18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP}  [get_ports cn0540_spi_miso]    ; ## CK_IO12
set_property -dict {PACKAGE_PIN  K18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP}  [get_ports cn0540_spi_mosi]    ; ## CK_IO11
set_property -dict {PACKAGE_PIN  U15 IOSTANDARD LVCMOS33 IOB TRUE}                  [get_ports cn0540_spi_cs]      ; ## CK_IO10

# reset and GPIO signals

set_property -dict {PACKAGE_PIN  M18 IOSTANDARD LVCMOS33}                           [get_ports cn0540_shutdown]    ; ## CK_IO9
set_property -dict {PACKAGE_PIN  R14 IOSTANDARD LVCMOS33}                           [get_ports cn0540_reset_adc]   ; ## CK_IO7
set_property -dict {PACKAGE_PIN  V18 IOSTANDARD LVCMOS33}                           [get_ports cn0540_csb_aux]     ; ## CK_IO5
set_property -dict {PACKAGE_PIN  V17 IOSTANDARD LVCMOS33}                           [get_ports cn0540_sw_ff]       ; ## CK_IO4
set_property -dict {PACKAGE_PIN  T15 IOSTANDARD LVCMOS33}                           [get_ports cn0540_drdy_aux]    ; ## CK_IO3
set_property -dict {PACKAGE_PIN  V13 IOSTANDARD LVCMOS33}                           [get_ports cn0540_blue_led]    ; ## CK_IO1
set_property -dict {PACKAGE_PIN  U14 IOSTANDARD LVCMOS33}                           [get_ports cn0540_yellow_led]  ; ## CK_IO0

# synchronization and timing

set_property -dict {PACKAGE_PIN  R17 IOSTANDARD LVCMOS33}                           [get_ports cn0540_sync_in]     ; ## CK_IO6
set_property -dict {PACKAGE_PIN  T14 IOSTANDARD LVCMOS33}                           [get_ports cn0540_drdy]        ; ## CK_IO2

set_property -dict {PACKAGE_PIN  P16 IOSTANDARD LVCMOS33}                           [get_ports cn0540_scl]         ; ## CK_SCL
set_property -dict {PACKAGE_PIN  P15 IOSTANDARD LVCMOS33}                           [get_ports cn0540_sda]         ; ## CK_SDA

# rename auto-generated clock for SPI Engine to spi_clk - 80MHz
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# create a generated clock for SCLK - fSCLK=spi_clk/2 - 20MHz
create_generated_clock -name SCLK_clk -source [get_pins -hier -filter name=~*sclk_reg/C] -edges {1 3 5} [get_ports cn0540_spi_sclk]

# input delays for MISO lines (SDO for the device)
set_input_delay -clock [get_clocks spi_clk] [get_property PERIOD [get_clocks spi_clk]] \
		[get_ports -filter {NAME =~ "cn0540_spi_miso"}]

## Dedicated Analog Inputs
set_property -dict { PACKAGE_PIN K9    IOSTANDARD LVCMOS33 } [get_ports { cn0540_xadc_mux_p }]; #VP_0 Sch=xadc_v_p
set_property -dict { PACKAGE_PIN L10   IOSTANDARD LVCMOS33 } [get_ports { cn0540_xadc_mux_n }]; #VN_0 Sch=xadc_v_n

## ChipKit Outer Analog Header - as Single-Ended Analog Inputs
## NOTE: These ports can be used as single-ended analog inputs with voltages from 0-3.3V (ChipKit analog pins A0-A5) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an0_p }]; #IO_L3P_T0_DQS_AD1P_35 Sch=ck_an_p[0]
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an0_n }]; #IO_L3N_T0_DQS_AD1N_35 Sch=ck_an_n[0]
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an1_p }]; #IO_L5P_T0_AD9P_35 Sch=ck_an_p[1]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an1_n }]; #IO_L5N_T0_AD9N_35 Sch=ck_an_n[1]
set_property -dict { PACKAGE_PIN K14   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an2_p }]; #IO_L20P_T3_AD6P_35 Sch=ck_an_p[2]
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an2_n }]; #IO_L20N_T3_AD6N_35 Sch=ck_an_n[2]
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an3_p }]; #IO_L24P_T3_AD15P_35 Sch=ck_an_p[3]
set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an3_n }]; #IO_L24N_T3_AD15N_35 Sch=ck_an_n[3]
set_property -dict { PACKAGE_PIN J20   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an4_p }]; #IO_L17P_T2_AD5P_35 Sch=ck_an_p[4]
set_property -dict { PACKAGE_PIN H20   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an4_n }]; #IO_L17N_T2_AD5N_35 Sch=ck_an_n[4]
set_property -dict { PACKAGE_PIN G19   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an5_p }]; #IO_L18P_T2_AD13P_35 Sch=ck_an_p[5]
set_property -dict { PACKAGE_PIN G20   IOSTANDARD LVCMOS33 } [get_ports { cn0540_ck_an5_n }]; #IO_L18N_T2_AD13N_35 Sch=ck_an_n[5]
