
set dac_fifo_name avl_ad9172_fifo
set dac_fifo_address_width 20
set dac_data_width 256
set dac_dma_data_width 128

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_qsys.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_dacfifo_qsys.tcl
source ../common/ad9172_fmc_ebz_qsys.tcl

