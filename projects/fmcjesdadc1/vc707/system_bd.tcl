source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source ../common/fmcjesdadc1_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter axi_ad9250_dma CONFIG.DMA_DATA_WIDTH_DEST 256
ad_ip_parameter axi_ad9250_dma CONFIG.FIFO_SIZE 32
