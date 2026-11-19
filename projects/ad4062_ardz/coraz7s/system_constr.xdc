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

set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports adc_gp0]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports adc_gp1]

# clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
set i3c_clk clk_fpga_0

# SCL is forwarded from i3c_clk, toggles every 4 cycles max (PP)
create_generated_clock -name i3c_scl -divide_by 8 \
  -source [get_property SOURCE_PINS [get_clocks $i3c_clk]] [get_ports iic_ard_scl]

# Input data driven by the peripherals at the SCL falling edge gets registered by rx_reg
# 4 cycles after, less the cycle of the SCL output register
set_multicycle_path -from [get_clocks i3c_scl] -to [get_clocks $i3c_clk] -setup -end 3
set_multicycle_path -from [get_clocks i3c_scl] -to [get_clocks $i3c_clk] -hold -end 2

# Output data toggles 1 cycle after the SCL falling edge, 7 cycles before the next
set_multicycle_path -from [get_clocks $i3c_clk] -to [get_clocks i3c_scl] -setup -start 7
set_multicycle_path -from [get_clocks $i3c_clk] -to [get_clocks i3c_scl] -hold -start 6

# Notes
# tcr/tcf rising/fall time for SCL is 150e06 * 1 / fSCL, at fSCL = 12.5 MHz => 12ns, at fSCL = 6.25 MHz, 24ns,
# 2ns is taken, since the SCL output register is placed at the IOB.
# t_SCO has a max of 12 ns, and the peripheral thd_pp a min of 0 ns.
# The input_delay and output_delay are relative to the SCL falling edge and selected for the worst case scenario.
# tsu_pp(min) of 3ns is to the SCL rising edge, 4 cycles before the SCL falling edge.
# One i3c_clk clock cycle is included in the sdo signal to ensure thd_pp(min) of tcf + 3ns is met.
set tclk       10;
set tsco_max   12;
set tsco_min    0;
set trc_dly_max 1;
set trc_dly_min 0;
set_input_delay  -clock i3c_scl -clock_fall -max [expr $tsco_max + 2 * $trc_dly_max] [get_ports iic_ard_sda]
set_input_delay  -clock i3c_scl -clock_fall -min [expr $tsco_min + 2 * $trc_dly_min] [get_ports iic_ard_sda]
set tsu         3;
set thd         5;
set_output_delay -clock i3c_scl -clock_fall -max [expr 4 * $tclk + $trc_dly_max + $tsu] [get_ports iic_ard_sda]
set_output_delay -clock i3c_scl -clock_fall -min [expr $tclk + $trc_dly_min - $thd] [get_ports iic_ard_sda]

# Place the SCL, SDO and T output registers at the IOB
set_property IOB TRUE [get_cells -hier -filter {NAME =~ *i3c/core/*g_out_reg.*_r_reg}]
