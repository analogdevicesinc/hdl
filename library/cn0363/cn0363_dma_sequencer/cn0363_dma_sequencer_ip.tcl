###############################################################################
## Copyright (C) 2015-2024, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
