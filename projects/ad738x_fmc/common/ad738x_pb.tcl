###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

########### This file contains only the tcl commands for importing lib ########
########### components and the assembly of the design. ########################

## Get parameters from global scope (set by adi_project_pb)
global ad_project_params

# Set default values if parameters are not provided
if {![info exists ad_project_params(ALERT_SPI_N)]} {
  set ALERT_SPI_N 0
} else {
  set ALERT_SPI_N $ad_project_params(ALERT_SPI_N)
}

if {![info exists ad_project_params(NUM_OF_SDI)]} {
  set NUM_OF_SDI 1
} else {
  set NUM_OF_SDI $ad_project_params(NUM_OF_SDI)
}

if {![info exists ad_project_params(DATA_WIDTH)]} {
  set DATA_WIDTH 16
} else {
  set DATA_WIDTH $ad_project_params(DATA_WIDTH)
}

puts "ad738x_pb.tcl: Using ALERT_SPI_N=$ALERT_SPI_N, NUM_OF_SDI=$NUM_OF_SDI, DATA_WIDTH=$DATA_WIDTH"

set DMA_WIDTH_SRC [expr ${NUM_OF_SDI} * $DATA_WIDTH]

adi_ip_update $project_name -vlnv {latticesemi.com:module:pll0:1.9.0} \
  -meta_vlnv {latticesemi.com:module:pll:1.9.0} \
  -cfg_value {
    gui_clk_os_byp:false,
    gui_clk_os_en:true,
    gui_clk_os_freq:10,
    gui_clk_s2_en:true,
    gui_clk_s2_freq:160,
    gui_refclk_freq:125
  } \
  -ip_iname "pll0_inst"
adi_ip_update $project_name -vlnv {latticesemi.com:ip:axi_interc0:2.0.1} \
  -meta_vlnv {latticesemi.com:ip:axi_interconnect:2.0.1} \
  -cfg_value {
    EXT_MAS_AXI_ID_WIDTH:4,
    EXT_SLV_AXI_ID_WIDTH:8,
    TOTAL_EXTMAS_CNT:3,
    TOTAL_EXTSLV_CNT:6,
    ext_slv_axi_protocol_2:1,
    ext_slv_axi_protocol_3:1,
    ext_slv_axi_protocol_4:1,
    ext_slv_axi_protocol_5:1
  } \
  -ip_iname "axi_interc0_inst"
adi_ip_instance -vlnv {analog.com:ip:axi_spi0:1.0} \
  -meta_vlnv {analog.com:ip:axi_spi_engine:1.0} \
  -cfg_value [subst {
    ASYNC_SPI_CLK:1,
    DATA_WIDTH:$DATA_WIDTH,
    MM_IF_TYPE:0,
    NUM_OFFLOAD:1,
    NUM_OF_SDI:$NUM_OF_SDI
  }] \
  -ip_iname "axi_spi0_inst"
adi_ip_instance -vlnv {analog.com:ip:pwm0:1.0} \
  -meta_vlnv {analog.com:ip:axi_pwm_gen:1.0} \
  -cfg_value {
    ASYNC_CLK_EN:1,
    FORCE_ALIGN:0,
    PWM_EXT_SYNC:0,
    SOFTWARE_BRINGUP:1,
    START_AT_SYNC:1,
    PULSE_0_PERIOD:120,
    PULSE_0_WIDTH:10
  } \
  -ip_iname "pwm0_inst"
adi_ip_instance -vlnv {analog.com:ip:spi_offload0:1.0} \
  -meta_vlnv {analog.com:ip:spi_engine_offload:1.0} \
  -cfg_value [subst {
    ASYNC_SPI_CLK:0,
    DATA_WIDTH:$DATA_WIDTH,
    NUM_OF_SDI:$NUM_OF_SDI
  }] \
  -ip_iname "spi_offload0_inst"
adi_ip_instance -vlnv {analog.com:ip:dmac0:1.0} \
  -meta_vlnv {analog.com:ip:axi_dmac:1.0} \
  -cfg_value [subst {
    ASYNC_CLK_DEST_REQ:0,
    ASYNC_CLK_DEST_SG:0,
    ASYNC_CLK_REQ_SG:0,
    ASYNC_CLK_REQ_SRC:1,
    ASYNC_CLK_SRC_DEST:1,
    ASYNC_CLK_SRC_SG:0,
    AXI_SLICE_DEST:1,
    AXI_SLICE_SRC:0,
    DMA_DATA_WIDTH_DEST:32,
    DMA_DATA_WIDTH_SRC:$DMA_WIDTH_SRC,
    DMA_TYPE_DEST:0,
    DMA_TYPE_SRC:1
  }] \
  -ip_iname "dmac0_inst"
adi_ip_instance -vlnv {analog.com:ip:spi_interc0:1.0} \
  -meta_vlnv {analog.com:ip:spi_engine_interconnect:1.0} \
  -cfg_value [subst {
    DATA_WIDTH:$DATA_WIDTH,
    NUM_OF_SDI:$NUM_OF_SDI
  }] \
  -ip_iname "spi_interc0_inst"
adi_ip_instance -vlnv {analog.com:ip:spi_exec0:1.0} \
  -meta_vlnv {analog.com:ip:spi_engine_execution:1.0} \
  -cfg_value [subst {
    DATA_WIDTH:$DATA_WIDTH,
    NUM_OF_SDI:$NUM_OF_SDI,
    SDI_DELAY:1
  }] \
  -ip_iname "spi_exec0_inst"

sbp_add_port -direction out spi_master0_cs
sbp_add_port -direction out spi_master0_sclk
if { $NUM_OF_SDI > 1 } {
sbp_add_port -from [expr $NUM_OF_SDI - 1] -to 0 -direction in spi_master0_sdi
} else {
  sbp_add_port -direction in spi_master0_sdi
}
sbp_add_port -direction out spi_master0_sdo
sbp_add_port -direction out spi_master0_sdo_t
sbp_add_port -direction out spi_master0_three_wire

sbp_add_gluelogic -name cnv_gate_inst \
  -logicinfo [sbp_create_glue_logic equation equation_module {} { {
    "expr": "A & B",
    "module_name": "cnv_gate"
  }}]

sbp_connect_net $project_name/pwm0_inst/pwm_0 \
  "$project_name/cnv_gate_inst/A"
sbp_connect_net "$project_name/dmac0_inst/s_axis_xfer_req" \
  "$project_name/cnv_gate_inst/B"
sbp_connect_net "$project_name/cnv_gate_inst/O" \
  $project_name/spi_offload0_inst/trigger

sbp_connect_constant -constant 1'B0 $project_name/dmac0_inst/s_axis_last

sbp_connect_net $project_name/spi_exec0_inst/cs \
  $project_name/spi_master0_cs
sbp_connect_net $project_name/spi_exec0_inst/sclk \
  $project_name/spi_master0_sclk
sbp_connect_net $project_name/spi_exec0_inst/sdi \
  $project_name/spi_master0_sdi
sbp_connect_net $project_name/spi_exec0_inst/sdo \
  $project_name/spi_master0_sdo
sbp_connect_net $project_name/spi_exec0_inst/sdo_t \
  $project_name/spi_master0_sdo_t
sbp_connect_net $project_name/spi_exec0_inst/three_wire \
  $project_name/spi_master0_three_wire

sbp_connect_net -name [sbp_get_nets -from $project_name/pll0_inst *clkop*] \
  "$project_name/pwm0_inst/s_axi_aclk" \
  "$project_name/axi_spi0_inst/s_axi_aclk" \
  "$project_name/dmac0_inst/s_axi_aclk" \
  "$project_name/dmac0_inst/m_dest_axi_aclk"

sbp_connect_net "$project_name/pll0_inst/clkos2_o" \
  "$project_name/pwm0_inst/ext_clk" \
  "$project_name/axi_spi0_inst/spi_clk" \
  "$project_name/spi_offload0_inst/spi_clk" \
  "$project_name/spi_offload0_inst/ctrl_clk" \
  "$project_name/dmac0_inst/s_axis_aclk" \
  "$project_name/spi_interc0_inst/clk" \
  "$project_name/spi_exec0_inst/clk"

sbp_connect_net -name [sbp_get_nets -from $project_name/cpu0_inst *resetn*] \
  "$project_name/pwm0_inst/s_axi_aresetn" \
  "$project_name/axi_spi0_inst/s_axi_aresetn" \
  "$project_name/dmac0_inst/s_axi_aresetn" \
  "$project_name/dmac0_inst/m_dest_axi_aresetn"

sbp_connect_net "$project_name/axi_spi0_inst/spi_resetn" \
  "$project_name/spi_offload0_inst/spi_resetn" \
  "$project_name/spi_interc0_inst/resetn" \
  "$project_name/spi_exec0_inst/resetn"

sbp_connect_interface_net "$project_name/axi_spi0_inst/IRQ" \
  "$project_name/cpu0_inst/IRQ_S8"
sbp_connect_interface_net "$project_name/dmac0_inst/IRQ" \
  "$project_name/cpu0_inst/IRQ_S7"

sbp_connect_interface_net $project_name/spi_offload0_inst/spi_engine_offload_ctrl \
  $project_name/axi_spi0_inst/spi_engine_offload_ctrl0
sbp_connect_interface_net $project_name/dmac0_inst/s_axis \
  $project_name/spi_offload0_inst/offload_sdi
sbp_connect_interface_net $project_name/spi_interc0_inst/s0_ctrl \
  $project_name/spi_offload0_inst/spi_engine_ctrl
sbp_connect_interface_net $project_name/spi_interc0_inst/s1_ctrl \
  $project_name/axi_spi0_inst/spi_engine_ctrl
sbp_connect_interface_net $project_name/spi_exec0_inst/spi_engine_ctrl \
  $project_name/spi_interc0_inst/m_ctrl
sbp_connect_interface_net $project_name/axi_interc0_inst/AXIL_M05 \
  $project_name/pwm0_inst/s_axi
sbp_connect_interface_net $project_name/axi_interc0_inst/AXIL_M04 \
  $project_name/axi_spi0_inst/s_axi
sbp_connect_interface_net $project_name/axi_interc0_inst/AXI_S02 \
  $project_name/dmac0_inst/m_dest_axi
sbp_connect_interface_net $project_name/dmac0_inst/s_axi \
  $project_name/axi_interc0_inst/AXIL_M03
sbp_connect_interface_net $project_name/spi_offload0_inst/m_interconnect_ctrl \
  $project_name/spi_interc0_inst/s_interconnect_ctrl

sbp_assign_addr_seg -offset 'h40030000 $project_name/axi_interc0_inst/AXIL_M04 \
  $project_name/axi_spi0_inst/s_axi
sbp_assign_addr_seg -offset 'h40020000 $project_name/axi_interc0_inst/AXIL_M03 \
  $project_name/dmac0_inst/s_axi
sbp_assign_addr_seg -offset 'h40040000 $project_name/axi_interc0_inst/AXIL_M05 \
  $project_name/pwm0_inst/s_axi
