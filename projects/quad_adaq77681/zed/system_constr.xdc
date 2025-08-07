
# SPI interface

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_sdo]    ; ##  FMC_LA02_P
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_sclk]   ; ##  FMC_LA01_CC_P

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_sdi[0]] ; ##  FMC_LA03_P
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_sdi[1]] ; ##  FMC_LA04_P
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_sdi[2]] ; ##  FMC_LA05_P
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_sdi[3]] ; ##  FMC_LA06_P

set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_cs[0]]  ; ##  FMC_LA08_P
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_cs[1]]  ; ##  FMC_LA09_P
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_cs[2]]  ; ##  FMC_LA10_P
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports se_spi_cs[3]]  ; ##  FMC_LA11_P

set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports qadc_drdy[0]]           ; ##  FMC_LA13_P
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports qadc_drdy[1]]           ; ##  FMC_LA14_P
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports qadc_drdy[2]]           ; ##  FMC_LA15_P
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports qadc_drdy[3]]           ; ##  FMC_LA16_P

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports qadc_mclk_refclk]       ; ##  FMC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25} [get_ports qadc_xtal2_mclk]        ; ##  FMC_LA17_CC_P
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports qadc_sync]              ; ##  FMC_LA12_P

set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS25} [get_ports qadc_muxa[0]]           ; ##  FMC_LA22_P
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS25} [get_ports qadc_muxa[1]]           ; ##  FMC_LA23_P
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS25} [get_ports qadc_muxb[0]]           ; ##  FMC_LA24_P
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS25} [get_ports qadc_muxb[1]]           ; ##  FMC_LA25_P
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS25} [get_ports qadc_muxc[0]]           ; ##  FMC_LA26_P
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS25} [get_ports qadc_muxc[1]]           ; ##  FMC_LA27_P
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25} [get_ports qadc_muxd[0]]           ; ##  FMC_LA28_P
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS25} [get_ports qadc_muxd[1]]           ; ##  FMC_LA29_P

set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS25} [get_ports qadc_pgood[0]]          ; ## FMC_LA30_P
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS25} [get_ports qadc_pgood[1]]          ; ## FMC_LA30_P
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS25} [get_ports qadc_pgood[2]]          ; ## FMC_LA30_P
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS25} [get_ports qadc_pgood[3]]          ; ## FMC_LA30_P

#create_clock -period 30.5175781 -name qadc_mclk_refclk [get_ports qadc_mclk_refclk]
create_clock -period 32.768 -name qadc_mclk_refclk [get_ports qadc_mclk_refclk]

## There is a multi-cycle path between the axi_spi_engine's SDO_FIFO and the
# execution's shift register, because we load new data into the shift register
# in every DATA_WIDTH's x 8 cycle. (worst case scenario)
# Set a multi-cycle delay of 8 spi_clk cycle, slightly over constraining the path.

# rename auto-generated clock for SPIEngine to spi_clk - 16.384MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk

create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*mclk_clkgen*i_mmcm]] -master_clock qadc_mclk_refclk [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*mclk_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies

set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/left_aligned_reg*}] -from [get_clocks spi_clk]
