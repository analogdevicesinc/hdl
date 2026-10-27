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
