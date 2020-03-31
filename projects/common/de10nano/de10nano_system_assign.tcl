# de10nano
# clocks (V11, Y13, E11 - PL 50MHz)
# clocks (E20, D20 - HPS 25MHz)

set_location_assignment PIN_V11 -to sys_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sys_clk

# Switches

set_location_assignment PIN_Y24  -to gpio_bd_o[0]
set_location_assignment PIN_W24  -to gpio_bd_o[1]
set_location_assignment PIN_W21  -to gpio_bd_o[2]
set_location_assignment PIN_W20  -to gpio_bd_o[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_o[3]

# LEDs

set_location_assignment PIN_W15   -to gpio_bd_i[0]
set_location_assignment PIN_AA24  -to gpio_bd_i[1]
set_location_assignment PIN_V16   -to gpio_bd_i[2]
set_location_assignment PIN_V15   -to gpio_bd_i[3]
set_location_assignment PIN_AF26  -to gpio_bd_i[4]
set_location_assignment PIN_AE26  -to gpio_bd_i[5]
set_location_assignment PIN_Y16   -to gpio_bd_i[6]
set_location_assignment PIN_AA23  -to gpio_bd_i[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[7]

# push-buttons

# set_location_assignment PIN_AH17 -to gpio_bd_i[0]
# set_location_assignment PIN_AH16 -to gpio_bd_i[1]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[0]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd_i[1]

# UART

set_location_assignment PIN_A22 -to uart0_rx
set_location_assignment PIN_B21 -to uart0_tx

# set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart0_rx
# set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart0_tx

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

# gpio-0 (JP1)

# set_location_assignment PIN_V12  -to gpio_0[0]
# set_location_assignment PIN_E8   -to gpio_0[1]
# set_location_assignment PIN_W12  -to gpio_0[2]
# set_location_assignment PIN_D11  -to gpio_0[3]
# set_location_assignment PIN_D8   -to gpio_0[4]
# set_location_assignment PIN_AH13 -to gpio_0[5]
# set_location_assignment PIN_AF7  -to gpio_0[6]
# set_location_assignment PIN_AH14 -to gpio_0[7]
# set_location_assignment PIN_AF4  -to gpio_0[8]
# set_location_assignment PIN_AH3  -to gpio_0[9]
# set_location_assignment PIN_AD5  -to gpio_0[10]
# set_location_assignment PIN_AG14 -to gpio_0[11]
# set_location_assignment PIN_AE23 -to gpio_0[12]
# set_location_assignment PIN_AE6  -to gpio_0[13]
# set_location_assignment PIN_AD23 -to gpio_0[14]
# set_location_assignment PIN_AE24 -to gpio_0[15]
# set_location_assignment PIN_D12  -to gpio_0[16]
# set_location_assignment PIN_AD20 -to gpio_0[17]
# set_location_assignment PIN_C12  -to gpio_0[18]
# set_location_assignment PIN_AD17 -to gpio_0[19]
# set_location_assignment PIN_AC23 -to gpio_0[20]
# set_location_assignment PIN_AC22 -to gpio_0[21]
# set_location_assignment PIN_Y19  -to gpio_0[22]
# set_location_assignment PIN_AB23 -to gpio_0[23]
# set_location_assignment PIN_AA19 -to gpio_0[24]
# set_location_assignment PIN_W11  -to gpio_0[25]
# set_location_assignment PIN_AA18 -to gpio_0[26]
# set_location_assignment PIN_W14  -to gpio_0[27]
# set_location_assignment PIN_Y18  -to gpio_0[28]
# set_location_assignment PIN_Y17  -to gpio_0[29]
# set_location_assignment PIN_AB25 -to gpio_0[30]
# set_location_assignment PIN_AB26 -to gpio_0[31]
# set_location_assignment PIN_Y11  -to gpio_0[32]
# set_location_assignment PIN_AA26 -to gpio_0[33]
# set_location_assignment PIN_AA13 -to gpio_0[34]
# set_location_assignment PIN_AA11 -to gpio_0[35]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[0]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[1]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[2]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[3]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[4]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[5]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[6]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[7]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[8]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[9]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[10]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[11]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[12]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[13]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[14]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[15]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[16]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[17]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[18]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[19]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[20]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[21]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[22]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[23]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[24]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[25]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[26]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[27]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[28]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[29]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[30]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[31]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[32]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[33]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[34]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[35]

# gpio-1 (JP7)

# set_location_assignment PIN_Y15  -to gpio_1[0]
# set_location_assignment PIN_AC24 -to gpio_1[1]
# set_location_assignment PIN_AA15 -to gpio_1[2]
# set_location_assignment PIN_AD26 -to gpio_1[3]
# set_location_assignment PIN_AG28 -to gpio_1[4]
# set_location_assignment PIN_AF28 -to gpio_1[5]
# set_location_assignment PIN_AE25 -to gpio_1[6]
# set_location_assignment PIN_AF27 -to gpio_1[7]
# set_location_assignment PIN_AG26 -to gpio_1[8]
# set_location_assignment PIN_AH27 -to gpio_1[9]
# set_location_assignment PIN_AG25 -to gpio_1[10]
# set_location_assignment PIN_AH26 -to gpio_1[11]
# set_location_assignment PIN_AH24 -to gpio_1[12]
# set_location_assignment PIN_AF25 -to gpio_1[13]
# set_location_assignment PIN_AG23 -to gpio_1[14]
# set_location_assignment PIN_AF23 -to gpio_1[15]
# set_location_assignment PIN_AG24 -to gpio_1[16]
# set_location_assignment PIN_AH22 -to gpio_1[17]
# set_location_assignment PIN_AH21 -to gpio_1[18]
# set_location_assignment PIN_AG21 -to gpio_1[19]
# set_location_assignment PIN_AH23 -to gpio_1[20]
# set_location_assignment PIN_AA20 -to gpio_1[21]
# set_location_assignment PIN_AF22 -to gpio_1[22]
# set_location_assignment PIN_AE22 -to gpio_1[23]
# set_location_assignment PIN_AG20 -to gpio_1[24]
# set_location_assignment PIN_AF21 -to gpio_1[25]
# set_location_assignment PIN_AG19 -to gpio_1[26]
# set_location_assignment PIN_AH19 -to gpio_1[27]
# set_location_assignment PIN_AG18 -to gpio_1[28]
# set_location_assignment PIN_AH18 -to gpio_1[29]
# set_location_assignment PIN_AF18 -to gpio_1[30]
# set_location_assignment PIN_AF20 -to gpio_1[31]
# set_location_assignment PIN_AG15 -to gpio_1[32]
# set_location_assignment PIN_AE20 -to gpio_1[33]
# set_location_assignment PIN_AE19 -to gpio_1[34]
# set_location_assignment PIN_AE17 -to gpio_1[35]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[0]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[1]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[2]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[3]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[4]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[5]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[6]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[7]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[8]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[9]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[10]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[11]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[12]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[13]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[14]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[15]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[16]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[17]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[18]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[19]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[20]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[21]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[22]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[23]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[24]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[25]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[26]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[27]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[28]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[29]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[30]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[31]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[32]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[33]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[34]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[35]

# arduino (JP7)

# set_location_assignment PIN_AG13 -to arduino_io[0]
# set_location_assignment PIN_AF13 -to arduino_io[1]
# set_location_assignment PIN_AG10 -to arduino_io[2]
# set_location_assignment PIN_AG9  -to arduino_io[3]
# set_location_assignment PIN_U14  -to arduino_io[4]
# set_location_assignment PIN_U13  -to arduino_io[5]
# set_location_assignment PIN_AG8  -to arduino_io[6]
# set_location_assignment PIN_AH8  -to arduino_io[7]
# set_location_assignment PIN_AF17 -to arduino_io[8]
# set_location_assignment PIN_AE15 -to arduino_io[9]
# set_location_assignment PIN_AF15 -to arduino_io[10]
# set_location_assignment PIN_AG16 -to arduino_io[11]
# set_location_assignment PIN_AH11 -to arduino_io[12]
# set_location_assignment PIN_AH12 -to arduino_io[13]
# set_location_assignment PIN_AH9  -to arduino_io[14]
# set_location_assignment PIN_AG11 -to arduino_io[15]
# set_location_assignment PIN_AH7  -to arduino_reset_n
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[0]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[1]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[2]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[3]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[4]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[5]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[6]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[7]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[8]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[9]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[10]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[11]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[12]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[13]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[14]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_io[15]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_reset_n

# globals

set_global_assignment -name USE_DLL_FREQUENCY_FOR_DQS_DELAY_CHAIN ON
set_global_assignment -name UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON
set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"
set_global_assignment -name ECO_REGENERATE_REPORT ON
set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON

