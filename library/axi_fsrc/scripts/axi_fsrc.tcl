###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## The FSRC cores carry the whole link on one converter major bus: converter i
## occupies data[i*data_width +: data_width]. The transport layer cores, the
## gearboxes and cpack/upack all speak one port per converter instead, so the
## two have to be stitched together. These helpers do that stitching from the
## converter count alone, inside a hierarchy, so the block design sees a single
## block with one pin per converter and no hand written concatenation.

## Fan the per converter pins of a hierarchy into the core's flat bus and back.
#
#  \param[name] - hierarchy name
#  \param[core] - FSRC core instance inside the hierarchy
#  \param[num_conv] - number of converters
#  \param[data_width] - beat width of a single converter
#
proc adi_fsrc_data_fanout {name core num_conv data_width} {

  for {set i 0} {$i < $num_conv} {incr i} {
    create_bd_pin -dir I -from [expr $data_width - 1] -to 0 ${name}/data_in_$i
    create_bd_pin -dir O -from [expr $data_width - 1] -to 0 ${name}/data_out_$i
  }

  if {$num_conv == 1} {
    ad_connect ${name}/data_in_0 ${core}/data_in
    ad_connect ${core}/data_out ${name}/data_out_0
    return
  }

  ad_ip_instance ilconcat ${name}/data_concat [list \
    NUM_PORTS $num_conv \
  ]
  ad_connect ${name}/data_concat/dout ${core}/data_in

  for {set i 0} {$i < $num_conv} {incr i} {
    ad_connect ${name}/data_in_$i ${name}/data_concat/In$i

    ad_ip_instance ilslice ${name}/data_slice_$i [list \
      DIN_WIDTH [expr $num_conv * $data_width] \
      DIN_FROM  [expr ($i + 1) * $data_width - 1] \
      DIN_TO    [expr $i * $data_width] \
    ]
    ad_connect ${core}/data_out ${name}/data_slice_$i/Din
    ad_connect ${name}/data_slice_$i/Dout ${name}/data_out_$i
  }
}

## One RX FSRC block. It sits right after the transport layer, at the link beat
#  width, because the sentinel is defined at link sample positions. NUM_CONV
#  keeps one remover per converter inside the core, so compaction never moves a
#  sample across a channel boundary.
#
#  The core's reset comes in active high and the only source with the semantics
#  it needs - held across a DMA transfer boundary, so no partial beat survives
#  into the next burst - is util_pack_cdc's active low device_resetn, hence the
#  inverter inside the block.
#
#  \param[name] - hierarchy name
#  \param[clk] - link clock net
#  \param[device_resetn] - active low reset of the pack domain
#  \param[num_conv] - number of converters
#  \param[data_width] - beat width of a single converter
#  \param[np] - sample width
#
proc adi_fsrc_rx_create {name clk device_resetn num_conv data_width np} {

  create_bd_cell -type hier $name

  create_bd_pin -dir I -type clk ${name}/clk
  create_bd_pin -dir I -type rst ${name}/device_resetn
  create_bd_pin -dir I ${name}/data_in_valid
  create_bd_pin -dir O ${name}/data_out_valid

  create_bd_pin -dir I -type clk ${name}/s_axi_aclk
  create_bd_pin -dir I -type rst ${name}/s_axi_aresetn
  create_bd_intf_pin -mode Slave \
    -vlnv xilinx.com:interface:aximm_rtl:1.0 ${name}/s_axi

  ad_ip_instance axi_fsrc_rx ${name}/axi_fsrc_rx [list \
    DATA_WIDTH $data_width \
    NP $np \
    NUM_CONV $num_conv \
  ]

  ad_ip_instance ilvector_logic ${name}/rst [list \
    C_SIZE 1 \
    C_OPERATION {not} \
  ]

  ad_connect ${name}/clk ${name}/axi_fsrc_rx/clk
  ad_connect ${name}/device_resetn ${name}/rst/Op1
  ad_connect ${name}/rst/Res ${name}/axi_fsrc_rx/reset
  ad_connect ${name}/data_in_valid ${name}/axi_fsrc_rx/data_in_valid
  ad_connect ${name}/axi_fsrc_rx/data_out_valid ${name}/data_out_valid

  ad_connect ${name}/s_axi_aclk ${name}/axi_fsrc_rx/s_axi_aclk
  ad_connect ${name}/s_axi_aresetn ${name}/axi_fsrc_rx/s_axi_aresetn
  ad_connect ${name}/s_axi ${name}/axi_fsrc_rx/s_axi

  adi_fsrc_data_fanout $name ${name}/axi_fsrc_rx $num_conv $data_width

  ad_connect $clk ${name}/clk
  ad_connect $device_resetn ${name}/device_resetn
}

## One TX FSRC block. It is last in the chain, again at the link beat width,
#  because the holes have to land on link sample positions. It is a real
#  ready/valid consumer, so whatever feeds it must be able to stall.
#
#  The reset is not connected here. The core carries the accumulator phase and a
#  partially consumed beat, so it has to come out of reset together with upack
#  and the unpack FIFO ahead of it, and that shared reset does not exist yet at
#  the point the block design calls this.
#
#  \param[name] - hierarchy name
#  \param[clk] - link clock net
#  \param[num_conv] - number of converters
#  \param[data_width] - beat width of a single converter
#  \param[np] - sample width
#  \param[accum_width] - phase accumulator width
#
proc adi_fsrc_tx_create {name clk num_conv data_width np accum_width} {

  create_bd_cell -type hier $name

  create_bd_pin -dir I -type clk ${name}/clk
  create_bd_pin -dir I -type rst ${name}/reset
  create_bd_pin -dir I ${name}/tx_data_start
  create_bd_pin -dir I ${name}/data_in_valid
  create_bd_pin -dir O ${name}/data_in_ready
  create_bd_pin -dir O ${name}/data_out_valid
  create_bd_pin -dir I ${name}/data_out_ready

  create_bd_pin -dir I -type clk ${name}/s_axi_aclk
  create_bd_pin -dir I -type rst ${name}/s_axi_aresetn
  create_bd_intf_pin -mode Slave \
    -vlnv xilinx.com:interface:aximm_rtl:1.0 ${name}/s_axi

  ad_ip_instance axi_fsrc_tx ${name}/axi_fsrc_tx [list \
    DATA_WIDTH $data_width \
    NP $np \
    MAX_CONV $num_conv \
    ACCUM_WIDTH $accum_width \
  ]

  ad_connect ${name}/clk ${name}/axi_fsrc_tx/clk
  ad_connect ${name}/reset ${name}/axi_fsrc_tx/reset
  ad_connect ${name}/tx_data_start ${name}/axi_fsrc_tx/tx_data_start
  ad_connect ${name}/data_in_valid ${name}/axi_fsrc_tx/data_in_valid
  ad_connect ${name}/axi_fsrc_tx/data_in_ready ${name}/data_in_ready
  ad_connect ${name}/axi_fsrc_tx/data_out_valid ${name}/data_out_valid
  ad_connect ${name}/data_out_ready ${name}/axi_fsrc_tx/data_out_ready

  ad_connect ${name}/s_axi_aclk ${name}/axi_fsrc_tx/s_axi_aclk
  ad_connect ${name}/s_axi_aresetn ${name}/axi_fsrc_tx/s_axi_aresetn
  ad_connect ${name}/s_axi ${name}/axi_fsrc_tx/s_axi

  adi_fsrc_data_fanout $name ${name}/axi_fsrc_tx $num_conv $data_width

  ad_connect $clk ${name}/clk
}
