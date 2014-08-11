
set ip_device_wr_clk  [get_clocks -of_objects [get_ports fifo_wr_clk]]
set ip_dma_wr_clk     [get_clocks -of_objects [get_ports m_dest_axi_aclk]]
set ip_device_rd_clk  [get_clocks -of_objects [get_ports fifo_rd_clk]]
set ip_dma_rd_clk     [get_clocks -of_objects [get_ports m_src_axi_aclk]]
set ip_cpu_clk        [get_clocks -of_objects [get_ports s_axi_aclk]]

set_false_path -from $ip_cpu_clk        -to $ip_device_wr_clk
set_false_path -from $ip_cpu_clk        -to $ip_dma_wr_clk
set_false_path -from $ip_cpu_clk        -to $ip_device_rd_clk
set_false_path -from $ip_cpu_clk        -to $ip_dma_rd_clk
set_false_path -from $ip_device_wr_clk  -to $ip_cpu_clk
set_false_path -from $ip_device_wr_clk  -to $ip_dma_wr_clk
set_false_path -from $ip_device_wr_clk  -to $ip_device_rd_clk
set_false_path -from $ip_device_wr_clk  -to $ip_dma_rd_clk
set_false_path -from $ip_dma_wr_clk     -to $ip_device_wr_clk
set_false_path -from $ip_dma_wr_clk     -to $ip_cpu_clk
set_false_path -from $ip_dma_wr_clk     -to $ip_device_rd_clk
set_false_path -from $ip_dma_wr_clk     -to $ip_dma_rd_clk
set_false_path -from $ip_device_rd_clk  -to $ip_device_wr_clk
set_false_path -from $ip_device_rd_clk  -to $ip_dma_wr_clk
set_false_path -from $ip_device_rd_clk  -to $ip_cpu_clk
set_false_path -from $ip_device_rd_clk  -to $ip_dma_rd_clk
set_false_path -from $ip_dma_rd_clk     -to $ip_device_wr_clk
set_false_path -from $ip_dma_rd_clk     -to $ip_dma_wr_clk
set_false_path -from $ip_dma_rd_clk     -to $ip_device_rd_clk
set_false_path -from $ip_dma_rd_clk     -to $ip_cpu_clk



