###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
package require quartus::device
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create adi_data_offload {Analog Devices Data Offload}
set_module_property COMPOSITION_CALLBACK data_offload_compose

# parameters

ad_ip_parameter INSTANCE_NAME STRING "" false {
  VISIBLE true
}

ad_ip_parameter DATAPATH_TYPE BOOLEAN 0 false { \
  DISPLAY_HINT "radio" \
  DISPLAY_NAME "Data Path" \
  ALLOWED_RANGES { "0:Receive" "1:Transmit" }
}

ad_ip_parameter MEM_TYPE BOOLEAN 0 false { \
  DISPLAY_HINT "radio" \
  DISPLAY_NAME "Memory Type" \
  ALLOWED_RANGES { "0:Internal memory" "1:External memory" }
}

ad_ip_parameter MEM_SIZE INTEGER 10 false { \
  DISPLAY_NAME "Memory Size" \
  ALLOWED_RANGES { "1024:1kB"
                   "2048:2kB"
                   "4096:4kB"
                   "8192:8kB"
                   "16384:16kB"
                   "32768:32kB"
                   "65536:64kB"
                   "131072:128kB"
                   "262144:256kB"
                   "524288:512kB"
                   "1048576:1MB"
                   "2097152:2MB"
                   "4194304:4MB"
                   "8388608:8MB"
                   "16777216:16MB"
                   "33554432:32MB"
                   "67108864:64MB"
                   "134217728:128MB"
                   "268435456:256MB"
                   "536870912:512MB"
                   "1073741824:1GB"
                   "2147483648:2GB"
                   "4294967296:4GB"
                   "8589934592:8GB"
                   "17179869184:16GB" }
}

ad_ip_parameter SOURCE_DWIDTH INTEGER 64 false { \
  DISPLAY_NAME "Source Interface data width" \
}

ad_ip_parameter DESTINATION_DWIDTH INTEGER 128 false { \
  DISPLAY_NAME "Destination Interface data width" \
}

ad_ip_parameter AXI_DATA_WIDTH INTEGER 256 false { \
  DISPLAY_NAME "AXI data width" \
}

ad_ip_parameter AXI_ADDR_WIDTH INTEGER 32 false { \
  DISPLAY_NAME "AXI address width" \
}

ad_ip_parameter SHARED_DEVCLK BOOLEAN 0 false { \
  DISPLAY_HINT "radio" \
  DISPLAY_NAME "CDC Circuit for sync_ext" \
  ALLOWED_RANGES { "0:Disable" "1:Enable" }
}

ad_ip_parameter SYSCLK_FREQUENCY FLOAT 100.0 false { \
  DISPLAY_NAME "System Clock Frequency" \
  UNITS Megahertz
}

#ad_ip_parameter MCLK_FREQUENCY FLOAT 100.0 false { \
#  DISPLAY_NAME "Manager AXIS Clock Frequency" \
#  UNITS Megahertz
#}

#ad_ip_parameter SCLK_FREQUENCY FLOAT 100.0 false { \
#  DISPLAY_NAME "Subordinate AXIS Clock Frequency" \
#  UNITS Megahertz
#}

proc data_offload_compose {} {

  set instance_name [get_parameter_value "INSTANCE_NAME"]
  set datapath_type [get_parameter_value "DATAPATH_TYPE"]
  set mem_type [get_parameter_value "MEM_TYPE"]
  set mem_size [get_parameter_value "MEM_SIZE"]
  set source_dwidth [get_parameter_value "SOURCE_DWIDTH"]
  set destination_dwidth [get_parameter_value "DESTINATION_DWIDTH"]
  set axi_data_width [get_parameter_value "AXI_DATA_WIDTH"]
  set axi_addr_width [get_parameter_value "AXI_ADDR_WIDTH"]
  set shared_devclk [get_parameter_value "SHARED_DEVCLK"]
  set sysclk_frequency [get_parameter_value "SYSCLK_FREQUENCY"]
  #set mclk_frequency [get_parameter_value "MCLK_FREQUENCY"]
  #set sclk_frequency [get_parameter_value "SCLK_FREQUENCY"]

  set source_addresses [expr ($mem_size * 8) / $source_dwidth]
  set source_awidth [log2 $source_addresses]
  set destination_max_address [expr ($mem_size * 8) / $destination_dwidth]
  set destination_awidth [log2 $destination_max_address]

  ###########################################################################
  ## Sub-system's ports and interface definitions
  ###########################################################################

  add_instance sys_clock clock_source
  set_instance_parameter_value sys_clock {clockFrequency} [expr $sysclk_frequency*1000000]
  set_instance_parameter_value sys_clock {resetSynchronousEdges} {deassert}
  add_interface sys_clk clock sink
  set_interface_property sys_clk EXPORT_OF sys_clock.clk_in
  add_interface sys_resetn reset sink
  set_interface_property sys_resetn EXPORT_OF sys_clock.clk_in_reset

  #add_instance m_axis_clock clock_source
  #set_instance_parameter_value m_axis_clock {clockFrequency} [expr $mclk_frequency*1000000]
  #add_interface m_axis_aclk clock sink
  #set_interface_property m_axis_aclk EXPORT_OF m_axis_clock.clk_in
  #add_interface m_axis_aresetn reset sink
  #set_interface_property m_axis_aresetn EXPORT_OF m_axis_clock.clk_in_reset

  #add_instance s_axis_clock clock_source
  #set_instance_parameter_value s_axis_clock {clockFrequency} [expr $sclk_frequency*1000000]
  #add_interface s_axis_aclk clock sink
  #set_interface_property s_axis_aclk EXPORT_OF s_axis_clock.clk_in
  #add_interface s_axis_aresetn reset sink
  #set_interface_property s_axis_aresetn EXPORT_OF s_axis_clock.clk_in_reset

  add_instance m_axis_clock altera_clock_bridge
  add_interface m_axis_aclk clock sink
  set_interface_property m_axis_aclk EXPORT_OF m_axis_clock.in_clk
  add_instance m_axis_reset altera_reset_bridge
  add_interface m_axis_aresetn reset sink
  set_interface_property m_axis_aresetn EXPORT_OF m_axis_reset.in_reset
  add_connection m_axis_clock.out_clk m_axis_reset.clk

  add_instance s_axis_clock altera_clock_bridge
  add_interface s_axis_aclk clock sink
  set_interface_property s_axis_aclk EXPORT_OF s_axis_clock.in_clk
  add_instance s_axis_reset altera_reset_bridge
  add_interface s_axis_aresetn reset sink
  set_interface_property s_axis_aresetn EXPORT_OF s_axis_reset.in_reset
  add_connection s_axis_clock.out_clk s_axis_reset.clk

  ###########################################################################
  # Data offload controller instance
  ###########################################################################

  add_instance i_data_offload data_offload
  set_instance_parameter_value i_data_offload {MEM_TYPE} [expr $mem_type == 0 ? 0 : 1]
  set_instance_parameter_value i_data_offload {MEM_SIZE_LOG2} [log2 $mem_size]
  set_instance_parameter_value i_data_offload {TX_OR_RXN_PATH} $datapath_type
  set_instance_parameter_value i_data_offload {SRC_DATA_WIDTH} $source_dwidth
  set_instance_parameter_value i_data_offload {DST_DATA_WIDTH} $destination_dwidth
  set_instance_parameter_value i_data_offload {DST_CYCLIC_EN} $datapath_type
  set_instance_parameter_value i_data_offload {SYNC_EXT_ADD_INTERNAL_CDC} [expr {!$shared_devclk}]

  add_interface s_axi axi4lite slave
  set_interface_property s_axi EXPORT_OF i_data_offload.s_axi

  add_interface m_axis axi4stream start
  set_interface_property m_axis EXPORT_OF i_data_offload.m_axis

  add_interface s_axis axi4stream end
  set_interface_property s_axis EXPORT_OF i_data_offload.s_axis

  add_interface init_req conduit end
  set_interface_property init_req EXPORT_OF i_data_offload.if_init_req

  add_interface sync_ext conduit end
  set_interface_property sync_ext EXPORT_OF i_data_offload.if_sync_ext

  #if {$mem_type == 0} {
    ###########################################################################
    # Internal storage instance (BRAMs)
    ###########################################################################

    add_instance storage_unit util_do_ram
    set_instance_parameter_value storage_unit {SRC_DATA_WIDTH} $source_dwidth
    set_instance_parameter_value storage_unit {DST_DATA_WIDTH} $destination_dwidth
    set_instance_parameter_value storage_unit {LENGTH_WIDTH} [log2 $mem_size]

  #} elseif {$mem_type == 1 || $mem_type == 2} {
    ###########################################################################
    # Bridge instance for the external DDR (1) / HBM(2) memory controller
    # NOTE: The DDR/HBM instantiation should be in project's system_qsys.tcl file
    ###########################################################################
    #source $ad_hdl_dir/library/util_hbm/scripts/util_hbm_qsys.tcl

    #ad_create_util_hbm storage_unit \
    #  $datapath_type \
    #  $source_dwidth \
    #  $destination_dwidth \
    #  $mem_size \
    #  $axi_data_width \
    #  $mem_type

    #if {$mem_type == 1} {
    #  set_instance_parameter_value storage_unit {AXI_PROTOCOL} 0
    #} else {
    #  set_instance_parameter_value storage_unit {AXI_PROTOCOL} 1
    #}

  #}

  ###########################################################################
  # Connect Storage to Data Offload
  ###########################################################################

  add_connection storage_unit.if_wr_request_enable           i_data_offload.if_wr_request_enable
  add_connection storage_unit.if_wr_request_valid            i_data_offload.if_wr_request_valid
  add_connection storage_unit.if_wr_request_ready            i_data_offload.if_wr_request_ready
  add_connection storage_unit.if_wr_request_length           i_data_offload.if_wr_request_length
  add_connection storage_unit.if_wr_response_measured_length i_data_offload.if_wr_response_measured_length
  add_connection storage_unit.if_wr_response_eot             i_data_offload.if_wr_response_eot

  add_connection storage_unit.if_rd_request_enable i_data_offload.if_rd_request_enable
  add_connection storage_unit.if_rd_request_valid  i_data_offload.if_rd_request_valid
  add_connection storage_unit.if_rd_request_ready  i_data_offload.if_rd_request_ready
  add_connection storage_unit.if_rd_request_length i_data_offload.if_rd_request_length
  add_connection storage_unit.if_rd_response_eot   i_data_offload.if_rd_response_eot

  add_connection i_data_offload.m_storage_axis storage_unit.s_axis
  add_connection storage_unit.m_axis i_data_offload.s_storage_axis

  ###########################################################################
  # Internal connections
  ###########################################################################

  add_connection sys_clock.clk i_data_offload.s_axi_clock
  add_connection sys_clock.clk_reset i_data_offload.s_axi_reset
  add_connection s_axis_clock.out_clk i_data_offload.if_s_axis_aclk
  add_connection s_axis_reset.out_reset i_data_offload.if_s_axis_aresetn
  add_connection m_axis_clock.out_clk i_data_offload.if_m_axis_aclk
  add_connection m_axis_reset.out_reset i_data_offload.if_m_axis_aresetn

  add_connection s_axis_clock.out_clk storage_unit.if_s_axis_aclk
  add_connection s_axis_reset.out_reset storage_unit.if_s_axis_aresetn
  add_connection m_axis_clock.out_clk storage_unit.if_m_axis_aclk
  add_connection m_axis_reset.out_reset storage_unit.if_m_axis_aresetn

}

proc log2 {x} {
    expr (int (ceil ((log($x) / log(2)))))
}
