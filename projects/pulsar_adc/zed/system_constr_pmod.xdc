###############################################################################
## Copyright (C) 2021-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports pulsar_spi_sdo];   ## JA2
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports pulsar_spi_sdi];   ## JA3
set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports pulsar_spi_sclk];  ## JA4
set_property -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports pulsar_spi_cs];    ## JA1

# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk

create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

## There is a multi-cycle path between the axi_spi_engine's SDO_FIFO and the
# execution's shift register, because we load new data into the shift register
# in every DATA_WIDTH's x 8 cycle. (worst case scenario)
# Set a multi-cycle delay of 8 spi_clk cycle, slightly over constraining the path.

set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]

set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/spi_pulsar_adc_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/spi_pulsar_adc_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]

# set IOSTANDARD according to VADJ 3.3V

# constraints
# hdmi

set_property  -dict {PACKAGE_PIN  W18   IOSTANDARD LVCMOS33}           [get_ports hdmi_out_clk]
set_property  -dict {PACKAGE_PIN  W17   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_vsync]
set_property  -dict {PACKAGE_PIN  V17   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_hsync]
set_property  -dict {PACKAGE_PIN  U16   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data_e]
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[0]]
set_property  -dict {PACKAGE_PIN  AA13  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[1]]
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[2]]
set_property  -dict {PACKAGE_PIN  Y14   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[3]]
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[4]]
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[5]]
set_property  -dict {PACKAGE_PIN  AA16  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[6]]
set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[7]]
set_property  -dict {PACKAGE_PIN  AA17  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[8]]
set_property  -dict {PACKAGE_PIN  Y15   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[9]]
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[10]]
set_property  -dict {PACKAGE_PIN  W15   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[11]]
set_property  -dict {PACKAGE_PIN  V15   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[12]]
set_property  -dict {PACKAGE_PIN  U17   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[13]]
set_property  -dict {PACKAGE_PIN  V14   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[14]]
set_property  -dict {PACKAGE_PIN  V13   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[15]]

# spdif

set_property  -dict {PACKAGE_PIN  U15   IOSTANDARD LVCMOS33} [get_ports spdif]

# i2s

set_property  -dict {PACKAGE_PIN  AB2   IOSTANDARD LVCMOS33} [get_ports i2s_mclk]
set_property  -dict {PACKAGE_PIN  AA6   IOSTANDARD LVCMOS33} [get_ports i2s_bclk]
set_property  -dict {PACKAGE_PIN  Y6    IOSTANDARD LVCMOS33} [get_ports i2s_lrclk]
set_property  -dict {PACKAGE_PIN  Y8    IOSTANDARD LVCMOS33} [get_ports i2s_sdata_out]
set_property  -dict {PACKAGE_PIN  AA7   IOSTANDARD LVCMOS33} [get_ports i2s_sdata_in]

# iic

set_property  -dict {PACKAGE_PIN  R7    IOSTANDARD LVCMOS33} [get_ports iic_scl]
set_property  -dict {PACKAGE_PIN  U7    IOSTANDARD LVCMOS33} [get_ports iic_sda]
set_property  -dict {PACKAGE_PIN  AA18  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_scl[1]]
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_sda[1]]
set_property  -dict {PACKAGE_PIN  AB4   IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_scl[0]]
set_property  -dict {PACKAGE_PIN  AB5   IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_sda[0]]

# otg

set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS33} [get_ports otg_vbusoc]

# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVCMOS33} [get_ports gpio_bd[0]]       ; ## BTNC
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVCMOS33} [get_ports gpio_bd[1]]       ; ## BTND
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[2]]       ; ## BTNL
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS33} [get_ports gpio_bd[3]]       ; ## BTNR
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD LVCMOS33} [get_ports gpio_bd[4]]       ; ## BTNU
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS33} [get_ports gpio_bd[5]]       ; ## OLED-DC
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS33} [get_ports gpio_bd[6]]       ; ## OLED-RES
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[7]]       ; ## OLED-SCLK
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[8]]       ; ## OLED-SDIN
set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD LVCMOS33} [get_ports gpio_bd[9]]       ; ## OLED-VBAT
set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD LVCMOS33} [get_ports gpio_bd[10]]      ; ## OLED-VDD

set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[11]]      ; ## SW0
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[12]]      ; ## SW1
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[13]]      ; ## SW2
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[14]]      ; ## SW3
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD LVCMOS33} [get_ports gpio_bd[15]]      ; ## SW4
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVCMOS33} [get_ports gpio_bd[16]]      ; ## SW5
set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVCMOS33} [get_ports gpio_bd[17]]      ; ## SW6
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[18]]      ; ## SW7

set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[19]]      ; ## LD0
set_property  -dict {PACKAGE_PIN  T21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[20]]      ; ## LD1
set_property  -dict {PACKAGE_PIN  U22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[21]]      ; ## LD2
set_property  -dict {PACKAGE_PIN  U21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[22]]      ; ## LD3
set_property  -dict {PACKAGE_PIN  V22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[23]]      ; ## LD4
set_property  -dict {PACKAGE_PIN  W22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[24]]      ; ## LD5
set_property  -dict {PACKAGE_PIN  U19   IOSTANDARD LVCMOS33} [get_ports gpio_bd[25]]      ; ## LD6
set_property  -dict {PACKAGE_PIN  U14   IOSTANDARD LVCMOS33} [get_ports gpio_bd[26]]      ; ## LD7

set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS33} [get_ports gpio_bd[31]]      ; ## OTG-RESETN

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]
