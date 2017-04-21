# CDC paths

set_false_path  -from [get_registers *avl_dacfifo_rd:i_rd|dac_mem_rd_address_g*]    -to [get_registers *avl_dacfifo_rd:i_rd|avl_mem_rd_address_m1*]
set_false_path  -from [get_registers *avl_dacfifo_rd:i_rd|avl_mem_wr_address_g*]    -to [get_registers *avl_dacfifo_rd:i_rd|dac_mem_wr_address_m1*]
set_false_path  -from [get_registers *avl_dacfifo_rd:i_rd|avl_xfer_req*]            -to [get_registers *avl_dacfifo_rd:i_rd|dac_avl_xfer_req_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|avl_mem_raddr_g*]         -to [get_registers *avl_dacfifo_wr:i_wr|dma_mem_raddr_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|avl_write_xfer_req*]      -to [get_registers *avl_dacfifo_wr:i_wr|dma_avl_xfer_req_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|dma_mem_read_control*]    -to [get_registers *avl_dacfifo_wr:i_wr|avl_mem_fetch_waddr_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|dma_last_beat_ack*]       -to [get_registers *avl_dacfifo_wr:i_wr|avl_last_beat_req_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|dma_xfer_req*]            -to [get_registers *avl_dacfifo_wr:i_wr|avl_dma_xfer_req_m1*]
set_false_path  -from [get_registers *avl_dacfifo_wr:i_wr|dma_mem_last_beats*]      -to [get_registers *avl_dacfifo_wr:i_wr|avl_last_beats_m1*]

