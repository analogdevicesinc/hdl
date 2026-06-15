###############################################################################
## Copyright (C) 2017-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# report delays
set m_file [open "axi_ad9361_delay.log" w]
set m_ios [get_ports -filter {NAME =~ rx_*_in*}]
set m_ddr_ios [get_pins -hierarchical -filter {NAME =~ *i_rx_data_iddr/C || NAME =~ *i_rx_data_iddr/D}]
set m_info [report_timing -no_header -return_string -from $m_ios -to $m_ddr_ios -max_paths 100]

set m_sources {}
set m_string $m_info
while {[regexp {\s+Source:\s+(.*?)\s+(.*)} $m_string m1 m_value m_string] == 1} {
  lappend m_sources $m_value
}
set m_destinations {}
set m_string $m_info
while {[regexp {\s+Destination:\s+(.*?)\s+(.*)} $m_string m1 m_value m_string] == 1} {
  lappend m_destinations $m_value
}
set m_delays {}
set m_string $m_info
while {[regexp {\s+Data\s+Path\s+Delay:\s+(.*?)\s+(.*)} $m_string m1 m_value m_string] == 1} {
  lappend m_delays $m_value
}

set m_size [llength $m_sources]
if {[llength $m_destinations] != $m_size} {
  puts "CRITICAL WARNING: axi_ad9361_delay.tcl, source-destination size mismatch"
}
if {[llength $m_delays] != $m_size} {
  puts "CRITICAL WARNING: axi_ad9361_delay.tcl, source-delay size mismatch"
}

for {set m_index 0} {$m_index < $m_size} {incr m_index} {
  set m_delay [lindex $m_delays $m_index]
  set m_source [lindex $m_sources $m_index]
  set m_destination [lindex $m_destinations $m_index]
  puts "$m_source $m_destination $m_delay"
  puts $m_file "$m_source $m_destination $m_delay"
}

puts $m_file "\nDetails:\n"
puts $m_file $m_info
close $m_file

