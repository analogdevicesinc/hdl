###############################################################################
## Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# hmcad15xx, 1st ADC

set_property  -dict {PACKAGE_PIN H12 IOSTANDARD LVDS} [get_ports data_in_a1_p[0]]; # A1DP1A IO_L1N_T0_34
set_property  -dict {PACKAGE_PIN G11 IOSTANDARD LVDS} [get_ports data_in_a1_n[0]]; # A1DN1A IO_L1P_T0_34

set_property  -dict {PACKAGE_PIN H13 IOSTANDARD LVDS} [get_ports data_in_a1_p[1]]; # A1DP1B IO_L2N_T0_34
set_property  -dict {PACKAGE_PIN G12 IOSTANDARD LVDS} [get_ports data_in_a1_n[1]]; # A1DN1B IO_L2P_T0_34

set_property  -dict {PACKAGE_PIN H14 IOSTANDARD LVDS} [get_ports data_in_a1_p[2]]; # A1DP2A IO_L3N_T0_DQS_34
set_property  -dict {PACKAGE_PIN G14 IOSTANDARD LVDS} [get_ports data_in_a1_n[2]]; # A1DN2A IO_L3N_T0_DQS_PUDC_B_34

set_property  -dict {PACKAGE_PIN K15 IOSTANDARD LVDS} [get_ports data_in_a1_p[3]]; # A1DP2B IO_L4N_T0_34
set_property  -dict {PACKAGE_PIN J15 IOSTANDARD LVDS} [get_ports data_in_a1_n[3]]; # A1DN2B IO_L4P_T0_34

set_property  -dict {PACKAGE_PIN J14 IOSTANDARD LVDS} [get_ports data_in_a1_p[4]]; # A1DP3A IO_L5N_T0_34
set_property  -dict {PACKAGE_PIN J13 IOSTANDARD LVDS} [get_ports data_in_a1_n[4]]; # A1DN3A IO_L5P_T0_34

set_property  -dict {PACKAGE_PIN J11 IOSTANDARD LVDS} [get_ports data_in_a1_p[5]]; # A1DP3B IO_L6N_T0_VREF_34
set_property  -dict {PACKAGE_PIN H11 IOSTANDARD LVDS} [get_ports data_in_a1_n[5]]; # A1DN3B IO_L6P_T0_34

set_property  -dict {PACKAGE_PIN N14 IOSTANDARD LVDS} [get_ports data_in_a1_p[6]]; # A1DP4A IO_L7N_T1_34  
set_property  -dict {PACKAGE_PIN N13 IOSTANDARD LVDS} [get_ports data_in_a1_n[6]]; # A1DN4A IO_L7P_T1_34 

set_property  -dict {PACKAGE_PIN M15 IOSTANDARD LVDS} [get_ports data_in_a1_p[7]]; # A1DP4B IO_L8N_T1_34 
set_property  -dict {PACKAGE_PIN L15 IOSTANDARD LVDS} [get_ports data_in_a1_n[7]]; # A1DN4B IO_L8P_T1_34 

# hmcad15xx, 2nd ADC

set_property  -dict {PACKAGE_PIN R13 IOSTANDARD LVDS} [get_ports data_in_a2_p[0]]; # A2DP1A IO_L17N_T2_34
set_property  -dict {PACKAGE_PIN R12 IOSTANDARD LVDS} [get_ports data_in_a2_n[0]]; # A2DN1A IO_L17P_T2_34

set_property  -dict {PACKAGE_PIN P14 IOSTANDARD LVDS} [get_ports data_in_a2_p[1]]; # A2DP1B IO_L18N_T2_34
set_property  -dict {PACKAGE_PIN P13 IOSTANDARD LVDS} [get_ports data_in_a2_n[1]]; # A2DN1B IO_L18P_T2_34

set_property  -dict {PACKAGE_PIN N9 IOSTANDARD LVDS}  [get_ports data_in_a2_p[2]]; # A2DP2A IO_L19N_T3_VREF_34
set_property  -dict {PACKAGE_PIN M9 IOSTANDARD LVDS}  [get_ports data_in_a2_n[2]]; # A2DN2A IO_L19P_T3_34

set_property  -dict {PACKAGE_PIN R8 IOSTANDARD LVDS}  [get_ports data_in_a2_p[3]]; # A2DP2B IO_L20N_T3_34
set_property  -dict {PACKAGE_PIN R7 IOSTANDARD LVDS}  [get_ports data_in_a2_n[3]]; # A2DN2B IO_L20P_T3_34

set_property  -dict {PACKAGE_PIN M11 IOSTANDARD LVDS} [get_ports data_in_a2_p[4]]; # A2DP3A IO_L21N_T3_DQS_34
set_property  -dict {PACKAGE_PIN M10 IOSTANDARD LVDS} [get_ports data_in_a2_n[4]]; # A2DN3A IO_L21P_T3_DQS_34

set_property  -dict {PACKAGE_PIN N8 IOSTANDARD LVDS}  [get_ports data_in_a2_p[5]]; # A2DP3B IO_L22N_T3_34
set_property  -dict {PACKAGE_PIN N7 IOSTANDARD LVDS}  [get_ports data_in_a2_n[5]]; # A2DN3B IO_L22P_T3_34

set_property  -dict {PACKAGE_PIN P9 IOSTANDARD LVDS}  [get_ports data_in_a2_p[6]]; # A2DP4A IO_L23N_T3_34
set_property  -dict {PACKAGE_PIN P8 IOSTANDARD LVDS}  [get_ports data_in_a2_n[6]]; # A2DN4A IO_L23P_T3_34

set_property  -dict {PACKAGE_PIN R10 IOSTANDARD LVDS} [get_ports data_in_a2_p[7]]; # A2DP4B IO_L24N_T3_34
set_property  -dict {PACKAGE_PIN P10 IOSTANDARD LVDS} [get_ports data_in_a2_n[7]]; # A2DN4B IO_L24P_T3_34

# GPIOs

set_property  -dict {PACKAGE_PIN  L15  IOSTANDARD LVCMOS18} [get_ports gpio_status[0]]
set_property  -dict {PACKAGE_PIN  M15  IOSTANDARD LVCMOS18} [get_ports gpio_status[1]]
set_property  -dict {PACKAGE_PIN  N11  IOSTANDARD LVCMOS18} [get_ports gpio_status[2]]
set_property  -dict {PACKAGE_PIN  N12  IOSTANDARD LVCMOS18} [get_ports gpio_status[3]]
set_property  -dict {PACKAGE_PIN  M10  IOSTANDARD LVCMOS18} [get_ports gpio_status[4]]
set_property  -dict {PACKAGE_PIN  M11  IOSTANDARD LVCMOS18} [get_ports gpio_status[5]]
set_property  -dict {PACKAGE_PIN  N7   IOSTANDARD LVCMOS18} [get_ports gpio_status[6]]
set_property  -dict {PACKAGE_PIN  N8   IOSTANDARD LVCMOS18} [get_ports gpio_status[7]]

set_property  -dict {PACKAGE_PIN  F13  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[0]]
set_property  -dict {PACKAGE_PIN  F14  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[1]]
set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[2]]
set_property  -dict {PACKAGE_PIN  F15  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[3]]

set_property  -dict {PACKAGE_PIN  L13  IOSTANDARD LVCMOS18} [get_ports gpio_en_agc]
set_property  -dict {PACKAGE_PIN  P9   IOSTANDARD LVCMOS18} [get_ports gpio_resetb]

set_property  -dict {PACKAGE_PIN  K12  IOSTANDARD LVCMOS18} [get_ports enable]
set_property  -dict {PACKAGE_PIN  K11  IOSTANDARD LVCMOS18} [get_ports txnrx]

set_property  -dict {PACKAGE_PIN  E12  IOSTANDARD LVCMOS18  PULLTYPE PULLUP} [get_ports spi_csn]
set_property  -dict {PACKAGE_PIN  E11  IOSTANDARD LVCMOS18} [get_ports spi_clk]
set_property  -dict {PACKAGE_PIN  E13  IOSTANDARD LVCMOS18} [get_ports spi_mosi]
set_property  -dict {PACKAGE_PIN  F12  IOSTANDARD LVCMOS18} [get_ports spi_miso]

# PL GPIOs
#
# Pin  | Package Pin | GPIO     | Pluto    | Phaser  |
# -----|-------------|----------|----------|---------|
# L10P | K13         | PL_GPIO0 | SPI MOSI | TXDATA  |
# L12N | M12         | PL_GPIO1 | SPI MISO | BURST   |
# L24N | R10         | PL_GPIO2 | SPI CLKO | MUXOUT  |
# L7N  | N14         | PL_GPIO3 | IIC SDA  | IIC SDA |
# L9N  | M14         | PL_GPIO4 | IIC SCL  | IIC SCL |

set_property  -dict {PACKAGE_PIN  K13  IOSTANDARD LVCMOS18} [get_ports pl_gpio0]
set_property  -dict {PACKAGE_PIN  M12  IOSTANDARD LVCMOS18} [get_ports pl_gpio1]
set_property  -dict {PACKAGE_PIN  R10  IOSTANDARD LVCMOS18} [get_ports pl_gpio2]
set_property  -dict {PACKAGE_PIN  N14  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports pl_gpio3]
set_property  -dict {PACKAGE_PIN  M14  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports pl_gpio4]

set_property  -dict {PACKAGE_PIN  P8   IOSTANDARD LVCMOS18} [get_ports clk_out]

# probably gone in 2016.4

create_clock -name clk_fpga_0 -period 10 [get_pins "i_system_wrapper/system_i/sys_ps7/inst/PS7_i/FCLKCLK[0]"]
create_clock -name clk_fpga_1 -period  5 [get_pins "i_system_wrapper/system_i/sys_ps7/inst/PS7_i/FCLKCLK[1]"]

create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]

set_input_jitter clk_fpga_0 0.3
set_input_jitter clk_fpga_1 0.15

set_property IOSTANDARD LVCMOS18 [get_ports *fixed_io_mio*]
set_property SLEW SLOW [get_ports *fixed_io_mio*]
set_property DRIVE 8 [get_ports *fixed_io_mio*]
set_property  -dict {PACKAGE_PIN D8   PULLTYPE PULLUP} [get_ports fixed_io_mio[ 0]]
set_property  -dict {PACKAGE_PIN A5   PULLTYPE PULLUP} [get_ports fixed_io_mio[ 1]]
set_property  -dict {PACKAGE_PIN A8                  } [get_ports fixed_io_mio[ 2]]
set_property  -dict {PACKAGE_PIN A7                  } [get_ports fixed_io_mio[ 3]]
set_property  -dict {PACKAGE_PIN C8                  } [get_ports fixed_io_mio[ 4]]
set_property  -dict {PACKAGE_PIN A9                  } [get_ports fixed_io_mio[ 5]]
set_property  -dict {PACKAGE_PIN A10                 } [get_ports fixed_io_mio[ 6]]
set_property  -dict {PACKAGE_PIN D9                  } [get_ports fixed_io_mio[ 7]]
set_property  -dict {PACKAGE_PIN B6                  } [get_ports fixed_io_mio[ 8]]
set_property  -dict {PACKAGE_PIN B5   PULLTYPE PULLUP} [get_ports fixed_io_mio[ 9]]
set_property  -dict {PACKAGE_PIN D6   PULLTYPE PULLUP} [get_ports fixed_io_mio[10]]
set_property  -dict {PACKAGE_PIN B10  PULLTYPE PULLUP} [get_ports fixed_io_mio[11]]
set_property  -dict {PACKAGE_PIN B7   PULLTYPE PULLUP} [get_ports fixed_io_mio[12]]
set_property  -dict {PACKAGE_PIN C6   PULLTYPE PULLUP} [get_ports fixed_io_mio[13]]
set_property  -dict {PACKAGE_PIN B9   PULLTYPE PULLUP} [get_ports fixed_io_mio[14]]
set_property  -dict {PACKAGE_PIN D10  PULLTYPE PULLUP} [get_ports fixed_io_mio[15]]
set_property  -dict {PACKAGE_PIN A15  PULLTYPE PULLUP} [get_ports fixed_io_mio[16]]
set_property  -dict {PACKAGE_PIN D11  PULLTYPE PULLUP} [get_ports fixed_io_mio[17]]
set_property  -dict {PACKAGE_PIN B15  PULLTYPE PULLUP} [get_ports fixed_io_mio[18]]
set_property  -dict {PACKAGE_PIN C12  PULLTYPE PULLUP} [get_ports fixed_io_mio[19]]
set_property  -dict {PACKAGE_PIN E15  PULLTYPE PULLUP} [get_ports fixed_io_mio[20]]
set_property  -dict {PACKAGE_PIN C11  PULLTYPE PULLUP} [get_ports fixed_io_mio[21]]
set_property  -dict {PACKAGE_PIN D15  PULLTYPE PULLUP} [get_ports fixed_io_mio[22]]
set_property  -dict {PACKAGE_PIN A14  PULLTYPE PULLUP} [get_ports fixed_io_mio[23]]
set_property  -dict {PACKAGE_PIN B14  PULLTYPE PULLUP} [get_ports fixed_io_mio[24]]
set_property  -dict {PACKAGE_PIN C14  PULLTYPE PULLUP} [get_ports fixed_io_mio[25]]
set_property  -dict {PACKAGE_PIN A13  PULLTYPE PULLUP} [get_ports fixed_io_mio[26]]
set_property  -dict {PACKAGE_PIN D14  PULLTYPE PULLUP} [get_ports fixed_io_mio[27]]
set_property  -dict {PACKAGE_PIN B12  PULLTYPE PULLUP} [get_ports fixed_io_mio[28]]
set_property  -dict {PACKAGE_PIN D13  PULLTYPE PULLUP} [get_ports fixed_io_mio[29]]
set_property  -dict {PACKAGE_PIN A12  PULLTYPE PULLUP} [get_ports fixed_io_mio[30]]
set_property  -dict {PACKAGE_PIN C13  PULLTYPE PULLUP} [get_ports fixed_io_mio[31]]

set_property IOSTANDARD LVCMOS18 [get_ports *fixed_io_ps*]
set_property SLEW SLOW [get_ports *fixed_io_ps*]
set_property DRIVE 8 [get_ports *fixed_io_ps*]
set_property PACKAGE_PIN C7 [get_ports fixed_io_ps_clk]
set_property PACKAGE_PIN C9 [get_ports fixed_io_ps_porb]

set_property IOSTANDARD SSTL15_T_DCI [get_ports *fixed_io_ddr_vr*]
set_property SLEW FAST [get_ports *fixed_io_ddr_vr*]
set_property PACKAGE_PIN H3 [get_ports fixed_io_ddr_vrp]
set_property PACKAGE_PIN J3 [get_ports fixed_io_ddr_vrn]

set_property IOSTANDARD DIFF_SSTL15 [get_ports *ddr_ck*]
set_property SLEW FAST [get_ports *ddr_ck*]
set_property PACKAGE_PIN N3 [get_ports ddr_ck_p]
set_property PACKAGE_PIN N2 [get_ports ddr_ck_n]

set_property IOSTANDARD SSTL15 [get_ports *ddr_addr*]
set_property SLEW SLOW [get_ports *ddr_addr*]
set_property PACKAGE_PIN P1 [get_ports ddr_addr[0]]
set_property PACKAGE_PIN N1 [get_ports ddr_addr[1]]
set_property PACKAGE_PIN M1 [get_ports ddr_addr[2]]
set_property PACKAGE_PIN M4 [get_ports ddr_addr[3]]
set_property PACKAGE_PIN P3 [get_ports ddr_addr[4]]
set_property PACKAGE_PIN P4 [get_ports ddr_addr[5]]
set_property PACKAGE_PIN P5 [get_ports ddr_addr[6]]
set_property PACKAGE_PIN M5 [get_ports ddr_addr[7]]
set_property PACKAGE_PIN P6 [get_ports ddr_addr[8]]
set_property PACKAGE_PIN N4 [get_ports ddr_addr[9]]
set_property PACKAGE_PIN J1 [get_ports ddr_addr[10]]
set_property PACKAGE_PIN L2 [get_ports ddr_addr[11]]
set_property PACKAGE_PIN M2 [get_ports ddr_addr[12]]
set_property PACKAGE_PIN K2 [get_ports ddr_addr[13]]
set_property PACKAGE_PIN K1 [get_ports ddr_addr[14]]

set_property IOSTANDARD SSTL15 [get_ports *ddr_ba*]
set_property SLEW SLOW [get_ports *ddr_ba*]
set_property PACKAGE_PIN M6 [get_ports ddr_ba[0]]
set_property PACKAGE_PIN R1 [get_ports ddr_ba[1]]
set_property PACKAGE_PIN N6 [get_ports ddr_ba[2]]

set_property IOSTANDARD SSTL15 [get_ports ddr_reset_n]
set_property SLEW FAST [get_ports ddr_reset_n]
set_property PACKAGE_PIN L4 [get_ports ddr_reset_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_cs_n]
set_property SLEW SLOW [get_ports ddr_cs_n]
set_property PACKAGE_PIN R2 [get_ports ddr_cs_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_ras_n]
set_property SLEW SLOW [get_ports ddr_ras_n]
set_property PACKAGE_PIN R6 [get_ports ddr_ras_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_cas_n]
set_property SLEW SLOW [get_ports ddr_cas_n]
set_property PACKAGE_PIN R5 [get_ports ddr_cas_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_we_n]
set_property SLEW SLOW [get_ports ddr_we_n]
set_property PACKAGE_PIN R3 [get_ports ddr_we_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_cke]
set_property SLEW SLOW [get_ports ddr_cke]
set_property PACKAGE_PIN L3 [get_ports ddr_cke]
set_property IOSTANDARD SSTL15 [get_ports ddr_odt]
set_property SLEW SLOW [get_ports ddr_odt]
set_property PACKAGE_PIN K3 [get_ports ddr_odt]

set_property IOSTANDARD SSTL15_T_DCI [get_ports *ddr_dq[*]]
set_property SLEW FAST [get_ports *ddr_dq[*]]
set_property PACKAGE_PIN D4 [get_ports ddr_dq[0]]
set_property PACKAGE_PIN A2 [get_ports ddr_dq[1]]
set_property PACKAGE_PIN C4 [get_ports ddr_dq[2]]
set_property PACKAGE_PIN C1 [get_ports ddr_dq[3]]
set_property PACKAGE_PIN B4 [get_ports ddr_dq[4]]
set_property PACKAGE_PIN A4 [get_ports ddr_dq[5]]
set_property PACKAGE_PIN C3 [get_ports ddr_dq[6]]
set_property PACKAGE_PIN A3 [get_ports ddr_dq[7]]
set_property PACKAGE_PIN E1 [get_ports ddr_dq[8]]
set_property PACKAGE_PIN D1 [get_ports ddr_dq[9]]
set_property PACKAGE_PIN E2 [get_ports ddr_dq[10]]
set_property PACKAGE_PIN E3 [get_ports ddr_dq[11]]
set_property PACKAGE_PIN F3 [get_ports ddr_dq[12]]
set_property PACKAGE_PIN G1 [get_ports ddr_dq[13]]
set_property PACKAGE_PIN H1 [get_ports ddr_dq[14]]
set_property PACKAGE_PIN H2 [get_ports ddr_dq[15]]
set_property IOSTANDARD SSTL15_T_DCI [get_ports *ddr_dm[*]]
set_property SLEW FAST [get_ports *ddr_dm[*]]
set_property PACKAGE_PIN B1 [get_ports ddr_dm[0]]
set_property PACKAGE_PIN D3 [get_ports ddr_dm[1]]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports *ddr_dqs*]
set_property SLEW FAST [get_ports *ddr_dqs*]
set_property PACKAGE_PIN C2 [get_ports ddr_dqs_p[0]]
set_property PACKAGE_PIN B2 [get_ports ddr_dqs_n[0]]
set_property PACKAGE_PIN G2 [get_ports ddr_dqs_p[1]]
set_property PACKAGE_PIN F2 [get_ports ddr_dqs_n[1]]
