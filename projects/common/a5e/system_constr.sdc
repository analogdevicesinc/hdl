###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "10.000 ns"  -name emif_ref_clk        [get_ports {emif_hps_ref_clk}]

derive_clock_uncertainty

set_multicycle_path 2 -setup \
    -from [get_registers {*|sys_hps|sm_hps|sundancemesa_hps_inst~intosc_clk.reg}] \
    -to [get_registers {*|sys_hps|sm_hps|sundancemesa_hps_inst~intosc_clk.reg}]
set_multicycle_path 1 -hold \
    -from [get_registers {*|sys_hps|sm_hps|sundancemesa_hps_inst~intosc_clk.reg}] \
    -to [get_registers {*|sys_hps|sm_hps|sundancemesa_hps_inst~intosc_clk.reg}]

set_clock_groups -asynchronous \
    -group [get_clocks {hps_internal_osc}] \
    -group [get_clocks {sys_clk_100mhz}]

set_false_path \
    -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]
