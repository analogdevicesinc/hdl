###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path -from [get_registers *dout_enable*]  -to [get_registers *din_enable_m1*]
set_false_path -from [get_registers *dout_req_t*]   -to [get_registers *din_req_t_m1*]
set_false_path -from [get_registers *dout_init*]    -to [get_registers *din_init*]
set_false_path -from [get_registers *din_unf_d*]    -to [get_registers *dout_unf_m1*]

