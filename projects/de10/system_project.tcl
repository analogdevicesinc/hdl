
source ../scripts/adi_env.tcl
source ../scripts/adi_project_alt.tcl

load_package flow

project_new de10nano -overwrite

set family "Cyclone V"
set device 5CSEBA6U23I7DK

set_global_assignment -name FAMILY $family
set_global_assignment -name DEVICE $device

set QFILE [open "system_qsys_script.tcl" "w"]
puts $QFILE "set ad_hdl_dir $ad_hdl_dir"
puts $QFILE "set ad_phdl_dir $ad_phdl_dir"
puts $QFILE "package require qsys"
puts $QFILE "set_module_property NAME {system_bd}"
puts $QFILE "set_project_property DEVICE_FAMILY {$family}"
puts $QFILE "set_project_property DEVICE $device"
puts $QFILE "source system_qsys.tcl"
puts $QFILE "set_interconnect_requirement {\$system} {qsys_mm.clockCrossingAdapter} {AUTO}"
puts $QFILE "set_interconnect_requirement {\$system} {qsys_mm.burstAdapterImplementation} {PER_BURST_TYPE_CONVERTER}"
puts $QFILE "set_interconnect_requirement {\$system} {qsys_mm.maxAdditionalLatency} {4}"
puts $QFILE "save_system {system_bd.qsys}"
close $QFILE

exec -ignorestderr $quartus(quartus_rootpath)/sopc_builder/bin/qsys-script \
  --script=system_qsys_script.tcl
exec -ignorestderr $quartus(quartus_rootpath)/sopc_builder/bin/qsys-generate \
  system_bd.qsys --synthesis=VERILOG --output-directory=system_bd \
  --family=$family --part=$device

# ignored warnings and such

set_global_assignment -name MESSAGE_DISABLE 17951 ; ## unused RX channels
set_global_assignment -name MESSAGE_DISABLE 18655 ; ## unused TX channels
set_global_assignment -name MESSAGE_DISABLE 114001 ; ## time value $x truncated to $y

# default assignments
 
set_global_assignment -name QIP_FILE system_bd/synthesis/system_bd.qip
set_global_assignment -name VERILOG_FILE system_top.v
set_global_assignment -name SDC_FILE system_constr.sdc
set_global_assignment -name TOP_LEVEL_ENTITY system_top

# globals

set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
set_global_assignment -name SYNCHRONIZER_IDENTIFICATION AUTO
set_global_assignment -name ENABLE_ADVANCED_IO_TIMING ON
set_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER ON
set_global_assignment -name TIMEQUEST_DO_REPORT_TIMING ON
set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL ON
set_global_assignment -name USE_DLL_FREQUENCY_FOR_DQS_DELAY_CHAIN ON
set_global_assignment -name UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON
set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
set_global_assignment -name ECO_REGENERATE_REPORT ON
set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON
set_global_assignment -name TIMEQUEST_REPORT_SCRIPT $ad_hdl_dir/projects/scripts/adi_tquest.tcl
set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF

# clocks (V11, Y13, E11 - PL 50MHz)
# clocks (E20, D20 - HPS 25MHz)

set_location_assignment PIN_V11 -to sys_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sys_clk

# leds

set_location_assignment PIN_W15  -to gpio_bd[0]
set_location_assignment PIN_AA24 -to gpio_bd[1]
set_location_assignment PIN_V16  -to gpio_bd[2]
set_location_assignment PIN_V15  -to gpio_bd[3]
set_location_assignment PIN_AF26 -to gpio_bd[4]
set_location_assignment PIN_AE26 -to gpio_bd[5]
set_location_assignment PIN_Y16  -to gpio_bd[6]
set_location_assignment PIN_AA23 -to gpio_bd[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[7]

# dip switches

set_location_assignment PIN_Y24 -to gpio_bd[8]
set_location_assignment PIN_W24 -to gpio_bd[9]
set_location_assignment PIN_W21 -to gpio_bd[10]
set_location_assignment PIN_W20 -to gpio_bd[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[11]

# push-buttons

set_location_assignment PIN_AH17 -to gpio_bd[12]
set_location_assignment PIN_AH16 -to gpio_bd[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_bd[13]

# hps gpio

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_gpio_led
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hps_gpio_pb

# uart

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart0_rx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart0_tx
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to uart0_rx
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to uart0_tx

# usb

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

# sdio

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_cmd
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_d[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_d[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_d[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdio_d[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sdio_clk
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sdio_cmd
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sdio_d[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sdio_d[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sdio_d[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sdio_d[3]

# qspi

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_ss0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_io[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_io[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_io[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to qspi_io[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to qspi_ss0
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to qspi_clk
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to qspi_io[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to qspi_io[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to qspi_io[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to qspi_io[3]

# ethernet

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

# gpio-0 (JP1)

set_location_assignment PIN_V12  -to gpio_0[0]
set_location_assignment PIN_E8   -to gpio_0[1]
set_location_assignment PIN_W12  -to gpio_0[2]
set_location_assignment PIN_D11  -to gpio_0[3]
set_location_assignment PIN_D8   -to gpio_0[4]
set_location_assignment PIN_AH13 -to gpio_0[5]
set_location_assignment PIN_AF7  -to gpio_0[6]
set_location_assignment PIN_AH14 -to gpio_0[7]
set_location_assignment PIN_AF4  -to gpio_0[8]
set_location_assignment PIN_AH3  -to gpio_0[9]
set_location_assignment PIN_AD5  -to gpio_0[10]
set_location_assignment PIN_AG14 -to gpio_0[11]
set_location_assignment PIN_AE23 -to gpio_0[12]
set_location_assignment PIN_AE6  -to gpio_0[13]
set_location_assignment PIN_AD23 -to gpio_0[14]
set_location_assignment PIN_AE24 -to gpio_0[15]
set_location_assignment PIN_D12  -to gpio_0[16]
set_location_assignment PIN_AD20 -to gpio_0[17]
set_location_assignment PIN_C12  -to gpio_0[18]
set_location_assignment PIN_AD17 -to gpio_0[19]
set_location_assignment PIN_AC23 -to gpio_0[20]
set_location_assignment PIN_AC22 -to gpio_0[21]
set_location_assignment PIN_Y19  -to gpio_0[22]
set_location_assignment PIN_AB23 -to gpio_0[23]
set_location_assignment PIN_AA19 -to gpio_0[24]
set_location_assignment PIN_W11  -to gpio_0[25]
set_location_assignment PIN_AA18 -to gpio_0[26]
set_location_assignment PIN_W14  -to gpio_0[27]
set_location_assignment PIN_Y18  -to gpio_0[28]
set_location_assignment PIN_Y17  -to gpio_0[29]
set_location_assignment PIN_AB25 -to gpio_0[30]
set_location_assignment PIN_AB26 -to gpio_0[31]
set_location_assignment PIN_Y11  -to gpio_0[32]
set_location_assignment PIN_AA26 -to gpio_0[33]
set_location_assignment PIN_AA13 -to gpio_0[34]
set_location_assignment PIN_AA11 -to gpio_0[35]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[18]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[19]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[20]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[21]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[22]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[23]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[24]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[25]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[26]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[27]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[28]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[29]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[30]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[31]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[32]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[33]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[34]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[35]

# gpio-1 (JP7)

set_location_assignment PIN_Y15  -to gpio_1[0]
set_location_assignment PIN_AC24 -to gpio_1[1]
set_location_assignment PIN_AA15 -to gpio_1[2]
set_location_assignment PIN_AD26 -to gpio_1[3]
set_location_assignment PIN_AG28 -to gpio_1[4]
set_location_assignment PIN_AF28 -to gpio_1[5]
set_location_assignment PIN_AE25 -to gpio_1[6]
set_location_assignment PIN_AF27 -to gpio_1[7]
set_location_assignment PIN_AG26 -to gpio_1[8]
set_location_assignment PIN_AH27 -to gpio_1[9]
set_location_assignment PIN_AG25 -to gpio_1[10]
set_location_assignment PIN_AH26 -to gpio_1[11]
set_location_assignment PIN_AH24 -to gpio_1[12]
set_location_assignment PIN_AF25 -to gpio_1[13]
set_location_assignment PIN_AG23 -to gpio_1[14]
set_location_assignment PIN_AF23 -to gpio_1[15]
set_location_assignment PIN_AG24 -to gpio_1[16]
set_location_assignment PIN_AH22 -to gpio_1[17]
set_location_assignment PIN_AH21 -to gpio_1[18]
set_location_assignment PIN_AG21 -to gpio_1[19]
set_location_assignment PIN_AH23 -to gpio_1[20]
set_location_assignment PIN_AA20 -to gpio_1[21]
set_location_assignment PIN_AF22 -to gpio_1[22]
set_location_assignment PIN_AE22 -to gpio_1[23]
set_location_assignment PIN_AG20 -to gpio_1[24]
set_location_assignment PIN_AF21 -to gpio_1[25]
set_location_assignment PIN_AG19 -to gpio_1[26]
set_location_assignment PIN_AH19 -to gpio_1[27]
set_location_assignment PIN_AG18 -to gpio_1[28]
set_location_assignment PIN_AH18 -to gpio_1[29]
set_location_assignment PIN_AF18 -to gpio_1[30]
set_location_assignment PIN_AF20 -to gpio_1[31]
set_location_assignment PIN_AG15 -to gpio_1[32]          
set_location_assignment PIN_AE20 -to gpio_1[33]
set_location_assignment PIN_AE19 -to gpio_1[34]
set_location_assignment PIN_AE17 -to gpio_1[35]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[18]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[19]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[20]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[21]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[22]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[23]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[24]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[25]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[26]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[27]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[28]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[29]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[30]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[31]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[32]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[33]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[34]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[35]

# arduino (JP2, JP3, JP4 & JP5)

set_location_assignment PIN_AG13 -to arduino_gpio[0]
set_location_assignment PIN_AF13 -to arduino_gpio[1]
set_location_assignment PIN_AG10 -to arduino_gpio[2]
set_location_assignment PIN_AG9  -to arduino_gpio[3]
set_location_assignment PIN_U14  -to arduino_gpio[4]
set_location_assignment PIN_U13  -to arduino_gpio[5]
set_location_assignment PIN_AG8  -to arduino_gpio[6]
set_location_assignment PIN_AH8  -to arduino_spi_csn[3]
set_location_assignment PIN_AF17 -to arduino_spi_csn[2]
set_location_assignment PIN_AE15 -to arduino_spi_csn[1]
set_location_assignment PIN_AF15 -to arduino_spi_csn[0]
set_location_assignment PIN_AG16 -to arduino_spi_mosi
set_location_assignment PIN_AH11 -to arduino_spi_miso
set_location_assignment PIN_AH12 -to arduino_spi_clk
set_location_assignment PIN_AH9  -to arduino_i2c_sda
set_location_assignment PIN_AG11 -to arduino_i2c_scl
set_location_assignment PIN_AH7  -to arduino_reset_n 
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_gpio[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_gpio[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_gpio[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_gpio[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_gpio[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_gpio[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_gpio[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_spi_csn[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_spi_csn[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_spi_csn[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_spi_csn[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_spi_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_i2c_sda
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to arduino_reset_n

# adxl345 (i2c address 0xa6/0xa7) (i2c0)
# scl (C18), sda (A19) & int (A17)

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adxl345_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adxl345_sda
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to adxl345_int

# ltc connector (J17)
# i2c/spi select-gpio (H13,J17.14) (i2c1, spim1)
# sclk (K18,J17.4,J17.11), sda (A21,J17.7,J17.9)
# csn (C16,J17.6), clk (C19,J17.4), mosi (B16,J17.J17.7) & miso (B19,J17.5)

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc_i2c_spi_sel
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc_i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc_i2c_sda
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc_spi_csn
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc_spi_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ltc_spi_miso

# HDMI

set_location_assignment PIN_U10   -to hdmi_i2c_scl
set_location_assignment PIN_AA4   -to hdmi_i2c_sda
set_location_assignment PIN_T13   -to hdmi_i2s
set_location_assignment PIN_T11   -to hdmi_lrclk
set_location_assignment PIN_U11   -to hdmi_mclk
set_location_assignment PIN_T12   -to hdmi_sclk
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
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_i2s
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_lrclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_mclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hdmi_sclk
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
set_location_assignment PIN_V28   -to ddr3_reset_n
set_location_assignment PIN_N21   -to ddr3_ck_p
set_location_assignment PIN_N20   -to ddr3_ck_n
set_location_assignment PIN_L28   -to ddr3_cke
set_location_assignment PIN_L21   -to ddr3_cs_n
set_location_assignment PIN_A25   -to ddr3_ras_n
set_location_assignment PIN_A26   -to ddr3_cas_n
set_location_assignment PIN_E25   -to ddr3_we_n
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
set_location_assignment PIN_G28   -to ddr3_dm[0]
set_location_assignment PIN_P28   -to ddr3_dm[1]
set_location_assignment PIN_W28   -to ddr3_dm[2]
set_location_assignment PIN_AB28  -to ddr3_dm[3]
set_location_assignment PIN_D28   -to ddr3_odt
set_location_assignment PIN_D25   -to ddr3_rzq

execute_flow -compile

