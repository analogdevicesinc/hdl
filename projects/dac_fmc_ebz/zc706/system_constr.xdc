# ***************************************************************************
# ***************************************************************************
# Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
#
# In this HDL repository, there are many different and unique modules, consisting
# of various HDL (Verilog or VHDL) components. The individual modules are
# developed independently, and may be accompanied by separate and unique license
# terms.
#
# The user should read each of these license terms, and understand the
# freedoms and responsibilities that he or she has by using this source/core.
#
# This core is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.
#
# Redistribution and use of source or resulting binaries, with or without modification
# of this file, are permitted under one of the following two license terms:
#
#   1. The GNU General Public License version 2 as published by the
#      Free Software Foundation, which can be found in the top level directory
#      of this repository (LICENSE_GPL2), and also online at:
#      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
#
# OR
#
#   2. An ADI specific BSD license, which can be found in the top level directory
#      of this repository (LICENSE_ADIBSD), and also on-line at:
#      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
#      This will allow to generate bit files and not release the source code,
#      as long as it attaches to an ADI device.
#
# ***************************************************************************
# ***************************************************************************

set_property  -dict {PACKAGE_PIN  AD10} [get_ports tx_ref_clk_p]                                      ; ## D04  FMC_HPC_GBTCLK0_M2C_P           MGTREFCLK0P_109_AD10
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports tx_ref_clk_n]                                      ; ## D05  FMC_HPC_GBTCLK0_M2C_N           MGTREFCLK0N_109_AD9

set_property  -dict {PACKAGE_PIN  AK10} [get_ports tx_data_p[0]]                                      ; ## C02  FMC_HPC_DP0_C2M_P               MGTXTXP0_109_A
set_property  -dict {PACKAGE_PIN  AK9 } [get_ports tx_data_n[0]]                                      ; ## C03  FMC_HPC_DP0_C2M_N               MGTXTXN0_109_AK9
set_property  -dict {PACKAGE_PIN  AK6 } [get_ports tx_data_p[1]]                                      ; ## A22  FMC_HPC_DP1_C2M_P               MGTXTXP1_109_AK6
set_property  -dict {PACKAGE_PIN  AK5 } [get_ports tx_data_n[1]]                                      ; ## A23  FMC_HPC_DP1_C2M_N               MGTXTXN1_109_AK5
set_property  -dict {PACKAGE_PIN  AJ4 } [get_ports tx_data_p[2]]                                      ; ## A26  FMC_HPC_DP2_C2M_P               MGTXTXP2_109_AJ4
set_property  -dict {PACKAGE_PIN  AJ3 } [get_ports tx_data_n[2]]                                      ; ## A27  FMC_HPC_DP2_C2M_N               MGTXTXN2_109_AJ3
set_property  -dict {PACKAGE_PIN  AK2 } [get_ports tx_data_p[3]]                                      ; ## A30  FMC_HPC_DP3_C2M_P               MGTXTXP3_109_AK2
set_property  -dict {PACKAGE_PIN  AK1 } [get_ports tx_data_n[3]]                                      ; ## A31  FMC_HPC_DP3_C2M_N               MGTXTXN3_109_AK1
set_property  -dict {PACKAGE_PIN  AH2 } [get_ports tx_data_p[4]]                                      ; ## A34  FMC_HPC_DP4_C2M_P               MGTXTXP0_110_AH2
set_property  -dict {PACKAGE_PIN  AH1 } [get_ports tx_data_n[4]]                                      ; ## A35  FMC_HPC_DP4_C2M_N               MGTXTXN0_110_AH1
set_property  -dict {PACKAGE_PIN  AF2 } [get_ports tx_data_p[5]]                                      ; ## A38  FMC_HPC_DP5_C2M_P               MGTXTXP1_110_AF2
set_property  -dict {PACKAGE_PIN  AF1 } [get_ports tx_data_n[5]]                                      ; ## A39  FMC_HPC_DP5_C2M_N               MGTXTXN1_110_AF1
set_property  -dict {PACKAGE_PIN  AE4 } [get_ports tx_data_p[6]]                                      ; ## B36  FMC_HPC_DP6_C2M_P               MGTXTXP2_110_AE4
set_property  -dict {PACKAGE_PIN  AE3 } [get_ports tx_data_n[6]]                                      ; ## B37  FMC_HPC_DP6_C2M_N               MGTXTXN2_110_AE3
set_property  -dict {PACKAGE_PIN  AD2 } [get_ports tx_data_p[7]]                                      ; ## B32  FMC_HPC_DP7_C2M_P               MGTXTXP3_110_AD2
set_property  -dict {PACKAGE_PIN  AD1 } [get_ports tx_data_n[7]]                                      ; ## B33  FMC_HPC_DP7_C2M_N               MGTXTXN3_110_AD1

set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p[0]]   ; ## D07  FMC_HPC_LA01_P                  IO_L13P_T2_MRCC_11_AG21
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n[0]]   ; ## D08  FMC_HPC_LA01_N                  IO_L13N_T2_MRCC_11_AH21
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p[1]]   ; ## H07  FMC_HPC_LA02_P                  IO_L16P_T2_11_AK17
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n[1]]   ; ## H08  FMC_HPC_LA02_N                  IO_L16N_T2_11_AK18
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_p]    ; ## G06  FMC_HPC_LA00_P                  IO_L14P_T2_SRCC_11_AF20
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_n]    ; ## G07  FMC_HPC_LA00_N                  IO_L14N_T2_SRCC_11_AG20

set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVCMOS25} [get_ports spi_en]                       ; ## D12  FMC_HPC_LA05_N                  IO_L5N_T0_11_AH24

set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## G09  FMC_HPC_LA03_P                  IO_L17P_T2_11_AH19
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVCMOS25} [get_ports spi_mosi]                     ; ## G10  FMC_HPC_LA03_N                  IO_L17N_T2_11_AJ19
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVCMOS25} [get_ports spi_miso]                     ; ## H10  FMC_HPC_LA04_P                  IO_L15P_T2_DQS_11_AJ20
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVCMOS25} [get_ports spi_csn_dac]                  ; ## H11  FMC_HPC_LA04_N                  IO_L15N_T2_DQS_11_AK20
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                  ; ## D11  FMC_HPC_LA05_P                  IO_L5P_T0_11_AH23

set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports dac_txen[0]]                  ; ## H13  FMC_HPC_LA07_P                  IO_L4P_T0_11_AJ23
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVCMOS25} [get_ports dac_txen[1]]                  ; ## H14  FMC_HPC_LA07_N                  IO_L4N_T0_11_AJ24

# clocks

# Maximum lane of 10.3125 (Maximum supported by the ZC706)
create_clock -name tx_ref_clk   -period  3.879 [get_ports tx_ref_clk_p]

# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Center-Aligned signal to REFCLK
set_input_delay -clock [get_clocks tx_ref_clk] \
  [expr [get_property  PERIOD [get_clocks tx_ref_clk]] / 2] \
  [get_ports {tx_sysref_*}]
