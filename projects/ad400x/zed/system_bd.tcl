
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

# specify ADC resolution -- supported resolutions 16/18/20 bits
set adc_resolution 20

# specify ADC sampling rate in samples/seconds -- default is 1.8 MSPS
set adc_sampling_rate 1800000

source ../common/ad400x_bd.tcl

