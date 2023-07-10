###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path  -to [get_registers *axi_ad9684_if:i_ad9684_if|adc_status_m1*]
set_false_path  -to [get_registers *up_delay_cntrl:i_delay_cntrl|up_dlocked_m1*]

