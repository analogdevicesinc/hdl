# ad405x_i3c_ardz I3C interface

# Ultrascale devices could use IOB_TRI_REG.
# Since IOB_TRI_REG is not available in the zynq7000 the tristate flip-flop is placed in the device fabric.
# Valid IOSTANDARD for the I3C bus are: LVCMOS12, LVCMOS18, and LVCMOS33
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 PULLTYPE PULLUP IOB FALSE DRIVE 12 IBUF_LOW_PWR FALSE SLEW FAST} [get_ports i3c_controller_0_sda] ; ##  PMOD JA [1]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 PULLTYPE PULLUP IOB FALSE DRIVE 12 SLEW FAST} [get_ports i3c_controller_0_scl] ; ##  PMOD JA [0]

# clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
set i3c_clk clk_fpga_0

# Input data driven the peripherals toggles every 4 cycles max (PP) of the capture clock
# gets registered by rx_reg
set_multicycle_path -from [get_ports i3c_controller_0_sda] -to [get_clocks $i3c_clk] -setup 4
set_multicycle_path -from [get_ports i3c_controller_0_sda] -to [get_clocks $i3c_clk] -hold 3

# Output data toggles every 2 cycles max of the capture clock (PP)
set_multicycle_path -from [get_clocks clk_fpga_0] -to [get_ports i3c_controller_0_sda] -setup 2
set_multicycle_path -from [get_clocks clk_fpga_0] -to [get_ports i3c_controller_0_sda] -hold 1
set_multicycle_path -from [get_clocks clk_fpga_0] -to [get_ports i3c_controller_0_scl] -setup 2
set_multicycle_path -from [get_clocks clk_fpga_0] -to [get_ports i3c_controller_0_scl] -hold 1

set_multicycle_path -from [get_clocks clk_1] -to [get_clocks $i3c_clk] -setup 4
set_multicycle_path -from [get_clocks clk_1] -to [get_clocks $i3c_clk] -hold  3

# The rx_raw_reg is used to observe the SDA lane for IBI requests during bus idle condition,
# and the delay does not matter.
set_false_path -from  [get_ports i3c_controller_0_sda] -to [get_cells -hierarchical -filter {NAME =~ *i3c_controller_bit_mod/rx_raw_reg}]

# Notes
# tcr/tcf rising/fall time for SCL is 150e06 * 1 / fSCL, at fSCL = 12.5 MHz => 12ns, at fSCL = 6.25 MHz, 24ns.
# and t_SCO has a minimum/default value of 8ns and max of 12 ns
# Taking those into consideration, the input_delay and output_delay are selected for the worst case scenario.
set tsco_max   12;
set tsco_min    8;
set trc_dly_max 1;
set trc_dly_min 0;
set_input_delay  -clock $i3c_clk -max [expr $tsco_max + $trc_dly_max] [get_ports i3c_controller_0_sda]
set_input_delay  -clock $i3c_clk -min [expr $tsco_min + $trc_dly_min] [get_ports i3c_controller_0_sda]
set tsu         2;
set thd         0;
set_output_delay  -clock $i3c_clk -max [expr $trc_dly_max + $tsu] [get_ports i3c_controller_0_sda]
set_output_delay  -clock $i3c_clk -min [expr $trc_dly_min - $thd] [get_ports i3c_controller_0_sda]
set_output_delay  -clock $i3c_clk -max [expr $trc_dly_max + $tsu] [get_ports i3c_controller_0_scl]
set_output_delay  -clock $i3c_clk -min [expr $trc_dly_min - $thd] [get_ports i3c_controller_0_scl]
