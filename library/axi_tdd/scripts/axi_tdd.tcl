###############################################################################
## Copyright (C) 2022-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc ad_tdd_gen_create {ip_name
                        num_of_channels
                        {default_polarity 0}
                        {reg_counter_width 32}
                        {burst_counter_width 32}
                        {sync_counter_width 64}
                        {sync_internal 1}
                        {sync_external 0}
                        {sync_external_cdc 0}} {

  create_bd_cell -type hier $ip_name

  # Control interface
  create_bd_pin -dir I -type clk "${ip_name}/s_axi_aclk"
  create_bd_pin -dir I -type rst "${ip_name}/s_axi_aresetn"
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 "${ip_name}/s_axi"

  # Device interface
  create_bd_pin -dir I -type clk "${ip_name}/clk"
  create_bd_pin -dir I -type rst "${ip_name}/resetn"
  create_bd_pin -dir I "${ip_name}/sync_in"
  create_bd_pin -dir O "${ip_name}/sync_out"
  for {set i 0} {$i < $num_of_channels} {incr i} {
    create_bd_pin -dir O "${ip_name}/tdd_channel_${i}"
  }

  # Generic TDD core
  ad_ip_instance axi_tdd "${ip_name}/tdd_core" [list \
    CHANNEL_COUNT $num_of_channels \
    DEFAULT_POLARITY $default_polarity \
    REGISTER_WIDTH $reg_counter_width \
    BURST_COUNT_WIDTH $burst_counter_width \
    SYNC_COUNT_WIDTH $sync_counter_width \
    SYNC_INTERNAL $sync_internal \
    SYNC_EXTERNAL $sync_external \
    SYNC_EXTERNAL_CDC $sync_external_cdc
   ]

  for {set i 0} {$i < $num_of_channels} {incr i} {
    ad_ip_instance ilslice "${ip_name}/tdd_ch_slice_${i}" [list \
      DIN_WIDTH $num_of_channels \
      DIN_FROM $i \
      DIN_TO $i \
    ]
  }

  # Create connections
  ad_connect "${ip_name}/s_axi_aclk" "${ip_name}/tdd_core/s_axi_aclk"
  ad_connect "${ip_name}/s_axi_aresetn" "${ip_name}/tdd_core/s_axi_aresetn"
  ad_connect "${ip_name}/s_axi" "${ip_name}/tdd_core/s_axi"

  ad_connect ${ip_name}/tdd_core/clk ${ip_name}/clk
  ad_connect ${ip_name}/tdd_core/resetn ${ip_name}/resetn
  ad_connect ${ip_name}/tdd_core/sync_in ${ip_name}/sync_in
  ad_connect ${ip_name}/tdd_core/sync_out ${ip_name}/sync_out

  for {set i 0} {$i < $num_of_channels} {incr i} {
    ad_connect ${ip_name}/tdd_core/tdd_channel ${ip_name}/tdd_ch_slice_$i/Din
    ad_connect ${ip_name}/tdd_ch_slice_$i/Dout ${ip_name}/tdd_channel_$i
  }

}
