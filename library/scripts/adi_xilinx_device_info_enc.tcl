###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# adi_xilinx_device_info_enc.tcl

variable auto_set_param_list
variable auto_set_param_list_overwritable
variable fpga_series_list
variable fpga_family_list
variable speed_grade_list
variable dev_package_list
variable xcvr_type_list
variable fpga_voltage_list

# Parameter list for automatic assignament
set auto_set_param_list { \
          DEV_PACKAGE \
          SPEED_GRADE \
          FPGA_FAMILY \
          FPGA_TECHNOLOGY }

set auto_set_param_list_overwritable { \
          FPGA_VOLTAGE \
          XCVR_TYPE }

# List for automatically assigned parameter values and encoded values
# The list name must be the parameter name (lowercase), appending "_list" to it
set fpga_technology_list { \
        { Unknown     0 } \
        { 7series     1 } \
        { ultrascale  2 } \
        { ultrascale+ 3 } \
        { versal      4 }}

set fpga_family_list { \
        { Unknown       0 } \
        { artix         1 } \
        { kintex        2 } \
        { virtex        3 } \
        { zynq          4 } \
        { versalprime   5 } \
        { versalaicore  6 } \
        { versalpremium 7 }}

set speed_grade_list { \
        { Unknown 0  } \
        { -1      10 } \
        { -1L     11 } \
        { -1H     12 } \
        { -1HV    13 } \
        { -1LV    14 } \
        { -2      20 } \
        { -2L     21 } \
        { -2LV    22 } \
        { -2MP    23 } \
        { -2LVC   24 } \
        { -2LVI   25 } \
        { -3      30 }}

set dev_package_list { \
        { Unknown 0  } \
        { rf      1  } \
        { fl      2  } \
        { ff      3  } \
        { fb      4  } \
        { hc      5  } \
        { fh      6  } \
        { cs      7  } \
        { cp      8  } \
        { ft      9  } \
        { fg      10 } \
        { sb      11 } \
        { rb      12 } \
        { rs      13 } \
        { cl      14 } \
        { sf      15 } \
        { ba      16 } \
        { fa      17 } \
        { fs      18 } \
        { fi      19 } \
        { vs      20 } \
        { ls      21 }}


set xcvr_type_list { \
        { Unknown             0 } \
        { GTPE2_NOT_SUPPORTED 1 } \
        { GTXE2               2 } \
        { GTHE2_NOT_SUPPORTED 3 } \
        { GTZE2_NOT_SUPPORTED 4 } \
        { GTHE3               5 } \
        { GTYE3_NOT_SUPPORTED 6 } \
        { GTRE4_NOT_SUPPORTED 7 } \
        { GTHE4               8 } \
        { GTYE4               9 } \
        { GTME4_NOT_SUPPORTED 10}}

set fpga_voltage_list {0 5000} ;# 0 to 5000mV


## ***************************************************************************

proc adi_device_spec {cellpath param} {

  set list_pointer [string tolower $param]
  set list_pointer [append list_pointer "_list"]

  upvar 1 $list_pointer $list_pointer

  set ip [get_bd_cells $cellpath]
  set part [get_property PART [current_project]]

  switch -regexp -- $param {
      FPGA_TECHNOLOGY {
          switch  -regexp -- $part {
             ^xc7          {set series_name 7series}
             ^xczu         {set series_name ultrascale+}
             ^xcvu.?.p     {set series_name ultrascale+}
             ^x.zu..?p     {set series_name ultrascale+}
             ^xck26        {set series_name ultrascale+}
             ^xc.u         {set series_name ultrascale }
             ^xcv[ecmph]   {set series_name versal}
             default {
                 puts "Undefined fpga technology for \"$part\"!"
                 exit -1
             }
          }
          return "$series_name"
      }
      FPGA_FAMILY {
          set fpga_family [get_property FAMILY $part]
          foreach i $fpga_family_list {
              regexp ^[lindex $i 0] $fpga_family matched
          }
          return "$matched"
      }
      SPEED_GRADE {
          set speed_grade [get_property SPEED $part]
          return "$speed_grade"
      }
      DEV_PACKAGE {
          set dev_package [get_property PACKAGE $part]
          foreach i $dev_package_list {
              regexp ^[lindex $i 0] $dev_package matched
          }
          return "$matched"
      }
      XCVR_TYPE {
          set matched ""
          set dev_transcivers "none"
          foreach x [list_property $part] {
              regexp ^GT..._TRANSCEIVERS $x dev_transcivers
          }
          foreach i $xcvr_type_list {
              regexp ^[lindex $i 0] $dev_transcivers matched
          }
          if { $matched eq "" } {
               puts "CRITICAL WARNING: \"$dev_transcivers\" TYPE IS NOT SUPPORTED BY ADI!"
          }
          return "$matched"
      }
      FPGA_VOLTAGE {
          set fpga_voltage [get_property REF_OPERATING_VOLTAGE $part]
	  set fpga_voltage [expr int([expr $fpga_voltage * 1000])] ;# // V to mV conversion(integer val)

          return "$fpga_voltage"
      }
      default {
          puts "WARNING: UNDEFINED PARAMETER \"$param\" (adi_device_spec)!"
      }
  }
}


## ***************************************************************************
## ***************************************************************************
