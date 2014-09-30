
# fifo and controller (write side)

proc p_sys_wfifo {p_name m_name m_width s_width} {

  global ad_hdl_dir

  set p_instance [get_bd_cells $p_name]
  set c_instance [current_bd_instance .]

  current_bd_instance $p_instance

  set m_instance [create_bd_cell -type hier $m_name]
  current_bd_instance $m_instance

  create_bd_pin -dir I rstn

  create_bd_pin -dir I -type clk m_clk
  create_bd_pin -dir I m_wr
  create_bd_pin -dir O m_wovf
  create_bd_pin -dir I -from [expr ($m_width-1)] -to 0 m_wdata

  create_bd_pin -dir I -type clk s_clk
  create_bd_pin -dir O s_wr
  create_bd_pin -dir I s_wovf
  create_bd_pin -dir O -from [expr ($s_width-1)] -to 0 s_wdata

  set wfifo_ctl [create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 wfifo_ctl]
  set_property -dict [list CONFIG.M_DATA_WIDTH $m_width] $wfifo_ctl
  set_property -dict [list CONFIG.S_DATA_WIDTH $s_width] $wfifo_ctl

  set wfifo_mem [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 wfifo_mem]
  set_property -dict [list CONFIG.INTERFACE_TYPE {Native}] $wfifo_mem
  set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}] $wfifo_mem
  set_property -dict [list CONFIG.Input_Data_Width $m_width] $wfifo_mem
  set_property -dict [list CONFIG.Input_Depth {64}] $wfifo_mem
  set_property -dict [list CONFIG.Output_Data_Width $s_width] $wfifo_mem
  set_property -dict [list CONFIG.Overflow_Flag {true}] $wfifo_mem

  connect_bd_net -net rstn                    [get_bd_pins rstn]
  connect_bd_net -net m_clk                   [get_bd_pins m_clk]
  connect_bd_net -net s_clk                   [get_bd_pins s_clk]
  connect_bd_net -net rstn                    [get_bd_pins wfifo_ctl/rstn]
  connect_bd_net -net m_clk                   [get_bd_pins wfifo_ctl/m_clk]
  connect_bd_net -net s_clk                   [get_bd_pins wfifo_ctl/s_clk]
  connect_bd_net -net m_clk                   [get_bd_pins wfifo_mem/wr_clk]
  connect_bd_net -net s_clk                   [get_bd_pins wfifo_mem/rd_clk]

  connect_bd_net -net m_wr                    [get_bd_pins m_wr]                      [get_bd_pins wfifo_ctl/m_wr]
  connect_bd_net -net m_wdata                 [get_bd_pins m_wdata]                   [get_bd_pins wfifo_ctl/m_wdata]
  connect_bd_net -net m_wovf                  [get_bd_pins m_wovf]                    [get_bd_pins wfifo_ctl/m_wovf]
  connect_bd_net -net s_wr                    [get_bd_pins s_wr]                      [get_bd_pins wfifo_ctl/s_wr]
  connect_bd_net -net s_wdata                 [get_bd_pins s_wdata]                   [get_bd_pins wfifo_ctl/s_wdata]
  connect_bd_net -net s_wovf                  [get_bd_pins s_wovf]                    [get_bd_pins wfifo_ctl/s_wovf]

  connect_bd_net -net wfifo_ctl_fifo_rst      [get_bd_pins wfifo_ctl/fifo_rst]        [get_bd_pins wfifo_mem/rst]
  connect_bd_net -net wfifo_ctl_fifo_wr       [get_bd_pins wfifo_ctl/fifo_wr]         [get_bd_pins wfifo_mem/wr_en]
  connect_bd_net -net wfifo_ctl_fifo_wdata    [get_bd_pins wfifo_ctl/fifo_wdata]      [get_bd_pins wfifo_mem/din]
  connect_bd_net -net wfifo_ctl_fifo_wfull    [get_bd_pins wfifo_ctl/fifo_wfull]      [get_bd_pins wfifo_mem/full]
  connect_bd_net -net wfifo_ctl_fifo_wovf     [get_bd_pins wfifo_ctl/fifo_wovf]       [get_bd_pins wfifo_mem/overflow]
  connect_bd_net -net wfifo_ctl_fifo_rd       [get_bd_pins wfifo_ctl/fifo_rd]         [get_bd_pins wfifo_mem/rd_en]
  connect_bd_net -net wfifo_ctl_fifo_rdata    [get_bd_pins wfifo_ctl/fifo_rdata]      [get_bd_pins wfifo_mem/dout]
  connect_bd_net -net wfifo_ctl_fifo_rempty   [get_bd_pins wfifo_ctl/fifo_rempty]     [get_bd_pins wfifo_mem/empty]

  current_bd_instance $c_instance
}

