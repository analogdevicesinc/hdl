###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path  -from [get_registers *up_xfer_status:i_xfer_status|up_xfer_toggle*]   -to [get_registers *up_xfer_status:i_xfer_status|d_xfer_state_m1*]
set_false_path  -from [get_registers *up_xfer_status:i_xfer_status|d_xfer_toggle*]    -to [get_registers *up_xfer_status:i_xfer_status|up_xfer_toggle_m1*]
set_false_path  -from [get_registers *up_xfer_status:i_xfer_status|d_xfer_data*]      -to [get_registers *up_xfer_status:i_xfer_status|up_data_status*]
