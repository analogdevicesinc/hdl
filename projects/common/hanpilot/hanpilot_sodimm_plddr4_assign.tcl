
# pl-ddr4 settings

set_location_assignment PIN_AB12  -to sys_ddr_ref_clk
set_location_assignment PIN_AA12  -to "sys_ddr_ref_clk(n)"

set_instance_assignment -name IO_STANDARD LVDS -to sys_ddr_ref_clk
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sys_ddr_ref_clk -disable

set_location_assignment PIN_AD3   -to sys_ddr_clk_p

set_location_assignment PIN_AD4   -to sys_ddr_clk_n

set_location_assignment PIN_AC1  -to sys_ddr_a[0]
set_location_assignment PIN_AB1  -to sys_ddr_a[1]
set_location_assignment PIN_AB4  -to sys_ddr_a[2]
set_location_assignment PIN_AA5  -to sys_ddr_a[3]
set_location_assignment PIN_AA3  -to sys_ddr_a[4]
set_location_assignment PIN_AA4  -to sys_ddr_a[5]
set_location_assignment PIN_Y2   -to sys_ddr_a[6]
set_location_assignment PIN_AA2  -to sys_ddr_a[7]
set_location_assignment PIN_AB5  -to sys_ddr_a[8]
set_location_assignment PIN_AB6  -to sys_ddr_a[9]
set_location_assignment PIN_W5   -to sys_ddr_a[10]
set_location_assignment PIN_Y5   -to sys_ddr_a[11]
set_location_assignment PIN_AA9  -to sys_ddr_a[12]
set_location_assignment PIN_AB7  -to sys_ddr_a[13]
set_location_assignment PIN_AA7  -to sys_ddr_a[14]
set_location_assignment PIN_AB10 -to sys_ddr_a[15]
set_location_assignment PIN_AB11 -to sys_ddr_a[16]

# set_location_assignment PIN_AD5 -to sys_ddr_ac_r[0]
# set_location_assignment PIN_Y6  -to sys_ddr_ac_r[1]
# set_location_assignment PIN_AC4 -to sys_ddr_c[0]
# set_location_assignment PIN_AB2 -to sys_ddr_c[1]

set_location_assignment PIN_Y7    -to sys_ddr_ba[0]
set_location_assignment PIN_AB9   -to sys_ddr_ba[1]
set_location_assignment PIN_AA10  -to sys_ddr_bg[0]
set_location_assignment PIN_AE2   -to sys_ddr_bg[1]
set_location_assignment PIN_AC2   -to sys_ddr_cke
set_location_assignment PIN_AE1   -to sys_ddr_cs_n
set_location_assignment PIN_AC3   -to sys_ddr_odt
set_location_assignment PIN_AE3   -to sys_ddr_reset_n
set_location_assignment PIN_AD1   -to sys_ddr_act_n
set_location_assignment PIN_AC6   -to sys_ddr_par
set_location_assignment PIN_AC12  -to sys_ddr_alert_n
# set_location_assignment PIN_T5    -to sys_ddr_event_n

set_location_assignment PIN_AE8  -to sys_ddr_dqs_p[0]
set_location_assignment PIN_AF7  -to sys_ddr_dqs_p[1]
set_location_assignment PIN_AN1  -to sys_ddr_dqs_p[2]
set_location_assignment PIN_AH2  -to sys_ddr_dqs_p[3]
set_location_assignment PIN_P1   -to sys_ddr_dqs_p[4]
set_location_assignment PIN_J3   -to sys_ddr_dqs_p[5]
set_location_assignment PIN_R5   -to sys_ddr_dqs_p[6]
set_location_assignment PIN_V9   -to sys_ddr_dqs_p[7]
set_location_assignment PIN_V2   -to sys_ddr_dqs_p[8]

set_location_assignment PIN_AD8  -to sys_ddr_dqs_n[0]
set_location_assignment PIN_AE7  -to sys_ddr_dqs_n[1]
set_location_assignment PIN_AN2  -to sys_ddr_dqs_n[2]
set_location_assignment PIN_AH3  -to sys_ddr_dqs_n[3]
set_location_assignment PIN_R1   -to sys_ddr_dqs_n[4]
set_location_assignment PIN_K3   -to sys_ddr_dqs_n[5]
set_location_assignment PIN_R6   -to sys_ddr_dqs_n[6]
set_location_assignment PIN_W9   -to sys_ddr_dqs_n[7]
set_location_assignment PIN_V3   -to sys_ddr_dqs_n[8]

set_location_assignment PIN_AC11 -to sys_ddr_dq[0]
set_location_assignment PIN_AD10 -to sys_ddr_dq[1]
set_location_assignment PIN_AC9  -to sys_ddr_dq[2]
set_location_assignment PIN_AG7  -to sys_ddr_dq[3]
set_location_assignment PIN_AD13 -to sys_ddr_dq[4]
set_location_assignment PIN_AD11 -to sys_ddr_dq[5]
set_location_assignment PIN_AC8  -to sys_ddr_dq[6]
set_location_assignment PIN_AF8  -to sys_ddr_dq[7]
set_location_assignment PIN_AE6  -to sys_ddr_dq[8]
set_location_assignment PIN_AJ6  -to sys_ddr_dq[9]
set_location_assignment PIN_AG6  -to sys_ddr_dq[10]
set_location_assignment PIN_AD6  -to sys_ddr_dq[11]
set_location_assignment PIN_AG5  -to sys_ddr_dq[12]
set_location_assignment PIN_AK5  -to sys_ddr_dq[13]
set_location_assignment PIN_AC7  -to sys_ddr_dq[14]
set_location_assignment PIN_AH6  -to sys_ddr_dq[15]
set_location_assignment PIN_AK1  -to sys_ddr_dq[16]
set_location_assignment PIN_AL4  -to sys_ddr_dq[17]
set_location_assignment PIN_AJ4  -to sys_ddr_dq[18]
set_location_assignment PIN_AM1  -to sys_ddr_dq[19]
set_location_assignment PIN_AK3  -to sys_ddr_dq[20]
set_location_assignment PIN_AL2  -to sys_ddr_dq[21]
set_location_assignment PIN_AJ3  -to sys_ddr_dq[22]
set_location_assignment PIN_AM2  -to sys_ddr_dq[23]
set_location_assignment PIN_AF2  -to sys_ddr_dq[24]
set_location_assignment PIN_AH1  -to sys_ddr_dq[25]
set_location_assignment PIN_AG4  -to sys_ddr_dq[26]
set_location_assignment PIN_AE5  -to sys_ddr_dq[27]
set_location_assignment PIN_AF3  -to sys_ddr_dq[28]
set_location_assignment PIN_AH4  -to sys_ddr_dq[29]
set_location_assignment PIN_AG1  -to sys_ddr_dq[30]
set_location_assignment PIN_AF4  -to sys_ddr_dq[31]
set_location_assignment PIN_K1   -to sys_ddr_dq[32]
set_location_assignment PIN_P4   -to sys_ddr_dq[33]
set_location_assignment PIN_N2   -to sys_ddr_dq[34]
set_location_assignment PIN_K2   -to sys_ddr_dq[35]
set_location_assignment PIN_M2   -to sys_ddr_dq[36]
set_location_assignment PIN_P3   -to sys_ddr_dq[37]
set_location_assignment PIN_N1   -to sys_ddr_dq[38]
set_location_assignment PIN_J1   -to sys_ddr_dq[39]
set_location_assignment PIN_N3   -to sys_ddr_dq[40]
set_location_assignment PIN_P5   -to sys_ddr_dq[41]
set_location_assignment PIN_M5   -to sys_ddr_dq[42]
set_location_assignment PIN_R2   -to sys_ddr_dq[43]
set_location_assignment PIN_N4   -to sys_ddr_dq[44]
set_location_assignment PIN_P6   -to sys_ddr_dq[45]
set_location_assignment PIN_L4   -to sys_ddr_dq[46]
set_location_assignment PIN_R3   -to sys_ddr_dq[47]
set_location_assignment PIN_V6   -to sys_ddr_dq[48]
set_location_assignment PIN_T7   -to sys_ddr_dq[49]
set_location_assignment PIN_U5   -to sys_ddr_dq[50]
set_location_assignment PIN_U7   -to sys_ddr_dq[51]
set_location_assignment PIN_T4   -to sys_ddr_dq[52]
set_location_assignment PIN_W6   -to sys_ddr_dq[53]
set_location_assignment PIN_T3   -to sys_ddr_dq[54]
set_location_assignment PIN_U6   -to sys_ddr_dq[55]
set_location_assignment PIN_W8   -to sys_ddr_dq[56]
set_location_assignment PIN_Y12  -to sys_ddr_dq[57]
set_location_assignment PIN_Y11  -to sys_ddr_dq[58]
set_location_assignment PIN_W10  -to sys_ddr_dq[59]
set_location_assignment PIN_Y13  -to sys_ddr_dq[60]
set_location_assignment PIN_Y8   -to sys_ddr_dq[61]
set_location_assignment PIN_Y10  -to sys_ddr_dq[62]
set_location_assignment PIN_W11  -to sys_ddr_dq[63]
set_location_assignment PIN_V1   -to sys_ddr_dq[64]
set_location_assignment PIN_Y1   -to sys_ddr_dq[65]
set_location_assignment PIN_W3   -to sys_ddr_dq[66]
set_location_assignment PIN_W1   -to sys_ddr_dq[67]
set_location_assignment PIN_Y3   -to sys_ddr_dq[68]
set_location_assignment PIN_W4   -to sys_ddr_dq[69]
set_location_assignment PIN_U1   -to sys_ddr_dq[70]
set_location_assignment PIN_U2   -to sys_ddr_dq[71]

set_location_assignment PIN_AD9 -to sys_ddr_dbi_n[0]
set_location_assignment PIN_AJ5 -to sys_ddr_dbi_n[1]
set_location_assignment PIN_AK2 -to sys_ddr_dbi_n[2]
set_location_assignment PIN_AG2 -to sys_ddr_dbi_n[3]
set_location_assignment PIN_L2  -to sys_ddr_dbi_n[4]
set_location_assignment PIN_L3  -to sys_ddr_dbi_n[5]
set_location_assignment PIN_U4  -to sys_ddr_dbi_n[6]
set_location_assignment PIN_V8  -to sys_ddr_dbi_n[7]
set_location_assignment PIN_V4  -to sys_ddr_dbi_n[8]

set_location_assignment PIN_AA8   -to sys_ddr_rzq

# set_location_assignment PIN_AF5 -to sys_ddr_scl
# set_location_assignment PIN_AJ1 -to sys_ddr_sda

