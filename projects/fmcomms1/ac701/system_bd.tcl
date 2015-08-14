
  source $ad_hdl_dir/projects/common/ac701/ac701_system_bd.tcl
  source $ad_hdl_dir/projects/common/xilinx/sys_wfifo.tcl
  source ../common/fmcomms1_bd.tcl
  set_property -dict [list CONFIG.C_FIFO_SIZE {8}] $axi_ad9643_dma

