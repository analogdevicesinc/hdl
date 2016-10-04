
# sys bram (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

proc p_sys_dacfifo {p_name m_name data_width addr_width} {

  global ad_hdl_dir

  set p_instance [get_bd_cells $p_name]
  set c_instance [current_bd_instance .]

  current_bd_instance $p_instance

  set m_instance [create_bd_cell -type hier $m_name]
  current_bd_instance $m_instance

  create_bd_pin -dir I  dma_clk
  create_bd_pin -dir I  dma_rst
  create_bd_pin -dir O  dma_ready
  create_bd_pin -dir I  dma_valid
  create_bd_pin -dir I  -from [expr ($data_width-1)] -to 0 dma_data
  create_bd_pin -dir I  dma_xfer_req
  create_bd_pin -dir I  dma_xfer_last
  create_bd_pin -dir I  dac_fifo_bypass

  create_bd_pin -dir I  dac_clk
  create_bd_pin -dir I  dac_valid
  create_bd_pin -dir O  -from [expr ($data_width - 1)] -to 0 dac_data
  create_bd_pin -dir O dac_xfer_out

  set util_dacfifo [create_bd_cell -type ip -vlnv analog.com:user:util_dacfifo:1.0 util_dacfifo]
  set_property -dict [list CONFIG.DATA_WIDTH $data_width] $util_dacfifo
  set_property -dict [list CONFIG.ADDRESS_WIDTH $addr_width] $util_dacfifo

  ad_connect  dma_clk util_dacfifo/dma_clk
  ad_connect  dac_clk util_dacfifo/dac_clk
  ad_connect  dma_rst util_dacfifo/dma_rst
  ad_connect  dma_ready util_dacfifo/dma_ready
  ad_connect  dma_valid util_dacfifo/dma_valid
  ad_connect  dma_data util_dacfifo/dma_data
  ad_connect  dma_xfer_req util_dacfifo/dma_xfer_req
  ad_connect  dma_xfer_last util_dacfifo/dma_xfer_last
  ad_connect  dac_valid util_dacfifo/dac_valid
  ad_connect  dac_data util_dacfifo/dac_data
  ad_connect  dac_xfer_out util_dacfifo/dac_xfer_out
  ad_connect  dac_fifo_bypass util_dacfifo/dac_fifo_bypass

  current_bd_instance $c_instance
}

