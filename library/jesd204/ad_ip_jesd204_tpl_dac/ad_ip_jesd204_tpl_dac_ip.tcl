###############################################################################
## Copyright (C) 2018-2022 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create ad_ip_jesd204_tpl_dac
adi_ip_files ad_ip_jesd204_tpl_dac [list \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_mux.v" \
  "$ad_hdl_dir/library/common/ad_mux_core.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_cordic_pipe.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine_cordic.v" \
  "$ad_hdl_dir/library/common/ad_dds_2.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_iqcor.v" \
  "$ad_hdl_dir/library/common/ad_perfect_shuffle.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "$ad_hdl_dir/library/common/util_ext_sync.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "../ad_ip_jesd204_tpl_common/up_tpl_common.v" \
  "ad_ip_jesd204_tpl_dac_channel.v" \
  "ad_ip_jesd204_tpl_dac_core.v" \
  "ad_ip_jesd204_tpl_dac_framer.v" \
  "ad_ip_jesd204_tpl_dac_regmap.v" \
  "ad_ip_jesd204_tpl_dac_pn.v" \
  "ad_ip_jesd204_tpl_dac.v" ]

adi_ip_properties ad_ip_jesd204_tpl_dac

adi_init_bd_tcl
adi_ip_bd ad_ip_jesd204_tpl_dac "bd/bd.tcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/jesd204/jesd204_tpl_dac} [ipx::current_core]

set cc [ipx::current_core]

set_property display_name "JESD204 Transport Layer for DACs" $cc
set_property description "JESD204 Transport Layer for DACs" $cc

# ADD missing stuff #######################################################

adi_add_bus "link" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list \
    {"link_ready" "TREADY"} \
    {"link_valid" "TVALID"} \
    {"link_data" "TDATA"} \
  ]
adi_add_bus_clock "link_clk" "link"

adi_set_ports_dependency "dac_sync_in"             "EXT_SYNC == 1"
adi_set_ports_dependency "dac_sync_manual_req_out" "EXT_SYNC == 1"
adi_set_ports_dependency "dac_sync_manual_req_in"  "EXT_SYNC == 1"

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" {"Polynominal" "0" "CORDIC" "1"} \
  "enablement_tcl_expr" "\$DATAPATH_DISABLE == 0" \
] [ipx::get_user_parameters DDS_TYPE -of_objects $cc]

foreach p {DDS_CORDIC_DW DDS_CORDIC_PHASE_DW} {
  set_property -dict [list \
    "value_validation_type" "range_long" \
    "value_validation_range_minimum" 8 \
    "value_validation_range_maximum" 20 \
    "enablement_tcl_expr" "\$DATAPATH_DISABLE == 0 && \$DDS_TYPE == 1" \
  ] [ipx::get_user_parameters $p -of_objects $cc]
}

foreach {p v} {
  "NUM_LANES" "1 2 3 4 6 8 12 16 24 32" \
  "NUM_CHANNELS" "1 2 4 6 8 16 32 64" \
  "BITS_PER_SAMPLE" "8 12 16" \
  "DMA_BITS_PER_SAMPLE" "8 12 16" \
  "CONVERTER_RESOLUTION" "8 11 12 16" \
  "SAMPLES_PER_FRAME" "1 2 3 4 6 8 12 16" \
  "OCTETS_PER_BEAT" "4 6 8 12 16 32 64" \
} { \
  set_property -dict [list \
    "value_validation_type" "list" \
    "value_validation_list" $v \
  ] [ipx::get_user_parameters $p -of_objects $cc]
}

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration"]

set p [ipgui::get_guiparamspec -name "ID" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $general_group
set_property -dict [list \
  "display_name" "Core ID" \
] $p

set framer_group [ipgui::add_group -name "JESD204 Framer Configuration" -component $cc \
    -parent $page0 -display_name "JESD204 Framer Cofiguration"]

set i 0

foreach {k v} { \
  "NUM_LANES" "Number of Lanes (L)" \
  "NUM_CHANNELS" "Number of Conveters (M)" \
  "BITS_PER_SAMPLE" "Bits per Sample (N')" \
  "DMA_BITS_PER_SAMPLE" "DMA Bits per Sample" \
  "CONVERTER_RESOLUTION" "Converter Resolution (N)" \
  "SAMPLES_PER_FRAME" "Samples per Frame (S)" \
  "OCTETS_PER_BEAT" "Octets per Beat" \
  } { \
  set p [ipgui::get_guiparamspec -name $k -component $cc]
  ipgui::move_param -component $cc -order $i $p -parent $framer_group
  set_property -dict [list \
    WIDGET "comboBox" \
    DISPLAY_NAME $v \
  ] $p
  incr i
}

set datapath_group [ipgui::add_group -name "Datapath Configuration" -component $cc \
    -parent $page0 -display_name "Datapath Cofiguration"]

set i 0

foreach {k v w} {
  "DATAPATH_DISABLE" "Disable Datapath" "checkBox" \
  "EXT_SYNC" "Enable external SYNC" "checkBox" \
  "IQCORRECTION_DISABLE" "Disable IQ Correction" "checkBox" \
  "XBAR_ENABLE" "Enable user data XBAR" "checkBox" \
  "DDS_TYPE" "DDS Type" "comboBox" \
  "DDS_PHASE_DW" "DDS Phase Width" "text" \
  "DDS_CORDIC_DW" "CORDIC DDS Data Width" "text" \
  "DDS_CORDIC_PHASE_DW" "CORDIC DDS Phase Width" "text" \
  } { \
  set p [ipgui::get_guiparamspec -name $k -component $cc]
  ipgui::move_param -component $cc -order $i $p -parent $datapath_group
  set_property -dict [list \
    WIDGET $w \
    DISPLAY_NAME $v \
  ] $p
  incr i
}

adi_add_auto_fpga_spec_params

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]
