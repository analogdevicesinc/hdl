###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# FMC HPC0
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS18} [get_ports "BF_TR"]
set_property -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS18} [get_ports "BF_TX_LOAD"]
set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS18} [get_ports "BF_RX_LOAD"]
set_property -dict {PACKAGE_PIN V11  IOSTANDARD LVCMOS18} [get_ports "PG_PA_VGG_01"]
set_property -dict {PACKAGE_PIN V12  IOSTANDARD LVCMOS18} [get_ports "BF_PWR_EN_01"]
set_property -dict {PACKAGE_PIN U9   IOSTANDARD LVCMOS18} [get_ports "BF_PA_ON_01"]
set_property -dict {PACKAGE_PIN Y4   IOSTANDARD LVCMOS18} [get_ports "PG_PA_VGG_02"]
set_property -dict {PACKAGE_PIN Y3   IOSTANDARD LVCMOS18} [get_ports "BF_PWR_EN_02"]
set_property -dict {PACKAGE_PIN V3   IOSTANDARD LVCMOS18} [get_ports "BF_PA_ON_02"]
set_property -dict {PACKAGE_PIN L10  IOSTANDARD LVCMOS18} [get_ports "PG_PA_VGG_03"]
set_property -dict {PACKAGE_PIN M10  IOSTANDARD LVCMOS18} [get_ports "BF_PWR_EN_03"]
set_property -dict {PACKAGE_PIN AC8  IOSTANDARD LVCMOS18} [get_ports "BF_PA_ON_03"]
set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVCMOS18} [get_ports "PG_PA_VGG_04"]
set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS18} [get_ports "BF_PWR_EN_04"]
set_property -dict {PACKAGE_PIN AB8  IOSTANDARD LVCMOS18} [get_ports "BF_PA_ON_04"]
set_property -dict {PACKAGE_PIN N13  IOSTANDARD LVCMOS18} [get_ports "XUD_RX_GAIN_MODE"]
set_property -dict {PACKAGE_PIN M13  IOSTANDARD LVCMOS18} [get_ports "XUD_PLL_OUTPUT_SEL"]
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS18} [get_ports "XUD_TXRX0"]
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS18} [get_ports "XUD_TXRX1"]
set_property -dict {PACKAGE_PIN W6   IOSTANDARD LVCMOS18} [get_ports "XUD_TXRX2"]
set_property -dict {PACKAGE_PIN W7   IOSTANDARD LVCMOS18} [get_ports "XUD_TXRX3"]

set_property -dict {PACKAGE_PIN U11  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_SCLK_01"]
set_property -dict {PACKAGE_PIN U6   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_CSB_01"]
set_property -dict {PACKAGE_PIN T11  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_MOSI_01"]
set_property -dict {PACKAGE_PIN V6   IOSTANDARD LVCMOS18          } [get_ports "BF_SPI_MISO_01"]

set_property -dict {PACKAGE_PIN V2   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_SCLK_02"]
set_property -dict {PACKAGE_PIN AA2  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_CSB_02"]
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_MOSI_02"]
set_property -dict {PACKAGE_PIN AA1  IOSTANDARD LVCMOS18          } [get_ports "BF_SPI_MISO_02"]

set_property -dict {PACKAGE_PIN K15  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_SCLK_03"]
set_property -dict {PACKAGE_PIN K16  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_CSB_03"]
set_property -dict {PACKAGE_PIN L15  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_MOSI_03"]
set_property -dict {PACKAGE_PIN L16  IOSTANDARD LVCMOS18          } [get_ports "BF_SPI_MISO_03"]

set_property -dict {PACKAGE_PIN AB4  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_SCLK_04"]
set_property -dict {PACKAGE_PIN AB3  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_CSB_04"]
set_property -dict {PACKAGE_PIN AC4  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_MOSI_04"]
set_property -dict {PACKAGE_PIN AC3  IOSTANDARD LVCMOS18          } [get_ports "BF_SPI_MISO_04"]

set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "XUD_SPI_SCLK"]
set_property -dict {PACKAGE_PIN L11  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "XUD_SPI_CSB"]
set_property -dict {PACKAGE_PIN M14  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "XUD_SPI_MOSI"]
set_property -dict {PACKAGE_PIN M11  IOSTANDARD LVCMOS18          } [get_ports "XUD_SPI_MISO"]

# set false path to output ports which connect to devices without any clocks
set_false_path -to [get_ports BF_TR]
set_false_path -to [get_ports BF_TX_LOAD]
set_false_path -to [get_ports BF_RX_LOAD]
set_false_path -to [get_ports PG_PA_VGG_01]
set_false_path -to [get_ports BF_PWR_EN_01]
set_false_path -to [get_ports BF_PA_ON_01]
set_false_path -to [get_ports PG_PA_VGG_02]
set_false_path -to [get_ports BF_PWR_EN_02]
set_false_path -to [get_ports BF_PA_ON_02]
set_false_path -to [get_ports PG_PA_VGG_03]
set_false_path -to [get_ports BF_PWR_EN_03]
set_false_path -to [get_ports BF_PA_ON_03]
set_false_path -to [get_ports PG_PA_VGG_04]
set_false_path -to [get_ports BF_PWR_EN_04]
set_false_path -to [get_ports BF_PA_ON_04]
set_false_path -to [get_ports XUD_RX_GAIN_MODE]
set_false_path -to [get_ports XUD_PLL_OUTPUT_SEL]
set_false_path -to [get_ports XUD_TXRX0]
set_false_path -to [get_ports XUD_TXRX1]
set_false_path -to [get_ports XUD_TXRX2]
set_false_path -to [get_ports XUD_TXRX3]

set trce_dly_max   0.900; # maximum board trace delay
set trce_dly_min   0.850; # minimum board trace delay

# BF SPI 01

create_generated_clock -name BF_SPI_SCLK_01 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_01]
set tsu          100.000;      # destination device setup time requirement
set thd          20.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_01 BF_SPI_MOSI_01]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     40.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_01]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 02

create_generated_clock -name BF_SPI_SCLK_02 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_02]
set tsu          100.000;      # destination device setup time requirement
set thd          20.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_02 BF_SPI_MOSI_02]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     40.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_02]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 03

create_generated_clock -name BF_SPI_SCLK_03 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_03]
set tsu          100.000;      # destination device setup time requirement
set thd          20.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_03 BF_SPI_MOSI_03]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     40.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_03]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 04

create_generated_clock -name BF_SPI_SCLK_04 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_04]
set tsu          100.000;      # destination device setup time requirement
set thd          20.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_04 BF_SPI_MOSI_04]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     40.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_04]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# XUD SPI

create_generated_clock -name XUD_SPI_SCLK -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports XUD_SPI_SCLK]
set tsu          100.000;      # destination device setup time requirement
set thd          20.000;      # destination device hold time requirement
set output_ports [get_ports [list XUD_SPI_CSB XUD_SPI_MOSI]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     40.000;     # Minimum clock to out delay
set input_ports [get_ports XUD_SPI_MISO]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];
