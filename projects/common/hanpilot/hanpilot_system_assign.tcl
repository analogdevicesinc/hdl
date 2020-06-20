# hanPilot carrier defaults

# clocks and resets
set_location_assignment PIN_AJ18  -to sys_clk
set_location_assignment PIN_AN18  -to sys_resetn
set_instance_assignment -name IO_STANDARD "1.8 V" -to sys_clk
set_instance_assignment -name GLOBAL_SIGNAL "GLOBAL CLOCK" -to sys_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to sys_resetn
set_global_assignment -name HPS_EARLY_IO_RELEASE ON
set_global_assignment -name PROGRAMMABLE_POWER_TECHNOLOGY_SETTING "FORCE ALL USED TILES TO HIGH SPEED"

set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files

set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"


# hps-ddr4 (32)

set_location_assignment PIN_M27   -to hps_ddr_ref_clk
set_location_assignment PIN_M26   -to "hps_ddr_ref_clk(n)"
set_location_assignment PIN_U26   -to hps_ddr_clk_p
set_location_assignment PIN_V26   -to hps_ddr_clk_n
set_location_assignment PIN_U27   -to hps_ddr_a[0]
set_location_assignment PIN_V27   -to hps_ddr_a[1]
set_location_assignment PIN_P28   -to hps_ddr_a[2]
set_location_assignment PIN_N27   -to hps_ddr_a[3]
set_location_assignment PIN_N26   -to hps_ddr_a[4]
set_location_assignment PIN_P26   -to hps_ddr_a[5]
set_location_assignment PIN_R26   -to hps_ddr_a[6]
set_location_assignment PIN_R25   -to hps_ddr_a[7]
set_location_assignment PIN_R28   -to hps_ddr_a[8]
set_location_assignment PIN_R27   -to hps_ddr_a[9]
set_location_assignment PIN_T25   -to hps_ddr_a[10]
set_location_assignment PIN_U25   -to hps_ddr_a[11]
set_location_assignment PIN_K26   -to hps_ddr_a[12]
set_location_assignment PIN_G29   -to hps_ddr_a[13]
set_location_assignment PIN_H28   -to hps_ddr_a[14]
set_location_assignment PIN_K28   -to hps_ddr_a[15]
set_location_assignment PIN_L28   -to hps_ddr_a[16]
set_location_assignment PIN_H27   -to hps_ddr_ba[0]
set_location_assignment PIN_E32   -to hps_ddr_ba[1]
set_location_assignment PIN_E31   -to hps_ddr_bg
#set_location_assignment PIN_W26 -to hps_ddr_bg[1] not used in this base... not sure why
set_location_assignment PIN_V28   -to hps_ddr_cke
set_location_assignment PIN_W25   -to hps_ddr_cs_n
set_location_assignment PIN_Y28   -to hps_ddr_odt
set_location_assignment PIN_Y26   -to hps_ddr_reset_n
set_location_assignment PIN_Y25   -to hps_ddr_act_n
set_location_assignment PIN_T27   -to hps_ddr_par
set_location_assignment PIN_A23  -to hps_ddr_alert_n
set_location_assignment PIN_A20  -to hps_ddr_dqs_p[0]
set_location_assignment PIN_B20  -to hps_ddr_dqs_n[0]
set_location_assignment PIN_B17  -to hps_ddr_dqs_p[1]
set_location_assignment PIN_C17  -to hps_ddr_dqs_n[1]
set_location_assignment PIN_L15  -to hps_ddr_dqs_p[2]
set_location_assignment PIN_M15  -to hps_ddr_dqs_n[2]
set_location_assignment PIN_F18  -to hps_ddr_dqs_p[3]
set_location_assignment PIN_F19  -to hps_ddr_dqs_n[3]
set_location_assignment PIN_C19  -to hps_ddr_dq[0]
set_location_assignment PIN_B21  -to hps_ddr_dq[1]
set_location_assignment PIN_C21  -to hps_ddr_dq[2]
set_location_assignment PIN_A22  -to hps_ddr_dq[3]
set_location_assignment PIN_D19  -to hps_ddr_dq[4]
set_location_assignment PIN_B19  -to hps_ddr_dq[5]
set_location_assignment PIN_G19  -to hps_ddr_dq[6]
set_location_assignment PIN_A19  -to hps_ddr_dq[7]
set_location_assignment PIN_C18  -to hps_ddr_dq[8]
set_location_assignment PIN_B16  -to hps_ddr_dq[9]
set_location_assignment PIN_D18  -to hps_ddr_dq[10]
set_location_assignment PIN_E17  -to hps_ddr_dq[11]
set_location_assignment PIN_A17  -to hps_ddr_dq[12]
set_location_assignment PIN_A15  -to hps_ddr_dq[13]
set_location_assignment PIN_A18  -to hps_ddr_dq[14]
set_location_assignment PIN_K17  -to hps_ddr_dq[15]
set_location_assignment PIN_J16  -to hps_ddr_dq[16]
set_location_assignment PIN_G16  -to hps_ddr_dq[17]
set_location_assignment PIN_H17  -to hps_ddr_dq[18]
set_location_assignment PIN_H16  -to hps_ddr_dq[19]
set_location_assignment PIN_J15  -to hps_ddr_dq[20]
set_location_assignment PIN_G15  -to hps_ddr_dq[21]
set_location_assignment PIN_K15  -to hps_ddr_dq[22]
set_location_assignment PIN_C16  -to hps_ddr_dq[23]
set_location_assignment PIN_F20  -to hps_ddr_dq[24]
set_location_assignment PIN_D21  -to hps_ddr_dq[25]
set_location_assignment PIN_F17  -to hps_ddr_dq[26]
set_location_assignment PIN_G20  -to hps_ddr_dq[27]
set_location_assignment PIN_E21  -to hps_ddr_dq[28]
set_location_assignment PIN_C22  -to hps_ddr_dq[29]
set_location_assignment PIN_G17  -to hps_ddr_dq[30]
set_location_assignment PIN_D20  -to hps_ddr_dq[31]
set_location_assignment PIN_H18  -to hps_ddr_dbi_n[0]
set_location_assignment PIN_E18  -to hps_ddr_dbi_n[1]
set_location_assignment PIN_D16  -to hps_ddr_dbi_n[2]
set_location_assignment PIN_E20  -to hps_ddr_dbi_n[3]
set_location_assignment PIN_J26   -to hps_ddr_rzq

set_instance_assignment -name IO_STANDARD LVDS -to hps_ddr_ref_clk
set_instance_assignment -name IO_STANDARD LVDS -to "hps_ddr_ref_clk(n)"

# hps-ethernet

set_location_assignment PIN_K22   -to hps_eth_rxclk
set_location_assignment PIN_L22   -to hps_eth_rxctl
set_location_assignment PIN_H23   -to hps_eth_rxd[0]
set_location_assignment PIN_J23   -to hps_eth_rxd[1]
set_location_assignment PIN_F24   -to hps_eth_rxd[2]
set_location_assignment PIN_G24   -to hps_eth_rxd[3]
set_location_assignment PIN_F25   -to hps_eth_txclk
set_location_assignment PIN_G25   -to hps_eth_txctl
set_location_assignment PIN_H24   -to hps_eth_txd[0]
set_location_assignment PIN_J24   -to hps_eth_txd[1]
set_location_assignment PIN_M22   -to hps_eth_txd[2]
set_location_assignment PIN_M21   -to hps_eth_txd[3]
set_location_assignment PIN_D24   -to hps_eth_mdc
set_location_assignment PIN_C24   -to hps_eth_mdio

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
#DIO 2, 1
set_location_assignment PIN_K18   -to hps_sdio_clk
set_location_assignment PIN_F22   -to hps_sdio_cmd
#DIO 0, 3, 4, 5 (SDCARD)
set_location_assignment PIN_J18   -to hps_sdio_d[0]
set_location_assignment PIN_E23   -to hps_sdio_d[1]
set_location_assignment PIN_G21   -to hps_sdio_d[2]
set_location_assignment PIN_H21   -to hps_sdio_d[3]
#DIO 6 to 7
# set_location_assignment PIN_H22   -to hps_sdio_d[4]
# set_location_assignment PIN_H19   -to hps_sdio_d[5]
# set_location_assignment PIN_F23   -to hps_sdio_d[6]
# set_location_assignment PIN_G22   -to hps_sdio_d[7]

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_cmd
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[3]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[4]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[5]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[6]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[7]

set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_clk
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_cmd
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[3]
# set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[4]
# set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[5]
# set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[6]
# set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[7]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_clk
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_cmd
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[0]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[1]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[2]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[3]

# hps-usb

set_location_assignment PIN_L25   -to hps_usb_clk
set_location_assignment PIN_J25   -to hps_usb_dir
set_location_assignment PIN_H26   -to hps_usb_nxt
set_location_assignment PIN_M25   -to hps_usb_stp
set_location_assignment PIN_K25   -to hps_usb_d[0]
set_location_assignment PIN_G26   -to hps_usb_d[1]
set_location_assignment PIN_E27   -to hps_usb_d[2]
set_location_assignment PIN_F27   -to hps_usb_d[3]
set_location_assignment PIN_L24   -to hps_usb_d[4]
set_location_assignment PIN_M24   -to hps_usb_d[5]
set_location_assignment PIN_K23   -to hps_usb_d[6]
set_location_assignment PIN_L23   -to hps_usb_d[7]

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
#DIO 12 to 13
set_location_assignment PIN_J19   -to hps_uart_tx
set_location_assignment PIN_L20   -to hps_uart_rx

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart_tx
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart_rx

#key and led
set_location_assignment PIN_A29 -to hps_key
set_location_assignment PIN_D29 -to hps_led

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_key
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_led

# hps-i2c
set_location_assignment PIN_B30   -to hps_i2c_scl
set_location_assignment PIN_A30   -to hps_i2c_sda

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_scl
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_sda

# fpga-i2c 
set_location_assignment PIN_M1   -to fpga_i2c_scl
set_location_assignment PIN_M4   -to fpga_i2c_sda

set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_i2c_scl
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_i2c_sda

# gpio

# leds

# set_location_assignment PIN_C26  -to gpio_bd_o[0]  ; ## led[0]
# set_location_assignment PIN_B24  -to gpio_bd_o[1]  ; ## led[1]

# 7 segment HEX 0
set_location_assignment PIN_AT32  -to gpio_bd_o[2]  ; ## HEX0sma_clkout_p
set_location_assignment PIN_AR32  -to gpio_bd_o[3]  ; ## HEX0
set_location_assignment PIN_AU32  -to gpio_bd_o[4]  ; ## HEX0
set_location_assignment PIN_AU30  -to gpio_bd_o[5]  ; ## HEX0
set_location_assignment PIN_AT30  -to gpio_bd_o[6]  ; ## HEX0
set_location_assignment PIN_AU29  -to gpio_bd_o[7]  ; ## HEX0
set_location_assignment PIN_AV29  -to gpio_bd_o[8]  ; ## HEX0
set_location_assignment PIN_AU31  -to gpio_bd_o[9]  ; ## HEX0

# 7 segment HEX 1
set_location_assignment PIN_AT28  -to gpio_bd_o[10]  ; ## HEX1
set_location_assignment PIN_AT29  -to gpio_bd_o[11]  ; ## HEX1
set_location_assignment PIN_AR30  -to gpio_bd_o[12]  ; ## HEX1
set_location_assignment PIN_AM27  -to gpio_bd_o[13]  ; ## HEX1
set_location_assignment PIN_AL27  -to gpio_bd_o[14]  ; ## HEX1
set_location_assignment PIN_AK27  -to gpio_bd_o[15]  ; ## HEX1
set_location_assignment PIN_AM26  -to gpio_bd_o[16]  ; ## HEX1
set_location_assignment PIN_AR31  -to gpio_bd_o[17]  ; ## HEX1

# dipswitches
set_location_assignment PIN_AJ19    -to gpio_bd_i[0]  ; ## dipsw[0]
set_location_assignment PIN_AV16    -to gpio_bd_i[1]  ; ## dipsw[1]

# push button
set_location_assignment PIN_AU15    -to gpio_bd_i[2]  ; ## pb[0]
set_location_assignment PIN_AT15    -to gpio_bd_i[3]  ; ## pb[1]

# ALERT lines
# set_location_assignment PIN_D25    -to pm_alert_n
# set_location_assignment PIN_E25    -to fan_alert_n

# MPU INT
set_location_assignment PIN_E26    -to mpu_int

# USBFX3, not tested
# set_location_assignment PIN_AU21    -to usbfx3_dq[0]
# set_location_assignment PIN_AW23    -to usbfx3_dq[1]
# set_location_assignment PIN_AW24    -to usbfx3_dq[2]
# set_location_assignment PIN_AW25    -to usbfx3_dq[3]
# set_location_assignment PIN_AW26    -to usbfx3_dq[4]
# set_location_assignment PIN_AV24    -to usbfx3_dq[5]
# set_location_assignment PIN_AW28    -to usbfx3_dq[6]
# set_location_assignment PIN_AW30    -to usbfx3_dq[7]
# set_location_assignment PIN_AW29    -to usbfx3_dq[8]
# set_location_assignment PIN_AV27    -to usbfx3_dq[9]
# set_location_assignment PIN_AV28    -to usbfx3_dq[10]
# set_location_assignment PIN_AU26    -to usbfx3_dq[11]
# set_location_assignment PIN_AV23    -to usbfx3_dq[12]
# set_location_assignment PIN_AU25    -to usbfx3_dq[13]
# set_location_assignment PIN_AR25    -to usbfx3_dq[14]
# set_location_assignment PIN_AP24    -to usbfx3_dq[15]
# set_location_assignment PIN_AL23    -to usbfx3_dq[16]
# set_location_assignment PIN_AM24    -to usbfx3_dq[17]
# set_location_assignment PIN_AK25    -to usbfx3_dq[18]
# set_location_assignment PIN_AM25    -to usbfx3_dq[19]
# set_location_assignment PIN_AT24    -to usbfx3_dq[20]
# set_location_assignment PIN_AR26    -to usbfx3_dq[21]
# set_location_assignment PIN_AP26    -to usbfx3_dq[22]
# set_location_assignment PIN_AP25    -to usbfx3_dq[23]
# set_location_assignment PIN_AN24    -to usbfx3_dq[24]
# set_location_assignment PIN_AN26    -to usbfx3_dq[25]
# set_location_assignment PIN_AK23    -to usbfx3_dq[26]
# set_location_assignment PIN_AJ25    -to usbfx3_dq[27]
# set_location_assignment PIN_AJ23    -to usbfx3_dq[28]
# set_location_assignment PIN_AH23    -to usbfx3_dq[29]
# set_location_assignment PIN_AR20    -to usbfx3_dq[30]
# set_location_assignment PIN_AP20    -to usbfx3_dq[31]
# set_location_assignment PIN_AV26    -to usbfx3_slcs_n
# set_location_assignment PIN_AT22    -to usbfx3_slwr_n
# set_location_assignment PIN_AT25    -to usbfx3_sloe_n
# set_location_assignment PIN_AR27    -to usbfx3_slrd_n
# set_location_assignment PIN_AN22    -to usbfx3_flag[0]
# set_location_assignment PIN_AN23    -to usbfx3_flag[1]
# set_location_assignment PIN_AL24    -to usbfx3_flag[2]
# set_location_assignment PIN_AL25    -to usbfx3_pktend_n
# set_location_assignment PIN_AV21    -to usbfx3_flag[3]
# set_location_assignment PIN_AV22    -to usbfx3_ctl9
# set_location_assignment PIN_AU24    -to usbfx3_ctl10
# set_location_assignment PIN_AU22    -to usbfx3_addr[1]
# set_location_assignment PIN_AT23    -to usbfx3_addr[0]
# set_location_assignment PIN_AW21    -to usbfx3_int_n
# set_location_assignment PIN_AJ24    -to usbfx3_reset_n
# set_location_assignment PIN_AT27    -to usbfx3_pclk
# set_location_assignment PIN_AP23    -to usbfx3_uart_tx
# set_location_assignment PIN_AU27    -to usbfx3_uart_rx
# set_location_assignment PIN_AG26    -to usbfx3_otg_id
# set_location_assignment PIN_AE25    -to usbfx3_path_sel_n
# set_location_assignment PIN_AF25    -to usbfx3_path_oe_n
# set_location_assignment PIN_AE27    -to usbfx3_host_dev_oe_n
# set_location_assignment PIN_AD26    -to usbfx3_host_dev_sel_n
# set_location_assignment PIN_AB31    -to usbfx3_refclk_p
# set_location_assignment PIN_AA37    -to usbfx3_rx_p
# set_location_assignment PIN_AB39    -to usbfx3_tx_p

# usb c display port
# copy -n- pasta from terasic
# set_location_assignment PIN_AC28 -to DP_AUX_SEL
# set_location_assignment PIN_AM22 -to DP_AUX_p
# set_location_assignment PIN_AB27 -to DP_DX_SEL
# set_location_assignment PIN_AM31 -to DP_REFCLK_p
# set_location_assignment PIN_AV35 -to DP_RX_p[0]
# set_location_assignment PIN_AT35 -to DP_RX_p[1]
# set_location_assignment PIN_AN33 -to DP_RX_p[2]
# set_location_assignment PIN_AP35 -to DP_RX_p[3]
# set_location_assignment PIN_AW37 -to DP_TX_p[0]
# set_location_assignment PIN_AV39 -to DP_TX_p[1]
# set_location_assignment PIN_AU37 -to DP_TX_p[2]
# set_location_assignment PIN_AT39 -to DP_TX_p[3]
# set_location_assignment PIN_AH27 -to I2C_INT
# set_location_assignment PIN_AD25 -to SRC_DP_HPD
# set_location_assignment PIN_AH26 -to TYPEC_5V_EN
# set_location_assignment PIN_AF27 -to TYPEC_PD_SCL
# set_location_assignment PIN_AE26 -to TYPEC_PD_SDA
# set_location_assignment PIN_AG25 -to TYPEC_PD_SLAVE_SCL
# set_location_assignment PIN_AH28 -to TYPEC_PD_SLAVE_SDA
# set_location_assignment PIN_A24 -to USB20_OE_n
# set_location_assignment PIN_C27 -to USB20_SW
# set_location_assignment PIN_AA27 -to USBDP_SW_CNF[0]
# set_location_assignment PIN_AB26 -to USBDP_SW_CNF[1]
# set_location_assignment PIN_AB25 -to USBDP_SW_CNF[2]

# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[0]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[1]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[2]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[3]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[4]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[5]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[6]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[7]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[8]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[9]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[10]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[11]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[12]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[13]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[14]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[15]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[16]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[17]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[18]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[19]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[20]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[21]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[22]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[23]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[24]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[25]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[26]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[27]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[28]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[29]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[30]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_dq[31]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_slcs_n
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_slwr_n
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_sloe_n
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_slrd_n
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_flag[0]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_flag[1]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_flag[2]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_flag[3]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_addr[0]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_addr[1]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_pktend_n
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_int_n
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_reset_n
# set_instance_assignment -name IO_STANDARD "1.8 V" -to usbfx3_pclk
# 
# set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[0]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[1]

set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[17]


set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[3]

# set_instance_assignment -name IO_STANDARD "1.8 V" -to pm_alert_n
# set_instance_assignment -name IO_STANDARD "1.8 V" -to fan_alert_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to mpu_int


# hps-gpio
#DIO 8 to 11
set_location_assignment PIN_D23   -to hps_gpio[0] ; ## DIO8
set_location_assignment PIN_C23   -to hps_gpio[1] ; ## DIO9
set_location_assignment PIN_F23   -to hps_gpio[2] ; ## DIO10
set_location_assignment PIN_G22   -to hps_gpio[3] ; ## DIO11
# set_location_assignment PIN_J19   -to hps_gpio[4] ; ## DIO12
# set_location_assignment PIN_L20   -to hps_gpio[5] ; ## DIO13

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[3]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[4]
# set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio[5]
