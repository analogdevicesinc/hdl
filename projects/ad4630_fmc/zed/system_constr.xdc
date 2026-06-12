###############################################################################
## Copyright (C) 2021-2024, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

# ad463x_fmc SPI interface
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad463x_spi_sdo]    ; ## C11  FMC_LA06_N
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad463x_spi_sclk]   ; ## G6  FMC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25}          [get_ports ad463x_spi_cs]     ; ## G7  FMC_LA00_CC_N

set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25} [get_ports ad463x_echo_sclk]           ; ## D20  FMC_LA17_CC_P
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports ad463x_resetn]              ; ## D9  FMC_LA01_CC_N
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS25} [get_ports ad463x_busy]                ; ## C22  FMC_LA18_CC_P
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ad463x_cnv]                 ; ## D8  FMC_LA01_CC_P
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports ad463x_ext_clk]             ; ## H4  FMC_CLK0_P

set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports {adaq42xx_pgia_mux[0]}]    ; ## G12  FMC-LA08_P
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports {adaq42xx_pgia_mux[1]}]    ; ## G13  FMC-LA08_N

set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports max17687_rst]              ; ## H13  FMC-LA07_P
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports max17687_en]               ; ## H14  FMC-LA07_N
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports max17687_sync_clk]         ; ## D21  FMC-LA17_N_CC

# external clock, that drives the CNV generator, must have a maximum 100 MHz frequency
create_clock -period 10.000 -name cnv_ext_clk [get_ports ad463x_ext_clk]

# SCLK echod clock, tuned to 80 MHz //, phase shifted with 30% (aprox. 4ns)
create_clock -period 12.500 -name ECHOSCLK_clk [get_ports ad463x_echo_sclk]

# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# create a generated clock for SCLK - fSCLK=spi_clk/2 - 80MHz
create_generated_clock -name SCLK_clk -source [get_pins -hier -filter name=~*sclk_reg/C] -edges {1 3 5} [get_ports ad463x_spi_sclk]

# output delay for MOSI line (SDI for the device)
#
# tHSDI and tSSDI is 1.5ns
set_output_delay -clock [get_clocks SCLK_clk] -max 1.500 [get_ports ad463x_spi_sdo]
set_output_delay -clock [get_clocks SCLK_clk] -min 1.500 [get_ports ad463x_spi_sdo]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup -from [get_clocks spi_clk] -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] 8
set_multicycle_path -hold  -from [get_clocks spi_clk] -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] 7

set_multicycle_path -setup -from [get_clocks spi_clk] -to [get_cells -hierarchical -filter NAME=~*/spi_ad463x_execution/inst/left_aligned_reg*] 8
set_multicycle_path -hold  -from [get_clocks spi_clk] -to [get_cells -hierarchical -filter NAME=~*/spi_ad463x_execution/inst/left_aligned_reg*] 7
