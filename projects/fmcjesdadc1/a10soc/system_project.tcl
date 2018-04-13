
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_alt.tcl

adi_project_altera fmcjesdadc1_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl

# files

set_global_assignment -name VERILOG_FILE ../common/fmcjesdadc1_spi.v
set_global_assignment -name VERILOG_FILE ../../../library/common/ad_sysref_gen.v

# lane interface

set_location_assignment PIN_N29   -to ref_clk               ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_location_assignment PIN_N28   -to "ref_clk(n)"          ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_location_assignment PIN_T31   -to rx_data[0]            ; ## C06  FMC_HPC_DP0_M2C_P
set_location_assignment PIN_T30   -to "rx_data[0](n)"       ; ## C07  FMC_HPC_DP0_M2C_N
set_location_assignment PIN_R33   -to rx_data[1]            ; ## A02  FMC_HPC_DP1_M2C_P
set_location_assignment PIN_R32   -to "rx_data[1](n)"       ; ## A03  FMC_HPC_DP1_M2C_N
set_location_assignment PIN_P35   -to rx_data[2]            ; ## A06  FMC_HPC_DP2_M2C_P
set_location_assignment PIN_P34   -to "rx_data[2](n)"       ; ## A07  FMC_HPC_DP2_M2C_N
set_location_assignment PIN_P31   -to rx_data[3]            ; ## A10  FMC_HPC_DP3_M2C_P
set_location_assignment PIN_P30   -to "rx_data[3](n)"       ; ## A11  FMC_HPC_DP3_M2C_N
set_location_assignment PIN_P11   -to rx_sync               ; ## G36  FMCA_HPC_LA33_P
set_location_assignment PIN_R11   -to rx_sysref             ; ## G37  FMCA_HPC_LA33_N
set_location_assignment PIN_R8    -to spi_csn               ; ## G34  FMCA_HPC_LA31_N
set_location_assignment PIN_P8    -to spi_clk               ; ## G33  FMCA_HPC_LA31_P
set_location_assignment PIN_L8    -to spi_sdio              ; ## H37  FMCA_HPC_LA32_P

set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to ref_clk
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_data
set_instance_assignment -name IO_STANDARD LVDS -to ref_clk
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[0]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[1]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[2]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to rx_data[3]

execute_flow -compile

