
set_clock_groups -asynchronous -group {s_axi_aclk} \
  -group {fifo_wr_clk} -group {fifo_rd_clk} \
  -group {m_dest_axi_aclk} -group {m_src_axi_aclk}

