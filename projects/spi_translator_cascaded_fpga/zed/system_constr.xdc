###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

# quad spi pmod JB1

set_property  -dict {PACKAGE_PIN  W12    IOSTANDARD LVCMOS33}     [get_ports spi_pmod1_clk]               ; ## JB1
set_property  -dict {PACKAGE_PIN  W11    IOSTANDARD LVCMOS33}     [get_ports spi_pmod1_copi]              ; ## JB2
set_property  -dict {PACKAGE_PIN  V10    IOSTANDARD LVCMOS33}     [get_ports spi_pmod1_cipo]              ; ## JB3
set_property  -dict {PACKAGE_PIN  W8     IOSTANDARD LVCMOS33}     [get_ports spi_pmod1_csn]               ; ## JB4

# spi engine pmod JA1

set_property  -dict {PACKAGE_PIN  Y11    IOSTANDARD LVCMOS33}     [get_ports spi_pmod2_clk]               ; ## JA1
set_property  -dict {PACKAGE_PIN  AA11   IOSTANDARD LVCMOS33}     [get_ports spi_pmod2_copi]              ; ## JA2
set_property  -dict {PACKAGE_PIN  Y10    IOSTANDARD LVCMOS33}     [get_ports spi_pmod2_cipo]              ; ## JA3
set_property  -dict {PACKAGE_PIN  AB11   IOSTANDARD LVCMOS33}     [get_ports spi_pmod2_csn[0]]            ; ## JA7
set_property  -dict {PACKAGE_PIN  AB10   IOSTANDARD LVCMOS33}     [get_ports spi_pmod2_csn[1]]            ; ## JA8
set_property  -dict {PACKAGE_PIN  AB9    IOSTANDARD LVCMOS33}     [get_ports spi_pmod2_csn[2]]            ; ## JA9
set_property  -dict {PACKAGE_PIN  AA8    IOSTANDARD LVCMOS33}     [get_ports spi_pmod2_csn[3]]            ; ## JA10

# spi engine pmod JC1, behind spi_slave_1 (spi_execution CS 4)

set_property  -dict {PACKAGE_PIN  AB7    IOSTANDARD LVCMOS33}     [get_ports spi_pmod3_clk]               ; ## JC1P
set_property  -dict {PACKAGE_PIN  AB6    IOSTANDARD LVCMOS33}     [get_ports spi_pmod3_copi]              ; ## JC1N
set_property  -dict {PACKAGE_PIN  Y4     IOSTANDARD LVCMOS33}     [get_ports spi_pmod3_cipo]              ; ## JC2P
set_property  -dict {PACKAGE_PIN  AA4    IOSTANDARD LVCMOS33}     [get_ports spi_pmod3_cs4]               ; ## JC2N
set_property  -dict {PACKAGE_PIN  R6     IOSTANDARD LVCMOS33}     [get_ports spi_pmod3_csn[0]]            ; ## JC3P
set_property  -dict {PACKAGE_PIN  T6     IOSTANDARD LVCMOS33}     [get_ports spi_pmod3_csn[1]]            ; ## JC3N
set_property  -dict {PACKAGE_PIN  T4     IOSTANDARD LVCMOS33}     [get_ports spi_pmod3_csn[2]]            ; ## JC4P
set_property  -dict {PACKAGE_PIN  U4     IOSTANDARD LVCMOS33}     [get_ports spi_pmod3_csn[3]]            ; ## JC4N

# spi engine pmod JD1, behind spi_slave_2 (spi_execution CS 5)

set_property  -dict {PACKAGE_PIN  V7     IOSTANDARD LVCMOS33}     [get_ports spi_pmod4_clk]               ; ## JD1P
set_property  -dict {PACKAGE_PIN  W7     IOSTANDARD LVCMOS33}     [get_ports spi_pmod4_copi]              ; ## JD1N
set_property  -dict {PACKAGE_PIN  V5     IOSTANDARD LVCMOS33}     [get_ports spi_pmod4_cipo]              ; ## JD2P
set_property  -dict {PACKAGE_PIN  V4     IOSTANDARD LVCMOS33}     [get_ports spi_pmod4_cs5]               ; ## JD2N
set_property  -dict {PACKAGE_PIN  W6     IOSTANDARD LVCMOS33}     [get_ports spi_pmod4_csn[0]]            ; ## JD3P
set_property  -dict {PACKAGE_PIN  W5     IOSTANDARD LVCMOS33}     [get_ports spi_pmod4_csn[1]]            ; ## JD3N
set_property  -dict {PACKAGE_PIN  U6     IOSTANDARD LVCMOS33}     [get_ports spi_pmod4_csn[2]]            ; ## JD4P
set_property  -dict {PACKAGE_PIN  U5     IOSTANDARD LVCMOS33}     [get_ports spi_pmod4_csn[3]]            ; ## JD4N

# upstream SCLK: the axi_spi_host flop driving spi_slave/sclk,
# ext_spi_clk (clk_fpga_0, 100 MHz) / C_SCK_RATIO 8 = 12.5 MHz

set up_sclk_src [get_pins -leaf -filter {DIRECTION == OUT} \
  -of [get_nets -segments -of [get_pins -hier -filter {NAME =~ */spi_slave/sclk}]]]

create_generated_clock -name spi_up_sclk \
  -source [get_pins -of [get_cells -of $up_sclk_src] -filter {REF_PIN_NAME == C}] \
  -divide_by 8 \
  $up_sclk_src

# mode 0: MOSI changes on the SCLK falling edge and is sampled on the next
# rising edge, i.e. 4 clk_fpga_0 cycles later

set_multicycle_path -setup -start 4 -from [get_clocks clk_fpga_0] -to [get_clocks spi_up_sclk]
set_multicycle_path -hold  -start 3 -from [get_clocks clk_fpga_0] -to [get_clocks spi_up_sclk]

# cascaded SCLK: the spi_execution sclk flop driving spi_slave_1/sclk and
# spi_slave_2/sclk, clk_fpga_0 / 2 is the fastest rate (clk_div = 0, the
# default; the host may slow it down with a CLK_DIV write)
# mode 0: SDO changes on the SCLK falling edge, i.e. one clk_fpga_0 cycle
# before the capturing rising edge, which is the default setup relation

set dn_sclk_src [get_pins -leaf -filter {DIRECTION == OUT} \
  -of [get_nets -segments -of [get_pins -hier -filter {NAME =~ */spi_slave_1/sclk}]]]

create_generated_clock -name spi_dn_sclk \
  -source [get_pins -of [get_cells -of $dn_sclk_src] -filter {REF_PIN_NAME == C}] \
  -divide_by 2 \
  $dn_sclk_src
