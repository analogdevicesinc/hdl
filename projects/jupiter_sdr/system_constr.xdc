###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
################################################################################

# jupiter_sdr pinout

set_property -dict {PACKAGE_PIN J7 IOSTANDARD LVCMOS18} [get_ports gp_int]                                      ; ## IO_L24P_65_ADRV9002_GP_INT
set_property -dict {PACKAGE_PIN L4 IOSTANDARD LVCMOS18} [get_ports mode]                                        ; ## IO_65_ADRV9002_MODE
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS18} [get_ports resetb]                                      ; ## IO_65_ADRV9002_RST
set_property -dict {PACKAGE_PIN J6 IOSTANDARD LVCMOS18} [get_ports clksrc]                                      ; ## IO_66_ADRV9002_CLKSRC

set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS18} [get_ports spi_di]                                      ; ## IO_L2P_65_SPI_DO
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS18} [get_ports spi_do]                                      ; ## IO_L1N_65_SPI_DI
set_property -dict {PACKAGE_PIN M7 IOSTANDARD LVCMOS18} [get_ports spi_enb]                                     ; ## IO_65_SPI_ENB
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS18} [get_ports spi_clk]                                     ; ## IO_L1P_65_SPICLK

set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS18} [get_ports usb_flash_prog_en]                           ; ## IO_66_USB_FLASH_PROG_EN
set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS18} [get_ports usb_pd_reset]                                ; ## IO_66_USB_PD_RESET
set_property -dict {PACKAGE_PIN D8 IOSTANDARD LVCMOS18} [get_ports vin_poe_valid_n]                             ; ## VIN_POE_VALID_N
set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS18} [get_ports vin_usb2_valid_n]                            ; ## VIN_USB2_VALID_N
set_property -dict {PACKAGE_PIN A7 IOSTANDARD LVCMOS18} [get_ports vin_usb1_valid_n]                            ; ## VIN_USB1_VALID_N

## ADRV9002 # BANK 65

set_property  -dict {PACKAGE_PIN V1    IOSTANDARD LVCMOS18}                      [get_ports rx1_enable]         ; ## IO_L2N_65_RX1_EN
set_property  -dict {PACKAGE_PIN P6    IOSTANDARD LVCMOS18}                      [get_ports rx2_enable]         ; ## IO_L10N_65_RX2_EN
set_property  -dict {PACKAGE_PIN K4    IOSTANDARD LVCMOS18}                      [get_ports tx1_enable]         ; ## IO_L23P_65_TX1_EN
set_property  -dict {PACKAGE_PIN J4    IOSTANDARD LVCMOS18}                      [get_ports tx2_enable]         ; ## IO_L23N_65_TX2_EN

set_property  -dict {PACKAGE_PIN R4    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx1_dclk_in_n]      ; ## IO_L11N_65_RX1_DCLK_OUT_N
set_property  -dict {PACKAGE_PIN P4    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx1_dclk_in_p]      ; ## IO_L11P_65_RX1_DCLK_OUT_P
set_property  -dict {PACKAGE_PIN P2    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx1_idata_in_n]     ; ## IO_L5N_65_RX1_IDATA_OUT_N
set_property  -dict {PACKAGE_PIN P3    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx1_idata_in_p]     ; ## IO_L5P_65_RX1_IDATA_OUT_P
set_property  -dict {PACKAGE_PIN U2    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx1_qdata_in_n]     ; ## IO_L6N_65_RX1_QDATA_OUT_N
set_property  -dict {PACKAGE_PIN T3    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx1_qdata_in_p]     ; ## IO_L6P_65_RX1_QDATA_OUT_P
set_property  -dict {PACKAGE_PIN V3    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx1_strobe_in_n]    ; ## IO_L4N_65_RX1_STROBE_OUT_N
set_property  -dict {PACKAGE_PIN U3    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx1_strobe_in_p]    ; ## IO_L4P_65_RX1_STROBE_OUT_P

set_property  -dict {PACKAGE_PIN R5    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx2_dclk_in_n]      ; ## IO_L12N_65_RX2_DCLK_OUT_N
set_property  -dict {PACKAGE_PIN R6    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx2_dclk_in_p]      ; ## IO_L12P_65_RX2_DCLK_OUT_P
set_property  -dict {PACKAGE_PIN T7    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx2_idata_in_n]     ; ## IO_L8N_65_RX2_IDATA_OUT_N
set_property  -dict {PACKAGE_PIN R7    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx2_idata_in_p]     ; ## IO_L8P_65_RX2_IDATA_OUT_P
set_property  -dict {PACKAGE_PIN T4    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx2_qdata_in_n]     ; ## IO_L9N_65_RX2_QDATA_OUT_N
set_property  -dict {PACKAGE_PIN T5    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx2_qdata_in_p]     ; ## IO_L9P_65_RX2_QDATA_OUT_P
set_property  -dict {PACKAGE_PIN U5    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx2_strobe_in_n]    ; ## IO_L7N_65_RX2_STROBE_OUT_N
set_property  -dict {PACKAGE_PIN U6    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports rx2_strobe_in_p]    ; ## IO_L7P_65_RX2_STROBE_OUT_P

set_property  -dict {PACKAGE_PIN J1    IOSTANDARD LVDS}                          [get_ports tx1_dclk_out_n]     ; ## IO_L15N_65_TX1_DCLK_IN_N
set_property  -dict {PACKAGE_PIN K1    IOSTANDARD LVDS}                          [get_ports tx1_dclk_out_p]     ; ## IO_L15P_65_TX1_DCLK_IN_P
set_property  -dict {PACKAGE_PIN L3    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports tx1_dclk_in_n]      ; ## IO_L13N_65_TX1_DCLK_OUT_N
set_property  -dict {PACKAGE_PIN M3    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports tx1_dclk_in_p]      ; ## IO_L13P_65_TX1_DCLK_OUT_P
set_property  -dict {PACKAGE_PIN J2    IOSTANDARD LVDS}                          [get_ports tx1_idata_out_n]    ; ## IO_L17N_65_TX1_IDATA_IN_N
set_property  -dict {PACKAGE_PIN J3    IOSTANDARD LVDS}                          [get_ports tx1_idata_out_p]    ; ## IO_L17P_65_TX1_IDATA_IN_P
set_property  -dict {PACKAGE_PIN K2    IOSTANDARD LVDS}                          [get_ports tx1_qdata_out_n]    ; ## IO_L18N_65_TX1_QDATA_IN_N
set_property  -dict {PACKAGE_PIN L2    IOSTANDARD LVDS}                          [get_ports tx1_qdata_out_p]    ; ## IO_L18P_65_TX1_QDATA_IN_P
set_property  -dict {PACKAGE_PIN M1    IOSTANDARD LVDS}                          [get_ports tx1_strobe_out_n]   ; ## IO_L16N_65_TX1_STROBE_IN_N
set_property  -dict {PACKAGE_PIN M2    IOSTANDARD LVDS}                          [get_ports tx1_strobe_out_p]   ; ## IO_L16P_65_TX1_STROBE_IN_P

set_property  -dict {PACKAGE_PIN L5    IOSTANDARD LVDS}                          [get_ports tx2_dclk_out_n]     ; ## IO_L19N_65_TX2_DCLK_IN_N
set_property  -dict {PACKAGE_PIN M6    IOSTANDARD LVDS}                          [get_ports tx2_dclk_out_p]     ; ## IO_L19P_65_TX2_DCLK_IN_P
set_property  -dict {PACKAGE_PIN N3    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports tx2_dclk_in_n]      ; ## IO_L14N_65_TX2_DCLK_OUT_N
set_property  -dict {PACKAGE_PIN N4    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports tx2_dclk_in_p]      ; ## IO_L14P_65_TX2_DCLK_OUT_P
set_property  -dict {PACKAGE_PIN K5    IOSTANDARD LVDS}                          [get_ports tx2_idata_out_n]    ; ## IO_L21N_65_TX2_IDATA_IN_N
set_property  -dict {PACKAGE_PIN K6    IOSTANDARD LVDS}                          [get_ports tx2_idata_out_p]    ; ## IO_L21P_65_TX2_IDATA_IN_P
set_property  -dict {PACKAGE_PIN K7    IOSTANDARD LVDS}                          [get_ports tx2_qdata_out_n]    ; ## IO_L22N_65_TX2_QDATA_IN_N
set_property  -dict {PACKAGE_PIN L7    IOSTANDARD LVDS}                          [get_ports tx2_qdata_out_p]    ; ## IO_L22P_65_TX2_QDATA_IN_P
set_property  -dict {PACKAGE_PIN M5    IOSTANDARD LVDS}                          [get_ports tx2_strobe_out_n]   ; ## IO_L20N_65_TX2_STROBE_IN_N
set_property  -dict {PACKAGE_PIN N5    IOSTANDARD LVDS}                          [get_ports tx2_strobe_out_p]   ; ## IO_L20P_65_TX2_STROBE_IN_P

# BANK 64

set_property  -dict {PACKAGE_PIN Y6    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports fpga_ref_clk_n]     ; ## IO_L12N_64_DEV_CLK_IN_N
set_property  -dict {PACKAGE_PIN W6    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports fpga_ref_clk_p]     ; ## IO_L12P_64_DEV_CLK_IN_P

set_property  -dict {PACKAGE_PIN P1    IOSTANDARD LVDS}                          [get_ports dev_mcs_fpga_out_n] ; ## IO_L3N_65_MCS_FPGA_IN_N
set_property  -dict {PACKAGE_PIN N1    IOSTANDARD LVDS}                          [get_ports dev_mcs_fpga_out_p] ; ## IO_L3P_65_MCS_FPGA_IN_P
set_property  -dict {PACKAGE_PIN AA5   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports fpga_mcs_in_n]      ; ## IO_L11N_64_EXT_MCS_IN_N
set_property  -dict {PACKAGE_PIN Y5    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports fpga_mcs_in_p]      ; ## IO_L11P_64_EXT_MCS_IN_P

set_property  -dict {PACKAGE_PIN AE9   IOSTANDARD LVCMOS18}                      [get_ports adrv9002_mcssrc]    ; ## IO_L4N_64_ADRV9002_MCSSRC
set_property  -dict {PACKAGE_PIN C1    IOSTANDARD LVCMOS18}                      [get_ports fan_en]             ; ## IO_L7P_66_FAN_EN
set_property  -dict {PACKAGE_PIN B1    IOSTANDARD LVCMOS18}                      [get_ports fan_ctl]            ; ## IO_L7N_66_FAN_CTL

set_property  -dict {PACKAGE_PIN AD6   IOSTANDARD LVCMOS18}                      [get_ports dgpio[0]]           ; ## IO_L5P_64_ADRV9002_DGPIO_0
set_property  -dict {PACKAGE_PIN AD5   IOSTANDARD LVCMOS18}                      [get_ports dgpio[1]]           ; ## IO_L5N_64_ADRV9002_DGPIO_1
set_property  -dict {PACKAGE_PIN AC9   IOSTANDARD LVCMOS18}                      [get_ports dgpio[2]]           ; ## IO_L6P_64_ADRV9002_DGPIO_2
set_property  -dict {PACKAGE_PIN AC8   IOSTANDARD LVCMOS18}                      [get_ports dgpio[3]]           ; ## IO_L6N_64_ADRV9002_DGPIO_3
set_property  -dict {PACKAGE_PIN AA9   IOSTANDARD LVCMOS18}                      [get_ports dgpio[4]]           ; ## IO_L7P_64_ADRV9002_DGPIO_4
set_property  -dict {PACKAGE_PIN AA8   IOSTANDARD LVCMOS18}                      [get_ports dgpio[5]]           ; ## IO_L7N_64_ADRV9002_DGPIO_5
set_property  -dict {PACKAGE_PIN AC4   IOSTANDARD LVCMOS18}                      [get_ports dgpio[6]]           ; ## IO_L14N_64_ADRV9002_DGPIO_6
set_property  -dict {PACKAGE_PIN AC1   IOSTANDARD LVCMOS18}                      [get_ports dgpio[7]]           ; ## IO_T2U_N12_64_ADRV9002_DGPIO_7
set_property  -dict {PACKAGE_PIN AB8   IOSTANDARD LVCMOS18}                      [get_ports dgpio[8]]           ; ## IO_L9P_64_ADRV9002_DGPIO_8
set_property  -dict {PACKAGE_PIN AB7   IOSTANDARD LVCMOS18}                      [get_ports dgpio[9]]           ; ## IO_L9N_64_ADRV9002_DGPIO_9
set_property  -dict {PACKAGE_PIN AE3   IOSTANDARD LVCMOS18}                      [get_ports dgpio[10]]          ; ## IO_L18N_64_ADRV9002_DGPIO_10
set_property  -dict {PACKAGE_PIN AE4   IOSTANDARD LVCMOS18}                      [get_ports dgpio[11]]          ; ## IO_L18P_64_ADRV9002_DGPIO_11

#set_property  -dict {PACKAGE_PIN AB3   IOSTANDARD LVCMOS18}                      [get_ports adrv9002_dev_clk]  ; ## IO_L13P_64_ADRV9002_DEV_CLK_OUT
#set_property  -dict {PACKAGE_PIN W8    IOSTANDARD LVCMOS18}                      [get_ports  s_1pps]           ; ## IO_L10P_64_1PPS

set_property  -dict {PACKAGE_PIN AE2   IOSTANDARD LVCMOS18}                      [get_ports rf_rx1a_mux_ctl]    ; ## IO_L15N_RF_RX1A_MUX_CTL
set_property  -dict {PACKAGE_PIN AD2   IOSTANDARD LVCMOS18}                      [get_ports rf_rx1b_mux_ctl]    ; ## IO_L15P_RF_RX1B_MUX_CTL
set_property  -dict {PACKAGE_PIN AB5   IOSTANDARD LVCMOS18}                      [get_ports rf_rx2a_mux_ctl]    ; ## IO_L14P_RF_RX2A_MUX_CTL
set_property  -dict {PACKAGE_PIN AC3   IOSTANDARD LVCMOS18}                      [get_ports rf_rx2b_mux_ctl]    ; ## IO_L13P_RF_RX2B_MUX_CTL
set_property  -dict {PACKAGE_PIN AD4   IOSTANDARD LVCMOS18}                      [get_ports rf_tx1_mux_ctl1]    ; ## IO_L16P_RF_TX1_MUX_CTL1
set_property  -dict {PACKAGE_PIN AD3   IOSTANDARD LVCMOS18}                      [get_ports rf_tx1_mux_ctl2]    ; ## IO_L16N_RF_TX1_MUX_CTL2
set_property  -dict {PACKAGE_PIN AD1   IOSTANDARD LVCMOS18}                      [get_ports rf_tx2_mux_ctl1]    ; ## IO_L17P_RF_TX2_MUX_CTL1
set_property  -dict {PACKAGE_PIN AE1   IOSTANDARD LVCMOS18}                      [get_ports rf_tx2_mux_ctl2]    ; ## IO_L17N_RF_TX2_MUX_CTL2

# EXTERNAL GPIO CONNECTOR # BANK 26 3V3

set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS33} [get_ports ext_gpio[0]];  # IO_L1P_AD11P_26  IO_L1P_AD11P_26
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports ext_gpio[1]];  # IO_L1N_AD11N_26  IO_L1N_AD11N_26
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports ext_gpio[2]];  # IO_L2P_AD10P_26  IO_L2P_AD10P_26
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports ext_gpio[3]];  # IO_L2N_AD10N_26  IO_L2N_AD10N_26
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports ext_gpio[4]];  # IO_L3P_AD9P_26   IO_L3P_AD9P_26
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports ext_gpio[5]];  # IO_L3N_AD9N_26   IO_L3N_AD9N_26
set_property -dict {PACKAGE_PIN C10 IOSTANDARD LVCMOS33} [get_ports ext_gpio[6]];  # IO_L4P_AD8P_26   IO_L4P_AD8P_26
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS33} [get_ports ext_gpio[7]];  # IO_L4N_AD8N_26   IO_L4N_AD8N_26
set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVCMOS33} [get_ports ext_gpio[8]];  # IO_L5P_AD7P_26   IO_L5P_HDGC_AD7P_26
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports ext_gpio[9]];  # IO_L5N_AD7N_26   IO_L5N_HDGC_AD7N_26
set_property -dict {PACKAGE_PIN D9  IOSTANDARD LVCMOS33} [get_ports ext_gpio[10]]; # IO_L6P_AD6P_26   IO_L6P_HDGC_AD6P_26
set_property -dict {PACKAGE_PIN C9  IOSTANDARD LVCMOS33} [get_ports ext_gpio[11]]; # IO_L6N_AD6N_26   IO_L6N_HDGC_AD6N_26
set_property -dict {PACKAGE_PIN F9  IOSTANDARD LVCMOS33} [get_ports ext_gpio[12]]; # IO_L7P_AD5P_26   IO_L7P_HDGC_AD5P_26
set_property -dict {PACKAGE_PIN E9  IOSTANDARD LVCMOS33} [get_ports ext_gpio[13]]; # IO_L7N_AD5N_26   IO_L7N_HDGC_AD5N_26
set_property -dict {PACKAGE_PIN E11 IOSTANDARD LVCMOS33} [get_ports ext_gpio[14]]; # IO_L8P_AD4P_26   IO_L8P_HDGC_AD4P_26
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVCMOS33} [get_ports ext_gpio[15]]; # IO_L8N_AD4N_26   IO_L8N_HDGC_AD4N_26

# add-on board connector

# BANK 26 3V3

set_property -dict {PACKAGE_PIN H10 IOSTANDARD LVCMOS33} [get_ports add_on_gpio[0]]  ; # IO_L9P_AD3P_26 -
set_property -dict {PACKAGE_PIN H9  IOSTANDARD LVCMOS33} [get_ports add_on_gpio[1]]  ; # IO_L9N_AD3N_26 -
set_property -dict {PACKAGE_PIN G10 IOSTANDARD LVCMOS33} [get_ports add_on_gpio[2]]  ; # IO_L10P_AD2P_26 -
set_property -dict {PACKAGE_PIN F10 IOSTANDARD LVCMOS33} [get_ports add_on_gpio[3]]  ; # IO_L10N_AD2N_26 -
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS33} [get_ports add_on_gpio[4]]  ; # IO_L11P_AD1P_26 -
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33} [get_ports add_on_gpio[5]]  ; # IO_L11N_AD1N_26 -
set_property -dict {PACKAGE_PIN G12 IOSTANDARD LVCMOS33} [get_ports add_on_gpio[6]]  ; # IO_L12P_AD0P_26
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS33} [get_ports add_on_gpio[7]]  ; # IO_L12N_AD0N_26

# BANK 64 1V8

set_property -dict {PACKAGE_PIN AC6 IOSTANDARD LVCMOS18} [get_ports add_on_gpio[8]]  ; # IO_L1N_T0L_N1_DBC_64
set_property -dict {PACKAGE_PIN AD8 IOSTANDARD LVCMOS18} [get_ports add_on_gpio[9]]  ; # IO_L2P_T0L_N2_64
set_property -dict {PACKAGE_PIN AD7 IOSTANDARD LVCMOS18} [get_ports add_on_gpio[10]] ; # IO_L2N_T0L_N3_64
set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS18} [get_ports add_on_gpio[11]] ; # IO_L21P_T3L_N4_AD8P_64
set_property -dict {PACKAGE_PIN AB1 IOSTANDARD LVCMOS18} [get_ports add_on_gpio[12]] ; # IO_L21N_T3L_N5_AD8N_64
set_property -dict {PACKAGE_PIN W1  IOSTANDARD LVCMOS18} [get_ports add_on_gpio[13]] ; # IO_L23P_T3U_N8_64
set_property -dict {PACKAGE_PIN Y1  IOSTANDARD LVCMOS18} [get_ports add_on_gpio[14]] ; # IO_L23N_T3U_N9_64
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS18} [get_ports add_on_power]    ; # IO_L1P_T0L_N0_DBC_64

## connect to system management (monitor)

set_property  -dict {PACKAGE_PIN G8   IOSTANDARD ANALOG} [get_ports s_1p0_rf_sns_p]        ; ##  G8  IO_L16P_66_1P0_RF_SNS_P
set_property  -dict {PACKAGE_PIN F8   IOSTANDARD ANALOG} [get_ports s_1p0_rf_sns_n]        ; ##  F8  IO_L16N_66_1P0_RF_SNS_N
set_property  -dict {PACKAGE_PIN H6   IOSTANDARD ANALOG} [get_ports s_1p8_rf_sns_p]        ; ##  H6  IO_L17P_66_1P8_RF_SNS_P
set_property  -dict {PACKAGE_PIN G6   IOSTANDARD ANALOG} [get_ports s_1p8_rf_sns_n]        ; ##  G6  IO_L17N_66_1P8_RF_SNS_N
set_property  -dict {PACKAGE_PIN G7   IOSTANDARD ANALOG} [get_ports s_1p3_rf_sns_p]        ; ##  G7  IO_L18P_66_1P3_RF_SNS_P
set_property  -dict {PACKAGE_PIN F7   IOSTANDARD ANALOG} [get_ports s_1p3_rf_sns_n]        ; ##  F7  IO_L18N_66_1P3_RF_SNS_N
set_property  -dict {PACKAGE_PIN A6   IOSTANDARD ANALOG} [get_ports s_5v0_rf_sns_p]        ; ##  A6  IO_L19P_66_5V0_RF_SNS_P
set_property  -dict {PACKAGE_PIN A5   IOSTANDARD ANALOG} [get_ports s_5v0_rf_sns_n]        ; ##  A5  IO_L19N_66_5V0_RF_SNS_N
set_property  -dict {PACKAGE_PIN C8   IOSTANDARD ANALOG} [get_ports s_2v5_sns_p]           ; ##  C8  IO_L20P_66_2V5_SNS_P
set_property  -dict {PACKAGE_PIN B8   IOSTANDARD ANALOG} [get_ports s_2v5_sns_n]           ; ##  B8  IO_L20N_66_2V5_SNS_N
set_property  -dict {PACKAGE_PIN C5   IOSTANDARD ANALOG} [get_ports s_vtt_ps_ddr4_sns_p]   ; ##  C5  IO_L21P_66_VTT_PS_DDR4_SNS_P
set_property  -dict {PACKAGE_PIN B5   IOSTANDARD ANALOG} [get_ports s_vtt_ps_ddr4_sns_n]   ; ##  B5  IO_L21N_66_VTT_PS_DDR4_SNS_N
set_property  -dict {PACKAGE_PIN A9   IOSTANDARD ANALOG} [get_ports s_1v2_ps_ddr4_sns_p]   ; ##  A9  IO_L22P_66_1V2_PS_DDR4_SNS_P
set_property  -dict {PACKAGE_PIN A8   IOSTANDARD ANALOG} [get_ports s_1v2_ps_ddr4_sns_n]   ; ##  A8  IO_L22N_66_1V2_PS_DDR4_SNS_N

set_property  -dict {PACKAGE_PIN G3   IOSTANDARD ANALOG} [get_ports s_0v85_mgtravcc_sns_p] ; ##  G3  IO_L4P_66_0V85_MGTRAVCC_SNS_P
set_property  -dict {PACKAGE_PIN F3   IOSTANDARD ANALOG} [get_ports s_0v85_mgtravcc_sns_n] ; ##  F3  IO_L4N_66_0V85_MGTRAVCC_SNS_N
set_property  -dict {PACKAGE_PIN H4   IOSTANDARD ANALOG} [get_ports s_5v0_sns_p]           ; ##  H4  IO_L6P_66_5V0_SNS_P
set_property  -dict {PACKAGE_PIN H3   IOSTANDARD ANALOG} [get_ports s_5v0_sns_n]           ; ##  H3  IO_L6N_66_5V0_SNS_N
set_property  -dict {PACKAGE_PIN A3   IOSTANDARD ANALOG} [get_ports s_1v2_sns_p]           ; ##  A3  IO_L8P_66_1V2_SNS_P
set_property  -dict {PACKAGE_PIN A2   IOSTANDARD ANALOG} [get_ports s_1v2_sns_n]           ; ##  A2  IO_L8N_66_1V2_SNS_N
set_property  -dict {PACKAGE_PIN B3   IOSTANDARD ANALOG} [get_ports s_1v8_mgtravtt_sns_p]  ; ##  B3  IO_L10P_66_1V8_MGTRAVTT_SNS_P
set_property  -dict {PACKAGE_PIN B2   IOSTANDARD ANALOG} [get_ports s_1v8_mgtravtt_sns_n]  ; ##  B2  IO_L10N_66_1V8_MGTRAVTT_SNS_N

# clocks

create_clock -name spi0_clk       -period  100   [get_pins -hier */EMIOSPI0SCLKO]

create_clock -name ref_clk        -period  8.00  [get_ports fpga_ref_clk_p]

create_clock -name rx1_dclk_out   -period  2.034 [get_ports rx1_dclk_in_p]
create_clock -name rx2_dclk_out   -period  2.034 [get_ports rx2_dclk_in_p]
create_clock -name tx1_dclk_out   -period  2.034 [get_ports tx1_dclk_in_p]
create_clock -name tx2_dclk_out   -period  2.034 [get_ports tx2_dclk_in_p]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_1 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_1_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_1_phy/i_clk_buf_fast/O]] \
  ]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_2 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_2_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_2_phy/i_clk_buf_fast/O]] \
  ]
