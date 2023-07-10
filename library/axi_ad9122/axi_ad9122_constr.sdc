###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path  -from [get_registers *up_drp_locked*] -to [get_registers *dac_status_m1*]

