
# sys bram (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

if {$dac_data_width != $dac_dma_data_width} {
  return -code error [format "ERROR: util_dacfifo dac/dma widths must be the same!"]
}

create_bd_cell -type ip -vlnv analog.com:user:util_dacfifo:1.0 $dac_fifo_name
set_property CONFIG.DATA_WIDTH $dac_data_width [get_bd_cells $dac_fifo_name]
set_property CONFIG.ADDRESS_WIDTH $dac_fifo_address_width [get_bd_cells $dac_fifo_name]

