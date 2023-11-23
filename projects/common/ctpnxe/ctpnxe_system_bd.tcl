###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

########### This file contains only the tcl commands for importing lib ########
########### components and the assemly of the design. #########################

set preinst_ip_mod_dir ${env(TOOLRTF)}
set ip_download_path ${env(USERPROFILE)}/PropelIPLocal
set conf_dir $ad_hdl_dir/projects/common/ctpnxe/ipcfg

## configure ip components and add to design. #################################
adi_ip_instance -vlnv {latticesemi.com:ip:cpu0:2.4.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_riscv_mc_2.4.0" \
  -ip_params {
    "SIMULATION": false,
    "DEBUG_ENABLE": true,
    "M_STANDALONE": true,
    "IRQ_NUM": 6
  } \
  -ip_iname "cpu0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:gpio0:1.6.1} \
  -ip_path "$ip_download_path/latticesemi.com_ip_gpio_1.6.1" \
  -ip_params {
    "IO_LINES_COUNT": 32,
    "DIRECTION_DEF_VAL_INPUT": "FF"
  } \
  -ip_iname "gpio0_inst"
  adi_ip_instance -vlnv {latticesemi.com:ip:gpio1:1.6.1} \
  -ip_path "$ip_download_path/latticesemi.com_ip_gpio_1.6.1" \
  -ip_params {
    "IO_LINES_COUNT": 32,
    "DIRECTION_DEF_VAL_INPUT": "FF"
  } \
  -ip_iname "gpio1_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:uart0:1.3.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_uart_1.3.0" \
  -ip_params {
    "SYS_CLOCK_FREQ": 18.0
  } \
  -ip_iname "uart0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:spi0:1.4.1} \
  -ip_path "$ip_download_path/latticesemi.com_ip_spi_master_1.4.1" \
  -ip_params {
    "DATA_WIDTH": 8,
    "CPOL": 1,
    "CPHA": 1,
    "FIFO_DEPTH": 256,
    "SYS_CLOCK_FREQ": 108.0
  } \
  -ip_iname "spi0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:i2c0:1.5.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_i2c_master_1.5.0" \
  -ip_params {
    "SYS_CLOCK_FREQ": 18
  } \
  -ip_iname "i2c0_inst"

adi_ip_instance -vlnv {latticesemi.com:module:pll0:1.7.0} \
  -ip_path "$preinst_ip_mod_dir/ip/lifcl/pll" \
  -ip_params {
    "gui_en_frac_n": false,
    "gui_en_ssc": false,
    "gui_en_int_fbkdel_sel": false,
    "gui_refclk_freq": 18.0,
    "gui_clk_op_freq": 108.0,
    "gui_clk_op_tol": 0.0,
    "gui_clk_os_en": true,
    "gui_clk_os_freq": 18.0,
    "gui_en_pll_reset": true,
    "gui_en_pll_lock": true
  } \
  -ip_iname "pll0_inst"
adi_ip_instance -vlnv {latticesemi.com:module:osc0:1.4.0} \
  -ip_path "$preinst_ip_mod_dir/ip/lifcl/osc" \
  -ip_params {
    "HF_CLK_FREQ": 18.0
  } \
  -ip_iname "osc0_inst"
adi_ip_instance -vlnv {latticesemi.com:module:ahbl0:1.3.0} \
  -ip_path "$preinst_ip_mod_dir/ip/common/ahb_lite_interconnect" \
  -ip_params {
    "TOTAL_MASTER_CNT": 1,
    "TOTAL_SLAVE_CNT": 4
  } \
  -ip_iname "ahbl0_inst"
adi_ip_instance -vlnv {latticesemi.com:module:ahbl2apb0:1.1.0} \
  -ip_path "$preinst_ip_mod_dir/ip/common/ahb_lite_to_apb_bridge" \
  -ip_params {
    "APB_CLK_EN": true
  } \
  -ip_iname "ahbl2apb0_inst"
adi_ip_instance -vlnv {latticesemi.com:module:apb0:1.2.0} \
  -ip_path "$preinst_ip_mod_dir/ip/common/apb_interconnect" \
  -ip_params {
    "TOTAL_MASTER_CNT": 1,
    "TOTAL_SLAVE_CNT": 4
  } \
  -ip_iname "apb0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:sysmem0:1.1.2} \
  -ip_path "$preinst_ip_mod_dir/ip/common/system_memory" \
  -ip_params {
    "ADDR_DEPTH": 8192,
    "PORT_COUNT": 2,
    "INIT_MEM": false,
    "REGMODE_S0": true,
    "REGMODE_S1": true
  } \
  -ip_iname "sysmem0_inst"

sbp_add_gluelogic -name equation_module0_inst \
  -logicinfo [sbp_create_glue_logic equation equation_module0 {} { {
    "expr": "A & B",
    "module_name": "equation_module0"
  }}]

sbp_add_port -direction in rstn_i
sbp_add_port -direction in rxd_i
sbp_add_port -direction out txd_o
sbp_add_port -from 31 -to 0 -direction inout gpio
sbp_add_port -from 31 -to 0 -direction inout gpio_eval

sbp_add_port -direction out mosi_o
sbp_add_port -direction out sclk_o
sbp_add_port -direction in  miso_i
sbp_add_port -from 0 -to 0 -direction out ssn_o

sbp_add_port -direction inout scl_io
sbp_add_port -direction inout sda_io


sbp_connect_net "$project_name/equation_module0_inst/O" \
  "$project_name/cpu0_inst/rst_n_i"

sbp_connect_net "$project_name/osc0_inst/hf_clk_out_o" \
  "$project_name/pll0_inst/clki_i"

sbp_connect_net "$project_name/pll0_inst/clkos_o" \
  "$project_name/ahbl2apb0_inst/pclk_i" \
  "$project_name/apb0_inst/apb_pclk_i" \
  "$project_name/uart0_inst/clk_i" \
  "$project_name/gpio0_inst/clk_i" \
  "$project_name/gpio1_inst/clk_i" \
  "$project_name/i2c0_inst/clk_i"

sbp_connect_net "$project_name/pll0_inst/lock_o" \
  "$project_name/equation_module0_inst/B"

sbp_connect_net "$project_name/equation_module0_inst/A" \
  "$project_name/pll0_inst/rstn_i" "$project_name/rstn_i"

sbp_connect_net "$project_name/uart0_inst/rxd_i" \
  "$project_name/rxd_i"
sbp_connect_net "$project_name/uart0_inst/txd_o" \
  "$project_name/txd_o"

sbp_connect_net "$project_name/gpio0_inst/gpio_io" \
  "$project_name/gpio"
sbp_connect_net "$project_name/gpio1_inst/gpio_io" \
  "$project_name/gpio_eval"

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

sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M00" \
  "$project_name/sysmem0_inst/AHBL_S1"
sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M01" \
  "$project_name/ahbl2apb0_inst/AHBL_S0"
sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M02" \
  "$project_name/spi0_inst/AHBL_S0"
sbp_connect_interface_net "$project_name/ahbl2apb0_inst/APB_M0" \
  "$project_name/apb0_inst/APB_S00"
sbp_connect_interface_net "$project_name/apb0_inst/APB_M00" \
  "$project_name/uart0_inst/APB_S0"
sbp_connect_interface_net "$project_name/apb0_inst/APB_M01" \
  "$project_name/gpio0_inst/APB_S0"
sbp_connect_interface_net "$project_name/apb0_inst/APB_M02" \
  "$project_name/i2c0_inst/APB_S0"
sbp_connect_interface_net "$project_name/apb0_inst/APB_M03" \
  "$project_name/gpio1_inst/APB_S0"
sbp_connect_interface_net "$project_name/cpu0_inst/AHBL_M0_INSTR" \
  "$project_name/sysmem0_inst/AHBL_S0"
sbp_connect_interface_net "$project_name/cpu0_inst/AHBL_M1_DATA" \
  "$project_name/ahbl0_inst/AHBL_S00"
sbp_connect_interface_net "$project_name/gpio0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S1"
sbp_connect_interface_net "$project_name/uart0_inst/INT_M0" \
  "$project_name/cpu0_inst/IRQ_S0"
sbp_connect_interface_net "$project_name/spi0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S2"
sbp_connect_interface_net "$project_name/i2c0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S3"
sbp_connect_interface_net "$project_name/gpio1_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S4"

sbp_connect_constant -constant 1'B1 "$project_name/osc0_inst/hf_out_en_i"

sbp_assign_addr_seg -offset 'h00000000 "$project_name/ahbl0_inst/AHBL_M00" \
  "$project_name/sysmem0_inst/AHBL_S1"
sbp_assign_addr_seg -offset 'h00000000 "$project_name/cpu0_inst/AHBL_M0_INSTR" \
  "$project_name/sysmem0_inst/AHBL_S0"
sbp_assign_addr_seg -offset 'h00008000 "$project_name/apb0_inst/APB_M00" \
  "$project_name/uart0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h00008400 "$project_name/apb0_inst/APB_M01" \
  "$project_name/gpio0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h00008800 "$project_name/apb0_inst/APB_M02" \
  "$project_name/i2c0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h00008C00 "$project_name/ahbl0_inst/AHBL_M02" \
  "$project_name/spi0_inst/AHBL_S0"
sbp_assign_addr_seg -offset 'h00018000 "$project_name/apb0_inst/APB_M03" \
  "$project_name/gpio1_inst/APB_S0"

#sbp_design auto_assign_addresses
