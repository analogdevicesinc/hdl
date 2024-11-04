###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# density 4GB,8GB
proc ad_create_hbm {ip_name {density "4GB"}} {

  add_instance $ip_name hbm
  set_instance_parameter_value $ip_name {USER_HBM_DENSITY} $density
  set_instance_parameter_value $ip_name {USER_APB_EN} {false}

  set i_hbm_ip [get_bd_cells $ip_name]
  set num_stacks [get_instance_parameter_value $i_hbm_ip USER_HBM_STACK]
  # 16 pseudo channels / sections / segments per stack
  set num_segments [expr $num_stacks*16]
  for {set i 1} {$i < $num_segments} {incr i} {
    set i_formatted [format "%02d" $i]
    set_instance_parameter_value $ip_name {USER_SAXI_${i_formatted}} {false}
  }
}

proc ad_create_util_hbm {name tx_rx_n src_width dst_width mem_size {axi_data_width 256} {mem_type 2}} {

  if {$mem_type == 2} {
    # HBM
    # split converter side bus into multiple AXI masters
    set number_of_masters [expr int(ceil((${tx_rx_n} == 1 ? ${dst_width}.0 : ${src_width}.0) / ${axi_data_width}.0))]
  } else {
    # DDR we have always one master
    set number_of_masters 1
  }

  add_instance $name util_hbm
  set_instance_parameter_value $name {LENGTH_WIDTH} [log2 $mem_size]
  set_instance_parameter_value $name {SRC_DATA_WIDTH} $src_width
  set_instance_parameter_value $name {DST_DATA_WIDTH} $dst_width
  set_instance_parameter_value $name {AXI_DATA_WIDTH} $axi_data_width
  set_instance_parameter_value $name {TX_RX_N} $tx_rx_n
  set_instance_parameter_value $name {NUM_M} $number_of_masters
  set_instance_parameter_value $name {MEM_TYPE} $mem_type
}

proc ad_connect_hbm {i_hbm i_util_hbm axi_clk axi_aresetn {first_slave_index 0}} {

  set i_util_hbm_ip [get_bd_cells $i_util_hbm]
  set segments_per_master [get_instance_parameter_value $i_util_hbm_ip HBM_SEGMENTS_PER_MASTER]
  set num_m [get_instance_parameter_value $i_util_hbm_ip NUM_M]

  set i_hbm_ip [get_bd_cells $i_hbm]
  set num_stacks [get_instance_parameter_value $i_hbm_ip USER_HBM_STACK]

  # 16 pseudo channels / sections / segments per stack
  set num_segments [expr $num_stacks*16]

  set totat_used_segments [expr $num_m * $segments_per_master]

  for {set i 0} {$i < $totat_used_segments} {incr i} {

    set idx_hbm_slv [format "%02d" [expr $i+$first_slave_index]]

    if {$i % $segments_per_master == 0} {
      set_instance_parameter_value $i_hbm {USER_SAXI_${idx_hbm_slv}} {true}
      add_connection $i_util_hbm/MAXI_[expr $i/$segments_per_master] $i_hbm/SAXI_${idx_hbm_slv}
      add_connection $i_hbm/AXI_${idx_hbm_slv}_ACLK $axi_clk
      add_connection $i_hbm/AXI_${idx_hbm_slv}_ARESET_N $axi_aresetn
    }
  }

  set_instance_parameter_value $i_util_hbm {HBM_SEGMENT_INDEX} $first_slave_index

  add_connection $axi_clk $i_util_hbm/m_axi_aclk
  add_connection $axi_aresetn $i_util_hbm/m_axi_aresetn
}

proc log2 {x} {
  return [tcl::mathfunc::int [tcl::mathfunc::ceil [expr [tcl::mathfunc::log $x] / [tcl::mathfunc::log 2]]]]
}
