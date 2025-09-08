###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# fmc hpc 0

set_property  -dict {PACKAGE_PIN Y3     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx1_dclk_out_n]     ;## FMC_HPC0_LA00_CC_N
set_property  -dict {PACKAGE_PIN Y4     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx1_dclk_out_p]     ;## FMC_HPC0_LA00_CC_P
set_property  -dict {PACKAGE_PIN Y1     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx1_idata_out_n]    ;## FMC_HPC0_LA03_N
set_property  -dict {PACKAGE_PIN Y2     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx1_idata_out_p]    ;## FMC_HPC0_LA03_P
set_property  -dict {PACKAGE_PIN AA1    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx1_qdata_out_n]    ;## FMC_HPC0_LA04_N
set_property  -dict {PACKAGE_PIN AA2    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx1_qdata_out_p]    ;## FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN V1     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx1_strobe_out_n]   ;## FMC_HPC0_LA02_N
set_property  -dict {PACKAGE_PIN V2     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx1_strobe_out_p]   ;## FMC_HPC0_LA02_P

set_property  -dict {PACKAGE_PIN N11    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx2_dclk_out_n]     ;## FMC_HPC0_LA17_CC_N
set_property  -dict {PACKAGE_PIN P11    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx2_dclk_out_p]     ;## FMC_HPC0_LA17_CC_P
set_property  -dict {PACKAGE_PIN M13    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx2_idata_out_n]    ;## FMC_HPC0_LA20_N
set_property  -dict {PACKAGE_PIN N13    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx2_idata_out_p]    ;## FMC_HPC0_LA20_P
set_property  -dict {PACKAGE_PIN K13    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx2_qdata_out_n]    ;## FMC_HPC0_LA19_N
set_property  -dict {PACKAGE_PIN L13    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx2_qdata_out_p]    ;## FMC_HPC0_LA19_P
set_property  -dict {PACKAGE_PIN N12    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx2_strobe_out_n]   ;## FMC_HPC0_LA21_N
set_property  -dict {PACKAGE_PIN P12    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_rx2_strobe_out_p]   ;## FMC_HPC0_LA21_P

set_property  -dict {PACKAGE_PIN U4     IOSTANDARD LVDS}                          [get_ports adrv1_tx1_dclk_in_n]      ;## FMC_HPC0_LA07_N
set_property  -dict {PACKAGE_PIN U5     IOSTANDARD LVDS}                          [get_ports adrv1_tx1_dclk_in_p]      ;## FMC_HPC0_LA07_P
set_property  -dict {PACKAGE_PIN AC4    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_tx1_dclk_out_n]     ;## FMC_HPC0_LA01_CC_N
set_property  -dict {PACKAGE_PIN AB4    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_tx1_dclk_out_p]     ;## FMC_HPC0_LA01_CC_P
set_property  -dict {PACKAGE_PIN V3     IOSTANDARD LVDS}                          [get_ports adrv1_tx1_idata_in_n]     ;## FMC_HPC0_LA08_N
set_property  -dict {PACKAGE_PIN V4     IOSTANDARD LVDS}                          [get_ports adrv1_tx1_idata_in_p]     ;## FMC_HPC0_LA08_P
set_property  -dict {PACKAGE_PIN AC3    IOSTANDARD LVDS}                          [get_ports adrv1_tx1_qdata_in_n]     ;## FMC_HPC0_LA05_N
set_property  -dict {PACKAGE_PIN AB3    IOSTANDARD LVDS}                          [get_ports adrv1_tx1_qdata_in_p]     ;## FMC_HPC0_LA05_P
set_property  -dict {PACKAGE_PIN AC1    IOSTANDARD LVDS}                          [get_ports adrv1_tx1_strobe_in_n]    ;## FMC_HPC0_LA06_N
set_property  -dict {PACKAGE_PIN AC2    IOSTANDARD LVDS}                          [get_ports adrv1_tx1_strobe_in_p]    ;## FMC_HPC0_LA06_P

set_property  -dict {PACKAGE_PIN M14    IOSTANDARD LVDS}                          [get_ports adrv1_tx2_dclk_in_n]      ;## FMC_HPC0_LA22_N
set_property  -dict {PACKAGE_PIN M15    IOSTANDARD LVDS}                          [get_ports adrv1_tx2_dclk_in_p]      ;## FMC_HPC0_LA22_P
set_property  -dict {PACKAGE_PIN N8     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_tx2_dclk_out_n]     ;## FMC_HPC0_LA18_CC_N
set_property  -dict {PACKAGE_PIN N9     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv1_tx2_dclk_out_p]     ;## FMC_HPC0_LA18_CC_P
set_property  -dict {PACKAGE_PIN K16    IOSTANDARD LVDS}                          [get_ports adrv1_tx2_idata_in_n]     ;## FMC_HPC0_LA23_N
set_property  -dict {PACKAGE_PIN L16    IOSTANDARD LVDS}                          [get_ports adrv1_tx2_idata_in_p]     ;## FMC_HPC0_LA23_P
set_property  -dict {PACKAGE_PIN L11    IOSTANDARD LVDS}                          [get_ports adrv1_tx2_qdata_in_n]     ;## FMC_HPC0_LA25_N
set_property  -dict {PACKAGE_PIN M11    IOSTANDARD LVDS}                          [get_ports adrv1_tx2_qdata_in_p]     ;## FMC_HPC0_LA25_P
set_property  -dict {PACKAGE_PIN K12    IOSTANDARD LVDS}                          [get_ports adrv1_tx2_strobe_in_n]    ;## FMC_HPC0_LA24_N
set_property  -dict {PACKAGE_PIN L12    IOSTANDARD LVDS}                          [get_ports adrv1_tx2_strobe_in_p]    ;## FMC_HPC0_LA24_P

# fmc hpc 1

set_property  -dict {PACKAGE_PIN AF5     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx1_dclk_out_n]     ;## FMC_HPC1_LA00_CC_N
set_property  -dict {PACKAGE_PIN AE5     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx1_dclk_out_p]     ;## FMC_HPC1_LA00_CC_P
set_property  -dict {PACKAGE_PIN AJ1     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx1_idata_out_n]    ;## FMC_HPC1_LA03_N
set_property  -dict {PACKAGE_PIN AH1     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx1_idata_out_p]    ;## FMC_HPC1_LA03_P
set_property  -dict {PACKAGE_PIN AF1     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx1_qdata_out_n]    ;## FMC_HPC1_LA04_N
set_property  -dict {PACKAGE_PIN AF2     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx1_qdata_out_p]    ;## FMC_HPC1_LA04_P
set_property  -dict {PACKAGE_PIN AD1     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx1_strobe_out_n]   ;## FMC_HPC1_LA02_N
set_property  -dict {PACKAGE_PIN AD2     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx1_strobe_out_p]   ;## FMC_HPC1_LA02_P

set_property  -dict {PACKAGE_PIN AA5     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx2_dclk_out_n]     ;## FMC_HPC1_LA17_CC_N
set_property  -dict {PACKAGE_PIN Y5      IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx2_dclk_out_p]     ;## FMC_HPC1_LA17_CC_P
set_property  -dict {PACKAGE_PIN AB10    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx2_idata_out_n]    ;## FMC_HPC1_LA20_N
set_property  -dict {PACKAGE_PIN AB11    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx2_idata_out_p]    ;## FMC_HPC1_LA20_P
set_property  -dict {PACKAGE_PIN AA10    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx2_qdata_out_n]    ;## FMC_HPC1_LA19_N
set_property  -dict {PACKAGE_PIN AA11    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx2_qdata_out_p]    ;## FMC_HPC1_LA19_P
set_property  -dict {PACKAGE_PIN AC11    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx2_strobe_out_n]   ;## FMC_HPC1_LA21_N
set_property  -dict {PACKAGE_PIN AC12    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_rx2_strobe_out_p]   ;## FMC_HPC1_LA21_P

set_property  -dict {PACKAGE_PIN AE4    IOSTANDARD LVDS}                          [get_ports adrv2_tx1_dclk_in_n]       ;## FMC_HPC1_LA07_N
set_property  -dict {PACKAGE_PIN AD4    IOSTANDARD LVDS}                          [get_ports adrv2_tx1_dclk_in_p]       ;## FMC_HPC1_LA07_P
set_property  -dict {PACKAGE_PIN AJ5    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_tx1_dclk_out_n]      ;## FMC_HPC1_LA01_CC_N
set_property  -dict {PACKAGE_PIN AJ6    IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_tx1_dclk_out_p]      ;## FMC_HPC1_LA01_CC_P
set_property  -dict {PACKAGE_PIN AF3    IOSTANDARD LVDS}                          [get_ports adrv2_tx1_idata_in_n]      ;## FMC_HPC1_LA08_N
set_property  -dict {PACKAGE_PIN AE3    IOSTANDARD LVDS}                          [get_ports adrv2_tx1_idata_in_p]      ;## FMC_HPC1_LA08_P
set_property  -dict {PACKAGE_PIN AH3    IOSTANDARD LVDS}                          [get_ports adrv2_tx1_qdata_in_n]      ;## FMC_HPC1_LA05_N
set_property  -dict {PACKAGE_PIN AG3    IOSTANDARD LVDS}                          [get_ports adrv2_tx1_qdata_in_p]      ;## FMC_HPC1_LA05_P
set_property  -dict {PACKAGE_PIN AJ2    IOSTANDARD LVDS}                          [get_ports adrv2_tx1_strobe_in_n]     ;## FMC_HPC1_LA06_N
set_property  -dict {PACKAGE_PIN AH2    IOSTANDARD LVDS}                          [get_ports adrv2_tx1_strobe_in_p]     ;## FMC_HPC1_LA06_P

set_property  -dict {PACKAGE_PIN AG11   IOSTANDARD LVDS}                          [get_ports adrv2_tx2_dclk_in_n]       ;## FMC_HPC1_LA22_N
set_property  -dict {PACKAGE_PIN AF11   IOSTANDARD LVDS}                          [get_ports adrv2_tx2_dclk_in_p]       ;## FMC_HPC1_LA22_P
set_property  -dict {PACKAGE_PIN Y7     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_tx2_dclk_out_n]      ;## FMC_HPC1_LA18_CC_N
set_property  -dict {PACKAGE_PIN Y8     IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100}  [get_ports adrv2_tx2_dclk_out_p]      ;## FMC_HPC1_LA18_CC_P
set_property  -dict {PACKAGE_PIN AF12   IOSTANDARD LVDS}                          [get_ports adrv2_tx2_idata_in_n]      ;## FMC_HPC1_LA23_N
set_property  -dict {PACKAGE_PIN AE12   IOSTANDARD LVDS}                          [get_ports adrv2_tx2_idata_in_p]      ;## FMC_HPC1_LA23_P
set_property  -dict {PACKAGE_PIN AF10   IOSTANDARD LVDS}                          [get_ports adrv2_tx2_qdata_in_n]      ;## FMC_HPC1_LA25_N
set_property  -dict {PACKAGE_PIN AE10   IOSTANDARD LVDS}                          [get_ports adrv2_tx2_qdata_in_p]      ;## FMC_HPC1_LA25_P
set_property  -dict {PACKAGE_PIN AH11   IOSTANDARD LVDS}                          [get_ports adrv2_tx2_strobe_in_n]     ;## FMC_HPC1_LA24_N
set_property  -dict {PACKAGE_PIN AH12   IOSTANDARD LVDS}                          [get_ports adrv2_tx2_strobe_in_p]     ;## FMC_HPC1_LA24_P

# clocks

create_clock -name adrv1_ref_clk       -period  8.00 [get_ports fpga_ref_clk_p]

create_clock -name adrv1_rx1_dclk_in   -period  2.034 [get_ports adrv1_rx1_dclk_out_p]
create_clock -name adrv1_rx2_dclk_in   -period  2.034 [get_ports adrv1_rx2_dclk_out_p]
create_clock -name adrv1_tx1_dclk_in   -period  2.034 [get_ports adrv1_tx1_dclk_out_p]
create_clock -name adrv1_tx2_dclk_in   -period  2.034 [get_ports adrv1_tx2_dclk_out_p]

create_clock -name adrv2_rx1_dclk_in   -period  2.034 [get_ports adrv2_rx1_dclk_out_p]
create_clock -name adrv2_rx2_dclk_in   -period  2.034 [get_ports adrv2_rx2_dclk_out_p]
create_clock -name adrv2_tx1_dclk_in   -period  2.034 [get_ports adrv2_tx1_dclk_out_p]
create_clock -name adrv2_tx2_dclk_in   -period  2.034 [get_ports adrv2_tx2_dclk_out_p]

# Allow max skew of 0.2 ns between input clocks
set_clock_latency -source -early -0.1 [get_clocks adrv1_rx1_dclk_in]
set_clock_latency -source -early -0.1 [get_clocks adrv1_rx2_dclk_in]

set_clock_latency -source -late 0.1 [get_clocks adrv1_rx1_dclk_in]
set_clock_latency -source -late 0.1 [get_clocks adrv1_rx2_dclk_in]

# Allow max skew of 0.2 ns between input clocks
set_clock_latency -source -early -0.1 [get_clocks adrv2_rx1_dclk_in]
set_clock_latency -source -early -0.1 [get_clocks adrv2_rx2_dclk_in]

set_clock_latency -source -late 0.1 [get_clocks adrv2_rx1_dclk_in]
set_clock_latency -source -late 0.1 [get_clocks adrv2_rx2_dclk_in]


set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_1 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_1/inst/i_if/i_rx_1_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_1/inst/i_if/i_rx_1_phy/i_clk_buf_fast/O]] \
  ]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_2 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_1/inst/i_if/i_rx_2_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_1/inst/i_if/i_rx_2_phy/i_clk_buf_fast/O]] \
  ]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_3 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_2/inst/i_if/i_rx_1_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_2/inst/i_if/i_rx_1_phy/i_clk_buf_fast/O]] \
  ]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_4 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_2/inst/i_if/i_rx_2_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_2/inst/i_if/i_rx_2_phy/i_clk_buf_fast/O]] \
  ]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_5 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_1/inst/i_if/i_tx_1_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_1/inst/i_if/i_tx_1_phy/i_clk_buf_fast/O]] \
  ]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_6 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_1/inst/i_if/i_tx_2_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_1/inst/i_if/i_tx_2_phy/i_clk_buf_fast/O]] \
  ]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_7 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_2/inst/i_if/i_tx_1_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_2/inst/i_if/i_tx_1_phy/i_clk_buf_fast/O]] \
  ]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_8 \
  [list [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_2/inst/i_if/i_tx_2_phy/i_div_clk_buf/O]] \
        [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001_2/inst/i_if/i_tx_2_phy/i_clk_buf_fast/O]] \
  ]

set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports adrv1_tx1_strobe_in_p]
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports adrv1_tx2_idata_in_p]

set_false_path -to [get_pins i_system_wrapper/system_i/axi_adrv9001_1/inst/i_sync/mssi_sync_in_d_reg/D]
set_false_path -to [get_pins i_system_wrapper/system_i/axi_adrv9001_2/inst/i_sync/mssi_sync_in_d_reg/D]
