###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property  -dict {PACKAGE_PIN AA7   IOSTANDARD LVCMOS18}  [get_ports dev_clk_in]                        ; #FMC_HPC0_CLK0_M2C_P  IO_L12P_T1U_N10_GC_66
set_property  -dict {PACKAGE_PIN AC6   IOSTANDARD LVDS}      [get_ports dev_mcs_fpga_out_n]                ; #FMC_HPC0_LA14_N      IO_L7N_T1L_N1_QBC_AD13N_66
set_property  -dict {PACKAGE_PIN AC7   IOSTANDARD LVDS}      [get_ports dev_mcs_fpga_out_p]                ; #FMC_HPC0_LA14_P      IO_L7P_T1L_N0_QBC_AD13P_66

set_property  -dict {PACKAGE_PIN Y12   IOSTANDARD LVCMOS18}  [get_ports dgpio_0]                           ; #FMC_HPC0_LA16_P      IO_L5P_T0U_N8_AD14P_66
set_property  -dict {PACKAGE_PIN AA12  IOSTANDARD LVCMOS18}  [get_ports dgpio_1]                           ; #FMC_HPC0_LA16_N      IO_L5N_T0U_N9_AD14N_66
set_property  -dict {PACKAGE_PIN Y9    IOSTANDARD LVCMOS18}  [get_ports dgpio_2]                           ; #FMC_HPC0_LA15_N      IO_L6N_T0U_N11_AD6N_66
set_property  -dict {PACKAGE_PIN AB5   IOSTANDARD LVCMOS18}  [get_ports dgpio_3]                           ; #FMC_HPC0_LA11_N      IO_L10N_T1U_N7_QBC_AD4N_66
set_property  -dict {PACKAGE_PIN W1    IOSTANDARD LVCMOS18}  [get_ports dgpio_4]                           ; #FMC_HPC0_LA09_N      IO_L24N_T3U_N11_66
set_property  -dict {PACKAGE_PIN W4    IOSTANDARD LVCMOS18}  [get_ports dgpio_5]                           ; #FMC_HPC0_LA10_N      IO_L15N_T2L_N5_AD11N_66
set_property  -dict {PACKAGE_PIN M10   IOSTANDARD LVCMOS18}  [get_ports dgpio_6]                           ; #FMC_HPC0_LA27_P      IO_L15P_T2L_N4_AD11P_67
set_property  -dict {PACKAGE_PIN L15   IOSTANDARD LVCMOS18}  [get_ports dgpio_7]                           ; #FMC_HPC0_LA26_P      IO_L24P_T3U_N10_67
set_property  -dict {PACKAGE_PIN T7    IOSTANDARD LVCMOS18}  [get_ports dgpio_8]                           ; #FMC_HPC0_LA28_P      IO_L10P_T1U_N6_QBC_AD4P_67
set_property  -dict {PACKAGE_PIN T6    IOSTANDARD LVCMOS18}  [get_ports dgpio_9]                           ; #FMC_HPC0_LA28_N      IO_L10N_T1U_N7_QBC_AD4N_67
set_property  -dict {PACKAGE_PIN AB6   IOSTANDARD LVCMOS18}  [get_ports dgpio_10]                          ; #FMC_HPC0_LA11_P      IO_L10P_T1U_N6_QBC_AD4P_66
set_property  -dict {PACKAGE_PIN L10   IOSTANDARD LVCMOS18}  [get_ports dgpio_11]                          ; #FMC_HPC0_LA27_N      IO_L15N_T2L_N5_AD11N_67

set_property  -dict {PACKAGE_PIN T11   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports fpga_mcs_in_n]  ; #FMC_HPC0_LA32_N      IO_L6N_T0U_N11_AD6N_67
set_property  -dict {PACKAGE_PIN U11   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports fpga_mcs_in_p]  ; #FMC_HPC0_LA32_P      IO_L6P_T0U_N10_AD6P_67
set_property  -dict {PACKAGE_PIN R8    IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports fpga_ref_clk_n] ; #FMC_HPC0_CLK1_M2C_N  IO_L12N_T1U_N11_GC_67
set_property  -dict {PACKAGE_PIN T8    IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports fpga_ref_clk_p] ; #FMC_HPC0_CLK1_M2C_P  IO_L12P_T1U_N10_GC_67
set_property  -dict {PACKAGE_PIN V6    IOSTANDARD LVCMOS18}  [get_ports gp_int]                            ; #FMC_HPC0_LA30_P      IO_L8P_T1L_N2_AD5P_67
set_property  -dict {PACKAGE_PIN AB8   IOSTANDARD LVCMOS18}  [get_ports mode]                              ; #FMC_HPC0_LA13_P      IO_L8P_T1L_N2_AD5P_66
set_property  -dict {PACKAGE_PIN AC8   IOSTANDARD LVCMOS18}  [get_ports reset_trx]                         ; #FMC_HPC0_LA13_N      IO_L8N_T1L_N3_AD5N_66

set_property  -dict {PACKAGE_PIN W5    IOSTANDARD LVCMOS18}  [get_ports rx1_enable]                        ; #FMC_HPC0_LA10_P      IO_L15P_T2L_N4_AD11P_66
set_property  -dict {PACKAGE_PIN K15   IOSTANDARD LVCMOS18}  [get_ports rx2_enable]                        ; #FMC_HPC0_LA26_N      IO_L24N_T3U_N11_67

set_property  -dict {PACKAGE_PIN AA6   IOSTANDARD LVCMOS18}  [get_ports sm_fan_tach]                       ; #FMC_HPC0_CLK0_M2C_N  IO_L12N_T1U_N11_GC_66

set_property  -dict {PACKAGE_PIN W7    IOSTANDARD LVCMOS18}  [get_ports spi_clk]                           ; #FMC_HPC0_LA12_P      IO_L9P_T1L_N4_AD12P_66
set_property  -dict {PACKAGE_PIN U8    IOSTANDARD LVCMOS18}  [get_ports spi_dio]                           ; #FMC_HPC0_LA29_N      IO_L9N_T1L_N5_AD12N_67
set_property  -dict {PACKAGE_PIN W6    IOSTANDARD LVCMOS18}  [get_ports spi_do]                            ; #FMC_HPC0_LA12_N      IO_L9N_T1L_N5_AD12N_66
set_property  -dict {PACKAGE_PIN Y10   IOSTANDARD LVCMOS18}  [get_ports spi_en]                            ; #FMC_HPC0_LA15_P      IO_L6P_T0U_N10_AD6P_66

set_property  -dict {PACKAGE_PIN W2    IOSTANDARD LVCMOS18}  [get_ports tx1_enable]                        ; #FMC_HPC0_LA09_P      IO_L24P_T3U_N10_66
set_property  -dict {PACKAGE_PIN U9    IOSTANDARD LVCMOS18}  [get_ports tx2_enable]                        ; #FMC_HPC0_LA29_P      IO_L9P_T1L_N4_AD12P_67

set_property  -dict {PACKAGE_PIN V8    IOSTANDARD LVCMOS18}  [get_ports vadj_err]                          ; #FMC_HPC0_LA31_P      IO_L7P_T1L_N0_QBC_AD13P_67
set_property  -dict {PACKAGE_PIN V7    IOSTANDARD LVCMOS18}  [get_ports platform_status]                   ; #FMC_HPC0_LA31_N      IO_L7N_T1L_N1_QBC_AD13N_67

set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports tx1_strobe_out_p]
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports tx2_idata_out_p]

set_property  -dict {PACKAGE_PIN A20   IOSTANDARD LVCMOS33} [get_ports tdd_sync]   ;#PMOD0_0 J55.1

# Debug port (Proto header)
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports proto_hdr[0]]  ;# J3 24 L8P_HDGC_50_P
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports proto_hdr[1]]  ;# J3 22 L8N_HDGC_50_N
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports proto_hdr[2]]  ;# J3 20 L11P_AD9P_50_P
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports proto_hdr[3]]  ;# J3 18 L11N_AD9N_50_N
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports proto_hdr[4]]  ;# J3 16 L12P_AD8P_50_P
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports proto_hdr[5]]  ;# J3 14 L12N_AD8N_50_N
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports proto_hdr[6]]  ;# J3 12 L9P_AD11P_50_P
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports proto_hdr[7]]  ;# J3 10 L9N_AD11N_50_N
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports proto_hdr[8]]  ;# J3  8 L10P_AD10P_50_P
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports proto_hdr[9]]  ;# J3  6 L10N_AD10N_50_N

