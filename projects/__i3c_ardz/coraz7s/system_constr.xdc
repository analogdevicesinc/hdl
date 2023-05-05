# __i3c_ardz I3C interface

# Ultrascale devices could use IOB_TRI_REG.
# Since IOB_TRI_REG is not available in the zynq7000 the tristate flip-flop is placed in the device fabric.
# Valid IOSTANDARD for the I3C bus are: LVCMOS12, LVCMOS18, and LVCMOS33
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports i3c_controller_0_sda] ; ##  PMOD JA [1]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports i3c_controller_0_scl] ; ##  PMOD JA [0]

# rename auto-generated clock for I3C Controller to i3c_clk
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name i3c_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*i3c_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*i3c_clkgen*i_mmcm]]
