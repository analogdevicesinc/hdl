###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

if { ![regexp {AD485[1-8]} $DEVICE]} {
  puts "ERROR: Device \"$DEVICE\" not supported."
  puts "Suported devices:"
  puts "AD4858"
  puts "AD4857"
  puts "AD4856"
  puts "AD4855"
  puts "AD4854"
  puts "AD4853"
  puts "AD4852"
  puts "AD4851"
  exit 1
}

set numb_of_lanes [expr {$DEVICE eq {AD4858} ? 8 : \
                         $DEVICE eq {AD4857} ? 8 : \
                         $DEVICE eq {AD4856} ? 8 : \
                         $DEVICE eq {AD4855} ? 8 : \
                         $DEVICE eq {AD4854} ? 4 : \
                         $DEVICE eq {AD4853} ? 4 : \
                         $DEVICE eq {AD4852} ? 4 : \
                         $DEVICE eq {AD4851} ? 4 : 8}]

