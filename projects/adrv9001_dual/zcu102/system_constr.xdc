###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# fmc hpc 0

#set_property  -dict {PACKAGE_PIN AA7   IOSTANDARD LVCMOS18}  [get_ports adrv1_dev_clk_in]                        ; #FMC_HPC0_CLK0_M2C_P  IO_L12P_T1U_N10_GC_66
set_property  -dict {PACKAGE_PIN AC6   IOSTANDARD LVDS}      [get_ports adrv1_dev_mcs_fpga_out_n]                ; #FMC_HPC0_LA14_N      IO_L7N_T1L_N1_QBC_AD13N_66
set_property  -dict {PACKAGE_PIN AC7   IOSTANDARD LVDS}      [get_ports adrv1_dev_mcs_fpga_out_p]                ; #FMC_HPC0_LA14_P      IO_L7P_T1L_N0_QBC_AD13P_66

set_property  -dict {PACKAGE_PIN Y12   IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_0]                           ; #FMC_HPC0_LA16_P      IO_L5P_T0U_N8_AD14P_66
set_property  -dict {PACKAGE_PIN AA12  IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_1]                           ; #FMC_HPC0_LA16_N      IO_L5N_T0U_N9_AD14N_66
set_property  -dict {PACKAGE_PIN Y9    IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_2]                           ; #FMC_HPC0_LA15_N      IO_L6N_T0U_N11_AD6N_66
set_property  -dict {PACKAGE_PIN AB5   IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_3]                           ; #FMC_HPC0_LA11_N      IO_L10N_T1U_N7_QBC_AD4N_66
set_property  -dict {PACKAGE_PIN W1    IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_4]                           ; #FMC_HPC0_LA09_N      IO_L24N_T3U_N11_66
set_property  -dict {PACKAGE_PIN W4    IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_5]                           ; #FMC_HPC0_LA10_N      IO_L15N_T2L_N5_AD11N_66
set_property  -dict {PACKAGE_PIN M10   IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_6]                           ; #FMC_HPC0_LA27_P      IO_L15P_T2L_N4_AD11P_67
set_property  -dict {PACKAGE_PIN L15   IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_7]                           ; #FMC_HPC0_LA26_P      IO_L24P_T3U_N10_67
set_property  -dict {PACKAGE_PIN T7    IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_8]                           ; #FMC_HPC0_LA28_P      IO_L10P_T1U_N6_QBC_AD4P_67
set_property  -dict {PACKAGE_PIN T6    IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_9]                           ; #FMC_HPC0_LA28_N      IO_L10N_T1U_N7_QBC_AD4N_67
set_property  -dict {PACKAGE_PIN AB6   IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_10]                          ; #FMC_HPC0_LA11_P      IO_L10P_T1U_N6_QBC_AD4P_66
set_property  -dict {PACKAGE_PIN L10   IOSTANDARD LVCMOS18}  [get_ports adrv1_dgpio_11]                          ; #FMC_HPC0_LA27_N      IO_L15N_T2L_N5_AD11N_67

set_property  -dict {PACKAGE_PIN T11   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports adrv1_fpga_mcs_in_n]  ; #FMC_HPC0_LA32_N      IO_L6N_T0U_N11_AD6N_67
set_property  -dict {PACKAGE_PIN U11   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports adrv1_fpga_mcs_in_p]  ; #FMC_HPC0_LA32_P      IO_L6P_T0U_N10_AD6P_67
set_property  -dict {PACKAGE_PIN R8    IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports adrv1_fpga_ref_clk_n] ; #FMC_HPC0_CLK1_M2C_N  IO_L12N_T1U_N11_GC_67
set_property  -dict {PACKAGE_PIN T8    IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports adrv1_fpga_ref_clk_p] ; #FMC_HPC0_CLK1_M2C_P  IO_L12P_T1U_N10_GC_67

set_property  -dict {PACKAGE_PIN V6    IOSTANDARD LVCMOS18}  [get_ports adrv1_gp_int]                            ; #FMC_HPC0_LA30_P      IO_L8P_T1L_N2_AD5P_67
set_property  -dict {PACKAGE_PIN AB8   IOSTANDARD LVCMOS18}  [get_ports adrv1_mode]                              ; #FMC_HPC0_LA13_P      IO_L8P_T1L_N2_AD5P_66
set_property  -dict {PACKAGE_PIN AC8   IOSTANDARD LVCMOS18}  [get_ports adrv1_reset_trx]                         ; #FMC_HPC0_LA13_N      IO_L8N_T1L_N3_AD5N_66

set_property  -dict {PACKAGE_PIN W5    IOSTANDARD LVCMOS18}  [get_ports adrv1_rx1_en]                            ; #FMC_HPC0_LA10_P      IO_L15P_T2L_N4_AD11P_66
set_property  -dict {PACKAGE_PIN K15   IOSTANDARD LVCMOS18}  [get_ports adrv1_rx2_en]                            ; #FMC_HPC0_LA26_N      IO_L24N_T3U_N11_67

set_property  -dict {PACKAGE_PIN AA6   IOSTANDARD LVCMOS18}  [get_ports adrv1_sm_fan_tach]                       ; #FMC_HPC0_CLK0_M2C_N  IO_L12N_T1U_N11_GC_66

set_property  -dict {PACKAGE_PIN W7    IOSTANDARD LVCMOS18}  [get_ports adrv1_spi_clk]                           ; #FMC_HPC0_LA12_P      IO_L9P_T1L_N4_AD12P_66
set_property  -dict {PACKAGE_PIN U8    IOSTANDARD LVCMOS18}  [get_ports adrv1_spi_dio]                           ; #FMC_HPC0_LA29_N      IO_L9N_T1L_N5_AD12N_67
set_property  -dict {PACKAGE_PIN W6    IOSTANDARD LVCMOS18}  [get_ports adrv1_spi_do]                            ; #FMC_HPC0_LA12_N      IO_L9N_T1L_N5_AD12N_66
set_property  -dict {PACKAGE_PIN Y10   IOSTANDARD LVCMOS18}  [get_ports adrv1_spi_en]                            ; #FMC_HPC0_LA15_P      IO_L6P_T0U_N10_AD6P_66

set_property  -dict {PACKAGE_PIN W2    IOSTANDARD LVCMOS18}  [get_ports adrv1_tx1_en]                            ; #FMC_HPC0_LA09_P      IO_L24P_T3U_N10_66
set_property  -dict {PACKAGE_PIN U9    IOSTANDARD LVCMOS18}  [get_ports adrv1_tx2_en]                            ; #FMC_HPC0_LA29_P      IO_L9P_T1L_N4_AD12P_67

set_property  -dict {PACKAGE_PIN V8    IOSTANDARD LVCMOS18}  [get_ports adrv1_vadj_err]                          ; #FMC_HPC0_LA31_P      IO_L7P_T1L_N0_QBC_AD13P_67
set_property  -dict {PACKAGE_PIN V7    IOSTANDARD LVCMOS18}  [get_ports adrv1_platform_status]                   ; #FMC_HPC0_LA31_N      IO_L7N_T1L_N1_QBC_AD13N_67

# fmc hpc 1

#set_property  -dict {PACKAGE_PIN AE7   IOSTANDARD LVCMOS18}  [get_ports adrv2_dev_clk_in]                        ; #FMC_HPC1_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN AH6   IOSTANDARD LVDS}      [get_ports adrv2_dev_mcs_fpga_out_n]                ; #FMC_HPC1_LA14_N
set_property  -dict {PACKAGE_PIN AH7   IOSTANDARD LVDS}      [get_ports adrv2_dev_mcs_fpga_out_p]                ; #FMC_HPC1_LA14_P

set_property  -dict {PACKAGE_PIN AG10  IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_0]                           ; #FMC_HPC1_LA16_P
set_property  -dict {PACKAGE_PIN AG9   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_1]                           ; #FMC_HPC1_LA16_N
set_property  -dict {PACKAGE_PIN AE9   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_2]                           ; #FMC_HPC1_LA15_N
set_property  -dict {PACKAGE_PIN AF8   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_3]                           ; #FMC_HPC1_LA11_N
set_property  -dict {PACKAGE_PIN AE1   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_4]                           ; #FMC_HPC1_LA09_N
set_property  -dict {PACKAGE_PIN AJ4   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_5]                           ; #FMC_HPC1_LA10_N
set_property  -dict {PACKAGE_PIN U10   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_6]                           ; #FMC_HPC1_LA27_P
set_property  -dict {PACKAGE_PIN T12   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_7]                           ; #FMC_HPC1_LA26_P
set_property  -dict {PACKAGE_PIN T13   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_8]                           ; #FMC_HPC1_LA28_P
set_property  -dict {PACKAGE_PIN R13   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_9]                           ; #FMC_HPC1_LA28_N
set_property  -dict {PACKAGE_PIN AE8   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_10]                          ; #FMC_HPC1_LA11_P
set_property  -dict {PACKAGE_PIN T10   IOSTANDARD LVCMOS18}  [get_ports adrv2_dgpio_11]                          ; #FMC_HPC1_LA27_N

# set_property  -dict {PACKAGE_PIN xx  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports adrv1_fpga_mcs_in_n]  ; #FMC_HPC1_LA32_N
# set_property  -dict {PACKAGE_PIN xx  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports adrv1_fpga_mcs_in_p]  ; #FMC_HPC1_LA32_P

set_property  -dict {PACKAGE_PIN P9    IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports adrv2_fpga_ref_clk_n] ; #FMC_HPC1_CLK1_M2C_N
set_property  -dict {PACKAGE_PIN P10   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports adrv2_fpga_ref_clk_p] ; #FMC_HPC1_CLK1_M2C_P

#set_property  -dict {PACKAGE_PIN xx   IOSTANDARD LVCMOS18}  [get_ports adrv2_gp_int]                            ; #FMC_HPC1_LA30_P
set_property  -dict {PACKAGE_PIN AG8   IOSTANDARD LVCMOS18}  [get_ports adrv2_mode]                              ; #FMC_HPC1_LA13_P
set_property  -dict {PACKAGE_PIN AH8   IOSTANDARD LVCMOS18}  [get_ports adrv2_reset_trx]                         ; #FMC_HPC1_LA13_N

set_property  -dict {PACKAGE_PIN AH4   IOSTANDARD LVCMOS18}  [get_ports adrv2_rx1_en]                            ; #FMC_HPC1_LA10_P
set_property  -dict {PACKAGE_PIN R12   IOSTANDARD LVCMOS18}  [get_ports adrv2_rx2_en]                            ; #FMC_HPC1_LA26_N

set_property  -dict {PACKAGE_PIN AF7   IOSTANDARD LVCMOS18}  [get_ports adrv2_sm_fan_tach]                       ; #FMC_HPC1_CLK0_M2C_N

set_property  -dict {PACKAGE_PIN AD7   IOSTANDARD LVCMOS18}  [get_ports adrv2_spi_clk]                           ; #FMC_HPC1_LA12_P
set_property  -dict {PACKAGE_PIN W11   IOSTANDARD LVCMOS18}  [get_ports adrv2_spi_dio]                           ; #FMC_HPC1_LA29_N
set_property  -dict {PACKAGE_PIN AD6   IOSTANDARD LVCMOS18}  [get_ports adrv2_spi_do]                            ; #FMC_HPC1_LA12_N
set_property  -dict {PACKAGE_PIN AD10  IOSTANDARD LVCMOS18}  [get_ports adrv2_spi_en]                            ; #FMC_HPC1_LA15_P

set_property  -dict {PACKAGE_PIN AE2   IOSTANDARD LVCMOS18}  [get_ports adrv2_tx1_en]                            ; #FMC_HPC1_LA09_P
set_property  -dict {PACKAGE_PIN W12   IOSTANDARD LVCMOS18}  [get_ports adrv2_tx2_en]                            ; #FMC_HPC1_LA29_P

#set_property  -dict {PACKAGE_PIN V8   IOSTANDARD LVCMOS18}  [get_ports adrv2_vadj_err]                          ; #FMC_HPC1_LA31_P
#set_property  -dict {PACKAGE_PIN V7   IOSTANDARD LVCMOS18}  [get_ports adrv2_platform_status]                   ; #FMC_HPC1_LA31_N

set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports adrv2_tx1_strobe_in_p]
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports adrv2_tx2_idata_in_p]
