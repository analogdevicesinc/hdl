
# pl-ddr4 settings

set_location_assignment PIN_AU7   -to sys_ddr_ref_clk
set_location_assignment PIN_AT7   -to "sys_ddr_ref_clk(n)"

set_instance_assignment -name IO_STANDARD LVDS -to sys_ddr_ref_clk
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sys_ddr_ref_clk -disable

set_location_assignment PIN_AL13   -to sys_ddr_clk_p

set_location_assignment PIN_AK13   -to sys_ddr_clk_n

set_location_assignment PIN_AJ11  -to sys_ddr_a[0]
set_location_assignment PIN_AH12  -to sys_ddr_a[1]
set_location_assignment PIN_AP11  -to sys_ddr_a[2]
set_location_assignment PIN_AN11  -to sys_ddr_a[3]
set_location_assignment PIN_AM10  -to sys_ddr_a[4]
set_location_assignment PIN_AM11  -to sys_ddr_a[5]
set_location_assignment PIN_AP9   -to sys_ddr_a[6]
set_location_assignment PIN_AN9   -to sys_ddr_a[7]
set_location_assignment PIN_AR10  -to sys_ddr_a[8]
set_location_assignment PIN_AP10  -to sys_ddr_a[9]
set_location_assignment PIN_AM9   -to sys_ddr_a[10]
set_location_assignment PIN_AL10  -to sys_ddr_a[11]
set_location_assignment PIN_AV8   -to sys_ddr_a[12]
set_location_assignment PIN_AT8   -to sys_ddr_a[13]
set_location_assignment PIN_AT9   -to sys_ddr_a[14]
set_location_assignment PIN_AR7   -to sys_ddr_a[15]
set_location_assignment PIN_AR8   -to sys_ddr_a[16]

set_location_assignment PIN_AU6   -to sys_ddr_ba[0]
set_location_assignment PIN_AP8   -to sys_ddr_ba[1]
set_location_assignment PIN_AN8   -to sys_ddr_bg
#set_location_assignment PIN_AJ14 -to DDR4A_BG[1]
set_location_assignment PIN_AK10  -to sys_ddr_cke
set_location_assignment PIN_AJ13  -to sys_ddr_cs_n
set_location_assignment PIN_AL12  -to sys_ddr_odt
set_location_assignment PIN_AH14  -to sys_ddr_reset_n
set_location_assignment PIN_AH13  -to sys_ddr_act_n
set_location_assignment PIN_AM12  -to sys_ddr_par
set_location_assignment PIN_AH11  -to sys_ddr_alert_n

set_location_assignment PIN_AE12  -to sys_ddr_dqs_p[0]
set_location_assignment PIN_AL7   -to sys_ddr_dqs_p[1]
set_location_assignment PIN_AR6   -to sys_ddr_dqs_p[2]
set_location_assignment PIN_AT2   -to sys_ddr_dqs_p[3]
set_location_assignment PIN_AF13  -to sys_ddr_dqs_n[0]
set_location_assignment PIN_AK8   -to sys_ddr_dqs_n[1]
set_location_assignment PIN_AP6   -to sys_ddr_dqs_n[2]
set_location_assignment PIN_AT3   -to sys_ddr_dqs_n[3]

set_location_assignment PIN_AJ9   -to sys_ddr_dq[0]
set_location_assignment PIN_AG11  -to sys_ddr_dq[1]
set_location_assignment PIN_AF9   -to sys_ddr_dq[2]
set_location_assignment PIN_AG12  -to sys_ddr_dq[3]
set_location_assignment PIN_AG9   -to sys_ddr_dq[4]
set_location_assignment PIN_AF12  -to sys_ddr_dq[5]
set_location_assignment PIN_AJ10  -to sys_ddr_dq[6]
set_location_assignment PIN_AG10  -to sys_ddr_dq[7]
set_location_assignment PIN_AL9   -to sys_ddr_dq[8]
set_location_assignment PIN_AH9   -to sys_ddr_dq[9]
set_location_assignment PIN_AK6   -to sys_ddr_dq[10]
set_location_assignment PIN_AK7   -to sys_ddr_dq[11]
set_location_assignment PIN_AH8   -to sys_ddr_dq[12]
set_location_assignment PIN_AH7   -to sys_ddr_dq[13]
set_location_assignment PIN_AJ8   -to sys_ddr_dq[14]
set_location_assignment PIN_AE11  -to sys_ddr_dq[15]
set_location_assignment PIN_AT4   -to sys_ddr_dq[16]
set_location_assignment PIN_AM7   -to sys_ddr_dq[17]
set_location_assignment PIN_AP5   -to sys_ddr_dq[18]
set_location_assignment PIN_AL5   -to sys_ddr_dq[19]
set_location_assignment PIN_AM5   -to sys_ddr_dq[20]
set_location_assignment PIN_AM6   -to sys_ddr_dq[21]
set_location_assignment PIN_AM4   -to sys_ddr_dq[22]
set_location_assignment PIN_AR5   -to sys_ddr_dq[23]
set_location_assignment PIN_AP1   -to sys_ddr_dq[24]
set_location_assignment PIN_AR3   -to sys_ddr_dq[25]
set_location_assignment PIN_AN3   -to sys_ddr_dq[26]
set_location_assignment PIN_AR1   -to sys_ddr_dq[27]
set_location_assignment PIN_AU2   -to sys_ddr_dq[28]
set_location_assignment PIN_AP4   -to sys_ddr_dq[29]
set_location_assignment PIN_AR2   -to sys_ddr_dq[30]
set_location_assignment PIN_AU1   -to sys_ddr_dq[31]

set_location_assignment PIN_AF10  -to sys_ddr_dbi_n[0]
set_location_assignment PIN_AL8   -to sys_ddr_dbi_n[1]
set_location_assignment PIN_AN7   -to sys_ddr_dbi_n[2]
set_location_assignment PIN_AN4   -to sys_ddr_dbi_n[3]

set_location_assignment PIN_AW8   -to sys_ddr_rzq

