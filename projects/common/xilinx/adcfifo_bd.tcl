###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# sys bram (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

proc ad_adcfifo_create {adc_fifo_name adc_data_width adc_dma_data_width adc_fifo_address_width} {

  ad_ip_instance util_adcfifo $adc_fifo_name
  ad_ip_parameter $adc_fifo_name CONFIG.ADC_DATA_WIDTH $adc_data_width
  ad_ip_parameter $adc_fifo_name CONFIG.DMA_DATA_WIDTH $adc_dma_data_width
  ad_ip_parameter $adc_fifo_name CONFIG.DMA_READY_ENABLE 1
  ad_ip_parameter $adc_fifo_name CONFIG.DMA_ADDRESS_WIDTH $adc_fifo_address_width

}

