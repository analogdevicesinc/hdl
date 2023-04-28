# constraints

set_property  -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 4}  [get_ports fan_en_b]; # Bank  45 VCCO - som240_1_b13 - IO_L11P_AD9P_45

create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]

set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]
