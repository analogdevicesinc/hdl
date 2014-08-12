
set ip_spdif_clk  [get_clocks -of_objects [get_ports spdif_data_clk]]
set ip_dma_clk    [get_clocks -of_objects [get_ports s_axis_aclk]]
set ip_ps7_clk    [get_clocks -of_objects [get_ports DMA_REQ_ACLK]]
set ip_cpu_clk    [get_clocks -of_objects [get_ports S_AXI_ACLK]]

set_false_path -from $ip_spdif_clk  -to $ip_cpu_clk
set_false_path -from $ip_spdif_clk  -to $ip_dma_clk
set_false_path -from $ip_spdif_clk  -to $ip_ps7_clk
set_false_path -from $ip_dma_clk    -to $ip_spdif_clk
set_false_path -from $ip_dma_clk    -to $ip_cpu_clk
set_false_path -from $ip_dma_clk    -to $ip_ps7_clk
set_false_path -from $ip_cpu_clk    -to $ip_spdif_clk
set_false_path -from $ip_cpu_clk    -to $ip_dma_clk
set_false_path -from $ip_cpu_clk    -to $ip_ps7_clk
set_false_path -from $ip_ps7_clk    -to $ip_spdif_clk
set_false_path -from $ip_ps7_clk    -to $ip_cpu_clk
set_false_path -from $ip_ps7_clk    -to $ip_dma_clk


