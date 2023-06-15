create_bd_intf_port -mode Master -vlnv analog.com:interface:i3c_controller_rtl:1.0 i3c_controller_0

source $ad_hdl_dir/library/i3c_controller/scripts/i3c_controller.tcl

set async_i3c_clk 0
set sim_device "7SERIES"
set clk_div 4

set hier_i3c_controller i3c_controller_0

i3c_controller_create $hier_i3c_controller $async_i3c_clk $clk_div $sim_device

ad_connect $hier_i3c_controller/m_i3c i3c_controller_0

ad_connect $sys_cpu_clk $hier_i3c_controller/clk
ad_connect sys_cpu_resetn $hier_i3c_controller/reset_n

ad_cpu_interconnect 0x44a00000 $hier_i3c_controller/axi_regmap

ad_cpu_interrupt "ps-12" "mb-12" /$hier_i3c_controller/irq

#ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
