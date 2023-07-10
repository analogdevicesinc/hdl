###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property  -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS18  }  [get_ports rx1_dclk_in_n]    ;## G07 FMC_HPC0_LA00_CC_N IO_L13N_T2_MRCC_34
set_property  -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS18  }  [get_ports rx1_dclk_in_p]    ;## G06 FMC_HPC0_LA00_CC_P IO_L13P_T2_MRCC_34
set_property  -dict {PACKAGE_PIN P22  IOSTANDARD LVCMOS18  }  [get_ports rx1_idata_in_n]   ;## G10 FMC_HPC0_LA03_N    IO_L16N_T2_34
set_property  -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS18  }  [get_ports rx1_idata_in_p]   ;## G09 FMC_HPC0_LA03_P    IO_L16P_T2_34
set_property  -dict {PACKAGE_PIN M22  IOSTANDARD LVCMOS18  }  [get_ports rx1_qdata_in_n]   ;## H11 FMC_HPC0_LA04_N    IO_L15N_T2_DQS_34
set_property  -dict {PACKAGE_PIN M21  IOSTANDARD LVCMOS18  }  [get_ports rx1_qdata_in_p]   ;## H10 FMC_HPC0_LA04_P    IO_L15P_T2_DQS_34
set_property  -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS18  }  [get_ports rx1_strobe_in_n]  ;## H08 FMC_HPC0_LA02_N    IO_L20N_T3_34
set_property  -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS18  }  [get_ports rx1_strobe_in_p]  ;## H07 FMC_HPC0_LA02_P    IO_L20P_T3_34

set_property  -dict {PACKAGE_PIN B20  IOSTANDARD LVCMOS18  }  [get_ports rx2_dclk_in_n]    ;## D21 FMC_HPC0_LA17_CC_N IO_L13N_T2_MRCC_35
set_property  -dict {PACKAGE_PIN B19  IOSTANDARD LVCMOS18  }  [get_ports rx2_dclk_in_p]    ;## D20 FMC_HPC0_LA17_CC_P IO_L13P_T2_MRCC_35
set_property  -dict {PACKAGE_PIN G21  IOSTANDARD LVCMOS18  }  [get_ports rx2_idata_in_n]   ;## G22 FMC_HPC0_LA20_N    IO_L22N_T3_AD7N_35
set_property  -dict {PACKAGE_PIN G20  IOSTANDARD LVCMOS18  }  [get_ports rx2_idata_in_p]   ;## G21 FMC_HPC0_LA20_P    IO_L22P_T3_AD7P_35
set_property  -dict {PACKAGE_PIN G16  IOSTANDARD LVCMOS18  }  [get_ports rx2_qdata_in_n]   ;## H23 FMC_HPC0_LA19_N    IO_L4N_T0_35
set_property  -dict {PACKAGE_PIN G15  IOSTANDARD LVCMOS18  }  [get_ports rx2_qdata_in_p]   ;## H22 FMC_HPC0_LA19_P    IO_L4P_T0_35
set_property  -dict {PACKAGE_PIN E20  IOSTANDARD LVCMOS18  }  [get_ports rx2_strobe_in_n]  ;## H26 FMC_HPC0_LA21_N    IO_L21N_T3_DQS_AD14N_35
set_property  -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS18  }  [get_ports rx2_strobe_in_p]  ;## H25 FMC_HPC0_LA21_P    IO_L21P_T3_DQS_AD14P_35


set_property  -dict {PACKAGE_PIN T17  IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_out_n]   ;## H14 FMC_HPC0_LA07_N    IO_L21N_T3_DQS_34
set_property  -dict {PACKAGE_PIN T16  IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_out_p]   ;## H13 FMC_HPC0_LA07_P    IO_L21P_T3_DQS_34
set_property  -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_in_n]    ;## D09 FMC_HPC0_LA01_CC_N IO_L14N_T2_SRCC_34
set_property  -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_in_p]    ;## D08 FMC_HPC0_LA01_CC_P IO_L14P_T2_SRCC_34
set_property  -dict {PACKAGE_PIN J22  IOSTANDARD LVCMOS18  }  [get_ports tx1_idata_out_n]  ;## G13 FMC_HPC0_LA08_N    IO_L8N_T1_34
set_property  -dict {PACKAGE_PIN J21  IOSTANDARD LVCMOS18  }  [get_ports tx1_idata_out_p]  ;## G12 FMC_HPC0_LA08_P    IO_L8P_T1_34
set_property  -dict {PACKAGE_PIN K18  IOSTANDARD LVCMOS18  }  [get_ports tx1_qdata_out_n]  ;## D12 FMC_HPC0_LA05_N    IO_L7N_T1_34
set_property  -dict {PACKAGE_PIN J18  IOSTANDARD LVCMOS18  }  [get_ports tx1_qdata_out_p]  ;## D11 FMC_HPC0_LA05_P    IO_L7P_T1_34
set_property  -dict {PACKAGE_PIN L22  IOSTANDARD LVCMOS18  }  [get_ports tx1_strobe_out_n] ;## C11 FMC_HPC0_LA06_N    IO_L10N_T1_34
set_property  -dict {PACKAGE_PIN L21  IOSTANDARD LVCMOS18  }  [get_ports tx1_strobe_out_p] ;## C10 FMC_HPC0_LA06_P    IO_L10P_T1_34

set_property  -dict {PACKAGE_PIN F19  IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_out_n]   ;## G25 FMC_HPC0_LA22_N    IO_L20N_T3_AD6N_35
set_property  -dict {PACKAGE_PIN G19  IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_out_p]   ;## G24 FMC_HPC0_LA22_P    IO_L20P_T3_AD6P_35
set_property  -dict {PACKAGE_PIN C20  IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_in_n]    ;## C23 FMC_HPC0_LA18_CC_N IO_L14N_T2_AD4N_SRCC_35
set_property  -dict {PACKAGE_PIN D20  IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_in_p]    ;## C22 FMC_HPC0_LA18_CC_P IO_L14P_T2_AD4P_SRCC_35
set_property  -dict {PACKAGE_PIN D15  IOSTANDARD LVCMOS18  }  [get_ports tx2_idata_out_n]  ;## D24 FMC_HPC0_LA23_N    IO_L3N_T0_DQS_AD1N_35
set_property  -dict {PACKAGE_PIN E15  IOSTANDARD LVCMOS18  }  [get_ports tx2_idata_out_p]  ;## D23 FMC_HPC0_LA23_P    IO_L3P_T0_DQS_AD1P_35
set_property  -dict {PACKAGE_PIN C22  IOSTANDARD LVCMOS18  }  [get_ports tx2_qdata_out_n]  ;## G28 FMC_HPC0_LA25_N    IO_L16N_T2_35
set_property  -dict {PACKAGE_PIN D22  IOSTANDARD LVCMOS18  }  [get_ports tx2_qdata_out_p]  ;## G27 FMC_HPC0_LA25_P    IO_L16P_T2_35
set_property  -dict {PACKAGE_PIN A19  IOSTANDARD LVCMOS18  }  [get_ports tx2_strobe_out_n] ;## H29 FMC_HPC0_LA24_N    IO_L10N_T1_AD11N_35
set_property  -dict {PACKAGE_PIN A18  IOSTANDARD LVCMOS18  }  [get_ports tx2_strobe_out_p] ;## H28 FMC_HPC0_LA24_P    IO_L10P_T1_AD11P_35


# clocks

#create_clock -name ref_clk        -period  25.00 [get_ports fpga_ref_clk_p]

create_clock -name rx1_dclk_out   -period  12.5 [get_ports rx1_dclk_in_p]
create_clock -name rx2_dclk_out   -period  12.5 [get_ports rx2_dclk_in_p]
create_clock -name tx1_dclk_out   -period  12.5 [get_ports tx1_dclk_in_p]
create_clock -name tx2_dclk_out   -period  12.5 [get_ports tx2_dclk_in_p]

set_clock_latency -source -early 2 [get_clocks rx1_dclk_out]
set_clock_latency -source -early 2 [get_clocks rx2_dclk_out]

set_clock_latency -source -late 5 [get_clocks rx1_dclk_out]
set_clock_latency -source -late 5 [get_clocks rx2_dclk_out]
