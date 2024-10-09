###############################################################################
## Copyright (C) 2020-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/coraz7s/coraz7s_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# specify the spi reference clock frequency in MHz
set spi_clk_ref_frequency 160

# specify ADC resolution -- supported resolutions 16 bits
set adc_resolution 16

# specify ADC sampling rate in samples/seconds
set adc_sampling_rate 1000000

adi_project_files ad469x_fmc_coraz7s [list \
	"../../../library/common/ad_edge_detect.v" \
	"../../../library/util_cdc/sync_bits.v" \
]

source ../common/ad469x_bd.tcl

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 ad469x_iic

ad_ip_instance axi_iic axi_ad469x_iic
ad_connect ad469x_iic axi_ad469x_iic/iic

ad_cpu_interconnect 0x44a40000 axi_ad469x_iic

ad_cpu_interrupt "ps-11" "mb-11" axi_ad469x_iic/iic2intc_irpt

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "SPI_CLK_FREQ=$spi_clk_ref_frequency\
ADC_RESOLUTION=$adc_resolution\
SAMPLING_RATE=$adc_sampling_rate"

sysid_gen_sys_init_file $sys_cstring
