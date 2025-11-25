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
    set input_data_reg_cdc [get_cells -quiet -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[0]*]
    # skip if no register is found
    if {$input_data_reg_cdc eq ""} {
      continue
    }
    set input_data_reg_pin [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects $input_data_reg_cdc]

    set input_start_cells [all_fanin -quiet -flat -only_cells [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects $input_data_reg_cdc]]
    foreach input_data_reg $input_data_reg_cdc {
      set input_start_cells [filter -quiet $input_start_cells "NAME != $input_data_reg"]
    }

    set input_start_regs [filter -quiet $input_start_cells {(PRIMITIVE_GROUP == REGISTER && PRIMITIVE_SUBGROUP == SDR) || (PRIMITIVE_GROUP == FLOP_LATCH) || (PRIMITIVE_GROUP == DMEM)}]

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
          -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[0]*]]
      } else {
        set input_clk [get_clocks -of_objects $input_start_regs]
        set output_clk [get_clocks -of_objects [get_cells -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[0]*]]

        set input_clk_period [get_property -min PERIOD $input_clk]
        set output_clk_period [get_property -min PERIOD $output_clk]

        set min_clk_period [expr min($input_clk_period, $output_clk_period)]

        set_max_delay -datapath_only \
          -from $input_start_regs \
          -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[0]*]] \
          $input_clk_period

        if {$item_count_fd > 1} {
          set_bus_skew \
            -from $input_start_regs \
            -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_bits_inst/cdc_sync_stage_reg[0]*]] \
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

  # ad rst constraints
  if {$ip_inst != ""} {
    current_instance -quiet
    current_instance $ip_inst
  }
  foreach sync_rst_inst [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == ad_rst || REF_NAME == ad_rst)}] {
    current_instance -quiet
    set input_data_reg_cdc [get_cells -quiet -include_replicated_objects $sync_rst_inst/cdc_sync_stage_reg[0]]
    # skip if no register is found
    if {$input_data_reg_cdc eq ""} {
      continue
    }
    set input_data_reg_pin [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects $input_data_reg_cdc]

    set input_start_cells [all_fanin -quiet -flat -only_cells [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects $input_data_reg_cdc]]
    foreach input_data_reg $input_data_reg_cdc {
      set input_start_cells [filter -quiet $input_start_cells "NAME != $input_data_reg"]
    }

    set input_start_regs [filter -quiet $input_start_cells {(PRIMITIVE_GROUP == REGISTER && PRIMITIVE_SUBGROUP == SDR) || (PRIMITIVE_GROUP == FLOP_LATCH) || (PRIMITIVE_GROUP == DMEM)}]

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
          -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -include_replicated_objects $sync_rst_inst/cdc_sync_stage_reg[*]]]
      } else {
        set input_clk [get_clocks -of_objects $input_start_regs]
        set input_clk_period [get_property -min PERIOD $input_clk]

        set_max_delay -datapath_only \
          -from $input_start_regs \
          -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -include_replicated_objects $sync_rst_inst/cdc_sync_stage_reg[*]]] \
          $input_clk_period
      }
    }
  }

  # util rst constraints
  if {$ip_inst != ""} {
    current_instance -quiet
    current_instance $ip_inst
  }
  foreach sync_rst_inst [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == util_rst || REF_NAME == util_rst)}] {
    current_instance -quiet
    set input_data_reg_cdc [get_cells -quiet -include_replicated_objects $sync_rst_inst/cdc_async_stage_reg[0]]
    # skip if no register is found
    if {$input_data_reg_cdc eq ""} {
      continue
    }
    set input_data_reg_pin [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects $input_data_reg_cdc]

    set input_start_cells [all_fanin -quiet -flat -only_cells [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects $input_data_reg_cdc]]
    foreach input_data_reg $input_data_reg_cdc {
      set input_start_cells [filter -quiet $input_start_cells "NAME != $input_data_reg"]
    }

    set input_start_regs [filter -quiet $input_start_cells {(PRIMITIVE_GROUP == REGISTER && PRIMITIVE_SUBGROUP == SDR) || (PRIMITIVE_GROUP == FLOP_LATCH) || (PRIMITIVE_GROUP == DMEM)}]

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
          -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -include_replicated_objects $sync_rst_inst/cdc_async_stage_reg[*]]]
      } else {
        set input_clk [get_clocks -of_objects $input_start_regs]
        set input_clk_period [get_property -min PERIOD $input_clk]

        set_max_delay -datapath_only \
          -from $input_start_regs \
          -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -include_replicated_objects $sync_rst_inst/cdc_async_stage_reg[*]]] \
          $input_clk_period
      }
    }
  }

  # util rst chain constraints
  if {$ip_inst != ""} {
    current_instance -quiet
    current_instance $ip_inst
  }
  foreach sync_rst_inst [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == util_rst_chain || REF_NAME == util_rst_chain)}] {
    current_instance -quiet

    # constrain the reset signal

    set input_data_reg_cdc [get_cells -quiet -include_replicated_objects $sync_rst_inst/genblk1[0].cdc_async_stage_reg[0]]
    # skip if no register is found
    if {$input_data_reg_cdc eq ""} {
      continue
    }
    set input_data_reg_pin [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects $input_data_reg_cdc]

    set input_start_cells [all_fanin -quiet -flat -only_cells [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects $input_data_reg_cdc]]
    foreach input_data_reg $input_data_reg_cdc {
      set input_start_cells [filter -quiet $input_start_cells "NAME != $input_data_reg"]
    }

    set input_start_regs [filter -quiet $input_start_cells {(PRIMITIVE_GROUP == REGISTER && PRIMITIVE_SUBGROUP == SDR) || (PRIMITIVE_GROUP == FLOP_LATCH) || (PRIMITIVE_GROUP == DMEM)}]

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
          -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -include_replicated_objects $sync_rst_inst/genblk1[*].cdc_async_stage_reg[*]]]
      } else {
        set input_clk [get_clocks -of_objects $input_start_regs]
        set input_clk_period [get_property -min PERIOD $input_clk]

        set_max_delay -datapath_only \
          -from $input_start_regs \
          -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -include_replicated_objects $sync_rst_inst/genblk1[*].cdc_async_stage_reg[*]]] \
          $input_clk_period
      }
    }

    # constrain the reset signals between the async registers
    set input_data_reg_cdc [get_cells -quiet -include_replicated_objects $sync_rst_inst/genblk1[*].cdc_async_stage_reg[0]]
    # skip if no register is found
    if {$input_data_reg_cdc eq ""} {
      continue
    }
    foreach input_data_reg_cdc_i $input_data_reg_cdc {
      set input_data_reg_pin [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects $input_data_reg_cdc_i]

      set input_start_cells [all_fanin -quiet -flat -only_cells [get_pins -quiet -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects $input_data_reg_cdc_i]]
      foreach input_data_reg $input_data_reg_cdc_i {
        set input_start_cells [filter -quiet $input_start_cells "NAME != $input_data_reg"]
      }

      set input_start_regs [filter -quiet $input_start_cells {(PRIMITIVE_GROUP == REGISTER && PRIMITIVE_SUBGROUP == SDR) || (PRIMITIVE_GROUP == FLOP_LATCH) || (PRIMITIVE_GROUP == DMEM)}]

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
            -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_rst_inst/genblk1[*].cdc_async_stage_reg[*]]]
        } else {
          set input_clk [get_clocks -of_objects $input_start_regs]
          set input_clk_period [get_property -min PERIOD $input_clk]

          set_max_delay -datapath_only \
            -from $input_start_regs \
            -to [get_pins -include_replicated_objects -filter {REF_PIN_NAME == D} -of_objects [get_cells -include_replicated_objects $sync_rst_inst/genblk1[*].cdc_async_stage_reg[*]]] \
            $input_clk_period
        }
      }
    }
  }

  # util rst constraints
  if {$ip_inst != ""} {
    current_instance -quiet
    current_instance $ip_inst
  }
  foreach sync_clkdiv [get_cells -quiet -include_replicated_objects -hier -filter {(ORIG_REF_NAME == util_clkdiv || REF_NAME == util_clkdiv)}] {
    current_instance -quiet

    set_clock_groups -logically_exclusive \
      -group [get_clocks -of_objects [get_pins -filter {REF_PIN_NAME == O} -of_objects [get_cells -include_replicated_objects $sync_clkdiv/clk_divide_sel_0]]] \
      -group [get_clocks -of_objects [get_pins -filter {REF_PIN_NAME == O} -of_objects [get_cells -include_replicated_objects $sync_clkdiv/clk_divide_sel_1]]]

    set_false_path -to [get_pins -include_replicated_objects $sync_clkdiv/i_div_clk_gbuf/S*]
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
