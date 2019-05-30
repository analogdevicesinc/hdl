
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

# the DAC FIFO has a 500KSMP depth - 1 Mbyte
set dac_fifo_address_width 15

# by default PLDDR is used (1 Gbyte), this varible should be ignored
set adc_fifo_address_width 18

source ../common/fmcomms11_bd.tcl

