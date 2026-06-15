###############################################################################
## Copyright (C) 2021-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

proc ad_data_offload_create {instance_name
                             datapath_type
                             mem_type
                             mem_size
                             source_dwidth
                             destination_dwidth
                             {axi_data_width 256}
                             {axi_addr_width 32}
                             {shared_devclk 0}
                             {async_clk 1}} {

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
      MEM_TYPE [expr $mem_type == 0 ? 0 : 1] \
      MEM_SIZE_LOG2 [log2 $mem_size] \
      TX_OR_RXN_PATH $datapath_type \
      SRC_DATA_WIDTH $source_dwidth \
      DST_DATA_WIDTH $destination_dwidth \
      DST_CYCLIC_EN $datapath_type \
      SYNC_EXT_ADD_INTERNAL_CDC [expr {!$shared_devclk}] \
      ASYNC_CLK $async_clk \
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

    } elseif {$mem_type == 1 || $mem_type == 2} {
      ###########################################################################
      # Bridge instance for the external DDR (1) / HBM(2) memory contreller
      # NOTE: The DDR/HBM instantiation should be in project's system_bd.tcl file
      ###########################################################################
      source $ad_hdl_dir/library/util_hbm/scripts/adi_util_hbm.tcl

      ad_create_util_hbm storage_unit \
        $datapath_type \
        $source_dwidth \
        $destination_dwidth \
        $mem_size \
        $axi_data_width \
        $mem_type

      if {$mem_type == 1} {
        ad_ip_parameter storage_unit CONFIG.AXI_PROTOCOL 0
      } else {
        ad_ip_parameter storage_unit CONFIG.AXI_PROTOCOL 1
      }

    }

    ###########################################################################
    # Connect Storage to Data Offload
    ###########################################################################
    ad_connect storage_unit/wr_ctrl i_data_offload/wr_ctrl
    ad_connect storage_unit/rd_ctrl i_data_offload/rd_ctrl

    ad_connect storage_unit/s_axis i_data_offload/m_storage_axis
    ad_connect storage_unit/m_axis i_data_offload/s_storage_axis

    ad_connect storage_unit/s_axis_aclk s_axis_aclk
    ad_connect storage_unit/s_axis_aresetn s_axis_aresetn
    ad_connect storage_unit/m_axis_aclk m_axis_aclk
    ad_connect storage_unit/m_axis_aresetn m_axis_aresetn

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
