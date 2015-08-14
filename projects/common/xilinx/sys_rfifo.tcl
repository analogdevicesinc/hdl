
# fifo and controller (read side)

proc p_sys_rfifo {p_name m_name dac_data_width dma_data_width} {

  global ad_hdl_dir

  set p_instance [get_bd_cells $p_name]
  set c_instance [current_bd_instance .]

  current_bd_instance $p_instance

  set m_instance [create_bd_cell -type hier $m_name]
  current_bd_instance $m_instance

  create_bd_pin -dir I -type clk dac_clk
  create_bd_pin -dir I dac_rd
  create_bd_pin -dir O -from [expr ($dac_data_width-1)] -to 0 dac_rdata
  create_bd_pin -dir O dac_runf

  create_bd_pin -dir I -type clk dma_clk
  create_bd_pin -dir O dma_rd
  create_bd_pin -dir I -from [expr ($dma_data_width-1)] -to 0 dma_rdata
  create_bd_pin -dir I dma_runf

  set rfifo_ctl [create_bd_cell -type ip -vlnv analog.com:user:util_rfifo:1.0 rfifo_ctl]
  set_property -dict [list CONFIG.DAC_DATA_WIDTH $dac_data_width] $rfifo_ctl
  set_property -dict [list CONFIG.DMA_DATA_WIDTH $dma_data_width] $rfifo_ctl

  set rfifo_mem [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 rfifo_mem]
  set_property -dict [list CONFIG.INTERFACE_TYPE {Native}] $rfifo_mem
  set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}] $rfifo_mem
  set_property -dict [list CONFIG.Input_Data_Width $dma_data_width] $rfifo_mem
  set_property -dict [list CONFIG.Input_Depth {64}] $rfifo_mem
  set_property -dict [list CONFIG.Output_Data_Width $dac_data_width] $rfifo_mem
  set_property -dict [list CONFIG.Underflow_Flag {true}] $rfifo_mem
  set_property -dict [list CONFIG.Reset_Pin {true}] $rfifo_mem
  set_property -dict [list CONFIG.Programmable_Full_Type {Single_Programmable_Full_Threshold_Constant}] $rfifo_mem
  set_property -dict [list CONFIG.Full_Threshold_Assert_Value {50}] $rfifo_mem

  connect_bd_net -net dac_clk                 [get_bd_pins dac_clk]
  connect_bd_net -net dma_clk                 [get_bd_pins dma_clk]
  connect_bd_net -net dac_clk                 [get_bd_pins rfifo_ctl/dac_clk]
  connect_bd_net -net dma_clk                 [get_bd_pins rfifo_ctl/dma_clk]
  connect_bd_net -net dma_clk                 [get_bd_pins rfifo_mem/wr_clk]
  connect_bd_net -net dac_clk                 [get_bd_pins rfifo_mem/rd_clk]

  connect_bd_net -net dac_rd                  [get_bd_pins dac_rd]                    [get_bd_pins rfifo_ctl/dac_rd]
  connect_bd_net -net dac_rdata               [get_bd_pins dac_rdata]                 [get_bd_pins rfifo_ctl/dac_rdata]
  connect_bd_net -net dac_runf                [get_bd_pins dac_runf]                  [get_bd_pins rfifo_ctl/dac_runf]
  connect_bd_net -net dma_rd                  [get_bd_pins dma_rd]                    [get_bd_pins rfifo_ctl/dma_rd]
  connect_bd_net -net dma_rdata               [get_bd_pins dma_rdata]                 [get_bd_pins rfifo_ctl/dma_rdata]
  connect_bd_net -net dma_runf                [get_bd_pins dma_runf]                  [get_bd_pins rfifo_ctl/dma_runf]

  connect_bd_net -net rfifo_ctl_fifo_rst      [get_bd_pins rfifo_ctl/fifo_rst]        [get_bd_pins rfifo_mem/rst]
  connect_bd_net -net rfifo_ctl_fifo_wr       [get_bd_pins rfifo_ctl/fifo_wr]         [get_bd_pins rfifo_mem/wr_en]
  connect_bd_net -net rfifo_ctl_fifo_wdata    [get_bd_pins rfifo_ctl/fifo_wdata]      [get_bd_pins rfifo_mem/din]
  connect_bd_net -net rfifo_ctl_fifo_wfull    [get_bd_pins rfifo_ctl/fifo_wfull]      [get_bd_pins rfifo_mem/prog_full]
  connect_bd_net -net rfifo_ctl_fifo_rd       [get_bd_pins rfifo_ctl/fifo_rd]         [get_bd_pins rfifo_mem/rd_en]
  connect_bd_net -net rfifo_ctl_fifo_rdata    [get_bd_pins rfifo_ctl/fifo_rdata]      [get_bd_pins rfifo_mem/dout]
  connect_bd_net -net rfifo_ctl_fifo_rempty   [get_bd_pins rfifo_ctl/fifo_rempty]     [get_bd_pins rfifo_mem/empty]
  connect_bd_net -net rfifo_ctl_fifo_runf     [get_bd_pins rfifo_ctl/fifo_runf]       [get_bd_pins rfifo_mem/underflow]

  current_bd_instance $c_instance
}

