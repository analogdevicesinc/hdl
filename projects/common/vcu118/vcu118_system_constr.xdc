
# constraints

set_property -dict  {PACKAGE_PIN  L19  IOSTANDARD  LVCMOS12} [get_ports sys_rst]

# clocks

set_property -dict  {PACKAGE_PIN  AW26   IOSTANDARD  LVDS} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  AW27   IOSTANDARD  LVDS} [get_ports sys_clk_n]

# ethernet

set_property PACKAGE_PIN AU21 [get_ports phy_tx_p]
set_property PACKAGE_PIN AV21 [get_ports phy_tx_n]
set_property PACKAGE_PIN AU24 [get_ports phy_rx_p]
set_property PACKAGE_PIN AV24 [get_ports phy_rx_n]

set_property -dict  {PACKAGE_PIN  AT22  IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100} [get_ports phy_clk_p]
set_property -dict  {PACKAGE_PIN  AU22  IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100} [get_ports phy_clk_n]

set_property -dict  {PACKAGE_PIN  BA21  IOSTANDARD  LVCMOS18} [get_ports phy_rst_n]
set_property -dict  {PACKAGE_PIN  AV23  IOSTANDARD  LVCMOS18} [get_ports mdio_mdc]
set_property -dict  {PACKAGE_PIN  AR23  IOSTANDARD  LVCMOS18} [get_ports mdio_mdio]

set_false_path -through [get_nets phy_rst_n]

# uart

set_property -dict  {PACKAGE_PIN  AW25  IOSTANDARD  LVCMOS18} [get_ports uart_sin]
set_property -dict  {PACKAGE_PIN  BB21  IOSTANDARD  LVCMOS18} [get_ports uart_sout]

set_property -dict  {PACKAGE_PIN  B17   IOSTANDARD  LVCMOS12} [get_ports gpio_bd[0]]    ; ## GPIO_DIP_SW0
set_property -dict  {PACKAGE_PIN  G16   IOSTANDARD  LVCMOS12} [get_ports gpio_bd[1]]    ; ## GPIO_DIP_SW1
set_property -dict  {PACKAGE_PIN  J16   IOSTANDARD  LVCMOS12} [get_ports gpio_bd[2]]    ; ## GPIO_DIP_SW2
set_property -dict  {PACKAGE_PIN  D21   IOSTANDARD  LVCMOS12} [get_ports gpio_bd[3]]    ; ## GPIO_DIP_SW3
set_property -dict  {PACKAGE_PIN  BD23  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[4]]    ; ## GPIO_PB_0
set_property -dict  {PACKAGE_PIN  BF22  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[5]]    ; ## GPIO_PB_1
set_property -dict  {PACKAGE_PIN  BE22  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[6]]    ; ## GPIO_PB_2
set_property -dict  {PACKAGE_PIN  BE23  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[7]]    ; ## GPIO_PB_3
set_property -dict  {PACKAGE_PIN  BB24  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[8]]    ; ## GPIO_PB_4
set_property -dict  {PACKAGE_PIN  AT32  IOSTANDARD  LVCMOS12} [get_ports gpio_bd[9]]    ; ## GPIO_LED_0_LS
set_property -dict  {PACKAGE_PIN  AV34  IOSTANDARD  LVCMOS12} [get_ports gpio_bd[10]]   ; ## GPIO_LED_1_LS
set_property -dict  {PACKAGE_PIN  AY30  IOSTANDARD  LVCMOS12} [get_ports gpio_bd[11]]   ; ## GPIO_LED_2_LS
set_property -dict  {PACKAGE_PIN  BB32  IOSTANDARD  LVCMOS12} [get_ports gpio_bd[12]]   ; ## GPIO_LED_3_LS
set_property -dict  {PACKAGE_PIN  BF32  IOSTANDARD  LVCMOS12} [get_ports gpio_bd[13]]   ; ## GPIO_LED_4_LS
set_property -dict  {PACKAGE_PIN  AU37  IOSTANDARD  LVCMOS12} [get_ports gpio_bd[14]]   ; ## GPIO_LED_5_LS
set_property -dict  {PACKAGE_PIN  AV36  IOSTANDARD  LVCMOS12} [get_ports gpio_bd[15]]   ; ## GPIO_LED_6_LS
set_property -dict  {PACKAGE_PIN  BA37  IOSTANDARD  LVCMOS12} [get_ports gpio_bd[16]]   ; ## GPIO_LED_7_LS

# iic

set_property -dict  {PACKAGE_PIN  AL25  IOSTANDARD  LVCMOS18} [get_ports iic_rstn]
set_property -dict  {PACKAGE_PIN  AM24  IOSTANDARD  LVCMOS18  DRIVE 8 SLEW SLOW} [get_ports iic_scl]
set_property -dict  {PACKAGE_PIN  AL24  IOSTANDARD  LVCMOS18  DRIVE 8 SLEW SLOW} [get_ports iic_sda]

# Create SPI clock
create_generated_clock -name spi_clk  \
  -source [get_pins i_system_wrapper/system_i/axi_spi/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi/sck_o]


# Balance clocks
#
# Minimize skew on synchronous CDC timing paths between clocks originating 
# from the same MMCM source. (sys_mem_clk and sys_cpu_clk)
# This is required mostly by the smart interconnect.
# Property must be applied directly to the output net of BUFGs.
set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS \
  [list [get_nets [get_property PARENT [get_nets {i_system_wrapper/system_i/sys_cpu_clk}]]] \
        [get_nets [get_property PARENT [get_nets {i_system_wrapper/system_i/sys_mem_clk}]]] \
  ]

set_property CFGBVS GND                                [current_design]
set_property CONFIG_VOLTAGE 1.8                        [current_design]
set_property CONFIG_MODE SPIx8                         [current_design]

set_property BITSTREAM.GENERAL.COMPRESS true           [current_design]
#set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN DIV-1   [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES       [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 8           [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES        [current_design]

set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN DISABLE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 51.0          [current_design]

# DUAL QUAD SPI constraints from PG153 

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


# Constraints for paths where STARTUP is Disabled :
set_input_delay -clock clk_sck -max [expr $tco_max + $tdata_trace_delay_max + \
  $tclk_trace_delay_max] [get_ports SPI_1*_io] -clock_fall;
set_input_delay -clock clk_sck -min [expr $tco_min + $tdata_trace_delay_min + \
  $tclk_trace_delay_min] [get_ports SPI_1*_io] -clock_fall;
# Data is captured into SPI on the following rising edge of SCK
# Data is driven by the IP on alternate rising_edge of the ext_spi_clk
set_output_delay -clock clk_sck -max [expr $tsu + $tdata_trace_delay_max - \
  $tclk_trace_delay_min] [get_ports SPI_1*_io];
set_output_delay -clock clk_sck -min [expr $tdata_trace_delay_min - $th - \
  $tclk_trace_delay_max] [get_ports SPI_1*_io];