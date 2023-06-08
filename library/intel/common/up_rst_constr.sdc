###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path  -to [get_pins -hierarchical -nocase rst_async_d*|CLRN]
set_false_path  -to [get_pins -hierarchical -nocase rst_sync|CLRN]

