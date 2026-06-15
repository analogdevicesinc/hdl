###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad9740
adi_ip_files axi_ad9740 [list \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "$ad_hdl_dir/library/common/ad_dds_cordic_pipe.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine_cordic.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_2.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_addsub.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "axi_ad9740_channel.v" \
  "axi_ad9740_core.v" \
  "axi_ad9740_if.v" \
  "axi_ad9740.v" ]

adi_ip_properties axi_ad9740
adi_init_bd_tcl
adi_ip_bd axi_ad9740 "bd/bd.tcl"

set cc [ipx::current_core]

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_ad9740} $cc

set_property driver_value 0 [ipx::get_ports *dac* -of_objects  $cc]
set_property driver_value 0 [ipx::get_ports *data* -of_objects  $cc]
set_property driver_value 0 [ipx::get_ports *valid* -of_objects  $cc]
ipx::infer_bus_interface dac_clk xilinx.com:signal:clock_rtl:1.0 $cc

# CLK_RATIO parameter (number of samples per clock cycle for DDR output)
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "1 2" \
] [ipx::get_user_parameters CLK_RATIO -of_objects $cc]
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "1 2" \
] [ipx::get_hdl_parameters CLK_RATIO -of_objects $cc]

# DAC_RESOLUTION parameter (8 for AD9748, 10 for AD9740, 12 for AD9742, 14 for AD9744)
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "8 10 12 14" \
] [ipx::get_user_parameters DAC_RESOLUTION -of_objects $cc]
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "8 10 12 14" \
] [ipx::get_hdl_parameters DAC_RESOLUTION -of_objects $cc]

adi_add_bus "s_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"dma_ready" "TREADY"} \
    {"dma_valid" "TVALID"} \
    {"dma_data" "TDATA"}]
adi_add_bus_clock "dac_clk" "s_axis"

adi_add_auto_fpga_spec_params

ipx::create_xgui_files $cc
ipx::save_core $cc
