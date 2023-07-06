###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc ad_adcfifo_create {adc_fifo_name adc_data_width dma_data_width adc_fifo_address_width} {

  if {$adc_data_width != $dma_data_width} {
    return -code error [format "ERROR: util_adcfifo adc/dma widths must be the same!"]
  }

  add_instance $adc_fifo_name util_adcfifo
  set_instance_parameter_value $adc_fifo_name {DMA_ADDRESS_WIDTH} $adc_fifo_address_width
  set_instance_parameter_value $adc_fifo_name {ADC_DATA_WIDTH} $adc_data_width
  set_instance_parameter_value $adc_fifo_name {DMA_DATA_WIDTH} $dma_data_width

}

