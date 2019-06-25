
set adc_fifo_name axi_ad9208_fifo
set adc_fifo_address_width 16
set adc_data_width 256
set adc_dma_data_width 128

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source ../common/ad9208_bd.tcl

ad_ip_parameter axi_ad9208_jesd/rx CONFIG.SYSREF_IOB false
