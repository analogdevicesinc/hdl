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
