###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path -from [get_cells -hier -filter {name =~ *up_drp_locked_reg  && IS_SEQUENTIAL}] \
	-to [get_cells -hier -filter {name =~ *dac_status_m1_reg && IS_SEQUENTIAL}]
