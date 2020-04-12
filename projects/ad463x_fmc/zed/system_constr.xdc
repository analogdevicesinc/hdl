
# ad4630_fmc SPI interface

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad463x_spi_sdo]       ; ## D08  FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad463x_spi_sdi]       ; ## H07  FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad463x_spi_sclk]      ; ## D09  FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad463x_spi_cs]        ; ## G06  FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad463x_spi_cnv]       ; ## G07  FMC_LPC_LA00_CC_N

set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports ad463x_resetn]                 ; ## H10  FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad463x_gp0]           ; ## H08  FMC_LPC_LA02_N

#set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS18} [get_ports ad4630_amp_pd]                ; ## G10  FMC_LPC_LA03_N

set_multicycle_path 2 -setup -from [get_pins -hierarchical -filter {NAME=~*/i_sdo_fifo/i_mem/m_ram_reg/CLKARDCLK}] -to [get_pins -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]/D}] 
set_multicycle_path 1 -hold -from [get_pins -hierarchical -filter {NAME=~*/i_sdo_fifo/i_mem/m_ram_reg/CLKARDCLK}] -to [get_pins -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]/D}] 
