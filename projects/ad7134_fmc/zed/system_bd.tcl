
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

# specify ADC resolution -- the design supports 16/24/32 bit resolutions

set adc_resolution 24

# ADC number of channels

set adc_num_of_channels 8

source ../common/ad7134_bd.tcl

