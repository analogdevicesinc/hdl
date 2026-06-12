###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

adi_ip_instance -vlnv {latticesemi.com:sim_model:clk_rst_gen:1.0.0} \
    -meta_vlnv {latticesemi.com:sim_model:Clock_Reset_Generator:1.0.0} \
    -cfg_value {TB_CLK_PERIOD:8} \
    -ip_iname "clk_rst_gen_inst"
adi_ip_instance -vlnv {latticesemi.com:sim_model:uart:1.0.0} \
    -meta_vlnv {latticesemi.com:sim_model:UART_Model:1.0.0} \
    -cfg_value {CLK_MHZ:125} \
    -ip_iname "uart_inst"

sbp_connect_net ${project_name}_v/uart_inst/clk \
    ${project_name}_v/clk_rst_gen_inst/tb_clk_o
sbp_connect_net -name ${project_name}_v/clk_rst_gen_inst_tb_clk_o_net \
    ${project_name}_v/dut_inst/clk_125
sbp_connect_net ${project_name}_v/uart_inst/rstn \
    ${project_name}_v/clk_rst_gen_inst/tb_rst_o
sbp_connect_net -name ${project_name}_v/clk_rst_gen_inst_tb_rst_o_net \
    ${project_name}_v/dut_inst/rstn_i
sbp_connect_net ${project_name}_v/dut_inst/rxd_i \
    ${project_name}_v/uart_inst/uart_txd
sbp_connect_net ${project_name}_v/dut_inst/txd_o \
    ${project_name}_v/uart_inst/uart_rxd
