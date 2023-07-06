###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc ad_dacfifo_create {dac_fifo_name dac_data_width dac_dma_data_width dac_fifo_address_width} {

  if {$dac_data_width != $dac_dma_data_width} {
    return -code error [format "ERROR: util_dacfifo dac/dma widths must be the same!"]
  }

  add_instance $dac_fifo_name util_dacfifo
  set_instance_parameter_value $dac_fifo_name {ADDRESS_WIDTH} $dac_fifo_address_width
  set_instance_parameter_value $dac_fifo_name {DATA_WIDTH} $dac_data_width

}

