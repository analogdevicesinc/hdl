
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_alt.tcl

adi_project_altera fmcjesdadc1_a10gx

source $ad_hdl_dir/projects/common/a10gx/a10gx_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE ../common/fmcjesdadc1_spi.v
set_global_assignment -name VERILOG_FILE ../../../library/common/ad_sysref_gen.v

# lane interface

set_location_assignment PIN_AL8   -to ref_clk               ; ## D04  FMCA_GBTCLK0_M2C_P
set_location_assignment PIN_AL7   -to "ref_clk(n)"          ; ## D05  FMCA_GBTCLK0_M2C_N
set_location_assignment PIN_AW7   -to rx_data[0]            ; ## C06  FMCA_DP0_M2C_P
set_location_assignment PIN_AW8   -to "rx_data[0](n)"       ; ## C07  FMCA_DP0_M2C_N
set_location_assignment PIN_BA7   -to rx_data[1]            ; ## A02  FMCA_DP1_M2C_P
set_location_assignment PIN_BA8   -to "rx_data[1](n)"       ; ## A03  FMCA_DP1_M2C_N
set_location_assignment PIN_AY5   -to rx_data[2]            ; ## A06  FMCA_DP2_M2C_P
set_location_assignment PIN_AY6   -to "rx_data[2](n)"       ; ## A07  FMCA_DP2_M2C_N
set_location_assignment PIN_AV5   -to rx_data[3]            ; ## A10  FMCA_DP3_M2C_P
set_location_assignment PIN_AV6   -to "rx_data[3](n)"       ; ## A11  FMCA_DP3_M2C_N
set_location_assignment PIN_AY17  -to rx_sync               ; ## G36  FMCA_HPC_LA33_P
set_location_assignment PIN_AW17  -to rx_sysref             ; ## G37  FMCA_HPC_LA33_N
set_location_assignment PIN_BB18  -to spi_csn               ; ## G34  FMCA_HPC_LA31_N
set_location_assignment PIN_BB17  -to spi_clk               ; ## G33  FMCA_HPC_LA31_P
set_location_assignment PIN_AV20  -to spi_sdio              ; ## H37  FMCA_HPC_LA32_P

set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to ref_clk
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_data
set_instance_assignment -name IO_STANDARD LVDS -to ref_clk
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[0]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[1]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[2]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[3]

execute_flow -compile

