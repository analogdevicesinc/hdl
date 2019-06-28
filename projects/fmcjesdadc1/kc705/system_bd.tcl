
source $ad_hdl_dir/projects/common/kc705/kc705_system_bd.tcl
source ../common/fmcjesdadc1_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter axi_ad9250_0_dma CONFIG.DMA_DATA_WIDTH_DEST 512
ad_ip_parameter axi_ad9250_0_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9250_1_dma CONFIG.DMA_DATA_WIDTH_DEST 512
ad_ip_parameter axi_ad9250_1_dma CONFIG.FIFO_SIZE 32

