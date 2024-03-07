###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

### Timing constraints
# Clocks
create_clock -period 2 -name rx_ref_clk [get_ports ref_clk0_p]
create_clock -period 8 -name rx_ref_clk2 [get_ports glblclk_p]

create_clock -period 3.2 -name tx_ref_clk [get_ports br40_ext_p]

set_input_delay -clock [get_clocks rx_ref_clk2] [get_property PERIOD [get_clocks rx_ref_clk2]] \
                [get_ports -regexp -filter { NAME =~  ".*sysrefadc.*" && DIRECTION == "IN" }]

create_generated_clock -name dma_clk [get_pins i_system_wrapper/system_i/dma_clk_generator/inst/mmcme4_adv_inst/CLKOUT0]

# For transceiver output clocks use reference clock divided by two
# This will help autoderive the clocks correcly
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[2]]

set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[2]]

## ndac_spi
set ndac_tco_max 2
set ndac_tco_min 1.5
set ndac_tsu 5
set ndac_th 5

set ndac_tdata_trace_delay_max 7.5
set ndac_tdata_trace_delay_min 0.525
set ndac_tclk_trace_delay_max 7.5
set ndac_tclk_trace_delay_min 0.525

create_generated_clock -name ndac_sclk -source [get_pins i_system_wrapper/system_i/axi_spi_ndac/ext_spi_clk] -divide_by 4 [get_ports ndac_sck]

set_output_delay -clock ndac_sclk -max [expr $ndac_tsu + $ndac_tdata_trace_delay_max - $ndac_tclk_trace_delay_min] [get_ports ndac_sdi];
set_output_delay -clock ndac_sclk -min [expr $ndac_tdata_trace_delay_min - $ndac_th - $ndac_tclk_trace_delay_max] [get_ports ndac_sdi];
set_multicycle_path 4 -setup -start -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_ndac/ext_spi_clk]] -to ndac_sclk
set_multicycle_path 3 -hold -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_ndac/ext_spi_clk]] -to ndac_sclk

## axi_spi_adl5960
set adl5960_tco_max 30
set adl5960_tco_min 25
set adl5960_tsu 15
set adl5960_th 15

set adl5960_tdata_trace_delay_max 0.05
set adl5960_tdata_trace_delay_min 0.025
set adl5960_tclk_trace_delay_max 0.05
set adl5960_tclk_trace_delay_min 0.025

create_generated_clock -name adl5960_sclk -source [get_pins i_system_wrapper/system_i/axi_spi_adl5960/ext_spi_clk] -divide_by 16 [get_ports spi_adl5960_sck]

set_input_delay -clock adl5960_sclk -max [expr $adl5960_tco_max + $adl5960_tdata_trace_delay_max + $adl5960_tclk_trace_delay_max] [get_ports spi_adl5960_sdio] -clock_fall;
set_input_delay -clock adl5960_sclk -min [expr $adl5960_tco_min + $adl5960_tdata_trace_delay_min + $adl5960_tclk_trace_delay_min] [get_ports spi_adl5960_sdio] -clock_fall;
set_multicycle_path 16 -setup -from adl5960_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_adl5960/ext_spi_clk]]
set_multicycle_path 15 -hold -end -from adl5960_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_adl5960/ext_spi_clk]]

set_output_delay -clock adl5960_sclk -max [expr $adl5960_tsu + $adl5960_tdata_trace_delay_max - $adl5960_tclk_trace_delay_min] [get_ports spi_adl5960_sdio];
set_output_delay -clock adl5960_sclk -min [expr $adl5960_tdata_trace_delay_min - $adl5960_th - $adl5960_tclk_trace_delay_max] [get_ports spi_adl5960_sdio];
set_multicycle_path 16 -setup -start -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_adl5960/ext_spi_clk]] -to adl5960_sclk
set_multicycle_path 15 -hold -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_adl5960/ext_spi_clk]] -to adl5960_sclk

## axi_spi_fpga_busf
set busf_tco_max 6
set busf_tco_min 4
set busf_tsu 5
set busf_th 2

set busf_tdata_trace_delay_max 7.5
set busf_tdata_trace_delay_min 0.525
set busf_tclk_trace_delay_max 7.5
set busf_tclk_trace_delay_min 0.525

create_generated_clock -name busf_sclk -source [get_pins i_system_wrapper/system_i/axi_spi_fpga_busf/ext_spi_clk] -divide_by 4 [get_ports fpga_busf_sck]

set_input_delay -clock busf_sclk -max [expr $busf_tco_max + $busf_tdata_trace_delay_max + $busf_tclk_trace_delay_max] [get_ports fpga_busf_sdo] -clock_fall;
set_input_delay -clock busf_sclk -min [expr $busf_tco_min + $busf_tdata_trace_delay_min + $busf_tclk_trace_delay_min] [get_ports fpga_busf_sdo] -clock_fall;
set_multicycle_path 4 -setup -from busf_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_fpga_busf/ext_spi_clk]]
set_multicycle_path 3 -hold -end -from busf_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_fpga_busf/ext_spi_clk]]

set_output_delay -clock busf_sclk -max [expr $busf_tsu + $busf_tdata_trace_delay_max - $busf_tclk_trace_delay_min] [get_ports fpga_busf_sdi];
set_output_delay -clock busf_sclk -min [expr $busf_tdata_trace_delay_min - $busf_th - $busf_tclk_trace_delay_max] [get_ports fpga_busf_sdi];
set_multicycle_path 4 -setup -start -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_fpga_busf/ext_spi_clk]] -to busf_sclk
set_multicycle_path 3 -hold -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_fpga_busf/ext_spi_clk]] -to busf_sclk

## axi_fpga_bus1
set fpga_bus1_tco_max 25
set fpga_bus1_tco_min 15
set fpga_bus1_tsu 9.5
set fpga_bus1_th 10

set fpga_bus1_tdata_trace_delay_max 7.5
set fpga_bus1_tdata_trace_delay_min 0.525
set fpga_bus1_tclk_trace_delay_max 7.5
set fpga_bus1_tclk_trace_delay_min 0.525

create_generated_clock -name fpga_bus1_sclk -source [get_pins i_system_wrapper/system_i/axi_fpga_bus1/ext_spi_clk] -divide_by 8 [get_ports fpga_bus1_sck]

set_input_delay -clock fpga_bus1_sclk -max [expr $fpga_bus1_tco_max + $fpga_bus1_tdata_trace_delay_max + $fpga_bus1_tclk_trace_delay_max] [get_ports fpga_bus1_sdo] -clock_fall;
set_input_delay -clock fpga_bus1_sclk -min [expr $fpga_bus1_tco_min + $fpga_bus1_tdata_trace_delay_min + $fpga_bus1_tclk_trace_delay_min] [get_ports fpga_bus1_sdo] -clock_fall;
set_multicycle_path 8 -setup -from fpga_bus1_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_fpga_bus1/ext_spi_clk]]
set_multicycle_path 7 -hold -end -from fpga_bus1_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_fpga_bus1/ext_spi_clk]]

set_output_delay -clock fpga_bus1_sclk -max [expr $fpga_bus1_tsu + $fpga_bus1_tdata_trace_delay_max - $fpga_bus1_tclk_trace_delay_min] [get_ports fpga_bus1_sdi];
set_output_delay -clock fpga_bus1_sclk -min [expr $fpga_bus1_tdata_trace_delay_min - $fpga_bus1_th - $fpga_bus1_tclk_trace_delay_max] [get_ports fpga_bus1_sdi];
set_multicycle_path 8 -setup -start -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_fpga_bus1/ext_spi_clk]] -to fpga_bus1_sclk
set_multicycle_path 7 -hold -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_fpga_bus1/ext_spi_clk]] -to fpga_bus1_sclk

## axi_fpga_bus0
set fpga_bus0_tco_max 10
set fpga_bus0_tco_min 6
set fpga_bus0_tsu 2.2
set fpga_bus0_th 2

set fpga_bus0_tdata_trace_delay_max 7.5
set fpga_bus0_tdata_trace_delay_min 0.525
set fpga_bus0_tclk_trace_delay_max 7.5
set fpga_bus0_tclk_trace_delay_min 0.525

create_generated_clock -name fpga_bus0_sclk -source [get_pins i_system_wrapper/system_i/axi_fpga_bus0/ext_spi_clk] -divide_by 4 [get_ports fpga_bus0_sck]

set_input_delay -clock fpga_bus0_sclk -max [expr $fpga_bus0_tco_max + $fpga_bus0_tdata_trace_delay_max + $fpga_bus0_tclk_trace_delay_max] [get_ports fpga_bus0_sdo] -clock_fall;
set_input_delay -clock fpga_bus0_sclk -min [expr $fpga_bus0_tco_min + $fpga_bus0_tdata_trace_delay_min + $fpga_bus0_tclk_trace_delay_min] [get_ports fpga_bus0_sdo] -clock_fall;
set_multicycle_path 4 -setup -from fpga_bus0_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_fpga_bus0/ext_spi_clk]]
set_multicycle_path 3 -hold -end -from fpga_bus0_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_fpga_bus0/ext_spi_clk]]

set_output_delay -clock fpga_bus0_sclk -max [expr $fpga_bus0_tsu + $fpga_bus0_tdata_trace_delay_max - $fpga_bus0_tclk_trace_delay_min] [get_ports fpga_bus0_sdi];
set_output_delay -clock fpga_bus0_sclk -min [expr $fpga_bus0_tdata_trace_delay_min - $fpga_bus0_th - $fpga_bus0_tclk_trace_delay_max] [get_ports fpga_bus0_sdi];
set_multicycle_path 4 -setup -start -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_fpga_bus0/ext_spi_clk]] -to fpga_bus0_sclk
set_multicycle_path 3 -hold -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_fpga_bus0/ext_spi_clk]] -to fpga_bus0_sclk

## axi_spim
set spim_tco_max 10
set spim_tco_min 8
set spim_tsu 10
set spim_th 10

set spim_tdata_trace_delay_max 9.5
set spim_tdata_trace_delay_min 0.525
set spim_tclk_trace_delay_max 9.5
set spim_tclk_trace_delay_min 0.525

create_generated_clock -name spim_sclk -source [get_pins i_system_wrapper/system_i/axi_spim/ext_spi_clk] -divide_by 8 [get_ports spim_sck]

set_input_delay -clock spim_sclk -max [expr $spim_tco_max + $spim_tdata_trace_delay_max + $spim_tclk_trace_delay_max] [get_ports spim_miso] -clock_fall;
set_input_delay -clock spim_sclk -min [expr $spim_tco_min + $spim_tdata_trace_delay_min + $spim_tclk_trace_delay_min] [get_ports spim_miso] -clock_fall;
set_multicycle_path 8 -setup -from spim_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spim/ext_spi_clk]]
set_multicycle_path 7 -hold -end -from spim_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spim/ext_spi_clk]]

set_output_delay -clock spim_sclk -max [expr $spim_tsu + $spim_tdata_trace_delay_max - $spim_tclk_trace_delay_min] [get_ports spim_mosi];
set_output_delay -clock spim_sclk -min [expr $spim_tdata_trace_delay_min - $spim_th - $spim_tclk_trace_delay_max] [get_ports spim_mosi];
set_multicycle_path 8 -setup -start -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spim/ext_spi_clk]] -to spim_sclk
set_multicycle_path 7 -hold -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spim/ext_spi_clk]] -to spim_sclk

## axi_fmcdac
set fmcdac_tco_max 5
set fmcdac_tco_min 4
set fmcdac_tsu 1.25
set fmcdac_th 0.6

set fmcdac_tdata_trace_delay_max 0.05
set fmcdac_tdata_trace_delay_min 0.025
set fmcdac_tclk_trace_delay_max 0.05
set fmcdac_tclk_trace_delay_min 0.025

create_generated_clock -name fmcdac_sclk -source [get_pins i_system_wrapper/system_i/axi_spi_fmcdac/ext_spi_clk] -divide_by 4 [get_ports fmcdac_sck]

set_input_delay -clock fmcdac_sclk -max [expr $fmcdac_tco_max + $fmcdac_tdata_trace_delay_max + $fmcdac_tclk_trace_delay_max] [get_ports fmcdac_miso] -clock_fall;
set_input_delay -clock fmcdac_sclk -min [expr $fmcdac_tco_min + $fmcdac_tdata_trace_delay_min + $fmcdac_tclk_trace_delay_min] [get_ports fmcdac_miso] -clock_fall;
set_multicycle_path 4 -setup -from fmcdac_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_fmcdac/ext_spi_clk]]
set_multicycle_path 3 -hold -end -from fmcdac_sclk -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_fmcdac/ext_spi_clk]]

set_output_delay -clock fmcdac_sclk -max [expr $fmcdac_tsu + $fmcdac_tdata_trace_delay_max - $fmcdac_tclk_trace_delay_min] [get_ports fmcdac_mosi];
set_output_delay -clock fmcdac_sclk -min [expr $fmcdac_tdata_trace_delay_min - $fmcdac_th - $fmcdac_tclk_trace_delay_max] [get_ports fmcdac_mosi];
set_multicycle_path 4 -setup -start -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_fmcdac/ext_spi_clk]] -to fmcdac_sclk
set_multicycle_path 3 -hold -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_spi_fmcdac/ext_spi_clk]] -to fmcdac_sclk
