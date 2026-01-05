###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# FMC HPC0
set_property -dict {PACKAGE_PIN V2   IOSTANDARD LVCMOS18} [get_ports BF_TR_01]
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVCMOS18} [get_ports BF_TX_LOAD_01]
set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVCMOS18} [get_ports BF_RX_LOAD_01]
set_property -dict {PACKAGE_PIN Y4   IOSTANDARD LVCMOS18} [get_ports BF_PA_ON_01]
set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVCMOS18} [get_ports BF_TR_02]
set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS18} [get_ports BF_TX_LOAD_02]
set_property -dict {PACKAGE_PIN U5   IOSTANDARD LVCMOS18} [get_ports BF_RX_LOAD_02]
set_property -dict {PACKAGE_PIN AA2 IOSTANDARD LVCMOS18} [get_ports BF_PA_ON_02]
set_property -dict {PACKAGE_PIN L12  IOSTANDARD LVCMOS18} [get_ports BF_TR_03]
set_property -dict {PACKAGE_PIN M13  IOSTANDARD LVCMOS18} [get_ports BF_TX_LOAD_03]
set_property -dict {PACKAGE_PIN K16  IOSTANDARD LVCMOS18} [get_ports BF_RX_LOAD_03]
set_property -dict {PACKAGE_PIN N9   IOSTANDARD LVCMOS18} [get_ports BF_PA_ON_03]
set_property -dict {PACKAGE_PIN V8   IOSTANDARD LVCMOS18} [get_ports BF_TR_04]
set_property -dict {PACKAGE_PIN V6   IOSTANDARD LVCMOS18} [get_ports BF_TX_LOAD_04]
set_property -dict {PACKAGE_PIN U6   IOSTANDARD LVCMOS18} [get_ports BF_RX_LOAD_04]
set_property -dict {PACKAGE_PIN L10  IOSTANDARD LVCMOS18} [get_ports BF_PA_ON_04]
set_property -dict {PACKAGE_PIN P12  IOSTANDARD LVCMOS18} [get_ports XUD_RX_GAIN_MODE]
set_property -dict {PACKAGE_PIN M11  IOSTANDARD LVCMOS18} [get_ports XUD_PLL_OUTPUT_SEL]
set_property -dict {PACKAGE_PIN M10  IOSTANDARD LVCMOS18} [get_ports XUD_TXRX0]
set_property -dict {PACKAGE_PIN K15  IOSTANDARD LVCMOS18} [get_ports XUD_TXRX1]
set_property -dict {PACKAGE_PIN L15  IOSTANDARD LVCMOS18} [get_ports XUD_TXRX2]
set_property -dict {PACKAGE_PIN L11  IOSTANDARD LVCMOS18} [get_ports XUD_TXRX3]
set_property -dict {PACKAGE_PIN W2   IOSTANDARD LVCMOS18} [get_ports BF_ALARM_TS_01]
set_property -dict {PACKAGE_PIN V3   IOSTANDARD LVCMOS18} [get_ports BF_ALARM_TS_02]
set_property -dict {PACKAGE_PIN V4   IOSTANDARD LVCMOS18} [get_ports BF_ALARM_TS_03]
set_property -dict {PACKAGE_PIN W1   IOSTANDARD LVCMOS18} [get_ports BF_ALARM_TS_04]

set_property -dict {PACKAGE_PIN AC4  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_SCLK_01]
set_property -dict {PACKAGE_PIN W5   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_CSB_01]
set_property -dict {PACKAGE_PIN Y3   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_MOSI_01]
set_property -dict {PACKAGE_PIN AB4  IOSTANDARD LVCMOS18          } [get_ports BF_SPI_MISO_01]

set_property -dict {PACKAGE_PIN AC3  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_SCLK_02]
set_property -dict {PACKAGE_PIN W7   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_CSB_02]
set_property -dict {PACKAGE_PIN AA1  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports BF_SPI_MOSI_02]
set_property -dict {PACKAGE_PIN AB3  IOSTANDARD LVCMOS18          } [get_ports BF_SPI_MISO_02]

set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports FMC_SPI_SCLK_03]
set_property -dict {PACKAGE_PIN AC7  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports FMC_SPI_CSB_03]
set_property -dict {PACKAGE_PIN N8   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports FMC_SPI_MOSI_03]
set_property -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS18          } [get_ports FMC_SPI_MISO_03]

set_property -dict {PACKAGE_PIN U9   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports FMC_SPI_SCLK_04]
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports FMC_SPI_CSB_04]
set_property -dict {PACKAGE_PIN T7   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports FMC_SPI_MOSI_04]
set_property -dict {PACKAGE_PIN T6   IOSTANDARD LVCMOS18          } [get_ports FMC_SPI_MISO_04]

set_property -dict {PACKAGE_PIN N12  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports XUD_SPI_SCLK]
set_property -dict {PACKAGE_PIN L16  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports XUD_SPI_CSB]
set_property -dict {PACKAGE_PIN M14  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports XUD_SPI_MOSI]
set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVCMOS18          } [get_ports XUD_SPI_MISO]

set_property -dict {PACKAGE_PIN Y1   IOSTANDARD LVCMOS18} [get_ports BF_SCL_01]
set_property -dict {PACKAGE_PIN AB5  IOSTANDARD LVCMOS18} [get_ports BF_SDA_01]

set_property -dict {PACKAGE_PIN U4   IOSTANDARD LVCMOS18} [get_ports BF_SCL_02]
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS18} [get_ports BF_SDA_02]

set_property -dict {PACKAGE_PIN V12  IOSTANDARD LVCMOS18} [get_ports BF_SCL_03]
set_property -dict {PACKAGE_PIN V11  IOSTANDARD LVCMOS18} [get_ports BF_SDA_03]

set_property -dict {PACKAGE_PIN U11  IOSTANDARD LVCMOS18} [get_ports BF_SCL_04]
set_property -dict {PACKAGE_PIN T11  IOSTANDARD LVCMOS18} [get_ports BF_SDA_04]

# set false path to output ports which connect to devices without any clocks
set_false_path -to   [get_ports BF_TR_01]
set_false_path -to   [get_ports BF_TX_LOAD_01]
set_false_path -to   [get_ports BF_RX_LOAD_01]
set_false_path -to   [get_ports BF_PA_ON_01]
set_false_path -to   [get_ports BF_TR_02]
set_false_path -to   [get_ports BF_TX_LOAD_02]
set_false_path -to   [get_ports BF_RX_LOAD_02]
set_false_path -to   [get_ports BF_PA_ON_02]
set_false_path -to   [get_ports BF_TR_03]
set_false_path -to   [get_ports BF_TX_LOAD_03]
set_false_path -to   [get_ports BF_RX_LOAD_03]
set_false_path -to   [get_ports BF_PA_ON_03]
set_false_path -to   [get_ports BF_TR_04]
set_false_path -to   [get_ports BF_TX_LOAD_04]
set_false_path -to   [get_ports BF_RX_LOAD_04]
set_false_path -to   [get_ports BF_PA_ON_04]
set_false_path -to   [get_ports XUD_RX_GAIN_MODE]
set_false_path -to   [get_ports XUD_PLL_OUTPUT_SEL]
set_false_path -to   [get_ports XUD_TXRX0]
set_false_path -to   [get_ports XUD_TXRX1]
set_false_path -to   [get_ports XUD_TXRX2]
set_false_path -to   [get_ports XUD_TXRX3]
set_false_path -from [get_ports BF_ALARM_TS_01]
set_false_path -from [get_ports BF_ALARM_TS_02]
set_false_path -from [get_ports BF_ALARM_TS_03]
set_false_path -from [get_ports BF_ALARM_TS_04]

set trce_dly_max   0.900; # maximum board trace delay
set trce_dly_min   0.800; # minimum board trace delay

# BF SPI 01

create_generated_clock -name BF_SPI_SCLK_01 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_01]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_01 BF_SPI_MOSI_01]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_01]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 02

create_generated_clock -name BF_SPI_SCLK_02 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_02]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_02 BF_SPI_MOSI_02]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_02]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 03

create_generated_clock -name FMC_SPI_SCLK_03 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports FMC_SPI_SCLK_03]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list FMC_SPI_CSB_03 FMC_SPI_MOSI_03]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports FMC_SPI_MISO_03]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 04

create_generated_clock -name FMC_SPI_SCLK_04 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports FMC_SPI_SCLK_04]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list FMC_SPI_CSB_04 FMC_SPI_MOSI_04]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports FMC_SPI_MISO_04]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# XUD SPI

create_generated_clock -name XUD_SPI_SCLK -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports XUD_SPI_SCLK]
set tsu          2.000;      # destination device setup time requirement
set thd          2.000;      # destination device hold time requirement
set output_ports [get_ports [list XUD_SPI_CSB XUD_SPI_MOSI]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     10.000;     # Maximum clock to out delay
set tco_min     10.000;     # Minimum clock to out delay
set input_ports [get_ports XUD_SPI_MISO]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF IICs

create_generated_clock -name BF_SCL_01 -source [get_pins -of_objects [get_clocks clk_pl_0]] -divide_by 1000 [get_ports BF_SCL_01]
create_generated_clock -name BF_SCL_02 -source [get_pins -of_objects [get_clocks clk_pl_0]] -divide_by 1000 [get_ports BF_SCL_02]
create_generated_clock -name BF_SCL_03 -source [get_pins -of_objects [get_clocks clk_pl_0]] -divide_by 1000 [get_ports BF_SCL_03]
create_generated_clock -name BF_SCL_04 -source [get_pins -of_objects [get_clocks clk_pl_0]] -divide_by 1000 [get_ports BF_SCL_04]
