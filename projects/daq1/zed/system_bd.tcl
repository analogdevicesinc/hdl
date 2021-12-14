set adc_fifo_address_width 10
set adc_data_width 64
set adc_dma_data_width 64

### Offload attributes
#set adc_offload_type 0
#set adc_offload_size [expr 1 * 256 * 1024]
#set dac_offload_type 0
#set dac_offload_size [expr 1 * 256 * 1024]
#set plddr_offload_axi_data_width 0
#set plddr_offload_axi_addr_width 0

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/daq1_bd.tcl

# System ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

#set sys_cstring "ADC_OFFLOAD_TYPE=$adc_offload_type\nDAC_OFFLOAD_TYPE=$dac_offload_type"
#sysid_gen_sys_init_file $sys_cstring
sysid_gen_sys_init_file
