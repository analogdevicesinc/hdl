
# pl ddr3 (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

proc p_plddr3_fifo {p_name m_name adc_data_width} {

  global ad_hdl_dir

  set p_instance [get_bd_cells $p_name]
  set c_instance [current_bd_instance .]

  current_bd_instance $p_instance

  set m_instance [create_bd_cell -type hier $m_name]
  current_bd_instance $m_instance

  create_bd_pin -dir I -type rst sys_rst
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR3
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk

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

  set axi_ddr_cntrl [create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:2.1 axi_ddr_cntrl]
  set axi_ddr_cntrl_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name $axi_ddr_cntrl]]]
  file copy -force $ad_hdl_dir/projects/common/zc706/zc706_system_mig.prj "$axi_ddr_cntrl_dir/"
  set_property -dict [list CONFIG.XML_INPUT_FILE {zc706_system_mig.prj}] $axi_ddr_cntrl

  set axi_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_rstgen]
  set_property -dict [list CONFIG.USE_BOARD_FLOW {true}] $axi_rstgen
  set_property -dict [list CONFIG.RESET_BOARD_INTERFACE {reset}] $axi_rstgen

  set axi_fifo2s [create_bd_cell -type ip -vlnv analog.com:user:axi_fifo2s:1.0 axi_fifo2s]
  set_property -dict [list CONFIG.ADC_DATA_WIDTH $adc_data_width] $axi_fifo2s
  set_property -dict [list CONFIG.DMA_DATA_WIDTH {64}] $axi_fifo2s
  set_property -dict [list CONFIG.AXI_DATA_WIDTH {512}] $axi_fifo2s
  set_property -dict [list CONFIG.DMA_READY_ENABLE {1}] $axi_fifo2s
  set_property -dict [list CONFIG.AXI_SIZE {6}] $axi_fifo2s
  set_property -dict [list CONFIG.AXI_LENGTH {4}] $axi_fifo2s
  set_property -dict [list CONFIG.AXI_ADDRESS {0x80000000}] $axi_fifo2s
  set_property -dict [list CONFIG.AXI_ADDRLIMIT {0xa0000000}] $axi_fifo2s
  set_property -dict [list CONFIG.AXI_BYTE_WIDTH {64}] $axi_fifo2s

  connect_bd_intf_net -intf_net sys_clk [get_bd_intf_pins sys_clk] [get_bd_intf_pins axi_ddr_cntrl/SYS_CLK]
  connect_bd_intf_net -intf_net DDR3 [get_bd_intf_pins DDR3] [get_bd_intf_pins axi_ddr_cntrl/DDR3]
  connect_bd_intf_net -intf_net axi_ddr3 [get_bd_intf_pins axi_ddr_cntrl/S_AXI] [get_bd_intf_pins axi_fifo2s/axi]

  connect_bd_net -net adc_rst                 [get_bd_pins adc_rst]                   [get_bd_pins axi_fifo2s/adc_rst]
  connect_bd_net -net adc_clk                 [get_bd_pins adc_clk]                   [get_bd_pins axi_fifo2s/adc_clk]
  connect_bd_net -net adc_wr                  [get_bd_pins adc_wr]                    [get_bd_pins axi_fifo2s/adc_wr]
  connect_bd_net -net adc_wdata               [get_bd_pins adc_wdata]                 [get_bd_pins axi_fifo2s/adc_wdata]
  connect_bd_net -net adc_wovf                [get_bd_pins adc_wovf]                  [get_bd_pins axi_fifo2s/adc_wovf]
  connect_bd_net -net dma_clk                 [get_bd_pins dma_clk]                   [get_bd_pins axi_fifo2s/dma_clk]
  connect_bd_net -net dma_wr                  [get_bd_pins dma_wr]                    [get_bd_pins axi_fifo2s/dma_wr]
  connect_bd_net -net dma_wdata               [get_bd_pins dma_wdata]                 [get_bd_pins axi_fifo2s/dma_wdata]
  connect_bd_net -net dma_wready              [get_bd_pins dma_wready]                [get_bd_pins axi_fifo2s/dma_wready]
  connect_bd_net -net dma_xfer_req            [get_bd_pins dma_xfer_req]              [get_bd_pins axi_fifo2s/dma_xfer_req]
  connect_bd_net -net dma_xfer_status         [get_bd_pins dma_xfer_status]           [get_bd_pins axi_fifo2s/dma_xfer_status]
  connect_bd_net -net axi_clk                 [get_bd_pins axi_ddr_cntrl/ui_clk]      [get_bd_pins axi_fifo2s/axi_clk]

  connect_bd_net -net adc_rst                 [get_bd_pins axi_rstgen/ext_reset_in]
  connect_bd_net -net sys_rst                 [get_bd_pins sys_rst]
  connect_bd_net -net sys_rst                 [get_bd_pins axi_ddr_cntrl/sys_rst]
  connect_bd_net -net axi_clk                 [get_bd_pins axi_rstgen/slowest_sync_clk]
  connect_bd_net -net axi_resetn              [get_bd_pins axi_rstgen/peripheral_aresetn]
  connect_bd_net -net axi_resetn              [get_bd_pins axi_fifo2s/axi_resetn]
  connect_bd_net -net axi_resetn              [get_bd_pins axi_ddr_cntrl/aresetn]

  current_bd_instance $c_instance
}

