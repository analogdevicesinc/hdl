# delete reference design connections
delete_bd_objs [get_bd_nets axi_ad9361_dac_fifo_din_valid_0]
delete_bd_objs [get_bd_nets axi_ad9361_dac_fifo_din_enable_*]
delete_bd_objs [get_bd_nets util_ad9361_dac_upack_fifo_rd_data_*]
delete_bd_objs [get_bd_nets util_ad9361_dac_upack_fifo_rd_underflow]
delete_bd_objs [get_bd_nets util_ad9361_dac_upack_fifo_rd_valid]
delete_bd_objs [get_bd_nets util_ad9361_adc_fifo_dout_valid_0]
delete_bd_objs [get_bd_nets util_ad9361_adc_fifo_dout_enable_*]
delete_bd_objs [get_bd_nets util_ad9361_adc_fifo_dout_data_*]

# adding interpolation filters
set util_fir_int_0 [create_bd_cell -type ip -vlnv analog.com:user:util_fir_int:1.0 util_fir_int_0]
set util_fir_int_1 [create_bd_cell -type ip -vlnv analog.com:user:util_fir_int:1.0 util_fir_int_1]

# adding interpolation control
set interp_slice [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 interp_slice]

# adding decimation filters
set fir_decimator_0 [create_bd_cell -type ip -vlnv analog.com:user:util_fir_dec:1.0 fir_decimator_0]
set fir_decimator_1 [create_bd_cell -type ip -vlnv analog.com:user:util_fir_dec:1.0 fir_decimator_1]

# adding decimation control
set decim_slice [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 decim_slice]

# adding concatenation modules
set concat_0 [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 concat_0]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER CONFIG.IN0_WIDTH.VALUE_SRC USER] $concat_0
set_property -dict [list CONFIG.IN0_WIDTH {16} CONFIG.IN1_WIDTH {16}] $concat_0
set concat_1 [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 concat_1]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER CONFIG.IN0_WIDTH.VALUE_SRC USER] $concat_1
set_property -dict [list CONFIG.IN0_WIDTH {16} CONFIG.IN1_WIDTH {16}] $concat_1
set pack0_slice_0 [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 pack0_slice_0]
set_property -dict [list CONFIG.DIN_FROM {15}] $pack0_slice_0
set_property -dict [list CONFIG.DIN_TO {0}] $pack0_slice_0
set_property -dict [list CONFIG.DOUT_WIDTH {16}] $pack0_slice_0
set pack0_slice_1 [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 pack0_slice_1]
set_property -dict [list CONFIG.DIN_FROM {31}] $pack0_slice_1
set_property -dict [list CONFIG.DIN_TO {16}] $pack0_slice_1
set_property -dict [list CONFIG.DOUT_WIDTH {16}] $pack0_slice_1
set pack1_slice_0 [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 pack1_slice_0]
set_property -dict [list CONFIG.DIN_FROM {15}] $pack1_slice_0
set_property -dict [list CONFIG.DIN_TO {0}] $pack1_slice_0
set_property -dict [list CONFIG.DOUT_WIDTH {16}] $pack1_slice_0
set pack1_slice_1 [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 pack1_slice_1]
set_property -dict [list CONFIG.DIN_FROM {31}] $pack1_slice_1
set_property -dict [list CONFIG.DIN_TO {16}] $pack1_slice_1
set_property -dict [list CONFIG.DOUT_WIDTH {16}] $pack1_slice_1

# fir interpolator 0
connect_bd_net [get_bd_pins util_ad9361_divclk/clk_out] [get_bd_pins util_fir_int_0/aclk]
connect_bd_net [get_bd_pins util_ad9361_dac_upack/enable_0] [get_bd_pins axi_ad9361_dac_fifo/din_enable_0]
connect_bd_net [get_bd_pins util_ad9361_dac_upack/enable_1] [get_bd_pins axi_ad9361_dac_fifo/din_enable_1]
connect_bd_net [get_bd_pins util_ad9361_dac_upack/fifo_rd_en] [get_bd_pins util_fir_int_0/s_axis_data_tready]
connect_bd_net [get_bd_pins util_ad9361_dac_upack/fifo_rd_en] [get_bd_pins util_fir_int_0/s_axis_data_tvalid]
connect_bd_net [get_bd_pins axi_ad9361_dac_fifo/din_data_0] [get_bd_pins util_fir_int_0/channel_0]
connect_bd_net [get_bd_pins axi_ad9361_dac_fifo/din_data_1] [get_bd_pins util_fir_int_0/channel_1]
connect_bd_net [get_bd_pins axi_ad9361_dac_fifo/din_valid_0] [get_bd_pins util_fir_int_0/dac_read]
connect_bd_net [get_bd_pins concat_0/In0] [get_bd_pins util_ad9361_dac_upack/fifo_rd_data_0]
connect_bd_net [get_bd_pins concat_0/In1] [get_bd_pins util_ad9361_dac_upack/fifo_rd_data_1]
connect_bd_net [get_bd_pins concat_0/dout] [get_bd_pins util_fir_int_0/s_axis_data_tdata]

# fir interpolator 1
connect_bd_net [get_bd_pins util_ad9361_divclk/clk_out] [get_bd_pins util_fir_int_1/aclk]
connect_bd_net [get_bd_pins util_ad9361_dac_upack/enable_2] [get_bd_pins axi_ad9361_dac_fifo/din_enable_2]
connect_bd_net [get_bd_pins util_ad9361_dac_upack/enable_3] [get_bd_pins axi_ad9361_dac_fifo/din_enable_3]
connect_bd_net [get_bd_pins util_ad9361_dac_upack/fifo_rd_en] [get_bd_pins util_fir_int_1/s_axis_data_tvalid]
connect_bd_net [get_bd_pins axi_ad9361_dac_fifo/din_data_2] [get_bd_pins util_fir_int_1/channel_0]
connect_bd_net [get_bd_pins axi_ad9361_dac_fifo/din_data_3] [get_bd_pins util_fir_int_0/channel_1]
connect_bd_net [get_bd_pins axi_ad9361_dac_fifo/din_valid_2] [get_bd_pins util_fir_int_1/dac_read]
connect_bd_net [get_bd_pins concat_1/In0] [get_bd_pins util_ad9361_dac_upack/fifo_rd_data_2]
connect_bd_net [get_bd_pins concat_1/In1] [get_bd_pins util_ad9361_dac_upack/fifo_rd_data_3]
connect_bd_net [get_bd_pins concat_1/dout] [get_bd_pins util_fir_int_1/s_axis_data_tdata]

# gpio controlled
connect_bd_net [get_bd_pins axi_ad9361/up_dac_gpio_out] [get_bd_pins interp_slice/Din]
connect_bd_net [get_bd_pins util_fir_int_0/interpolate] [get_bd_pins interp_slice/Dout]
connect_bd_net [get_bd_pins util_fir_int_1/interpolate] [get_bd_pins interp_slice/Dout]

# fir decimator 0
connect_bd_net [get_bd_pins util_ad9361_divclk/clk_out] [get_bd_pins fir_decimator_0/aclk]
connect_bd_net [get_bd_pins util_ad9361_adc_fifo/dout_data_0] [get_bd_pins fir_decimator_0/channel_0]
connect_bd_net [get_bd_pins util_ad9361_adc_fifo/dout_data_1] [get_bd_pins fir_decimator_0/channel_1]
connect_bd_net [get_bd_pins util_ad9361_adc_fifo/dout_valid_0] [get_bd_pins fir_decimator_0/s_axis_data_tvalid]
connect_bd_net [get_bd_pins util_ad9361_adc_pack/enable_0] [get_bd_pins util_ad9361_adc_fifo/dout_enable_0]
connect_bd_net [get_bd_pins util_ad9361_adc_pack/enable_1] [get_bd_pins util_ad9361_adc_fifo/dout_enable_1]
connect_bd_net [get_bd_pins pack0_slice_0/Din] [get_bd_pins fir_decimator_0/m_axis_data_tdata]
connect_bd_net [get_bd_pins pack0_slice_1/Din] [get_bd_pins fir_decimator_0/m_axis_data_tdata]
connect_bd_net [get_bd_pins util_ad9361_adc_pack/fifo_wr_data_0] [get_bd_pins pack0_slice_0/Dout]
connect_bd_net [get_bd_pins util_ad9361_adc_pack/fifo_wr_data_1] [get_bd_pins pack0_slice_1/Dout]

# fir decimator 1
connect_bd_net [get_bd_pins util_ad9361_divclk/clk_out] [get_bd_pins fir_decimator_1/aclk]
connect_bd_net [get_bd_pins util_ad9361_adc_fifo/dout_data_2] [get_bd_pins fir_decimator_1/channel_0]
connect_bd_net [get_bd_pins util_ad9361_adc_fifo/dout_data_3] [get_bd_pins fir_decimator_1/channel_1]
connect_bd_net [get_bd_pins util_ad9361_adc_fifo/dout_valid_2] [get_bd_pins fir_decimator_1/s_axis_data_tvalid]
connect_bd_net [get_bd_pins util_ad9361_adc_pack/fifo_wr_en] [get_bd_pins fir_decimator_1/m_axis_data_tvalid]
connect_bd_net [get_bd_pins util_ad9361_adc_pack/enable_2] [get_bd_pins util_ad9361_adc_fifo/dout_enable_2]
connect_bd_net [get_bd_pins util_ad9361_adc_pack/enable_3] [get_bd_pins util_ad9361_adc_fifo/dout_enable_3]
connect_bd_net [get_bd_pins pack1_slice_0/Din] [get_bd_pins fir_decimator_1/m_axis_data_tdata]
connect_bd_net [get_bd_pins pack1_slice_1/Din] [get_bd_pins fir_decimator_1/m_axis_data_tdata]
connect_bd_net [get_bd_pins util_ad9361_adc_pack/fifo_wr_data_2] [get_bd_pins pack1_slice_0/Dout]
connect_bd_net [get_bd_pins util_ad9361_adc_pack/fifo_wr_data_3] [get_bd_pins pack1_slice_1/Dout]

# gpio controlled
connect_bd_net [get_bd_pins axi_ad9361/up_dac_gpio_out] [get_bd_pins decim_slice/Din]
connect_bd_net [get_bd_pins fir_decimator_0/decimate] [get_bd_pins decim_slice/Dout]
connect_bd_net [get_bd_pins fir_decimator_1/decimate] [get_bd_pins decim_slice/Din]
