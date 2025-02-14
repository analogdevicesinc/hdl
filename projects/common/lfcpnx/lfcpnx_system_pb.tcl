###############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

########### This file contains only the tcl commands for importing lib ########
########### components and the assembly of the design. ########################

set preinst_ip_mod_dir ${env(TOOLRTF)}
set conf_dir $ad_hdl_dir/projects/common/lfcpnx/ipcfg
# If you want to use file path for the adi_ip_instance or adi_ip_update, use the
# -ip_path option and the file path to the ip. The built in modules and IPs can
# be found in the $preinst_ip_mod_dir, the downloaded IPs can be found somewhere
# in the <path_to>/PropelIPLocal directory.
# You can also use the exact text from the <instance_name>.cfg file from an
# already instatiated IP folder from the
# <project_name>/<project_name>/<.lib|lib>/<module|ip>/<instance_name><version>
# folder to configure an IP. For that you have to use the -ip_params option.
# set ip_download_path ${env(USERPROFILE)}/PropelIPLocal # by default on windows

## configure ip components and add to design. #################################
adi_ip_instance -vlnv {latticesemi.com:ip:cpu0:2.4.0} \
  -meta_vlnv {latticesemi.com:ip:riscv_rtos:2.4.0} \
  -cfg_value {
    TCM_ENABLE: true,
    IRQ_NUM: 16,
    UART_EN: true
  } \
  -ip_iname "cpu0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:gpio0:1.6.2} \
  -meta_vlnv {latticesemi.com:ip:gpio:1.6.2} \
  -cfg_value {
    IO_LINES_COUNT: 32,
    EXTERNAL_BUF: true,
    DIRECTION_DEF_VAL_INPUT: 00FFFFFF
  } \
  -ip_iname "gpio0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:gpio1:1.6.2} \
  -meta_vlnv {latticesemi.com:ip:gpio:1.6.2} \
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
    SYS_CLOCK_FREQ: 100
  } \
  -ip_iname "spi0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:i2c0:2.0.1} \
  -meta_vlnv {latticesemi.com:ip:i2c_controller:2.0.1} \
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
    TOTAL_EXTMAS_CNT: 1,
    TOTAL_EXTSLV_CNT: 4,
    EXT_MAS_AXI_ID_WIDTH: 1,
    EXT_SLV_AXI_ID_WIDTH: 8
  } \
  -ip_iname "axi_interc0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_ahb0:1.1.1} \
  -meta_vlnv {latticesemi.com:ip:axi2ahb_bridge:1.1.1} \
  -cfg_value {} \
  -ip_iname "axi_ahb0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_apb0:1.1.1} \
  -meta_vlnv {latticesemi.com:ip:axi2apb_bridge:1.1.1} \
  -cfg_value {} \
  -ip_iname "axi_apb0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_apb1:1.1.1} \
  -meta_vlnv {latticesemi.com:ip:axi2apb_bridge:1.1.1} \
  -cfg_value {} \
  -ip_iname "axi_apb1_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_apb2:1.1.1} \
  -meta_vlnv {latticesemi.com:ip:axi2apb_bridge:1.1.1} \
  -cfg_value {} \
  -ip_iname "axi_apb2_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:sysmem0:2.3.0} \
  -meta_vlnv latticesemi.com:ip:system_memory:2.3.0 \
  -cfg_value {
    INTERFACE: AXI4,
    ADDR_DEPTH: 8192,
    ID_WIDTH: 1,
    REGMODE_S0: true
  } \
  -ip_iname "sysmem0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:tcm0:1.5.0} \
  -meta_vlnv {latticesemi.com:ip:localbus_tcm:1.5.0} \
  -cfg_value {
    PORT_COUNT: 2,
    ADDR_DEPTH_A: 16384,
    ADDR_DEPTH_B: 16384,
    MEM_TYPE: LRAM
  } \
  -ip_iname "tcm0_inst"

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
  "$project_name/tcm0_inst/sys_rst_n" \
  "$project_name/axi_interc0_inst/axi_aresetn_i" \
  "$project_name/axi_ahb0_inst/aresetn_i" \
  "$project_name/axi_apb0_inst/aresetn_i" \
  "$project_name/axi_apb1_inst/aresetn_i" \
  "$project_name/axi_apb2_inst/aresetn_i" \
  "$project_name/spi0_inst/rst_n_i" \
  "$project_name/i2c0_inst/rst_n_i" \
  "$project_name/gpio0_inst/resetn_i" \
  "$project_name/gpio1_inst/resetn_i"

sbp_connect_net "$project_name/clk_125" \
  "$project_name/pll0_inst/clki_i"

sbp_connect_net "$project_name/pll0_inst/clkos_o" \
  "$project_name/cpu0_inst/clk_realtime_i"

sbp_connect_net "$project_name/pll0_inst/clkop_o" \
  "$project_name/cpu0_inst/clk_system_i" \
  "$project_name/sysmem0_inst/axi_aclk_i" \
  "$project_name/axi_interc0_inst/axi_aclk_i" \
  "$project_name/tcm0_inst/sys_clk" \
  "$project_name/axi_ahb0_inst/aclk_i" \
  "$project_name/axi_apb0_inst/aclk_i" \
  "$project_name/axi_apb1_inst/aclk_i" \
  "$project_name/axi_apb2_inst/aclk_i" \
  "$project_name/spi0_inst/clk_i" \
  "$project_name/i2c0_inst/clk_i" \
  "$project_name/gpio0_inst/clk_i" \
  "$project_name/gpio1_inst/clk_i"

sbp_connect_net "$project_name/cpu0_inst/uart_rxd_i" \
  "$project_name/rxd_i"
sbp_connect_net "$project_name/cpu0_inst/uart_txd_o" \
  "$project_name/txd_o"

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
  "$project_name/axi_ahb0_inst/AXI4_S"
sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_M01" \
  "$project_name/axi_apb0_inst/AXI4_S"
sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_M02" \
  "$project_name/axi_apb1_inst/AXI4_S"
sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_M03" \
  "$project_name/axi_apb2_inst/AXI4_S"
sbp_connect_interface_net "$project_name/axi_ahb0_inst/AHBL_M" \
  "$project_name/spi0_inst/AHBL_S0"
sbp_connect_interface_net "$project_name/cpu0_inst/AXI_M_INSTR" \
  "$project_name/sysmem0_inst/AXI_S0"
sbp_connect_interface_net "$project_name/axi_apb0_inst/APB3_M" \
  "$project_name/i2c0_inst/APB_S0"
sbp_connect_interface_net "$project_name/axi_apb1_inst/APB3_M" \
  "$project_name/gpio0_inst/APB_S0"
sbp_connect_interface_net "$project_name/axi_apb2_inst/APB3_M" \
  "$project_name/gpio1_inst/APB_S0"
sbp_connect_interface_net "$project_name/cpu0_inst/AXI_M_DATA" \
  "$project_name/axi_interc0_inst/AXI_S00"
sbp_connect_interface_net "$project_name/cpu0_inst/LOCAL_BUS_M_DATA" \
  "$project_name/tcm0_inst/LOCAL_BUS_DATA"
sbp_connect_interface_net "$project_name/cpu0_inst/LOCAL_BUS_M_INSTR" \
  "$project_name/tcm0_inst/LOCAL_BUS_INSTR"
sbp_connect_interface_net "$project_name/spi0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S2"
sbp_connect_interface_net "$project_name/i2c0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S3"
sbp_connect_interface_net "$project_name/gpio0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S4"
sbp_connect_interface_net "$project_name/gpio1_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S5"

sbp_assign_addr_seg -offset 'h40004000 "$project_name/axi_apb2_inst/APB3_M" \
  "$project_name/gpio1_inst/APB_S0"
sbp_assign_addr_seg -offset 'h40003000 "$project_name/axi_apb1_inst/APB3_M" \
  "$project_name/gpio0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h40002000 "$project_name/axi_apb0_inst/APB3_M" \
  "$project_name/i2c0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h40000000 "$project_name/axi_ahb0_inst/AHBL_M" \
  "$project_name/spi0_inst/AHBL_S0"
sbp_assign_addr_seg -offset 'h00000000 "$project_name/cpu0_inst/LOCAL_BUS_M_DATA" \
  "$project_name/tcm0_inst/LOCAL_BUS_DATA"
sbp_assign_addr_seg -offset 'h00200000 "$project_name/cpu0_inst/AXI_M_INSTR" \
  "$project_name/sysmem0_inst/AXI_S0"
sbp_assign_addr_seg -offset 'h00000000 "$project_name/cpu0_inst/LOCAL_BUS_M_INSTR" \
  "$project_name/tcm0_inst/LOCAL_BUS_INSTR"

if {$timer_en == 1} {
  adi_ip_update $project_name -vlnv {latticesemi.com:ip:axi_interc0:2.0.1} \
    -meta_vlnv {latticesemi.com:ip:axi_interc0:2.0.1} \
    -cfg_value {
      TOTAL_EXTMAS_CNT: 1,
      TOTAL_EXTSLV_CNT: 5,
      EXT_MAS_AXI_ID_WIDTH: 1,
      EXT_SLV_AXI_ID_WIDTH: 8
    } \
    -ip_iname "axi_interc0_inst"

  adi_ip_instance -vlnv {latticesemi.com:ip:axi_apb3:1.1.1} \
    -meta_vlnv {latticesemi.com:ip:axi2apb_bridge:1.1.1} \
    -cfg_value {} \
    -ip_iname "axi_apb3_inst"

  adi_ip_instance -vlnv {latticesemi.com:ip:timer0:1.3.1} \
    -meta_vlnv {latticesemi.com:ip:gp_timer:1.3.1} \
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
    "$project_name/timer0_inst/clk_i" \
    "$project_name/axi_apb3_inst/aclk_i"

  sbp_connect_net -name [sbp_get_nets -from $project_name/cpu0_inst *resetn*] \
    "$project_name/timer0_inst/rst_n_i" \
    "$project_name/axi_apb3_inst/aresetn_i"

  sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_M04" \
    "$project_name/axi_apb3_inst/AXI4_S"

  sbp_connect_interface_net "$project_name/axi_apb3_inst/APB3_M" \
    "$project_name/timer0_inst/APB_S0"

  sbp_connect_interface_net "$project_name/timer0_inst/INTR" \
    "$project_name/cpu0_inst/IRQ_S6"

  sbp_assign_addr_seg -offset 'h40005000 "$project_name/axi_apb3_inst/APB3_M" \
    "$project_name/timer0_inst/APB_S0"
}
