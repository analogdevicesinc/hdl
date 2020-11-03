
create_clock -period "10.000 ns"  -name sys_clk_100mhz        [get_ports {sys_clk}]
create_clock -period  "8.000 ns"  -name eth_ref_clk           [get_ports {eth_ref_clk}]
create_clock -period "30.303 ns"  -name {altera_reserved_tck} {altera_reserved_tck}
create_clock -period "100.00 ns"  -name sys_spi_clk           [get_registers {i_system_bd|sys_spi|sys_spi|SCLK_reg}]

set_false_path -from [get_ports {sys_resetn}]
set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]
set_false_path -from * -to [get_ports {flash_resetn}]

