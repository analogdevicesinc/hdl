
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
      DST_DATA_WIDTH $destination_dwidth \
      DST_CYCLIC_EN $datapath_type \
      SYNC_EXT_ADD_INTERNAL_CDC [expr {!$shared_devclk}] \
    ]

    if {$mem_type == 0} {
      ###########################################################################
      # Internal storage instance (BRAMs)
      ###########################################################################

      ad_ip_instance util_do_ram storage_unit [list \
        SRC_DATA_WIDTH $source_dwidth \
        DST_DATA_WIDTH $destination_dwidth \
        LENGTH_WIDTH [log2 $mem_size] \
      ]

      ad_connect storage_unit/wr_ctrl i_data_offload/wr_ctrl
      ad_connect storage_unit/rd_ctrl i_data_offload/rd_ctrl

      ad_connect storage_unit/s_axis i_data_offload/m_storage_axis
      ad_connect storage_unit/m_axis i_data_offload/s_storage_axis

      ad_connect storage_unit/s_axis_aclk s_axis_aclk
      ad_connect storage_unit/s_axis_aresetn s_axis_aresetn
      ad_connect storage_unit/m_axis_aclk m_axis_aclk
      ad_connect storage_unit/m_axis_aresetn m_axis_aresetn

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

    } elseif {$mem_type == 2} {
      ###########################################################################
      # Bridge instance for the external HBM memory contreller
      # NOTE: The HBM instantiation should be in project's system_bd.tcl file
      ###########################################################################
      source $ad_hdl_dir/library/util_hbm/scripts/adi_util_hbm.tcl

      set segments_per_master [expr int(ceil($mem_size.0 / (256.0 * 1024 * 1024)))]
      ad_create_util_hbm i_util_hbm \
        $datapath_type \
        $source_dwidth \
        $destination_dwidth \
        $segments_per_master
      ad_ip_parameter i_util_hbm CONFIG.LENGTH_WIDTH [log2 $mem_size]

      ad_connect i_util_hbm/wr_ctrl i_data_offload/wr_ctrl
      ad_connect i_util_hbm/rd_ctrl i_data_offload/rd_ctrl

      ad_connect i_util_hbm/s_axis i_data_offload/m_storage_axis
      ad_connect i_util_hbm/m_axis i_data_offload/s_storage_axis

      ad_connect i_util_hbm/s_axis_aclk s_axis_aclk
      ad_connect i_util_hbm/s_axis_aresetn s_axis_aresetn
      ad_connect i_util_hbm/m_axis_aclk m_axis_aclk
      ad_connect i_util_hbm/m_axis_aresetn m_axis_aresetn

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
    ad_connect sync_ext i_data_offload/sync_ext

  current_bd_instance /

}

proc log2 {x} {
  return [tcl::mathfunc::int [tcl::mathfunc::ceil [expr [tcl::mathfunc::log $x] / [tcl::mathfunc::log 2]]]]
}
