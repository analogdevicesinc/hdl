###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]

# Maximum lane rate of 14.2 Gbps however the dacfifo does not meet the 355 MHz requirement, reducing it to 333MHz
create_clock -period  "3 ns" -name tx_ref_clk         [get_ports {tx_ref_clk}]

# Asynchronous GPIOs

foreach async_input {gpio_bd_i[*]} {
   set_false_path -from [get_ports $async_input]
}

foreach async_output {gpio_bd_o[*] txen_0 txen_1 spi_en_n} {
   set_false_path -to [get_ports $async_output]
}
derive_pll_clocks
derive_clock_uncertainty
