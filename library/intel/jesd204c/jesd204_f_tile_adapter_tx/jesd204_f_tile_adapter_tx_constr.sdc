###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

set_false_path -to [get_registers {*|o_resetn_cdc|cdc_sync_stage*[0]}]

# FIFO constraints
set_false_path -to {*|dcfifo_component|auto_generated|rdaclr|dffe*a[0]}
set_false_path -to {*|dcfifo_component|auto_generated|wraclr|dffe*a[0]}

set_false_path -from [get_registers {*dcfifo*delayed_wrptr_g[*]}] -to [get_registers {*dcfifo*rs_dgwp*}]
set_false_path -from [get_registers {*dcfifo*rdptr_g[*]}] -to [get_registers {*dcfifo*ws_dgrp*}]
