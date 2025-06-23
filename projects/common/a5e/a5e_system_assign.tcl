###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Agilex5e carrier defaults
# clocks and resets

set_location_assignment PIN_BK109 -to sys_clk
set_location_assignment PIN_N134  -to hps_osc_clk
set_location_assignment PIN_BR112 -to sys_resetn

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sys_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_osc_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sys_resetn

# hps-emif

set_location_assignment PIN_H108 -to emif_hps_mem_ck_t
set_location_assignment PIN_F108 -to emif_hps_mem_ck_c
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to emif_hps_mem_ck_t
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to emif_hps_mem_ck_c

set_location_assignment PIN_AB117 -to emif_hps_ref_clk
set_location_assignment PIN_Y117  -to "emif_hps_ref_clk(n)"

set_location_assignment PIN_T114  -to emif_hps_mem_a[0]
set_location_assignment PIN_P114  -to emif_hps_mem_a[1]
set_location_assignment PIN_V117  -to emif_hps_mem_a[2]
set_location_assignment PIN_T117  -to emif_hps_mem_a[3]
set_location_assignment PIN_M114  -to emif_hps_mem_a[4]
set_location_assignment PIN_K114  -to emif_hps_mem_a[5]
set_location_assignment PIN_V108  -to emif_hps_mem_a[6]
set_location_assignment PIN_T108  -to emif_hps_mem_a[7]
set_location_assignment PIN_T105  -to emif_hps_mem_a[8]
set_location_assignment PIN_P105  -to emif_hps_mem_a[9]
set_location_assignment PIN_M105  -to emif_hps_mem_a[10]
set_location_assignment PIN_K105  -to emif_hps_mem_a[11]
set_location_assignment PIN_AG111 -to emif_hps_mem_a[12]
set_location_assignment PIN_Y114  -to emif_hps_mem_a[13]
set_location_assignment PIN_AB114 -to emif_hps_mem_a[14]
set_location_assignment PIN_AK107 -to emif_hps_mem_a[15]
set_location_assignment PIN_AK104 -to emif_hps_mem_a[16]

for {set i 0} {$i < 17} {incr i} {
    set_instance_assignment -name IO_STANDARD "SSTL-12" -to emif_hps_mem_a[$i]
}

set_location_assignment PIN_M117  -to emif_hps_mem_act_n
set_location_assignment PIN_AB108 -to emif_hps_mem_ba[0]
set_location_assignment PIN_Y105  -to emif_hps_mem_ba[1]
set_location_assignment PIN_AB105 -to emif_hps_mem_bg[0]
set_location_assignment PIN_F117  -to emif_hps_mem_bg[1]
set_location_assignment PIN_F105  -to emif_hps_mem_cke
set_location_assignment PIN_K117  -to emif_hps_mem_cs_n
set_location_assignment PIN_F114  -to emif_hps_mem_odt
set_location_assignment PIN_H117  -to emif_hps_mem_reset_n
set_location_assignment PIN_K108  -to emif_hps_mem_par
set_location_assignment PIN_Y108  -to emif_hps_mem_alert_n

foreach signal {mem_act_n mem_ba[0] mem_ba[1] mem_bg[0] mem_bg[1] mem_cke mem_cs_n mem_odt mem_reset_n mem_par} {
    set_instance_assignment -name IO_STANDARD "SSTL-12" -to emif_hps_$signal
}

set_location_assignment PIN_AG90 -to emif_hps_mem_dqs_t[0]
set_location_assignment PIN_F95  -to emif_hps_mem_dqs_t[1]
set_location_assignment PIN_K95  -to emif_hps_mem_dqs_t[2]
set_location_assignment PIN_B122 -to emif_hps_mem_dqs_t[3]
set_location_assignment PIN_AG93 -to emif_hps_mem_dqs_c[0]
set_location_assignment PIN_D95  -to emif_hps_mem_dqs_c[1]
set_location_assignment PIN_M95  -to emif_hps_mem_dqs_c[2]
set_location_assignment PIN_A125 -to emif_hps_mem_dqs_c[3]

foreach i {0 1 2 3} {
    set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to emif_hps_mem_dqs_t[$i]
    set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to emif_hps_mem_dqs_c[$i]
}

# Data bus
set_location_assignment PIN_Y84   -to emif_hps_mem_dq[0]
set_location_assignment PIN_AG104 -to emif_hps_mem_dq[1]
set_location_assignment PIN_AC100 -to emif_hps_mem_dq[2]
set_location_assignment PIN_AC96  -to emif_hps_mem_dq[3]
set_location_assignment PIN_Y98   -to emif_hps_mem_dq[4]
set_location_assignment PIN_Y95   -to emif_hps_mem_dq[5]
set_location_assignment PIN_Y87   -to emif_hps_mem_dq[6]
set_location_assignment PIN_AG100 -to emif_hps_mem_dq[7]
set_location_assignment PIN_D84   -to emif_hps_mem_dq[8]
set_location_assignment PIN_F84   -to emif_hps_mem_dq[9]
set_location_assignment PIN_M87   -to emif_hps_mem_dq[10]
set_location_assignment PIN_K87   -to emif_hps_mem_dq[11]
set_location_assignment PIN_K98   -to emif_hps_mem_dq[12]
set_location_assignment PIN_M98   -to emif_hps_mem_dq[13]
set_location_assignment PIN_F98   -to emif_hps_mem_dq[14]
set_location_assignment PIN_H98   -to emif_hps_mem_dq[15]
set_location_assignment PIN_K84   -to emif_hps_mem_dq[16]
set_location_assignment PIN_M84   -to emif_hps_mem_dq[17]
set_location_assignment PIN_T84   -to emif_hps_mem_dq[18]
set_location_assignment PIN_P84   -to emif_hps_mem_dq[19]
set_location_assignment PIN_V98   -to emif_hps_mem_dq[20]
set_location_assignment PIN_T98   -to emif_hps_mem_dq[21]
set_location_assignment PIN_P95   -to emif_hps_mem_dq[22]
set_location_assignment PIN_T95   -to emif_hps_mem_dq[23]
set_location_assignment PIN_A128  -to emif_hps_mem_dq[24]
set_location_assignment PIN_B130  -to emif_hps_mem_dq[25]
set_location_assignment PIN_A130  -to emif_hps_mem_dq[26]
set_location_assignment PIN_B116  -to emif_hps_mem_dq[27]
set_location_assignment PIN_A116  -to emif_hps_mem_dq[28]
set_location_assignment PIN_B113  -to emif_hps_mem_dq[29]
set_location_assignment PIN_A113  -to emif_hps_mem_dq[30]
set_location_assignment PIN_B128  -to emif_hps_mem_dq[31]

for {set i 0} {$i < 32} {incr i} {
    set_instance_assignment -name IO_STANDARD "1.2-V POD" -to emif_hps_mem_dq[$i]
}

set_location_assignment PIN_AK111 -to emif_hps_oct_rzqin
set_instance_assignment -name IO_STANDARD "1.2-V" -to emif_hps_oct_rzqin

# hps-sdmmc

set_location_assignment PIN_AB132 -to hps_sdmmc_cmd
set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_sdmmc_cmd
set_location_assignment PIN_E135 -to hps_sdmmc_d[0]
set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_sdmmc_d[0]
set_location_assignment PIN_F132 -to hps_sdmmc_d[1]
set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_sdmmc_d[1]
set_location_assignment PIN_AA135 -to hps_sdmmc_d[2]
set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_sdmmc_d[2]
set_location_assignment PIN_V127 -to hps_sdmmc_d[3]
set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_sdmmc_d[3]
set_location_assignment PIN_D132 -to hps_sdmmc_clk
set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_sdmmc_clk

# i2c

set_location_assignment PIN_N135 -to hps_i2c_sda
set_location_assignment PIN_AK120 -to hps_i2c_scl

set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_i2c_sda
set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_i2c_scl

# usb3.1

set_location_assignment PIN_AP120 -to usb31_phy_refclk_p
set_location_assignment PIN_AP115 -to "usb31_phy_refclk_p(n)"
set_location_assignment PIN_CF121 -to usb31_io_vbus_det
set_location_assignment PIN_CG135 -to usb31_io_flt_bar
set_location_assignment PIN_CF118 -to usb31_io_usb31_id
set_location_assignment PIN_CL128 -to usb31_io_usb_ctrl
set_location_assignment PIN_AM135 -to usb31_phy_rx_serial_p
set_location_assignment PIN_AM133 -to usb31_phy_rx_serial_n
set_location_assignment PIN_AN129 -to usb31_phy_tx_serial_p
set_location_assignment PIN_AN126 -to usb31_phy_tx_serial_n

set_instance_assignment -name IO_STANDARD "CURRENT MODE LOGIC (CML)" -to usb31_phy_refclk_p
set_instance_assignment -name IO_STANDARD "CURRENT MODE LOGIC (CML)" -to "usb31_phy_refclk_p(n)"

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to usb31_io_vbus_det
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to usb31_io_flt_bar
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to usb31_io_usb31_id
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to usb31_io_usb_ctrl

set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to usb31_phy_rx_serial_p
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to usb31_phy_rx_serial_n
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to usb31_phy_tx_serial_p
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to usb31_phy_tx_serial_n

# hps-usb

set_location_assignment PIN_P132  -to hps_usb_clk
set_location_assignment PIN_L135  -to hps_usb_stp
set_location_assignment PIN_J135  -to hps_usb_dir
set_location_assignment PIN_AD134 -to hps_usb_nxt
set_location_assignment PIN_AD135 -to hps_usb_d[0]
set_location_assignment PIN_M132  -to hps_usb_d[1]
set_location_assignment PIN_K132  -to hps_usb_d[2]
set_location_assignment PIN_AG129 -to hps_usb_d[3]
set_location_assignment PIN_J134  -to hps_usb_d[4]
set_location_assignment PIN_AG120 -to hps_usb_d[5]
set_location_assignment PIN_G134  -to hps_usb_d[6]
set_location_assignment PIN_G135  -to hps_usb_d[7]

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_stp
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_dir
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_nxt
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_stp
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_clk
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_dir
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_nxt

for {set i 0} {$i < 8} {incr i} {
    set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[$i]
    set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_d[$i]
    set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_d[$i]
}

# hps-uart

set_location_assignment PIN_W134  -to hps_uart_tx
set_location_assignment PIN_AK115 -to hps_uart_rx

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart_tx
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart_rx
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_uart_tx
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_uart_rx

# hps-jtag

set_location_assignment PIN_T124 -to hps_jtag_tdo
set_location_assignment PIN_Y132 -to hps_jtag_tms
set_location_assignment PIN_P124 -to hps_jtag_tdi
set_location_assignment PIN_T127 -to hps_jtag_tck

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tck
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tms
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tdo
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tdi
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_jtag_tdo
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tck
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tms
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tdi

# hps-emac

set_location_assignment PIN_M124  -to hps_emac_rxclk
set_location_assignment PIN_AB127 -to hps_emac_rxctl
set_location_assignment PIN_H127  -to hps_emac_rxd[0]
set_location_assignment PIN_AB124 -to hps_emac_rxd[1]
set_location_assignment PIN_F124  -to hps_emac_rxd[2]
set_location_assignment PIN_D124  -to hps_emac_rxd[3]
set_location_assignment PIN_M127  -to hps_emac_txclk
set_location_assignment PIN_K127  -to hps_emac_txctl
set_location_assignment PIN_K124  -to hps_emac_txd[0]
set_location_assignment PIN_Y127  -to hps_emac_txd[1]
set_location_assignment PIN_F127  -to hps_emac_txd[2]
set_location_assignment PIN_Y124  -to hps_emac_txd[3]
set_location_assignment PIN_U134  -to hps_emac_pps
set_location_assignment PIN_AL120 -to hps_emac_pps_trig
set_location_assignment PIN_AG115 -to hps_emac_mdc
set_location_assignment PIN_R134  -to hps_emac_mdio

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txctl
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxctl
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxd[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txd[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxd[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txd[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxd[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txd[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxd[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txd[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_mdio
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_mdc
set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_emac_pps
set_instance_assignment -name IO_STANDARD "1.8-V" -to hps_emac_pps_trig

set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac_txclk
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac_mdio
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac_mdc
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txctl
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txd[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txd[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txd[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txd[3]

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxclk
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxctl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxd[0]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxd[1]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxd[2]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxd[3]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_mdio

set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_emac_mdio

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

set_location_assignment PIN_W135  -to hps_gpio0_io0
set_location_assignment PIN_U135  -to hps_gpio0_io1
set_location_assignment PIN_AG123 -to hps_gpio1_io3
set_location_assignment PIN_B134  -to hps_gpio1_io4
set_location_assignment PIN_T132  -to hps_gpio0_io11

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio0_io0
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio0_io1
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio1_io3
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio1_io4
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio0_io11
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio0_io0
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio0_io1
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio1_io3
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio1_io4
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio0_io11
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio0_io0
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio0_io1
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio0_io11

# Agilex development kit's global assignments

set_global_assignment -name HPS_INITIALIZATION "HPS FIRST"
set_global_assignment -name HPS_DAP_SPLIT_MODE "SDM PINS"

set_global_assignment -name HPS_DAP_NO_CERTIFICATE on
set_global_assignment -name QSPI_OWNERSHIP HPS
set_global_assignment -name ENABLE_INTERMEDIATE_SNAPSHOTS ON
set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
set_global_assignment -name USE_HPS_COLD_RESET SDM_IO11
set_global_assignment -name USE_PWRMGT_SDA SDM_IO16
set_global_assignment -name USE_CONF_DONE SDM_IO12
set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE OTHER
set_global_assignment -name NUMBER_OF_SLAVE_DEVICE 2
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 74
set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 75
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
set_global_assignment -name STRATIX_JTAG_USER_CODE 4
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
set_global_assignment -name POWER_DEFAULT_TOGGLE_RATE 20%
set_global_assignment -name POWER_DEFAULT_INPUT_IO_TOGGLE_RATE 20%

set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHz
