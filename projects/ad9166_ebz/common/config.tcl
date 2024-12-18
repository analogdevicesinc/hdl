###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# AD9166-FMC-EBZ
# Select the mode you want the project synthesised for, by setting the
# ADI_DAC_MODE environment variable:
#
# make ADI_DAC_MODE=04

# Only option for device is AD9166.
# The default mode is 04

set device AD9166
puts "modul $mode"

if {[info exists ::env(ADI_DAC_MODE)]} {
  set mode [get_env_param ADI_DAC_MODE 04]
} elseif {![info exists ADI_DAC_MODE]} {
  set mode 04
}

# This reference design supports the AD9166 device with modes:
#                 Mode M L S F HD N NP
set params(AD9166,01) {2 1 1 4 1 16 16}
set params(AD9166,02) {2 2 1 2 1 16 16}
set params(AD9166,03) {2 3 3 4 1 16 16}
set params(AD9166,04) {2 4 1 1 1 16 16}
set params(AD9166,06) {2 6 3 2 1 16 16}
# lane rate = 12.5Gbps
set params(AD9166,08) {2 8 2 1 1 16 16}
set params(AD9166,09) {1 8 4 1 1 16 16}

# Internal procedures
proc get_config_param {param} {
  upvar device device
  upvar mode mode
  upvar params params

  set jesd_params {M L S F HD N NP}

  if {[info exists ::env($param)]} {
    return $::env($param)
  } else {
    set index [lsearch $jesd_params $param]
    return [lindex $params($device,$mode) $index]
  }
}
