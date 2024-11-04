###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc ad_data_offload_create {instance_name
                             datapath_type
                             mem_type
                             mem_size
                             source_dwidth
                             destination_dwidth
                             {axi_data_width 256}
                             {axi_addr_width 32}
                             {shared_devclk 0}} {

  global ad_hdl_dir

    ###########################################################################
    ## Sub-system's ports and interface definitions
    ###########################################################################

    set source_addresses [expr ($mem_size * 8) / $source_dwidth]
    set source_awidth [log2 $source_addresses]
    set destination_max_address [expr ($mem_size * 8) / $destination_dwidth]
    set destination_awidth [log2 $destination_max_address]

    ###########################################################################
    # Data offload controller instance
    ###########################################################################

    add_instance ${instance_name}_i_data_offload data_offload
    set_instance_parameter_value ${instance_name}_i_data_offload {MEM_TYPE} [expr $mem_type == 0 ? 0 : 1]
    set_instance_parameter_value ${instance_name}_i_data_offload {MEM_SIZE_LOG2} [log2 $mem_size]
    set_instance_parameter_value ${instance_name}_i_data_offload {TX_OR_RXN_PATH} $datapath_type
    set_instance_parameter_value ${instance_name}_i_data_offload {SRC_DATA_WIDTH} $source_dwidth
    set_instance_parameter_value ${instance_name}_i_data_offload {DST_DATA_WIDTH} $destination_dwidth
    set_instance_parameter_value ${instance_name}_i_data_offload {DST_CYCLIC_EN} $datapath_type
    set_instance_parameter_value ${instance_name}_i_data_offload {SYNC_EXT_ADD_INTERNAL_CDC} [expr {!$shared_devclk}]

    if {$mem_type == 0} {
      ###########################################################################
      # Internal storage instance (BRAMs)
      ###########################################################################

      add_instance ${instance_name}_storage_unit util_do_ram
      set_instance_parameter_value ${instance_name}_storage_unit {SRC_DATA_WIDTH} $source_dwidth
      set_instance_parameter_value ${instance_name}_storage_unit {DST_DATA_WIDTH} $destination_dwidth
      set_instance_parameter_value ${instance_name}_storage_unit {LENGTH_WIDTH} [log2 $mem_size]

    } elseif {$mem_type == 1 || $mem_type == 2} {
      ###########################################################################
      # Bridge instance for the external DDR (1) / HBM(2) memory controller
      # NOTE: The DDR/HBM instantiation should be in project's system_qsys.tcl file
      ###########################################################################
      source $ad_hdl_dir/library/util_hbm/scripts/util_hbm_qsys.tcl

      ad_create_util_hbm ${instance_name}_storage_unit \
        $datapath_type \
        $source_dwidth \
        $destination_dwidth \
        $mem_size \
        $axi_data_width \
        $mem_type

      if {$mem_type == 1} {
        set_instance_parameter_value ${instance_name}_storage_unit {AXI_PROTOCOL} 0
      } else {
        set_instance_parameter_value ${instance_name}_storage_unit {AXI_PROTOCOL} 1
      }

    }

    ###########################################################################
    # Connect Storage to Data Offload
    ###########################################################################
    add_connection ${instance_name}_storage_unit.if_wr_request_enable           ${instance_name}_i_data_offload.if_wr_request_enable
    add_connection ${instance_name}_storage_unit.if_wr_request_valid            ${instance_name}_i_data_offload.if_wr_request_valid
    add_connection ${instance_name}_storage_unit.if_wr_request_ready            ${instance_name}_i_data_offload.if_wr_request_ready
    add_connection ${instance_name}_storage_unit.if_wr_request_length           ${instance_name}_i_data_offload.if_wr_request_length
    add_connection ${instance_name}_storage_unit.if_wr_response_measured_length ${instance_name}_i_data_offload.if_wr_response_measured_length
    add_connection ${instance_name}_storage_unit.if_wr_response_eot             ${instance_name}_i_data_offload.if_wr_response_eot
    add_connection ${instance_name}_storage_unit.if_wr_overflow                 ${instance_name}_i_data_offload.if_wr_overflow

    add_connection ${instance_name}_storage_unit.if_rd_request_enable ${instance_name}_i_data_offload.if_rd_request_enable
    add_connection ${instance_name}_storage_unit.if_rd_request_valid  ${instance_name}_i_data_offload.if_rd_request_valid
    add_connection ${instance_name}_storage_unit.if_rd_request_ready  ${instance_name}_i_data_offload.if_rd_request_ready
    add_connection ${instance_name}_storage_unit.if_rd_request_length ${instance_name}_i_data_offload.if_rd_request_length
    add_connection ${instance_name}_storage_unit.if_rd_response_eot   ${instance_name}_i_data_offload.if_rd_response_eot
    add_connection ${instance_name}_storage_unit.if_rd_underflow      ${instance_name}_i_data_offload.if_rd_underflow

    add_connection ${instance_name}_storage_unit.s_axis ${instance_name}_i_data_offload.m_storage_axis
    add_connection ${instance_name}_storage_unit.m_axis ${instance_name}_i_data_offload.s_storage_axis

    add_connection ${instance_name}_storage_unit/s_axis_aclk s_axis_aclk
    add_connection ${instance_name}_storage_unit/s_axis_aresetn s_axis_aresetn
    add_connection ${instance_name}_storage_unit/m_axis_aclk m_axis_aclk
    add_connection ${instance_name}_storage_unit/m_axis_aresetn m_axis_aresetn

    ###########################################################################
    # Internal connections
    ###########################################################################

    #add_connection s_axi_aclk ${instance_name}_i_data_offload/s_axi_aclk
    #add_connection s_axi_aresetn ${instance_name}_i_data_offload/s_axi_aresetn
    #add_connection s_axis_aclk ${instance_name}_i_data_offload/s_axis_aclk
    #add_connection s_axis_aresetn ${instance_name}_i_data_offload/s_axis_aresetn
    #add_connection m_axis_aclk ${instance_name}_i_data_offload/m_axis_aclk
    #add_connection m_axis_aresetn ${instance_name}_i_data_offload/m_axis_aresetn

    #add_connection s_axi ${instance_name}_i_data_offload/s_axi
    #add_connection s_axis ${instance_name}_i_data_offload/s_axis
    #add_connection m_axis ${instance_name}_i_data_offload/m_axis

    #add_connection init_req ${instance_name}_i_data_offload/init_req
    #add_connection sync_ext ${instance_name}_i_data_offload/sync_ext

}

proc log2 {x} {
    expr (int (ceil ((log($x) / log(2)))))
}
