###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Function to execute a `make` command for xcvr_wizard project within another project.
#
# \param[parameters_for_make] - parameters for the make command
# \param[carrier_name] - (optional) carrier name, if not provided it will be auto-detected from current directory
#
# Usage:
#   adi_xcvr_project {LANE_RATE 10 REF_CLK 100}
#   adi_xcvr_project {LANE_RATE 10 REF_CLK 100} kcu105
#
proc adi_xcvr_project {parameters_for_make {carrier_name ""}} {

  global ad_hdl_dir

  set project_name "xcvr_wizard"
  set current_dir [pwd]

  if {$carrier_name eq ""} {
    set carrier_name [file tail $current_dir]
  }

  switch $carrier_name {
    "zc706" {
      set xcvr_type GTXE2
    }
    "kc705" {
      set xcvr_type GTXE2
    }
    "zed" {
      set xcvr_type GTXE2
    }
    "vc707" {
      set xcvr_type GTXE2
    }
    "kcu105" {
      set xcvr_type GTHE3
    }
    "zcu102" {
      set xcvr_type GTHE4
    }
    "vcu118" {
      set xcvr_type GTYE4
    }
    "vcu128" {
      set xcvr_type GTYE4
    }
    default {
      puts "ERROR adi_project_make: Unsupported carrier (device)."
      return 1
    }
  }

  set make_command "make"
  set adi_project_dir_path [file join $ad_hdl_dir/projects $project_name $carrier_name]
  puts $adi_project_dir_path
  cd $adi_project_dir_path

  set adi_dir_env ""
  if {[info exists ::env(ADI_PROJECT_DIR)] && $::env(ADI_PROJECT_DIR) ne ""} {
    set adi_dir_env [file tail [string trimright $::env(ADI_PROJECT_DIR) "/"]]
  }

  if {[llength $parameters_for_make] > 0} {

    set formatted_params {}
    set gt_xcvr_file {}

    foreach {key value} $parameters_for_make {
        lappend formatted_params "$key=$value"
        set key_parsed [string map {"LANE_" "" "_" ""} $key]
        set value_parrsed [string map {. _} $value]
        set ad_project_make_params($key) $value_parrsed
        set tok "${key_parsed}${value_parrsed}"

        if {$adi_dir_env eq "" || ![regexp "(^|_)${tok}(_|$)" $adi_dir_env]} {
          set gt_xcvr_file [linsert $gt_xcvr_file 0 "$tok"]
        }
    }

    append make_command " " [join $formatted_params " "]
    set gt_xcvr_file [join  $gt_xcvr_file "_"]
    set config_parser_dir_name "${xcvr_type}_${ad_project_make_params(PLL_TYPE)}_${ad_project_make_params(LANE_RATE)}_${ad_project_make_params(REF_CLK)}"
    set file_local_param [string tolower $config_parser_dir_name]
    append file_local_param "_common.v"
  }

  eval exec $make_command
  cd $current_dir

  if {$adi_dir_env ne ""} {
      if {$gt_xcvr_file eq ""} {
        append adi_project_dir_path "/${::env(ADI_PROJECT_DIR)}${project_name}_${carrier_name}.gen/sources_1/ip/${xcvr_type}_cfng.txt"
      } else {
        append adi_project_dir_path "/$gt_xcvr_file\_$::env(ADI_PROJECT_DIR)${project_name}_${carrier_name}.gen/sources_1/ip/${xcvr_type}_cfng.txt"
      }
  } else {
      append adi_project_dir_path "/$gt_xcvr_file/${project_name}_${carrier_name}.gen/sources_1/ip/${xcvr_type}_cfng.txt"
  }

  set config_dir_path [file dirname $adi_project_dir_path]
  set file_local_param_path ""

  if {$xcvr_type == "GTXE2"} {
    set file_local_param_path [file join $config_dir_path $config_parser_dir_name $file_local_param]
  }

  return [dict create "cfng_file_path" $adi_project_dir_path "param_file_path" $file_local_param_path]
}
