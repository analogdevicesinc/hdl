
# SPI interface

set_property -dict {PACKAGE_PIN  G15 IOSTANDARD LVCMOS33 IOB TRUE}                  [get_ports cn0540_spi_sclk]    ; ## CK_IO13
set_property -dict {PACKAGE_PIN  J18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP}  [get_ports cn0540_spi_miso]    ; ## CK_IO12
set_property -dict {PACKAGE_PIN  K18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP}  [get_ports cn0540_spi_mosi]    ; ## CK_IO11
set_property -dict {PACKAGE_PIN  U15 IOSTANDARD LVCMOS33}                           [get_ports cn0540_spi_cs]      ; ## CK_IO10

# reset and GPIO signals

set_property -dict {PACKAGE_PIN  M18 IOSTANDARD LVCMOS33}                           [get_ports cn0540_shutdown]    ; ## CK_IO9
set_property -dict {PACKAGE_PIN  R14 IOSTANDARD LVCMOS33}                           [get_ports cn0540_reset_adc]   ; ## CK_IO7
set_property -dict {PACKAGE_PIN  V18 IOSTANDARD LVCMOS33}                           [get_ports cn0540_csb_aux]     ; ## CK_IO5
set_property -dict {PACKAGE_PIN  V17 IOSTANDARD LVCMOS33}                           [get_ports cn0540_sw_ff]       ; ## CK_IO4
set_property -dict {PACKAGE_PIN  T15 IOSTANDARD LVCMOS33}                           [get_ports cn0540_drdy_aux]    ; ## CK_IO3
set_property -dict {PACKAGE_PIN  V13 IOSTANDARD LVCMOS33}                           [get_ports cn0540_blue_led]    ; ## CK_IO1
set_property -dict {PACKAGE_PIN  U14 IOSTANDARD LVCMOS33}                           [get_ports cn0540_yellow_led]  ; ## CK_IO0

# synchronization and timing

set_property -dict {PACKAGE_PIN  R17 IOSTANDARD LVCMOS33}                           [get_ports cn0540_sync_in]     ; ## CK_IO6
set_property -dict {PACKAGE_PIN  T14 IOSTANDARD LVCMOS33}                           [get_ports cn0540_drdy]        ; ## CK_IO2

set_property -dict {PACKAGE_PIN  P16 IOSTANDARD LVCMOS33}                           [get_ports cn0540_scl]         ; ## CK_SCL
set_property -dict {PACKAGE_PIN  P15 IOSTANDARD LVCMOS33}                           [get_ports cn0540_sda]         ; ## CK_SDA

# relax the timing between the SDO FIFO and shift-register
set_multicycle_path 2 -setup -from [get_cells -hierarchical -filter {NAME=~*/i_sdo_fifo/i_mem/m_ram_reg}] -to [get_pins -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]/D}]
set_multicycle_path 1 -hold  -from [get_cells -hierarchical -filter {NAME=~*/i_sdo_fifo/i_mem/m_ram_reg}] -to [get_pins -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]/D}]

# rename auto-generated clock for SPI Engine to spi_clk - 40MHz
create_generated_clock -name spi_clk [get_pins -hier -filter {name=~*PS7_i/FCLKCLK1}]

# create a generated clock for SCLK - fSCLK=spi_clk/2 - 20MHz
create_generated_clock -name SCLK_clk -source [get_pins -hier -filter name=~*sclk_reg/C] -edges {1 3 5} [get_ports cn0540_spi_sclk]

# input delays for MISO lines (SDO for the device)
set_input_delay -clock [get_clocks SCLK_clk] -max  0.6 [get_ports cn0540_spi_miso] -clock_fall
set_input_delay -clock [get_clocks SCLK_clk] -min  0.1 [get_ports cn0540_spi_miso] -clock_fall

