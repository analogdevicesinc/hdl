create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "6.000 ns"  -name emif_ref_clk        [get_ports {emif_hps_pll_ref_clk}]

source ./jtag.sdc

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

# FPGA IO port constraints
set_false_path -from [get_ports {sys_button_pio[0]}] -to *
set_false_path -from [get_ports {sys_button_pio[1]}] -to *
set_false_path -from [get_ports {sys_sgpio_clk}] -to *
set_false_path -from [get_ports {sys_sgpi}] -to *
set_false_path -from [get_ports {sys_sgpio_sync}] -to *
set_false_path -from * -to [get_ports {sys_sgpo}]
set_false_path -from [get_ports {sys_dipsw_pio[0]}] -to *
set_false_path -from [get_ports {sys_dipsw_pio[1]}] -to *
set_false_path -from [get_ports {sys_dipsw_pio[2]}] -to *
set_false_path -from [get_ports {sys_dipsw_pio[3]}] -to *
set_false_path -from [get_ports {sys_led_pio[0]}] -to *
set_false_path -from [get_ports {sys_led_pio[1]}] -to *
set_false_path -from [get_ports {sys_led_pio[2]}] -to *
set_false_path -from [get_ports {sys_led_pio[3]}] -to *
set_false_path -from * -to [get_ports {sys_led_pio[0]}]
set_false_path -from * -to [get_ports {sys_led_pio[1]}]
set_false_path -from * -to [get_ports {sys_led_pio[2]}]
set_false_path -from * -to [get_ports {sys_led_pio[3]}]
