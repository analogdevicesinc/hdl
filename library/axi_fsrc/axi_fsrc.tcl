###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#                                     L            M                 S                 N & NP
proc adi_axi_fsrc_rx_create {ip_name num_of_lanes num_of_converters samples_per_frame sample_width {link_layer_bytes_per_beat 4} {dma_sample_width 16}} {
  if {$num_of_lanes < 1 || $num_of_lanes > 32} {
    return -code 1 "ERROR: Invalid number of lanes. (Supported range 1-32)"
  }
  # F = (M * N * S) / (L * 8)
  set bytes_per_frame [expr ($num_of_converters * $sample_width * $samples_per_frame) / ($num_of_lanes * 8)];
  # one beat per lane must accommodate at least one frame
  set tpl_bytes_per_beat [expr max($bytes_per_frame, $link_layer_bytes_per_beat)]

  # datapath width = L * 8 * TPL_BYTES_PER_BEAT / (M * N)
  set samples_per_channel [expr ($num_of_lanes * 8 * $tpl_bytes_per_beat) / ($num_of_converters * $sample_width)];

  set channel_data_width [expr $samples_per_channel * $sample_width]
  set data_width [expr $channel_data_width * $num_of_converters]
  puts "channel_data_width: ${channel_data_width}, data_width: ${data_width}"
  startgroup

  set result [catch {
    create_bd_cell -type hier $ip_name
    # Control interface
    create_bd_pin -dir I -type clk ${ip_name}/s_axi_aclk
    create_bd_pin -dir I -type rst ${ip_name}/s_axi_aresetn
    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ${ip_name}/s_axi

    # Input/Output ports
    create_bd_pin -dir I -type clk ${ip_name}/link_clk
    create_bd_pin -dir I -type rst ${ip_name}/reset
    create_bd_pin -dir I ${ip_name}/adc_data_in_valid
    create_bd_pin -dir O ${ip_name}/adc_data_out_valid
    for {set i 0} {$i < $num_of_converters} {incr i} {
      create_bd_pin -dir I -from [expr ${channel_data_width} - 1] -to 0 ${ip_name}/adc_data_in_${i}
      create_bd_pin -dir O -from [expr ${channel_data_width} - 1] -to 0 ${ip_name}/adc_data_out_${i}
    }

    # Concatenate all the ADC data into a single stream
    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 ${ip_name}/data_concat
    set_property -dict [list \
      CONFIG.NUM_PORTS ${num_of_converters} \
    ] [get_bd_cells ${ip_name}/data_concat]
    for {set i 0} {$i < $num_of_converters} {incr i} {
      set_property -dict [list \
        CONFIG.IN${i}_WIDTH ${channel_data_width} \
      ] [get_bd_cells ${ip_name}/data_concat]
    }

    ad_ip_instance axi_fsrc_rx ${ip_name}/axi_fsrc_rx [list \
      NUM_OF_CHANNELS ${num_of_converters} \
      SAMPLES_PER_CHANNEL ${samples_per_channel} \
      SAMPLE_DATA_WIDTH ${sample_width} \
    ]

    # Slice the FSRC output stream into individial ADC streams
    for {set i 0} {$i < $num_of_converters} {incr i} {
      ad_ip_instance xlslice ${ip_name}/data_slice_${i} [list \
          DIN_WIDTH [expr $data_width] \
          DIN_FROM [expr $dma_sample_width*$samples_per_channel*($i+1)-1] \
          DIN_TO [expr $dma_sample_width*$samples_per_channel*$i] \
        ]
    }

    ad_connect ${ip_name}/s_axi_aclk       ${ip_name}/axi_fsrc_rx/s_axi_aclk
    ad_connect ${ip_name}/s_axi_aresetn    ${ip_name}/axi_fsrc_rx/s_axi_aresetn
    ad_connect ${ip_name}/s_axi            ${ip_name}/axi_fsrc_rx/s_axi

    ad_connect ${ip_name}/link_clk           ${ip_name}/axi_fsrc_rx/clk
    ad_connect ${ip_name}/reset              ${ip_name}/axi_fsrc_rx/reset
    ad_connect ${ip_name}/data_concat/dout   ${ip_name}/axi_fsrc_rx/data_in
    ad_connect ${ip_name}/adc_data_in_valid  ${ip_name}/axi_fsrc_rx/data_in_valid
    ad_connect ${ip_name}/adc_data_out_valid ${ip_name}/axi_fsrc_rx/data_out_valid

    for {set i 0} {$i < $num_of_converters} {incr i} {
      ad_connect ${ip_name}/adc_data_in_${i}      ${ip_name}/data_concat/In${i}
      ad_connect ${ip_name}/axi_fsrc_rx/data_out  ${ip_name}/data_slice_${i}/Din

      ad_connect ${ip_name}/data_slice_${i}/Dout ${ip_name}/adc_data_out_${i}
    }
  } resulttext resultoptions]

  dict unset resultoptions -level

  endgroup

  if {$result != 0} {
    undo -quiet
  }

  return -options $resultoptions $resulttext
}
