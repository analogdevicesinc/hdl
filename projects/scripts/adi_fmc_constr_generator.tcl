###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# To use this script you can source it in any tcl shell or simply
# run it e.g. tclsh ../../scripts/adi_fmc_constr_generator.tcl fmc0

proc gen_fmc_constr {{fmc_index1 fmc} {fmc_index2 {}}} {

  variable col0_max 0
  variable col1_max 0
  variable col2_max 0
  variable col3_max 0
  variable io_standard_max 0
  variable file_index 0

  set platform [expr [regexp {a10gx|a10soc|s10soc} [file tail [pwd]]] ? "{intel}" : "{xilinx}"]

  if {[string match $platform xilinx]} {

    if {![catch {file lstat fmc_constr.xdc finfo}]} {
      while {![catch {file lstat fmc_constr_$file_index\.xdc finfo}]} {
        incr file_index
      }
      set constr_file [open fmc_constr_$file_index\.xdc w+]
      set constr_file_name "fmc_constr_$file_index\.xdc"
      set file_index 0
    } else {
      set constr_file [open fmc_constr.xdc w+]
      set constr_file_name "fmc_constr.xdc"
    }

    if {[string length $fmc_index2] == 0} {
      gen_xilinx_fmc $fmc_index1 fmc $constr_file
    } else {
      gen_xilinx_fmc $fmc_index1 fmc1 $constr_file
      gen_xilinx_fmc $fmc_index2 fmc2 $constr_file
    }

    close $constr_file

   if {![catch {[string length [get_property NAME [current_project]]]} errmsg]} {
     add_files -fileset constrs_1 -norecurse $constr_file_name
   }

  } else {

      set constr_file [open fmc_constr.tcl w+]

      if {[string length $fmc_index2] == 0} {
        gen_intel_fmc $fmc_index1 fmc $constr_file
      } else {
        gen_intel_fmc $fmc_index1 fmc1 $constr_file
        gen_intel_fmc $fmc_index2 fmc2 $constr_file
      }
    close $constr_file
  }
}


proc gen_xilinx_fmc {fmc_index fmc_file constr_file} {
  set cwd [pwd]
  set carrier [file tail $cwd]
  set eval_board [file tail [file dirname $cwd]]

  global col0_max
  global col1_max
  global col2_max
  global col3_max
  global io_standard_max
  variable last_gbt_pin 0
  variable gbt_exist_flag 0
  variable edit_flag 0

  if {[string match *adrv9009zu11eg* $eval_board]} {
    set carrier_path [glob ../../common/adrv9009zu11eg/adrv9009zu11eg_$fmc_index*.txt]
  } else {
    set carrier_path [glob ../../common/$carrier*/$carrier*\_$fmc_index*.txt]
  }
  set carrier_file [open $carrier_path r]
  set carrier_data [read $carrier_file]
  close $carrier_file
  set line_c [split $carrier_data \n]

  set carrierType [expr [string match *$carrier* vck190vmk180] ? 2 : [string match *u* $carrier] || [string match v* $carrier] || [string match *adrv* $carrier]]
  if {[string match *fmcomms8* $carrier]} {
    set eval_board_path [glob ../../fmcomms8/common/fmcomms8_$fmc_file.txt]
  } else {
    set eval_board_path [glob ../common/*$eval_board*\_$fmc_file.txt]
  }
  set eval_board_file [open $eval_board_path r]
  set eval_board_data [read $eval_board_file]
  close $eval_board_file
  set line_e [split $eval_board_data \n]

  for {set i 1} {$i < [llength $line_e]} {incr i} {
    if {[string match [lindex $line_e $i] ""] || [string match " *" [lindex $line_e $i]]} {continue}
    if {[string match #* [lindex $line_e $i]]} {continue}
    set col_e [join [lindex $line_e $i] " "]
    if {[string match $carrier vcu118] && [string match $fmc_index fmcp] && [string match *[lindex $col_e 0]* D4D5B20B21]} {
      set last_gbt_pin [lindex $col_e 0]
      set gbt_exist_flag 1
    }
    if {![string match [lindex $col_e 4] #N/A]} {
      if {!$carrierType} {
        if {[string match [lindex $col_e 4] LVDS] || [string match [lindex $col_e 4] LVDS15]} {set col_e [lreplace $col_e 4 4 LVDS_25]}
        if {[string match [lindex $col_e 4] LVCMOS18] || [string match [lindex $col_e 4] LVCMOS15]} {set col_e [lreplace $col_e 4 4 LVCMOS25]}
      }
      if {$carrierType == 1} {
        if {[string match [lindex $col_e 4] LVDS_25] || [string match [lindex $col_e 4] LVDS15]} {set col_e [lreplace $col_e 4 4 LVDS]}
        if {[string match [lindex $col_e 4] LVCMOS25] || [string match [lindex $col_e 4] LVCMOS15]} {set col_e [lreplace $col_e 4 4 LVCMOS18]}
      }
      if {$carrierType == 2} {
        if {[string match [lindex $col_e 4] LVDS_25] || [string match [lindex $col_e 4] LVDS]} {set col_e [lreplace $col_e 4 4 LVDS15]}
        if {[string match [lindex $col_e 4] LVCMOS25] || [string match [lindex $col_e 4] LVCMOS18]} {set col_e [lreplace $col_e 4 4 LVCMOS15]}
      }
      set io_standard [lindex $col_e 4]
    } else {set io_standard ""}
    if {![string match [lindex $col_e 5] #N/A]} {
      for {set k 5} {$k < [llength $col_e]} {incr k} {
        append io_standard " [lindex $col_e $k]"
      }
    }
    if {[string length $io_standard] > $io_standard_max} {
      set io_standard_max [string length $io_standard]
    }
    for {set j 1} {$j < [llength $line_c]} {incr j} {
      set col_c [join [lindex $line_c $j] " "]
      if {[string match [lindex $col_e 0] [lindex $col_c 0]]} {
        if {![string match [lindex $col_c 2] #N/A]} {
          if {[string length [lindex $col_c 0]] > $col0_max} {
            set col0_max [string length [lindex $col_c 0]]
          }
          if {[string length [lindex $col_c 1]] > $col1_max} {
            set col1_max [string length [lindex $col_c 1]]
          }
          if {[string length [lindex $col_c 2]] > $col2_max} {
            set col2_max [string length [lindex $col_c 2]]
          }
        }
        if {[string length [lindex $col_e 3]] > $col3_max} {
          set col3_max [string length [lindex $col_e 3]]
        }
      }
    }
  }
  if {[string match $carrier vcu118] && [string match $fmc_index fmcp] && $gbt_exist_flag} {set edit_flag 1}
  for {set i 1} {$i < [llength $line_e]} {incr i} {
    if {[string match [lindex $line_e $i] ""] || [string match " *" [lindex $line_e $i]]} {
      puts $constr_file ""
      continue
    }
    if {[string match #* [lindex $line_e $i]]} {
      puts $constr_file [lindex $line_e $i]
      continue
    }
    if {$edit_flag} {
      puts $constr_file "#----------------------------------------------------------THIS SECTION NEEDS MANUAL EDITING----------------------------------------------------------"
      set edit_flag 0
    }
    set col_e [join [lindex $line_e $i] " "]
    for {set j 1} {$j < [llength $line_c]} {incr j} {
      set col_c [join [lindex $line_c $j] " "]
      if {[string match [lindex $col_e 0] [lindex $col_c 0]]} {
        if {![string match [lindex $col_c 2] #N/A]} {
          set spaces_0 ""
          set spaces_1 ""
          set spaces_2 ""
          set spaces_3 ""
          for {set k 0} {$k < [expr $col0_max - [string length [lindex $col_c 0]]]} {incr k} {append spaces_0 " "}
          for {set k 0} {$k < [expr $col1_max - [string length [lindex $col_c 1]]]} {incr k} {append spaces_1 " "}
          for {set k 0} {$k < [expr $col2_max - [string length [lindex $col_c 2]]]} {incr k} {append spaces_2 " "}
          for {set k 0} {$k < [expr $col3_max - [string length [lindex $col_e 3]]]} {incr k} {append spaces_3 " "}
          if {![string match [lindex $col_e 4] #N/A]} {
            if {!$carrierType} {
              if {[string match [lindex $col_e 4] LVDS] || [string match [lindex $col_e 4] LVDS15]} {set col_e [lreplace $col_e 4 4 LVDS_25]}
              if {[string match [lindex $col_e 4] LVCMOS18] || [string match [lindex $col_e 4] LVCMOS15]} {set col_e [lreplace $col_e 4 4 LVCMOS25]}
            }
            if {$carrierType == 1} {
              if {[string match [lindex $col_e 4] LVDS_25] || [string match [lindex $col_e 4] LVDS15]} {set col_e [lreplace $col_e 4 4 LVDS]}
              if {[string match [lindex $col_e 4] LVCMOS25] || [string match [lindex $col_e 4] LVCMOS15]} {set col_e [lreplace $col_e 4 4 LVCMOS18]}
            }
            if {$carrierType == 2} {
              if {[string match [lindex $col_e 4] LVDS_25] || [string match [lindex $col_e 4] LVDS]} {set col_e [lreplace $col_e 4 4 LVDS15]}
              if {[string match [lindex $col_e 4] LVCMOS25] || [string match [lindex $col_e 4] LVCMOS18]} {set col_e [lreplace $col_e 4 4 LVCMOS15]}
            }
            set io_standard "$spaces_2 IOSTANDARD [lindex $col_e 4]"
          } else {
              set io_standard ""
            }
          if {![string match [lindex $col_e 5] #N/A]} {
            if {![string length $io_standard]} {set io_standard $spaces_2}
            for {set k 5} {$k < [llength $col_e]} {incr k} {
              append io_standard " [lindex $col_e $k]"
            }
          }
          if {[string length $io_standard] > 0} {
            for {set k 0} {$k < [expr $io_standard_max + [string length $spaces_2] + 12 - [string length $io_standard]]} {incr k} {append spaces_3 " "}
            puts $constr_file "set_property -dict \{PACKAGE_PIN [lindex $col_c 2]$io_standard\} \[get_ports [lindex $col_e 3]\]$spaces_3 ; ## [lindex $col_c 0]$spaces_0  [lindex $col_c 1] $spaces_1 [lindex $col_c 3]"
          } else {
              for {set k 0} {$k < [expr $io_standard_max + 12 - [string length $io_standard]]} {incr k} {append spaces_3 " "}
              puts $constr_file "set_property -dict \{PACKAGE_PIN [lindex $col_c 2]\}$spaces_2 \[get_ports [lindex $col_e 3]\]$spaces_3 ; ## [lindex $col_c 0]$spaces_0  [lindex $col_c 1] $spaces_1 [lindex $col_c 3]"
            }
          if {[string match $carrier vcu118] && [string match $fmc_index fmcp] && [string match [lindex $col_c 0] $last_gbt_pin] && ![string match $last_gbt_pin* [lindex $line_c [expr $j+2]] ] && [string match [lindex $col_e 0] $last_gbt_pin] && ![string match $last_gbt_pin* [lindex $line_e [expr $i+2]]]} {
            puts $constr_file #-----------------------------------------------------------------------------------------------------------------------------------------------------
          }
        }
      }
    }
  }
}

proc gen_intel_fmc {fmc_index fmc_file constr_file} {

  set cwd [pwd]
  set carrier [file tail $cwd]

  global col0_max
  global col1_max
  global col2_max
  global col3_max
  variable current_index 1
  variable spaceFlag 0
  variable serialFlag 0
  variable xcvrCount 0
  set xcvrType "xcvr_\$\{i\}"

  set carrier_path [glob ../../common/$carrier/$carrier\_$fmc_index*.txt]
  set carrier_file [open $carrier_path r]
  set carrier_data [read $carrier_file]
  close $carrier_file
  set line_c [split $carrier_data \n]

  set eval_board_path [glob ../common/*_$fmc_file*.txt]
  set eval_board_file [open $eval_board_path r]
  set eval_board_data [read $eval_board_file]
  close $eval_board_file
  set line_e [split $eval_board_data \n]

  for {set i 1} {$i <= [llength $line_e]} {incr i} {
    if {[string match [lindex $line_e $i] ""] || [string match " *" [lindex $line_e $i]] || $i == [llength $line_e]} {continue}
    if {[string match #* [lindex $line_e $i]]} {continue}
    set col_e [join [lindex $line_e $i] " "]
    set col_e [constrToIntel $line_e $col_e $i]
    for {set j 1} {$j < [llength $line_c]} {incr j} {
      set col_c [join [lindex $line_c $j] " "]
      if {[string match [lindex $col_e 0] [lindex $col_c 0]]} {
        if {![string match [lindex $col_c 2] #N/A]} {
          if {[string length [lindex $col_c 0]] > $col0_max} {
            set col0_max [string length [lindex $col_c 0]]
          }
          if {[string length [lindex $col_c 1]] > $col1_max} {
            set col1_max [string length [lindex $col_c 1]]
          }
          if {[string length [lindex $col_c 2]] > $col2_max} {
            set col2_max [string length [lindex $col_c 2]]
          }
        }
        if {[string length [lindex $col_e 3]] > $col3_max} {
          set col3_max [string length [lindex $col_e 3]]
        }
      }
    }
  }
  for {set i 1} {$i <= [llength $line_e]} {incr i} {
    if {[string match #* [lindex $line_e $i]]} {
      puts $constr_file [lindex $line_e $i]
      continue
    }

    set col_e [join [lindex $line_e $i] " "]
    set col_e [constrToIntel $line_e $col_e $i]
    if {[string match "*serial_data*" [lindex $col_e 3]] && ![string match "*_data*" [lindex $line_e [expr $i+1]]]} {set serialFlag 1}
    if {[string match [lindex $line_e $i] ""] || [string match " *" [lindex $line_e $i]] || $i == [llength $line_e]} {
      puts $constr_file ""
      if {$serialFlag} {
        for {set k $current_index} {$k <= $i} {incr k} {
          set col_e [join [lindex $line_e $k] " "]
          set col_e [constrToIntel $line_e $col_e $k]
          if {[string match "*\[0\]*" [lindex $col_e 3]] && ![string match "*(n)*" [lindex $col_e 3]]} {
            puts $constr_file "set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to [string map -nocase {[0] ""} [lindex $col_e 3]]"
          }
        }
        puts $constr_file ""
        for {set k $current_index} {$k <= $i} {incr k} {
          set col_e [join [lindex $line_e $k] " "]
          set col_e [constrToIntel $line_e $col_e $k]
          if {[string match "*\[0\]*" [lindex $col_e 3]] && ![string match "*(n)*" [lindex $col_e 3]]} {
            set xcvrCount 0
            puts $constr_file "set_instance_assignment -name IO_STANDARD \"HIGH SPEED DIFFERENTIAL I/O\" -to [string map -nocase {[0] ""} [lindex $col_e 3]]"
          } else {incr xcvrCount}
        }
        puts $constr_file ""
        puts $constr_file "for \{set i 0\} \{\$i < [expr $xcvrCount/2]\} \{incr i\} \{"
        for {set k $current_index} {$k <= $i} {incr k} {
          set col_e [join [lindex $line_e $k] " "]
          set col_e [constrToIntel $line_e $col_e $k]
          if {[string match "*\[0\]*" [lindex $col_e 3]] && ![string match "*(n)*" [lindex $col_e 3]]} {
            if {[string match "*data_*" [lindex $col_e 3]]} {set xcvrType "xcvr_[string index [lindex $col_e 3] [expr [string last _ [lindex $col_e 3]] + 1]]_\$\{i\}"}
            puts $constr_file "  set_instance_assignment -name XCVR_RECONFIG_GROUP $xcvrType -to [string map -nocase {[0] \[\$\{i\}\]} [lindex $col_e 3]]"
          }
        }
        puts $constr_file "\}"
        set serialFlag 0
        set current_index $i
      }
      for {set k $current_index} {$k < $i} {incr k} {
        set col_e [join [lindex $line_e $k] " "]
        set col_e [constrToIntel $line_e $col_e $k]
        if {![string match [lindex $col_e 4] #N/A] && ![string match "*(n)*" [lindex $col_e 3]] && ![string match "" [lindex $col_e 4]]} {
          set io_standard [string map -nocase {LVCMOS15 "\"1.8 V\"" LVCMOS18 "\"1.8 V\"" LVCMOS25 "\"1.8 V\""} [lindex $col_e 4]]
          puts $constr_file "set_instance_assignment -name IO_STANDARD $io_standard -to [lindex $col_e 3]"
          set spaceFlag 1
        }
      }
      for {set k $current_index} {$k < $i} {incr k} {
        set col_e [join [lindex $line_e $k] " "]
        set col_e [constrToIntel $line_e $col_e $k]
        if {![string match [lindex $col_e 5] #N/A] && ![string match "*(n)*" [lindex $col_e 3]] && ![string match "" [lindex $col_e 5]]} {
          set io_standard [string map -nocase {DIFF_TERM "INPUT_TERMINATION DIFFERENTIAL"} [lindex $col_e 5]]
          puts $constr_file "set_instance_assignment -name $io_standard -to [lindex $col_e 3]"
        }
      }
      set current_index $i
      if {$spaceFlag} {puts $constr_file ""}
      continue
    }

    for {set j 1} {$j < [llength $line_c]} {incr j} {
      set col_c [join [lindex $line_c $j] " "]
      if {[string match [lindex $col_e 0] [lindex $col_c 0]]} {
        if {![string match [lindex $col_c 2] #N/A]} {
          set spaces_0 ""
          set spaces_1 ""
          set spaces_2 ""
          set spaces_3 ""
          for {set k 0} {$k < [expr $col0_max - [string length [lindex $col_c 0]]]} {incr k} {append spaces_0 " "}
          for {set k 0} {$k < [expr $col1_max - [string length [lindex $col_c 1]]]} {incr k} {append spaces_1 " "}
          for {set k 0} {$k < [expr $col2_max - [string length [lindex $col_c 2]]]} {incr k} {append spaces_2 " "}
          for {set k 0} {$k < [expr $col3_max - [string length [lindex $col_e 3]]]} {incr k} {append spaces_3 " "}

          puts $constr_file "set_location_assignment [lindex $col_c 2]$spaces_2 -to [lindex $col_e 3]$spaces_3 ; ## [lindex $col_c 0]$spaces_0  [lindex $col_c 1] $spaces_1 [lindex $col_c 3]"
        }
      }
    }
  }
}

proc constrToIntel {line_e col_e i} {
  if {[string match "*_p*" [lindex $col_e 3]] && [string match "*_n*" [lindex $line_e [expr $i+1]]]} {set col_e [lreplace $col_e 3 3 [string map -nocase {_p ""} [lindex $col_e 3]]]}
  if {[string match "*_n*" [lindex $col_e 3]] && [string match "*_p*" [lindex $line_e [expr $i-1]]]} {set col_e [lreplace $col_e 3 3 "\"[string map -nocase {_n ""} [lindex $col_e 3]](n)\""]}
  if {[string match "*_data*" [lindex $col_e 3]] && ![string match "*serial_data*" [lindex $col_e 3]]} {
    set col_e [lreplace $col_e 3 3 [string map -nocase {_data _serial_data} [lindex $col_e 3]]]
  }
  return $col_e
}

# Allow the script to be called or sourced
if {[info script] eq $::argv0} {
  if {$::argv == ""} {
    puts "To create the fmc_constr.xdc, call the adi_fmc_constr_generator.tcl with argument(s) <fmc_port>"
    puts "e.g. tclsh ../../scripts/adi_fmc_constr_generator.tcl fmc0"
    puts "e.g. tclsh ../../scripts/adi_fmc_constr_generator.tcl fmc0 fmc1"
    puts "NOTE: The fmc port name can be deduced from the git repo hdl/projects/common/<carrier>/<carrier>_<fmc_port>.txt"
  } else {
    if {$::argc == 2} {
      gen_fmc_constr [lindex $::argv 0] [lindex $::argv 1]
    } else {
      gen_fmc_constr $::argv
    }
  }
} else {
  puts "To create the fmc_constr.xdc call the gen_fmc_constr <fmc_port> procedure"
  puts "e.g. gen_fmc_constr fmc0"
  puts "e.g. gen_fmc_constr fmc0 fmc1"
  puts "NOTE: The fmc port name can be deduced from the git repo hdl/projects/common/<carrier>/<carrier>_<fmc_port>.txt"
}
