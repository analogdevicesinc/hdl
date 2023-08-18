###############################################################################
## Copyright (C) 2017-2022 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

proc adi_axi_jesd204_tx_create {ip_name num_lanes {num_links 1} {link_mode 1}} {

  if {$num_lanes < 1 || $num_lanes > 32} {
    return -code 1 "ERROR: Invalid number of JESD204B lanes. (Supported range 1-32)"
  }

  if {$num_links < 1 || $num_links > 8} {
    return -code 1 "ERROR: Invalid number of JESD204B links. (Supported range 1-8)"
  }

  startgroup

  set result [catch {

    create_bd_cell -type hier $ip_name

    ad_ip_instance axi_jesd204_tx "${ip_name}/tx_axi"
    ad_ip_instance jesd204_tx "${ip_name}/tx"

    ad_ip_parameter "${ip_name}/tx_axi" CONFIG.NUM_LANES $num_lanes
    ad_ip_parameter "${ip_name}/tx_axi" CONFIG.NUM_LINKS $num_links
    ad_ip_parameter "${ip_name}/tx_axi" CONFIG.LINK_MODE $link_mode
    ad_ip_parameter "${ip_name}/tx"     CONFIG.NUM_LANES $num_lanes
    ad_ip_parameter "${ip_name}/tx"     CONFIG.NUM_LINKS $num_links
    ad_ip_parameter "${ip_name}/tx"     CONFIG.LINK_MODE $link_mode

    ad_connect "${ip_name}/tx_axi/core_reset" "${ip_name}/tx/reset"
    ad_connect "${ip_name}/tx_axi/device_reset" "${ip_name}/tx/device_reset"
    if {$link_mode == 1} {ad_connect "${ip_name}/tx_axi/tx_ctrl" "${ip_name}/tx/tx_ctrl"}
    ad_connect "${ip_name}/tx_axi/tx_cfg" "${ip_name}/tx/tx_cfg"
    ad_connect "${ip_name}/tx/tx_event" "${ip_name}/tx_axi/tx_event"
    ad_connect "${ip_name}/tx/tx_status" "${ip_name}/tx_axi/tx_status"
    if {$link_mode == 1} {ad_connect "${ip_name}/tx/tx_ilas_config" "${ip_name}/tx_axi/tx_ilas_config"}

    # Control interface
    create_bd_pin -dir I -type clk "${ip_name}/s_axi_aclk"
    create_bd_pin -dir I -type rst "${ip_name}/s_axi_aresetn"
    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 "${ip_name}/s_axi"
    create_bd_pin -dir O -type intr "${ip_name}/irq"

    ad_connect "${ip_name}/s_axi_aclk" "${ip_name}/tx_axi/s_axi_aclk"
    ad_connect "${ip_name}/s_axi_aresetn" "${ip_name}/tx_axi/s_axi_aresetn"
    ad_connect "${ip_name}/s_axi" "${ip_name}/tx_axi/s_axi"
    ad_connect "${ip_name}/tx_axi/irq" "${ip_name}/irq"

    # JESD204 processing
    create_bd_pin -dir I -type clk "${ip_name}/link_clk"
    create_bd_pin -dir I -type clk "${ip_name}/device_clk"
    if {$link_mode == 1} {create_bd_pin -dir I -from [expr $num_links - 1] -to 0 "${ip_name}/sync"}
    create_bd_pin -dir I "${ip_name}/sysref"

    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 "${ip_name}/tx_data"

    ad_connect "${ip_name}/link_clk" "${ip_name}/tx_axi/core_clk"
    ad_connect "${ip_name}/link_clk" "${ip_name}/tx/clk"
    ad_connect "${ip_name}/device_clk" "${ip_name}/tx_axi/device_clk"
    ad_connect "${ip_name}/device_clk" "${ip_name}/tx/device_clk"
    if {$link_mode == 1} {ad_connect "${ip_name}/sync" "${ip_name}/tx/sync"}
    ad_connect "${ip_name}/sysref" "${ip_name}/tx/sysref"
    ad_connect "${ip_name}/tx_data" "${ip_name}/tx/tx_data"

    for {set i 0} {$i < $num_lanes} {incr i} {
      create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 "${ip_name}/tx_phy${i}"
      ad_connect "${ip_name}/tx/tx_phy${i}" "${ip_name}/tx_phy${i}"
    }
  } resulttext resultoptions]

  dict unset resultoptions -level

  endgroup

  if {$result != 0} {
    undo -quiet
  }

  return -options $resultoptions $resulttext
}

proc adi_axi_jesd204_rx_create {ip_name num_lanes {num_links 1} {link_mode 1}} {

  if {$num_lanes < 1 || $num_lanes > 32} {
    return -code 1 "ERROR: Invalid number of JESD204B lanes. (Supported range 1-32)"
  }

  if {$num_links < 1 || $num_links > 8} {
    return -code 1 "ERROR: Invalid number of JESD204B links. (Supported range 1-8)"
  }

  startgroup

  set result [catch {

    create_bd_cell -type hier $ip_name

    ad_ip_instance axi_jesd204_rx "${ip_name}/rx_axi"
    ad_ip_instance jesd204_rx "${ip_name}/rx"

    ad_ip_parameter "${ip_name}/rx_axi" CONFIG.NUM_LANES $num_lanes
    ad_ip_parameter "${ip_name}/rx_axi" CONFIG.NUM_LINKS $num_links
    ad_ip_parameter "${ip_name}/rx_axi" CONFIG.LINK_MODE $link_mode
    ad_ip_parameter "${ip_name}/rx"     CONFIG.NUM_LANES $num_lanes
    ad_ip_parameter "${ip_name}/rx"     CONFIG.NUM_LINKS $num_links
    ad_ip_parameter "${ip_name}/rx"     CONFIG.LINK_MODE $link_mode

    ad_connect "${ip_name}/rx_axi/core_reset" "${ip_name}/rx/reset"
    ad_connect "${ip_name}/rx_axi/device_reset" "${ip_name}/rx/device_reset"
    ad_connect "${ip_name}/rx_axi/rx_cfg" "${ip_name}/rx/rx_cfg"
    ad_connect "${ip_name}/rx/rx_event" "${ip_name}/rx_axi/rx_event"
    ad_connect "${ip_name}/rx/rx_status" "${ip_name}/rx_axi/rx_status"
    if {$link_mode == 1} {ad_connect "${ip_name}/rx/rx_ilas_config" "${ip_name}/rx_axi/rx_ilas_config"}

    # Control interface
    create_bd_pin -dir I -type clk "${ip_name}/s_axi_aclk"
    create_bd_pin -dir I -type rst "${ip_name}/s_axi_aresetn"
    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 "${ip_name}/s_axi"
    create_bd_pin -dir O -type intr "${ip_name}/irq"

    ad_connect "${ip_name}/s_axi_aclk" "${ip_name}/rx_axi/s_axi_aclk"
    ad_connect "${ip_name}/s_axi_aresetn" "${ip_name}/rx_axi/s_axi_aresetn"
    ad_connect "${ip_name}/s_axi" "${ip_name}/rx_axi/s_axi"
    ad_connect "${ip_name}/rx_axi/irq" "${ip_name}/irq"

    # JESD204 processing
    create_bd_pin -dir I -type clk "${ip_name}/link_clk"
    create_bd_pin -dir I -type clk "${ip_name}/device_clk"
    if {$link_mode == 1} {create_bd_pin -dir O -from [expr $num_links - 1] -to 0 "${ip_name}/sync"}
    create_bd_pin -dir I "${ip_name}/sysref"
    if {$link_mode == 1} {create_bd_pin -dir O "${ip_name}/phy_en_char_align"}
#    create_bd_pin -dir I "${ip_name}/phy_ready"
    create_bd_pin -dir O -from 3 -to 0 "${ip_name}/rx_eof"
    create_bd_pin -dir O -from 3 -to 0 "${ip_name}/rx_sof"

#    create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 "${ip_name}/rx_data"
    create_bd_pin -dir O "${ip_name}/rx_data_tvalid"
    create_bd_pin -dir O -from [expr $num_lanes * 32 - 1] -to 0 "${ip_name}/rx_data_tdata"

    ad_connect "${ip_name}/link_clk" "${ip_name}/rx_axi/core_clk"
    ad_connect "${ip_name}/link_clk" "${ip_name}/rx/clk"
    ad_connect "${ip_name}/device_clk" "${ip_name}/rx_axi/device_clk"
    ad_connect "${ip_name}/device_clk" "${ip_name}/rx/device_clk"
    if {$link_mode == 1} {ad_connect "${ip_name}/rx/sync" "${ip_name}/sync"}
    ad_connect "${ip_name}/sysref" "${ip_name}/rx/sysref"
#    ad_connect "${ip_name}/phy_ready" "${ip_name}/rx/phy_ready"
    if {$link_mode == 1} {ad_connect "${ip_name}/rx/phy_en_char_align" "${ip_name}/phy_en_char_align"}
    ad_connect "${ip_name}/rx/rx_data" "${ip_name}/rx_data_tdata"
    ad_connect "${ip_name}/rx/rx_valid" "${ip_name}/rx_data_tvalid"
    ad_connect "${ip_name}/rx/rx_eof" "${ip_name}/rx_eof"
    ad_connect "${ip_name}/rx/rx_sof" "${ip_name}/rx_sof"

    for {set i 0} {$i < $num_lanes} {incr i} {
      create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 "${ip_name}/rx_phy${i}"
      ad_connect "${ip_name}/rx/rx_phy${i}" "${ip_name}/rx_phy${i}"
    }
  } resulttext resultoptions]

  dict unset resultoptions -level

  endgroup

  if {$result != 0} {
    undo -quiet
  }

  return -options $resultoptions $resulttext
}




#                                       L            M                 S                 N & NP
proc adi_tpl_jesd204_tx_create {ip_name num_of_lanes num_of_converters samples_per_frame sample_width {link_layer_bytes_per_beat 4} {dma_sample_width 16}} {


  if {$num_of_lanes < 1 || $num_of_lanes > 32} {
    return -code 1 "ERROR: Invalid number of JESD204B lanes. (Supported range 1-32)"
  }
  # F = (M * N * S) / (L * 8)
  set bytes_per_frame [expr ($num_of_converters * $sample_width * $samples_per_frame) / ($num_of_lanes * 8)];
  # one beat per lane must accommodate at least one frame
  set tpl_bytes_per_beat [expr max($bytes_per_frame, $link_layer_bytes_per_beat)]

  # datapath width = L * 8 * TPL_BYTES_PER_BEAT / (M * N)
  set samples_per_channel [expr ($num_of_lanes * 8 * $tpl_bytes_per_beat) / ($num_of_converters * $sample_width)];


  startgroup

  set result [catch {

    create_bd_cell -type hier $ip_name

    # Control interface
    create_bd_pin -dir I -type clk "${ip_name}/s_axi_aclk"
    create_bd_pin -dir I -type rst "${ip_name}/s_axi_aresetn"
    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 "${ip_name}/s_axi"

    # Interface to link layer
    create_bd_pin -dir I -type clk "${ip_name}/link_clk"
    create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 "${ip_name}/link"

    # Interface to application layer
    create_bd_pin -dir I "${ip_name}/dac_dunf"
    for {set i 0} {$i < $num_of_converters} {incr i} {
      create_bd_pin -dir O "${ip_name}/dac_enable_${i}"
      create_bd_pin -dir O "${ip_name}/dac_valid_${i}"
      create_bd_pin -dir I "${ip_name}/dac_data_${i}"
    }

    # Generic TPL core
    ad_ip_instance ad_ip_jesd204_tpl_dac "${ip_name}/dac_tpl_core" [list \
      NUM_LANES $num_of_lanes \
      NUM_CHANNELS $num_of_converters \
      SAMPLES_PER_FRAME $samples_per_frame \
      CONVERTER_RESOLUTION $sample_width \
      BITS_PER_SAMPLE $sample_width  \
      OCTETS_PER_BEAT $tpl_bytes_per_beat \
      DMA_BITS_PER_SAMPLE $dma_sample_width
     ]

    if {$num_of_converters > 1} {
      # Concatenation and slicer cores
      # xconcat limited to 32 input ports
      for {set i 0} {$i < $num_of_converters} {incr i 32} {
      ad_ip_instance xlconcat "${ip_name}/data_concat[expr $i/32]" [list \
        NUM_PORTS [expr min(32,$num_of_converters-$i)] \
        ]
      }
      # main concat
      if {$num_of_converters > 32} {
       ad_ip_instance xlconcat "${ip_name}/data_concat" [list \
        NUM_PORTS [expr int(ceil(double($num_of_converters)/32))] \
        ]
      }

      for {set i 0} {$i < $num_of_converters} {incr i} {
        ad_ip_instance xlslice "${ip_name}/enable_slice_${i}" [list \
          DIN_WIDTH $num_of_converters \
          DIN_FROM $i \
          DIN_TO $i \
        ]
        ad_ip_instance xlslice "${ip_name}/valid_slice_${i}" [list \
          DIN_WIDTH $num_of_converters \
          DIN_FROM $i \
          DIN_TO $i \
        ]
      }
    }
    # Create connections
    # TPL configuration interface
    ad_connect "${ip_name}/s_axi_aclk" "${ip_name}/dac_tpl_core/s_axi_aclk"
    ad_connect "${ip_name}/s_axi_aresetn" "${ip_name}/dac_tpl_core/s_axi_aresetn"
    ad_connect "${ip_name}/s_axi" "${ip_name}/dac_tpl_core/s_axi"

    # TPL - link layer
    ad_connect ${ip_name}/dac_tpl_core/link_clk ${ip_name}/link_clk
    ad_connect ${ip_name}/dac_tpl_core/link ${ip_name}/link

    # TPL - app layer
    if {$num_of_converters > 1} {
      for {set i 0} {$i < $num_of_converters} {incr i} {
        ad_connect ${ip_name}/dac_tpl_core/enable ${ip_name}/enable_slice_$i/Din
        ad_connect ${ip_name}/dac_tpl_core/dac_valid ${ip_name}/valid_slice_$i/Din

        ad_connect ${ip_name}/enable_slice_$i/Dout ${ip_name}/dac_enable_$i
        ad_connect ${ip_name}/valid_slice_$i/Dout ${ip_name}/dac_valid_$i
        ad_connect ${ip_name}/dac_data_$i ${ip_name}/data_concat[expr $i/32]/In[expr $i%32]

      }
      if {$num_of_converters > 32} {
        # wire all concatenators together
        for {set i 0} {$i < $num_of_converters} {incr i 32} {
          ad_connect ${ip_name}/data_concat[expr $i/32]/dout ${ip_name}/data_concat/In[expr $i/32]
        }
        ad_connect ${ip_name}/data_concat/dout ${ip_name}/dac_tpl_core/dac_ddata
      } else {
        ad_connect ${ip_name}/data_concat0/dout ${ip_name}/dac_tpl_core/dac_ddata
      }
    } else {
      ad_connect ${ip_name}/dac_data_0 ${ip_name}/dac_tpl_core/dac_ddata
      ad_connect ${ip_name}/dac_tpl_core/enable ${ip_name}/dac_enable_0
      ad_connect ${ip_name}/dac_tpl_core/dac_valid ${ip_name}/dac_valid_0
    }
    ad_connect ${ip_name}/dac_dunf ${ip_name}/dac_tpl_core/dac_dunf

  } resulttext resultoptions]

  dict unset resultoptions -level

  endgroup

  if {$result != 0} {
    undo -quiet
  }

  return -options $resultoptions $resulttext
}


#                                       L            M                 S                 N & NP
proc adi_tpl_jesd204_rx_create {ip_name num_of_lanes num_of_converters samples_per_frame sample_width {link_layer_bytes_per_beat 4} {dma_sample_width 16}} {


  if {$num_of_lanes < 1 || $num_of_lanes > 32} {
    return -code 1 "ERROR: Invalid number of JESD204B lanes. (Supported range 1-32)"
  }
  # F = (M * N * S) / (L * 8)
  set bytes_per_frame [expr ($num_of_converters * $sample_width * $samples_per_frame) / ($num_of_lanes * 8)];
  # one beat per lane must accommodate at least one frame
  set tpl_bytes_per_beat [expr max($bytes_per_frame, $link_layer_bytes_per_beat)]

  # datapath width = L * 8 * TPL_BYTES_PER_BEAT / (M * N)
  set samples_per_channel [expr ($num_of_lanes * 8 * $tpl_bytes_per_beat) / ($num_of_converters * $sample_width)];


  startgroup

  set result [catch {

    create_bd_cell -type hier $ip_name

    # Control interface
    create_bd_pin -dir I -type clk "${ip_name}/s_axi_aclk"
    create_bd_pin -dir I -type rst "${ip_name}/s_axi_aresetn"
    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 "${ip_name}/s_axi"

    # Interface to link layer
    create_bd_pin -dir I -type clk "${ip_name}/link_clk"
    #create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 "${ip_name}/link"
    create_bd_pin -dir I "${ip_name}/link_sof"
    create_bd_pin -dir I "${ip_name}/link_valid"
    create_bd_pin -dir I "${ip_name}/link_data"

    # Interface to application layer
    create_bd_pin -dir I "${ip_name}/adc_dovf"
    for {set i 0} {$i < $num_of_converters} {incr i} {
      create_bd_pin -dir O "${ip_name}/adc_enable_${i}"
      create_bd_pin -dir O "${ip_name}/adc_valid_${i}"
      create_bd_pin -dir O "${ip_name}/adc_data_${i}"
    }

    # Generic TPL core
    ad_ip_instance ad_ip_jesd204_tpl_adc "${ip_name}/adc_tpl_core" [list \
      NUM_LANES $num_of_lanes \
      NUM_CHANNELS $num_of_converters \
      SAMPLES_PER_FRAME $samples_per_frame \
      CONVERTER_RESOLUTION $sample_width \
      BITS_PER_SAMPLE $sample_width  \
      OCTETS_PER_BEAT $tpl_bytes_per_beat \
      DMA_BITS_PER_SAMPLE $dma_sample_width
     ]

    if {$num_of_converters > 1} {
      # Slicer cores
      for {set i 0} {$i < $num_of_converters} {incr i} {
        ad_ip_instance xlslice ${ip_name}/data_slice_$i [list \
          DIN_WIDTH [expr $dma_sample_width*$samples_per_channel*$num_of_converters] \
          DIN_FROM [expr $dma_sample_width*$samples_per_channel*($i+1)-1] \
          DIN_TO [expr $dma_sample_width*$samples_per_channel*$i] \
        ]

        ad_ip_instance xlslice "${ip_name}/enable_slice_${i}" [list \
          DIN_WIDTH $num_of_converters \
          DIN_FROM $i \
          DIN_TO $i \
        ]
        ad_ip_instance xlslice "${ip_name}/valid_slice_${i}" [list \
          DIN_WIDTH $num_of_converters \
          DIN_FROM $i \
          DIN_TO $i \
        ]
      }
    }

    # Create connections
    # TPL configuration interface
    ad_connect "${ip_name}/s_axi_aclk" "${ip_name}/adc_tpl_core/s_axi_aclk"
    ad_connect "${ip_name}/s_axi_aresetn" "${ip_name}/adc_tpl_core/s_axi_aresetn"
    ad_connect "${ip_name}/s_axi" "${ip_name}/adc_tpl_core/s_axi"

    # TPL - link layer
    ad_connect ${ip_name}/adc_tpl_core/link_clk ${ip_name}/link_clk
    #ad_connect ${ip_name}/adc_tpl_core/link ${ip_name}/link
    ad_connect ${ip_name}/adc_tpl_core/link_sof ${ip_name}/link_sof
    ad_connect ${ip_name}/adc_tpl_core/link_data ${ip_name}/link_data
    ad_connect ${ip_name}/adc_tpl_core/link_valid ${ip_name}/link_valid

    # TPL - app layer
    if {$num_of_converters > 1} {
      for {set i 0} {$i < $num_of_converters} {incr i} {
        ad_connect ${ip_name}/adc_tpl_core/adc_data ${ip_name}/data_slice_$i/Din
        ad_connect ${ip_name}/adc_tpl_core/enable ${ip_name}/enable_slice_$i/Din
        ad_connect ${ip_name}/adc_tpl_core/adc_valid ${ip_name}/valid_slice_$i/Din

        ad_connect ${ip_name}/data_slice_$i/Dout ${ip_name}/adc_data_$i
        ad_connect ${ip_name}/enable_slice_$i/Dout ${ip_name}/adc_enable_$i
        ad_connect ${ip_name}/valid_slice_$i/Dout ${ip_name}/adc_valid_$i

      }
    } else {
      ad_connect ${ip_name}/adc_tpl_core/adc_data ${ip_name}/adc_data_0
      ad_connect ${ip_name}/adc_tpl_core/enable ${ip_name}/adc_enable_0
      ad_connect ${ip_name}/adc_tpl_core/adc_valid ${ip_name}/adc_valid_0
    }
    ad_connect ${ip_name}/adc_dovf ${ip_name}/adc_tpl_core/adc_dovf

  } resulttext resultoptions]

  dict unset resultoptions -level

  endgroup

  if {$result != 0} {
    undo -quiet
  }

  return -options $resultoptions $resulttext
}

# Calculate Link Layer interface width towards Transport Layer
# TPL width must be set to an integer multiple of F
proc adi_jesd204_calc_tpl_width {link_datapath_width jesd_l jesd_m jesd_s jesd_np {tpl_datapath_width {}}} {

  set jesd_f [expr ($jesd_m*$jesd_s*$jesd_np)/(8*$jesd_l)]

  if {$tpl_datapath_width != ""} {
    set tpl_div [expr $tpl_datapath_width / $jesd_f]
    set tpl_mod [expr $tpl_datapath_width % $jesd_f]

    if {$tpl_div < 1 || $tpl_mod != 0 || (($tpl_div > 1) && ([expr $tpl_div % 2] != 0))} {
      return -code 1 "ERROR: Invalid custom TPL width. Must be a power of 2 multiple of F"
    } else {
      return $tpl_datapath_width
    }

  # For F=3,6,12 get first pow 2 multiple of F greater than link_datapath_width
  } elseif {$jesd_f % 3 == 0} {
    set np12_datapath_width $jesd_f
    while {$np12_datapath_width < $link_datapath_width} {
        set np12_datapath_width [expr 2*$np12_datapath_width]
    }
    return $np12_datapath_width
  } else {
    return [expr max($jesd_f,$link_datapath_width)]
  }

}


