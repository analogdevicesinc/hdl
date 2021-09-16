
proc ad_data_offload_create {instance_name
                             datapath_type
                             mem_type
                             mem_size
                             source_dwidth
                             destination_dwidth
                             {ddr_data_width 0}
                             {ddr_addr_width 0}
                             {shared_devclk 0}} {

  global ad_hdl_dir
  global sys_cpu_resetn

  create_bd_cell -type hier $instance_name
  current_bd_instance /$instance_name

    ###########################################################################
    ## Sub-system's ports and interface definitions
    ###########################################################################

    create_bd_pin -dir I -type clk s_axi_aclk
    create_bd_pin -dir I -type rst s_axi_aresetn
    create_bd_pin -dir I -type clk s_axis_aclk
    create_bd_pin -dir I -type rst s_axis_aresetn
    create_bd_pin -dir I -type clk m_axis_aclk
    create_bd_pin -dir I -type rst m_axis_aresetn

    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi
    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis
    create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

    create_bd_pin -dir I init_req
    create_bd_pin -dir O init_ack
    create_bd_pin -dir I sync_ext

    set source_addresses [expr ($mem_size * 8) / $source_dwidth]
    set source_awidth [log2 $source_addresses]
    set destination_max_address [expr ($mem_size * 8) / $destination_dwidth]
    set destination_awidth [log2 $destination_max_address]

    ###########################################################################
    # Data offload controller instance
    ###########################################################################

    ad_ip_instance data_offload i_data_offload [list \
      MEM_TYPE $mem_type \
      MEM_SIZE $mem_size \
      TX_OR_RXN_PATH $datapath_type \
      SRC_DATA_WIDTH $source_dwidth \
      SRC_ADDR_WIDTH $source_awidth \
      DST_DATA_WIDTH $destination_dwidth \
      DST_ADDR_WIDTH $destination_awidth \
      DST_CYCLIC_EN $datapath_type \
      SYNC_EXT_ADD_INTERNAL_CDC [expr {!$shared_devclk}] \
    ]

    if {$mem_type == 0} {
      ###########################################################################
      # Internal storage instance (BRAMs)
      ###########################################################################

      ## Add the memory module source into the project file set
      if {[get_files -quiet "ad_mem_asym.v"] == ""} {
        add_files -norecurse -fileset sources_1 "$ad_hdl_dir/library/common/ad_mem_asym.v"
      }

      create_bd_cell -type module -reference ad_mem_asym storage_unit
      set_property -dict [list \
        CONFIG.A_DATA_WIDTH $source_dwidth \
        CONFIG.A_ADDRESS_WIDTH $source_awidth \
        CONFIG.B_DATA_WIDTH $destination_dwidth \
        CONFIG.B_ADDRESS_WIDTH $destination_awidth \
        CONFIG.CASCADE_HEIGHT 1 \
      ] [get_bd_cells storage_unit]

      ad_connect storage_unit/clka i_data_offload/s_axis_aclk
      ad_connect storage_unit/wea i_data_offload/fifo_src_wen
      ad_connect storage_unit/addra i_data_offload/fifo_src_waddr
      ad_connect storage_unit/dina i_data_offload/fifo_src_wdata
      ad_connect storage_unit/clkb i_data_offload/m_axis_aclk
      ad_connect storage_unit/reb i_data_offload/fifo_dst_ren
      ad_connect storage_unit/addrb i_data_offload/fifo_dst_raddr
      ad_connect storage_unit/doutb i_data_offload/fifo_dst_rdata
      ad_connect i_data_offload/fifo_dst_ready VCC     ; ## BRAM is always ready
      ad_connect i_data_offload/ddr_calib_done VCC

    } elseif {$mem_type == 1} {
      ###########################################################################
      # Bridge instance for the external DDR4 memory contreller
      # NOTE: The MIG instantiation should be in project's system_bd.tcl file
      ###########################################################################

      ad_ip_instance util_fifo2axi_bridge fifo2axi_bridge [list \
        SRC_DATA_WIDTH $source_dwidth \
        SRC_ADDR_WIDTH $source_awidth \
        DST_DATA_WIDTH $destination_dwidth \
        DST_ADDR_WIDTH $destination_awidth \
        AXI_DATA_WIDTH $ddr_data_width \
        AXI_ADDR_WIDTH $ddr_addr_width \
        AXI_ADDRESS 0x00000000 \
        AXI_ADDRESS_LIMIT [format 0x%X [expr int([expr { pow(2, 30) }]) - 1]] \
        REMOVE_NULL_BEAT_EN $datapath_type \
      ]

      ad_connect fifo2axi_bridge/fifo_src_clk i_data_offload/s_axis_aclk
      ad_connect fifo2axi_bridge/fifo_src_resetn i_data_offload/fifo_src_resetn
      ad_connect fifo2axi_bridge/fifo_src_wen i_data_offload/fifo_src_wen
      ad_connect fifo2axi_bridge/fifo_src_waddr i_data_offload/fifo_src_waddr
      ad_connect fifo2axi_bridge/fifo_src_wdata i_data_offload/fifo_src_wdata
      ad_connect fifo2axi_bridge/fifo_src_wlast i_data_offload/fifo_src_wlast

      ad_connect fifo2axi_bridge/fifo_dst_clk i_data_offload/m_axis_aclk
      ad_connect fifo2axi_bridge/fifo_dst_resetn i_data_offload/fifo_dst_resetn
      ad_connect fifo2axi_bridge/fifo_dst_ren i_data_offload/fifo_dst_ren
      ad_connect fifo2axi_bridge/fifo_dst_raddr i_data_offload/fifo_dst_raddr
      ad_connect fifo2axi_bridge/fifo_dst_rdata i_data_offload/fifo_dst_rdata
      ad_connect fifo2axi_bridge/fifo_dst_ready i_data_offload/fifo_dst_ready

    }

    ###########################################################################
    # Internal connections
    ###########################################################################

    ad_connect s_axi_aclk i_data_offload/s_axi_aclk
    ad_connect s_axi_aresetn i_data_offload/s_axi_aresetn
    ad_connect s_axis_aclk i_data_offload/s_axis_aclk
    ad_connect s_axis_aresetn i_data_offload/s_axis_aresetn
    ad_connect m_axis_aclk i_data_offload/m_axis_aclk
    ad_connect m_axis_aresetn i_data_offload/m_axis_aresetn

    ad_connect s_axi i_data_offload/s_axi
    ad_connect s_axis i_data_offload/s_axis
    ad_connect m_axis i_data_offload/m_axis

    ad_connect init_req i_data_offload/init_req
    ad_connect init_ack i_data_offload/init_ack
    ad_connect sync_ext i_data_offload/sync_ext

  current_bd_instance /

}

proc log2 {x} {
  return [tcl::mathfunc::int [tcl::mathfunc::ceil [expr [tcl::mathfunc::log $x] / [tcl::mathfunc::log 2]]]]
}
