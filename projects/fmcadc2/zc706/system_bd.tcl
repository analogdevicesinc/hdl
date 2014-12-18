
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_system_plddr3.tcl

p_plddr3_fifo [current_bd_instance .] axi_ad9625_fifo 256

create_bd_port -dir I -type rst sys_rst
set_property CONFIG.POLARITY {ACTIVE_HIGH} [get_bd_ports sys_rst]
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR3
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk
connect_bd_net -net sys_rst [get_bd_ports sys_rst] [get_bd_pins axi_ad9680_fifo/sys_rst]
connect_bd_intf_net -intf_net DDR3    [get_bd_intf_ports DDR3]    [get_bd_intf_pins axi_ad9625_fifo/DDR3]
connect_bd_intf_net -intf_net sys_clk [get_bd_intf_ports sys_clk] [get_bd_intf_pins axi_ad9625_fifo/sys_clk]
create_bd_addr_seg -range 0x40000000 -offset 0x80000000 [get_bd_addr_spaces axi_ad9625_fifo/axi_fifo2s/axi] \
  [get_bd_addr_segs axi_ad9625_fifo/axi_ddr_cntrl/memmap/memaddr] SEG_axi_ddr_cntrl_memaddr


source ../common/fmcadc2_bd.tcl



