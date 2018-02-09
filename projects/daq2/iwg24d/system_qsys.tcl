
set dac_fifo_name avl_ad9144_fifo
set dac_fifo_address_width 10
set dac_data_width 128
set dac_dma_data_width 128

source $ad_hdl_dir/projects/common/iwg24d/iwg24d_system_qsys.tcl
source $ad_hdl_dir/projects/common/iwg24d/iwg24d_fpga_ddr4_qsys.tcl
source ../common/daq2_qsys.tcl

