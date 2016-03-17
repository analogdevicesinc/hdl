
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_system_plddr3.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_dmafifo.tcl

p_plddr3_fifo [current_bd_instance .] axi_ad9680_fifo 128
p_sys_dacfifo [current_bd_instance .] axi_ad9152_fifo 128 10

create_bd_port -dir I -type rst sys_rst
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk

set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports sys_rst]

ad_connect  sys_rst axi_ad9680_fifo/sys_rst
ad_connect  sys_clk axi_ad9680_fifo/sys_clk
ad_connect  ddr3 axi_ad9680_fifo/ddr3

create_bd_addr_seg -range 0x40000000 -offset 0x80000000 \
  [get_bd_addr_spaces axi_ad9680_fifo/axi_adcfifo/axi] \
  [get_bd_addr_segs axi_ad9680_fifo/axi_ddr_cntrl/memmap/memaddr] \
  SEG_axi_ddr_cntrl_memaddr

source ../common/daq3_bd.tcl

# ila 

set mfifo_adc [create_bd_cell -type ip -vlnv analog.com:user:util_mfifo:1.0 mfifo_adc]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {2}] $mfifo_adc
set_property -dict [list CONFIG.DIN_DATA_WIDTH {64}] $mfifo_adc
set_property -dict [list CONFIG.ADDRESS_WIDTH {8}] $mfifo_adc

set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.0 ila_adc]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_adc
set_property -dict [list CONFIG.C_NUM_OF_PROBES {3}] $ila_adc
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_adc
set_property -dict [list CONFIG.C_PROBE2_WIDTH {16}] $ila_adc

ad_connect  util_daq3_gt/rx_rst mfifo_adc/din_rst
ad_connect  util_daq3_gt/rx_out_clk mfifo_adc/din_clk
ad_connect  axi_ad9680_core/adc_valid_0 mfifo_adc/din_valid
ad_connect  axi_ad9680_core/adc_data_0 mfifo_adc/din_data_0
ad_connect  axi_ad9680_core/adc_data_1 mfifo_adc/din_data_1
ad_connect  util_daq3_gt/rx_rst mfifo_adc/dout_rst
ad_connect  util_daq3_gt/rx_out_clk mfifo_adc/dout_clk
ad_connect  util_daq3_gt/rx_out_clk ila_adc/clk
ad_connect  mfifo_adc/dout_valid ila_adc/probe0
ad_connect  mfifo_adc/dout_data_0 ila_adc/probe1
ad_connect  mfifo_adc/dout_data_1 ila_adc/probe2


