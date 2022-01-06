
# ad40xx_fmc SPI interface

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports ad3552r_spi_sdio[0]]       ; ##  LA02_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports ad3552r_spi_sdio[1]]       ; ##  LA02_N
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports ad3552r_spi_sdio[2]]       ; ##  LA03_P
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports ad3552r_spi_sdio[3]]       ; ##  LA03_N

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad3552r_spi_sclk] ; ##  LA00_P_CC
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad3552r_spi_cs]   ; ##  LA00_N_CC

set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports ad3552r_ldacn]             ; ##  LA05_P
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports ad3552r_resetn]            ; ##  LA05_N
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports ad3552r_alertn]            ; ##  LA04_P
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports ad3552r_qspi_sel]          ; ##  LA04_N

set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_6]            ; ##  LA06_P VADJ POWER
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_7]            ; ##  LA06_N
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_8]            ; ##  LA07_P
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_9]            ; ##  LA07_N

#set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports pulsar_adc_spi_pd]       ; ##  PMOD JA [4]

# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies

get_cells -hierarchical -filter {NAME=~*.data_sdo_shift_reg*[*]}
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*.data_sdo_shift_reg*[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*.data_sdo_shift_reg*[*]}] -from [get_clocks spi_clk]
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]

