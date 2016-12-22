
load_package flow

source ../../scripts/adi_env.tcl
project_new fmcjesdadc1_a5gt -overwrite

source "../../common/a5gt/a5gt_system_assign.tcl"

set_global_assignment -name VERILOG_FILE ../common/fmcjesdadc1_spi.v
set_global_assignment -name VERILOG_FILE ../../../library/common/ad_sysref_gen.v
set_global_assignment -name VERILOG_FILE system_top.v
set_global_assignment -name QSYS_FILE system_bd.qsys

set_global_assignment -name SDC_FILE system_constr.sdc
set_global_assignment -name TOP_LEVEL_ENTITY system_top

# reference clock

set_location_assignment PIN_AB9   -to ref_clk
set_location_assignment PIN_AB8   -to "ref_clk(n)"
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to ref_clk
set_instance_assignment -name XCVR_REFCLK_PIN_TERMINATION AC_COUPLING -to ref_clk
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to ref_clk

# lane data

set_location_assignment PIN_AE1   -to rx_data[0]
set_location_assignment PIN_AE2   -to "rx_data[0](n)"
set_location_assignment PIN_AA1   -to rx_data[1]
set_location_assignment PIN_AA2   -to "rx_data[1](n)"
set_location_assignment PIN_U1    -to rx_data[2]
set_location_assignment PIN_U2    -to "rx_data[2](n)"
set_location_assignment PIN_R1    -to rx_data[3]
set_location_assignment PIN_R2    -to "rx_data[3](n)"
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[3]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[0]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[1]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[2]
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to rx_data[3]

# jesd signals

set_location_assignment PIN_AD25  -to rx_sync
set_instance_assignment -name IO_STANDARD "2.5 V" -to rx_sync

set_location_assignment PIN_AC24  -to rx_sysref
set_instance_assignment -name IO_STANDARD "2.5 V" -to rx_sysref

# spi

set_location_assignment PIN_AG27  -to spi_csn
set_location_assignment PIN_AH27  -to spi_clk
set_location_assignment PIN_AD24  -to spi_sdio

set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_csn
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to spi_sdio

# disable auto-pack

set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
set_global_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF
set_global_assignment -name QII_AUTO_PACKED_REGISTERS OFF

execute_flow -compile

