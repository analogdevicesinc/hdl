source $ad_hdl_dir/projects/common/coraz7s/coraz7s_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

adi_project_files cn0561_coraz7s [list \
  "$ad_hdl_dir/library/common/ad_edge_detect.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
]

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

#the eval board requires an extra i2c channel for the coraz7s project
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_0_io

ad_ip_parameter sys_ps7 CONFIG.PCW_I2C0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C0_I2C0_IO EMIO

ad_connect iic_0_io sys_ps7/IIC_0

# specify ADC resolution -- the design supports 16/24/32 bit resolutions

set adc_resolution 24

# ADC number of channels

set adc_num_of_channels 4

source ../common/cn0561_bd.tcl

