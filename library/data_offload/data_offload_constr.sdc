###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path -to    [get_registers *data_offload*cdc_sync_stage1*]
set_false_path -from  [get_registers *data_offload*cdc_sync_fifo_ram*]
