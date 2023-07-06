###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# For Arria 10 architecture
set_global_assignment -name MESSAGE_DISABLE 17951 ; ## unused RX channels
set_global_assignment -name MESSAGE_DISABLE 18655 ; ## unused TX channels

# For Stratix 10 architecture
set_global_assignment -name MESSAGE_DISABLE 19527 ; ## unused TX/RX channels

set_global_assignment -name MESSAGE_DISABLE 114001 ; ## Time value $x truncated to $y
