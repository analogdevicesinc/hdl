
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

# specify the spi reference clock frequency in MHz
set spi_clk_ref_frequency 160

# specify ADC resolution -- supported resolutions 16/18/20 bits
set adc_resolution 20

# specify ADC sampling rate in samples/seconds

# NOTE: This rate can be set just in turbo mode -- if turbo mode is not used
# the max rate should be 1.6 MSPS
set adc_sampling_rate 1800000

source ../common/ad40xx_bd.tcl

