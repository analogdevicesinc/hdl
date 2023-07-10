###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property  -dict {PACKAGE_PIN Y3    IOSTANDARD LVCMOS18  }  [get_ports rx1_dclk_in_n]    ;## FMC_HPC0_LA00_CC_N IO_L13N_T2L_N1_GC_QBC_66
set_property  -dict {PACKAGE_PIN Y4    IOSTANDARD LVCMOS18  }  [get_ports rx1_dclk_in_p]    ;## FMC_HPC0_LA00_CC_P IO_L13P_T2L_N0_GC_QBC_66
set_property  -dict {PACKAGE_PIN Y1    IOSTANDARD LVCMOS18  }  [get_ports rx1_idata_in_n]   ;## FMC_HPC0_LA03_N    IO_L22N_T3U_N7_DBC_AD0N_66
set_property  -dict {PACKAGE_PIN Y2    IOSTANDARD LVCMOS18  }  [get_ports rx1_idata_in_p]   ;## FMC_HPC0_LA03_P    IO_L22P_T3U_N6_DBC_AD0P_66
set_property  -dict {PACKAGE_PIN AA1   IOSTANDARD LVCMOS18  }  [get_ports rx1_qdata_in_n]   ;## FMC_HPC0_LA04_N    IO_L21N_T3L_N5_AD8N_66
set_property  -dict {PACKAGE_PIN AA2   IOSTANDARD LVCMOS18  }  [get_ports rx1_qdata_in_p]   ;## FMC_HPC0_LA04_P    IO_L21P_T3L_N4_AD8P_66
set_property  -dict {PACKAGE_PIN V1    IOSTANDARD LVCMOS18  }  [get_ports rx1_strobe_in_n]  ;## FMC_HPC0_LA02_N    IO_L23N_T3U_N9_66
set_property  -dict {PACKAGE_PIN V2    IOSTANDARD LVCMOS18  }  [get_ports rx1_strobe_in_p]  ;## FMC_HPC0_LA02_P    IO_L23P_T3U_N8_66

set_property  -dict {PACKAGE_PIN N11   IOSTANDARD LVCMOS18  }  [get_ports rx2_dclk_in_n]    ;## FMC_HPC0_LA17_CC_N IO_L13N_T2L_N1_GC_QBC_67
set_property  -dict {PACKAGE_PIN P11   IOSTANDARD LVCMOS18  }  [get_ports rx2_dclk_in_p]    ;## FMC_HPC0_LA17_CC_P IO_L13P_T2L_N0_GC_QBC_67
set_property  -dict {PACKAGE_PIN M13   IOSTANDARD LVCMOS18  }  [get_ports rx2_idata_in_n]   ;## FMC_HPC0_LA20_N    IO_L22N_T3U_N7_DBC_AD0N_67
set_property  -dict {PACKAGE_PIN N13   IOSTANDARD LVCMOS18  }  [get_ports rx2_idata_in_p]   ;## FMC_HPC0_LA20_P    IO_L22P_T3U_N6_DBC_AD0P_67
set_property  -dict {PACKAGE_PIN K13   IOSTANDARD LVCMOS18  }  [get_ports rx2_qdata_in_n]   ;## FMC_HPC0_LA19_N    IO_L23N_T3U_N9_67
set_property  -dict {PACKAGE_PIN L13   IOSTANDARD LVCMOS18  }  [get_ports rx2_qdata_in_p]   ;## FMC_HPC0_LA19_P    IO_L23P_T3U_N8_67
set_property  -dict {PACKAGE_PIN N12   IOSTANDARD LVCMOS18  }  [get_ports rx2_strobe_in_n]  ;## FMC_HPC0_LA21_N    IO_L21N_T3L_N5_AD8N_67
set_property  -dict {PACKAGE_PIN P12   IOSTANDARD LVCMOS18  }  [get_ports rx2_strobe_in_p]  ;## FMC_HPC0_LA21_P    IO_L21P_T3L_N4_AD8P_67

set_property  -dict {PACKAGE_PIN U4    IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_out_n]   ;## FMC_HPC0_LA07_N    IO_L18N_T2U_N11_AD2N_66
set_property  -dict {PACKAGE_PIN U5    IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_out_p]   ;## FMC_HPC0_LA07_P    IO_L18P_T2U_N10_AD2P_66
set_property  -dict {PACKAGE_PIN AC4   IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_in_n]    ;## FMC_HPC0_LA01_CC_N IO_L16N_T2U_N7_QBC_AD3N_66
set_property  -dict {PACKAGE_PIN AB4   IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_in_p]    ;## FMC_HPC0_LA01_CC_P IO_L16P_T2U_N6_QBC_AD3P_66
set_property  -dict {PACKAGE_PIN V3    IOSTANDARD LVCMOS18  }  [get_ports tx1_idata_out_n]  ;## FMC_HPC0_LA08_N    IO_L17N_T2U_N9_AD10N_66
set_property  -dict {PACKAGE_PIN V4    IOSTANDARD LVCMOS18  }  [get_ports tx1_idata_out_p]  ;## FMC_HPC0_LA08_P    IO_L17P_T2U_N8_AD10P_66
set_property  -dict {PACKAGE_PIN AC3   IOSTANDARD LVCMOS18  }  [get_ports tx1_qdata_out_n]  ;## FMC_HPC0_LA05_N    IO_L20N_T3L_N3_AD1N_66
set_property  -dict {PACKAGE_PIN AB3   IOSTANDARD LVCMOS18  }  [get_ports tx1_qdata_out_p]  ;## FMC_HPC0_LA05_P    IO_L20P_T3L_N2_AD1P_66
set_property  -dict {PACKAGE_PIN AC1   IOSTANDARD LVCMOS18  }  [get_ports tx1_strobe_out_n] ;## FMC_HPC0_LA06_N    IO_L19N_T3L_N1_DBC_AD9N_66
set_property  -dict {PACKAGE_PIN AC2   IOSTANDARD LVCMOS18  }  [get_ports tx1_strobe_out_p] ;## FMC_HPC0_LA06_P    IO_L19P_T3L_N0_DBC_AD9P_66

set_property  -dict {PACKAGE_PIN M14   IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_out_n]   ;## FMC_HPC0_LA22_N    IO_L20N_T3L_N3_AD1N_67
set_property  -dict {PACKAGE_PIN M15   IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_out_p]   ;## FMC_HPC0_LA22_P    IO_L20P_T3L_N2_AD1P_67
set_property  -dict {PACKAGE_PIN N8    IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_in_n]    ;## FMC_HPC0_LA18_CC_N IO_L16N_T2U_N7_QBC_AD3N_67
set_property  -dict {PACKAGE_PIN N9    IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_in_p]    ;## FMC_HPC0_LA18_CC_P IO_L16P_T2U_N6_QBC_AD3P_67
set_property  -dict {PACKAGE_PIN K16   IOSTANDARD LVCMOS18  }  [get_ports tx2_idata_out_n]  ;## FMC_HPC0_LA23_N    IO_L19N_T3L_N1_DBC_AD9N_67
set_property  -dict {PACKAGE_PIN L16   IOSTANDARD LVCMOS18  }  [get_ports tx2_idata_out_p]  ;## FMC_HPC0_LA23_P    IO_L19P_T3L_N0_DBC_AD9P_67
set_property  -dict {PACKAGE_PIN L11   IOSTANDARD LVCMOS18  }  [get_ports tx2_qdata_out_n]  ;## FMC_HPC0_LA25_N    IO_L17N_T2U_N9_AD10N_67
set_property  -dict {PACKAGE_PIN M11   IOSTANDARD LVCMOS18  }  [get_ports tx2_qdata_out_p]  ;## FMC_HPC0_LA25_P    IO_L17P_T2U_N8_AD10P_67
set_property  -dict {PACKAGE_PIN K12   IOSTANDARD LVCMOS18  }  [get_ports tx2_strobe_out_n] ;## FMC_HPC0_LA24_N    IO_L18N_T2U_N11_AD2N_67
set_property  -dict {PACKAGE_PIN L12   IOSTANDARD LVCMOS18  }  [get_ports tx2_strobe_out_p] ;## FMC_HPC0_LA24_P    IO_L18P_T2U_N10_AD2P_67

# clocks

create_clock -name ref_clk        -period  25.00 [get_ports fpga_ref_clk_p]

create_clock -name rx1_dclk_out   -period  12.5 [get_ports rx1_dclk_in_p]
create_clock -name rx2_dclk_out   -period  12.5 [get_ports rx2_dclk_in_p]
create_clock -name tx1_dclk_out   -period  12.5 [get_ports tx1_dclk_in_p]
create_clock -name tx2_dclk_out   -period  12.5 [get_ports tx2_dclk_in_p]

set_clock_latency -source -early -0.25 [get_clocks rx1_dclk_out]
set_clock_latency -source -early -0.25 [get_clocks rx2_dclk_out]

set_clock_latency -source -late 0.25 [get_clocks rx1_dclk_out]
set_clock_latency -source -late 0.25 [get_clocks rx2_dclk_out]

create_pblock SSI_REGION
add_cells_to_pblock [get_pblocks SSI_REGION] [get_cells -quiet [list \
    i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_1_phy/i_clk_buf_fast \
    i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_1_phy/i_div_clk_buf \
    i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_2_phy/i_clk_buf_fast \
    i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_2_phy/i_div_clk_buf \
    i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_1_phy/i_dac_clk_in_gbuf \
    i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_1_phy/i_dac_div_clk_rbuf \
    i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_2_phy/i_dac_clk_in_gbuf \
    i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_2_phy/i_dac_div_clk_rbuf \
    ]]
resize_pblock SSI_REGION -add CLOCKREGION_X3Y2:CLOCKREGION_X3Y3

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_1_phy/i_dac_clk_in_ibuf/O]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_2_phy/i_dac_clk_in_ibuf/O]
