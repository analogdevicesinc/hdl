# __i3c_ardz I3C interface

# Ultrascale devices could use IOB_TRI_REG.
# Since IOB_TRI_REG is not available in the zynq7000 the tristate flip-flop is placed in the device fabric.
# Valid IOSTANDARD for the I3C bus are: LVCMOS12, LVCMOS18, and LVCMOS33
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 PULLTYPE PULLUP IOB FALSE DRIVE 12 IBUF_LOW_PWR FALSE SLEW FAST} [get_ports i3c_controller_0_sda] ; ##  PMOD JA [1]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 PULLTYPE PULLUP IOB FALSE DRIVE 12 SLEW FAST} [get_ports i3c_controller_0_scl] ; ##  PMOD JA [0]

# rename auto-generated clock for I3C Controller to i3c_clk
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name i3c_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*i3c_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*i3c_clkgen*i_mmcm]]
create_generated_clock -name i3c_clk_bus -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*i3c_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT1 -of [get_cells -hier -filter name=~*i3c_clkgen*i_mmcm]]
#set_period -name i3c_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*i3c_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*i3c_clkgen*i_mmcm]]
set i3c_clock [get_clocks  "i3c_clk"]
set i3c_clock_bus [get_clocks  "i3c_clk_bus"]

# Input data driven the peripherals toggles every 4 cycles max of the capture clock i3c_clk_bus (PP)
set_multicycle_path -from [get_ports i3c_controller_0_sda] -to i_system_wrapper/system_i/i3c_controller_0/core/inst/i_i3c_controller_bit_mod/sdo_reg_reg/D -setup 4
set_multicycle_path -from [get_ports i3c_controller_0_sda] -to i_system_wrapper/system_i/i3c_controller_0/core/inst/i_i3c_controller_bit_mod/sdo_reg_reg/D -hold 3

# Output data toggles every 2 cycles max of the capture clock i3c_clk_bus (PP)
set_multicycle_path -to [get_ports i3c_controller_0_sda] -from i_system_wrapper/system_i/i3c_controller_0/core/inst/i_i3c_controller_bit_mod/sdi_reg/C -setup 2
set_multicycle_path -to [get_ports i3c_controller_0_sda] -from i_system_wrapper/system_i/i3c_controller_0/core/inst/i_i3c_controller_bit_mod/sdi_reg/C -hold 2
set_multicycle_path -to [get_ports i3c_controller_0_sda] -from i_system_wrapper/system_i/i3c_controller_0/core/inst/i_i3c_controller_bit_mod/pp_reg/C -setup 2
set_multicycle_path -to [get_ports i3c_controller_0_sda] -from i_system_wrapper/system_i/i3c_controller_0/core/inst/i_i3c_controller_bit_mod/pp_reg/C -hold 2
set_multicycle_path -to [get_ports i3c_controller_0_scl] -from i_system_wrapper/system_i/i3c_controller_0/core/inst/i_i3c_controller_bit_mod/scl_reg/C -setup 2
set_multicycle_path -to [get_ports i3c_controller_0_scl] -from i_system_wrapper/system_i/i3c_controller_0/core/inst/i_i3c_controller_bit_mod/scl_reg/C -hold 2

# Notes
# tcr/tcf rising/fall time for SCL is 150e06 * 1 / fSCL, at fSCL = 12.5 MHz => 12ns, at fSCL = 6.25 MHz, 24ns.
# and t_SCO has a minimum/default value of 8ns and max of 12 ns
# Taking those into consideration, the input_delay and output_delay are selected for the worst case scenario.
set tsco_max   12;
set tsco_min    8;
set trc_dly_max 1;
set trc_dly_min 0;
set_input_delay  -clock $i3c_clock_bus -max [expr $tsco_max + $trc_dly_max] [get_ports i3c_controller_0_sda]
set_input_delay  -clock $i3c_clock_bus -min [expr $tsco_min + $trc_dly_min] [get_ports i3c_controller_0_sda]
set tsu         2;
set thd         0;
set_output_delay  -clock $i3c_clock_bus -max [expr $trc_dly_max + $tsu] [get_ports i3c_controller_0_sda]
set_output_delay  -clock $i3c_clock_bus -min [expr $trc_dly_min - $thd] [get_ports i3c_controller_0_sda]
set_output_delay  -clock $i3c_clock_bus -max [expr $trc_dly_max + $tsu] [get_ports i3c_controller_0_scl]
set_output_delay  -clock $i3c_clock_bus -min [expr $trc_dly_min - $thd] [get_ports i3c_controller_0_scl]
