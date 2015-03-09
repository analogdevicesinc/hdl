
# sys bram (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

proc p_sys_dmafifo {p_name m_name adc_data_width dma_addr_width} {

  global ad_hdl_dir

  set p_instance [get_bd_cells $p_name]
  set c_instance [current_bd_instance .]

  current_bd_instance $p_instance

  set m_instance [create_bd_cell -type hier $m_name]
  current_bd_instance $m_instance

  create_bd_pin -dir I adc_rst
  create_bd_pin -dir I -type clk adc_clk
  create_bd_pin -dir I adc_wr
  create_bd_pin -dir I -from [expr ($adc_data_width-1)] -to 0 adc_wdata
  create_bd_pin -dir O adc_wovf

  create_bd_pin -dir I -type clk dma_clk
  create_bd_pin -dir O dma_wr
  create_bd_pin -dir O -from 63 -to 0 dma_wdata
  create_bd_pin -dir I dma_wready
  create_bd_pin -dir I dma_xfer_req
  create_bd_pin -dir O -from 3 -to 0 dma_xfer_status

  set axi_fifo2f [create_bd_cell -type ip -vlnv analog.com:user:axi_fifo2f:1.0 axi_fifo2f]
  set_property -dict [list CONFIG.ADC_DATA_WIDTH $adc_data_width] $axi_fifo2f
  set_property -dict [list CONFIG.DMA_DATA_WIDTH {64}] $axi_fifo2f
  set_property -dict [list CONFIG.DMA_READY_ENABLE {1}] $axi_fifo2f
  set_property -dict [list CONFIG.DMA_ADDR_WIDTH $dma_addr_width] $axi_fifo2f

  ad_connect  adc_rst axi_fifo2f/adc_rst
  ad_connect  adc_clk axi_fifo2f/adc_clk
  ad_connect  adc_wr axi_fifo2f/adc_wr
  ad_connect  adc_wdata axi_fifo2f/adc_wdata
  ad_connect  adc_wovf axi_fifo2f/adc_wovf
  ad_connect  dma_clk axi_fifo2f/dma_clk
  ad_connect  dma_wr axi_fifo2f/dma_wr
  ad_connect  dma_wdata axi_fifo2f/dma_wdata
  ad_connect  dma_wready axi_fifo2f/dma_wready
  ad_connect  dma_xfer_req axi_fifo2f/dma_xfer_req
  ad_connect  dma_xfer_status axi_fifo2f/dma_xfer_status

  current_bd_instance $c_instance
}

