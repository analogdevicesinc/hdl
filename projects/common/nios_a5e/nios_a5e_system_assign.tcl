###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Agilex5e carrier defaults, NIOS-V variant (no HPS oscillator pin)
# clocks and resets

set_location_assignment PIN_BK109 -to sys_clk
set_location_assignment PIN_BR112 -to sys_resetn

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sys_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sys_resetn

# emif (fabric-side controller)

set_location_assignment PIN_H108 -to emif_mem_ck_t
set_location_assignment PIN_F108 -to emif_mem_ck_c
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to emif_mem_ck_t
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to emif_mem_ck_c

set_location_assignment PIN_AB117 -to emif_ref_clk
set_location_assignment PIN_Y117  -to "emif_ref_clk(n)"

set_location_assignment PIN_T114  -to emif_mem_a[0]
set_location_assignment PIN_P114  -to emif_mem_a[1]
set_location_assignment PIN_V117  -to emif_mem_a[2]
set_location_assignment PIN_T117  -to emif_mem_a[3]
set_location_assignment PIN_M114  -to emif_mem_a[4]
set_location_assignment PIN_K114  -to emif_mem_a[5]
set_location_assignment PIN_V108  -to emif_mem_a[6]
set_location_assignment PIN_T108  -to emif_mem_a[7]
set_location_assignment PIN_T105  -to emif_mem_a[8]
set_location_assignment PIN_P105  -to emif_mem_a[9]
set_location_assignment PIN_M105  -to emif_mem_a[10]
set_location_assignment PIN_K105  -to emif_mem_a[11]
set_location_assignment PIN_AG111 -to emif_mem_a[12]
set_location_assignment PIN_Y114  -to emif_mem_a[13]
set_location_assignment PIN_AB114 -to emif_mem_a[14]
set_location_assignment PIN_AK107 -to emif_mem_a[15]
set_location_assignment PIN_AK104 -to emif_mem_a[16]

for {set i 0} {$i < 17} {incr i} {
    set_instance_assignment -name IO_STANDARD "SSTL-12" -to emif_mem_a[$i]
}

set_location_assignment PIN_M117  -to emif_mem_act_n
set_location_assignment PIN_AB108 -to emif_mem_ba[0]
set_location_assignment PIN_Y105  -to emif_mem_ba[1]
set_location_assignment PIN_AB105 -to emif_mem_bg[0]
set_location_assignment PIN_F117  -to emif_mem_bg[1]
set_location_assignment PIN_F105  -to emif_mem_cke
set_location_assignment PIN_K117  -to emif_mem_cs_n
set_location_assignment PIN_F114  -to emif_mem_odt
set_location_assignment PIN_H117  -to emif_mem_reset_n
set_location_assignment PIN_K108  -to emif_mem_par
set_location_assignment PIN_Y108  -to emif_mem_alert_n

foreach signal {mem_act_n mem_ba[0] mem_ba[1] mem_bg[0] mem_bg[1] mem_cke mem_cs_n mem_odt mem_reset_n mem_par} {
    set_instance_assignment -name IO_STANDARD "SSTL-12" -to emif_$signal
}

set_location_assignment PIN_B122 -to emif_mem_dqs_t[0]
set_location_assignment PIN_AG90 -to emif_mem_dqs_t[1]
set_location_assignment PIN_K95  -to emif_mem_dqs_t[2]
set_location_assignment PIN_F95  -to emif_mem_dqs_t[3]
set_location_assignment PIN_A101 -to emif_mem_dqs_t[4]
set_location_assignment PIN_A125 -to emif_mem_dqs_c[0]
set_location_assignment PIN_AG93 -to emif_mem_dqs_c[1]
set_location_assignment PIN_M95  -to emif_mem_dqs_c[2]
set_location_assignment PIN_D95  -to emif_mem_dqs_c[3]
set_location_assignment PIN_B101 -to emif_mem_dqs_c[4]

for {set i 0} {$i < 5} {incr i} {
    set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to emif_mem_dqs_t[$i]
    set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to emif_mem_dqs_c[$i]
}

# Data bus
set_location_assignment PIN_B128  -to emif_mem_dq[0]
set_location_assignment PIN_B116  -to emif_mem_dq[1]
set_location_assignment PIN_A128  -to emif_mem_dq[2]
set_location_assignment PIN_A116  -to emif_mem_dq[3]
set_location_assignment PIN_A130  -to emif_mem_dq[4]
set_location_assignment PIN_B113  -to emif_mem_dq[5]
set_location_assignment PIN_B130  -to emif_mem_dq[6]
set_location_assignment PIN_A113  -to emif_mem_dq[7]
set_location_assignment PIN_AC100 -to emif_mem_dq[8]
set_location_assignment PIN_Y84   -to emif_mem_dq[9]
set_location_assignment PIN_Y95   -to emif_mem_dq[10]
set_location_assignment PIN_AC96  -to emif_mem_dq[11]
set_location_assignment PIN_AG100 -to emif_mem_dq[12]
set_location_assignment PIN_Y87   -to emif_mem_dq[13]
set_location_assignment PIN_Y98   -to emif_mem_dq[14]
set_location_assignment PIN_AG104 -to emif_mem_dq[15]
set_location_assignment PIN_T98   -to emif_mem_dq[16]
set_location_assignment PIN_M84   -to emif_mem_dq[17]
set_location_assignment PIN_P95   -to emif_mem_dq[18]
set_location_assignment PIN_T84   -to emif_mem_dq[19]
set_location_assignment PIN_V98   -to emif_mem_dq[20]
set_location_assignment PIN_P84   -to emif_mem_dq[21]
set_location_assignment PIN_T95   -to emif_mem_dq[22]
set_location_assignment PIN_K84   -to emif_mem_dq[23]
set_location_assignment PIN_K98   -to emif_mem_dq[24]
set_location_assignment PIN_K87   -to emif_mem_dq[25]
set_location_assignment PIN_H98   -to emif_mem_dq[26]
set_location_assignment PIN_M87   -to emif_mem_dq[27]
set_location_assignment PIN_M98   -to emif_mem_dq[28]
set_location_assignment PIN_D84   -to emif_mem_dq[29]
set_location_assignment PIN_F98   -to emif_mem_dq[30]
set_location_assignment PIN_F84   -to emif_mem_dq[31]
set_location_assignment PIN_B106  -to emif_mem_dq[32]
set_location_assignment PIN_A91   -to emif_mem_dq[33]
set_location_assignment PIN_A106  -to emif_mem_dq[34]
set_location_assignment PIN_A94   -to emif_mem_dq[35]
set_location_assignment PIN_A110  -to emif_mem_dq[36]
set_location_assignment PIN_B91   -to emif_mem_dq[37]
set_location_assignment PIN_B103  -to emif_mem_dq[38]
set_location_assignment PIN_B88   -to emif_mem_dq[39]

for {set i 0} {$i < 40} {incr i} {
    set_instance_assignment -name IO_STANDARD "1.2-V POD" -to emif_mem_dq[$i]
}

set_location_assignment PIN_AK111 -to emif_oct_rzqin
set_instance_assignment -name IO_STANDARD "1.2-V" -to emif_oct_rzqin

set_location_assignment PIN_B119 -to emif_mem_dbi_n[0]
set_location_assignment PIN_AC90 -to emif_mem_dbi_n[1]
set_location_assignment PIN_V87  -to emif_mem_dbi_n[2]
set_location_assignment PIN_H87  -to emif_mem_dbi_n[3]
set_location_assignment PIN_B97  -to emif_mem_dbi_n[4]

set_instance_assignment -name IO_STANDARD "1.2-V POD" -to emif_mem_dbi_n[0]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to emif_mem_dbi_n[1]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to emif_mem_dbi_n[2]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to emif_mem_dbi_n[3]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to emif_mem_dbi_n[4]

# NOTE: the HPS-attached pinout (sdmmc, i2c, usb3.1/usb31, uart, jtag, emac and
# the hps_gpio* pins) is intentionally absent - those pins belong to the hard
# processor and have no top-level ports on a NIOS-V design. The board LEDs,
# dipswitches and buttons below are fabric I/O and are kept.

# Gpio

set_location_assignment PIN_BM59 -to fpga_led[0]
set_location_assignment PIN_BH59 -to fpga_led[1]
set_location_assignment PIN_BH62 -to fpga_led[2]
set_location_assignment PIN_BK59 -to fpga_led[3]

set_instance_assignment -name IO_STANDARD "1.1 V" -to fpga_led[0]
set_instance_assignment -name IO_STANDARD "1.1 V" -to fpga_led[1]
set_instance_assignment -name IO_STANDARD "1.1 V" -to fpga_led[2]
set_instance_assignment -name IO_STANDARD "1.1 V" -to fpga_led[3]
set_instance_assignment -name SLEW_RATE 0 -to fpga_led[0]
set_instance_assignment -name SLEW_RATE 0 -to fpga_led[1]
set_instance_assignment -name SLEW_RATE 0 -to fpga_led[2]
set_instance_assignment -name SLEW_RATE 0 -to fpga_led[3]

set_location_assignment PIN_CH12 -to fpga_dipsw[0]
set_location_assignment PIN_BU22 -to fpga_dipsw[1]
set_location_assignment PIN_BW19 -to fpga_dipsw[2]
set_location_assignment PIN_BH28 -to fpga_dipsw[3]

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to fpga_dipsw[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to fpga_dipsw[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to fpga_dipsw[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to fpga_dipsw[3]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to fpga_dipsw[0]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to fpga_dipsw[1]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to fpga_dipsw[2]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to fpga_dipsw[3]

set_location_assignment PIN_BK31 -to fpga_btn[0]
set_location_assignment PIN_BP22 -to fpga_btn[1]
set_location_assignment PIN_BK28 -to fpga_btn[2]
set_location_assignment PIN_BR22 -to fpga_btn[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to fpga_btn[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to fpga_btn[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to fpga_btn[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to fpga_btn[3]


# Agilex development kit's global assignments

## QSPI is owned by the SDM here, not the HPS
set_global_assignment -name QSPI_OWNERSHIP SDM
set_global_assignment -name ENABLE_INTERMEDIATE_SNAPSHOTS ON
set_global_assignment -name USE_CONF_DONE SDM_IO12
set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHZ
set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
set_global_assignment -name USE_PWRMGT_SDA SDM_IO16
set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE OTHER
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 74
set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 75
set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
set_global_assignment -name STRATIX_JTAG_USER_CODE 4
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF

set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHz

# Workaround for Quartus 25.1 incomplete IO assignment becoming a critical warning
set_global_assignment -name MESSAGE_DISABLE 15714
