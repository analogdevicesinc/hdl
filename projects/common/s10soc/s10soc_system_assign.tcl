# stratix10soc carrier defaults

# clocks and resets

set_location_assignment PIN_AW10                  -to sys_clk        ; ## 100 MHz
set_location_assignment PIN_BC15                  -to fpga_resetn
set_instance_assignment -name IO_STANDARD "1.8 V" -to sys_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to fpga_resetn

## 25 MHz on OOBE Daughter Card

set_location_assignment PIN_B29   -to hps_ref_clk
set_instance_assignment -name IO_STANDARD "1.8V"  -to hps_ref_clk

# fpga-gpio motherboard (led/dpsw/button)

set_location_assignment	PIN_A24	                      -to fpga_gpio_led[0]
set_location_assignment	PIN_F22	                      -to fpga_gpio_led[1]
set_location_assignment	PIN_B24	                      -to fpga_gpio_led[2]
set_location_assignment	PIN_E22	                      -to fpga_gpio_led[3]

set_instance_assignment	-name	IO_STANDARD	"1.8 V"     -to fpga_gpio_led[0]
set_instance_assignment	-name	IO_STANDARD	"1.8 V"	    -to fpga_gpio_led[1]
set_instance_assignment	-name	IO_STANDARD	"1.8 V"	    -to fpga_gpio_led[2]
set_instance_assignment	-name	IO_STANDARD	"1.8 V"	    -to fpga_gpio_led[3]

set_location_assignment	PIN_B23		                    -to fpga_gpio_dpsw[0]
set_location_assignment	PIN_C23		                    -to fpga_gpio_dpsw[1]
set_location_assignment	PIN_E23		                    -to fpga_gpio_dpsw[2]
set_location_assignment	PIN_E24		                    -to fpga_gpio_dpsw[3]

set_instance_assignment	-name	IO_STANDARD	"1.8 V"	    -to fpga_gpio_dpsw[0]
set_instance_assignment	-name	IO_STANDARD	"1.8 V"	    -to fpga_gpio_dpsw[1]
set_instance_assignment	-name	IO_STANDARD	"1.8 V"	    -to fpga_gpio_dpsw[2]
set_instance_assignment	-name	IO_STANDARD	"1.8 V"	    -to fpga_gpio_dpsw[3]

set_location_assignment	PIN_A26		                    -to fpga_gpio_btn[0]
set_location_assignment	PIN_A25		                    -to fpga_gpio_btn[1]
set_location_assignment	PIN_D23		                    -to fpga_gpio_btn[2]
set_location_assignment	PIN_D24		                    -to fpga_gpio_btn[3]

set_instance_assignment	-name IO_STANDARD	"1.8 V"	    -to fpga_gpio_btn[0]
set_instance_assignment	-name IO_STANDARD	"1.8 V"	    -to fpga_gpio_btn[1]
set_instance_assignment	-name IO_STANDARD	"1.8 V"	    -to fpga_gpio_btn[2]
set_instance_assignment	-name IO_STANDARD	"1.8 V"	    -to fpga_gpio_btn[3]

# hps-emac OOBE daughter card

set_location_assignment PIN_G28                       -to hps_emac_rx_clk
set_location_assignment PIN_F30                       -to hps_emac_rx_ctl
set_location_assignment PIN_F31                       -to hps_emac_tx_clk
set_location_assignment PIN_R29                       -to hps_emac_tx_ctl
set_location_assignment PIN_B34                       -to hps_emac_rx[0]
set_location_assignment PIN_E31                       -to hps_emac_rx[1]
set_location_assignment PIN_G29                       -to hps_emac_rx[2]
set_location_assignment PIN_H28                       -to hps_emac_rx[3]
set_location_assignment PIN_J28                       -to hps_emac_tx[0]
set_location_assignment PIN_E28                       -to hps_emac_tx[1]
set_location_assignment PIN_P29                       -to hps_emac_tx[2]
set_location_assignment PIN_B32                       -to hps_emac_tx[3]
set_location_assignment PIN_B28                       -to hps_emac_mdc
set_location_assignment PIN_K31                       -to hps_emac_mdio

set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_rx_clk
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_rx_ctl
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_tx_clk
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_tx_ctl
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_rx[0]
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_rx[1]
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_rx[2]
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_rx[3]
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_tx[0]
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_tx[1]
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_tx[2]
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_tx[3]
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_mdc
set_instance_assignment -name IO_STANDARD "1.8 V"     -to hps_emac_mdio

set_instance_assignment -name CURRENT_STRENGTH "4ma"  -to hps_emac_tx_clk
set_instance_assignment -name CURRENT_STRENGTH "8ma"  -to hps_emac_tx_ctl
set_instance_assignment -name CURRENT_STRENGTH "8ma"  -to hps_emac_tx[0]
set_instance_assignment -name CURRENT_STRENGTH "8ma"  -to hps_emac_tx[1]
set_instance_assignment -name CURRENT_STRENGTH "8ma"  -to hps_emac_tx[2]
set_instance_assignment -name CURRENT_STRENGTH "8ma"  -to hps_emac_tx[3]
set_instance_assignment -name CURRENT_STRENGTH "4ma"  -to hps_emac_mdc
set_instance_assignment -name CURRENT_STRENGTH "4ma"  -to hps_emac_mdio

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON  -to hps_emac_rx_clk
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON  -to hps_emac_rx_ctl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON  -to hps_emac_tx_clk
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON  -to hps_emac_tx_ctl

# hps-ddr4 mother board

set_location_assignment	PIN_M35 -to	hps_ddr_ref_clk
set_location_assignment	PIN_N35 -to	"hps_ddr_ref_clk(n)"
set_location_assignment	PIN_P34 -to	hps_ddr_rzq
set_location_assignment PIN_K38	-to hps_ddr_a[0]
set_location_assignment PIN_L37 -to hps_ddr_a[1]
set_location_assignment PIN_M37 -to hps_ddr_a[2]
set_location_assignment PIN_M38 -to hps_ddr_a[3]
set_location_assignment PIN_J39 -to hps_ddr_a[4]
set_location_assignment PIN_J38 -to hps_ddr_a[5]
set_location_assignment PIN_K39 -to hps_ddr_a[6]
set_location_assignment PIN_L39 -to hps_ddr_a[7]
set_location_assignment PIN_P37 -to hps_ddr_a[8]
set_location_assignment PIN_R37 -to hps_ddr_a[9]
set_location_assignment PIN_N37 -to hps_ddr_a[10]
set_location_assignment PIN_P38 -to hps_ddr_a[11]
set_location_assignment PIN_P35 -to hps_ddr_a[12]
set_location_assignment PIN_K36 -to hps_ddr_a[13]
set_location_assignment PIN_K37 -to hps_ddr_a[14]
set_location_assignment PIN_N36 -to hps_ddr_a[15]
set_location_assignment PIN_P36 -to hps_ddr_a[16]
set_location_assignment PIN_H38 -to hps_ddr_act_n[0]
set_location_assignment PIN_A38 -to hps_ddr_alert_n[0]
set_location_assignment PIN_L36 -to hps_ddr_ba[0]
set_location_assignment PIN_T35 -to hps_ddr_ba[1]
set_location_assignment PIN_R36 -to hps_ddr_bg[0]
set_location_assignment PIN_F39 -to hps_ddr_ck[0]
set_location_assignment PIN_G39 -to hps_ddr_ck_n[0]
set_location_assignment PIN_L40 -to hps_ddr_cke[0]
set_location_assignment PIN_G38 -to hps_ddr_cs_n[0]
set_location_assignment PIN_G40 -to hps_ddr_odt[0]
set_location_assignment PIN_H40 -to hps_ddr_par[0]
set_location_assignment PIN_E40 -to hps_ddr_reset_n[0]
set_location_assignment PIN_A36 -to hps_ddr_dqs_p[0]
set_location_assignment PIN_E36 -to hps_ddr_dqs_p[1]
set_location_assignment PIN_G33 -to hps_ddr_dqs_p[2]
set_location_assignment PIN_L32 -to hps_ddr_dqs_p[3]
set_location_assignment PIN_T26 -to hps_ddr_dqs_p[4]
set_location_assignment PIN_V28 -to hps_ddr_dqs_p[5]
set_location_assignment PIN_J26 -to hps_ddr_dqs_p[6]
set_location_assignment PIN_E26 -to hps_ddr_dqs_p[7]
set_location_assignment PIN_R32 -to hps_ddr_dqs_p[8]
set_location_assignment PIN_A35 -to hps_ddr_dqs_n[0]
set_location_assignment PIN_F36 -to hps_ddr_dqs_n[1]
set_location_assignment PIN_G34 -to hps_ddr_dqs_n[2]
set_location_assignment PIN_L31 -to hps_ddr_dqs_n[3]
set_location_assignment PIN_R27 -to hps_ddr_dqs_n[4]
set_location_assignment PIN_V27 -to hps_ddr_dqs_n[5]
set_location_assignment PIN_K26 -to hps_ddr_dqs_n[6]
set_location_assignment PIN_F26 -to hps_ddr_dqs_n[7]
set_location_assignment PIN_T32 -to hps_ddr_dqs_n[8]
set_location_assignment PIN_C36 -to hps_ddr_dbi_n[0]
set_location_assignment PIN_D39 -to hps_ddr_dbi_n[1]
set_location_assignment PIN_F34 -to hps_ddr_dbi_n[2]
set_location_assignment PIN_J34 -to hps_ddr_dbi_n[3]
set_location_assignment PIN_N25 -to hps_ddr_dbi_n[4]
set_location_assignment PIN_V30 -to hps_ddr_dbi_n[5]
set_location_assignment PIN_L26 -to hps_ddr_dbi_n[6]
set_location_assignment PIN_E27 -to hps_ddr_dbi_n[7]
set_location_assignment PIN_U34 -to hps_ddr_dbi_n[8]
set_location_assignment PIN_A37 -to hps_ddr_dq[0]
set_location_assignment PIN_B35 -to hps_ddr_dq[1]
set_location_assignment PIN_D36 -to hps_ddr_dq[2]
set_location_assignment PIN_B37 -to hps_ddr_dq[3]
set_location_assignment PIN_B38 -to hps_ddr_dq[4]
set_location_assignment PIN_C35 -to hps_ddr_dq[5]
set_location_assignment PIN_C38 -to hps_ddr_dq[6]
set_location_assignment PIN_C37 -to hps_ddr_dq[7]
set_location_assignment PIN_H37 -to hps_ddr_dq[8]
set_location_assignment PIN_E39 -to hps_ddr_dq[9]
set_location_assignment PIN_F37 -to hps_ddr_dq[10]
set_location_assignment PIN_E38 -to hps_ddr_dq[11]
set_location_assignment PIN_D38 -to hps_ddr_dq[12]
set_location_assignment PIN_D34 -to hps_ddr_dq[13]
set_location_assignment PIN_D35 -to hps_ddr_dq[14]
set_location_assignment PIN_E37 -to hps_ddr_dq[15]
set_location_assignment PIN_H33 -to hps_ddr_dq[16]
set_location_assignment PIN_E34 -to hps_ddr_dq[17]
set_location_assignment PIN_F35 -to hps_ddr_dq[18]
set_location_assignment PIN_J36 -to hps_ddr_dq[19]
set_location_assignment PIN_G35 -to hps_ddr_dq[20]
set_location_assignment PIN_J35 -to hps_ddr_dq[21]
set_location_assignment PIN_H35 -to hps_ddr_dq[22]
set_location_assignment PIN_H36 -to hps_ddr_dq[23]
set_location_assignment PIN_K33 -to hps_ddr_dq[24]
set_location_assignment PIN_K34 -to hps_ddr_dq[25]
set_location_assignment PIN_M33 -to hps_ddr_dq[26]
set_location_assignment PIN_N32 -to hps_ddr_dq[27]
set_location_assignment PIN_K32 -to hps_ddr_dq[28]
set_location_assignment PIN_N33 -to hps_ddr_dq[29]
set_location_assignment PIN_N31 -to hps_ddr_dq[30]
set_location_assignment PIN_M34 -to hps_ddr_dq[31]
set_location_assignment PIN_U25 -to hps_ddr_dq[32]
set_location_assignment PIN_T25 -to hps_ddr_dq[33]
set_location_assignment PIN_P25 -to hps_ddr_dq[34]
set_location_assignment PIN_N27 -to hps_ddr_dq[35]
set_location_assignment PIN_L25 -to hps_ddr_dq[36]
set_location_assignment PIN_R26 -to hps_ddr_dq[37]
set_location_assignment PIN_P26 -to hps_ddr_dq[38]
set_location_assignment PIN_M25 -to hps_ddr_dq[39]
set_location_assignment PIN_U30 -to hps_ddr_dq[40]
set_location_assignment PIN_T30 -to hps_ddr_dq[41]
set_location_assignment PIN_T29 -to hps_ddr_dq[42]
set_location_assignment PIN_U28 -to hps_ddr_dq[43]
set_location_assignment PIN_V25 -to hps_ddr_dq[44]
set_location_assignment PIN_U27 -to hps_ddr_dq[45]
set_location_assignment PIN_V26 -to hps_ddr_dq[46]
set_location_assignment PIN_U29 -to hps_ddr_dq[47]
set_location_assignment PIN_M27 -to hps_ddr_dq[48]
set_location_assignment PIN_L27 -to hps_ddr_dq[49]
set_location_assignment PIN_G25 -to hps_ddr_dq[50]
set_location_assignment PIN_H25 -to hps_ddr_dq[51]
set_location_assignment PIN_H27 -to hps_ddr_dq[52]
set_location_assignment PIN_K27 -to hps_ddr_dq[53]
set_location_assignment PIN_H26 -to hps_ddr_dq[54]
set_location_assignment PIN_F25 -to hps_ddr_dq[55]
set_location_assignment PIN_G27 -to hps_ddr_dq[56]
set_location_assignment PIN_C27 -to hps_ddr_dq[57]
set_location_assignment PIN_B27 -to hps_ddr_dq[58]
set_location_assignment PIN_F27 -to hps_ddr_dq[59]
set_location_assignment PIN_C26 -to hps_ddr_dq[60]
set_location_assignment PIN_B25 -to hps_ddr_dq[61]
set_location_assignment PIN_D26 -to hps_ddr_dq[62]
set_location_assignment PIN_D25 -to hps_ddr_dq[63]
set_location_assignment PIN_T34 -to hps_ddr_dq[64]
set_location_assignment PIN_R31 -to hps_ddr_dq[65]
set_location_assignment PIN_U33 -to hps_ddr_dq[66]
set_location_assignment PIN_T31 -to hps_ddr_dq[67]
set_location_assignment PIN_R34 -to hps_ddr_dq[68]
set_location_assignment PIN_U32 -to hps_ddr_dq[69]
set_location_assignment PIN_V32 -to hps_ddr_dq[70]
set_location_assignment PIN_P33 -to hps_ddr_dq[71]

# hps-usb0 OOBE daughter card

set_location_assignment PIN_E29 -to hps_usb_clk
set_location_assignment PIN_A30 -to hps_usb_data[0]
set_location_assignment PIN_C32 -to hps_usb_data[1]
set_location_assignment PIN_A29 -to hps_usb_data[2]
set_location_assignment PIN_E33 -to hps_usb_data[3]
set_location_assignment PIN_F29 -to hps_usb_data[4]
set_location_assignment PIN_E32 -to hps_usb_data[5]
set_location_assignment PIN_B30 -to hps_usb_data[6]
set_location_assignment PIN_D29 -to hps_usb_data[7]
set_location_assignment PIN_D30 -to hps_usb_dir
set_location_assignment PIN_A27 -to hps_usb_nxt
set_location_assignment PIN_C33 -to hps_usb_stp

set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_clk
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_data[0]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_data[1]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_data[2]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_data[3]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_data[4]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_data[5]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_data[6]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_data[7]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_dir
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_nxt
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_usb_stp

set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_usb_data[0]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_usb_data[1]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_usb_data[2]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_usb_data[3]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_usb_data[4]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_usb_data[5]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_usb_data[6]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_usb_data[7]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_usb_stp

# hps-sdmmc OOBE daughter card

set_location_assignment PIN_A31 -to hps_sdmmc_clk
set_location_assignment PIN_J30 -to hps_sdmmc_cmd
set_location_assignment PIN_P30 -to hps_sdmmc_data[0]
set_location_assignment PIN_H30 -to hps_sdmmc_data[1]
set_location_assignment PIN_D31 -to hps_sdmmc_data[2]
set_location_assignment PIN_H32 -to hps_sdmmc_data[3]

set_instance_assignment -name IO_STANDARD "1.8V" -to hps_sdmmc_clk
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_sdmmc_cmd
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_sdmmc_data[0]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_sdmmc_data[1]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_sdmmc_data[2]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_sdmmc_data[3]

set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_sdmmc_clk
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_sdmmc_cmd
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_sdmmc_data[0]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_sdmmc_data[1]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_sdmmc_data[2]
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_sdmmc_data[3]

# hps-uart0 OOBE daughter card

set_location_assignment PIN_K29 -to hps_uart_rx
set_location_assignment PIN_F32 -to hps_uart_tx

set_instance_assignment -name IO_STANDARD "1.8V" -to hps_uart_rx
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_uart_tx
set_instance_assignment -name CURRENT_STRENGTH "8ma" -to hps_uart_tx

# hps-gpio OOBE daughter card

set_location_assignment PIN_G30 -to hps_gpio_eth_irq
set_location_assignment PIN_C28 -to hps_gpio_usb_oci
set_location_assignment PIN_A34 -to hps_gpio_btn[0]
set_location_assignment PIN_N30 -to hps_gpio_btn[1]
set_location_assignment PIN_D33 -to hps_gpio_led[0]
set_location_assignment PIN_J31 -to hps_gpio_led[1]
set_location_assignment PIN_D28 -to hps_gpio_led[2]

set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_eth_irq
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_usb_oci
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_btn[0]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_btn[1]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_led[0]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_led[1]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_led[2]

set_instance_assignment -name CURRENT_STRENGTH "2ma" -to hps_gpio_eth_irq
set_instance_assignment -name CURRENT_STRENGTH "2ma" -to hps_gpio_usb_oci
set_instance_assignment -name CURRENT_STRENGTH "2ma" -to hps_gpio_btn[0]
set_instance_assignment -name CURRENT_STRENGTH "2ma" -to hps_gpio_btn[1]
set_instance_assignment -name CURRENT_STRENGTH "2ma" -to hps_gpio_led[0]
set_instance_assignment -name CURRENT_STRENGTH "2ma" -to hps_gpio_led[1]
set_instance_assignment -name CURRENT_STRENGTH "2ma" -to hps_gpio_led[2]

# hps-i2c OOBE daughter card

set_location_assignment PIN_H31   -to hps_i2c_scl
set_location_assignment PIN_B33   -to hps_i2c_sda

set_instance_assignment -name IO_STANDARD "1.8V"     -to hps_i2c_scl
set_instance_assignment -name IO_STANDARD "1.8V"     -to hps_i2c_sda
set_instance_assignment -name CURRENT_STRENGTH "4ma" -to hps_i2c_scl
set_instance_assignment -name CURRENT_STRENGTH "4ma" -to hps_i2c_sda

# hps-jtag OOBE daughter card

set_location_assignment PIN_K28 -to hps_jtag_tck
set_location_assignment PIN_A32 -to hps_jtag_tdi
set_location_assignment PIN_G32 -to hps_jtag_tdo
set_location_assignment PIN_J29 -to hps_jtag_tms

set_instance_assignment -name IO_STANDARD "1.8V"     -to hps_jtag_tck
set_instance_assignment -name IO_STANDARD "1.8V"     -to hps_jtag_tdi
set_instance_assignment -name IO_STANDARD "1.8V"     -to hps_jtag_tdo
set_instance_assignment -name IO_STANDARD "1.8V"     -to hps_jtag_tms
set_instance_assignment -name CURRENT_STRENGTH "4ma" -to hps_jtag_tdo

# Stratix 10 SOC development kit's global assignments

set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON; hps_dump_handoff_data=on"
set_global_assignment -name USE_HPS_COLD_RESET SDM_IO12
set_global_assignment -name HPS_INITIALIZATION "AFTER INIT_DONE"
set_global_assignment -name HPS_DAP_SPLIT_MODE "SDM PINS"
set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
set_global_assignment -name USE_PWRMGT_SDA SDM_IO16
set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE OTHER
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 47
set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "AUTO DISCOVERY"
set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS

set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHz

