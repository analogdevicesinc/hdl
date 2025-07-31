###############################################################################
## Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# hmcad15xx, 1st ADC

# switch P & N
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_n[0]}]
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_p[0]}]

set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_n[1]}]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_p[1]}]

set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_n[2]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_p[2]}]

set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_n[3]}]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_p[3]}]

set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_n[4]}]
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_p[4]}]

set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_n[5]}]
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_p[5]}]

set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_n[6]}]
set_property -dict {PACKAGE_PIN G12 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_p[6]}]

set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_n[7]}]
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a1_p[7]}]

set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports clk_in_a1_n]
set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports clk_in_a1_p]

set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fclk_a1_n]
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fclk_a1_p]

# hmcad15xx, 2nd ADC

set_property -dict {PACKAGE_PIN N7 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_p[0]}]
set_property -dict {PACKAGE_PIN N8 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_n[0]}]

set_property -dict {PACKAGE_PIN M9 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_p[1]}]
set_property -dict {PACKAGE_PIN N9 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_n[1]}]

set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_p[2]}]
set_property -dict {PACKAGE_PIN M11 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_n[2]}]

set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_p[3]}]
set_property -dict {PACKAGE_PIN R8 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_n[3]}]

set_property -dict {PACKAGE_PIN P8 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_p[4]}]
set_property -dict {PACKAGE_PIN P9 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_n[4]}]

set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_n[5]}]
set_property -dict {PACKAGE_PIN P10 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_p[5]}]

set_property -dict {PACKAGE_PIN R12 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_p[6]}]
set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_n[6]}]

set_property -dict {PACKAGE_PIN P13 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_p[7]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {data_in_a2_n[7]}]

# switch LCLK with FCLK according to the datasheet
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fclk_a2_p]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fclk_a2_n]

set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports clk_in_a2_p]
set_property -dict {PACKAGE_PIN N12 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports clk_in_a2_n]


create_clock -period 4.000 -name ref_clk_a1 [get_ports clk_in_a1_p]
create_clock -period 4.000 -name ref_clk_a2 [get_ports clk_in_a2_p]

# # input                  ____________________
# # clock    _____________|                    |_____________
# #                       |                    |
# #                dv_bre | dv_are      dv_bfe | dv_afe
# #               <------>|<------>    <------>|<------>
# #          _    ________|________    ________|________    _
# # data     _XXXX____Rise_Data____XXXX____Fall_Data____XXXX_
# #



# # # Input Delay Constraint
set_input_delay -clock ref_clk_a1 -max 1.050 [get_ports {data_in_a1_p[*]}]
set_input_delay -clock ref_clk_a1 -min 1.000 [get_ports {data_in_a1_p[*]}]
set_input_delay -clock ref_clk_a1 -clock_fall -max -add_delay 1.050 [get_ports {data_in_a1_p[*]}]
set_input_delay -clock ref_clk_a1 -clock_fall -min -add_delay 1.000 [get_ports {data_in_a1_p[*]}]

set_input_delay -clock ref_clk_a2 -max 1.050 [get_ports {data_in_a2_p[*]}]
set_input_delay -clock ref_clk_a2 -min 1.000 [get_ports {data_in_a2_p[*]}]
set_input_delay -clock ref_clk_a2 -clock_fall -max -add_delay 1.050 [get_ports {data_in_a2_p[*]}]
set_input_delay -clock ref_clk_a2 -clock_fall -min -add_delay 1.000 [get_ports {data_in_a2_p[*]}]

# I2C

set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS25} [get_ports iic_scl]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS25} [get_ports iic_sca]

# GPIOs

set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS25} [get_ports ad9696_ldac]

# SPI

set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS25} [get_ports spi_a1_csn]
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS25} [get_ports spi_a2_csn]
set_property -dict {PACKAGE_PIN E11 IOSTANDARD LVCMOS25} [get_ports spi_clk]
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS25} [get_ports spi_sdata]

# probably gone in 2016.4

create_clock -period 10.000 -name clk_fpga_0 [get_pins {i_system_wrapper/system_i/sys_ps7/inst/PS7_i/FCLKCLK[0]}]
create_clock -period 5.000 -name clk_fpga_1 [get_pins {i_system_wrapper/system_i/sys_ps7/inst/PS7_i/FCLKCLK[1]}]

create_clock -period 40.000 -name spi0_clk [get_pins -hier */EMIOSPI0SCLKO]

set_input_jitter clk_fpga_0 0.300
set_input_jitter clk_fpga_1 0.150

set_property IOSTANDARD LVCMOS18 [get_ports *fixed_io_mio*]
set_property SLEW SLOW [get_ports *fixed_io_mio*]
set_property DRIVE 8 [get_ports *fixed_io_mio*]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[0]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[1]}]
set_property -dict {PACKAGE_PIN A8} [get_ports {fixed_io_mio[2]}]
set_property -dict {PACKAGE_PIN A7} [get_ports {fixed_io_mio[3]}]
set_property -dict {PACKAGE_PIN C8} [get_ports {fixed_io_mio[4]}]
set_property -dict {PACKAGE_PIN A9} [get_ports {fixed_io_mio[5]}]
set_property -dict {PACKAGE_PIN A10} [get_ports {fixed_io_mio[6]}]
set_property -dict {PACKAGE_PIN D9} [get_ports {fixed_io_mio[7]}]
set_property -dict {PACKAGE_PIN B6} [get_ports {fixed_io_mio[8]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[9]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[10]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[11]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[12]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[13]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[14]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[15]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[16]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[17]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[18]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[19]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[20]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[21]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[22]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[23]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[24]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[25]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[26]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[27]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[28]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[29]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[30]}]
set_property PULLTYPE PULLUP [get_ports {fixed_io_mio[31]}]

set_property IOSTANDARD LVCMOS18 [get_ports *fixed_io_ps*]
set_property SLEW SLOW [get_ports *fixed_io_ps*]
set_property DRIVE 8 [get_ports *fixed_io_ps*]

set_property IOSTANDARD SSTL15_T_DCI [get_ports *fixed_io_ddr_vr*]
set_property SLEW FAST [get_ports *fixed_io_ddr_vr*]

set_property IOSTANDARD DIFF_SSTL15 [get_ports ddr_ck_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports ddr_ck_p]
set_property SLEW FAST [get_ports ddr_ck_n]
set_property SLEW FAST [get_ports ddr_ck_p]

set_property IOSTANDARD SSTL15 [get_ports *ddr_addr*]
set_property SLEW SLOW [get_ports *ddr_addr*]

set_property IOSTANDARD SSTL15 [get_ports *ddr_ba*]
set_property SLEW SLOW [get_ports *ddr_ba*]

set_property IOSTANDARD SSTL15 [get_ports ddr_reset_n]
set_property SLEW FAST [get_ports ddr_reset_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_cs_n]
set_property SLEW SLOW [get_ports ddr_cs_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_ras_n]
set_property SLEW SLOW [get_ports ddr_ras_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_cas_n]
set_property SLEW SLOW [get_ports ddr_cas_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_we_n]
set_property SLEW SLOW [get_ports ddr_we_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_cke]
set_property SLEW SLOW [get_ports ddr_cke]
set_property IOSTANDARD SSTL15 [get_ports ddr_odt]
set_property SLEW SLOW [get_ports ddr_odt]

set_property IOSTANDARD SSTL15_T_DCI [get_ports {*ddr_dq[*]}]
set_property SLEW FAST [get_ports {*ddr_dq[*]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {*ddr_dm[*]}]
set_property SLEW FAST [get_ports {*ddr_dm[*]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports *ddr_dqs*]
set_property SLEW FAST [get_ports *ddr_dqs*]
set_property PACKAGE_PIN R6 [get_ports ddr_ras_n]
set_property PACKAGE_PIN C9 [get_ports fixed_io_ps_porb]
set_property PACKAGE_PIN K3 [get_ports ddr_odt]
set_property PACKAGE_PIN C13 [get_ports {fixed_io_mio[31]}]
set_property PACKAGE_PIN A12 [get_ports {fixed_io_mio[30]}]
set_property PACKAGE_PIN D13 [get_ports {fixed_io_mio[29]}]
set_property PACKAGE_PIN B12 [get_ports {fixed_io_mio[28]}]
set_property PACKAGE_PIN D14 [get_ports {fixed_io_mio[27]}]
set_property PACKAGE_PIN A13 [get_ports {fixed_io_mio[26]}]
set_property PACKAGE_PIN C14 [get_ports {fixed_io_mio[25]}]
set_property PACKAGE_PIN B14 [get_ports {fixed_io_mio[24]}]
set_property PACKAGE_PIN A14 [get_ports {fixed_io_mio[23]}]
set_property PACKAGE_PIN D15 [get_ports {fixed_io_mio[22]}]
set_property PACKAGE_PIN C11 [get_ports {fixed_io_mio[21]}]
set_property PACKAGE_PIN E15 [get_ports {fixed_io_mio[20]}]
set_property PACKAGE_PIN C12 [get_ports {fixed_io_mio[19]}]
set_property PACKAGE_PIN B15 [get_ports {fixed_io_mio[18]}]
set_property PACKAGE_PIN D11 [get_ports {fixed_io_mio[17]}]
set_property PACKAGE_PIN A15 [get_ports {fixed_io_mio[16]}]
set_property PACKAGE_PIN D10 [get_ports {fixed_io_mio[15]}]
set_property PACKAGE_PIN B9 [get_ports {fixed_io_mio[14]}]
set_property PACKAGE_PIN C6 [get_ports {fixed_io_mio[13]}]
set_property PACKAGE_PIN B7 [get_ports {fixed_io_mio[12]}]
set_property PACKAGE_PIN B10 [get_ports {fixed_io_mio[11]}]
set_property PACKAGE_PIN D6 [get_ports {fixed_io_mio[10]}]
set_property PACKAGE_PIN B5 [get_ports {fixed_io_mio[9]}]
set_property PACKAGE_PIN A5 [get_ports {fixed_io_mio[1]}]
set_property PACKAGE_PIN D8 [get_ports {fixed_io_mio[0]}]
set_property PACKAGE_PIN L4 [get_ports ddr_reset_n]
set_property PACKAGE_PIN R3 [get_ports ddr_we_n]
set_property PACKAGE_PIN J3 [get_ports fixed_io_ddr_vrn]
set_property PACKAGE_PIN H3 [get_ports fixed_io_ddr_vrp]
set_property PACKAGE_PIN P1 [get_ports {ddr_addr[0]}]
set_property PACKAGE_PIN N1 [get_ports {ddr_addr[1]}]
set_property PACKAGE_PIN M1 [get_ports {ddr_addr[2]}]
set_property PACKAGE_PIN M4 [get_ports {ddr_addr[3]}]
set_property PACKAGE_PIN P3 [get_ports {ddr_addr[4]}]
set_property PACKAGE_PIN P4 [get_ports {ddr_addr[5]}]
set_property PACKAGE_PIN P5 [get_ports {ddr_addr[6]}]
set_property PACKAGE_PIN M5 [get_ports {ddr_addr[7]}]
set_property PACKAGE_PIN P6 [get_ports {ddr_addr[8]}]
set_property PACKAGE_PIN N4 [get_ports {ddr_addr[9]}]
set_property PACKAGE_PIN J1 [get_ports {ddr_addr[10]}]
set_property PACKAGE_PIN L2 [get_ports {ddr_addr[11]}]
set_property PACKAGE_PIN M2 [get_ports {ddr_addr[12]}]
set_property PACKAGE_PIN K1 [get_ports {ddr_addr[14]}]
set_property PACKAGE_PIN K2 [get_ports {ddr_addr[13]}]
set_property PACKAGE_PIN M6 [get_ports {ddr_ba[0]}]
set_property PACKAGE_PIN R1 [get_ports {ddr_ba[1]}]
set_property PACKAGE_PIN N6 [get_ports {ddr_ba[2]}]
set_property PACKAGE_PIN R5 [get_ports ddr_cas_n]
set_property PACKAGE_PIN L3 [get_ports ddr_cke]
set_property PACKAGE_PIN N2 [get_ports ddr_ck_n]
set_property PACKAGE_PIN N3 [get_ports ddr_ck_p]
set_property PACKAGE_PIN C7 [get_ports fixed_io_ps_clk]
set_property PACKAGE_PIN R2 [get_ports ddr_cs_n]
set_property PACKAGE_PIN B1 [get_ports {ddr_dm[0]}]
set_property PACKAGE_PIN D3 [get_ports {ddr_dm[1]}]
set_property PACKAGE_PIN D4 [get_ports {ddr_dq[0]}]
set_property PACKAGE_PIN A2 [get_ports {ddr_dq[1]}]
set_property PACKAGE_PIN C4 [get_ports {ddr_dq[2]}]
set_property PACKAGE_PIN C1 [get_ports {ddr_dq[3]}]
set_property PACKAGE_PIN B4 [get_ports {ddr_dq[4]}]
set_property PACKAGE_PIN A4 [get_ports {ddr_dq[5]}]
set_property PACKAGE_PIN C3 [get_ports {ddr_dq[6]}]
set_property PACKAGE_PIN A3 [get_ports {ddr_dq[7]}]
set_property PACKAGE_PIN E1 [get_ports {ddr_dq[8]}]
set_property PACKAGE_PIN D1 [get_ports {ddr_dq[9]}]
set_property PACKAGE_PIN E2 [get_ports {ddr_dq[10]}]
set_property PACKAGE_PIN E3 [get_ports {ddr_dq[11]}]
set_property PACKAGE_PIN F3 [get_ports {ddr_dq[12]}]
set_property PACKAGE_PIN G1 [get_ports {ddr_dq[13]}]
set_property PACKAGE_PIN H1 [get_ports {ddr_dq[14]}]
set_property PACKAGE_PIN H2 [get_ports {ddr_dq[15]}]
set_property PACKAGE_PIN B2 [get_ports {ddr_dqs_n[0]}]
set_property PACKAGE_PIN F2 [get_ports {ddr_dqs_n[1]}]
set_property PACKAGE_PIN C2 [get_ports {ddr_dqs_p[0]}]
set_property PACKAGE_PIN G2 [get_ports {ddr_dqs_p[1]}]

