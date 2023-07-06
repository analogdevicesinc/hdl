###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# specify the spi reference clock frequency in MHz
set spi_clk_ref_frequency 166

# specify ADC resolution -- supported resolutions 16/18/20 bits
set ADC_RESOLUTION [get_env_param ADC_RESOLUTION 20]

# specify ADC sampling rate in samples/seconds

# NOTE: This rate can be set just in turbo mode -- if turbo mode is not used
# the max rate should be 1.6 MSPS
# supported sampling rates: 2/1.8/1/0.5 MSPS depending on the board
set ADC_SAMPLING_RATE [get_env_param ADC_SAMPLING_RATE 1800000]

source ../common/ad40xx_bd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set AD40XX_ADAQ400X_N [get_env_param AD40XX_ADAQ400X_N 1]
set sys_cstring "ad40xx: $AD40XX_ADAQ400X_N - adc_sampling_rate: $ADC_SAMPLING_RATE - adc_resolution: $ADC_RESOLUTION"
sysid_gen_sys_init_file $sys_cstring

