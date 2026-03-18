###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## configure ip components and add to design. #################################
adi_ip_instance -vlnv {latticesemi.com:ip:cpu0:2.8.0} \
  -meta_vlnv {latticesemi.com:ip:riscv_rtos:2.8.0} \
  -cfg_value {
    TCM_ENABLE: false,
    IRQ_NUM: 16,
    UART_EN: false,
    INSTR_PORT_ENABLE:true,
    RESET_VECTOR_INPUT:80000000,
    CACHE_RANGE_HIGH:C0000000,
    AXI_ID_WIDTH:4,
    MODE:Balanced
  } \
  -ip_iname "cpu0_inst"

adi_ip_instance -vlnv {latticesemi.com:ip:axi_interc0:2.2.1} \
  -meta_vlnv {latticesemi.com:ip:axi_interconnect:2.2.1} \
  -cfg_value {
    EXT_MAS_AXI_ID_WIDTH:4,
    EXT_SLV_AXI_ID_WIDTH:8,
    TOTAL_EXTMAS_CNT:2,
    TOTAL_EXTSLV_CNT:3
  } \
  -ip_iname "axi_interc0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_apb0:1.4.0} \
  -meta_vlnv {latticesemi.com:ip:axi2apb_bridge:1.4.0} \
  -cfg_value {} \
  -ip_iname "axi_apb0_inst"
adi_ip_instance -vlnv {latticesemi.com:module:apb_interconnect0:1.4.0} \
  -meta_vlnv {latticesemi.com:module:apb_interconnect:1.4.0} \
  -cfg_value {TOTAL_MASTER_CNT:1,TOTAL_SLAVE_CNT:2} \
  -ip_iname "apb_interconnect0_inst"

if {[info exists ad_project_params(SYSMEM_INIT_FILE)]} {
  if {[file exists $ad_project_params(SYSMEM_INIT_FILE)]} {
    set sysmem_init ",INIT_FILE_IN:[file normalize $ad_project_params(SYSMEM_INIT_FILE)],INIT_MEM:true"
    puts "Provided path for SYSMEM_INIT_FILE: $ad_project_params(SYSMEM_INIT_FILE)"
    puts "NORMALIZED: [file normalize $ad_project_params(SYSMEM_INIT_FILE)]"
  } else {
    puts "Init file does not exist or you provided wrong path!"
    puts "Provided path for SYSMEM_INIT_FILE: $ad_project_params(SYSMEM_INIT_FILE)"
    puts "You can provide a path relative to the project folder or an absolute"
    puts "path proper to your operating system (Lattice Propel Builder installation)."
    set sysmem_init ""
  }
} else {
  set sysmem_init ""
}
adi_ip_instance -vlnv {latticesemi.com:ip:sysmem0:2.5.1} \
  -meta_vlnv {latticesemi.com:ip:system_memory:2.5.1} \
  -cfg_value [subst {
    ADDR_DEPTH:32768,
    ID_WIDTH:8,
    INTERFACE:AXI4,
    MEMORY_TYPE:LRAM,
    REGMODE_S0:true,
    ATOMIC_ACCESS_EN_S0:true$sysmem_init
  }] \
  -ip_iname "sysmem0_inst"

adi_ip_instance -vlnv {latticesemi.com:ip:lpddr4_contr:2.6.4}  \
  -meta_vlnv {latticesemi.com:ip:memory_controller:2.6.4} \
  -cfg_value {
    AXI_DATA_WIDTH:32,
    AXI_ID_WIDTH:8,
    CA_SLEW_RATE:MED,
    DATA_CLK_EN:true,
    DDR_CMD_FREQ:533,
    DDR_DENSITY:8,
    DDR_WIDTH:32,
    MAX_BURST_LEN:256
  } \
  -ip_iname "lpddr4_contr_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:uart0:1.5.0} \
  -meta_vlnv {latticesemi.com:ip:uart:1.5.0} \
  -cfg_value {SYS_CLOCK_FREQ:100} \
  -ip_iname "uart0_inst"
adi_ip_instance -vlnv {latticesemi.com:module:pll0:1.9.1} \
  -meta_vlnv {latticesemi.com:module:pll:1.9.1} \
  -cfg_value {
    gui_refclk_freq: 125.0,
    gui_clk_os_en: true,
    gui_clk_os_byp: false,
    gui_clk_os_freq: 10.0
  } \
  -ip_iname "pll0_inst"

sbp_add_gluelogic -name equation_module_inst \
  -logicinfo [sbp_create_glue_logic equation equation_module {} { {
    "expr": "A & B",
    "module_name": "equation_module0"
  }}]

sbp_add_port -direction in clk_100
sbp_add_port -direction in clk_125
sbp_add_port -direction in rstn_i
sbp_add_port -direction in rxd_i
sbp_add_port -direction out txd_o

sbp_add_port -direction out config_active

sbp_add_port -from 5 -to 0 -direction out ddr_ca_o
sbp_add_port -from 0 -to 0 -direction out ddr_ck_o
sbp_add_port -from 0 -to 0 -direction out ddr_cke_o
sbp_add_port -from 0 -to 0 -direction out ddr_cs_o
sbp_add_port -from 3 -to 0 -direction inout ddr_dmi_io
sbp_add_port -from 31 -to 0 -direction inout ddr_dq_io
sbp_add_port -from 3 -to 0 -direction inout ddr_dqs_io

sbp_add_port -direction out ddr_reset_n_o
sbp_add_port -direction out init_done_o
sbp_add_port -direction out irq_o
sbp_add_port -direction out pll_lock_o
sbp_add_port -direction out sclk_o
sbp_add_port -direction out trn_err_o

sbp_connect_net $project_name/ddr_ca_o       $project_name/lpddr4_contr_inst/ddr_ca_o
sbp_connect_net $project_name/ddr_ck_o       $project_name/lpddr4_contr_inst/ddr_ck_o
sbp_connect_net $project_name/ddr_cke_o      $project_name/lpddr4_contr_inst/ddr_cke_o
sbp_connect_net $project_name/ddr_cs_o       $project_name/lpddr4_contr_inst/ddr_cs_o
sbp_connect_net $project_name/ddr_dmi_io     $project_name/lpddr4_contr_inst/ddr_dmi_io
sbp_connect_net $project_name/ddr_dq_io      $project_name/lpddr4_contr_inst/ddr_dq_io
sbp_connect_net $project_name/ddr_dqs_io     $project_name/lpddr4_contr_inst/ddr_dqs_io
sbp_connect_net $project_name/ddr_reset_n_o  $project_name/lpddr4_contr_inst/ddr_reset_n_o
sbp_connect_net $project_name/init_done_o    $project_name/lpddr4_contr_inst/init_done_o
sbp_connect_net $project_name/irq_o          $project_name/lpddr4_contr_inst/irq_o
sbp_connect_net $project_name/pll_lock_o     $project_name/lpddr4_contr_inst/pll_lock_o
sbp_connect_net $project_name/sclk_o         $project_name/lpddr4_contr_inst/sclk_o
sbp_connect_net $project_name/trn_err_o      $project_name/lpddr4_contr_inst/trn_err_o

sbp_connect_net "$project_name/equation_module_inst/A" \
  "$project_name/pll0_inst/lock_o"
sbp_connect_net "$project_name/equation_module_inst/B" \
  "$project_name/pll0_inst/rstn_i" \
  "$project_name/rstn_i"
sbp_connect_net "$project_name/equation_module_inst/O" \
  "$project_name/cpu0_inst/rstn_i"

sbp_connect_net "$project_name/cpu0_inst/system_resetn_o" \
  "$project_name/sysmem0_inst/axi_resetn_i" \
  "$project_name/axi_interc0_inst/axi_aresetn_i" \
  "$project_name/axi_apb0_inst/aresetn_i" \
  "$project_name/apb_interconnect0_inst/apb_presetn_i" \
  "$project_name/lpddr4_contr_inst/rst_n_i" \
  "$project_name/lpddr4_contr_inst/pll_rst_n_i" \
  "$project_name/lpddr4_contr_inst/preset_n_i" \
  "$project_name/lpddr4_contr_inst/areset_n_i" \
  "$project_name/uart0_inst/rst_n_i"

sbp_add_gluelogic -name invert_module_inst -logicinfo [sbp_create_glue_logic invert invert_module  {}]
sbp_connect_net $project_name/config_active $project_name/invert_module_inst/O
sbp_connect_net -name $project_name/cpu0_inst_system_resetn_o_net $project_name/invert_module_inst/I

sbp_connect_net "$project_name/clk_125" \
  "$project_name/pll0_inst/clki_i"

sbp_connect_net "$project_name/pll0_inst/clkos_o" \
  "$project_name/cpu0_inst/clk_realtime_i"

sbp_connect_net "$project_name/pll0_inst/clkop_o" \
  "$project_name/cpu0_inst/clk_system_i" \
  "$project_name/sysmem0_inst/axi_aclk_i" \
  "$project_name/axi_interc0_inst/axi_aclk_i" \
  "$project_name/axi_apb0_inst/aclk_i" \
  "$project_name/apb_interconnect0_inst/apb_pclk_i" \
  "$project_name/lpddr4_contr_inst/aclk_i" \
  "$project_name/lpddr4_contr_inst/pclk_i" \
  "$project_name/uart0_inst/clk_i"

sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_S00" \
  "$project_name/cpu0_inst/AXI_M_INSTR"
sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_S01" \
  "$project_name/cpu0_inst/AXI_M_DATA"
  sbp_connect_interface_net "$project_name/sysmem0_inst/AXI_S0" \
  "$project_name/axi_interc0_inst/AXI_M00"
sbp_connect_interface_net "$project_name/axi_apb0_inst/AXI4_S" \
  "$project_name/axi_interc0_inst/AXI_M01"
sbp_connect_interface_net "$project_name/apb_interconnect0_inst/APB_S00" \
  "$project_name/axi_apb0_inst/APB3_M"

sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_M02" \
  "$project_name/lpddr4_contr_inst/AXI_S0"

sbp_connect_interface_net "$project_name/lpddr4_contr_inst/APB_S0" \
  "$project_name/apb_interconnect0_inst/APB_M00"
sbp_connect_interface_net "$project_name/uart0_inst/APB_S0" \
  "$project_name/apb_interconnect0_inst/APB_M01"

sbp_connect_net $project_name/rxd_i $project_name/uart0_inst/rxd_i
sbp_connect_net $project_name/txd_o $project_name/uart0_inst/txd_o

sbp_connect_net $project_name/clk_100 $project_name/lpddr4_contr_inst/pll_refclk_i

sbp_connect_interface_net $project_name/cpu0_inst/IRQ_S3 $project_name/uart0_inst/INT_M0

# sbp_design auto_assign_addresses
sbp_assign_addr_seg -offset 'h00000000 $project_name/axi_interc0_inst/AXI_M02 $project_name/lpddr4_contr_inst/AXI_S0
sbp_assign_addr_seg -offset 'hC000B000 $project_name/apb_interconnect0_inst/APB_M00 $project_name/lpddr4_contr_inst/APB_S0
sbp_assign_addr_seg -offset 'hC0000000 $project_name/apb_interconnect0_inst/APB_M01 $project_name/uart0_inst/APB_S0
sbp_assign_addr_seg -offset 'h80000000 $project_name/axi_interc0_inst/AXI_M00 $project_name/sysmem0_inst/AXI_S0
