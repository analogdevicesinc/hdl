###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Select the device and mode you want the project synthesise for, by setting the
# ADI_DAC_DEVICE, ADI_DAC_MODE or ADI_LANE_RATE environment variables:
#
# make ADI_LANE_RATE=4.16 ADI_DAC_DEVICE=AD9163 ADI_DAC_MODE=08
# 
# Or just run make without any parameters (will build for AD9162, Mode 08,
# 12.5 GHz)

# Default:
set device AD9162
set mode   08

if [info exists ::env(ADI_DAC_DEVICE)] {
  set device $::env(ADI_DAC_DEVICE)
} else {
  set env(ADI_DAC_DEVICE) $device
}

if [info exists ::env(ADI_DAC_MODE)] {
  set mode $::env(ADI_DAC_MODE)
} else {
  set env(ADI_DAC_MODE) $mode
}

# single link only
set num_links 1

# This reference design supports the following devices and modes:

# AD9161
#                 Mode M L S F HD N NP
set params(AD9161,01) {2 1 1 4 1 16 16}
set params(AD9161,02) {2 2 2 2 1 16 16}
set params(AD9161,03) {2 3 3 4 1 16 16}
set params(AD9161,04) {2 4 1 1 1 16 16}
set params(AD9161,06) {2 6 3 2 1 16 16}
set params(AD9161,08) {2 8 2 1 1 16 16}

# AD9162
#                 Mode M L S F HD N NP
set params(AD9162,01) {2 1 1 4 1 16 16}
set params(AD9162,02) {2 2 2 2 1 16 16}
set params(AD9162,03) {2 3 3 4 1 16 16}
set params(AD9162,04) {2 4 1 1 1 16 16}
set params(AD9162,06) {2 6 3 2 1 16 16}
set params(AD9162,08) {2 8 2 1 1 16 16}

# AD9163
#                 Mode M L S F HD N NP
set params(AD9163,01) {2 1 1 4 1 16 16}
set params(AD9163,02) {2 2 1 2 1 16 16}
set params(AD9163,03) {2 3 3 4 1 16 16}
set params(AD9163,04) {2 4 1 1 1 16 16}
set params(AD9163,06) {2 6 3 2 1 16 16}
set params(AD9163,08) {2 8 2 1 1 16 16}

# AD9164
#                 Mode M L S F HD N NP
set params(AD9164,01) {2 1 1 4 1 16 16}
set params(AD9164,02) {2 2 2 2 1 16 16}
set params(AD9164,03) {2 3 3 4 1 16 16}
set params(AD9164,04) {2 4 1 1 1 16 16}
set params(AD9164,06) {2 6 3 2 1 16 16}
set params(AD9164,08) {2 8 2 1 1 16 16}

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
