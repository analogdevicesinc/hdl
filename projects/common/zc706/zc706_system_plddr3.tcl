
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3
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

  set axi_ddr_cntrl [create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:2.3 axi_ddr_cntrl]
  set axi_ddr_cntrl_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name $axi_ddr_cntrl]]]
  file copy -force $ad_hdl_dir/projects/common/zc706/zc706_system_mig.prj "$axi_ddr_cntrl_dir/"
  set_property -dict [list CONFIG.XML_INPUT_FILE {zc706_system_mig.prj}] $axi_ddr_cntrl

  set axi_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_rstgen]
  set_property -dict [list CONFIG.USE_BOARD_FLOW {true}] $axi_rstgen
  set_property -dict [list CONFIG.RESET_BOARD_INTERFACE {reset}] $axi_rstgen

  set axi_adcfifo [create_bd_cell -type ip -vlnv analog.com:user:axi_adcfifo:1.0 axi_adcfifo]
  set_property -dict [list CONFIG.ADC_DATA_WIDTH $adc_data_width] $axi_adcfifo
  set_property -dict [list CONFIG.DMA_DATA_WIDTH {64}] $axi_adcfifo
  set_property -dict [list CONFIG.AXI_DATA_WIDTH {512}] $axi_adcfifo
  set_property -dict [list CONFIG.DMA_READY_ENABLE {1}] $axi_adcfifo
  set_property -dict [list CONFIG.AXI_SIZE {6}] $axi_adcfifo
  set_property -dict [list CONFIG.AXI_LENGTH {4}] $axi_adcfifo
  set_property -dict [list CONFIG.AXI_ADDRESS {0x80000000}] $axi_adcfifo
  set_property -dict [list CONFIG.AXI_ADDRLIMIT {0xa0000000}] $axi_adcfifo
  set_property -dict [list CONFIG.AXI_BYTE_WIDTH {64}] $axi_adcfifo

  ad_connect  sys_rst axi_ddr_cntrl/sys_rst
  ad_connect  sys_clk axi_ddr_cntrl/SYS_CLK
  ad_connect  ddr3 axi_ddr_cntrl/DDR3
  ad_connect  axi_ddr_cntrl/S_AXI axi_adcfifo/axi
  ad_connect  adc_rst axi_adcfifo/adc_rst
  ad_connect  adc_rst axi_rstgen/ext_reset_in
  ad_connect  adc_clk axi_adcfifo/adc_clk 
  ad_connect  adc_wr axi_adcfifo/adc_wr 
  ad_connect  adc_wdata axi_adcfifo/adc_wdata
  ad_connect  adc_wovf axi_adcfifo/adc_wovf
  ad_connect  dma_clk axi_adcfifo/dma_clk
  ad_connect  dma_wr axi_adcfifo/dma_wr
  ad_connect  dma_wdata axi_adcfifo/dma_wdata
  ad_connect  dma_wready axi_adcfifo/dma_wready
  ad_connect  dma_xfer_req axi_adcfifo/dma_xfer_req
  ad_connect  dma_xfer_status axi_adcfifo/dma_xfer_status
  ad_connect  axi_clk axi_ddr_cntrl/ui_clk
  ad_connect  axi_clk axi_adcfifo/axi_clk
  ad_connect  axi_clk axi_rstgen/slowest_sync_clk
  ad_connect  axi_resetn axi_rstgen/peripheral_aresetn
  ad_connect  axi_resetn axi_adcfifo/axi_resetn
  ad_connect  axi_resetn axi_ddr_cntrl/aresetn

  current_bd_instance $c_instance
}

