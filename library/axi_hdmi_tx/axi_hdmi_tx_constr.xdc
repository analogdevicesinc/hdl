
set ip_hdmi_clk [get_clocks -of_objects [get_ports hdmi_clk]]
set ip_dma_clk  [get_clocks -of_objects [get_ports m_axis_mm2s_clk]]
set ip_cpu_clk  [get_clocks -of_objects [get_ports s_axi_aclk]]

set_false_path -from $ip_hdmi_clk -to $ip_cpu_clk
set_false_path -from $ip_hdmi_clk -to $ip_dma_clk
set_false_path -from $ip_dma_clk  -to $ip_hdmi_clk
set_false_path -from $ip_dma_clk  -to $ip_cpu_clk
set_false_path -from $ip_cpu_clk  -to $ip_hdmi_clk
set_false_path -from $ip_cpu_clk  -to $ip_dma_clk


