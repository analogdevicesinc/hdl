###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set adc_offload_type 1                              ; ## PL_DDR
set adc_offload_size [expr 1 * 1024 * 1024 * 1024]  ; ## 1 Gbyte

set dac_offload_type 0                              ; ## BRAM
set dac_offload_size [expr 1 * 1024 * 1024]         ; ## 1 MByte

set plddr_offload_axi_data_width 512

## NOTE: With this configuration the #36Kb BRAM utilization is at ~52%

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/daq2_bd.tcl

################################################################################
## DDR3 MIG for Data Offload IP
################################################################################

if {$adc_offload_type} {
  set offload_name axi_ad9680_offload
}

if {$dac_offload_type} {
  set offload_name axi_ad9144_offload
}

if {$adc_offload_type || $dac_offload_type} {

    ad_ip_instance proc_sys_reset axi_rstgen
    ad_ip_instance mig_7series axi_ddr_cntrl
    file copy -force $ad_hdl_dir/projects/common/zc706/zc706_plddr3_mig.prj [get_property IP_DIR \
      [get_ips [get_property CONFIG.Component_Name [get_bd_cells axi_ddr_cntrl]]]]
    ad_ip_parameter axi_ddr_cntrl CONFIG.XML_INPUT_FILE zc706_plddr3_mig.prj

    # PL-DDR data offload interfaces
    create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk
    create_bd_port -dir I -type rst sys_rst
    set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports sys_rst]
    create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3

    ad_connect axi_ddr_cntrl/ui_clk axi_rstgen/slowest_sync_clk
    ad_connect axi_ddr_cntrl/ui_clk $offload_name/storage_unit/m_axi_aclk
    ad_connect axi_ddr_cntrl/S_AXI $offload_name/storage_unit/MAXI_0
    ad_connect axi_rstgen/peripheral_aresetn $offload_name/storage_unit/m_axi_aresetn
    ad_connect axi_rstgen/peripheral_aresetn axi_ddr_cntrl/aresetn
    ad_connect sys_cpu_resetn axi_rstgen/ext_reset_in

    assign_bd_address [get_bd_addr_segs -of_objects [get_bd_cells axi_ddr_cntrl]]

    ad_connect  sys_rst axi_ddr_cntrl/sys_rst
    ad_connect  sys_clk axi_ddr_cntrl/SYS_CLK
    ad_connect  ddr3    axi_ddr_cntrl/DDR3
    ad_connect  axi_ddr_cntrl/device_temp_i GND
    ad_connect  $offload_name/i_data_offload/ddr_calib_done axi_ddr_cntrl/init_calib_complete

}

################################################################################
# System ID
################################################################################

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "ADC_OFFLOAD_TYPE=$adc_offload_type\nDAC_OFFLOAD_TYPE=$dac_offload_type"
sysid_gen_sys_init_file $sys_cstring
