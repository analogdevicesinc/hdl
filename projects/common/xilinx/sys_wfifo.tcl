
# fifo and controller (write side)

proc p_sys_wfifo {p_name m_name adc_data_width dma_data_width} {

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
  create_bd_pin -dir O -from [expr ($dma_data_width-1)] -to 0 dma_wdata
  create_bd_pin -dir I dma_wovf

  set wfifo_ctl [create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 wfifo_ctl]
  set_property -dict [list CONFIG.ADC_DATA_WIDTH $adc_data_width] $wfifo_ctl
  set_property -dict [list CONFIG.DMA_DATA_WIDTH $dma_data_width] $wfifo_ctl

  set wfifo_mem [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 wfifo_mem]
  set_property -dict [list CONFIG.INTERFACE_TYPE {Native}] $wfifo_mem
  set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}] $wfifo_mem
  set_property -dict [list CONFIG.Input_Data_Width $adc_data_width] $wfifo_mem
  set_property -dict [list CONFIG.Input_Depth {64}] $wfifo_mem
  set_property -dict [list CONFIG.Output_Data_Width $dma_data_width] $wfifo_mem
  set_property -dict [list CONFIG.Overflow_Flag {true}] $wfifo_mem

  connect_bd_net -net adc_rst                 [get_bd_pins adc_rst]
  connect_bd_net -net adc_clk                 [get_bd_pins adc_clk]
  connect_bd_net -net dma_clk                 [get_bd_pins dma_clk]
  connect_bd_net -net adc_rst                 [get_bd_pins wfifo_ctl/adc_rst]
  connect_bd_net -net adc_clk                 [get_bd_pins wfifo_ctl/adc_clk]
  connect_bd_net -net dma_clk                 [get_bd_pins wfifo_ctl/dma_clk]
  connect_bd_net -net adc_clk                 [get_bd_pins wfifo_mem/wr_clk]
  connect_bd_net -net dma_clk                 [get_bd_pins wfifo_mem/rd_clk]

  connect_bd_net -net adc_wr                  [get_bd_pins adc_wr]                    [get_bd_pins wfifo_ctl/adc_wr]
  connect_bd_net -net adc_wdata               [get_bd_pins adc_wdata]                 [get_bd_pins wfifo_ctl/adc_wdata]
  connect_bd_net -net adc_wovf                [get_bd_pins adc_wovf]                  [get_bd_pins wfifo_ctl/adc_wovf]
  connect_bd_net -net dma_wr                  [get_bd_pins dma_wr]                    [get_bd_pins wfifo_ctl/dma_wr]
  connect_bd_net -net dma_wdata               [get_bd_pins dma_wdata]                 [get_bd_pins wfifo_ctl/dma_wdata]
  connect_bd_net -net dma_wovf                [get_bd_pins dma_wovf]                  [get_bd_pins wfifo_ctl/dma_wovf]

  connect_bd_net -net wfifo_ctl_fifo_rst      [get_bd_pins wfifo_ctl/fifo_rst]        [get_bd_pins wfifo_mem/rst]
  connect_bd_net -net wfifo_ctl_fifo_wr       [get_bd_pins wfifo_ctl/fifo_wr]         [get_bd_pins wfifo_mem/wr_en]
  connect_bd_net -net wfifo_ctl_fifo_wdata    [get_bd_pins wfifo_ctl/fifo_wdata]      [get_bd_pins wfifo_mem/din]
  connect_bd_net -net wfifo_ctl_fifo_wovf     [get_bd_pins wfifo_ctl/fifo_wovf]       [get_bd_pins wfifo_mem/overflow]
  connect_bd_net -net wfifo_ctl_fifo_rd       [get_bd_pins wfifo_ctl/fifo_rd]         [get_bd_pins wfifo_mem/rd_en]
  connect_bd_net -net wfifo_ctl_fifo_rdata    [get_bd_pins wfifo_ctl/fifo_rdata]      [get_bd_pins wfifo_mem/dout]
  connect_bd_net -net wfifo_ctl_fifo_rempty   [get_bd_pins wfifo_ctl/fifo_rempty]     [get_bd_pins wfifo_mem/empty]

  current_bd_instance $c_instance
}

