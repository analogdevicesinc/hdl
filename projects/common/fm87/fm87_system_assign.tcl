###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# fm87 carrier defaults
# clocks and resets

set_location_assignment PIN_CM29 -to sys_clk
set_location_assignment PIN_CL30 -to "sys_clk(n)"
set_location_assignment PIN_AB53 -to sys_resetn
set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to sys_clk
set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to "sys_clk(n)"
set_instance_assignment -name IO_STANDARD "1.2 V" -to sys_resetn

# hps-mem

set_location_assignment PIN_U34  -to emif_hps_pll_ref_clk
set_location_assignment PIN_T35  -to "emif_hps_pll_ref_clk(n)"
set_location_assignment PIN_W34  -to emif_hps_oct_rzq
set_location_assignment PIN_L32  -to emif_hps_mem_a[0]
set_location_assignment PIN_M33  -to emif_hps_mem_a[1]
set_location_assignment PIN_R32  -to emif_hps_mem_a[2]
set_location_assignment PIN_P33  -to emif_hps_mem_a[3]
set_location_assignment PIN_L30  -to emif_hps_mem_a[4]
set_location_assignment PIN_M31  -to emif_hps_mem_a[5]
set_location_assignment PIN_R30  -to emif_hps_mem_a[6]
set_location_assignment PIN_P31  -to emif_hps_mem_a[7]
set_location_assignment PIN_L28  -to emif_hps_mem_a[8]
set_location_assignment PIN_M29  -to emif_hps_mem_a[9]
set_location_assignment PIN_R28  -to emif_hps_mem_a[10]
set_location_assignment PIN_P29  -to emif_hps_mem_a[11]
set_location_assignment PIN_Y35  -to emif_hps_mem_a[12]
set_location_assignment PIN_U32  -to emif_hps_mem_a[13]
set_location_assignment PIN_T33  -to emif_hps_mem_a[14]
set_location_assignment PIN_W32  -to emif_hps_mem_a[15]
set_location_assignment PIN_Y33  -to emif_hps_mem_a[16]
set_location_assignment PIN_T31  -to emif_hps_mem_ba[0]
set_location_assignment PIN_W30  -to emif_hps_mem_ba[1]
set_location_assignment PIN_Y31  -to emif_hps_mem_bg
set_location_assignment PIN_P39  -to emif_hps_mem_act_n
set_location_assignment PIN_U30  -to emif_hps_mem_alert_n
set_location_assignment PIN_L34  -to emif_hps_mem_clk_p
set_location_assignment PIN_M35  -to emif_hps_mem_clk_n
set_location_assignment PIN_R36  -to emif_hps_mem_cke
set_location_assignment PIN_R38  -to emif_hps_mem_cs_n
set_location_assignment PIN_L36  -to emif_hps_mem_odt
set_location_assignment PIN_P35  -to emif_hps_mem_par
set_location_assignment PIN_M39  -to emif_hps_mem_reset_n
set_location_assignment PIN_G24  -to emif_hps_mem_dqs_p[0]
set_location_assignment PIN_E28  -to emif_hps_mem_dqs_p[1]
set_location_assignment PIN_G30  -to emif_hps_mem_dqs_p[2]
set_location_assignment PIN_A34  -to emif_hps_mem_dqs_p[3]
set_location_assignment PIN_AA38 -to emif_hps_mem_dqs_p[4]
set_location_assignment PIN_U38  -to emif_hps_mem_dqs_p[5]
set_location_assignment PIN_G42  -to emif_hps_mem_dqs_p[6]
set_location_assignment PIN_L42  -to emif_hps_mem_dqs_p[7]
set_location_assignment PIN_AA32 -to emif_hps_mem_dqs_p[8]
set_location_assignment PIN_F25  -to emif_hps_mem_dqs_n[0]
set_location_assignment PIN_D29  -to emif_hps_mem_dqs_n[1]
set_location_assignment PIN_F31  -to emif_hps_mem_dqs_n[2]
set_location_assignment PIN_B35  -to emif_hps_mem_dqs_n[3]
set_location_assignment PIN_AB39 -to emif_hps_mem_dqs_n[4]
set_location_assignment PIN_T39  -to emif_hps_mem_dqs_n[5]
set_location_assignment PIN_F43  -to emif_hps_mem_dqs_n[6]
set_location_assignment PIN_M43  -to emif_hps_mem_dqs_n[7]
set_location_assignment PIN_AB33 -to emif_hps_mem_dqs_n[8]
set_location_assignment PIN_J24  -to emif_hps_mem_dbi_n[0]
set_location_assignment PIN_A28  -to emif_hps_mem_dbi_n[1]
set_location_assignment PIN_J30  -to emif_hps_mem_dbi_n[2]
set_location_assignment PIN_E34  -to emif_hps_mem_dbi_n[3]
set_location_assignment PIN_AE38 -to emif_hps_mem_dbi_n[4]
set_location_assignment PIN_W38  -to emif_hps_mem_dbi_n[5]
set_location_assignment PIN_J42  -to emif_hps_mem_dbi_n[6]
set_location_assignment PIN_R42  -to emif_hps_mem_dbi_n[7]
set_location_assignment PIN_AE32 -to emif_hps_mem_dbi_n[8]
set_location_assignment PIN_G26  -to emif_hps_mem_dq[0]
set_location_assignment PIN_F27  -to emif_hps_mem_dq[1]
set_location_assignment PIN_J26  -to emif_hps_mem_dq[2]
set_location_assignment PIN_K27  -to emif_hps_mem_dq[3]
set_location_assignment PIN_G22  -to emif_hps_mem_dq[4]
set_location_assignment PIN_F23  -to emif_hps_mem_dq[5]
set_location_assignment PIN_J22  -to emif_hps_mem_dq[6]
set_location_assignment PIN_K23  -to emif_hps_mem_dq[7]
set_location_assignment PIN_A30  -to emif_hps_mem_dq[8]
set_location_assignment PIN_B31  -to emif_hps_mem_dq[9]
set_location_assignment PIN_D31  -to emif_hps_mem_dq[10]
set_location_assignment PIN_E30  -to emif_hps_mem_dq[11]
set_location_assignment PIN_A26  -to emif_hps_mem_dq[12]
set_location_assignment PIN_B27  -to emif_hps_mem_dq[13]
set_location_assignment PIN_E26  -to emif_hps_mem_dq[14]
set_location_assignment PIN_D27  -to emif_hps_mem_dq[15]
set_location_assignment PIN_G32  -to emif_hps_mem_dq[16]
set_location_assignment PIN_K33  -to emif_hps_mem_dq[17]
set_location_assignment PIN_J32  -to emif_hps_mem_dq[18]
set_location_assignment PIN_F33  -to emif_hps_mem_dq[19]
set_location_assignment PIN_G28  -to emif_hps_mem_dq[20]
set_location_assignment PIN_F29  -to emif_hps_mem_dq[21]
set_location_assignment PIN_J28  -to emif_hps_mem_dq[22]
set_location_assignment PIN_K29  -to emif_hps_mem_dq[23]
set_location_assignment PIN_A36  -to emif_hps_mem_dq[24]
set_location_assignment PIN_B37  -to emif_hps_mem_dq[25]
set_location_assignment PIN_E36  -to emif_hps_mem_dq[26]
set_location_assignment PIN_D37  -to emif_hps_mem_dq[27]
set_location_assignment PIN_A32  -to emif_hps_mem_dq[28]
set_location_assignment PIN_B33  -to emif_hps_mem_dq[29]
set_location_assignment PIN_E32  -to emif_hps_mem_dq[30]
set_location_assignment PIN_D33  -to emif_hps_mem_dq[31]
set_location_assignment PIN_AE40 -to emif_hps_mem_dq[32]
set_location_assignment PIN_AA40 -to emif_hps_mem_dq[33]
set_location_assignment PIN_AD41 -to emif_hps_mem_dq[34]
set_location_assignment PIN_AB41 -to emif_hps_mem_dq[35]
set_location_assignment PIN_AD37 -to emif_hps_mem_dq[36]
set_location_assignment PIN_AE36 -to emif_hps_mem_dq[37]
set_location_assignment PIN_AB37 -to emif_hps_mem_dq[38]
set_location_assignment PIN_AA36 -to emif_hps_mem_dq[39]
set_location_assignment PIN_T41  -to emif_hps_mem_dq[40]
set_location_assignment PIN_U40  -to emif_hps_mem_dq[41]
set_location_assignment PIN_Y41  -to emif_hps_mem_dq[42]
set_location_assignment PIN_W40  -to emif_hps_mem_dq[43]
set_location_assignment PIN_U36  -to emif_hps_mem_dq[44]
set_location_assignment PIN_T37  -to emif_hps_mem_dq[45]
set_location_assignment PIN_W36  -to emif_hps_mem_dq[46]
set_location_assignment PIN_Y37  -to emif_hps_mem_dq[47]
set_location_assignment PIN_F45  -to emif_hps_mem_dq[48]
set_location_assignment PIN_G44  -to emif_hps_mem_dq[49]
set_location_assignment PIN_K45  -to emif_hps_mem_dq[50]
set_location_assignment PIN_J44  -to emif_hps_mem_dq[51]
set_location_assignment PIN_J40  -to emif_hps_mem_dq[52]
set_location_assignment PIN_K41  -to emif_hps_mem_dq[53]
set_location_assignment PIN_G40  -to emif_hps_mem_dq[54]
set_location_assignment PIN_F41  -to emif_hps_mem_dq[55]
set_location_assignment PIN_L44  -to emif_hps_mem_dq[56]
set_location_assignment PIN_P45  -to emif_hps_mem_dq[57]
set_location_assignment PIN_M45  -to emif_hps_mem_dq[58]
set_location_assignment PIN_R44  -to emif_hps_mem_dq[59]
set_location_assignment PIN_L40  -to emif_hps_mem_dq[60]
set_location_assignment PIN_M41  -to emif_hps_mem_dq[61]
set_location_assignment PIN_R40  -to emif_hps_mem_dq[62]
set_location_assignment PIN_P41  -to emif_hps_mem_dq[63]
set_location_assignment PIN_AA34 -to emif_hps_mem_dq[64]
set_location_assignment PIN_AB35 -to emif_hps_mem_dq[65]
set_location_assignment PIN_AE34 -to emif_hps_mem_dq[66]
set_location_assignment PIN_AD35 -to emif_hps_mem_dq[67]
set_location_assignment PIN_AA30 -to emif_hps_mem_dq[68]
set_location_assignment PIN_AB31 -to emif_hps_mem_dq[69]
set_location_assignment PIN_AE30 -to emif_hps_mem_dq[70]
set_location_assignment PIN_AD31 -to emif_hps_mem_dq[71]

# hps-emac

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxctl
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxd[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxd[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxd[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_rxd[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txctl
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txd[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txd[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txd[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_txd[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_mdio
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac_mdc

set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac_txclk
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txctl
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txd[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txd[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txd[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac_txd[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac_mdio
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac_mdc
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxclk
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxctl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxd[0]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxd[1]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxd[2]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_rxd[3]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac_mdio

set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_emac_mdio

# hps-sdio

set_location_assignment PIN_T21  -to hps_io_ref_clk

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_cmd
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[3]

set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdio_cmd
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdio_clk
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdio_d[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdio_d[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdio_d[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdio_d[3]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_cmd
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[0]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[1]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[2]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_d[3]

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_io_ref_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tck
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tms
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tdo
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tdi
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_jtag_tdo
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tck
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tms
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tdi

# hps-usb

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_dir
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_stp
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_nxt
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb_d[7]

set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_stp
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_clk
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_dir
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_nxt

set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_d[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_d[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_d[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_d[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_d[4]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_d[5]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_d[6]
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb_d[7]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_d[0]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_d[1]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_d[2]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_d[3]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_d[4]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_d[5]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_d[6]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb_d[7]

# hps-uart

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart_tx
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart_rx

set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_uart_tx
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_uart_rx

# hps-i2c

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_sda
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_scl

set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_i2c_sda
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_i2c_scl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_i2c_sda
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_i2c_scl
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_i2c_sda
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_i2c_scl

# hps-gpio

set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_eth_irq
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_usb_oci
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_btn[0]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_btn[1]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_led[0]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_led[1]
set_instance_assignment -name IO_STANDARD "1.8V" -to hps_gpio_led[2]

set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio_eth_irq
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio_usb_oci
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio_btn[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio_btn[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio_led[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio_led[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio_led[2]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio_eth_irq
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio_usb_oci
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio_btn[0]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio_btn[1]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio_led[0]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio_led[1]
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio_led[2]

# gpio

set_location_assignment PIN_CY47 -to fpga_gpio[0]
set_location_assignment PIN_CW48 -to fpga_gpio[1]
set_location_assignment PIN_CT47 -to fpga_gpio[2]
set_location_assignment PIN_CU48 -to fpga_gpio[3]
set_location_assignment PIN_CY49 -to fpga_gpio[4]
set_location_assignment PIN_CW50 -to fpga_gpio[5]
set_location_assignment PIN_CT49 -to fpga_gpio[6]
set_location_assignment PIN_CU50 -to fpga_gpio[7]
set_location_assignment PIN_CY51 -to fpga_gpio[8]
set_location_assignment PIN_CW52 -to fpga_gpio[9]
set_location_assignment PIN_CT51 -to fpga_gpio[10]
set_location_assignment PIN_CU52 -to fpga_gpio[11]
set_location_assignment PIN_DA50 -to fpga_gpio[12]

set_location_assignment PIN_Y49 -to fpga_sgpio_sync
set_location_assignment PIN_W48 -to fpga_sgpio_clk
set_location_assignment PIN_T49 -to fpga_sgpi
set_location_assignment PIN_U48 -to fpga_sgpo

set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[2]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[3]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[4]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[5]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[6]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[7]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[8]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[9]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[10]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[11]
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_gpio[12]

set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_sgpio_sync
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_sgpio_clk
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_sgpi
set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_sgpo

# Agilex development kit's global assignments

set_global_assignment -name HPS_INITIALIZATION "HPS FIRST"
set_global_assignment -name HPS_DAP_SPLIT_MODE "SDM PINS"

set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON;"
set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
set_global_assignment -name USE_HPS_COLD_RESET SDM_IO11
set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
set_global_assignment -name USE_CONF_DONE SDM_IO16
set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
set_global_assignment -name PWRMGT_BUS_SPEED_MODE "100 KHZ"
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTC3888
set_global_assignment -name NUMBER_OF_SLAVE_DEVICE 1
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 62
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS

set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHz
