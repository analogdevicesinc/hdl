###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# sys bram (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.
proc ad_dacfifo_create {dac_fifo_name dac_data_width dac_dma_data_width dac_fifo_address_width} {

  if {$dac_data_width != $dac_dma_data_width} {
    return -code error [format "ERROR: util_dacfifo dac/dma widths must be the same!"]
  }

  ad_ip_instance util_dacfifo $dac_fifo_name
  ad_ip_parameter $dac_fifo_name CONFIG.DATA_WIDTH $dac_data_width
  ad_ip_parameter $dac_fifo_name CONFIG.ADDRESS_WIDTH $dac_fifo_address_width

}
