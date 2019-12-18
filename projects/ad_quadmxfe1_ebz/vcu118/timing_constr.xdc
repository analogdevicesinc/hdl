# Primary clock definitions

# These two reference clocks are connect to the same source on the PCB
create_clock -name refclk         -period  2.00 [get_ports fpga_clk_m2c_p[0]]
create_clock -name refclk_replica -period  2.00 [get_ports fpga_clk_m2c_0_replica_n]

# device clock
create_clock -name device_clk     -period  4.00 [get_ports fpga_clk_m2c_p[4]]


# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks device_clk] \
  [get_property PERIOD [get_clocks device_clk]] \
  [get_ports {fpga_sysref_m2c_*}]


