# a10soc carrier defaults
# clocks and resets

set_location_assignment PIN_AM10  -to sys_clk
set_location_assignment PIN_AL10  -to "sys_clk(n)"
set_location_assignment PIN_AV21  -to sys_resetn
set_instance_assignment -name IO_STANDARD LVDS -to sys_clk
set_instance_assignment -name IO_STANDARD LVDS -to "sys_clk(n)"
set_instance_assignment -name IO_STANDARD "1.8 V" -to sys_resetn
set_global_assignment -name PROGRAMMABLE_POWER_TECHNOLOGY_SETTING "FORCE ALL USED TILES TO HIGH SPEED"

# hps-ddr4 (32)

set_location_assignment PIN_F25   -to hps_ddr_ref_clk
set_location_assignment PIN_G24   -to "hps_ddr_ref_clk(n)"
set_location_assignment PIN_B20   -to hps_ddr_clk_p
set_location_assignment PIN_B19   -to hps_ddr_clk_n
set_location_assignment PIN_B26   -to hps_ddr_a[0]
set_location_assignment PIN_C26   -to hps_ddr_a[1]
set_location_assignment PIN_C22   -to hps_ddr_a[2]
set_location_assignment PIN_C21   -to hps_ddr_a[3]
set_location_assignment PIN_C25   -to hps_ddr_a[4]
set_location_assignment PIN_B24   -to hps_ddr_a[5]
set_location_assignment PIN_B22   -to hps_ddr_a[6]
set_location_assignment PIN_C23   -to hps_ddr_a[7]
set_location_assignment PIN_D23   -to hps_ddr_a[8]
set_location_assignment PIN_E23   -to hps_ddr_a[9]
set_location_assignment PIN_C24   -to hps_ddr_a[10]
set_location_assignment PIN_D24   -to hps_ddr_a[11]
set_location_assignment PIN_F26   -to hps_ddr_a[12]
set_location_assignment PIN_G26   -to hps_ddr_a[13]
set_location_assignment PIN_G25   -to hps_ddr_a[14]
set_location_assignment PIN_F24   -to hps_ddr_a[15]
set_location_assignment PIN_F23   -to hps_ddr_a[16]
set_location_assignment PIN_E25   -to hps_ddr_ba[0]
set_location_assignment PIN_H24   -to hps_ddr_ba[1]
set_location_assignment PIN_J24   -to hps_ddr_bg
set_location_assignment PIN_A24   -to hps_ddr_cke
set_location_assignment PIN_A22   -to hps_ddr_cs_n
set_location_assignment PIN_A26   -to hps_ddr_odt
set_location_assignment PIN_A19   -to hps_ddr_reset_n
set_location_assignment PIN_B21   -to hps_ddr_act_n
set_location_assignment PIN_A18   -to hps_ddr_par
set_location_assignment PIN_AG24  -to hps_ddr_alert_n
set_location_assignment PIN_AM25  -to hps_ddr_dqs_p[0]
set_location_assignment PIN_AL25  -to hps_ddr_dqs_n[0]
set_location_assignment PIN_AT25  -to hps_ddr_dqs_p[1]
set_location_assignment PIN_AT24  -to hps_ddr_dqs_n[1]
set_location_assignment PIN_AW26  -to hps_ddr_dqs_p[2]
set_location_assignment PIN_AW25  -to hps_ddr_dqs_n[2]
set_location_assignment PIN_AK25  -to hps_ddr_dqs_p[3]
set_location_assignment PIN_AJ25  -to hps_ddr_dqs_n[3]
set_location_assignment PIN_AP26  -to hps_ddr_dq[0]
set_location_assignment PIN_AN24  -to hps_ddr_dq[1]
set_location_assignment PIN_AN23  -to hps_ddr_dq[2]
set_location_assignment PIN_AM24  -to hps_ddr_dq[3]
set_location_assignment PIN_AK26  -to hps_ddr_dq[4]
set_location_assignment PIN_AL23  -to hps_ddr_dq[5]
set_location_assignment PIN_AL26  -to hps_ddr_dq[6]
set_location_assignment PIN_AK23  -to hps_ddr_dq[7]
set_location_assignment PIN_AP23  -to hps_ddr_dq[8]
set_location_assignment PIN_AT26  -to hps_ddr_dq[9]
set_location_assignment PIN_AR26  -to hps_ddr_dq[10]
set_location_assignment PIN_AR25  -to hps_ddr_dq[11]
set_location_assignment PIN_AT23  -to hps_ddr_dq[12]
set_location_assignment PIN_AP25  -to hps_ddr_dq[13]
set_location_assignment PIN_AU24  -to hps_ddr_dq[14]
set_location_assignment PIN_AU26  -to hps_ddr_dq[15]
set_location_assignment PIN_AU28  -to hps_ddr_dq[16]
set_location_assignment PIN_AU27  -to hps_ddr_dq[17]
set_location_assignment PIN_AV23  -to hps_ddr_dq[18]
set_location_assignment PIN_AW28  -to hps_ddr_dq[19]
set_location_assignment PIN_AV24  -to hps_ddr_dq[20]
set_location_assignment PIN_AW24  -to hps_ddr_dq[21]
set_location_assignment PIN_AV28  -to hps_ddr_dq[22]
set_location_assignment PIN_AV27  -to hps_ddr_dq[23]
set_location_assignment PIN_AH24  -to hps_ddr_dq[24]
set_location_assignment PIN_AH23  -to hps_ddr_dq[25]
set_location_assignment PIN_AG25  -to hps_ddr_dq[26]
set_location_assignment PIN_AF24  -to hps_ddr_dq[27]
set_location_assignment PIN_AF25  -to hps_ddr_dq[28]
set_location_assignment PIN_AJ24  -to hps_ddr_dq[29]
set_location_assignment PIN_AJ23  -to hps_ddr_dq[30]
set_location_assignment PIN_AJ26  -to hps_ddr_dq[31]
set_location_assignment PIN_AN26  -to hps_ddr_dbi_n[0]
set_location_assignment PIN_AU25  -to hps_ddr_dbi_n[1]
set_location_assignment PIN_AV26  -to hps_ddr_dbi_n[2]
set_location_assignment PIN_AH25  -to hps_ddr_dbi_n[3]
set_location_assignment PIN_E26   -to hps_ddr_rzq

# hps-ethernet

set_location_assignment PIN_F18   -to hps_eth_rxclk
set_location_assignment PIN_G17   -to hps_eth_rxctl
set_location_assignment PIN_G20   -to hps_eth_rxd[0]
set_location_assignment PIN_G21   -to hps_eth_rxd[1]
set_location_assignment PIN_F22   -to hps_eth_rxd[2]
set_location_assignment PIN_G22   -to hps_eth_rxd[3]
set_location_assignment PIN_H18   -to hps_eth_txclk
set_location_assignment PIN_H19   -to hps_eth_txctl
set_location_assignment PIN_E20   -to hps_eth_txd[0]
set_location_assignment PIN_F20   -to hps_eth_txd[1]
set_location_assignment PIN_F19   -to hps_eth_txd[2]
set_location_assignment PIN_G19   -to hps_eth_txd[3]
set_location_assignment PIN_K20   -to hps_eth_mdc
set_location_assignment PIN_K21   -to hps_eth_mdio

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_rxclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_rxctl
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_rxd[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_rxd[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_rxd[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_rxd[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_txclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_txctl
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_txd[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_txd[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_txd[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_txd[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_mdc
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_eth_mdio

set_instance_assignment -name OUTPUT_DELAY_CHAIN 8 -to hps_eth_txclk

# hps-sdio

set_location_assignment PIN_K16   -to hps_sdio_clk
set_location_assignment PIN_H16   -to hps_sdio_cmd
set_location_assignment PIN_E16   -to hps_sdio_d[0]
set_location_assignment PIN_G16   -to hps_sdio_d[1]
set_location_assignment PIN_H17   -to hps_sdio_d[2]
set_location_assignment PIN_F15   -to hps_sdio_d[3]
set_location_assignment PIN_M19   -to hps_sdio_d[4]
set_location_assignment PIN_E15   -to hps_sdio_d[5]
set_location_assignment PIN_J16   -to hps_sdio_d[6]
set_location_assignment PIN_L18   -to hps_sdio_d[7]

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_cmd
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[7]

set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_clk
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_cmd
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[3]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[4]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[5]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[6]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[7]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_clk
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_cmd
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[0]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[1]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[2]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[3]

# hps-usb

set_location_assignment PIN_D18   -to hps_usb_clk
set_location_assignment PIN_C19   -to hps_usb_dir
set_location_assignment PIN_F17   -to hps_usb_nxt
set_location_assignment PIN_E18   -to hps_usb_stp
set_location_assignment PIN_D19   -to hps_usb_d[0]
set_location_assignment PIN_E17   -to hps_usb_d[1]
set_location_assignment PIN_C17   -to hps_usb_d[2]
set_location_assignment PIN_C18   -to hps_usb_d[3]
set_location_assignment PIN_D21   -to hps_usb_d[4]
set_location_assignment PIN_D20   -to hps_usb_d[5]
set_location_assignment PIN_E21   -to hps_usb_d[6]
set_location_assignment PIN_E22   -to hps_usb_d[7]

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_dir
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_nxt
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_stp
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[7]

# hps-uart

set_location_assignment PIN_M17   -to hps_uart_tx
set_location_assignment PIN_K17   -to hps_uart_rx

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart_tx
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart_rx

# hps-i2c (shared w fmc-a, fmc-b)

set_location_assignment PIN_M20   -to hps_i2c_scl
set_location_assignment PIN_L20   -to hps_i2c_sda

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_scl
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_sda

# gpio (max-v-u21)

set_location_assignment PIN_AR23  -to gpio_bd_o[0]  ; ## led[0]
set_location_assignment PIN_AR22  -to gpio_bd_o[1]  ; ## led[1]
set_location_assignment PIN_AM21  -to gpio_bd_o[2]  ; ## led[2]
set_location_assignment PIN_AL20  -to gpio_bd_o[3]  ; ## led[3]
set_location_assignment PIN_P3    -to gpio_bd_i[0]  ; ## dipsw[0]
set_location_assignment PIN_P4    -to gpio_bd_i[1]  ; ## dipsw[1]
set_location_assignment PIN_P1    -to gpio_bd_i[2]  ; ## dipsw[2]
set_location_assignment PIN_R1    -to gpio_bd_i[3]  ; ## dipsw[3]
set_location_assignment PIN_R5    -to gpio_bd_i[4]  ; ## pb[0]
set_location_assignment PIN_T5    -to gpio_bd_i[5]  ; ## pb[1]
set_location_assignment PIN_P5    -to gpio_bd_i[6]  ; ## pb[2]
set_location_assignment PIN_P6    -to gpio_bd_i[7]  ; ## pb[3]

set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[7]

# hps-gpio (max-v-u16)

set_location_assignment PIN_J20   -to hps_gpio[0]
set_location_assignment PIN_N20   -to hps_gpio[1]
set_location_assignment PIN_K23   -to hps_gpio[2]
set_location_assignment PIN_L23   -to hps_gpio[3]

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[3]

