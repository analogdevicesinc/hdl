
# ad463x_fmc SPI interface

set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdo]          ; ## C11  FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sclk]         ; ## G06  FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_cs]           ; ## G07  FMC_LPC_LA00_CC_N

set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports ad463x_resetn]           ; ## D09  FMC_LPC_LA01_N
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad463x_busy]             ; ## C10  FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ad463x_cnv]              ; ## D08  FMC_LPC_LA01_P
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports ad463x_ext_clk]          ; ## H04  FMC_LPC_CLK0_M2C_P

# debug interfaces through a PMOD
set_property -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33} [get_ports dbg_spi_sdi[0]]    ; ## JA1
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports dbg_spi_sdi[1]]    ; ## JA2
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33} [get_ports dbg_spi_sdo]       ; ## JA3
set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33} [get_ports dbg_spi_sclk]      ; ## JA4
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports dbg_spi_cs]        ; ## JA7
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33} [get_ports dbg_spi_resetn]    ; ## JA8


# external clock, that drives the CNV generator, must have a maximum 100 MHz frequency
create_clock -name cnv_ext_clk -period  10.0 [get_ports ad463x_ext_clk]

