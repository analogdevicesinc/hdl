
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl

set_property CONFIG.PSU__FPGA_PL2_ENABLE {1} $sys_ps8
set_property CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {200} $sys_ps8
set_property CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {3} $sys_ps8
set_property CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {2} $sys_ps8
ad_connect  sys_dma_clk sys_ps8/pl_clk2
source ../common/fmcomms5_bd.tcl

set_property CONFIG.DEVICE_TYPE 2 [get_bd_cells axi_ad9361_0]
set_property CONFIG.DEVICE_TYPE 2 [get_bd_cells axi_ad9361_1]

set_property -dict [list CONFIG.SIM_DEVICE {ULTRASCALE}] $clkdiv
