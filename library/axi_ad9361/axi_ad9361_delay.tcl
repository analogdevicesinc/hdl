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

