
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_intel.tcl

adi_project adin1100_mii_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl

# files
set_global_assignment -name VERILOG_FILE ../../../library/common/ad_iobuf.v

# Note: This projects requires a hardware rework to function correctly.
# The rework connects FMC header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required (D08-FMC):
#
#  R610: DNI -> R0
#  R611: DNI -> R0
#  R612: R0 -> DNI
#  R613: R0 -> DNI
#  R620: DNI -> R0
#  R632: DNI -> R0
#  R621: R0 -> DNI
#  R633: R0 -> DNI

set_location_assignment PIN_E12    -to  mii_rx_clk              ; ## D08  FMCA_HPC_LA01_CC_P
set_location_assignment PIN_G7     -to  mii_rx_er               ; ## C22  FMCA_HPC_LA18_CC_P
set_location_assignment PIN_C3     -to  mii_rx_dv               ; ## G21  FMCA_HPC_LA20_P
set_location_assignment PIN_D3     -to  mii_rxd[0]              ; ## H26  FMCA_HPC_LA21_N
set_location_assignment PIN_G2     -to  mii_rxd[1]              ; ## D27  FMCA_HPC_LA26_N
set_location_assignment PIN_E2     -to  mii_rxd[2]              ; ## G27  FMCA_HPC_LA25_P
set_location_assignment PIN_H2     -to  mii_rxd[3]              ; ## C27  FMCA_HPC_LA27_N

set_location_assignment PIN_G14    -to  mii_tx_clk              ; ## G06  FMCA_HPC_LA00_CC_P
set_location_assignment PIN_J9     -to  mii_tx_en               ; ## C18  FMCA_HPC_LA14_P
set_location_assignment PIN_J10    -to  mii_tx_er               ; ## C19  FMCA_HPC_LA14_N
set_location_assignment PIN_B12    -to  mii_txd[0]              ; ## G13  FMCA_HPC_LA08_N
set_location_assignment PIN_F14    -to  mii_txd[1]              ; ## D12  FMCA_HPC_LA05_N
set_location_assignment PIN_B11    -to  mii_txd[2]              ; ## G12  FMCA_HPC_LA08_P
set_location_assignment PIN_F13    -to  mii_txd[3]              ; ## D11  FMCA_HPC_LA05_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_rx_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_rx_dv
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_rxd
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_tx_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_tx_en
set_instance_assignment -name IO_STANDARD "1.8 V" -to mii_txd

set_location_assignment PIN_D6     -to  mdio_fmc                ; ## G18  FMCA_HPC_LA16_P
set_location_assignment PIN_E6     -to  mdc_fmc                 ; ## G19  FMCA_HPC_LA16_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to mdio_fmc
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to mdio_fmc
set_instance_assignment -name IO_STANDARD "1.8 V" -to mdc_fmc

set_location_assignment PIN_H7     -to  link_st                 ; ## C23  FMCA_HPC_LA18_CC_N
set_location_assignment PIN_D4     -to  reset_n                 ; ## H19  FMCA_HPC_LA15_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to reset_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to link_st

execute_flow -compile

