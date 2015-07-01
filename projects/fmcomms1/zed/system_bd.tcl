
  source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
  source $ad_hdl_dir/projects/common/xilinx/sys_wfifo.tcl
  source ../common/fmcomms1_bd.tcl

  # Add extra register slice between ADC DMA and HP1 to meet timing
  #delete_bd_objs [get_bd_intf_nets axi_ad9643_dma_axi]
  #create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0
  #set_property -dict [list CONFIG.REG_AW {0} CONFIG.REG_AR {0} CONFIG.REG_W {1} CONFIG.REG_R {0} CONFIG.REG_B {0}] [get_bd_cells axi_register_slice_0]
  #ad_connect [get_bd_intf_pins axi_register_slice_0/S_AXI] [get_bd_intf_pins axi_ad9643_dma/m_dest_axi]
  #connect_bd_intf_net [get_bd_intf_pins sys_ps7/S_AXI_HP1] [get_bd_intf_pins axi_register_slice_0/M_AXI]
  #connect_bd_net -net [get_bd_nets sys_200m_clk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins sys_ps7/FCLK_CLK1]
  #connect_bd_net -net [get_bd_nets sys_100m_resetn] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn]
  #assign_bd_address [get_bd_addr_segs {sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM }]
