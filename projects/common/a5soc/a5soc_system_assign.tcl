
# device settings

set_global_assignment -name FAMILY "Arria V"
set_global_assignment -name DEVICE 5ASTFD5K3F40I3ES

# i2c (fmc)

set_location_assignment PIN_F26 -to fmca_scl
set_location_assignment PIN_G26 -to fmca_sda
set_instance_assignment -name IO_STANDARD "2.5 V" -to fmca_scl
set_instance_assignment -name IO_STANDARD "2.5 V" -to fmca_sda
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to fmca_scl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to fmca_sda

# led & switches

set_location_assignment PIN_AH24  -to gpio_bd_o[0]   ; ## led[0]
set_location_assignment PIN_AU24  -to gpio_bd_o[1]   ; ## led[1]
set_location_assignment PIN_AT24  -to gpio_bd_o[2]   ; ## led[2]
set_location_assignment PIN_AD24  -to gpio_bd_o[3]   ; ## led[3]
set_location_assignment PIN_AT23  -to gpio_bd_i[0]   ; ## push_buttons[0]
set_location_assignment PIN_AP24  -to gpio_bd_i[1]   ; ## push_buttons[1]
set_location_assignment PIN_AW24  -to gpio_bd_i[2]   ; ## push_buttons[2]
set_location_assignment PIN_AW23  -to gpio_bd_i[3]   ; ## push_buttons[3]
set_location_assignment PIN_AL24  -to gpio_bd_i[4]   ; ## dip_switches[0]
set_location_assignment PIN_AF24  -to gpio_bd_i[5]   ; ## dip_switches[1]
set_location_assignment PIN_AE24  -to gpio_bd_i[6]   ; ## dip_switches[2]
set_location_assignment PIN_AU23  -to gpio_bd_i[7]   ; ## dip_switches[3]

set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_o[0] 
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_o[1] 
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_o[2] 
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_o[3] 
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_i[0]
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_i[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_i[2]
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_i[3]
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_i[4]
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_i[5]
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_i[6]
set_instance_assignment -name IO_STANDARD "1.5 V" -to gpio_bd_i[7]

# uart

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart0_rx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart0_tx

# usb

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_stp
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_dir
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_nxt
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d4
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d5
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d6
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to usb1_d7

# sdio

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_cmd
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_d0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_d1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_d2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_d3

# qspi

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_ss0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_io0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_io1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_io2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_io3

# ethernet

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_tx_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_tx_ctl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_txd0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_txd1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_txd2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_txd3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rx_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rx_ctl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rxd0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rxd1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rxd2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_rxd3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_mdc
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to eth1_mdio

# ddr

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
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[4].read_capture_clk_buffer
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[1]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[2]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[3]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[4]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[1]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[2]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[3]
set_instance_assignment -name GLOBAL_SIGNAL OFF -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[4]
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
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[32]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[33]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[34]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[35]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[36]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[37]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[38]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dq[39]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[0]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[1]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[2]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[3]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[4]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[0]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[1]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[2]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[3]
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[4]

set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_ck_p
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_ck_n
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_p[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_p[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_p[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_p[3]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_p[4]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_n[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_n[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_n[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_n[3]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to ddr3_dqs_n[4]

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
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dm[4]
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
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[32]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[33]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[34]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[35]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[36]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[37]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[38]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_dq[39]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_odt
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_ras_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_reset_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_we_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to ddr3_oct_rzqin

set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dm[0]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dm[1]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dm[2]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dm[3]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dm[4]
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
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[32]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[33]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[34]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[35]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[36]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[37]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[38]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dq[39]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[0]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[1]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[2]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[3]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_p[4]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[0]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[1]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[2]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[3]
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to ddr3_dqs_n[4]
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
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dm[4]
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
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[32]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[33]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[34]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[35]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[36]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[37]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[38]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dq[39]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_p[0]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_p[1]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_p[2]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_p[3]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_p[4]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_n[0]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_n[1]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_n[2]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_n[3]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_dqs_n[4]
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_odt
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_ras_n
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_reset_n
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to ddr3_we_n

set_instance_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS ON -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst
set_instance_assignment -name PLL_COMPENSATION_MODE DIRECT -to i_system_bd|sys_hps|hps_io|border|hps_sdram_inst|pll0|fbout

# globals

set_global_assignment -name USE_DLL_FREQUENCY_FOR_DQS_DELAY_CHAIN ON
set_global_assignment -name UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON
set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"
set_global_assignment -name ECO_REGENERATE_REPORT ON
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"

# source defaults

source $ad_hdl_dir/projects/common/altera/sys_gen.tcl

