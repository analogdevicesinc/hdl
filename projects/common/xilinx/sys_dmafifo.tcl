
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

  set wfifo_ctl [create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 wfifo_ctl]
  set_property -dict [list CONFIG.M_DATA_WIDTH $m_width] $wfifo_ctl
  set_property -dict [list CONFIG.S_DATA_WIDTH {512}] $wfifo_ctl
  set_property -dict [list CONFIG.S_READY_ENABLE {0}] $wfifo_ctl

  set rfifo_ctl [create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 rfifo_ctl]
  set_property -dict [list CONFIG.M_DATA_WIDTH {512}] $rfifo_ctl
  set_property -dict [list CONFIG.S_DATA_WIDTH {64}] $rfifo_ctl
  set_property -dict [list CONFIG.S_READY_ENABLE {1}] $rfifo_ctl

  set wfifo_mem [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 wfifo_mem]
  set_property -dict [list CONFIG.INTERFACE_TYPE {Native}] $wfifo_mem
  set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}] $wfifo_mem
  set_property -dict [list CONFIG.asymmetric_port_width {true}] $wfifo_mem
  set_property -dict [list CONFIG.Input_Data_Width $m_width] $wfifo_mem
  set_property -dict [list CONFIG.Input_Depth {64}] $wfifo_mem
  set_property -dict [list CONFIG.Output_Data_Width {512}] $wfifo_mem
  set_property -dict [list CONFIG.Overflow_Flag {true}] $wfifo_mem

  set rfifo_mem [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 rfifo_mem]
  set_property -dict [list CONFIG.INTERFACE_TYPE {Native}] $rfifo_mem
  set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}] $rfifo_mem
  set_property -dict [list CONFIG.asymmetric_port_width {true}] $rfifo_mem
  set_property -dict [list CONFIG.Input_Data_Width {512}] $rfifo_mem
  set_property -dict [list CONFIG.Input_Depth {64}] $rfifo_mem
  set_property -dict [list CONFIG.Output_Data_Width {64}] $rfifo_mem
  set_property -dict [list CONFIG.Overflow_Flag {true}] $rfifo_mem
  set_property -dict [list CONFIG.Programmable_Full_Type {Multiple_Programmable_Full_Threshold_Constants}] $rfifo_mem
  set_property -dict [list CONFIG.Full_Threshold_Assert_Value {24}] $rfifo_mem
  set_property -dict [list CONFIG.Full_Threshold_Negate_Value {12}] $rfifo_mem

  set axi_fifo2s [create_bd_cell -type ip -vlnv analog.com:user:axi_fifo2s:1.0 axi_fifo2s]
  set_property -dict [list CONFIG.AXI_ADDRESS {0xc0000000}] $axi_fifo2s
  set_property -dict [list CONFIG.AXI_ADDRLIMIT {0xc00fff00}] $axi_fifo2s
  set_property -dict [list CONFIG.AXI_LENGTH {4}] $axi_fifo2s
  set_property -dict [list CONFIG.AXI_SIZE {6}] $axi_fifo2s
  set_property -dict [list CONFIG.DATA_WIDTH {512}] $axi_fifo2s

  set axi_bram_ctl [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctl]
  set_property -dict [list CONFIG.DATA_WIDTH {512}] $axi_bram_ctl
  set_property -dict [list CONFIG.SINGLE_PORT_BRAM {0}] $axi_bram_ctl

  set bram_mem [create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 bram_mem]
  set_property -dict [list CONFIG.use_bram_block {BRAM_Controller}] $bram_mem
  set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}] $bram_mem

  connect_bd_intf_net -intf_net axi_bram [get_bd_intf_pins axi_bram_ctl/S_AXI] [get_bd_intf_pins axi_fifo2s/axi]
  connect_bd_intf_net -intf_net bram_port_a [get_bd_intf_pins axi_bram_ctl/BRAM_PORTA] [get_bd_intf_pins bram_mem/BRAM_PORTA]
  connect_bd_intf_net -intf_net bram_port_b [get_bd_intf_pins axi_bram_ctl/BRAM_PORTB] [get_bd_intf_pins bram_mem/BRAM_PORTB]

  connect_bd_net -net adc_rst                 [get_bd_pins adc_rst]
  connect_bd_net -net adc_rst                 [get_bd_pins axi_fifo2s/m_rst]
  connect_bd_net -net adc_clk                 [get_bd_pins adc_clk]
  connect_bd_net -net axi_clk                 [get_bd_pins axi_clk]
  connect_bd_net -net dma_clk                 [get_bd_pins dma_clk]
  connect_bd_net -net adc_clk                 [get_bd_pins wfifo_ctl/m_clk]
  connect_bd_net -net adc_clk                 [get_bd_pins wfifo_mem/wr_clk]
  connect_bd_net -net axi_clk                 [get_bd_pins axi_bram_ctl/s_axi_aclk]
  connect_bd_net -net axi_clk                 [get_bd_pins axi_fifo2s/axi_clk]
  connect_bd_net -net axi_clk                 [get_bd_pins axi_fifo2s/m_clk]
  connect_bd_net -net axi_clk                 [get_bd_pins wfifo_ctl/s_clk]
  connect_bd_net -net axi_clk                 [get_bd_pins wfifo_mem/rd_clk]
  connect_bd_net -net axi_clk                 [get_bd_pins rfifo_ctl/m_clk]
  connect_bd_net -net axi_clk                 [get_bd_pins rfifo_mem/wr_clk]
  connect_bd_net -net dma_rstn                [get_bd_pins dma_rstn]
  connect_bd_net -net dma_rstn                [get_bd_pins axi_bram_ctl/s_axi_aresetn]
  connect_bd_net -net dma_rstn                [get_bd_pins axi_fifo2s/axi_resetn]
  connect_bd_net -net dma_rstn                [get_bd_pins wfifo_ctl/rstn]
  connect_bd_net -net dma_clk                 [get_bd_pins rfifo_ctl/s_clk]
  connect_bd_net -net dma_clk                 [get_bd_pins rfifo_mem/rd_clk]

  connect_bd_net -net adc_wr                  [get_bd_pins adc_wr]                    [get_bd_pins wfifo_ctl/m_wr]
  connect_bd_net -net adc_wdata               [get_bd_pins adc_wdata]                 [get_bd_pins wfifo_ctl/m_wdata]
  connect_bd_net -net adc_wovf                [get_bd_pins adc_wovf]                  [get_bd_pins wfifo_ctl/m_wovf]
  connect_bd_net -net axi_xfer_req            [get_bd_pins axi_xfer_req]              [get_bd_pins axi_fifo2s/axi_xfer_req]
  connect_bd_net -net axi_xfer_status         [get_bd_pins axi_xfer_status]           [get_bd_pins axi_fifo2s/axi_xfer_status]
  connect_bd_net -net wfifo_ctl_fifo_rst      [get_bd_pins wfifo_ctl/fifo_rst]        [get_bd_pins wfifo_mem/rst]
  connect_bd_net -net wfifo_ctl_fifo_wr       [get_bd_pins wfifo_ctl/fifo_wr]         [get_bd_pins wfifo_mem/wr_en]
  connect_bd_net -net wfifo_ctl_fifo_wdata    [get_bd_pins wfifo_ctl/fifo_wdata]      [get_bd_pins wfifo_mem/din]
  connect_bd_net -net wfifo_ctl_fifo_wfull    [get_bd_pins wfifo_ctl/fifo_wfull]      [get_bd_pins wfifo_mem/full]
  connect_bd_net -net wfifo_ctl_fifo_wovf     [get_bd_pins wfifo_ctl/fifo_wovf]       [get_bd_pins wfifo_mem/overflow]
  connect_bd_net -net dma_wvalid              [get_bd_pins dma_wvalid]                [get_bd_pins rfifo_ctl/s_wr]
  connect_bd_net -net dma_wready              [get_bd_pins dma_wready]                [get_bd_pins rfifo_ctl/s_wready]
  connect_bd_net -net dma_wdata               [get_bd_pins dma_wdata]                 [get_bd_pins rfifo_ctl/s_wdata]
  connect_bd_net -net dma_wovf                [get_bd_pins dma_wovf]                  [get_bd_pins rfifo_ctl/s_wovf]
  connect_bd_net -net rfifo_ctl_fifo_rd       [get_bd_pins rfifo_ctl/fifo_rd]         [get_bd_pins rfifo_mem/rd_en]
  connect_bd_net -net rfifo_ctl_fifo_rdata    [get_bd_pins rfifo_ctl/fifo_rdata]      [get_bd_pins rfifo_mem/dout]
  connect_bd_net -net rfifo_ctl_fifo_rempty   [get_bd_pins rfifo_ctl/fifo_rempty]     [get_bd_pins rfifo_mem/empty]
  connect_bd_net -net wfifo_ctl_fifo_rd       [get_bd_pins wfifo_ctl/fifo_rd]         [get_bd_pins wfifo_mem/rd_en]
  connect_bd_net -net wfifo_ctl_fifo_rdata    [get_bd_pins wfifo_ctl/fifo_rdata]      [get_bd_pins wfifo_mem/dout]
  connect_bd_net -net wfifo_ctl_fifo_rempty   [get_bd_pins wfifo_ctl/fifo_rempty]     [get_bd_pins wfifo_mem/empty]
  connect_bd_net -net rfifo_ctl_fifo_rst      [get_bd_pins rfifo_ctl/fifo_rst]        [get_bd_pins rfifo_mem/rst]
  connect_bd_net -net rfifo_ctl_fifo_wr       [get_bd_pins rfifo_ctl/fifo_wr]         [get_bd_pins rfifo_mem/wr_en]
  connect_bd_net -net rfifo_ctl_fifo_wdata    [get_bd_pins rfifo_ctl/fifo_wdata]      [get_bd_pins rfifo_mem/din]
  connect_bd_net -net rfifo_ctl_fifo_wfull    [get_bd_pins rfifo_ctl/fifo_wfull]      [get_bd_pins rfifo_mem/full]
  connect_bd_net -net rfifo_ctl_fifo_wovf     [get_bd_pins rfifo_ctl/fifo_wovf]       [get_bd_pins rfifo_mem/overflow]
  connect_bd_net -net axi_fifo2s_swr          [get_bd_pins axi_fifo2s/m_wr]           [get_bd_pins wfifo_ctl/s_wr]
  connect_bd_net -net axi_fifo2s_swdata       [get_bd_pins axi_fifo2s/m_wdata]        [get_bd_pins wfifo_ctl/s_wdata]
  connect_bd_net -net axi_fifo2s_swovf        [get_bd_pins axi_fifo2s/m_wovf]         [get_bd_pins wfifo_ctl/s_wovf]
  connect_bd_net -net axi_fifo2s_axi_mrst     [get_bd_pins axi_fifo2s/axi_mrstn]      [get_bd_pins rfifo_ctl/rstn]
  connect_bd_net -net axi_fifo2s_axi_mwr      [get_bd_pins axi_fifo2s/axi_mwr]        [get_bd_pins rfifo_ctl/m_wr]
  connect_bd_net -net axi_fifo2s_axi_mwdata   [get_bd_pins axi_fifo2s/axi_mwdata]     [get_bd_pins rfifo_ctl/m_wdata]
  connect_bd_net -net axi_fifo2s_axi_mwovf    [get_bd_pins axi_fifo2s/axi_mwovf]      [get_bd_pins rfifo_ctl/m_wovf]
  connect_bd_net -net axi_fifo2s_axi_mwpfull  [get_bd_pins axi_fifo2s/axi_mwpfull]    [get_bd_pins rfifo_mem/prog_full]

  current_bd_instance $c_instance
}

