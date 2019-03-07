
source ../common/adrv9361z7035_bd.tcl
source ../common/ccfmc_bd.tcl

cfg_ad9361_interface LVDS

create_bd_port -dir O sys_cpu_clk_out
ad_connect  sys_cpu_clk sys_cpu_clk_out

ad_ip_parameter axi_ad9361 CONFIG.ADC_INIT_DELAY 29


create_bd_cell -type ip -vlnv analog.com:user:util_axis_fifo:1.0 util_axis_fifo_0
set_property -dict [list CONFIG.DATA_WIDTH {16}] [get_bd_cells util_axis_fifo_0]
set_property -dict [list CONFIG.ADDRESS_WIDTH {3}] [get_bd_cells util_axis_fifo_0]

copy_bd_objs /  [get_bd_cells {util_axis_fifo_0}]
copy_bd_objs /  [get_bd_cells {util_axis_fifo_1}]
copy_bd_objs /  [get_bd_cells {util_axis_fifo_2}]

delete_bd_objs [get_bd_nets util_ad9361_adc_fifo_din_ovf] \
[get_bd_nets util_ad9361_adc_fifo_dout_enable_2] \
[get_bd_nets util_ad9361_adc_fifo_dout_data_3] \
[get_bd_nets axi_ad9361_adc_valid_i0] \
[get_bd_nets axi_ad9361_adc_enable_q0] \
[get_bd_nets axi_ad9361_adc_data_i1] \
[get_bd_nets axi_ad9361_adc_data_q1] \
[get_bd_nets util_ad9361_adc_fifo_dout_enable_3] \
[get_bd_nets util_ad9361_adc_fifo_dout_enable_0] \
[get_bd_nets util_ad9361_adc_fifo_dout_enable_1] \
[get_bd_nets axi_ad9361_adc_data_i0] \
[get_bd_nets axi_ad9361_adc_enable_i1] \
[get_bd_nets axi_ad9361_adc_valid_q1] \
[get_bd_nets util_ad9361_adc_fifo_dout_data_0] \
[get_bd_nets util_ad9361_adc_fifo_dout_data_1] \
[get_bd_nets util_ad9361_adc_fifo_dout_valid_0] \
[get_bd_nets axi_ad9361_adc_data_q0] \
[get_bd_nets axi_ad9361_adc_valid_i1] \
[get_bd_nets axi_ad9361_adc_enable_q1] \
[get_bd_nets util_ad9361_adc_fifo_dout_data_2] \
[get_bd_nets axi_ad9361_adc_enable_i0] \
[get_bd_nets axi_ad9361_adc_valid_q0] \
[get_bd_cells util_ad9361_adc_fifo]

disconnect_bd_net /util_ad9361_adc_fifo_dout_valid_1 [get_bd_pins util_ad9361_adc_pack/adc_valid_1]
disconnect_bd_net /util_ad9361_adc_fifo_dout_valid_2 [get_bd_pins util_ad9361_adc_pack/adc_valid_2]
disconnect_bd_net /util_ad9361_adc_fifo_dout_valid_3 [get_bd_pins util_ad9361_adc_pack/adc_valid_3]

delete_bd_objs [get_bd_nets util_ad9361_adc_fifo_dout_valid_0]
delete_bd_objs [get_bd_nets util_ad9361_adc_fifo_dout_valid_1]
delete_bd_objs [get_bd_nets util_ad9361_adc_fifo_dout_valid_2]
delete_bd_objs [get_bd_nets util_ad9361_adc_fifo_dout_valid_3]

connect_bd_net [get_bd_pins util_axis_fifo_0/s_axis_data] [get_bd_pins axi_ad9361/adc_data_i0]
connect_bd_net [get_bd_pins util_axis_fifo_0/s_axis_valid] [get_bd_pins axi_ad9361/adc_valid_i0]
connect_bd_net [get_bd_pins util_axis_fifo_0/m_axis_data] [get_bd_pins util_ad9361_adc_pack/adc_data_0]
connect_bd_net [get_bd_pins util_axis_fifo_0/m_axis_aclk] [get_bd_pins sys_ps7/FCLK_CLK0]
connect_bd_net [get_bd_pins util_axis_fifo_0/m_axis_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_net [get_bd_pins util_axis_fifo_0/s_axis_aclk] [get_bd_pins axi_ad9361/l_clk]

connect_bd_net [get_bd_pins util_axis_fifo_1/s_axis_valid] [get_bd_pins axi_ad9361/adc_valid_q0]
connect_bd_net [get_bd_pins util_axis_fifo_1/s_axis_data] [get_bd_pins axi_ad9361/adc_data_q0]
connect_bd_net [get_bd_pins util_axis_fifo_1/m_axis_data] [get_bd_pins util_ad9361_adc_pack/adc_data_1]
connect_bd_net [get_bd_pins util_axis_fifo_1/s_axis_aclk] [get_bd_pins axi_ad9361/l_clk]
connect_bd_net [get_bd_pins util_axis_fifo_1/m_axis_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_net [get_bd_pins util_axis_fifo_1/m_axis_aclk] [get_bd_pins sys_ps7/FCLK_CLK0]

connect_bd_net [get_bd_pins util_axis_fifo_2/s_axis_valid] [get_bd_pins axi_ad9361/adc_valid_i1]
connect_bd_net [get_bd_pins util_axis_fifo_2/s_axis_data] [get_bd_pins axi_ad9361/adc_data_i1]
connect_bd_net [get_bd_pins util_axis_fifo_2/m_axis_data] [get_bd_pins util_ad9361_adc_pack/adc_data_2]
connect_bd_net [get_bd_pins util_axis_fifo_2/s_axis_aclk] [get_bd_pins axi_ad9361/l_clk]
connect_bd_net [get_bd_pins util_axis_fifo_2/m_axis_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_net [get_bd_pins util_axis_fifo_2/m_axis_aclk] [get_bd_pins sys_ps7/FCLK_CLK0]

connect_bd_net [get_bd_pins util_axis_fifo_3/s_axis_valid] [get_bd_pins axi_ad9361/adc_valid_q1]
connect_bd_net [get_bd_pins util_axis_fifo_3/s_axis_data] [get_bd_pins axi_ad9361/adc_data_q1]
connect_bd_net [get_bd_pins util_axis_fifo_3/m_axis_data] [get_bd_pins util_ad9361_adc_pack/adc_data_3]
connect_bd_net [get_bd_pins util_axis_fifo_3/s_axis_aclk] [get_bd_pins axi_ad9361/l_clk]
connect_bd_net [get_bd_pins util_axis_fifo_3/m_axis_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_net [get_bd_pins util_axis_fifo_3/m_axis_aclk] [get_bd_pins sys_ps7/FCLK_CLK0]

create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0
set_property -dict [list CONFIG.C_SIZE {4}] [get_bd_cells util_reduced_logic_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]

connect_bd_net [get_bd_pins xlconcat_0/In0] [get_bd_pins util_axis_fifo_0/m_axis_valid]
connect_bd_net [get_bd_pins xlconcat_0/In1] [get_bd_pins util_axis_fifo_1/m_axis_valid]
connect_bd_net [get_bd_pins xlconcat_0/In2] [get_bd_pins util_axis_fifo_2/m_axis_valid]
connect_bd_net [get_bd_pins xlconcat_0/In3] [get_bd_pins util_axis_fifo_3/m_axis_valid]

connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins util_reduced_logic_0/Op1]

connect_bd_net [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins util_ad9361_adc_pack/adc_valid_0]
connect_bd_net [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins util_ad9361_adc_pack/adc_valid_1]
connect_bd_net [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins util_ad9361_adc_pack/adc_valid_2]
connect_bd_net [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins util_ad9361_adc_pack/adc_valid_3]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 VCC

connect_bd_net [get_bd_pins VCC/dout] [get_bd_pins util_ad9361_adc_pack/adc_enable_0]
connect_bd_net [get_bd_pins VCC/dout] [get_bd_pins util_ad9361_adc_pack/adc_enable_1]
connect_bd_net [get_bd_pins VCC/dout] [get_bd_pins util_ad9361_adc_pack/adc_enable_2]
connect_bd_net [get_bd_pins VCC/dout] [get_bd_pins util_ad9361_adc_pack/adc_enable_3]

connect_bd_net [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins util_axis_fifo_3/m_axis_ready]
connect_bd_net [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins util_axis_fifo_2/m_axis_ready]
connect_bd_net [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins util_axis_fifo_1/m_axis_ready]
connect_bd_net [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins util_axis_fifo_0/m_axis_ready]


disconnect_bd_net /util_ad9361_divclk_clk_out [get_bd_pins util_ad9361_adc_pack/adc_clk]
disconnect_bd_net /util_ad9361_divclk_clk_out [get_bd_pins axi_ad9361_adc_dma/fifo_wr_clk]

connect_bd_net [get_bd_pins util_ad9361_adc_pack/adc_clk] [get_bd_pins sys_ps7/FCLK_CLK0]
connect_bd_net [get_bd_pins axi_ad9361_adc_dma/fifo_wr_clk] [get_bd_pins sys_ps7/FCLK_CLK0]

delete_bd_objs [get_bd_nets util_ad9361_divclk_reset_peripheral_reset]
connect_bd_net [get_bd_pins sys_rstgen/peripheral_reset] [get_bd_pins util_ad9361_adc_pack/adc_rst]


create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
connect_bd_net [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins axi_ad9361/l_clk]

connect_bd_net [get_bd_pins util_axis_fifo_0/s_axis_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
connect_bd_net [get_bd_pins util_axis_fifo_1/s_axis_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
connect_bd_net [get_bd_pins util_axis_fifo_2/s_axis_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
connect_bd_net [get_bd_pins util_axis_fifo_3/s_axis_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
