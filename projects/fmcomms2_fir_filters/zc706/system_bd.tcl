

set project_dir [pwd]
cd $ad_hdl_dir/projects/fmcomms2/zc706/
source system_bd.tcl
cd $project_dir


delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_dac_upack/dac_valid_*]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_dac_upack/dac_enable_*]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_dac_upack/dac_data_*]]]

delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_adc_pack/adc_valid_*]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_adc_pack/adc_enable_*]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_adc_pack/adc_data_*]]]

set interp_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 interp_slice ]
set fir_interpolator_0 [ create_bd_cell -type ip -vlnv analog.com:user:util_fir_int:1.0 fir_interpolator_0 ]
set fir_interpolator_1 [ create_bd_cell -type ip -vlnv analog.com:user:util_fir_int:1.0 fir_interpolator_1 ]

set decim_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 decim_slice ]
set fir_decimator_0 [ create_bd_cell -type ip -vlnv analog.com:user:util_fir_dec:1.0 fir_decimator_0 ]
set fir_decimator_1 [ create_bd_cell -type ip -vlnv analog.com:user:util_fir_dec:1.0 fir_decimator_1 ]

set concat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_0 ]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER CONFIG.IN0_WIDTH.VALUE_SRC USER] $concat_0
set_property -dict [list CONFIG.IN0_WIDTH {16} CONFIG.IN1_WIDTH {16}] $concat_0

set concat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_1 ]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER CONFIG.IN0_WIDTH.VALUE_SRC USER] $concat_1
set_property -dict [list CONFIG.IN0_WIDTH {16} CONFIG.IN1_WIDTH {16}] $concat_1

set pack0_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 pack0_slice_0 ]
set_property -dict [list CONFIG.DIN_FROM {15}] $pack0_slice_0
set_property -dict [list CONFIG.DIN_TO {0}] $pack0_slice_0
set_property -dict [list CONFIG.DOUT_WIDTH {16}] $pack0_slice_0

set pack0_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 pack0_slice_1 ]
set_property -dict [list CONFIG.DIN_FROM {31}] $pack0_slice_1
set_property -dict [list CONFIG.DIN_TO {16}] $pack0_slice_1
set_property -dict [list CONFIG.DOUT_WIDTH {16}] $pack0_slice_1

set pack1_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 pack1_slice_0 ]
set_property -dict [list CONFIG.DIN_FROM {15}] $pack1_slice_0
set_property -dict [list CONFIG.DIN_TO {0}] $pack1_slice_0
set_property -dict [list CONFIG.DOUT_WIDTH {16}] $pack1_slice_0

set pack1_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 pack1_slice_1 ]
set_property -dict [list CONFIG.DIN_FROM {31}] $pack1_slice_1
set_property -dict [list CONFIG.DIN_TO {16}] $pack1_slice_1
set_property -dict [list CONFIG.DOUT_WIDTH {16}] $pack1_slice_1

# fir interpolator 0
ad_connect clkdiv/clk_out fir_interpolator_0/aclk
ad_connect util_ad9361_dac_upack/dac_enable_0 dac_fifo/din_enable_0
ad_connect util_ad9361_dac_upack/dac_enable_1 dac_fifo/din_enable_1
ad_connect util_ad9361_dac_upack/dac_valid_0 fir_interpolator_0/s_axis_data_tready
ad_connect util_ad9361_dac_upack/dac_valid_1 fir_interpolator_0/s_axis_data_tready
ad_connect util_ad9361_dac_upack/upack_valid_0 fir_interpolator_0/s_axis_data_tvalid
ad_connect dac_fifo/din_data_0 fir_interpolator_0/channel_0
ad_connect dac_fifo/din_data_1 fir_interpolator_0/channel_1
ad_connect dac_fifo/din_valid_0 fir_interpolator_0/dac_read

ad_connect concat_0/In0 util_ad9361_dac_upack/dac_data_0
ad_connect concat_0/In1 util_ad9361_dac_upack/dac_data_1
ad_connect concat_0/dout fir_interpolator_0/s_axis_data_tdata

# fir interpolator 1
ad_connect clkdiv/clk_out fir_interpolator_1/aclk
ad_connect util_ad9361_dac_upack/dac_enable_2 dac_fifo/din_enable_2
ad_connect util_ad9361_dac_upack/dac_enable_3 dac_fifo/din_enable_3
ad_connect util_ad9361_dac_upack/dac_valid_2 fir_interpolator_1/s_axis_data_tready
ad_connect util_ad9361_dac_upack/dac_valid_3 fir_interpolator_1/s_axis_data_tready
ad_connect util_ad9361_dac_upack/upack_valid_2 fir_interpolator_1/s_axis_data_tvalid
ad_connect dac_fifo/din_data_2 fir_interpolator_1/channel_0
ad_connect dac_fifo/din_data_3 fir_interpolator_1/channel_1
ad_connect dac_fifo/din_valid_2 fir_interpolator_1/dac_read

ad_connect concat_1/In0 util_ad9361_dac_upack/dac_data_2
ad_connect concat_1/In1 util_ad9361_dac_upack/dac_data_3
ad_connect concat_1/dout fir_interpolator_1/s_axis_data_tdata

ad_connect util_ad9361_dac_upack/dma_xfer_in VCC

# gpio controlled
ad_connect axi_ad9361/up_dac_gpio_out interp_slice/Din
ad_connect fir_interpolator_0/interpolate interp_slice/Dout
ad_connect fir_interpolator_1/interpolate interp_slice/Dout

# ad_connect axi_ad9361_dac_dma/fifo_rd_en fir_interpolator_1/s_axis_data_tready

# fir decimator 0
ad_connect clkdiv/clk_out fir_decimator_0/aclk
ad_connect util_ad9361_adc_fifo/dout_data_0 fir_decimator_0/channel_0
ad_connect util_ad9361_adc_fifo/dout_data_1 fir_decimator_0/channel_1
ad_connect util_ad9361_adc_fifo/dout_valid_0 fir_decimator_0/s_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_valid_0 fir_decimator_0/m_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_valid_1 fir_decimator_0/m_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_enable_0 util_ad9361_adc_fifo/dout_enable_0
ad_connect util_ad9361_adc_pack/adc_enable_1 util_ad9361_adc_fifo/dout_enable_1
ad_connect pack0_slice_0/Din fir_decimator_0/m_axis_data_tdata
ad_connect pack0_slice_1/Din fir_decimator_0/m_axis_data_tdata
ad_connect util_ad9361_adc_pack/adc_data_0 pack0_slice_0/Dout
ad_connect util_ad9361_adc_pack/adc_data_1 pack0_slice_1/Dout

# fir decimator 1
ad_connect clkdiv/clk_out fir_decimator_1/aclk
ad_connect util_ad9361_adc_fifo/dout_data_2 fir_decimator_1/channel_0
ad_connect util_ad9361_adc_fifo/dout_data_3 fir_decimator_1/channel_1
ad_connect util_ad9361_adc_fifo/dout_valid_2 fir_decimator_1/s_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_valid_2 fir_decimator_1/m_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_valid_3 fir_decimator_1/m_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_enable_2 util_ad9361_adc_fifo/dout_enable_2
ad_connect util_ad9361_adc_pack/adc_enable_3 util_ad9361_adc_fifo/dout_enable_3
ad_connect pack1_slice_0/Din fir_decimator_1/m_axis_data_tdata
ad_connect pack1_slice_1/Din fir_decimator_1/m_axis_data_tdata
ad_connect util_ad9361_adc_pack/adc_data_2 pack1_slice_0/Dout
ad_connect util_ad9361_adc_pack/adc_data_3 pack1_slice_1/Dout

#gpio controlled
ad_connect axi_ad9361/up_adc_gpio_out decim_slice/Din
ad_connect fir_decimator_0/decimate decim_slice/Dout
ad_connect fir_decimator_1/decimate decim_slice/Dout



set ila_FIR_int [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_FIR_int ]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_FIR_int
set_property -dict [list CONFIG.C_NUM_OF_PROBES {12}] $ila_FIR_int
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE0_WIDTH {16}] $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE2_WIDTH {32}] $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}]  $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE4_WIDTH {1}]  $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE5_WIDTH {1}]  $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE6_WIDTH {16}] $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE7_WIDTH {16}] $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE8_WIDTH {32}] $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE9_WIDTH {1}]  $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE10_WIDTH {1}]  $ila_FIR_int
set_property -dict [list CONFIG.C_PROBE11_WIDTH {1}]  $ila_FIR_int

ad_connect ila_FIR_int/clk clkdiv/clk_out
# interpolator 0
ad_connect ila_FIR_int/probe0 fir_interpolator_0/channel_0
ad_connect ila_FIR_int/probe1 fir_interpolator_0/channel_1
ad_connect ila_FIR_int/probe2 fir_interpolator_0/s_axis_data_tdata
ad_connect ila_FIR_int/probe3 fir_interpolator_0/s_axis_data_tready
ad_connect ila_FIR_int/probe4 fir_interpolator_0/s_axis_data_tvalid
ad_connect ila_FIR_int/probe5 fir_interpolator_0/m_axis_data_tvalid
# interpolator 1
ad_connect ila_FIR_int/probe6 fir_interpolator_1/channel_0
ad_connect ila_FIR_int/probe7 fir_interpolator_1/channel_1
ad_connect ila_FIR_int/probe8 fir_interpolator_1/s_axis_data_tdata
ad_connect ila_FIR_int/probe9 fir_interpolator_1/s_axis_data_tready
ad_connect ila_FIR_int/probe10 fir_interpolator_1/s_axis_data_tvalid
ad_connect ila_FIR_int/probe11 fir_interpolator_1/m_axis_data_tvalid



set ila_dac_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_dac_fifo ]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_dac_fifo
set_property -dict [list CONFIG.C_NUM_OF_PROBES {16}] $ila_dac_fifo
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE2_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE4_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE5_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE6_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE7_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE8_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE9_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE10_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE11_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE12_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE13_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE14_WIDTH {1}] $ila_dac_fifo
set_property -dict [list CONFIG.C_PROBE15_WIDTH {1}] $ila_dac_fifo

ad_connect ila_dac_fifo/clk clkdiv/clk_out
ad_connect ila_dac_fifo/probe0 dac_fifo/din_valid_0
ad_connect ila_dac_fifo/probe1 dac_fifo/din_valid_1
ad_connect ila_dac_fifo/probe2 dac_fifo/din_valid_2
ad_connect ila_dac_fifo/probe3 dac_fifo/din_valid_3
ad_connect ila_dac_fifo/probe4 dac_fifo/din_enable_0
ad_connect ila_dac_fifo/probe5 dac_fifo/din_enable_1
ad_connect ila_dac_fifo/probe6 dac_fifo/din_enable_2
ad_connect ila_dac_fifo/probe7 dac_fifo/din_enable_3
ad_connect ila_dac_fifo/probe8  dac_fifo/dout_valid_0
ad_connect ila_dac_fifo/probe9  dac_fifo/dout_valid_1
ad_connect ila_dac_fifo/probe10 dac_fifo/dout_valid_2
ad_connect ila_dac_fifo/probe11 dac_fifo/dout_valid_3
ad_connect ila_dac_fifo/probe12 dac_fifo/dout_enable_0
ad_connect ila_dac_fifo/probe13 dac_fifo/dout_enable_1
ad_connect ila_dac_fifo/probe14 dac_fifo/dout_enable_2
ad_connect ila_dac_fifo/probe15 dac_fifo/dout_enable_3


set ila_FIR_dec [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_FIR_dec ]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_FIR_dec
set_property -dict [list CONFIG.C_NUM_OF_PROBES {10}] $ila_FIR_dec
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE0_WIDTH {16}] $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE2_WIDTH {32}] $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}]  $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE4_WIDTH {1}]  $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE5_WIDTH {16}] $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE6_WIDTH {16}] $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE7_WIDTH {32}] $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE8_WIDTH {1}] $ila_FIR_dec
set_property -dict [list CONFIG.C_PROBE9_WIDTH {1}]  $ila_FIR_dec

ad_connect ila_FIR_dec/clk clkdiv/clk_out
# decimator 0
ad_connect ila_FIR_dec/probe0 fir_decimator_0/channel_0
ad_connect ila_FIR_dec/probe1 fir_decimator_0/channel_1
ad_connect ila_FIR_dec/probe2 fir_decimator_0/m_axis_data_tdata
ad_connect ila_FIR_dec/probe3 fir_decimator_0/s_axis_data_tready
ad_connect ila_FIR_dec/probe4 fir_decimator_0/m_axis_data_tvalid
# decimator 1
ad_connect ila_FIR_dec/probe5 fir_decimator_1/channel_0
ad_connect ila_FIR_dec/probe6 fir_decimator_1/channel_1
ad_connect ila_FIR_dec/probe7 fir_decimator_1/m_axis_data_tdata
ad_connect ila_FIR_dec/probe8 fir_decimator_1/s_axis_data_tready
ad_connect ila_FIR_dec/probe9 fir_decimator_1/m_axis_data_tvalid

regenerate_bd_layout
save_bd_design
validate_bd_design
