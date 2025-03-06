###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period  "6.000 ns"  -name sys_ddr_ref_clk        [get_ports {sys_ddr_ref_clk_clk}]
