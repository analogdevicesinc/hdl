
# ad40xx_fmc SPI interface

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad40xx_spi_sdo]       ; ## H07  FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad40xx_spi_sdi]       ; ## D08  FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad40xx_spi_sclk]      ; ## G06  FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad40xx_spi_cs]        ; ## G07  FMC_LPC_LA00_CC_N

set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports ad40xx_amp_pd]                 ; ## G10  FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports ad7944_turbo]                  ; ## D09  FMC_LA01_CC_N



# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk

create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

## There is a multi-cycle path between the axi_spi_engine's SDO_FIFO and the
# execution's shift register, because we load new data into the shift register
# in every DATA_WIDTH's x 8 cycle. (worst case scenario)
# Set a multi-cycle delay of 8 spi_clk cycle, slightly over constraining the path.

set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]

set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]

