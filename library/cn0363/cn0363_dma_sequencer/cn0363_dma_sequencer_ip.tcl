###############################################################################
## Copyright (C) 2015-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create cn0363_dma_sequencer
adi_ip_files cn0363_dma_sequencer [list \
	"cn0363_dma_sequencer.v"
]

adi_ip_properties_lite cn0363_dma_sequencer

adi_add_bus "phase" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"phase_valid" "TVALID"} \
		{"phase_ready" "TREADY"} \
		{"phase" "TDATA"} \
	}

adi_add_bus "data" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"data_valid" "TVALID"} \
		{"data_ready" "TREADY"} \
		{"data" "TDATA"} \
	}

adi_add_bus "data_filtered" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"data_filtered_valid" "TVALID"} \
		{"data_filtered_ready" "TREADY"} \
		{"data_filtered" "TDATA"} \
	}

adi_add_bus "i_q" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"i_q_valid" "TVALID"} \
		{"i_q_ready" "TREADY"} \
		{"i_q" "TDATA"} \
	}

adi_add_bus "i_q_filtered" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"i_q_filtered_valid" "TVALID"} \
		{"i_q_filtered_ready" "TREADY"} \
		{"i_q_filtered" "TDATA"} \
	}


adi_add_bus "dma_wr" "master" \
	"analog.com:interface:fifo_wr_rtl:1.0" \
	"analog.com:interface:fifo_wr:1.0" \
	{
		{"dma_wr_en" "EN"} \
		{"dma_wr_data" "DATA"} \
		{"dma_wr_overflow" "OVERFLOW"} \
		{"dma_wr_xfer_req" "XFER_REQ"} \
	}


adi_add_bus_clock "clk" "phase:data:data_filtered:i_q:i_q_filtered:dma_wr" "processing_resetn"

ipx::save_core [ipx::current_core]
