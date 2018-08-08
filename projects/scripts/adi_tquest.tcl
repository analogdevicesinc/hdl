
report_timing -detail full_path -npaths 20 -setup -file timing_impl.log
report_timing -detail full_path -npaths 20 -hold -append -file timing_impl.log
report_timing -detail full_path -npaths 20 -recovery -append -file timing_impl.log
report_timing -detail full_path -npaths 20 -removal -append -file timing_impl.log

set worst_path [get_timing_paths -npaths 1 -setup]
foreach_in_collection path $worst_path {
  set slack [get_path_info $path -slack]
}

if {$slack > 0} {
  set worst_path [get_timing_paths -npaths 1 -hold]
  foreach_in_collection path $worst_path {
    set slack [get_path_info $path -slack]
  }
}

if {$slack > 0} {
  set worst_path [get_timing_paths -npaths 1 -recovery]
  foreach_in_collection path $worst_path {
    set slack [get_path_info $path -slack]
  }
}

if {$slack > 0} {
  set worst_path [get_timing_paths -npaths 1 -removal]
  foreach_in_collection path $worst_path {
    set slack [get_path_info $path -slack]
  }
}

if {$slack < 0} {
  set sof_files [glob *.sof]
  foreach sof_file $sof_files {
    set root_sof_file [file rootname $sof_file]
    set new_sof_file [append root_sof_file "_timing.sof"]
    file rename -force $sof_file $new_sof_file
  }
  return -code error [format "ERROR: Timing Constraints NOT met!"]
}
