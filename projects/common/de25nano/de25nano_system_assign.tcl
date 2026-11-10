###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_global_assignment -name DEVICE_FILTER_PACKAGE VPBGA

#============================================================
# Configuration scheme/pin 
#============================================================
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "ACTIVE SERIAL X4"
set_global_assignment -name ACTIVE_SERIAL_CLOCK AS_FREQ_125MHZ
set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHZ
set_global_assignment -name USE_HPS_COLD_RESET SDM_IO11
set_global_assignment -name USE_CONF_DONE SDM_IO16
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
set_global_assignment -name NUMBER_OF_SLAVE_DEVICE 2
set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF
set_global_assignment -name HPS_DAP_SPLIT_MODE "SDM PINS"
set_global_assignment -name HPS_DAP_NO_CERTIFICATE on
set_global_assignment -name AUTO_RESTART_CONFIGURATION OFF
set_global_assignment -name ENABLE_SIGNALTAP OFF
set_global_assignment -name POWER_APPLY_THERMAL_MARGIN ADDITIONAL
set_global_assignment -name STRATIX_JTAG_USER_CODE 77777777
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
set_global_assignment -name HPS_INITIALIZATION "HPS FIRST"
set_global_assignment -name QSPI_OWNERSHIP HPS
set_global_assignment -name INI_VARS "asm_enable_advanced_devices=on"
set_global_assignment -name NUM_PARALLEL_PROCESSORS 4
set_global_assignment -name BOARD default
set_global_assignment -name PROJECT_IP_REGENERATION_POLICY ALWAYS_REGENERATE_IP


#============================================================
# CLOCK
#============================================================
set_instance_assignment -name IO_STANDARD "1.1-V" -to CLOCK0_50
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to CLOCK1_50
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to CLOCK2_50
set_location_assignment PIN_DJ35 -to CLOCK0_50
set_location_assignment PIN_V16  -to CLOCK1_50
set_location_assignment PIN_BF23 -to CLOCK2_50
#set_location_assignment PIN_AN67 -to HPS_CLK_25

#============================================================
# KEY
#============================================================
#set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to KEY[0]
#set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to KEY[1]
#set_location_assignment PIN_C8   -to KEY[0]
#set_location_assignment PIN_C11  -to KEY[1]

#============================================================
# SW
#============================================================
#set_instance_assignment -name IO_STANDARD "1.1-V" -to SW[0]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to SW[1]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to SW[2]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to SW[3]
#set_location_assignment PIN_DK24 -to SW[0]
#set_location_assignment PIN_DD24 -to SW[1]
#set_location_assignment PIN_DD27 -to SW[2]
#set_location_assignment PIN_DF27 -to SW[3]

#============================================================
# LED
#============================================================
#set_instance_assignment -name IO_STANDARD "1.1-V" -to LED[0]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to LED[1]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to LED[2]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to LED[3]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to LED[4]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to LED[5]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to LED[6]
#set_instance_assignment -name IO_STANDARD "1.1-V" -to LED[7]
#set_location_assignment PIN_DF35 -to LED[0]
#set_location_assignment PIN_DJ32 -to LED[1]
#set_location_assignment PIN_DN22 -to LED[2]
#set_location_assignment PIN_DP23 -to LED[3]
#set_location_assignment PIN_DN25 -to LED[4]
#set_location_assignment PIN_DP25 -to LED[5]
#set_location_assignment PIN_DJ27 -to LED[6]
#set_location_assignment PIN_DP30 -to LED[7]

#============================================================
# HPS SD card
#============================================================
#set_instance_assignment -name IO_STANDARD "1.8-V" -to HPS_SD_CLK
#set_instance_assignment -name IO_STANDARD "1.8-V" -to HPS_SD_CMD
#set_instance_assignment -name IO_STANDARD "1.8-V" -to HPS_SD_DATA[0]
#set_instance_assignment -name IO_STANDARD "1.8-V" -to HPS_SD_DATA[1]
#set_instance_assignment -name IO_STANDARD "1.8-V" -to HPS_SD_DATA[2]
#set_instance_assignment -name IO_STANDARD "1.8-V" -to HPS_SD_DATA[3]
#set_location_assignment PIN_AC74 -to HPS_SD_CLK
#set_location_assignment PIN_AK69 -to HPS_SD_CMD
#set_location_assignment PIN_AF75 -to HPS_SD_DATA[0]
#set_location_assignment PIN_AC75 -to HPS_SD_DATA[1]
#set_location_assignment PIN_AN64 -to HPS_SD_DATA[2]
#set_location_assignment PIN_Y74  -to HPS_SD_DATA[3]

#============================================================
# LPDDR4A
#============================================================
set_instance_assignment -name IO_STANDARD "1.1-V TRUE DIFFERENTIAL SIGNALING" -to LPDDR4A_REFCLK_p
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_CS_n
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_CA[0]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_CA[1]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_CA[2]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_CA[3]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_CA[4]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_CA[5]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_CK
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_CKE
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_CK_n
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DM[0]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DM[1]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DM[2]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DM[3]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[0]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[1]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[2]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[3]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[4]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[5]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[6]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[7]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[8]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[9]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[10]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[11]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[12]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[13]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[14]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[15]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[16]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[17]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[18]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[19]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[20]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[21]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[22]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[23]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[24]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[25]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[26]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[27]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[28]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[29]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[30]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_DQ[31]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_DQS[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_DQS[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_DQS[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_DQS[3]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_DQS_n[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_DQS_n[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_DQS_n[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.1-V LVSTL" -to LPDDR4A_DQS_n[3]
set_instance_assignment -name IO_STANDARD "1.1-V LVSTL" -to LPDDR4A_RESET_n
set_instance_assignment -name IO_STANDARD "1.1-V" -to LPDDR4A_RZQ
set_location_assignment PIN_B55  -to LPDDR4A_REFCLK_p
set_location_assignment PIN_B58  -to LPDDR4A_CS_n
set_location_assignment PIN_B66  -to LPDDR4A_CA[0]
set_location_assignment PIN_A68  -to LPDDR4A_CA[1]
set_location_assignment PIN_B68  -to LPDDR4A_CA[2]
set_location_assignment PIN_A70  -to LPDDR4A_CA[3]
set_location_assignment PIN_B63  -to LPDDR4A_CA[4]
set_location_assignment PIN_A66  -to LPDDR4A_CA[5]
set_location_assignment PIN_J42  -to LPDDR4A_CK
set_location_assignment PIN_A61  -to LPDDR4A_CKE
set_location_assignment PIN_G42  -to LPDDR4A_CK_n
set_location_assignment PIN_J59  -to LPDDR4A_DM[0]
set_location_assignment PIN_T59  -to LPDDR4A_DM[1]
set_location_assignment PIN_J27  -to LPDDR4A_DM[2]
set_location_assignment PIN_A25  -to LPDDR4A_DM[3]
set_location_assignment PIN_T62  -to LPDDR4A_DQ[0]
set_location_assignment PIN_T56  -to LPDDR4A_DQ[1]
set_location_assignment PIN_G56  -to LPDDR4A_DQ[2]
set_location_assignment PIN_E56  -to LPDDR4A_DQ[3]
set_location_assignment PIN_G65  -to LPDDR4A_DQ[4]
set_location_assignment PIN_J65  -to LPDDR4A_DQ[5]
set_location_assignment PIN_M56  -to LPDDR4A_DQ[6]
set_location_assignment PIN_M62  -to LPDDR4A_DQ[7]
set_location_assignment PIN_W62  -to LPDDR4A_DQ[8]
set_location_assignment PIN_M65  -to LPDDR4A_DQ[9]
set_location_assignment PIN_M51  -to LPDDR4A_DQ[10]
set_location_assignment PIN_T51  -to LPDDR4A_DQ[11]
set_location_assignment PIN_AB48 -to LPDDR4A_DQ[12]
set_location_assignment PIN_W48  -to LPDDR4A_DQ[13]
set_location_assignment PIN_T65  -to LPDDR4A_DQ[14]
set_location_assignment PIN_AB62 -to LPDDR4A_DQ[15]
set_location_assignment PIN_G24  -to LPDDR4A_DQ[16]
set_location_assignment PIN_E24  -to LPDDR4A_DQ[17]
set_location_assignment PIN_J35  -to LPDDR4A_DQ[18]
set_location_assignment PIN_T32  -to LPDDR4A_DQ[19]
set_location_assignment PIN_M32  -to LPDDR4A_DQ[20]
set_location_assignment PIN_T24  -to LPDDR4A_DQ[21]
set_location_assignment PIN_G35  -to LPDDR4A_DQ[22]
set_location_assignment PIN_M24  -to LPDDR4A_DQ[23]
set_location_assignment PIN_A22  -to LPDDR4A_DQ[24]
set_location_assignment PIN_A23  -to LPDDR4A_DQ[25]
set_location_assignment PIN_A33  -to LPDDR4A_DQ[26]
set_location_assignment PIN_B33  -to LPDDR4A_DQ[27]
set_location_assignment PIN_B30  -to LPDDR4A_DQ[28]
set_location_assignment PIN_A36  -to LPDDR4A_DQ[29]
set_location_assignment PIN_A20  -to LPDDR4A_DQ[30]
set_location_assignment PIN_B22  -to LPDDR4A_DQ[31]
set_location_assignment PIN_G62  -to LPDDR4A_DQS[0]
set_location_assignment PIN_AB56 -to LPDDR4A_DQS[1]
set_location_assignment PIN_G32  -to LPDDR4A_DQS[2]
set_location_assignment PIN_B28  -to LPDDR4A_DQS[3]
set_location_assignment PIN_E62  -to LPDDR4A_DQS_n[0]
set_location_assignment PIN_W56  -to LPDDR4A_DQS_n[1]
set_location_assignment PIN_E32  -to LPDDR4A_DQS_n[2]
set_location_assignment PIN_A30  -to LPDDR4A_DQS_n[3]
set_location_assignment PIN_M48  -to LPDDR4A_RESET_n
set_location_assignment PIN_T48  -to LPDDR4A_RZQ

export_assignments
