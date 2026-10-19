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

source [file join [file dirname [info script]] ../../common/nios_a5e/system_constr.sdc]

## Default configuration: 64B66B, 10.3125 Gbps lane rate
##   REF_CLK_RATE = DEVICE_CLK_RATE = 10312.5 / 66 = 156.25 MHz -> 6.400 ns
## When changing the lane rate these have to be updated as well!

create_clock  -period "6.400 ns"  -name ref_clk_a      [get_ports {fpga_refclk_in_a}]
create_clock  -period "6.400 ns"  -name ref_clk_b      [get_ports {fpga_refclk_in_b}]

# In gearbox builds the device clocks also feed the link clock IOPLLs, whose
# SDC is read first and already creates a clock on the pin. Use that one.
proc device_clk {name period port} {
  foreach_in_collection clk [get_clocks -nowarn] {
    foreach_in_collection target [get_clock_info -targets $clk] {
      if {[get_node_info -name $target] eq $port} {
        return [get_clock_info -name $clk]
      }
    }
  }
  create_clock -period $period -name $name [get_ports $port]
  return $name
}
set rx_device_clk [device_clk rx_device_clk "6.400 ns" rx_device_clk]
set tx_device_clk [device_clk tx_device_clk "6.400 ns" tx_device_clk]

derive_clock_uncertainty

# The two device clocks come from separate clock chip outputs. Nothing crosses
# between them except SYSREF, which every link captures on its own device clock.
set_clock_groups -asynchronous \
    -group [get_clocks $rx_device_clk] \
    -group [get_clocks $tx_device_clk]

# SYNC~ is asynchronous to the link clock; it is captured by sync_bits
# synchronizers inside the link layer.
set_false_path -to [get_registers {*|i_cdc_sync|cdc_sync_stage*[0]}]
# In 64B66B these ports are virtual, so the collections come back empty.
if {[llength [get_ports -nowarn {syncoutb_a0 syncoutb_b0}]]} {
  set_false_path -from [get_ports {syncoutb_a0 syncoutb_b0}]
  set_false_path -to [get_ports {syncinb_a0 syncinb_b0}]
}

# Constraint SYSREF
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
foreach clk [list $tx_device_clk $rx_device_clk] {
  set_input_delay -add_delay \
    -clock $clk \
    [expr [get_clock_info -period $clk] / 8] \
    [get_ports {sysref_out}]
}
