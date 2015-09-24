
  source $ad_hdl_dir/projects/common/ac701/ac701_system_bd.tcl
  source ../common/fmcomms1_bd.tcl
  set_property -dict [list CONFIG.FIFO_SIZE {8}] $axi_ad9643_dma

