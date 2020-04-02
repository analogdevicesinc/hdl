# Common block design


# IP cores related to JESD framework
source $ad_hdl_dir/projects/quad_quad_mxfe/common/jesd_cores_bd.tcl


# connect main control path interconnect to the qmxfe smart connects
set masters [get_property CONFIG.NUM_MI [get_bd_cells axi_cpu_interconnect]]
set_property -dict [list CONFIG.NUM_MI [expr $masters+4]] [get_bd_cells axi_cpu_interconnect]
for {set i 0} {$i < 4} {incr i} {
  ad_connect axi_cpu_interconnect/M[expr $masters+$i]_AXI qmxfe$i/interconnect/S00_AXI
  ad_connect axi_cpu_interconnect/M[expr $masters+$i]_ACLK $sys_cpu_clk
  ad_connect axi_cpu_interconnect/M[expr $masters+$i]_ARESETN $sys_cpu_resetn
  #fake an ad_cpu_interconnect
  global sys_cpu_interconnect_index
  incr sys_cpu_interconnect_index
}
assign_bd_address

# crate dummy DMACs to consume/drive adc/dac data so complete datapath
source $ad_hdl_dir/projects/quad_quad_mxfe/common/data_moovers_bd.tcl

for {set i 0} {$i < 4} {incr i} {

  ad_connect $sys_dma_resetn axi_mxfe_rx_dma_$i/m_dest_axi_aresetn
  ad_connect $sys_dma_resetn axi_mxfe_tx_dma_$i/m_src_axi_aresetn

  ad_cpu_interconnect 0x7c4[expr $i*2]0000 axi_mxfe_rx_dma_${i}
  ad_cpu_interconnect 0x7c4[expr $i*2+1]0000 axi_mxfe_tx_dma_${i}

  ad_mem_hp0_interconnect $sys_dma_clk axi_mxfe_tx_dma_$i/m_src_axi
  ad_mem_hp0_interconnect $sys_dma_clk axi_mxfe_rx_dma_$i/m_dest_axi
}





