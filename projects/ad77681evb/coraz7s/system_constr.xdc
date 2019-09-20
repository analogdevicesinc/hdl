
# SPI interface

set_property -dict {PACKAGE_PIN  G15 IOSTANDARD LVCMOS33 IOB TRUE}                  [get_ports ad77681_spi_sclk]    ; ## CK_IO13
set_property -dict {PACKAGE_PIN  J18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP}  [get_ports ad77681_spi_miso]    ; ## CK_IO12
set_property -dict {PACKAGE_PIN  K18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP}  [get_ports ad77681_spi_mosi]    ; ## CK_IO11
set_property -dict {PACKAGE_PIN  U15 IOSTANDARD LVCMOS33}                           [get_ports ad77681_spi_cs]      ; ## CK_IO10

# reset and GPIO signals

set_property -dict {PACKAGE_PIN  T15 IOSTANDARD LVCMOS33}                           [get_ports ad77681_reset]       ; ## CK_IO3
set_property -dict {PACKAGE_PIN  M18 IOSTANDARD LVCMOS33}                           [get_ports ad77681_fda_dis]     ; ## CK_IO9
set_property -dict {PACKAGE_PIN  N18 IOSTANDARD LVCMOS33}                           [get_ports ad77681_fda_mode]    ; ## CK_IO8
set_property -dict {PACKAGE_PIN  V18 IOSTANDARD LVCMOS33}                           [get_ports ad77681_dac_buf_en]  ; ## CK_IO5

# syncronization and timing

set_property -dict {PACKAGE_PIN  T14 IOSTANDARD LVCMOS33 IOB TRUE}                  [get_ports ad77681_drdy]        ; ## CK_IO2
set_property -dict {PACKAGE_PIN  R17 IOSTANDARD LVCMOS33}                           [get_ports ad77681_sync_in]     ; ## CK_IO6
