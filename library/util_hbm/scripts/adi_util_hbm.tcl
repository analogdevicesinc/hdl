###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# density 4GB,8GB
proc ad_create_hbm {ip_name {density "4GB"}} {
  global hbm_sim;
  if { [info exists hbm_sim] == 0} {
    set hbm_sim 0
  }

  if {$hbm_sim == 0} {
    ad_ip_instance hbm $ip_name
    ad_ip_parameter $ip_name CONFIG.USER_HBM_DENSITY $density
    ad_ip_parameter $ip_name CONFIG.USER_APB_EN {false}

    set i_hbm_ip [get_bd_cells $ip_name]
    set num_stacks [get_property CONFIG.USER_HBM_STACK $i_hbm_ip]
    # 16 pseudo channels / sections / segments per stack
    set num_segments [expr $num_stacks*16]
    for {set i 1} {$i < $num_segments} {incr i} {
      set i_formatted [format "%02d" $i]
      ad_ip_parameter $ip_name CONFIG.USER_SAXI_${i_formatted} {false}
    }

  } else {
    # Create data storage HMB controller model (AXI slave)
    ad_ip_instance axi_vip $ip_name [list \
      INTERFACE_MODE {SLAVE} \
    ]
    adi_sim_add_define "HBM_AXI=$ip_name"
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

  ad_ip_instance util_hbm $name [list \
    LENGTH_WIDTH [log2 $mem_size] \
    SRC_DATA_WIDTH $src_width \
    DST_DATA_WIDTH $dst_width \
    AXI_DATA_WIDTH $axi_data_width \
    TX_RX_N $tx_rx_n \
    NUM_M $number_of_masters \
    MEM_TYPE $mem_type \
  ]
}

proc ad_connect_hbm {i_hbm i_util_hbm axi_clk axi_aresetn {first_slave_index 0}} {
  global hbm_sim;
  if { [info exists hbm_sim] == 0} {
    set hbm_sim 0
  }

  set i_util_hbm_ip [get_bd_cells $i_util_hbm]
  set segments_per_master [get_property CONFIG.HBM_SEGMENTS_PER_MASTER $i_util_hbm_ip]
  set num_m [get_property CONFIG.NUM_M $i_util_hbm_ip]

  if {$hbm_sim == 0} {

    set i_hbm_ip [get_bd_cells $i_hbm]
    set num_stacks [get_property CONFIG.USER_HBM_STACK $i_hbm_ip]

    # 16 pseudo channels / sections / segments per stack
    set num_segments [expr $num_stacks*16]

    set totat_used_segments [expr $num_m * $segments_per_master]

    for {set i 0} {$i < $totat_used_segments} {incr i} {

      set idx_hbm_slv [format "%02d" [expr $i+$first_slave_index]]

      if {$i % $segments_per_master == 0} {
        ad_ip_parameter $i_hbm CONFIG.USER_SAXI_${idx_hbm_slv} {true}
        ad_connect $i_util_hbm/MAXI_[expr $i/$segments_per_master] $i_hbm/SAXI_${idx_hbm_slv}
        ad_connect $i_hbm/AXI_${idx_hbm_slv}_ACLK $axi_clk
        ad_connect $i_hbm/AXI_${idx_hbm_slv}_ARESET_N $axi_aresetn
      }
    }

    ad_ip_parameter $i_util_hbm CONFIG.HBM_SEGMENT_INDEX $first_slave_index

  } else {

    # Create smart connect
    ad_ip_instance smartconnect axi_hbm_interconnect [list \
      NUM_MI 1 \
      NUM_SI $num_m \
    ]
    # connect it to hbm vip
    ad_connect axi_hbm_interconnect/M00_AXI $i_hbm/S_AXI
    # connect smart connect to util_hbm
    for {set i 0} {$i < $num_m} {incr i} {
      set i_formatted [format "%02d" $i]
      ad_connect $i_util_hbm/MAXI_$i axi_hbm_interconnect/S${i_formatted}_AXI
    }
    ad_connect axi_hbm_interconnect/aclk $axi_clk
    ad_connect axi_hbm_interconnect/aresetn $axi_aresetn

    ad_connect $i_hbm/aclk $axi_clk
    ad_connect $i_hbm/aresetn $axi_aresetn
  }
  ad_connect $axi_clk $i_util_hbm/m_axi_aclk
  ad_connect $axi_aresetn $i_util_hbm/m_axi_aresetn

  for {set i 0} {$i < $num_m} {incr i} {
    assign_bd_address -target_address_space $i_util_hbm/MAXI_${i}
  }
}

proc log2 {x} {
  return [tcl::mathfunc::int [tcl::mathfunc::ceil [expr [tcl::mathfunc::log $x] / [tcl::mathfunc::log 2]]]]
}
