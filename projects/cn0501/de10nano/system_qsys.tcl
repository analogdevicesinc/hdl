
set dac_fifo_address_width 10

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_qsys.tcl
source ../common/cn0501_qsys.tcl

set_instance_parameter_value sys_spi {clockPolarity} {0}
set_instance_parameter_value sys_spi {targetClockRate} {1000000.0}
