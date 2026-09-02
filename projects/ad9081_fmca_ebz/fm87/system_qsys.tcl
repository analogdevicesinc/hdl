###############################################################################
## Copyright (C) 2024, 2026 Analog Devices, Inc. All rights reserved.
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

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/fm87/fm87_system_qsys.tcl
source $ad_hdl_dir/projects/common/intel/dacfifo_qsys.tcl
source $ad_hdl_dir/projects/common/intel/adcfifo_qsys.tcl

set jesd_mode $ad_project_params(JESD_MODE)

set jesd204_ref_clock [format {%.6f} $ad_project_params(REF_CLK_RATE)]
if {$jesd_mode == "64B66B"} {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 32]]
} else {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 20]]
}
# DUT F-Tile Ref clock
add_instance systemclk systemclk_f
set_instance_parameter_value systemclk syspll_mod_0 {User Configuration}
set_instance_parameter_value systemclk syspll_refclk_src_0 {RefClk #2}
set_instance_parameter_value systemclk syspll_freq_mhz_0 $syspll_freq
set_instance_parameter_value systemclk refclk_fgt_output_enable_2 1
set_instance_parameter_value systemclk refclk_fgt_freq_mhz_2 $jesd204_ref_clock

add_interface ref_clk_fgt_2 clock sink
set_interface_property ref_clk_fgt_2 EXPORT_OF systemclk.out_refclk_fgt_2

# add_interface systempll_clk_0 clock sink
# set_interface_property systempll_clk_0 EXPORT_OF systemclk.out_systempll_clk_0

add_interface ref_clk_in clock sink
set_interface_property ref_clk_in EXPORT_OF systemclk.refclk_fgt

set TRANSCEIVER_TYPE "F-Tile"
if [info exists ad_project_dir] {
  source ../../common/ad9081_fmca_ebz_qsys.tcl
} else {
  source ../common/ad9081_fmca_ebz_qsys.tcl
}

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "$mem_init_sys_file_path/mem_init_sys.txt"
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set sys_cstring "$ad_project_params(JESD_MODE)\
RX:RATE=$ad_project_params(RX_LANE_RATE)\
M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
NP=$ad_project_params(RX_JESD_NP)\
LINKS=$ad_project_params(RX_NUM_LINKS)\
KS/CH=$ad_project_params(RX_KS_PER_CHANNEL)\
TX:RATE=$ad_project_params(TX_LANE_RATE)\
M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
NP=$ad_project_params(TX_JESD_NP)\
LINKS=$ad_project_params(TX_NUM_LINKS)\
KS/CH=$ad_project_params(TX_KS_PER_CHANNEL)\
REF_CLK=$ad_project_params(REF_CLK_RATE)\
DEV_CLK=$ad_project_params(DEVICE_CLK_RATE)"

sysid_gen_sys_init_file sys_cstring
