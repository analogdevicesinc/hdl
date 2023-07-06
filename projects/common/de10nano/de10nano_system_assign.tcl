###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# de10nano
# clocks (V11, Y13, E11 - PL 50MHz)
# clocks (E20, D20 - HPS 25MHz)
# clocks (G4 - HPS USB 60MHz)

set_location_assignment PIN_V11 -to sys_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sys_clk

# Switches

set_location_assignment PIN_Y24  -to gpio_bd_i[0]
set_location_assignment PIN_W24  -to gpio_bd_i[1]
set_location_assignment PIN_W21  -to gpio_bd_i[2]
set_location_assignment PIN_W20  -to gpio_bd_i[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[3]

# LEDs

set_location_assignment PIN_W15   -to gpio_bd_o[0]
set_location_assignment PIN_AA24  -to gpio_bd_o[1]
set_location_assignment PIN_V16   -to gpio_bd_o[2]
set_location_assignment PIN_V15   -to gpio_bd_o[3]
set_location_assignment PIN_AF26  -to gpio_bd_o[4]
set_location_assignment PIN_AE26  -to gpio_bd_o[5]
set_location_assignment PIN_Y16   -to gpio_bd_o[6]
set_location_assignment PIN_AA23  -to gpio_bd_o[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[7]

# push-buttons

set_location_assignment PIN_AH17 -to gpio_bd_i[4]
set_location_assignment PIN_AH16 -to gpio_bd_i[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[5]

# UART

set_location_assignment PIN_A22 -to uart0_rx
set_location_assignment PIN_B21 -to uart0_tx
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to uart0_rx
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to uart0_tx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart0_rx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart0_tx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_conv_usb_n

# hps spi master

set_location_assignment PIN_C16 -to spim1_ss0
set_location_assignment PIN_C19 -to spim1_clk
set_location_assignment PIN_B16 -to spim1_mosi
set_location_assignment PIN_B19 -to spim1_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spim1_ss0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spim1_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spim1_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spim1_miso

# SPI interface for ltc2308

set_location_assignment PIN_V10  -to ltc2308_sclk
set_location_assignment PIN_AD4  -to ltc2308_miso
set_location_assignment PIN_AC4  -to ltc2308_mosi
set_location_assignment PIN_U9   -to ltc2308_cs

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc2308_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc2308_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc2308_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc2308_cs

# USB

set_location_assignment PIN_G4    -to usb1_clk
set_location_assignment PIN_C5    -to usb1_stp
set_location_assignment PIN_E5    -to usb1_dir
set_location_assignment PIN_D5    -to usb1_nxt
set_location_assignment PIN_C10   -to usb1_d[0]
set_location_assignment PIN_F5    -to usb1_d[1]
set_location_assignment PIN_C9    -to usb1_d[2]
set_location_assignment PIN_C4    -to usb1_d[3]
set_location_assignment PIN_C8    -to usb1_d[4]
set_location_assignment PIN_D4    -to usb1_d[5]
set_location_assignment PIN_C7    -to usb1_d[6]
set_location_assignment PIN_F4    -to usb1_d[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_stp
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_dir
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_nxt
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d[7]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_clk
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_stp
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_dir
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_nxt
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_d[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_d[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_d[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_d[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_d[4]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_d[5]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_d[6]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to usb1_d[7]

set_location_assignment PIN_B8   -to sdio_clk
set_location_assignment PIN_D14  -to sdio_cmd
set_location_assignment PIN_C13  -to sdio_d[0]
set_location_assignment PIN_B6   -to sdio_d[1]
set_location_assignment PIN_B11  -to sdio_d[2]
set_location_assignment PIN_B9   -to sdio_d[3]

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdio_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdio_cmd
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdio_d[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdio_d[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdio_d[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdio_d[3]

# ETHERNET

set_location_assignment PIN_J15   -to eth1_tx_clk
set_location_assignment PIN_A12   -to eth1_tx_ctl
set_location_assignment PIN_A16   -to eth1_tx_d[0]
set_location_assignment PIN_J14   -to eth1_tx_d[1]
set_location_assignment PIN_A15   -to eth1_tx_d[2]
set_location_assignment PIN_D17   -to eth1_tx_d[3]
set_location_assignment PIN_J12   -to eth1_rx_clk
set_location_assignment PIN_J13   -to eth1_rx_ctl
set_location_assignment PIN_A14   -to eth1_rx_d[0]
set_location_assignment PIN_A11   -to eth1_rx_d[1]
set_location_assignment PIN_C15   -to eth1_rx_d[2]
set_location_assignment PIN_A9    -to eth1_rx_d[3]
set_location_assignment PIN_A13   -to eth1_mdc
set_location_assignment PIN_E16   -to eth1_mdio
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_tx_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_tx_ctl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_tx_d[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_tx_d[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_tx_d[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_tx_d[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rx_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rx_ctl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rx_d[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rx_d[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rx_d[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rx_d[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_mdc
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_mdio
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_tx_clk
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_tx_ctl
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_tx_d[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_tx_d[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_tx_d[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_tx_d[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_rx_clk
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_rx_ctl
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_rx_d[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_rx_d[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_rx_d[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_rx_d[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_mdc
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to eth1_mdio

# DDR

set_instance_assignment -name D5_DELAY 2 -to ddr3_ck_p
set_instance_assignment -name D5_DELAY 2 -to ddr3_ck_n

set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[4]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[5]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[6]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[7]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[8]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[9]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[10]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[11]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[12]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[13]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_a[14]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_ba[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_ba[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_ba[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_cas_n
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_cke
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_cs_n
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_odt
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_ras_n
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_reset_n
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to ddr3_we_n

set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[0].read_capture_clk_buffer
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[1].read_capture_clk_buffer
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[2].read_capture_clk_buffer
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[3].read_capture_clk_buffer
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[1]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[2]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[3]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[1]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[2]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[3]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_mem_stable_n
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_n

set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[0]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[1]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[2]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[3]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[4]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[5]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[6]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[7]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[8]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[9]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[10]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[11]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[12]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[13]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[14]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[15]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[16]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[17]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[18]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[19]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[20]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[21]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[22]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[23]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[24]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[25]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[26]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[27]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[28]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[29]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[30]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[31]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[0]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[1]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[2]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[3]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[0]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[1]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[2]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[3]

set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_ck_p
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_ck_n
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_p[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_p[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_p[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_p[3]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_n[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_n[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_n[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_n[3]

set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[3]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[4]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[5]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[6]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[7]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[8]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[9]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[10]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[11]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[12]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[13]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_a[14]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_ba[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_ba[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_ba[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_cas_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_cke
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_cs_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dm[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dm[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dm[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dm[3]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[3]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[4]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[5]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[6]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[7]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[8]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[9]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[10]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[11]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[12]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[13]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[14]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[15]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[16]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[17]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[18]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[19]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[20]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[21]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[22]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[23]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[24]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[25]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[26]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[27]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[28]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[29]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[30]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[31]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_odt
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_ras_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_reset_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_we_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_rzq

set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dm[0]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dm[1]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dm[2]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dm[3]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[0]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[1]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[2]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[3]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[4]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[5]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[6]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[7]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[8]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[9]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[10]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[11]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[12]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[13]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[14]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[15]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[16]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[17]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[18]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[19]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[20]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[21]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[22]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[23]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[24]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[25]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[26]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[27]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[28]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[29]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[30]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[31]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[0]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[1]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[2]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[3]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[0]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[1]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[2]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[3]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION" -to ddr3_ck_p
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION" -to ddr3_ck_n

set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[0]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[1]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[2]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[3]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[4]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[5]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[6]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[7]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[8]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[9]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[10]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[11]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[12]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[13]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_a[14]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_ba[0]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_ba[1]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_ba[2]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_cas_n
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_ck_p
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_ck_n
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_cke
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_cs_n
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dm[0]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dm[1]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dm[2]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dm[3]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[0]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[1]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[2]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[3]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[4]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[5]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[6]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[7]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[8]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[9]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[10]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[11]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[12]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[13]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[14]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[15]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[16]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[17]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[18]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[19]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[20]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[21]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[22]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[23]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[24]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[25]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[26]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[27]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[28]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[29]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[30]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[31]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_p[0]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_p[1]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_p[2]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_p[3]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_n[0]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_n[1]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_n[2]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_n[3]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_odt
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_ras_n
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_reset_n
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_we_n

set_instance_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS ON -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst
set_instance_assignment -name PLL_COMPENSATION_MODE DIRECT -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|pll0|fbout

# DDR3 pin locations

set_location_assignment PIN_C28   -to ddr3_a[0]
set_location_assignment PIN_B28   -to ddr3_a[1]
set_location_assignment PIN_E26   -to ddr3_a[2]
set_location_assignment PIN_D26   -to ddr3_a[3]
set_location_assignment PIN_J21   -to ddr3_a[4]
set_location_assignment PIN_J20   -to ddr3_a[5]
set_location_assignment PIN_C26   -to ddr3_a[6]
set_location_assignment PIN_B26   -to ddr3_a[7]
set_location_assignment PIN_F26   -to ddr3_a[8]
set_location_assignment PIN_F25   -to ddr3_a[9]
set_location_assignment PIN_A24   -to ddr3_a[10]
set_location_assignment PIN_B24   -to ddr3_a[11]
set_location_assignment PIN_D24   -to ddr3_a[12]
set_location_assignment PIN_C24   -to ddr3_a[13]
set_location_assignment PIN_G23   -to ddr3_a[14]
set_location_assignment PIN_A27   -to ddr3_ba[0]
set_location_assignment PIN_H25   -to ddr3_ba[1]
set_location_assignment PIN_G25   -to ddr3_ba[2]
set_location_assignment PIN_A26   -to ddr3_cas_n
set_location_assignment PIN_N21   -to ddr3_ck_p
set_location_assignment PIN_N20   -to ddr3_ck_n
set_location_assignment PIN_L28   -to ddr3_cke
set_location_assignment PIN_L21   -to ddr3_cs_n
set_location_assignment PIN_G28   -to ddr3_dm[0]
set_location_assignment PIN_P28   -to ddr3_dm[1]
set_location_assignment PIN_W28   -to ddr3_dm[2]
set_location_assignment PIN_AB28  -to ddr3_dm[3]
set_location_assignment PIN_J25   -to ddr3_dq[0]
set_location_assignment PIN_J24   -to ddr3_dq[1]
set_location_assignment PIN_E28   -to ddr3_dq[2]
set_location_assignment PIN_D27   -to ddr3_dq[3]
set_location_assignment PIN_J26   -to ddr3_dq[4]
set_location_assignment PIN_K26   -to ddr3_dq[5]
set_location_assignment PIN_G27   -to ddr3_dq[6]
set_location_assignment PIN_F28   -to ddr3_dq[7]
set_location_assignment PIN_K25   -to ddr3_dq[8]
set_location_assignment PIN_L25   -to ddr3_dq[9]
set_location_assignment PIN_J27   -to ddr3_dq[10]
set_location_assignment PIN_J28   -to ddr3_dq[11]
set_location_assignment PIN_M27   -to ddr3_dq[12]
set_location_assignment PIN_M26   -to ddr3_dq[13]
set_location_assignment PIN_M28   -to ddr3_dq[14]
set_location_assignment PIN_N28   -to ddr3_dq[15]
set_location_assignment PIN_N24   -to ddr3_dq[16]
set_location_assignment PIN_N25   -to ddr3_dq[17]
set_location_assignment PIN_T28   -to ddr3_dq[18]
set_location_assignment PIN_U28   -to ddr3_dq[19]
set_location_assignment PIN_N26   -to ddr3_dq[20]
set_location_assignment PIN_N27   -to ddr3_dq[21]
set_location_assignment PIN_R27   -to ddr3_dq[22]
set_location_assignment PIN_V27   -to ddr3_dq[23]
set_location_assignment PIN_R26   -to ddr3_dq[24]
set_location_assignment PIN_R25   -to ddr3_dq[25]
set_location_assignment PIN_AA28  -to ddr3_dq[26]
set_location_assignment PIN_W26   -to ddr3_dq[27]
set_location_assignment PIN_R24   -to ddr3_dq[28]
set_location_assignment PIN_T24   -to ddr3_dq[29]
set_location_assignment PIN_Y27   -to ddr3_dq[30]
set_location_assignment PIN_AA27  -to ddr3_dq[31]
set_location_assignment PIN_R17   -to ddr3_dqs_p[0]
set_location_assignment PIN_R16   -to ddr3_dqs_n[0]
set_location_assignment PIN_R19   -to ddr3_dqs_p[1]
set_location_assignment PIN_R18   -to ddr3_dqs_n[1]
set_location_assignment PIN_T19   -to ddr3_dqs_p[2]
set_location_assignment PIN_T18   -to ddr3_dqs_n[2]
set_location_assignment PIN_U19   -to ddr3_dqs_p[3]
set_location_assignment PIN_T20   -to ddr3_dqs_n[3]
set_location_assignment PIN_D28   -to ddr3_odt
set_location_assignment PIN_A25   -to ddr3_ras_n
set_location_assignment PIN_V28   -to ddr3_reset_n
set_location_assignment PIN_E25   -to ddr3_we_n
set_location_assignment PIN_D25   -to ddr3_rzq

# hdmi

set_location_assignment PIN_U10   -to hdmi_i2c_scl
set_location_assignment PIN_AA4   -to hdmi_i2c_sda
set_location_assignment PIN_AG5   -to hdmi_out_clk
set_location_assignment PIN_AD12  -to hdmi_data[0]
set_location_assignment PIN_AE12  -to hdmi_data[1]
set_location_assignment PIN_W8    -to hdmi_data[2]
set_location_assignment PIN_Y8    -to hdmi_data[3]
set_location_assignment PIN_AD11  -to hdmi_data[4]
set_location_assignment PIN_AD10  -to hdmi_data[5]
set_location_assignment PIN_AE11  -to hdmi_data[6]
set_location_assignment PIN_Y5    -to hdmi_data[7]
set_location_assignment PIN_AF10  -to hdmi_data[8]
set_location_assignment PIN_Y4    -to hdmi_data[9]
set_location_assignment PIN_AE9   -to hdmi_data[10]
set_location_assignment PIN_AB4   -to hdmi_data[11]
set_location_assignment PIN_AE7   -to hdmi_data[12]
set_location_assignment PIN_AF6   -to hdmi_data[13]
set_location_assignment PIN_AF8   -to hdmi_data[14]
set_location_assignment PIN_AF5   -to hdmi_data[15]
set_location_assignment PIN_AE4   -to hdmi_data[16]
set_location_assignment PIN_AH2   -to hdmi_data[17]
set_location_assignment PIN_AH4   -to hdmi_data[18]
set_location_assignment PIN_AH5   -to hdmi_data[19]
set_location_assignment PIN_AH6   -to hdmi_data[20]
set_location_assignment PIN_AG6   -to hdmi_data[21]
set_location_assignment PIN_AF9   -to hdmi_data[22]
set_location_assignment PIN_AE8   -to hdmi_data[23]
set_location_assignment PIN_AD19  -to hdmi_data_e
set_location_assignment PIN_T8    -to hdmi_hsync
set_location_assignment PIN_V13   -to hdmi_vsync

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_i2c_sda
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_out_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[18]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[19]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[20]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[21]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[22]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data[23]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_data_e
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_hsync
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_vsync

# globals

set_global_assignment -name USE_DLL_FREQUENCY_FOR_DQS_DELAY_CHAIN ON
set_global_assignment -name UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON
set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"
set_global_assignment -name ECO_REGENERATE_REPORT ON
set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON

