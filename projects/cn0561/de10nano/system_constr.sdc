###############################################################################
## Copyright (C) 2023-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "20.000 ns"  -name sys_clk     [get_ports {sys_clk}]
create_clock -period "16.666 ns"  -name usb1_clk    [get_ports {usb1_clk}]

derive_pll_clocks
derive_clock_uncertainty

# Virtual clock representing DCLK/SCLK as seen by the AD4134
# create_clock -period 20.0 -name cn0561_dclk_virt

# DOUTx input delay relative to DCLK
set_input_delay -clock cn0561_dclk_virt -max 8.2 [get_ports cn0561_din[*]]
set_input_delay -clock cn0561_dclk_virt -min 0.0 [get_ports cn0561_din[*]]

# SDO input delay relative to SCLK falling
set_input_delay -clock cn0561_dclk_virt -clock_fall -max 8.0 [get_ports cn0561_spi_sdi]
set_input_delay -clock cn0561_dclk_virt -clock_fall -min 0.0 [get_ports cn0561_spi_sdi]

# Virtual clock is unrelated to PLL domain
set_false_path -from [get_clocks cn0561_dclk_virt] -to [get_clocks *spi_clk_pll*]

# GPIO mux select (quasi-static) crossing into SPI Engine clock domain
set_false_path -from [get_registers {*sys_gpio_out*}] -to [get_registers {*cn0561_spi*data_sdi_shift*}]
