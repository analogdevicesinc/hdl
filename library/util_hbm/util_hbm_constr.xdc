###############################################################################
## Copyright (C) 2022-2023, 2026 Analog Devices, Inc. All rights reserved.
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

set_property ASYNC_REG TRUE \
	[get_cells -quiet -hier *cdc_sync_stage1_reg*] \
	[get_cells -quiet -hier *cdc_sync_stage2_reg*]

# i_wr_transfer constraints
#    .async_req_src(0),
#    .async_src_dest(1),
#    .async_dest_req(1),

set req_clk [get_clocks -of_objects [get_ports s_axis_aclk]]
set src_clk [get_clocks -of_objects [get_ports s_axis_aclk]]
set dest_clk [get_clocks -of_objects [get_ports m_axi_aclk]]

set_max_delay -quiet -datapath_only \
	-from $dest_clk \
	-to [get_cells -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_sync_req_response_id* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $dest_clk]

set_false_path -quiet \
	-from $dest_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_sync_status_dest* && IS_SEQUENTIAL}]

set_false_path -quiet \
	-from $req_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_sync_control_dest* && IS_SEQUENTIAL}]

set_max_delay -quiet -datapath_only \
	-from $dest_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_dest_response_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
	-from $req_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_dest_response_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $req_clk]
set_max_delay -quiet -datapath_only \
	-from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_wr_transfer*i_dest_response_fifo* && IS_SEQUENTIAL}] \
	-to $req_clk \
	[get_property -min PERIOD $req_clk]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_sync_dest_request_id* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_store_and_forward/i_dest_sync_id* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $dest_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_store_and_forward/i_src_sync_id* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
  -from $src_clk \
  -through [get_cells -quiet -hier \
    -filter {IS_SEQUENTIAL && NAME =~ *i_wr_transfer*i_store_and_forward/burst_len_mem_reg*}] \
	-to $dest_clk \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_dest_req_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $dest_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_dest_req_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
	-from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_wr_transfer*i_dest_req_fifo* && IS_SEQUENTIAL}] \
	-to $dest_clk \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_src_dest_bl_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $dest_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_wr_transfer*i_src_dest_bl_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
	-from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_wr_transfer*i_src_dest_bl_fifo* && IS_SEQUENTIAL}] \
	-to $dest_clk \
	[get_property -min PERIOD $dest_clk]

  set_max_delay -quiet -datapath_only \
  -from $src_clk \
  -through [get_cells -quiet -hier DP \
    -filter {NAME =~ *i_wr_transfer*i_request_arb/eot_mem_dest_reg*}] \
	-to $dest_clk \
	[get_property -min PERIOD $dest_clk]

# i_rd_transfer  constraints
#    .async_req_src(1),
#    .async_src_dest(1),
#    .async_dest_req(0),

set req_clk [get_clocks -of_objects [get_ports m_axis_aclk]]
set src_clk [get_clocks -of_objects [get_ports m_axi_aclk]]
set dest_clk [get_clocks -of_objects [get_ports m_axis_aclk]]

set_max_delay -quiet -datapath_only \
	-from $req_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_sync_src_request_id* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $req_clk]

set_false_path -quiet \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_sync_status_src* && IS_SEQUENTIAL}]

set_false_path -quiet \
	-from $req_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_sync_control_src* && IS_SEQUENTIAL}]

set_max_delay -quiet -datapath_only \
	-from $req_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_src_req_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $req_clk]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_src_req_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_rd_transfer*i_src_req_fifo* && IS_SEQUENTIAL}] \
	-to $src_clk \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
  -from $req_clk \
  -through [get_cells -quiet -hier DP \
    -filter {NAME =~ *i_rd_transfer*i_request_arb/eot_mem_src_reg*}] \
	-to $src_clk \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_rewind_req_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $req_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_rewind_req_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $req_clk]

set_max_delay -quiet -datapath_only \
	-from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_rd_transfer*i_rewind_req_fifo* && IS_SEQUENTIAL}] \
	-to $req_clk \
	[get_property -min PERIOD $req_clk]

set_false_path -quiet \
	-from $req_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*sync_rewind/i_sync_out* && IS_SEQUENTIAL}]

set_false_path -quiet \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*sync_rewind/i_sync_in* && IS_SEQUENTIAL}]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_sync_dest_request_id* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_store_and_forward/i_dest_sync_id* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $dest_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_store_and_forward/i_src_sync_id* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
  -from $src_clk \
  -through [get_cells -quiet -hier \
    -filter {IS_SEQUENTIAL && NAME =~ *i_rd_transfer*i_store_and_forward/burst_len_mem_reg*}] \
	-to $dest_clk \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_dest_req_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $dest_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_dest_req_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
	-from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_rd_transfer*i_dest_req_fifo* && IS_SEQUENTIAL}] \
	-to $dest_clk \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
	-from $src_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_src_dest_bl_fifo/zerodeep.i_waddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $src_clk]

set_max_delay -quiet -datapath_only \
	-from $dest_clk \
	-to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
		-filter {NAME =~ *i_rd_transfer*i_src_dest_bl_fifo/zerodeep.i_raddr_sync* && IS_SEQUENTIAL}] \
	[get_property -min PERIOD $dest_clk]

set_max_delay -quiet -datapath_only \
	-from [get_cells -quiet -hier *cdc_sync_fifo_ram_reg* \
		-filter {NAME =~ *i_rd_transfer*i_src_dest_bl_fifo* && IS_SEQUENTIAL}] \
	-to $dest_clk \
	[get_property -min PERIOD $dest_clk]

  set_max_delay -quiet -datapath_only \
  -from $src_clk \
  -through [get_cells -quiet -hier DP \
    -filter {NAME =~ *i_rd_transfer*i_request_arb/eot_mem_dest_reg*}] \
	-to $dest_clk \
	[get_property -min PERIOD $dest_clk]

# 
# Common to both dmas
#

# Reset signals
set_false_path -quiet \
	-from [get_cells -quiet -hier *do_reset_reg* \
		-filter {NAME =~ *i_reset_manager* && IS_SEQUENTIAL}] \
	-to [get_pins -quiet -hier *reset_async_reg*/PRE]

set_false_path -quiet \
	-from [get_cells -quiet -hier *reset_async_reg[0] \
		-filter {NAME =~ *i_reset_manager* && IS_SEQUENTIAL}] \
	-to [get_cells -quiet -hier *reset_async_reg[3]* \
		-filter {NAME =~ *i_reset_manager* && IS_SEQUENTIAL}]

set_false_path -quiet \
	-from [get_cells -quiet -hier *reset_async_reg[0] \
		-filter {NAME =~ *i_reset_manager* && IS_SEQUENTIAL}] \
	-to [get_pins -quiet -hier *reset_sync_in_reg*/PRE \
		-filter {NAME =~ *i_reset_manager*}]

set_false_path -quiet \
	-from [get_cells -quiet -hier *reset_sync_reg[0] \
		-filter {NAME =~ *i_reset_manager* && IS_SEQUENTIAL}] \
	-to [get_pins -quiet -hier *reset_sync_in_reg*/PRE \
		-filter {NAME =~ *i_reset_manager*}]

set_property -dict { \
    SHREG_EXTRACT NO \
    ASYNC_REG TRUE \
  } [get_cells -quiet -hier *reset_async_reg*]

set_property -dict { \
    SHREG_EXTRACT NO \
    ASYNC_REG TRUE \
  } [get_cells -quiet -hier *reset_sync_reg*]

