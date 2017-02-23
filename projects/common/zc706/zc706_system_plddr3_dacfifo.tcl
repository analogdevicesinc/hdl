
# pl ddr3 (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

proc p_plddr3_dacfifo {p_name m_name dma_data_width dac_data_width} {

  global ad_hdl_dir

  set p_instance [get_bd_cells $p_name]
  set c_instance [current_bd_instance .]

  current_bd_instance $p_instance

  set m_instance [create_bd_cell -type hier $m_name]
  current_bd_instance $m_instance

  create_bd_pin -dir I -type rst sys_rst
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk

  create_bd_pin -dir I dac_rst
  create_bd_pin -dir I -type clk dac_clk
  create_bd_pin -dir I dac_valid
  create_bd_pin -dir O -from [expr ($dac_data_width-1)] -to 0 dac_data
  create_bd_pin -dir O dac_dunf
  create_bd_pin -dir O dac_xfer_out
  create_bd_pin -dir I dac_fifo_bypass

  create_bd_pin -dir I -type clk dma_clk
  create_bd_pin -dir I dma_rvalid
  create_bd_pin -dir I -from [expr ($dma_data_width-1)] -to 0 dma_rdata
  create_bd_pin -dir O dma_rready
  create_bd_pin -dir I dma_xfer_req
  create_bd_pin -dir I dma_xfer_last

  create_bd_pin -dir O ddr_clk

  set axi_ddr_cntrl [create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.0 axi_ddr_cntrl]
  set axi_ddr_cntrl_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name $axi_ddr_cntrl]]]
  file copy -force $ad_hdl_dir/projects/common/zc706/zc706_system_mig.prj "$axi_ddr_cntrl_dir/"
  set_property -dict [list CONFIG.XML_INPUT_FILE {zc706_system_mig.prj}] $axi_ddr_cntrl

  set axi_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_rstgen]

  set axi_dacfifo [create_bd_cell -type ip -vlnv analog.com:user:axi_dacfifo:1.0 axi_dacfifo]
  set_property -dict [list CONFIG.DAC_DATA_WIDTH $dac_data_width] $axi_dacfifo
  set_property -dict [list CONFIG.DMA_DATA_WIDTH $dma_data_width] $axi_dacfifo
  set_property -dict [list CONFIG.AXI_DATA_WIDTH {512}] $axi_dacfifo
  set_property -dict [list CONFIG.AXI_SIZE {6}] $axi_dacfifo
  set_property -dict [list CONFIG.AXI_LENGTH {15}] $axi_dacfifo
  set_property -dict [list CONFIG.AXI_ADDRESS {0x80000000}] $axi_dacfifo
  set_property -dict [list CONFIG.AXI_ADDRESS_LIMIT {0xa0000000}] $axi_dacfifo

  ## clock and reset

  ad_connect  sys_clk axi_ddr_cntrl/SYS_CLK
  ad_connect  sys_rst axi_ddr_cntrl/sys_rst
  ad_connect  axi_clk axi_ddr_cntrl/ui_clk
  ad_connect  axi_clk axi_dacfifo/axi_clk
  ad_connect  axi_clk axi_rstgen/slowest_sync_clk
  ad_connect  dma_clk axi_dacfifo/dma_clk
  ad_connect  ddr_clk axi_ddr_cntrl/ui_clk
  ad_connect  dac_clk axi_dacfifo/dac_clk

  ad_connect  axi_resetn axi_rstgen/peripheral_aresetn
  ad_connect  axi_resetn axi_dacfifo/axi_resetn
  ad_connect  axi_resetn axi_ddr_cntrl/aresetn
  ad_connect  dac_rst axi_dacfifo/dac_rst
  ad_connect  dac_rst axi_rstgen/ext_reset_in

  ## interfaces

  ad_connect  ddr3 axi_ddr_cntrl/DDR3
  ad_connect  axi_ddr_cntrl/S_AXI axi_dacfifo/axi

  ad_connect  dma_rvalid axi_dacfifo/dma_valid
  ad_connect  dma_rready axi_dacfifo/dma_ready
  ad_connect  dma_rdata axi_dacfifo/dma_data
  ad_connect  dma_xfer_req axi_dacfifo/dma_xfer_req
  ad_connect  dma_xfer_last axi_dacfifo/dma_xfer_last

  ad_connect  dac_fifo_bypass axi_dacfifo/bypass
  ad_connect  dac_valid axi_dacfifo/dac_valid
  ad_connect  dac_data axi_dacfifo/dac_data
  ad_connect  dac_dunf axi_dacfifo/dac_dunf
  ad_connect  dac_xfer_out axi_dacfifo/dac_xfer_out

  ad_connect  axi_ddr_cntrl/device_temp_i GND

  current_bd_instance $c_instance
}
