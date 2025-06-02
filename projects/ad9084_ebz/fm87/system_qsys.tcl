###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/fm87/system_qsys.tcl
source $ad_hdl_dir/projects/common/fm87/fm87_plddr_dacfifo_qsys.tcl
source $ad_hdl_dir/projects/common/intel/adcfifo_qsys.tcl

set jesd_mode $ad_project_params(JESD_MODE)

set jesd204_ref_clock [format {%.6f} $ad_project_params(REF_CLK_RATE)]
if {$jesd_mode == "64B66B"} {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 32]]
} else {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 20]]
}
# DUT F-Tile Ref clock
add_instance systemclk systemclk_f
set_instance_parameter_value systemclk syspll_mod_0 {User Configuration}
set_instance_parameter_value systemclk syspll_refclk_src_0 {RefClk #2}
set_instance_parameter_value systemclk syspll_freq_mhz_0 $syspll_freq
set_instance_parameter_value systemclk refclk_fgt_output_enable_2 1
set_instance_parameter_value systemclk refclk_fgt_freq_mhz_2 $jesd204_ref_clock

add_interface ref_clk_fgt_2 clock sink
set_interface_property ref_clk_fgt_2 EXPORT_OF systemclk.out_refclk_fgt_2

add_interface ref_clk_in clock sink
set_interface_property ref_clk_in EXPORT_OF systemclk.refclk_fgt

set HSCI_ENABLE 0
set ASYMMETRIC_A_B_MODE 0
source $ad_hdl_dir/projects/ad9084_ebz/common/ad9084_ebz_qsys.tcl

# Apollo spi
add_instance apollo_spi altera_avalon_spi
set_instance_parameter_value apollo_spi {clockPhase} {0}
set_instance_parameter_value apollo_spi {clockPolarity} {0}
set_instance_parameter_value apollo_spi {dataWidth} {8}
set_instance_parameter_value apollo_spi {masterSPI} {1}
set_instance_parameter_value apollo_spi {numberOfSlaves} {8}
set_instance_parameter_value apollo_spi {targetClockRate} {10000000.0}

add_connection sys_clk.clk_reset apollo_spi.reset
add_connection sys_clk.clk apollo_spi.clk
add_interface apollo_spi conduit end
set_interface_property apollo_spi EXPORT_OF apollo_spi.external

ad_cpu_interconnect 0x000EA000 apollo_spi.spi_control_port

ad_cpu_interrupt 18 apollo_spi.irq

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

sysid_gen_sys_init_file;