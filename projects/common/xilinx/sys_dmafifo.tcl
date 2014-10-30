
# sys bram (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

proc p_sys_dmafifo {p_name m_name m_width} {

  global ad_hdl_dir

  set p_instance [get_bd_cells $p_name]
  set c_instance [current_bd_instance .]

  current_bd_instance $p_instance

  set m_instance [create_bd_cell -type hier $m_name]
  current_bd_instance $m_instance

  create_bd_pin -dir I -type clk axi_clk
  create_bd_pin -dir I axi_xfer_req
  create_bd_pin -dir O -from 4 -to 0 axi_xfer_status

  create_bd_pin -dir I adc_rst
  create_bd_pin -dir I -type clk adc_clk
  create_bd_pin -dir I adc_wr
  create_bd_pin -dir O adc_wovf
  create_bd_pin -dir I -from [expr ($m_width-1)] -to 0 adc_wdata

  create_bd_pin -dir I dma_rstn
  create_bd_pin -dir I -type clk dma_clk
  create_bd_pin -dir O dma_wvalid
  create_bd_pin -dir I dma_wready
  create_bd_pin -dir I dma_wovf
  create_bd_pin -dir O -from 63 -to 0 dma_wdata

  set axi_fifo2f [create_bd_cell -type ip -vlnv analog.com:user:axi_fifo2f:1.0 axi_fifo2f]
  set_property -dict [list CONFIG.ADC_DATA_WIDTH $m_width] $axi_fifo2f
  set_property -dict [list CONFIG.DMA_DATA_WIDTH {64}] $axi_fifo2f
  set_property -dict [list CONFIG.DMA_READY_ENABLE {1}] $axi_fifo2f
  set_property -dict [list CONFIG.MEM_ADDRLIMIT {0x00001000}] $axi_fifo2f

  set dma_fifo [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 dma_fifo]
  set_property -dict [list CONFIG.INTERFACE_TYPE {Native}] $dma_fifo
  set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}] $dma_fifo
  set_property -dict [list CONFIG.asymmetric_port_width {true}] $dma_fifo
  set_property -dict [list CONFIG.Input_Data_Width $m_width] $dma_fifo
  set_property -dict [list CONFIG.Input_Depth {64}] $dma_fifo
  set_property -dict [list CONFIG.Output_Data_Width {64}] $dma_fifo
  set_property -dict [list CONFIG.Overflow_Flag {true}] $dma_fifo

  connect_bd_net -net adc_clk         [get_bd_pins adc_clk]            
  connect_bd_net -net dma_clk         [get_bd_pins dma_clk]            
  connect_bd_net -net adc_clk         [get_bd_pins dma_fifo/wr_clk]
  connect_bd_net -net dma_clk         [get_bd_pins dma_fifo/rd_clk]
  connect_bd_net -net adc_clk         [get_bd_pins axi_fifo2f/adc_clk]  
  connect_bd_net -net dma_clk         [get_bd_pins axi_fifo2f/dma_clk]  

  connect_bd_net -net adc_rst         [get_bd_pins adc_rst]                 [get_bd_pins axi_fifo2f/adc_rst]
  connect_bd_net -net dma_rstn        [get_bd_pins dma_rstn]                [get_bd_pins axi_fifo2f/dma_rstn]
  connect_bd_net -net adc_wr          [get_bd_pins adc_wr]                  [get_bd_pins axi_fifo2f/adc_wr]
  connect_bd_net -net adc_wdata       [get_bd_pins adc_wdata]               [get_bd_pins axi_fifo2f/adc_wdata]
  connect_bd_net -net adc_wovf        [get_bd_pins adc_wovf]                [get_bd_pins axi_fifo2f/adc_wovf]
  connect_bd_net -net dma_wvalid      [get_bd_pins dma_wvalid]              [get_bd_pins axi_fifo2f/dma_wr]
  connect_bd_net -net dma_wdata       [get_bd_pins dma_wdata]               [get_bd_pins axi_fifo2f/dma_wdata]
  connect_bd_net -net dma_wready      [get_bd_pins dma_wready]              [get_bd_pins axi_fifo2f/dma_wready]
  connect_bd_net -net dma_wovf        [get_bd_pins dma_wovf]                [get_bd_pins axi_fifo2f/dma_wovf]
  connect_bd_net -net axi_xfer_req    [get_bd_pins axi_xfer_req]            [get_bd_pins axi_fifo2f/dma_xfer_req]
  connect_bd_net -net axi_xfer_status [get_bd_pins axi_xfer_status]         [get_bd_pins axi_fifo2f/dma_xfer_status]
  connect_bd_net -net dma_fifo_rst    [get_bd_pins axi_fifo2f/fifo_rst]     [get_bd_pins dma_fifo/rst]
  connect_bd_net -net dma_fifo_wr     [get_bd_pins axi_fifo2f/fifo_wr]      [get_bd_pins dma_fifo/wr_en]
  connect_bd_net -net dma_fifo_wdata  [get_bd_pins axi_fifo2f/fifo_wdata]   [get_bd_pins dma_fifo/din]
  connect_bd_net -net dma_fifo_wfull  [get_bd_pins axi_fifo2f/fifo_wfull]   [get_bd_pins dma_fifo/full]
  connect_bd_net -net dma_fifo_wovf   [get_bd_pins axi_fifo2f/fifo_wovf]    [get_bd_pins dma_fifo/overflow]
  connect_bd_net -net dma_fifo_rd     [get_bd_pins axi_fifo2f/fifo_rd]      [get_bd_pins dma_fifo/rd_en]
  connect_bd_net -net dma_fifo_rdata  [get_bd_pins axi_fifo2f/fifo_rdata]   [get_bd_pins dma_fifo/dout]
  connect_bd_net -net dma_fifo_rempty [get_bd_pins axi_fifo2f/fifo_rempty]  [get_bd_pins dma_fifo/empty]

  current_bd_instance $c_instance
}

