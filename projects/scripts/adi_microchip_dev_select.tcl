###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Determine device parameters based on the carrier name in project_name.
# Analogue to adi_lattice_dev_select.tcl.
#
# Sets: device, die, package, speed, die_voltage

if {[regexp {(^|_)mpfs_icicle(_sim)?$} $project_name]} {
  set device      "MPFS250T_ES"
  set die         "MPFS250T"
  set package     "FCVG484"
  set speed       "STD"
  set die_voltage "1.05"
} elseif {[regexp {(^|_)mpfs_video_kit(_sim)?$} $project_name]} {
  set device      "MPFS250TS"
  set die         "MPFS250TS"
  set package     "FCG1152"
  set speed       "-1"
  set die_voltage "1.0"
}
