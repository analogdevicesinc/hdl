# Primary clock definitions

# These two reference clocks are connect to the same source on the PCB
create_clock -name refclk         -period  4.00 [get_ports fpga_clk_m2c_p[0]]
create_clock -name refclk_replica -period  4.00 [get_ports fpga_clk_m2c_0_replica_n]

# rx device clock
create_clock -name rx_device_clk     -period  4.00 [get_ports fpga_clk_m2c_p[1]]
# tx device clock
create_clock -name tx_device_clk     -period  4.00 [get_ports fpga_clk_m2c_p[2]]

# SPI 2 clock
create_generated_clock -name spi_2_clk  \
  -source [get_pins i_system_wrapper/system_i/axi_spi_2/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi_2/sck_o]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks rx_device_clk] \
  [get_property PERIOD [get_clocks rx_device_clk]] \
  [get_ports {fpga_sysref_m2c_*}]
set_input_delay -clock [get_clocks tx_device_clk] -add_delay\
  [get_property PERIOD [get_clocks tx_device_clk]] \
  [get_ports {fpga_sysref_m2c_*}]
set_clock_groups -group rx_device_clk -group tx_device_clk -asynchronous

################################################################################

# Single QUAD SPI constraints from PG153

#STARTUPE3 (UltraScale+) primitive included inside IP:
# Following are the SPI device parameters
# Max Tco
set tco_max 7
# Min Tco
set tco_min 1
# Setup time requirement
set tsu 2.5
# Hold time requirement
set th 2
# Following are the board/trace delay numbers
# Assumption is that all Data lines are matched
set tdata_trace_delay_max 0.25
set tdata_trace_delay_min 0.25
set tclk_trace_delay_max 0.2
set tclk_trace_delay_min 0.2

create_generated_clock -name clk_sck -source [get_pins -hierarchical \
  *axi_cfg_spi/ext_spi_clk] [get_pins -hierarchical */CCLK] -edges {3 5 7}

set_input_delay -clock clk_sck -max [expr $tco_max + $tdata_trace_delay_max + \
  $tclk_trace_delay_max] [get_pins -hierarchical *STARTUP*/DATA_IN[*]] -clock_fall;

set_input_delay -clock clk_sck -min [expr $tco_min + $tdata_trace_delay_min + \
  $tclk_trace_delay_min] [get_pins -hierarchical *STARTUP*/DATA_IN[*]] -clock_fall;

set_multicycle_path 2 -setup -from clk_sck -to [get_clocks -of_objects [get_pins \
  -hierarchical *axi_cfg_spi/ext_spi_clk]]

set_multicycle_path 1 -hold -end -from clk_sck -to [get_clocks -of_objects [get_pins \
  -hierarchical *axi_cfg_spi/ext_spi_clk]]

set_output_delay -clock clk_sck -max [expr $tsu + $tdata_trace_delay_max - \
  $tclk_trace_delay_min] [get_pins -hierarchical *STARTUP*/DATA_OUT[*]];

set_output_delay -clock clk_sck -min [expr $tdata_trace_delay_min - $th - \
  $tclk_trace_delay_max] [get_pins -hierarchical *STARTUP*/DATA_OUT[*]];

set_multicycle_path 2 -setup -start -from [get_clocks -of_objects [get_pins \
  -hierarchical *axi_cfg_spi/ext_spi_clk]] -to clk_sck

set_multicycle_path 1 -hold -from [get_clocks -of_objects [get_pins -hierarchical \
  *axi_cfg_spi/ext_spi_clk]] -to clk_sck

set_max_delay -quiet -datapath_only -from [get_pins -hier {*STARTUP*_inst/DI[*]}] 1.000

set_max_delay -quiet -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical \
  *axi_cfg_spi/ext_spi_clk]] -to [get_pins -hier *STARTUP*_inst/USRCCLKO] 1.000

set_max_delay -quiet -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical \
  *axi_cfg_spi/ext_spi_clk]] -to [get_pins -hier *STARTUP*_inst/DO[*]] 1.000

set_max_delay -quiet -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical \
  *axi_cfg_spi/ext_spi_clk]] -to [get_pins -hier *STARTUP*_inst/DTS[*]] 1.000
