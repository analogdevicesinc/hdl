###############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

########### This file contains only the tcl commands for importing lib ########
########### components and the assembly of the design. ########################

## configure ip components and add to design. #################################
adi_ip_instance -vlnv {latticesemi.com:ip:cpu0:2.5.0} \
  -meta_vlnv {latticesemi.com:ip:riscv_rtos:2.5.0} \
  -cfg_value {
    TCM_ENABLE: false,
    IRQ_NUM: 16,
    UART_EN: false,
    INSTR_PORT_ENABLE:true,
    AXI_ID_WIDTH:4
  } \
  -ip_iname "cpu0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:gpio0:1.7.0} \
  -meta_vlnv {latticesemi.com:ip:gpio:1.7.0} \
  -cfg_value {
    IO_LINES_COUNT: 32,
    EXTERNAL_BUF: true,
    DIRECTION_DEF_VAL_INPUT: 00FFFFFF
  } \
  -ip_iname "gpio0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:gpio1:1.7.0} \
  -meta_vlnv {latticesemi.com:ip:gpio:1.7.0} \
  -cfg_value {
    IO_LINES_COUNT: 32,
    EXTERNAL_BUF: true,
    DIRECTION_DEF_VAL_INPUT: 00000000
  } \
  -ip_iname "gpio1_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:spi0:2.1.0} \
  -meta_vlnv {latticesemi.com:ip:spi_controller:2.1.0} \
  -cfg_value {
    DATA_WIDTH: 8,
    FIFO_DEPTH: 256,
    INTERFACE: APB,
    SYS_CLOCK_FREQ: 100
  } \
  -ip_iname "spi0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:i2c0:2.2.0} \
  -meta_vlnv {latticesemi.com:ip:i2c_controller:2.2.0} \
  -cfg_value {
    SYS_CLOCK_FREQ: 100
  } \
  -ip_iname "i2c0_inst"
adi_ip_instance -vlnv {latticesemi.com:module:pll0:1.9.0} \
  -meta_vlnv {latticesemi.com:module:pll:1.9.0} \
  -cfg_value {
    gui_refclk_freq: 125.0,
    gui_clk_os_en: true,
    gui_clk_os_byp: false,
    gui_clk_os_freq: 10.0
  } \
  -ip_iname "pll0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_interc0:2.0.1} \
  -meta_vlnv {latticesemi.com:ip:axi_interconnect:2.0.1} \
  -cfg_value {
    TOTAL_EXTMAS_CNT: 2,
    TOTAL_EXTSLV_CNT: 3,
    EXT_MAS_AXI_ID_WIDTH: 4,
    EXT_SLV_AXI_ID_WIDTH: 8,
    ext_slv_axi_protocol_2:1
  } \
  -ip_iname "axi_interc0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:uart0:1.4.0} \
  -meta_vlnv {latticesemi.com:ip:uart:1.4.0} \
  -cfg_value {SYS_CLOCK_FREQ:100} \
  -ip_iname "uart0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_apb0:1.3.0} \
  -meta_vlnv {latticesemi.com:ip:axi2apb_bridge:1.3.0} \
  -cfg_value {} \
  -ip_iname "axi_apb0_inst"
adi_ip_instance -vlnv {latticesemi.com:module:apb_interconnect0:1.2.1} \
  -meta_vlnv {latticesemi.com:module:apb_interconnect:1.2.1} \
  -cfg_value {TOTAL_MASTER_CNT:1,TOTAL_SLAVE_CNT:5} \
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
adi_ip_instance -vlnv {latticesemi.com:ip:sysmem0:2.3.0} \
  -meta_vlnv latticesemi.com:ip:system_memory:2.3.0 \
  -cfg_value [subst {
    ADDR_DEPTH:32768,
    ID_WIDTH:8,
    INTERFACE:AXI4,
    MEMORY_TYPE:LRAM,
    REGMODE_S0:true,
    ATOMIC_ACCESS_EN_S0:true$sysmem_init
  }] \
  -ip_iname "sysmem0_inst"

adi_ip_instance -vlnv {analog.com:ip:axi_sysid0:1.0} \
  -meta_vlnv {analog.com:ip:axi_sysid:1.0} \
  -cfg_value {
    ROM_ADDR_BITS:9,
    ROM_WIDTH:32
  } \
  -ip_iname "axi_sysid0_inst"

adi_ip_instance -vlnv {analog.com:ip:sysid_rom0:1.0} \
  -meta_vlnv {analog.com:ip:sysid_rom:1.0} \
  -cfg_value [subst {
    ROM_ADDR_BITS:9,
    ROM_WIDTH:32,
    PATH_TO_FILE:[pwd]/mem_init_sys.txt
  }] \
  -ip_iname "sysid_rom0_inst"

sbp_add_gluelogic -name equation_module_inst \
  -logicinfo [sbp_create_glue_logic equation equation_module {} { {
    "expr": "A & B",
    "module_name": "equation_module0"
  }}]

sbp_add_port -direction in clk_125
sbp_add_port -direction in rstn_i
sbp_add_port -direction in rxd_i
sbp_add_port -direction out txd_o

sbp_add_port -from 31 -to 0 -direction out gpio0_o
sbp_add_port -from 31 -to 0 -direction in gpio0_i
sbp_add_port -from 31 -to 0 -direction out gpio0_en_o

sbp_add_port -from 31 -to 0 -direction out gpio1_o
sbp_add_port -from 31 -to 0 -direction in gpio1_i
sbp_add_port -from 31 -to 0 -direction out gpio1_en_o

sbp_add_port -direction out mosi_o
sbp_add_port -direction out sclk_o
sbp_add_port -direction in  miso_i
sbp_add_port -from 0 -to 0 -direction out ssn_o

sbp_add_port -direction inout scl_io
sbp_add_port -direction inout sda_io

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
  "$project_name/spi0_inst/rst_n_i" \
  "$project_name/i2c0_inst/rst_n_i" \
  "$project_name/gpio0_inst/resetn_i" \
  "$project_name/gpio1_inst/resetn_i" \
  "$project_name/axi_sysid0_inst/s_axi_aresetn" \
  "$project_name/uart0_inst/rst_n_i"

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
  "$project_name/spi0_inst/clk_i" \
  "$project_name/i2c0_inst/clk_i" \
  "$project_name/gpio0_inst/clk_i" \
  "$project_name/gpio1_inst/clk_i" \
  "$project_name/axi_sysid0_inst/s_axi_aclk" \
  "$project_name/sysid_rom0_inst/clk" \
  "$project_name/uart0_inst/clk_i"

sbp_connect_net  $project_name/axi_sysid0_inst/rom_addr \
  $project_name/sysid_rom0_inst/rom_addr
sbp_connect_net  $project_name/axi_sysid0_inst/sys_rom_data \
  $project_name/sysid_rom0_inst/rom_data

sbp_connect_net $project_name/rxd_i $project_name/uart0_inst/rxd_i
sbp_connect_net $project_name/txd_o $project_name/uart0_inst/txd_o

sbp_connect_net "$project_name/gpio0_inst/gpio_i" \
  "$project_name/gpio0_i"
sbp_connect_net "$project_name/gpio0_inst/gpio_o" \
  "$project_name/gpio0_o"
sbp_connect_net "$project_name/gpio0_inst/gpio_en_o" \
  "$project_name/gpio0_en_o"

sbp_connect_net "$project_name/gpio1_inst/gpio_i" \
  "$project_name/gpio1_i"
sbp_connect_net "$project_name/gpio1_inst/gpio_o" \
  "$project_name/gpio1_o"
sbp_connect_net "$project_name/gpio1_inst/gpio_en_o" \
  "$project_name/gpio1_en_o"

sbp_connect_net "$project_name/i2c0_inst/scl_io" \
  "$project_name/scl_io"
sbp_connect_net "$project_name/i2c0_inst/sda_io" \
  "$project_name/sda_io"

sbp_connect_net "$project_name/spi0_inst/mosi_o" \
  "$project_name/mosi_o"
sbp_connect_net "$project_name/spi0_inst/miso_i" \
  "$project_name/miso_i"
sbp_connect_net "$project_name/spi0_inst/sclk_o" \
  "$project_name/sclk_o"
sbp_connect_net "$project_name/spi0_inst/ssn_o" \
  "$project_name/ssn_o"


sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_M00" \
  "$project_name/sysmem0_inst/AXI_S0"
sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_M01" \
  "$project_name/axi_apb0_inst/AXI4_S"
sbp_connect_interface_net "$project_name/axi_apb0_inst/APB3_M" \
  "$project_name/apb_interconnect0_inst/APB_S00"
sbp_connect_interface_net "$project_name/apb_interconnect0_inst/APB_M00" \
  "$project_name/uart0_inst/APB_S0"
sbp_connect_interface_net "$project_name/apb_interconnect0_inst/APB_M01" \
  "$project_name/spi0_inst/APB_S0"
sbp_connect_interface_net "$project_name/axi_interc0_inst/AXIL_M02" \
  "$project_name/axi_sysid0_inst/s_axi"
sbp_connect_interface_net "$project_name/apb_interconnect0_inst/APB_M02" \
  "$project_name/i2c0_inst/APB_S0"
sbp_connect_interface_net "$project_name/apb_interconnect0_inst/APB_M03" \
  "$project_name/gpio0_inst/APB_S0"
sbp_connect_interface_net "$project_name/apb_interconnect0_inst/APB_M04" \
  "$project_name/gpio1_inst/APB_S0"
sbp_connect_interface_net "$project_name/cpu0_inst/AXI_M_DATA" \
  "$project_name/axi_interc0_inst/AXI_S00"
sbp_connect_interface_net "$project_name/cpu0_inst/AXI_M_INSTR" \
  "$project_name/axi_interc0_inst/AXI_S01"
sbp_connect_interface_net "$project_name/uart0_inst/INT_M0" \
  "$project_name/cpu0_inst/IRQ_S2"
sbp_connect_interface_net "$project_name/spi0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S3"
sbp_connect_interface_net "$project_name/i2c0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S4"
sbp_connect_interface_net "$project_name/gpio0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S5"
sbp_connect_interface_net "$project_name/gpio1_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S6"

sbp_assign_addr_seg -offset 'h40000000 "$project_name/apb_interconnect0_inst/APB_M00" \
  "$project_name/uart0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h40001000 "$project_name/apb_interconnect0_inst/APB_M01" \
  "$project_name/spi0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h40002000 "$project_name/apb_interconnect0_inst/APB_M02" \
  "$project_name/i2c0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h40003000 "$project_name/apb_interconnect0_inst/APB_M03" \
  "$project_name/gpio0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h40004000 "$project_name/apb_interconnect0_inst/APB_M04" \
  "$project_name/gpio1_inst/APB_S0"
sbp_assign_addr_seg -offset 'h40010000 "$project_name/axi_interc0_inst/AXIL_M02" \
  "$project_name/axi_sysid0_inst/s_axi"

sbp_assign_addr_seg -offset 'h00000000 "$project_name/axi_interc0_inst/AXI_M00" \
  "$project_name/sysmem0_inst/AXI_S0"

if {$timer_en == 1} {
  adi_ip_update $project_name -vlnv {latticesemi.com:module:apb_interconnect0:1.2.1} \
    -meta_vlnv {latticesemi.com:module:apb_interconnect:1.2.1} \
    -cfg_value {TOTAL_MASTER_CNT:1,TOTAL_SLAVE_CNT:6} \
    -ip_iname "apb_interconnect0_inst"

  adi_ip_instance -vlnv {latticesemi.com:ip:timer0:1.4.0} \
    -meta_vlnv {latticesemi.com:ip:gp_timer:1.4.0} \
    -cfg_value {
      t1_cnt_up: count-up,
      T1_PERIOD_WIDTH: 32,
      t1_period_val: 0,
      t1_dis_pscaler: false,
      t2_cnt_up: count-up,
      T2_PERIOD_WIDTH: 32,
      t2_period_val: 0,
      t2_dis_pscaler: false,
      t3_cnt_up: count-up,
      T3_PERIOD_WIDTH: 32,
      t3_period_val: 0,
      t4_cnt_up: count-up,
      T4_PERIOD_WIDTH: 32,
      t4_period_val: 0
    } \
    -ip_iname "timer0_inst"

  sbp_connect_net -name [sbp_get_nets -from $project_name/pll0_inst *clkop*] \
    "$project_name/timer0_inst/clk_i"

  sbp_connect_net -name [sbp_get_nets -from $project_name/cpu0_inst *resetn*] \
    "$project_name/timer0_inst/rst_n_i"

  sbp_connect_interface_net "$project_name/apb_interconnect0_inst/APB_M04" \
    "$project_name/timer0_inst/APB_S0"

  sbp_connect_interface_net "$project_name/timer0_inst/INTR" \
    "$project_name/cpu0_inst/IRQ_S6"

  sbp_assign_addr_seg -offset 'h40005000 "$project_name/apb_interconnect0_inst/APB_M04" \
    "$project_name/timer0_inst/APB_S0"
}
