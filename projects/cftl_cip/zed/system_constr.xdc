
# pmod connectors

# JA supports : CN0350, CN0335, CN0336 and CN0337

set_property  -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33}  [get_ports  pmod_spi_cs]       ; ## JA1
set_property  -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33}  [get_ports  pmod_spi_miso]     ; ## JA3
set_property  -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33}  [get_ports  pmod_spi_clk]      ; ## JA4
set_property  -dict {PACKAGE_PIN AB9  IOSTANDARD LVCMOS33}  [get_ports  pmod_spi_convst]   ; ## JA9

# JB supports CN0332

set_property  -dict {PACKAGE_PIN W8   IOSTANDARD LVCMOS33}  [get_ports pmod_gpio]          ; ## JB4

