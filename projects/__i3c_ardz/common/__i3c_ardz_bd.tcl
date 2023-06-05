create_bd_intf_port -mode Master -vlnv analog.com:interface:i3c_controller_rtl:1.0 i3c_controller_0

source $ad_hdl_dir/library/i3c_controller/scripts/i3c_controller.tcl

set async_i3c_clk 1

set hier_i3c_controller i3c_controller_0

i3c_controller_create $hier_i3c_controller $async_i3c_clk

ad_ip_instance axi_clkgen i3c_clkgen
ad_ip_parameter i3c_clkgen CONFIG.ENABLE_CLKOUT1 true
ad_ip_parameter i3c_clkgen CONFIG.CLK0_DIV 8
ad_ip_parameter i3c_clkgen CONFIG.CLK1_DIV 32
ad_ip_parameter i3c_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter i3c_clkgen CONFIG.VCO_MUL 8

ad_connect $sys_cpu_clk i3c_clkgen/clk
ad_connect i3c_clk_0 i3c_clkgen/clk_0
ad_connect i3c_clk_1 i3c_clkgen/clk_1

ad_connect $hier_i3c_controller/m_i3c i3c_controller_0

ad_connect $sys_cpu_clk $hier_i3c_controller/clk
ad_connect i3c_clk_0 $hier_i3c_controller/i3c_clk_0
ad_connect i3c_clk_1 $hier_i3c_controller/i3c_clk_1
ad_connect sys_cpu_resetn $hier_i3c_controller/reset_n

ad_cpu_interconnect 0x44a00000 $hier_i3c_controller/axi_regmap
ad_cpu_interconnect 0x44a70000 i3c_clkgen

ad_cpu_interrupt "ps-12" "mb-12" /$hier_i3c_controller/irq

#ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
