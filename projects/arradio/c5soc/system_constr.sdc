###############################################################################
## Copyright (C) 2014-2023, 2026 Analog Devices, Inc. All rights reserved.
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

create_clock -period "20.000 ns" -name sys_clk  [get_ports {sys_clk}]
create_clock -period 4.0 -name rx_clk [get_ports {rx_clk_in}]

derive_pll_clocks
derive_clock_uncertainty

create_clock -period 4.0 -name v_rx_clk
create_generated_clock -name v_tx_clk -source [get_ports {rx_clk_in}] [get_ports {tx_clk_out}]

set_input_delay -add_delay -rise -max  1.2  -clock {v_rx_clk} [get_ports {rx_frame_in}]
set_input_delay -add_delay -rise -max  1.2  -clock {v_rx_clk} [get_ports {rx_data_in[0]}]
set_input_delay -add_delay -rise -max  1.2  -clock {v_rx_clk} [get_ports {rx_data_in[1]}]
set_input_delay -add_delay -rise -max  1.2  -clock {v_rx_clk} [get_ports {rx_data_in[2]}]
set_input_delay -add_delay -rise -max  1.2  -clock {v_rx_clk} [get_ports {rx_data_in[3]}]
set_input_delay -add_delay -rise -max  1.2  -clock {v_rx_clk} [get_ports {rx_data_in[4]}]
set_input_delay -add_delay -rise -max  1.2  -clock {v_rx_clk} [get_ports {rx_data_in[5]}]
set_input_delay -add_delay -rise -min  0.2  -clock {v_rx_clk} [get_ports {rx_frame_in}]
set_input_delay -add_delay -rise -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[0]}]
set_input_delay -add_delay -rise -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[1]}]
set_input_delay -add_delay -rise -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[2]}]
set_input_delay -add_delay -rise -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[3]}]
set_input_delay -add_delay -rise -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[4]}]
set_input_delay -add_delay -rise -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[5]}]
set_input_delay -add_delay -fall -max  0.2  -clock {v_rx_clk} [get_ports {rx_frame_in}]
set_input_delay -add_delay -fall -max  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[0]}]
set_input_delay -add_delay -fall -max  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[1]}]
set_input_delay -add_delay -fall -max  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[2]}]
set_input_delay -add_delay -fall -max  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[3]}]
set_input_delay -add_delay -fall -max  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[4]}]
set_input_delay -add_delay -fall -max  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[5]}]
set_input_delay -add_delay -fall -min  0.2  -clock {v_rx_clk} [get_ports {rx_frame_in}]
set_input_delay -add_delay -fall -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[0]}]
set_input_delay -add_delay -fall -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[1]}]
set_input_delay -add_delay -fall -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[2]}]
set_input_delay -add_delay -fall -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[3]}]
set_input_delay -add_delay -fall -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[4]}]
set_input_delay -add_delay -fall -min  0.2  -clock {v_rx_clk} [get_ports {rx_data_in[5]}]

set_output_delay -add_delay -rise -max  1.2 -clock {v_tx_clk} [get_ports {tx_frame_out}]
set_output_delay -add_delay -rise -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[0]}]
set_output_delay -add_delay -rise -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[1]}]
set_output_delay -add_delay -rise -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[2]}]
set_output_delay -add_delay -rise -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[3]}]
set_output_delay -add_delay -rise -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[4]}]
set_output_delay -add_delay -rise -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[5]}]
set_output_delay -add_delay -rise -min  0.2 -clock {v_tx_clk} [get_ports {tx_frame_out}]
set_output_delay -add_delay -rise -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[0]}]
set_output_delay -add_delay -rise -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[1]}]
set_output_delay -add_delay -rise -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[2]}]
set_output_delay -add_delay -rise -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[3]}]
set_output_delay -add_delay -rise -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[4]}]
set_output_delay -add_delay -rise -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[5]}]
set_output_delay -add_delay -fall -max  1.2 -clock {v_tx_clk} [get_ports {tx_frame_out}]
set_output_delay -add_delay -fall -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[0]}]
set_output_delay -add_delay -fall -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[1]}]
set_output_delay -add_delay -fall -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[2]}]
set_output_delay -add_delay -fall -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[3]}]
set_output_delay -add_delay -fall -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[4]}]
set_output_delay -add_delay -fall -max  1.2 -clock {v_tx_clk} [get_ports {tx_data_out[5]}]
set_output_delay -add_delay -fall -min  0.2 -clock {v_tx_clk} [get_ports {tx_frame_out}]
set_output_delay -add_delay -fall -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[0]}]
set_output_delay -add_delay -fall -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[1]}]
set_output_delay -add_delay -fall -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[2]}]
set_output_delay -add_delay -fall -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[3]}]
set_output_delay -add_delay -fall -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[4]}]
set_output_delay -add_delay -fall -min  0.2 -clock {v_tx_clk} [get_ports {tx_data_out[5]}]

# locked is async- most likely clock won't be running when deasserted

set_false_path  -to [get_registers *axi_ad9361_lvds_if:i_dev_if|up_drp_locked_m1*]

# frame reader seems to use the wrong reset!

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

