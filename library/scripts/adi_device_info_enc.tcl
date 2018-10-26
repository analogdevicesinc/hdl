## ***************************************************************************
## ***************************************************************************
## Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
##
## In this HDL repository, there are many different and unique modules, consisting
## of various HDL (Verilog or VHDL) components. The individual modules are
## developed independently, and may be accompanied by separate and unique license
## terms.
##
## The user should read each of these license terms, and understand the
## freedoms and responsibilities that he or she has by using this source/core.
##
## This core is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
## A PARTICULAR PURPOSE.
##
## Redistribution and use of source or resulting binaries, with or without modification
## of this file, are permitted under one of the following two license terms:
##
##   1. The GNU General Public License version 2 as published by the
##      Free Software Foundation, which can be found in the top level directory
##      of this repository (LICENSE_GPL2), and also online at:
##      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
##
## OR
##
##   2. An ADI specific BSD license, which can be found in the top level directory
##      of this repository (LICENSE_ADIBSD), and also on-line at:
##      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
##      This will allow to generate bit files and not release the source code,
##      as long as it attaches to an ADI device.
##
## ***************************************************************************
## ***************************************************************************

# adi_device_info_enc.tcl

variable auto_set_param_list
variable fpga_series_list
variable fpga_family_list
variable speed_grade_list
variable dev_package_list
variable xcvr_type_list

# Parameter list for automatic assignament
set auto_set_param_list {
          XCVR_TYPE \
          DEV_PACKAGE \
          SPEED_GRADE \
          FPGA_FAMILY \
          FPGA_TECHNOLOGY}


# List for automatically assigned parameter values and encoded values
# The list name must be the parameter name (lowercase), appending "_list" to it
set fpga_technology_list { \
        { 7series     0 } \
        { ultrascale  1 } \
        { ultrascale+ 2 }}

set fpga_family_list { \
        { artix  0 } \
        { kintex 1 } \
        { virtex 2 } \
        { zynq   3 }}

set speed_grade_list { \
        { -1   10 } \
        { -1L  11 } \
        { -1H  12 } \
        { -1HV 13 } \
        { -1LV 14 } \
        { -2   20 } \
        { -2L  21 } \
        { -2LV 22 } \
        { -3   30 }}

set dev_package_list { \
        { rf 1  } \
        { fl 2  } \
        { ff 3  } \
        { fb 4  } \
        { hc 5  } \
        { fh 6  } \
        { cs 7  } \
        { cp 8  } \
        { ft 9  } \
        { fg 10 } \
        { sb 11 } \
        { rb 12 } \
        { rs 13 } \
        { cl 14 } \
        { sf 15 } \
        { ba 16 } \
        { fa 17 }}

set xcvr_type_list { \
        { GTPE2_NOT_SUPPORTED 1 } \
        { GTXE2               2 } \
        { GTHE2_NOT_SUPPORTED 3 } \
        { GTZE2_NOT_SUPPORTED 4 } \
        { GTHE3               5 } \
        { GTYE3_NOT_SUPPORTED 6 } \
        { GTRE4_NOT_SUPPORTED 7 } \
        { GTHE4               8 } \
        { GTYE4_NOT_SUPPORTED 9 } \
        { GTME4_NOT_SUPPORTED 10}}

## ***************************************************************************
## ***************************************************************************
