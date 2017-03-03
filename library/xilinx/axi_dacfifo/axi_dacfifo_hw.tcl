
package require -exact qsys 13.0
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_alt.tcl

ad_ip_create axi_dacfifo {AXI DAC FIFO Interface}
ad_ip_files axi_dacfifo [list\
  $ad_hdl_dir/library/altera/common/ad_mem_asym.v \
  $ad_hdl_dir/library/common/ad_axis_inf_rx.v \
  axi_dacfifo_dac.v \
  axi_dacfifo_wr.v \
  axi_dacfifo_rd.v \
  axi_dacfifo_bypass.v \
  axi_dacfifo.v \
  axi_dacfifo_constr.sdc]

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter DAC_DATA_WIDTH INTEGER 64
ad_ip_parameter DMA_DATA_WIDTH INTEGER 64
ad_ip_parameter AXI_DATA_WIDTH INTEGER 512
ad_ip_parameter AXI_SIZE INTEGER 2
ad_ip_parameter AXI_LENGTH INTEGER 15
ad_ip_parameter AXI_ADDRESS INTEGER 0
ad_ip_parameter AXI_ADDRESS_LIMIT INTEGER -1

# interfaces

ad_alt_intf clock dma_clk input 1 clk
ad_alt_intf reset dma_rst input 1 if_dma_clk
ad_alt_intf signal dma_valid input 1 valid
ad_alt_intf signal dma_data input DMA_DATA_WIDTH data
ad_alt_intf signal dma_ready output 1 ready
ad_alt_intf signal dma_xfer_req input 1 xfer_req
ad_alt_intf signal dma_xfer_last input 1 last

ad_alt_intf clock dac_clk input 1
ad_alt_intf reset dac_rst input 1 if_dac_clk
ad_alt_intf signal dac_valid input 1 valid
ad_alt_intf signal dac_data output DAC_DATA_WIDTH data
ad_alt_intf signal dac_dunf output 1 unf
ad_alt_intf signal dac_xfer_out output 1 xfer_req

ad_alt_intf signal bypass input 1 bypass

add_interface axi_clock clock end
add_interface_port axi_clock axi_clk clk input 1

add_interface axi_reset_n reset end
set_interface_property axi_reset_n associatedclock axi_clock
add_interface_port axi_reset_n axi_resetn reset_n input 1

add_interface m_axi axi4 start
add_interface_port m_axi axi_awvalid awvalid output 1
add_interface_port m_axi axi_awid awid output 4
add_interface_port m_axi axi_awburst awburst output 2
add_interface_port m_axi axi_awlock awlock output 1
add_interface_port m_axi axi_awcache awcache output 4
add_interface_port m_axi axi_awprot awprot output 3
add_interface_port m_axi axi_awqos awqos output 4
add_interface_port m_axi axi_awuser awuser output 4
add_interface_port m_axi axi_awlen awlen output 8
add_interface_port m_axi axi_awsize awsize output 3
add_interface_port m_axi axi_awaddr awaddr output 32
add_interface_port m_axi axi_awready awready input 1
add_interface_port m_axi axi_wvalid wvalid output 1
add_interface_port m_axi axi_wdata wdata output AXI_DATA_WIDTH
add_interface_port m_axi axi_wstrb wstrb output AXI_DATA_WIDTH/8
add_interface_port m_axi axi_wlast wlast output 1
add_interface_port m_axi axi_wready wready input 1
add_interface_port m_axi axi_bvalid bvalid input 1
add_interface_port m_axi axi_bid bid input 4
add_interface_port m_axi axi_bresp bresp input 2
add_interface_port m_axi axi_buser buser input 4
add_interface_port m_axi axi_bready bready output 1
add_interface_port m_axi axi_arvalid arvalid output 1
add_interface_port m_axi axi_arid arid output 4
add_interface_port m_axi axi_arburst arburst output 2
add_interface_port m_axi axi_arlock arlock output 1
add_interface_port m_axi axi_arcache arcache output 4
add_interface_port m_axi axi_arprot arprot output 3
add_interface_port m_axi axi_arqos arqos output 4
add_interface_port m_axi axi_aruser aruser output 4
add_interface_port m_axi axi_arlen arlen output 8
add_interface_port m_axi axi_arsize arsize output 3
add_interface_port m_axi axi_araddr araddr output 32
add_interface_port m_axi axi_arready arready input 1
add_interface_port m_axi axi_rvalid rvalid input 1
add_interface_port m_axi axi_rid rid input 4
add_interface_port m_axi axi_ruser ruser input 4
add_interface_port m_axi axi_rresp rresp input 2
add_interface_port m_axi axi_rlast rlast input 1
add_interface_port m_axi axi_rdata rdata input AXI_DATA_WIDTH
add_interface_port m_axi axi_rready rready output 1

set_interface_property m_axi associatedclock axi_clock
set_interface_property m_axi associatedreset axi_reset_n


