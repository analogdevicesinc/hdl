###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property PACKAGE_PIN V10    [get_ports ref_clk_c_p];
set_property PACKAGE_PIN V9     [get_ports ref_clk_c_n];

set_property PACKAGE_PIN Y2 [get_ports {rx_data_c_p[0]}]
set_property PACKAGE_PIN Y1 [get_ports {rx_data_c_n[0]}]
set_property PACKAGE_PIN W4 [get_ports {rx_data_c_p[1]}]
set_property PACKAGE_PIN W3 [get_ports {rx_data_c_n[1]}]
set_property PACKAGE_PIN V2 [get_ports {rx_data_c_p[2]}]
set_property PACKAGE_PIN V1 [get_ports {rx_data_c_n[2]}]
set_property PACKAGE_PIN U4 [get_ports {rx_data_c_p[3]}]
set_property PACKAGE_PIN U3 [get_ports {rx_data_c_n[3]}]
set_property PACKAGE_PIN Y6 [get_ports {tx_data_c_p[0]}]
set_property PACKAGE_PIN Y5 [get_ports {tx_data_c_n[0]}]
set_property PACKAGE_PIN W8 [get_ports {tx_data_c_p[1]}]
set_property PACKAGE_PIN W7 [get_ports {tx_data_c_n[1]}]
set_property PACKAGE_PIN V6 [get_ports {tx_data_c_p[2]}]
set_property PACKAGE_PIN V5 [get_ports {tx_data_c_n[2]}]
set_property PACKAGE_PIN U8 [get_ports {tx_data_c_p[3]}]
set_property PACKAGE_PIN U7 [get_ports {tx_data_c_n[3]}]

set_property PACKAGE_PIN W12 [get_ports ref_clk_d_p]
set_property PACKAGE_PIN W11 [get_ports ref_clk_d_n]

set_property PACKAGE_PIN T2 [get_ports {rx_data_d_p[0]}]
set_property PACKAGE_PIN T1 [get_ports {rx_data_d_n[0]}]
set_property PACKAGE_PIN R4 [get_ports {rx_data_d_p[1]}]
set_property PACKAGE_PIN R3 [get_ports {rx_data_d_n[1]}]
set_property PACKAGE_PIN P2 [get_ports {rx_data_d_p[2]}]
set_property PACKAGE_PIN P1 [get_ports {rx_data_d_n[2]}]
set_property PACKAGE_PIN N4 [get_ports {rx_data_d_p[3]}]
set_property PACKAGE_PIN N3 [get_ports {rx_data_d_n[3]}]
set_property PACKAGE_PIN T6 [get_ports {tx_data_d_p[0]}]
set_property PACKAGE_PIN T5 [get_ports {tx_data_d_n[0]}]
set_property PACKAGE_PIN R8 [get_ports {tx_data_d_p[1]}]
set_property PACKAGE_PIN R7 [get_ports {tx_data_d_n[1]}]
set_property PACKAGE_PIN P6 [get_ports {tx_data_d_p[2]}]
set_property PACKAGE_PIN P5 [get_ports {tx_data_d_n[2]}]
set_property PACKAGE_PIN N8 [get_ports {tx_data_d_p[3]}]
set_property PACKAGE_PIN N7 [get_ports {tx_data_d_n[3]}]

set_property -dict {PACKAGE_PIN AP25  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports core_clk_c_p]
set_property -dict {PACKAGE_PIN AP26  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports core_clk_c_n]
set_property -dict {PACKAGE_PIN AP24  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports core_clk_d_p]
set_property -dict {PACKAGE_PIN AR24  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports core_clk_d_n]

set_property -dict {PACKAGE_PIN H36  IOSTANDARD LVDS} [get_ports rx_sync_c_p]
set_property -dict {PACKAGE_PIN H37  IOSTANDARD LVDS} [get_ports rx_sync_c_n]
set_property -dict {PACKAGE_PIN AH24 IOSTANDARD LVDS} [get_ports rx_os_sync_c_p]
set_property -dict {PACKAGE_PIN AJ24 IOSTANDARD LVDS} [get_ports rx_os_sync_c_n]
set_property -dict {PACKAGE_PIN C38  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_c_p]
set_property -dict {PACKAGE_PIN C39  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_c_n]
set_property -dict {PACKAGE_PIN J32  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_c_1_p]
set_property -dict {PACKAGE_PIN H33  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_c_1_n]
set_property -dict {PACKAGE_PIN AN23 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_c_p]
set_property -dict {PACKAGE_PIN AN24 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_c_n]

set_property -dict {PACKAGE_PIN AG22 IOSTANDARD LVCMOS18} [get_ports adrv9009_tx1_enable_c]
set_property -dict {PACKAGE_PIN AG23 IOSTANDARD LVCMOS18} [get_ports adrv9009_tx2_enable_c]
set_property -dict {PACKAGE_PIN AH22 IOSTANDARD LVCMOS18} [get_ports adrv9009_rx1_enable_c]
set_property -dict {PACKAGE_PIN AJ22 IOSTANDARD LVCMOS18} [get_ports adrv9009_rx2_enable_c]
set_property -dict {PACKAGE_PIN H31  IOSTANDARD LVCMOS18} [get_ports adrv9009_reset_b_c]
set_property -dict {PACKAGE_PIN C37  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpint_c]
set_property -dict {PACKAGE_PIN E32  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_00_c]
set_property -dict {PACKAGE_PIN A32  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_01_c]
set_property -dict {PACKAGE_PIN D32  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_02_c]
set_property -dict {PACKAGE_PIN AW26 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_03_c]
set_property -dict {PACKAGE_PIN AR25 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_04_c]
set_property -dict {PACKAGE_PIN AR22 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_05_c]
set_property -dict {PACKAGE_PIN E35  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_06_c]
set_property -dict {PACKAGE_PIN AK22 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_07_c]
set_property -dict {PACKAGE_PIN G33  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_08_c]

set_property -dict {PACKAGE_PIN F37  IOSTANDARD LVDS} [get_ports rx_sync_d_p]
set_property -dict {PACKAGE_PIN E37  IOSTANDARD LVDS} [get_ports rx_sync_d_n]
set_property -dict {PACKAGE_PIN AM23 IOSTANDARD LVDS} [get_ports rx_os_sync_d_p]
set_property -dict {PACKAGE_PIN AM24 IOSTANDARD LVDS} [get_ports rx_os_sync_d_n]
set_property -dict {PACKAGE_PIN B33  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_d_p]
set_property -dict {PACKAGE_PIN B34  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_d_n]
set_property -dict {PACKAGE_PIN H38  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_d_1_p]
set_property -dict {PACKAGE_PIN H39  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_d_1_n]
set_property -dict {PACKAGE_PIN AN22 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_d_p]
set_property -dict {PACKAGE_PIN AP22 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_d_n]

set_property -dict {PACKAGE_PIN E39  IOSTANDARD LVCMOS18} [get_ports adrv9009_tx1_enable_d]
set_property -dict {PACKAGE_PIN D39  IOSTANDARD LVCMOS18} [get_ports adrv9009_tx2_enable_d]
set_property -dict {PACKAGE_PIN G38  IOSTANDARD LVCMOS18} [get_ports adrv9009_rx1_enable_d]
set_property -dict {PACKAGE_PIN G39  IOSTANDARD LVCMOS18} [get_ports adrv9009_rx2_enable_d]
set_property -dict {PACKAGE_PIN H32  IOSTANDARD LVCMOS18} [get_ports adrv9009_reset_b_d]
set_property -dict {PACKAGE_PIN B38  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpint_d]
set_property -dict {PACKAGE_PIN E33  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_00_d]
set_property -dict {PACKAGE_PIN A33  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_01_d]
set_property -dict {PACKAGE_PIN C32  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_02_d]
set_property -dict {PACKAGE_PIN AW27 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_03_d]
set_property -dict {PACKAGE_PIN AT25 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_04_d]
set_property -dict {PACKAGE_PIN AT22 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_05_d]
set_property -dict {PACKAGE_PIN D35  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_06_d]
set_property -dict {PACKAGE_PIN AK23 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_07_d]
set_property -dict {PACKAGE_PIN G34  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_08_d]

set_property -dict {PACKAGE_PIN AK24 IOSTANDARD LVCMOS18} [get_ports hmc7044_fmc_reset]
set_property -dict {PACKAGE_PIN AK25 IOSTANDARD LVCMOS18} [get_ports hmc7044_fmc_sync]
set_property -dict {PACKAGE_PIN AL25 IOSTANDARD LVCMOS18} [get_ports hmc7044_fmc_gpio_1]
set_property -dict {PACKAGE_PIN AM25 IOSTANDARD LVCMOS18} [get_ports hmc7044_fmc_gpio_2]
set_property -dict {PACKAGE_PIN AW24 IOSTANDARD LVCMOS18} [get_ports hmc7044_fmc_gpio_3]
set_property -dict {PACKAGE_PIN AW25 IOSTANDARD LVCMOS18} [get_ports hmc7044_fmc_gpio_4]

set_property -dict {PACKAGE_PIN F38 IOSTANDARD LVCMOS18}  [get_ports spi_fmc_clk]
set_property -dict {PACKAGE_PIN A38 IOSTANDARD LVCMOS18}  [get_ports spi_fmc_sdio]
set_property -dict {PACKAGE_PIN A37 IOSTANDARD LVCMOS18}  [get_ports spi_fmc_miso]

set_property -dict {PACKAGE_PIN AJ25 IOSTANDARD LVCMOS18}  [get_ports spi_csn_adrv9009_c]
set_property -dict {PACKAGE_PIN AL22 IOSTANDARD LVCMOS18}  [get_ports spi_csn_adrv9009_d]
set_property -dict {PACKAGE_PIN E38  IOSTANDARD LVCMOS18}  [get_ports spi_csn_fmc_hmc7044]

create_clock -name tx_fmc_dev_clk        -period  4.00 [get_ports core_clk_c_p]
create_clock -name rx_fmc_dev_clk        -period  4.00 [get_ports core_clk_d_p]
create_clock -name jesd_tx_fmc_ref_clk   -period  4.00 [get_ports ref_clk_c_p]
create_clock -name jesd_rx_fmc_ref_clk   -period  4.00 [get_ports ref_clk_d_p]

set_input_delay -clock rx_fmc_dev_clk -max 4    [get_ports sysref_c_p];
set_input_delay -clock rx_fmc_dev_clk -min 4    [get_ports sysref_c_p];

set_input_delay -clock tx_fmc_dev_clk -max 4    [get_ports sysref_d_p];
set_input_delay -clock tx_fmc_dev_clk -min 4    [get_ports sysref_d_p];

create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]
