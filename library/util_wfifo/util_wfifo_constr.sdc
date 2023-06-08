###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path -from [get_registers *din_enable*] -to [get_registers *dout_enable_m1*]
set_false_path -from [get_registers *din_req_t*]  -to [get_registers *dout_req_t_m1*]
set_false_path -from [get_registers *din_rinit*]  -to [get_registers *dout_rinit*]
set_false_path -from [get_registers *dout_ovf_d*] -to [get_registers *din_ovf_m1*]

