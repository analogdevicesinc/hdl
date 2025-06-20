###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property  -dict {PACKAGE_PIN AD41  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx1_dclk_in_n]      ; ## G07 FMC2_HPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN AD40  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx1_dclk_in_p]      ; ## G06 FMC2_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN AK42  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx1_idata_in_n]     ; ## G10 FMC2_HPC_LA03_N
set_property  -dict {PACKAGE_PIN AJ42  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx1_idata_in_p]     ; ## G09 FMC2_HPC_LA03_P
set_property  -dict {PACKAGE_PIN AL42  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx1_qdata_in_n]     ; ## H11 FMC2_HPC_LA04_N
set_property  -dict {PACKAGE_PIN AL41  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx1_qdata_in_p]     ; ## H10 FMC2_HPC_LA04_P
set_property  -dict {PACKAGE_PIN AL39  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx1_strobe_in_n]    ; ## H08 FMC2_HPC_LA02_N
set_property  -dict {PACKAGE_PIN AK39  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx1_strobe_in_p]    ; ## H07 FMC2_HPC_LA02_P

set_property  -dict {PACKAGE_PIN U38  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx2_dclk_in_n]      ; ## D21 FMC2_HPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN U37  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx2_dclk_in_p]      ; ## D20 FMC2_HPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN V34  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx2_idata_in_n]     ; ## G22 FMC2_HPC_LA20_N
set_property  -dict {PACKAGE_PIN V33  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx2_idata_in_p]     ; ## G21 FMC2_HPC_LA20_P
set_property  -dict {PACKAGE_PIN U33  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx2_qdata_in_n]     ; ## H23 FMC2_HPC_LA19_N
set_property  -dict {PACKAGE_PIN U32  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx2_qdata_in_p]     ; ## H22 FMC2_HPC_LA19_P
set_property  -dict {PACKAGE_PIN P36  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx2_strobe_in_n]    ; ## H26 FMC2_HPC_LA21_N
set_property  -dict {PACKAGE_PIN P35  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports rx2_strobe_in_p]    ; ## H25 FMC2_HPC_LA21_P

set_property  -dict {PACKAGE_PIN AG41  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports tx1_dclk_in_n]      ; ## D09 FMC2_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN AF41  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports tx1_dclk_in_p]      ; ## D08 FMC2_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN AC41  IOSTANDARD LVDS}                 [get_ports tx1_dclk_out_n]     ; ## H14 FMC2_HPC_LA07_N
set_property  -dict {PACKAGE_PIN AC40  IOSTANDARD LVDS}                 [get_ports tx1_dclk_out_p]     ; ## H13 FMC2_HPC_LA07_P
set_property  -dict {PACKAGE_PIN AE42  IOSTANDARD LVDS}                 [get_ports tx1_idata_out_n]    ; ## G13 FMC2_HPC_LA08_N
set_property  -dict {PACKAGE_PIN AD42  IOSTANDARD LVDS}                 [get_ports tx1_idata_out_p]    ; ## G12 FMC2_HPC_LA08_P
set_property  -dict {PACKAGE_PIN AG42  IOSTANDARD LVDS}                 [get_ports tx1_qdata_out_n]    ; ## D12 FMC2_HPC_LA05_N
set_property  -dict {PACKAGE_PIN AF42  IOSTANDARD LVDS}                 [get_ports tx1_qdata_out_p]    ; ## D11 FMC2_HPC_LA05_P
set_property  -dict {PACKAGE_PIN AE38  IOSTANDARD LVDS}                 [get_ports tx1_strobe_out_n]   ; ## C11 FMC2_HPC_LA06_N
set_property  -dict {PACKAGE_PIN AD38  IOSTANDARD LVDS}                 [get_ports tx1_strobe_out_p]   ; ## C10 FMC2_HPC_LA06_P

set_property  -dict {PACKAGE_PIN T37  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports tx2_dclk_in_n]      ; ## C23 FMC2_HPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN U36  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports tx2_dclk_in_p]      ; ## C22 FMC2_HPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN W33  IOSTANDARD LVDS}                 [get_ports tx2_dclk_out_n]     ; ## G25 FMC2_HPC_LA22_N
set_property  -dict {PACKAGE_PIN W32  IOSTANDARD LVDS}                 [get_ports tx2_dclk_out_p]     ; ## G24 FMC2_HPC_LA22_P
set_property  -dict {PACKAGE_PIN R39  IOSTANDARD LVDS}                 [get_ports tx2_idata_out_n]    ; ## D24 FMC2_HPC_LA23_N
set_property  -dict {PACKAGE_PIN R38  IOSTANDARD LVDS}                 [get_ports tx2_idata_out_p]    ; ## D23 FMC2_HPC_LA23_P
set_property  -dict {PACKAGE_PIN R34  IOSTANDARD LVDS}                 [get_ports tx2_qdata_out_n]    ; ## G28 FMC2_HPC_LA25_N
set_property  -dict {PACKAGE_PIN R33  IOSTANDARD LVDS}                 [get_ports tx2_qdata_out_p]    ; ## G27 FMC2_HPC_LA25_P
set_property  -dict {PACKAGE_PIN T35  IOSTANDARD LVDS}                 [get_ports tx2_strobe_out_n]   ; ## H29 FMC2_HPC_LA24_N
set_property  -dict {PACKAGE_PIN U34  IOSTANDARD LVDS}                 [get_ports tx2_strobe_out_p]   ; ## H28 FMC2_HPC_LA24_P

set_property  -dict {PACKAGE_PIN AB38  IOSTANDARD LVDS}                 [get_ports dev_mcs_fpga_out_p] ; ## C18  FMC2_HPC_LA14_P
set_property  -dict {PACKAGE_PIN AB39  IOSTANDARD LVDS}                 [get_ports dev_mcs_fpga_out_n] ; ## C19  FMC2_HPC_LA14_N

set_property  -dict {PACKAGE_PIN P37  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports fpga_mcs_in_p]      ; ## H37  FMC2_HPC_LA32_P
set_property  -dict {PACKAGE_PIN P38  IOSTANDARD LVDS DIFF_TERM TRUE}  [get_ports fpga_mcs_in_n]      ; ## H38  FMC2_HPC_LA32_N
set_property  -dict {PACKAGE_PIN U39  IOSTANDARD LVDS}                 [get_ports fpga_ref_clk_p]     ; ## G02  FMC2_HPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN T39  IOSTANDARD LVDS}                 [get_ports fpga_ref_clk_n]     ; ## G03  FMC2_HPC_CLK1_M2C_N

# clocks

create_clock -name rx1_dclk_out   -period  12.5 [get_ports rx1_dclk_in_p]
create_clock -name rx2_dclk_out   -period  12.5 [get_ports rx2_dclk_in_p]
create_clock -name tx1_dclk_out   -period  12.5 [get_ports tx1_dclk_in_p]
create_clock -name tx2_dclk_out   -period  12.5 [get_ports tx2_dclk_in_p]

