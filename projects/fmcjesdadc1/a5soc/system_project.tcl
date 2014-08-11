
load_package flow

source ../../scripts/adi_env.tcl
project_new fmcjesdadc1_a5soc -overwrite

source $ad_hdl_dir/projects/common/a5soc/a5soc_system_assign.tcl

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/altera/ad_jesd_align.v
set_global_assignment -name VERILOG_FILE $ad_hdl_dir/library/common/altera/ad_xcvr_rx_rst.v
set_global_assignment -name VERILOG_FILE ../common/fmcjesdadc1_spi.v


# reference clock

set_location_assignment PIN_AG32  -to ref_clk
set_location_assignment PIN_AG33  -to "ref_clk(n)"
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to ref_clk
set_instance_assignment -name XCVR_REFCLK_PIN_TERMINATION AC_COUPLING -to ref_clk
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to ref_clk

# lane data

set_location_assignment PIN_AW37  -to rx_data[0]
set_location_assignment PIN_AW36  -to "rx_data[0](n)"
set_location_assignment PIN_AP39  -to rx_data[1]
set_location_assignment PIN_AP38  -to "rx_data[1](n)"
set_location_assignment PIN_AM39  -to rx_data[2]
set_location_assignment PIN_AM38  -to "rx_data[2](n)"
set_location_assignment PIN_AH39  -to rx_data[3]
set_location_assignment PIN_AH38  -to "rx_data[3](n)"
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[3]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[0]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[1]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[2]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[3]

# jesd signals

set_location_assignment PIN_A29   -to rx_sync
set_instance_assignment -name IO_STANDARD "2.5 V" -to rx_sync

set_location_assignment PIN_A28   -to rx_sysref
set_instance_assignment -name IO_STANDARD "2.5 V" -to rx_sysref

# spi

set_location_assignment PIN_C29   -to spi_csn
set_location_assignment PIN_B28   -to spi_clk
set_location_assignment PIN_C32   -to spi_sdio

set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_csn
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_sdio

execute_flow -compile

