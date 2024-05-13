
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "5.000 ns"  -name ref_clk             [get_ports {fpga_refclk_in}]
create_clock -period "10.000 ns"  -name tx_device_clk       [get_ports {clkin6}]
create_clock -period "10.000 ns"  -name rx_device_clk       [get_ports {clkin10}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay \
  -clock tx_device_clk \
  [get_clock_info -period tx_device_clk] \
  [get_ports {sysref2}]