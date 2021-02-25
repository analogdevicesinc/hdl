
package require qsys
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create avl_dacfifo {Avalon DDR DAC Fifo} p_avl_dacfifo_elab
ad_ip_files avl_dacfifo [list\
  $ad_hdl_dir/library/common/util_delay.v \
  $ad_hdl_dir/library/common/ad_b2g.v \
  $ad_hdl_dir/library/common/ad_g2b.v \
  $ad_hdl_dir/library/common/ad_mem.v \
  util_dacfifo_bypass.v \
  avl_dacfifo_wr.v \
  avl_dacfifo_rd.v \
  avl_dacfifo.v \
  avl_dacfifo_constr.sdc]

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter DAC_DATA_WIDTH INTEGER 64
ad_ip_parameter DAC_MEM_ADDRESS_WIDTH INTEGER 8
ad_ip_parameter DMA_DATA_WIDTH INTEGER 64
ad_ip_parameter DMA_MEM_ADDRESS_WIDTH INTEGER 8
ad_ip_parameter AVL_DATA_WIDTH INTEGER 512
ad_ip_parameter AVL_ADDRESS_WIDTH INTEGER 25
ad_ip_parameter AVL_BURST_LENGTH INTEGER 127
ad_ip_parameter AVL_BASE_ADDRESS INTEGER 0
ad_ip_parameter AVL_ADDRESS_LIMIT INTEGER 0x800000

# interfaces

ad_interface clock dma_clk input 1 clk
ad_interface reset dma_rst input 1 if_dma_clk
ad_interface signal dma_xfer_req input 1 xfer_req

add_interface s_axis axi4stream end
set_interface_property s_axis associatedClock if_dma_clk
set_interface_property s_axis associatedReset if_dma_rst
add_interface_port  s_axis  dma_valid      tvalid  Input   1
add_interface_port  s_axis  dma_xfer_last  tlast   Input   1
add_interface_port  s_axis  dma_ready      tready  Output  1
add_interface_port  s_axis  dma_data       tdata   Input   DMA_DATA_WIDTH

ad_interface clock dac_clk input 1 clk
ad_interface reset dac_rst input 1 if_dac_clk
ad_interface signal dac_valid input 1 valid
ad_interface signal dac_data output DAC_DATA_WIDTH data
ad_interface signal dac_dunf output 1 unf
ad_interface signal dac_xfer_out output 1 xfer_out

ad_interface signal  bypass  input 1 bypass

add_interface avl_clock clock end
add_interface_port avl_clock avl_clk clk input 1

add_interface avl_reset reset end
set_interface_property avl_reset associatedclock avl_clock
add_interface_port avl_reset avl_reset reset input 1

add_interface amm_ddr avalon master
add_interface_port amm_ddr avl_address address output 25
add_interface_port amm_ddr avl_burstcount burstcount output 7
add_interface_port amm_ddr avl_byteenable byteenable output 64
add_interface_port amm_ddr avl_read read output 1
add_interface_port amm_ddr avl_readdata readdata input 512
add_interface_port amm_ddr avl_readdata_valid readdatavalid input 1
add_interface_port amm_ddr avl_ready waitrequest_n input 1
add_interface_port amm_ddr avl_write write output 1
add_interface_port amm_ddr avl_writedata writedata output 512

set_interface_property amm_ddr associatedClock avl_clock
set_interface_property amm_ddr associatedReset avl_reset
set_interface_property amm_ddr addressUnits WORDS

# elaborate

proc p_avl_dacfifo_elab {} {

  # read parameters

  set m_device_family [get_parameter_value "DEVICE_FAMILY"]
  set m_dma_data_width [get_parameter_value "DMA_DATA_WIDTH"]
  set m_dma_mem_addr_width [get_parameter_value "DMA_MEM_ADDRESS_WIDTH"]
  set m_avl_data_width [get_parameter_value "AVL_DATA_WIDTH"]
  set m_avl_addr_width [get_parameter_value "AVL_ADDRESS_WIDTH"]
  set m_dac_data_width [get_parameter_value "DAC_DATA_WIDTH"]
  set m_dac_mem_addr_width [get_parameter_value "DAC_MEM_ADDRESS_WIDTH"]
  set m_dac_mem_addr_width_bypass 10
  if {$m_dma_data_width > $m_dac_data_width} {
    set m_dma_to_dac_ratio [expr $m_dma_data_width/$m_dac_data_width]
    if {$m_dma_to_dac_ratio eq 2} {
      set m_dma_mem_addr_width_bypass [expr $m_dac_mem_addr_width_bypass - 1]
    } elseif {$m_dma_to_dac_ratio eq 4} {
      set m_dma_mem_addr_width_bypass [expr $m_dac_mem_addr_width_bypass - 2]
    } else {
      set m_dma_mem_addr_width_bypass [expr $m_dac_mem_addr_width_bypass - 3]
    }
  } else {
    set m_dma_to_dac_ratio [expr $m_dac_data_width/$m_dma_data_width]
    if {$m_dma_to_dac_ratio eq 1} {
      set m_dma_mem_addr_width_bypass $m_dac_mem_addr_width_bypass
    } elseif {$m_dma_to_dac_ratio eq 2} {
      set m_dma_mem_addr_width_bypass [expr $m_dac_mem_addr_width_bypass - 1]
    } elseif {$m_dma_to_dac_ratio eq 4} {
      set m_dma_mem_addr_width_bypass [expr $m_dac_mem_addr_width_bypass - 2]
    } else {
      set m_dma_mem_addr_width_bypass [expr $m_dac_mem_addr_width_bypass - 3]
    }
  }

  # intel memory for WRITE side

  add_hdl_instance ad_mem_asym_wr intel_mem_asym 1.0
  set_instance_parameter_value ad_mem_asym_wr DEVICE_FAMILY $m_device_family
  set_instance_parameter_value ad_mem_asym_wr A_ADDRESS_WIDTH $m_dma_mem_addr_width
  set_instance_parameter_value ad_mem_asym_wr A_DATA_WIDTH $m_dma_data_width
  set_instance_parameter_value ad_mem_asym_wr B_DATA_WIDTH $m_avl_data_width

  # intel memory for READ side

  add_hdl_instance ad_mem_asym_rd intel_mem_asym 1.0
  set_instance_parameter_value ad_mem_asym_rd DEVICE_FAMILY $m_device_family
  set_instance_parameter_value ad_mem_asym_rd A_ADDRESS_WIDTH 0
  set_instance_parameter_value ad_mem_asym_rd A_DATA_WIDTH $m_avl_data_width
  set_instance_parameter_value ad_mem_asym_rd B_ADDRESS_WIDTH $m_dac_mem_addr_width
  set_instance_parameter_value ad_mem_asym_rd B_DATA_WIDTH $m_dac_data_width

  # intel memory for bypass logic

  add_hdl_instance ad_mem_asym_bypass intel_mem_asym 1.0
  set_instance_parameter_value ad_mem_asym_bypass DEVICE_FAMILY $m_device_family
  set_instance_parameter_value ad_mem_asym_bypass A_ADDRESS_WIDTH $m_dma_mem_addr_width_bypass
  set_instance_parameter_value ad_mem_asym_bypass A_DATA_WIDTH $m_dma_data_width
  set_instance_parameter_value ad_mem_asym_bypass B_ADDRESS_WIDTH $m_dac_mem_addr_width_bypass
  set_instance_parameter_value ad_mem_asym_bypass B_DATA_WIDTH $m_dac_data_width

}

