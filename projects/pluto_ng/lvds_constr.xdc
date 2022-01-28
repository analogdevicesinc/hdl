
## ADRV9002 # BANK 65

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

# clocks

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
