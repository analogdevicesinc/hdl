
# Configurable parameters

set NUM_OF_CHANNELS 4
set NUM_OF_LANES 4
set SAMPLE_RATE_MHZ 1000.0
set ADC_RESOLUTION 8

# Auto-computed parameters

set CHANNEL_DATA_WIDTH [expr 32 * $NUM_OF_LANES / $NUM_OF_CHANNELS]
set ADC_DATA_WIDTH [expr $CHANNEL_DATA_WIDTH * $NUM_OF_CHANNELS]
set DMA_DATA_WIDTH [expr $ADC_DATA_WIDTH < 128 ? $ADC_DATA_WIDTH : 128]
set SAMPLE_WIDTH [expr $ADC_RESOLUTION > 8 ? 16 : 8]


set adc_fifo_name axi_ad9694_fifo
set adc_fifo_address_width 16
set adc_data_width $ADC_DATA_WIDTH
set adc_dma_data_width $DMA_DATA_WIDTH

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_adcfifo_bd.tcl
source ../common/ad9694_500ebz_bd.tcl

create_bd_port -dir O adc_capture_start

ad_connect axi_ad9694_fifo/adc_capture_start adc_capture_start
