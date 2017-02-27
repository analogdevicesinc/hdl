
# sys bram (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

create_bd_cell -type ip -vlnv analog.com:user:util_adcfifo:1.0 $adc_fifo_name
set_property CONFIG.ADC_DATA_WIDTH $adc_data_width [get_bd_cells $adc_fifo_name]
set_property CONFIG.DMA_DATA_WIDTH $adc_dma_data_width [get_bd_cells $adc_fifo_name]
set_property CONFIG.DMA_READY_ENABLE {1} [get_bd_cells $adc_fifo_name]
set_property CONFIG.DMA_ADDRESS_WIDTH $adc_fifo_address_width [get_bd_cells $adc_fifo_name]


