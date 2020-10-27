
## FIFO depth is 8Mb - 500k samples
set adc_fifo_address_width 17

## FIFO depth is 8Mb - 500k samples
set dac_fifo_address_width 16

source $ad_hdl_dir/projects/common/vc709/vc709_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
#source ../common/daq2_bd.tcl
