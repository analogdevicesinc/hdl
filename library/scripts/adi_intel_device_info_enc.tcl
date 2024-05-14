###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# adi_intel_device_info_enc.tcl

# The main rule when adding a new parameter is to have the same names for the parameter
# and it's list (valid range type or supported entity and its encoded value type)

variable auto_set_param_list
variable fpga_technology_list
variable fpga_technology
variable fpga_family_list
variable fpga_family
variable speed_grade_list
variable speed_grade
variable dev_package_list
variable dev_package
variable xcvr_type_list
variable xcvr_type
variable fpga_voltage_list
variable fpga_voltage

# Parameter list for automatic assignament(generation)
set auto_gen_param_list { \
          FPGA_TECHNOLOGY \
          FPGA_FAMILY \
          SPEED_GRADE \
          DEV_PACKAGE}

set auto_set_param_list { \
          FPGA_VOLTAGE \
          XCVR_TYPE}


# List for automatically assigned parameter values and encoded values
# The list name must be the parameter name (lowercase), appending "_list" to it
set fpga_technology_list { \
        { Unknown      100 } \
        { "Cyclone V"  101 } \
        { "Cyclone 10" 102 } \
        { "Arria 10"   103 } \
        { "Stratix 10" 104 } \
        { "Agilex 7"   105 }}

set fpga_family_list { \
        { Unknown   0 } \
        { SX        1 } \
        { GX        2 } \
        { GT        3 } \
        { GZ        4 } \
        { "SE Base" 5 } \
        { "I-Series with HPS only" 6 } \
        { TX        6 }}

       #technology 5 generation
       # family Arria SX

set speed_grade_list { \
        { Unknown   0 } \
        { 1         1 } \
        { 2         2 } \
        { 3         3 } \
        { 4         4 } \
        { 5         5 } \
        { 6         6 } \
        { 7         7 } \
        { 8         8 }}

set dev_package_list { \
        { Unknown   0 } \
        { BGA       1 } \
        { PGA       2 } \
        { FBGA      3 } \
        { HBGA      4 } \
        { PDIP      5 } \
        { EQFP      6 } \
        { PLCC      7 } \
        { PQFP      8 } \
        { RQFP      9 } \
        { TQFP     10 } \
        { UBGA     11 } \
        { UFBGA    12 } \
        { MBGA     13 }}

# Ball-Grid Array (BGA)
# Ceramic Pin-Grid Array (PGA)
# FineLine BGA (FBGA)
# Hybrid FineLine BGA (HBGA)
# Plastic Dual In-Line Package (PDIP)
# Plastic Enhanced Quad Flat Pack (EQFP)
# Plastic J-Lead Chip Carrier (PLCC)
# Plastic Quad Flat Pack (PQFP)
# Power Quad Flat Pack (RQFP)
# Thin Quad Flat Pack (TQFP)
# Ultra FineLine BGA (UBGA-UFBGA)

# transceiver speedgrade
set xcvr_type_list { 0 9 }

set fpga_voltage_list { 0 5000 } ;# min 0mV max 5V

################################################################################

proc get_part_param {} {

    global fpga_technology
    global fpga_family
    global speed_grade
    global dev_package
    global xcvr_type
    global fpga_voltage

    set device [get_parameter_value DEVICE]

    # user and system values (sys_val)
    if {[catch {set fpga_technology [quartus::device::get_part_info -family $device]} fid]} {
      set fpga_technology "Unknown"
    }
    if {[catch {set fpga_family [quartus::device::get_part_info -family_variant $device]} fid]} {
      set fpga_family "Unknown"
    }
    if {[catch {set speed_grade [quartus::device::get_part_info -speed_grade $device]} fid]} {
      set speed_grade "Unknown"
    }
    if {[catch {set dev_package [quartus::device::get_part_info -package $device]} fid]} {
      set dev_package "Unknown"
    }
    if {[catch {set xcvr_type [quartus::device::get_part_info -hssi_speed_grade $device]} fid]} {
      set xcvr_type "Unknown"
    }
    if {[catch {set fpga_voltage [quartus::device::get_part_info -default_voltage $device]} fid]} {
      set fpga_voltage "0"
    }

    # user and system values (sys_val)
    if { $fpga_technology == "{{Agilex 7}}" } {
      # TODO : Transform VID2 to some voltage
      set fpga_voltage "0"
    } else {
      regsub {V} $fpga_voltage "" fpga_voltage
      set fpga_voltage [expr int([expr $fpga_voltage * 1000])] ;# // V to mV conversion(integer val)
    }

}

## ***************************************************************************
## ***************************************************************************
