###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path  -from [get_registers *up_xfer_cntrl:i_xfer_cntrl|d_xfer_toggle*]      -to [get_registers *up_xfer_cntrl:i_xfer_cntrl|up_xfer_state_m1*]
set_false_path  -from [get_registers *up_xfer_cntrl:i_xfer_cntrl|up_xfer_toggle*]     -to [get_registers *up_xfer_cntrl:i_xfer_cntrl|d_xfer_toggle_m1*]
set_false_path  -from [get_registers *up_xfer_cntrl:i_xfer_cntrl|up_xfer_data*]       -to [get_registers *up_xfer_cntrl:i_xfer_cntrl|d_data_cntrl*]
