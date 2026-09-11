###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

# data interface

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ltc2378_spi_sclk]; ## G6   FMC_LA00_CC_P   IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ltc2378_spi_sdi];  ## H7   FMC_LA02_P      IO_L20P_T3_34
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ltc2378_spi_sdo];  ## C11  FMC_LA06_N      IO_L10N_T1_34
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ltc2378_spi_cnv];           ## D8   FMC_LA01_CC_P   IO_L14P_T2_SRCC_34

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports ltc2378_ext_clk];           ## H4   FMC_CLK0_M2C_P  IO_L12P_T1_MRCC_34

#set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS25} [get_ports ltc2378_spi_busy];         ## C11  FMC_LA18_CC_P   IO_L14P_T2_AD4P_SRCC_35
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports ltc2378_chain];             ## G7   FMC_LA00_CC_N   IO_L13N_T2_MRCC_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports ltc2378_dcgn];              ## D9   FMC_LA01_CC_N   IO_L14N_T2_SRCC_34
# set_property -dict {PACKAGE_PIN #N/A IOSTANDARD LVCMOS25} [get_ports enable];                 ## D1   FMC_PG_C2M      #N/A

# external clock, that drives the CNV generator, must have a maximum 100 MHz frequency
create_clock -period 10.000 -name cnv_ext_clk [get_ports ltc2378_ext_clk]

# rename auto-generated clock for SPIEngine to spi_clk - 200MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/spi_ltc2378_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/spi_ltc2378_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
