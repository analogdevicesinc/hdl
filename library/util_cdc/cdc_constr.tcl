###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc string_occurrences {needleString haystackString} {
    regsub -all $needleString $haystackString {} stripped
    expr {([string length $haystackString] - [string length $stripped]) / [string length $needleString]}
}

proc constrain_ip_inst {{ip_inst {}}} {
  # sync bits constraints
  if {$ip_inst != ""} {
    current_instance -quiet
    current_instance $ip_inst
  }
  foreach sync_bits_inst [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == sync_bits || REF_NAME == sync_bits)}] {
    current_instance -quiet
    # set input_data_reg_cdc [get_cells -quiet -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[0]*]
    set input_data_reg_cdc [get_cells -quiet -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[*]*]
    # skip if no register is found
    if {$input_data_reg_cdc eq ""} {
      continue
    }
    set input_data_reg_pin [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects $input_data_reg_cdc]

    set input_start_cells [all_fanin -quiet -flat -only_cells [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects $input_data_reg_cdc]]
    foreach input_data_reg $input_data_reg_cdc {
      set input_start_cells [filter -quiet $input_start_cells "NAME != $input_data_reg"]
    }

    set input_start_regs [filter -quiet $input_start_cells {PRIMITIVE_GROUP == REGISTER && PRIMITIVE_SUBGROUP == SDR}]

    # NEW ADDITION

    foreach input_data_reg $input_data_reg_cdc {
      set split_cell [split $input_data_reg "/"]

      set list_length [llength $split_cell]

      set base_cell_parts [lreplace $split_cell $list_length-1 $list_length-1]

      set base_cell {}
      foreach cell_part $base_cell_parts {
        append base_cell "/${cell_part}"
      }
      set base_cell [string trimleft $base_cell "/"]

      set input_start_regs [filter -quiet $input_start_regs "PARENT != $base_cell"]
    }

    # NEW ADDITION END

    if {$input_start_cells eq ""} {
      set item_count_total 0
      set item_count_gnd 0
    } else {
      set item_count_total [expr [string_occurrences " " $input_start_cells] + 1]
      set item_count_gnd [string_occurrences "GND" $input_start_cells]
    }
    if {$input_start_regs eq ""} {
      set item_count_fd 0
    } else {
      set item_count_fd [expr [string_occurrences " " $input_start_regs] + 1]
    }

    if {$item_count_total != 0 && $item_count_gnd != $item_count_total} {
      if {$item_count_fd == 0 || [expr $item_count_fd + $item_count_gnd] != $item_count_total} {
        set_false_path \
          -to $input_data_reg_pin
      } else {
        set input_clk [get_clocks -of_objects $input_start_regs]
        set output_clk [get_clocks -of_objects [get_cells -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[*]*]]

        set input_clk_period [get_property -min PERIOD $input_clk]
        set output_clk_period [get_property -min PERIOD $output_clk]

        set min_clk_period [expr min($input_clk_period, $output_clk_period)]

        set_max_delay -datapath_only \
          -from $input_start_regs \
          -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[*]*]] \
          $input_clk_period

        if {$item_count_fd > 1} {
          set_bus_skew \
            -from $input_start_regs \
            -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[*]*]] \
            $min_clk_period
        }
      }
    }
  }

  # sync data constraints
  if {$ip_inst != ""} {
    current_instance -quiet
    current_instance $ip_inst
  }
  foreach sync_data_inst [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == sync_data || REF_NAME == sync_data)}] {
    current_instance -quiet
    set input_data_reg_cdc [get_cells -quiet -include_replicated_objects $sync_data_inst/in_toggle_d1_reg]
    # skip if no register is found
    if {$input_data_reg_cdc eq ""} {
      continue
    }
    set input_clk [get_clocks -of_objects [get_cells -include_replicated_objects $sync_data_inst/in_toggle_d1_reg]]
    set output_clk [get_clocks -of_objects [get_cells -include_replicated_objects $sync_data_inst/out_toggle_d1_reg]]

    set input_clk_period [get_property -min PERIOD $input_clk]
    set output_clk_period [get_property -min PERIOD $output_clk]

    set min_clk_period [expr min($input_clk_period, $output_clk_period)]

    set_max_delay -datapath_only \
      -from [get_pins -include_replicated_objects -filter {REF_PIN_NAME == C} -of_objects [get_cells -include_replicated_objects $sync_data_inst/cdc_hold_reg[*]]] \
      -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_data_inst/out_data_reg[*]]] \
      $input_clk_period

    if {[string first " " [get_cells -quiet -include_replicated_objects $sync_data_inst/cdc_hold_reg[*]]] != -1} {
      set_bus_skew \
        -from [get_pins -include_replicated_objects -filter {REF_PIN_NAME == C} -of_objects [get_cells -include_replicated_objects $sync_data_inst/cdc_hold_reg[*]]] \
        -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_data_inst/out_data_reg[*]]] \
        $min_clk_period
    }
  }

  # sync event constraints
  if {$ip_inst != ""} {
    current_instance -quiet
    current_instance $ip_inst
  }
  foreach sync_event_inst [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == sync_event || REF_NAME == sync_event)}] {
    current_instance -quiet
    set input_data_reg_cdc [get_cells -quiet -include_replicated_objects $sync_event_inst/in_toggle_d1_reg]
    # skip if no register is found
    if {$input_data_reg_cdc eq ""} {
      continue
    }
    set input_clk [get_clocks -of_objects [get_cells -include_replicated_objects $sync_event_inst/in_toggle_d1_reg]]
    set output_clk [get_clocks -of_objects [get_cells -include_replicated_objects $sync_event_inst/out_toggle_d1_reg]]

    set input_clk_period [get_property -min PERIOD $input_clk]
    set output_clk_period [get_property -min PERIOD $output_clk]

    set min_clk_period [expr min($input_clk_period, $output_clk_period)]

    if {[string first " " [get_cells -quiet -include_replicated_objects $sync_event_inst/cdc_hold_reg[*]]] != -1} {
      set_max_delay -datapath_only \
        -from [get_pins -include_replicated_objects -filter {REF_PIN_NAME == C} -of_objects [get_cells -include_replicated_objects $sync_event_inst/cdc_hold_reg[*]]] \
        -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_event_inst/out_event_reg[*]]] \
        $input_clk_period

      set_bus_skew \
        -from [get_pins -include_replicated_objects -filter {REF_PIN_NAME == C} -of_objects [get_cells -include_replicated_objects $sync_event_inst/cdc_hold_reg[*]]] \
        -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_event_inst/out_event_reg[*]]] \
        $min_clk_period
    }
  }

  current_instance -quiet
}

proc constrain_ip {{ip_name {}}} {
  if {$ip_name == ""} {
    puts "Constraining all IP instances"
    constrain_ip_inst
  } else {
    puts "Look for IP: $ip_name"
    foreach ip_inst [get_cells -quiet -include_replicated_objects -hier -filter "(ORIG_REF_NAME == $ip_name || REF_NAME == $ip_name)"] {
      puts "Constraining IP instance: $ip_inst"
      constrain_ip_inst $ip_inst
    }
  }
}

proc constrain_ips {{ip_name_list {}}} {
  if {$ip_name_list == {}} {
    puts "Constraining all IPs"
    constrain_ip
  } else {
    foreach ip_name $ip_name_list {
      puts "Constraining IP type: $ip_name"
      constrain_ip $ip_name
    }
  }
}

# constrain_ips
