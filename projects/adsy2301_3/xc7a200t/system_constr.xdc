###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

set_property -dict {PACKAGE_PIN Y18  IOSTANDARD DIFF_SSTL18_I} [get_ports clk_125_p]
set_property -dict {PACKAGE_PIN Y19  IOSTANDARD DIFF_SSTL18_I} [get_ports clk_125_n]

# Aurora

set_property -dict {PACKAGE_PIN F6} [get_ports aurora_refclk_p]
set_property -dict {PACKAGE_PIN E6} [get_ports aurora_refclk_n]
set_property -dict {PACKAGE_PIN B4} [get_ports aurora_txp[0]]
set_property -dict {PACKAGE_PIN A4} [get_ports aurora_txn[0]]
set_property -dict {PACKAGE_PIN D5} [get_ports aurora_txp[1]]
set_property -dict {PACKAGE_PIN C5} [get_ports aurora_txn[1]]
set_property -dict {PACKAGE_PIN B8} [get_ports aurora_rxp[0]]
set_property -dict {PACKAGE_PIN A8} [get_ports aurora_rxn[0]]
set_property -dict {PACKAGE_PIN D11} [get_ports aurora_rxp[1]]
set_property -dict {PACKAGE_PIN C11} [get_ports aurora_rxn[1]]

# SPI

set_property -dict {PACKAGE_PIN U21  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_SCLK_01]
set_property -dict {PACKAGE_PIN T21  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_CSB_01]
set_property -dict {PACKAGE_PIN P19  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_MOSI_01]
set_property -dict {PACKAGE_PIN R19  IOSTANDARD LVCMOS18          } [get_ports BF_SPI_MISO_01]

set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_SCLK_02]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_CSB_02]
set_property -dict {PACKAGE_PIN U20  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_MOSI_02]
set_property -dict {PACKAGE_PIN V20  IOSTANDARD LVCMOS18          } [get_ports BF_SPI_MISO_02]

set_property -dict {PACKAGE_PIN H13  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_SCLK_03]
set_property -dict {PACKAGE_PIN J16  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_CSB_03]
set_property -dict {PACKAGE_PIN G13  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_MOSI_03]
set_property -dict {PACKAGE_PIN G15  IOSTANDARD LVCMOS18          } [get_ports BF_SPI_MISO_03]

set_property -dict {PACKAGE_PIN H18  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_SCLK_04]
set_property -dict {PACKAGE_PIN H17  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_CSB_04]
set_property -dict {PACKAGE_PIN J22  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_MOSI_04]
set_property -dict {PACKAGE_PIN H22  IOSTANDARD LVCMOS18          } [get_ports BF_SPI_MISO_04]

set_property -dict {PACKAGE_PIN B15  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RF_FL_SPI_SCLK]
set_property -dict {PACKAGE_PIN F14  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RF_FL_SPI_CSB1]
set_property -dict {PACKAGE_PIN C14  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RF_FL_SPI_CSB2]
set_property -dict {PACKAGE_PIN E14  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RF_FL_SPI_CSB3]
set_property -dict {PACKAGE_PIN D14  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RF_FL_SPI_CSB4]
set_property -dict {PACKAGE_PIN B16  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RF_FL_SPI_MOSI]
set_property -dict {PACKAGE_PIN C13  IOSTANDARD LVCMOS18          } [get_ports RF_FL_SPI_MISO]

set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports LO_SPI_SCLK]
set_property -dict {PACKAGE_PIN E18  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports LO_SPI_CSB]
set_property -dict {PACKAGE_PIN F18  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports LO_SPI_MOSI]
set_property -dict {PACKAGE_PIN D19  IOSTANDARD LVCMOS18          } [get_ports LO_SPI_MISO]

set_property -dict {PACKAGE_PIN B1   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports TX_SPI_SCLK]
set_property -dict {PACKAGE_PIN F19  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports TX_SPI_CSB1]
set_property -dict {PACKAGE_PIN C22  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports TX_SPI_CSB2]
set_property -dict {PACKAGE_PIN E22  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports TX_SPI_CSB3]
set_property -dict {PACKAGE_PIN G21  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports TX_SPI_CSB4]
set_property -dict {PACKAGE_PIN A1   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports TX_SPI_MOSI]
set_property -dict {PACKAGE_PIN F4   IOSTANDARD LVCMOS18          } [get_ports TX_SPI_MISO]

set_property -dict {PACKAGE_PIN M3   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RX_SPI_SCLK]
set_property -dict {PACKAGE_PIN K2   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RX_SPI_CSB1]
set_property -dict {PACKAGE_PIN H3   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RX_SPI_CSB2]
set_property -dict {PACKAGE_PIN K4   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RX_SPI_CSB3]
set_property -dict {PACKAGE_PIN M1   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RX_SPI_CSB4]
set_property -dict {PACKAGE_PIN M2   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports RX_SPI_MOSI]
set_property -dict {PACKAGE_PIN L1   IOSTANDARD LVCMOS18          } [get_ports RX_SPI_MISO]

# set_property -dict {PACKAGE_PIN L12  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports FLASH_SPI_SCLK]
# set_property -dict {PACKAGE_PIN T19  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports FLASH_SPI_CSB]
# set_property -dict {PACKAGE_PIN P22  IOSTANDARD LVCMOS18          } [get_ports FLASH_SPI_DQ0]
# set_property -dict {PACKAGE_PIN R22  IOSTANDARD LVCMOS18          } [get_ports FLASH_SPI_DQ1]
# set_property -dict {PACKAGE_PIN P21  IOSTANDARD LVCMOS18          } [get_ports FLASH_SPI_DQ2]
# set_property -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS18          } [get_ports FLASH_SPI_DQ3]

# I2C

set_property -dict {PACKAGE_PIN J19  IOSTANDARD LVCMOS18 SLEW SLOW PULLUP TRUE} [get_ports UDC_SCL]
set_property -dict {PACKAGE_PIN J21  IOSTANDARD LVCMOS18 SLEW SLOW PULLUP TRUE} [get_ports UDC_SDA]

# GPIO

set_property -dict {PACKAGE_PIN R14  IOSTANDARD LVCMOS18} [get_ports TX_LOAD]
set_property -dict {PACKAGE_PIN Y22  IOSTANDARD LVCMOS18} [get_ports BF_TX_LOAD_01]
set_property -dict {PACKAGE_PIN V17  IOSTANDARD LVCMOS18} [get_ports BF_TX_LOAD_02]
set_property -dict {PACKAGE_PIN H15  IOSTANDARD LVCMOS18} [get_ports BF_TX_LOAD_03]
set_property -dict {PACKAGE_PIN J20  IOSTANDARD LVCMOS18} [get_ports BF_TX_LOAD_04]

set_property -dict {PACKAGE_PIN R18  IOSTANDARD LVCMOS18} [get_ports RX_LOAD]
set_property -dict {PACKAGE_PIN Y21  IOSTANDARD LVCMOS18} [get_ports BF_RX_LOAD_01]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS18} [get_ports BF_RX_LOAD_02]
set_property -dict {PACKAGE_PIN J15  IOSTANDARD LVCMOS18} [get_ports BF_RX_LOAD_03]
set_property -dict {PACKAGE_PIN L21  IOSTANDARD LVCMOS18} [get_ports BF_RX_LOAD_04]

set_property -dict {PACKAGE_PIN P14  IOSTANDARD LVCMOS18} [get_ports TR_PULSE]
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS18} [get_ports BF_TR_01]
set_property -dict {PACKAGE_PIN V19  IOSTANDARD LVCMOS18} [get_ports BF_TR_02]
set_property -dict {PACKAGE_PIN G17  IOSTANDARD LVCMOS18} [get_ports BF_TR_03]
set_property -dict {PACKAGE_PIN K22  IOSTANDARD LVCMOS18} [get_ports BF_TR_04]

set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS18} [get_ports BF_PA_ON_01]
set_property -dict {PACKAGE_PIN W22  IOSTANDARD LVCMOS18} [get_ports BF_PWR_EN_01]
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS18} [get_ports VGG_PA_PG_N1]

set_property -dict {PACKAGE_PIN AA19 IOSTANDARD LVCMOS18} [get_ports BF_PA_ON_02]
set_property -dict {PACKAGE_PIN W19  IOSTANDARD LVCMOS18} [get_ports BF_PWR_EN_02]
set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS18} [get_ports VGG_PA_PG_N2]

set_property -dict {PACKAGE_PIN G18  IOSTANDARD LVCMOS18} [get_ports BF_PA_ON_03]
set_property -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS18} [get_ports BF_PWR_EN_03]
set_property -dict {PACKAGE_PIN U17  IOSTANDARD LVCMOS18} [get_ports VGG_PA_PG_N3]

set_property -dict {PACKAGE_PIN M21  IOSTANDARD LVCMOS18} [get_ports BF_PA_ON_04]
set_property -dict {PACKAGE_PIN P15  IOSTANDARD LVCMOS18} [get_ports BF_PWR_EN_04]
set_property -dict {PACKAGE_PIN U18  IOSTANDARD LVCMOS18} [get_ports VGG_PA_PG_N4]

set_property -dict {PACKAGE_PIN F15  IOSTANDARD LVCMOS18} [get_ports ADRF5030_CTRL1]
set_property -dict {PACKAGE_PIN F16  IOSTANDARD LVCMOS18} [get_ports ADRF5030_CTRL2]
set_property -dict {PACKAGE_PIN C15  IOSTANDARD LVCMOS18} [get_ports ADRF5030_CTRL3]
set_property -dict {PACKAGE_PIN E16  IOSTANDARD LVCMOS18} [get_ports ADRF5030_CTRL4]
set_property -dict {PACKAGE_PIN F13  IOSTANDARD LVCMOS18} [get_ports ADRF5030_EN1]
set_property -dict {PACKAGE_PIN E17  IOSTANDARD LVCMOS18} [get_ports ADRF5030_EN2]
set_property -dict {PACKAGE_PIN E13  IOSTANDARD LVCMOS18} [get_ports ADRF5030_EN3]
set_property -dict {PACKAGE_PIN D16  IOSTANDARD LVCMOS18} [get_ports ADRF5030_EN4]

set_property -dict {PACKAGE_PIN D15  IOSTANDARD LVCMOS18} [get_ports RF_FL_LDO_EN]
set_property -dict {PACKAGE_PIN B13  IOSTANDARD LVCMOS18} [get_ports RF_FL_SFL]
set_property -dict {PACKAGE_PIN A15  IOSTANDARD LVCMOS18} [get_ports RF_FL_PS_N]
set_property -dict {PACKAGE_PIN A16  IOSTANDARD LVCMOS18} [get_ports RF_FL_RST_N]
set_property -dict {PACKAGE_PIN A13  IOSTANDARD LVCMOS18} [get_ports RF_FL_HPF[0]]
set_property -dict {PACKAGE_PIN A14  IOSTANDARD LVCMOS18} [get_ports RF_FL_HPF[1]]
set_property -dict {PACKAGE_PIN B17  IOSTANDARD LVCMOS18} [get_ports RF_FL_HPF[2]]
set_property -dict {PACKAGE_PIN B18  IOSTANDARD LVCMOS18} [get_ports RF_FL_HPF[3]]
set_property -dict {PACKAGE_PIN D17  IOSTANDARD LVCMOS18} [get_ports RF_FL_LPF[0]]
set_property -dict {PACKAGE_PIN C17  IOSTANDARD LVCMOS18} [get_ports RF_FL_LPF[1]]
set_property -dict {PACKAGE_PIN C18  IOSTANDARD LVCMOS18} [get_ports RF_FL_LPF[2]]
set_property -dict {PACKAGE_PIN C19  IOSTANDARD LVCMOS18} [get_ports RF_FL_LPF[3]]

set_property -dict {PACKAGE_PIN B20  IOSTANDARD LVCMOS18} [get_ports LO_CE]

set_property -dict {PACKAGE_PIN A20  IOSTANDARD LVCMOS18} [get_ports TX_CEN1]
set_property -dict {PACKAGE_PIN A18  IOSTANDARD LVCMOS18} [get_ports TX_LOAD1]
set_property -dict {PACKAGE_PIN A19  IOSTANDARD LVCMOS18} [get_ports TX_RSTB1]
set_property -dict {PACKAGE_PIN F20  IOSTANDARD LVCMOS18} [get_ports TX_CEN2]
set_property -dict {PACKAGE_PIN D20  IOSTANDARD LVCMOS18} [get_ports TX_LOAD2]
set_property -dict {PACKAGE_PIN C20  IOSTANDARD LVCMOS18} [get_ports TX_RSTB2]
set_property -dict {PACKAGE_PIN B22  IOSTANDARD LVCMOS18} [get_ports TX_CEN3]
set_property -dict {PACKAGE_PIN B21  IOSTANDARD LVCMOS18} [get_ports TX_LOAD3]
set_property -dict {PACKAGE_PIN A21  IOSTANDARD LVCMOS18} [get_ports TX_RSTB3]
set_property -dict {PACKAGE_PIN D22  IOSTANDARD LVCMOS18} [get_ports TX_CEN4]
set_property -dict {PACKAGE_PIN E21  IOSTANDARD LVCMOS18} [get_ports TX_LOAD4]
set_property -dict {PACKAGE_PIN D21  IOSTANDARD LVCMOS18} [get_ports TX_RSTB4]

set_property -dict {PACKAGE_PIN J1   IOSTANDARD LVCMOS18} [get_ports RX_CEN1]
set_property -dict {PACKAGE_PIN H2   IOSTANDARD LVCMOS18} [get_ports RX_LOAD1]
set_property -dict {PACKAGE_PIN G2   IOSTANDARD LVCMOS18} [get_ports RX_RSTB1]
set_property -dict {PACKAGE_PIN J2   IOSTANDARD LVCMOS18} [get_ports RX_CEN2]
set_property -dict {PACKAGE_PIN J5   IOSTANDARD LVCMOS18} [get_ports RX_LOAD2]
set_property -dict {PACKAGE_PIN H5   IOSTANDARD LVCMOS18} [get_ports RX_RSTB2]
set_property -dict {PACKAGE_PIN G3   IOSTANDARD LVCMOS18} [get_ports RX_CEN3]
set_property -dict {PACKAGE_PIN H4   IOSTANDARD LVCMOS18} [get_ports RX_LOAD3]
set_property -dict {PACKAGE_PIN G4   IOSTANDARD LVCMOS18} [get_ports RX_RSTB3]
set_property -dict {PACKAGE_PIN J4   IOSTANDARD LVCMOS18} [get_ports RX_CEN4]
set_property -dict {PACKAGE_PIN L3   IOSTANDARD LVCMOS18} [get_ports RX_LOAD4]
set_property -dict {PACKAGE_PIN K3   IOSTANDARD LVCMOS18} [get_ports RX_RSTB4]

set_property -dict {PACKAGE_PIN L4   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDF[0]]
set_property -dict {PACKAGE_PIN N4   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDF[1]]
set_property -dict {PACKAGE_PIN N3   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDF[2]]
set_property -dict {PACKAGE_PIN R1   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDF[3]]
set_property -dict {PACKAGE_PIN P1   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDF[4]]
set_property -dict {PACKAGE_PIN P5   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDG[0]]
set_property -dict {PACKAGE_PIN P4   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDG[1]]
set_property -dict {PACKAGE_PIN P2   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDG[2]]
set_property -dict {PACKAGE_PIN N2   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDG[3]]
set_property -dict {PACKAGE_PIN M6   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDG[4]]
set_property -dict {PACKAGE_PIN M5   IOSTANDARD LVCMOS18} [get_ports ADMVXX20_ADDG[5]]

set_property -dict {PACKAGE_PIN W17  IOSTANDARD LVCMOS18} [get_ports N6P0V_EN]
set_property -dict {PACKAGE_PIN L19  IOSTANDARD LVCMOS18} [get_ports UDC_NEG_PWR_EN]
set_property -dict {PACKAGE_PIN L20  IOSTANDARD LVCMOS18} [get_ports UDC_3P3V_PWR_EN]
set_property -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS18} [get_ports UDC_5P0V_PWR_EN]
set_property -dict {PACKAGE_PIN H19  IOSTANDARD LVCMOS18} [get_ports PG_CARRIER]
set_property -dict {PACKAGE_PIN K18  IOSTANDARD LVCMOS18} [get_ports GT_PGOOD_1V]
set_property -dict {PACKAGE_PIN K19  IOSTANDARD LVCMOS18} [get_ports UDC_PG]
set_property -dict {PACKAGE_PIN M22  IOSTANDARD LVCMOS18} [get_ports N6P0V_PG]
set_property -dict {PACKAGE_PIN K1   IOSTANDARD LVCMOS18} [get_ports UDC_5P0V_LDO_PG]
set_property -dict {PACKAGE_PIN E1   IOSTANDARD LVCMOS18} [get_ports UDC_3P3V_LDO_PG]

set_property -dict {PACKAGE_PIN D1   IOSTANDARD LVCMOS18} [get_ports UDC_ALERT_N_LTC2945]
set_property -dict {PACKAGE_PIN E2   IOSTANDARD LVCMOS18} [get_ports FPGA_TRIG]
set_property -dict {PACKAGE_PIN K6   IOSTANDARD LVCMOS18} [get_ports DELSTR]
set_property -dict {PACKAGE_PIN J6   IOSTANDARD LVCMOS18} [get_ports DELADJ]
set_property -dict {PACKAGE_PIN L5   IOSTANDARD LVCMOS18} [get_ports MUXOUT]

create_clock -period 6.400 -name aurora_refclk [get_ports aurora_refclk_p]

create_generated_clock -name sys_clk [get_pins i_system_wrapper/system_i/clk_wizard/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name spi_clk [get_pins i_system_wrapper/system_i/clk_wizard/inst/mmcm_adv_inst/CLKOUT1]

set trce_dly_max   0.900; # maximum board trace delay
set trce_dly_min   0.800; # minimum board trace delay

# BF SPI 01

create_generated_clock -name BF_SPI_SCLK_01 -source [get_pins -of_objects [get_clocks spi_clk]] -divide_by 2 [get_ports BF_SPI_SCLK_01]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_01 BF_SPI_MOSI_01]]; # list of output ports
set_output_delay -clock [get_clocks spi_clk] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks spi_clk] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_01]; # list of input ports
set_input_delay -clock [get_clocks spi_clk] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks spi_clk] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 02

create_generated_clock -name BF_SPI_SCLK_02 -source [get_pins -of_objects [get_clocks spi_clk]] -divide_by 2 [get_ports BF_SPI_SCLK_02]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_02 BF_SPI_MOSI_02]]; # list of output ports
set_output_delay -clock [get_clocks spi_clk] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks spi_clk] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_02]; # list of input ports
set_input_delay -clock [get_clocks spi_clk] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks spi_clk] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 03

create_generated_clock -name BF_SPI_SCLK_03 -source [get_pins -of_objects [get_clocks spi_clk]] -divide_by 2 [get_ports BF_SPI_SCLK_03]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_03 BF_SPI_MOSI_03]]; # list of output ports
set_output_delay -clock [get_clocks spi_clk] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks spi_clk] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_03]; # list of input ports
set_input_delay -clock [get_clocks spi_clk] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks spi_clk] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 04

create_generated_clock -name BF_SPI_SCLK_04 -source [get_pins -of_objects [get_clocks spi_clk]] -divide_by 2 [get_ports BF_SPI_SCLK_04]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_04 BF_SPI_MOSI_04]]; # list of output ports
set_output_delay -clock [get_clocks spi_clk] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks spi_clk] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_04]; # list of input ports
set_input_delay -clock [get_clocks spi_clk] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks spi_clk] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# RF FL SPI

create_generated_clock -name RF_FL_SPI_SCLK -source [get_pins -of_objects [get_clocks spi_clk]] -divide_by 2 [get_ports RF_FL_SPI_SCLK]
set tsu          5.000;      # destination device setup time requirement
set thd          2.000;      # destination device hold time requirement
set output_ports [get_ports [list RF_FL_SPI_CSB1 RF_FL_SPI_CSB2 RF_FL_SPI_CSB3 RF_FL_SPI_CSB4 RF_FL_SPI_MOSI]]; # list of output ports
set_output_delay -clock [get_clocks spi_clk] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks spi_clk] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     6.000;     # Maximum clock to out delay
set tco_min     6.000;     # Minimum clock to out delay
set input_ports [get_ports RF_FL_SPI_MISO]; # list of input ports
set_input_delay -clock [get_clocks spi_clk] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks spi_clk] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# LO SPI

create_generated_clock -name LO_SPI_SCLK -source [get_pins -of_objects [get_clocks spi_clk]] -divide_by 2 [get_ports LO_SPI_SCLK]
set tsu          4.000;      # destination device setup time requirement
set thd          2.000;      # destination device hold time requirement
set output_ports [get_ports [list LO_SPI_CSB LO_SPI_MOSI]]; # list of output ports
set_output_delay -clock [get_clocks spi_clk] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks spi_clk] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     6.000;     # Maximum clock to out delay
set tco_min     6.000;     # Minimum clock to out delay
set input_ports [get_ports LO_SPI_MISO]; # list of input ports
set_input_delay -clock [get_clocks spi_clk] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks spi_clk] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# TX SPI

create_generated_clock -name TX_SPI_SCLK -source [get_pins -of_objects [get_clocks spi_clk]] -divide_by 2 [get_ports TX_SPI_SCLK]
set tsu          3.000;      # destination device setup time requirement
set thd          2.000;      # destination device hold time requirement
set output_ports [get_ports [list TX_SPI_CSB1 TX_SPI_CSB2 TX_SPI_CSB3 TX_SPI_CSB4 TX_SPI_MOSI]]; # list of output ports
set_output_delay -clock [get_clocks spi_clk] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks spi_clk] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     4.000;     # Maximum clock to out delay
set tco_min     4.000;     # Minimum clock to out delay
set input_ports [get_ports TX_SPI_MISO]; # list of input ports
set_input_delay -clock [get_clocks spi_clk] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks spi_clk] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# RX SPI

create_generated_clock -name RX_SPI_SCLK -source [get_pins -of_objects [get_clocks spi_clk]] -divide_by 2 [get_ports RX_SPI_SCLK]
set tsu          3.000;      # destination device setup time requirement
set thd          2.000;      # destination device hold time requirement
set output_ports [get_ports [list RX_SPI_CSB1 RX_SPI_CSB2 RX_SPI_CSB3 RX_SPI_CSB4 RX_SPI_MOSI]]; # list of output ports
set_output_delay -clock [get_clocks spi_clk] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks spi_clk] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     4.000;     # Maximum clock to out delay
set tco_min     4.000;     # Minimum clock to out delay
set input_ports [get_ports RX_SPI_MISO]; # list of input ports
set_input_delay -clock [get_clocks spi_clk] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks spi_clk] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# FLASH SPI

# create_generated_clock -name FLASH_SPI_SCLK -source [get_pins -of_objects [get_clocks spi_clk]] -divide_by 2 [get_ports FLASH_SPI_SCLK]
# set tsu          2.000;      # destination device setup time requirement
# set thd          2.000;      # destination device hold time requirement
# set output_ports [get_ports [list FLASH_SPI_CSB FLASH_SPI_DQ0]]; # list of output ports
# set_output_delay -clock [get_clocks spi_clk] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
# set_output_delay -clock [get_clocks spi_clk] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
# set tco_max     10.000;     # Maximum clock to out delay
# set tco_min     10.000;     # Minimum clock to out delay
# set input_ports [get_ports FLASH_SPI_DQ1]; # list of input ports
# set_input_delay -clock [get_clocks spi_clk] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
# set_input_delay -clock [get_clocks spi_clk] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# IIC

create_generated_clock -name UDC_SCL -source [get_pins -of_objects [get_clocks sys_clk]] -divide_by 1000 [get_ports UDC_SCL]

set_false_path -from [get_ports UDC_SDA]
set_false_path -to   [get_ports UDC_SDA]

# GPIO

set_false_path -from [get_ports TX_LOAD]
set_false_path -to   [get_ports BF_TX_LOAD_01]
set_false_path -to   [get_ports BF_TX_LOAD_02]
set_false_path -to   [get_ports BF_TX_LOAD_03]
set_false_path -to   [get_ports BF_TX_LOAD_04]

set_false_path -from [get_ports RX_LOAD]
set_false_path -to   [get_ports BF_RX_LOAD_01]
set_false_path -to   [get_ports BF_RX_LOAD_02]
set_false_path -to   [get_ports BF_RX_LOAD_03]
set_false_path -to   [get_ports BF_RX_LOAD_04]

set_false_path -from [get_ports TR_PULSE]
set_false_path -to   [get_ports BF_TR_01]
set_false_path -to   [get_ports BF_TR_02]
set_false_path -to   [get_ports BF_TR_03]
set_false_path -to   [get_ports BF_TR_04]

set_false_path -to   [get_ports BF_PA_ON_01]
set_false_path -from [get_ports BF_PWR_EN_01]
set_false_path -from [get_ports VGG_PA_PG_N1]

set_false_path -to   [get_ports BF_PA_ON_02]
set_false_path -from [get_ports BF_PWR_EN_02]
set_false_path -from [get_ports VGG_PA_PG_N2]

set_false_path -to   [get_ports BF_PA_ON_03]
set_false_path -from [get_ports BF_PWR_EN_03]
set_false_path -from [get_ports VGG_PA_PG_N3]

set_false_path -to   [get_ports BF_PA_ON_04]
set_false_path -from [get_ports BF_PWR_EN_04]
set_false_path -from [get_ports VGG_PA_PG_N4]

set_false_path -to   [get_ports ADRF5030_CTRL1]
set_false_path -to   [get_ports ADRF5030_CTRL2]
set_false_path -to   [get_ports ADRF5030_CTRL3]
set_false_path -to   [get_ports ADRF5030_CTRL4]
set_false_path -to   [get_ports ADRF5030_EN1]
set_false_path -to   [get_ports ADRF5030_EN2]
set_false_path -to   [get_ports ADRF5030_EN3]
set_false_path -to   [get_ports ADRF5030_EN4]

set_false_path -to   [get_ports RF_FL_LDO_EN]
set_false_path -to   [get_ports RF_FL_SFL]
set_false_path -to   [get_ports RF_FL_PS_N]
set_false_path -to   [get_ports RF_FL_RST_N]
set_false_path -to   [get_ports RF_FL_HPF[0]]
set_false_path -to   [get_ports RF_FL_HPF[1]]
set_false_path -to   [get_ports RF_FL_HPF[2]]
set_false_path -to   [get_ports RF_FL_HPF[3]]
set_false_path -to   [get_ports RF_FL_LPF[0]]
set_false_path -to   [get_ports RF_FL_LPF[1]]
set_false_path -to   [get_ports RF_FL_LPF[2]]
set_false_path -to   [get_ports RF_FL_LPF[3]]

set_false_path -to   [get_ports LO_CE]
set_false_path -to   [get_ports DELSTR]
set_false_path -to   [get_ports DELADJ]
set_false_path -from [get_ports MUXOUT]

set_false_path -to   [get_ports TX_CEN1]
set_false_path -to   [get_ports TX_LOAD1]
set_false_path -to   [get_ports TX_RSTB1]
set_false_path -to   [get_ports TX_CEN2]
set_false_path -to   [get_ports TX_LOAD2]
set_false_path -to   [get_ports TX_RSTB2]
set_false_path -to   [get_ports TX_CEN3]
set_false_path -to   [get_ports TX_LOAD3]
set_false_path -to   [get_ports TX_RSTB3]
set_false_path -to   [get_ports TX_CEN4]
set_false_path -to   [get_ports TX_LOAD4]
set_false_path -to   [get_ports TX_RSTB4]

set_false_path -to   [get_ports RX_CEN1]
set_false_path -to   [get_ports RX_LOAD1]
set_false_path -to   [get_ports RX_RSTB1]
set_false_path -to   [get_ports RX_CEN2]
set_false_path -to   [get_ports RX_LOAD2]
set_false_path -to   [get_ports RX_RSTB2]
set_false_path -to   [get_ports RX_CEN3]
set_false_path -to   [get_ports RX_LOAD3]
set_false_path -to   [get_ports RX_RSTB3]
set_false_path -to   [get_ports RX_CEN4]
set_false_path -to   [get_ports RX_LOAD4]
set_false_path -to   [get_ports RX_RSTB4]

set_false_path -to   [get_ports ADMVXX20_ADDF[0]]
set_false_path -to   [get_ports ADMVXX20_ADDF[1]]
set_false_path -to   [get_ports ADMVXX20_ADDF[2]]
set_false_path -to   [get_ports ADMVXX20_ADDF[3]]
set_false_path -to   [get_ports ADMVXX20_ADDF[4]]
set_false_path -to   [get_ports ADMVXX20_ADDG[0]]
set_false_path -to   [get_ports ADMVXX20_ADDG[1]]
set_false_path -to   [get_ports ADMVXX20_ADDG[2]]
set_false_path -to   [get_ports ADMVXX20_ADDG[3]]
set_false_path -to   [get_ports ADMVXX20_ADDG[4]]
set_false_path -to   [get_ports ADMVXX20_ADDG[5]]

set_false_path -to   [get_ports N6P0V_EN]
set_false_path -to   [get_ports UDC_NEG_PWR_EN]
set_false_path -to   [get_ports UDC_3P3V_PWR_EN]
set_false_path -to   [get_ports UDC_5P0V_PWR_EN]
set_false_path -from [get_ports PG_CARRIER]
set_false_path -from [get_ports GT_PGOOD_1V]
set_false_path -from [get_ports UDC_PG]
set_false_path -from [get_ports N6P0V_PG]
set_false_path -from [get_ports UDC_ALERT_N_LTC2945]
set_false_path -from [get_ports FPGA_TRIG]
set_false_path -from [get_ports UDC_5P0V_LDO_PG]
set_false_path -from [get_ports UDC_3P3V_LDO_PG]

set_property IOB TRUE [get_cells gpio_tx_load_reg[*]]
set_property IOB TRUE [get_cells gpio_rx_load_reg[*]]
set_property IOB TRUE [get_cells gpio_tr_pulse_reg[*]]
