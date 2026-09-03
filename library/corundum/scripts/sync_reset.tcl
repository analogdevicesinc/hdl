###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set sync_reset_ffs [get_cells -quiet -hier *sync_reg_reg*]
if {[llength $sync_reset_ffs]} {
  set_false_path -to $sync_reset_ffs
}
