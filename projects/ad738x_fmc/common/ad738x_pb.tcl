###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

########### This file contains only the tcl commands for importing lib ########
########### components and the assembly of the design. ########################

## configure ip components and add to design. #################################
# set dir [pwd]
# cd $ad_hdl_dir/library/axi_dmac
# source ./axi_dmac_ltt.tcl
# cd $ad_hdl_dir/library/axi_pwm_gen
# source ./axi_pwm_gen_ltt.tcl
# cd $ad_hdl_dir/library/spi_engine/axi_spi_engine
# source ./axi_spi_engine_ltt.tcl
# cd $ad_hdl_dir/library/spi_engine/spi_engine_offload
# source ./spi_engine_offload_ltt.tcl
# cd $ad_hdl_dir/library/spi_engine/spi_engine_interconnect
# source ./spi_engine_interconnect_ltt.tcl
# cd $ad_hdl_dir/library/spi_engine/spi_engine_execution
# source ./spi_engine_execution_ltt.tcl
# cd $dir

adi_ip_update $project_name -vlnv {latticesemi.com:ip:sysmem0:2.1.0} \
  -meta_vlnv {latticesemi.com:ip:system_memory:2.1.0} \
  -cfg_value {
    INTERFACE: AXI4,
    ADDR_DEPTH: 8192,
    ID_WIDTH: 1,
    REGMODE_S0: true,
    MEMORY_TYPE:LRAM
  } \
  -ip_iname "sysmem0_inst"
adi_ip_update $project_name -vlnv {latticesemi.com:ip:axi_interc0:1.2.2} \
  -meta_vlnv {latticesemi.com:ip:axi_interconnect:1.2.2} \
  -cfg_value {
    EXT_MAS_AXI_ID_WIDTH:1,
    EXT_SLV_AXI_ID_WIDTH:8,
    TOTAL_EXTMAS_CNT:2,
    TOTAL_EXTSLV_CNT:8,
    ext_slv_axi_protocol_4:1,
    ext_slv_axi_protocol_5:1,
    ext_slv_axi_protocol_6:1
  } \
  -ip_iname "axi_interc0_inst"
adi_ip_instance -vlnv {analog.com:ip:axi_spi0:1.0} \
  -meta_vlnv {analog.com:ip:axi_spi_engine:1.0} \
  -cfg_value {
    ASYNC_SPI_CLK:0,
    DATA_WIDTH:32,
    MM_IF_TYPE:0,
    NUM_OFFLOAD:1,
    NUM_OF_SDI:4
  } \
  -ip_iname "axi_spi0_inst"
adi_ip_instance -vlnv {analog.com:ip:pwm0:1.0} \
  -meta_vlnv {analog.com:ip:axi_pwm_gen:1.0} \
  -cfg_value {
    ASYNC_CLK_EN:0,
    PULSE_0_PERIOD:120,
    PULSE_0_WIDTH:10
  } \
  -ip_iname "pwm0_inst"
adi_ip_instance -vlnv {analog.com:ip:spi_offload0:1.0} \
  -meta_vlnv {analog.com:ip:spi_engine_offload:1.0} \
  -cfg_value {
    ASYNC_SPI_CLK:0,
    DATA_WIDTH:32,
    NUM_OF_SDI:4
  } \
  -ip_iname "spi_offload0_inst"
adi_ip_instance -vlnv {analog.com:ip:dmac0:1.0} \
  -meta_vlnv {analog.com:ip:axi_dmac:1.0} \
  -cfg_value {
    ASYNC_CLK_DEST_REQ:0,
    ASYNC_CLK_DEST_SG:0,
    ASYNC_CLK_REQ_SG:0,
    ASYNC_CLK_REQ_SRC:0,
    ASYNC_CLK_SRC_DEST:0,
    ASYNC_CLK_SRC_SG:0,
    AXI_SLICE_DEST:1,
    AXI_SLICE_SRC:0,
    DMA_DATA_WIDTH_DEST:32,
    DMA_DATA_WIDTH_SRC:128,
    DMA_TYPE_DEST:0,
    DMA_TYPE_SRC:1
  } \
  -ip_iname "dmac0_inst"
adi_ip_instance -vlnv {analog.com:ip:spi_interc0:1.0} \
  -meta_vlnv {analog.com:ip:spi_engine_interconnect:1.0} \
  -cfg_value {DATA_WIDTH:32,NUM_OF_SDI:4} \
  -ip_iname "spi_interc0_inst"
adi_ip_instance -vlnv {analog.com:ip:spi_exec0:1.0} \
  -meta_vlnv {analog.com:ip:spi_engine_execution:1.0} \
  -cfg_value {
    DATA_WIDTH:32,
    NUM_OF_SDI:4,
    SDI_DELAY:1
  } \
  -ip_iname "spi_exec0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:sysmem_dmac0:2.1.0} \
  -meta_vlnv {latticesemi.com:ip:system_memory:2.1.0} \
  -cfg_value {
    ADDR_DEPTH:8192,
    INTERFACE:AXI4,
    MEMORY_TYPE:LRAM
  } \
  -ip_iname "sysmem_dmac0_inst"

sbp_connect_net -name [sbp_get_nets -from $project_name/pll0_inst *clkop*] \
  "$project_name/pwm0_inst/s_axi_aclk" \
  "$project_name/axi_spi0_inst/s_axi_aclk" \
  "$project_name/axi_spi0_inst/spi_clk" \
  "$project_name/spi_offload0_inst/spi_clk" \
  "$project_name/spi_offload0_inst/ctrl_clk" \
  "$project_name/dmac0_inst/s_axi_aclk" \
  "$project_name/dmac0_inst/s_axis_aclk" \
  "$project_name/dmac0_inst/m_dest_axi_aclk" \
  "$project_name/spi_interc0_inst/clk" \
  "$project_name/spi_exec0_inst/clk" \
  "$project_name/sysmem_dmac0_inst/axi_aclk_i"

sbp_connect_net -name [sbp_get_nets -from $project_name/cpu0_inst *resetn*] \
  "$project_name/pwm0_inst/s_axi_aresetn" \
  "$project_name/axi_spi0_inst/s_axi_aresetn" \
  "$project_name/dmac0_inst/s_axi_aresetn" \
  "$project_name/dmac0_inst/m_dest_axi_aresetn" \
  "$project_name/sysmem_dmac0_inst/axi_resetn_i"

sbp_connect_net "$project_name/axi_spi0_inst/spi_resetn" \
  "$project_name/spi_offload0_inst/spi_resetn" \
  "$project_name/spi_interc0_inst/resetn" \
  "$project_name/spi_exec0_inst/resetn"

sbp_connect_interface_net "$project_name/axi_spi0_inst/IRQ" \
  "$project_name/cpu0_inst/IRQ_S7"
sbp_connect_interface_net "$project_name/dmac0_inst/IRQ" \
  "$project_name/cpu0_inst/IRQ_S6"

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
sbp_connect_interface_net $project_name/axi_interc0_inst/AXIL_M06 \
  $project_name/pwm0_inst/s_axi
sbp_connect_interface_net $project_name/axi_interc0_inst/AXIL_M05 \
  $project_name/axi_spi0_inst/s_axi
sbp_connect_interface_net $project_name/axi_interc0_inst/AXI_S01 \
  $project_name/dmac0_inst/m_dest_axi
sbp_connect_net $project_name/spi_offload0_inst/trigger \
  $project_name/pwm0_inst/pwm_0
sbp_connect_interface_net $project_name/dmac0_inst/s_axi \
  $project_name/axi_interc0_inst/AXIL_M04
sbp_connect_interface_net $project_name/axi_interc0_inst/AXI_M07 \
  $project_name/sysmem_dmac0_inst/AXI_S0

sbp_export_interfaces $project_name/spi_exec0_inst/spi_master
sbp_rename -name  {spi_master0} $project_name/spi_exec0_inst_spi_master_interface

sbp_assign_addr_seg -offset 'h10020000 $project_name/axi_interc0_inst/AXIL_M05 \
  $project_name/axi_spi0_inst/s_axi
sbp_assign_addr_seg -offset 'h00300000 $project_name/axi_interc0_inst/AXI_M07 \
  $project_name/sysmem_dmac0_inst/AXI_S0
sbp_assign_addr_seg -offset 'h10010000 $project_name/axi_interc0_inst/AXIL_M04 \
  $project_name/dmac0_inst/s_axi
sbp_assign_addr_seg -offset 'h10030000 $project_name/axi_interc0_inst/AXIL_M06 \
  $project_name/pwm0_inst/s_axi
