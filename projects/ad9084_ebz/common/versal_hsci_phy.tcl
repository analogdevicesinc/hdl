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

proc create_hsci_phy { {ip_name advanced_io_wizard_0} {num_banks 1} } {

  ad_ip_instance advanced_io_wizard ${ip_name}
  set_property -dict [list \
    CONFIG.DIFF_IO_T {DIFF_TERM_ADV} \
    CONFIG.DIFFERENTIAL_IO_TERMINATION {TERM_100} \
    CONFIG.BUS_DIR {3} \
    CONFIG.MAX_BANKS ${num_banks} \
    CONFIG.BIDIR_MODE {0} \
    CONFIG.CLK_TO_DATA_ALIGN {3} \
    CONFIG.DATA_SPEED {1600.00} \
    CONFIG.INPUT_CLK_FREQ {200.000} \
    CONFIG.ENABLE_PLLOUT1 {0} \
    CONFIG.PLL0_PLLOUTCLK1 {200.000} \
    CONFIG.SIMPLE_RIU {0} \
    CONFIG.REDUCE_CONTROL_SIG_EN {1} \
    CONFIG.BIT_PERIOD {625} \
    CONFIG.PLL_CLK {34.12539203348543} \
    CONFIG.TX_IOB {74} \
    CONFIG.TX_PHY {80} \
    CONFIG.TX_WINDOW_VAL {471} \
    CONFIG.RX_WINDOW_VAL {509} \
    CONFIG.BUS0_IO_TYPE {DIFF} \
    CONFIG.BUS0_STROBE_NAME {clk_in} \
    CONFIG.BUS0_STROBE_IO_TYPE {DIFF} \
    CONFIG.BUS0_SIG_NAME {data_in} \
    CONFIG.BUS1_DIR {TX} \
    CONFIG.BUS1_IO_TYPE {DIFF} \
    CONFIG.BUS1_SIG_NAME {data_out} \
    CONFIG.BUS2_DIR {TX} \
    CONFIG.BUS2_IO_TYPE {DIFF} \
    CONFIG.BUS2_SIG_TYPE {Clk Fwd} \
    CONFIG.BUS2_SIG_NAME {clk_out} \
    CONFIG.BUS12_WRCLK_EN {0} \
    CONFIG.DIFF_IO_STD {LVDS15} \
    CONFIG.ENABLE_BLI {0} \
  ] [get_bd_cells ${ip_name}]
}
