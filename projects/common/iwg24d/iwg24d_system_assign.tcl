# clocks and resets

set_location_assignment PIN_AK16 -to sys_clk
set_location_assignment PIN_AN7  -to sys_resetn
set_instance_assignment -name IO_STANDARD "1.8 V" -to sys_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to sys_resetn

# In Arria10 the CLKUSR pin is dedicated pin for tranceivers calibration, but because
# we have to have a 100 MHz system clock, we are forced to use this clock source
# as our system clock. This assignment will disable a critical warning about the
# missuse of this dedicated pin.
set_global_assignment -name AUTO_RESERVE_CLKUSR_FOR_CALIBRATION OFF

# hps-ddr4 (40)

set_location_assignment PIN_E23   -to hps_ddr_ref_clk
set_location_assignment PIN_E24   -to "hps_ddr_ref_clk(n)"
set_location_assignment PIN_L23   -to hps_ddr_clk_p
set_location_assignment PIN_M23   -to hps_ddr_clk_n
set_location_assignment PIN_H27   -to hps_ddr_a[0]
set_location_assignment PIN_G27   -to hps_ddr_a[1]
set_location_assignment PIN_G23   -to hps_ddr_a[2]
set_location_assignment PIN_G22   -to hps_ddr_a[3]
set_location_assignment PIN_H25   -to hps_ddr_a[4]
set_location_assignment PIN_G25   -to hps_ddr_a[5]
set_location_assignment PIN_H24   -to hps_ddr_a[6]
set_location_assignment PIN_H23   -to hps_ddr_a[7]
set_location_assignment PIN_H22   -to hps_ddr_a[8]
set_location_assignment PIN_J22   -to hps_ddr_a[9]
set_location_assignment PIN_G26   -to hps_ddr_a[10]
set_location_assignment PIN_F26   -to hps_ddr_a[11]
set_location_assignment PIN_F24   -to hps_ddr_a[12]
set_location_assignment PIN_E27   -to hps_ddr_a[13]
set_location_assignment PIN_D27   -to hps_ddr_a[14]
set_location_assignment PIN_E22   -to hps_ddr_a[15]
set_location_assignment PIN_F23   -to hps_ddr_a[16]
set_location_assignment PIN_D26   -to hps_ddr_ba[0]
set_location_assignment PIN_D25   -to hps_ddr_ba[1]
set_location_assignment PIN_C25   -to hps_ddr_bg
set_location_assignment PIN_J27   -to hps_ddr_cke
set_location_assignment PIN_K24   -to hps_ddr_cs_n
set_location_assignment PIN_K25   -to hps_ddr_odt
set_location_assignment PIN_L24   -to hps_ddr_reset_n
set_location_assignment PIN_J24   -to hps_ddr_act_n
set_location_assignment PIN_K22   -to hps_ddr_par
set_location_assignment PIN_AL27  -to hps_ddr_alert_n
set_location_assignment PIN_AM25  -to hps_ddr_dqs_p[0]
set_location_assignment PIN_AM26  -to hps_ddr_dqs_n[0]
set_location_assignment PIN_AG25  -to hps_ddr_dqs_p[1]
set_location_assignment PIN_AF25  -to hps_ddr_dqs_n[1]
set_location_assignment PIN_AM22  -to hps_ddr_dqs_p[2]
set_location_assignment PIN_AN22  -to hps_ddr_dqs_n[2]
set_location_assignment PIN_C24   -to hps_ddr_dqs_p[3]
set_location_assignment PIN_D24   -to hps_ddr_dqs_n[3]
set_location_assignment PIN_AH23  -to hps_ddr_dqs_p[4]
set_location_assignment PIN_AH24  -to hps_ddr_dqs_n[4]
set_location_assignment PIN_AN27  -to hps_ddr_dq[0]
set_location_assignment PIN_AK26  -to hps_ddr_dq[1]
set_location_assignment PIN_AK27  -to hps_ddr_dq[2]
set_location_assignment PIN_AN25  -to hps_ddr_dq[3]
set_location_assignment PIN_AP25  -to hps_ddr_dq[4]
set_location_assignment PIN_AP27  -to hps_ddr_dq[5]
set_location_assignment PIN_AP26  -to hps_ddr_dq[6]
set_location_assignment PIN_AL26  -to hps_ddr_dq[7]
set_location_assignment PIN_AE24  -to hps_ddr_dq[8]
set_location_assignment PIN_AJ25  -to hps_ddr_dq[9]
set_location_assignment PIN_AJ26  -to hps_ddr_dq[10]
set_location_assignment PIN_AH26  -to hps_ddr_dq[11]
set_location_assignment PIN_AH25  -to hps_ddr_dq[12]
set_location_assignment PIN_AH27  -to hps_ddr_dq[13]
set_location_assignment PIN_AD24  -to hps_ddr_dq[14]
set_location_assignment PIN_AJ27  -to hps_ddr_dq[15]
set_location_assignment PIN_AP22  -to hps_ddr_dq[16]
set_location_assignment PIN_AP21  -to hps_ddr_dq[17]
set_location_assignment PIN_AM23  -to hps_ddr_dq[18]
set_location_assignment PIN_AN23  -to hps_ddr_dq[19]
set_location_assignment PIN_AP20  -to hps_ddr_dq[20]
set_location_assignment PIN_AL25  -to hps_ddr_dq[21]
set_location_assignment PIN_AL24  -to hps_ddr_dq[22]
set_location_assignment PIN_AN24  -to hps_ddr_dq[23]
set_location_assignment PIN_B23   -to hps_ddr_dq[24]
set_location_assignment PIN_B27   -to hps_ddr_dq[25]
set_location_assignment PIN_C27   -to hps_ddr_dq[26]
set_location_assignment PIN_A25   -to hps_ddr_dq[27]
set_location_assignment PIN_B25   -to hps_ddr_dq[28]
set_location_assignment PIN_A26   -to hps_ddr_dq[29]
set_location_assignment PIN_A24   -to hps_ddr_dq[30]
set_location_assignment PIN_B26   -to hps_ddr_dq[31]
set_location_assignment PIN_AF24  -to hps_ddr_dq[32]
set_location_assignment PIN_AJ24  -to hps_ddr_dq[33]
set_location_assignment PIN_AL23  -to hps_ddr_dq[34]
set_location_assignment PIN_AK24  -to hps_ddr_dq[35]
set_location_assignment PIN_AK22  -to hps_ddr_dq[36]
set_location_assignment PIN_AK23  -to hps_ddr_dq[37]
set_location_assignment PIN_AG23  -to hps_ddr_dq[38]
set_location_assignment PIN_AF23  -to hps_ddr_dq[39]
set_location_assignment PIN_AM27  -to hps_ddr_dbi_n[0]
set_location_assignment PIN_AD25  -to hps_ddr_dbi_n[1]
set_location_assignment PIN_AP24  -to hps_ddr_dbi_n[2]
set_location_assignment PIN_C23   -to hps_ddr_dbi_n[3]
set_location_assignment PIN_AE23  -to hps_ddr_dbi_n[4]
set_location_assignment PIN_F25   -to hps_ddr_rzq

# hps-ethernet

set_location_assignment PIN_G20   -to hps_eth_rxclk
set_location_assignment PIN_F20   -to hps_eth_rxctl
set_location_assignment PIN_F19   -to hps_eth_rxd[0]
set_location_assignment PIN_E19   -to hps_eth_rxd[1]
set_location_assignment PIN_C20   -to hps_eth_rxd[2]
set_location_assignment PIN_D20   -to hps_eth_rxd[3]
set_location_assignment PIN_E17   -to hps_eth_txclk
set_location_assignment PIN_E18   -to hps_eth_txctl
set_location_assignment PIN_E21   -to hps_eth_txd[0]
set_location_assignment PIN_D21   -to hps_eth_txd[1]
set_location_assignment PIN_D22   -to hps_eth_txd[2]
set_location_assignment PIN_C22   -to hps_eth_txd[3]
set_location_assignment PIN_L19   -to hps_eth_mdc
set_location_assignment PIN_K19   -to hps_eth_mdio

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

set_location_assignment PIN_D15   -to hps_sdio_clk
set_location_assignment PIN_C17   -to hps_sdio_cmd
set_location_assignment PIN_B15   -to hps_sdio_d[0]
set_location_assignment PIN_B17   -to hps_sdio_d[1]
set_location_assignment PIN_D16   -to hps_sdio_d[2]
set_location_assignment PIN_A16   -to hps_sdio_d[3]

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_cmd
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_d[3]

set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_clk
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_cmd
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_d[3]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_clk
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_cmd
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[0]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[1]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[2]
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_d[3]

# hps-usb

set_location_assignment PIN_J20   -to hps_usb_clk
set_location_assignment PIN_J17   -to hps_usb_dir
set_location_assignment PIN_F21   -to hps_usb_nxt
set_location_assignment PIN_H20   -to hps_usb_stp
set_location_assignment PIN_H17   -to hps_usb_d[0]
set_location_assignment PIN_G21   -to hps_usb_d[1]
set_location_assignment PIN_G18   -to hps_usb_d[2]
set_location_assignment PIN_H18   -to hps_usb_d[3]
set_location_assignment PIN_F18   -to hps_usb_d[4]
set_location_assignment PIN_G17   -to hps_usb_d[5]
set_location_assignment PIN_J19   -to hps_usb_d[6]
set_location_assignment PIN_H19   -to hps_usb_d[7]

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

set_location_assignment PIN_K18   -to hps_uart0_tx
set_location_assignment PIN_L18   -to hps_uart0_rx

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart0_tx
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart0_rx

set_location_assignment PIN_K21   -to hps_uart1_tx
set_location_assignment PIN_J21   -to hps_uart1_rx
set_location_assignment PIN_M21   -to hps_uart1_cts_n
set_location_assignment PIN_L21   -to hps_uart1_rts_n

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart1_tx
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart1_rx
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart1_cts_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart1_rts_n

# hps-i2c (fmc) needs to be routed via FPGA pins to get to the FMC.
# hpc peripherals pins routed to a dedicated HPS header (J1)on the baseboard

set_location_assignment PIN_AP14   -to hps_i2c_scl
set_location_assignment PIN_AN14   -to hps_i2c_sda

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_scl
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_sda



