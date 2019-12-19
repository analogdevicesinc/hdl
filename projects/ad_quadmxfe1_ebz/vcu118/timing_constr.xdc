# Primary clock definitions

# These two reference clocks are connect to the same source on the PCB
create_clock -name refclk         -period  2.00 [get_ports fpga_clk_m2c_p[0]]
create_clock -name refclk_replica -period  2.00 [get_ports fpga_clk_m2c_0_replica_n]

# device clock
create_clock -name device_clk     -period  4.00 [get_ports fpga_clk_m2c_p[4]]

# SPI 2 clock
create_generated_clock -name spi_2_clk  \
  -source [get_pins i_system_wrapper/system_i/axi_spi_2/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi_2/sck_o]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks device_clk] \
  [get_property PERIOD [get_clocks device_clk]] \
  [get_ports {fpga_sysref_m2c_*}]


