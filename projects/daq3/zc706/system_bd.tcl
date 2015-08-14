
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_system_plddr3.tcl

p_plddr3_fifo [current_bd_instance .] axi_ad9680_fifo 128

create_bd_port -dir I -type rst sys_rst
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk

set_property CONFIG.POLARITY {ACTIVE_HIGH} [get_bd_ports sys_rst]

ad_connect  sys_rst axi_ad9680_fifo/sys_rst
ad_connect  sys_clk axi_ad9680_fifo/sys_clk
ad_connect  ddr3 axi_ad9680_fifo/ddr3

create_bd_addr_seg -range 0x40000000 -offset 0x80000000 \
  [get_bd_addr_spaces axi_ad9680_fifo/axi_adcfifo/axi] \
  [get_bd_addr_segs axi_ad9680_fifo/axi_ddr_cntrl/memmap/memaddr] \
  SEG_axi_ddr_cntrl_memaddr

source ../common/daq3_bd.tcl

