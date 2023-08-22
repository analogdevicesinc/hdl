# Primary clock definitions
create_clock -name refclk         -period  2 [get_ports ref_clk_p]

# device clock
create_clock -name device_clk     -period  4 [get_ports core_clk_p]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks core_clk_p] \
  [get_property PERIOD [get_clocks core_clk_p]] \
  [get_ports {sysref*}]

