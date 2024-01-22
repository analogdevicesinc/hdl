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
    "IRQ_NUM": 5
  } \
  -ip_iname "cpu0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:gpio0:1.6.1} \
  -ip_path "$ip_download_path/latticesemi.com_ip_gpio_1.6.1" \
  -ip_params {
    "IO_LINES_COUNT": 32,
    "EXTERNAL_BUF": true,
    "DIRECTION_DEF_VAL_INPUT": "00FFFFFF"
  } \
  -ip_iname "gpio0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:gpio1:1.6.1} \
  -ip_path "$ip_download_path/latticesemi.com_ip_gpio_1.6.1" \
  -ip_params {
    "IO_LINES_COUNT": 32,
    "EXTERNAL_BUF": true,
    "DIRECTION_DEF_VAL_INPUT": "00000000"
  } \
  -ip_iname "gpio1_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:uart0:1.3.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_uart_1.3.0" \
  -ip_params {
    "SYS_CLOCK_FREQ": 75.0
  } \
  -ip_iname "uart0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:spi0:1.4.1} \
  -ip_path "$ip_download_path/latticesemi.com_ip_spi_master_1.4.1" \
  -ip_params {
    "DATA_WIDTH": 8,
    "FIFO_DEPTH": 256,
    "SYS_CLOCK_FREQ": 75.0
  } \
  -ip_iname "spi0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:i2c0:1.5.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_i2c_master_1.5.0" \
  -ip_params {
    "SYS_CLOCK_FREQ": 75
  } \
  -ip_iname "i2c0_inst"

adi_ip_instance -vlnv {latticesemi.com:module:pll0:1.7.0} \
  -ip_path "$preinst_ip_mod_dir/ip/lifcl/pll" \
  -ip_params {
    "gui_en_frac_n": false,
    "gui_en_ssc": false,
    "gui_en_int_fbkdel_sel": false,
    "gui_refclk_freq": 125.0,
    "gui_clk_op_freq": 75.0,
    "gui_clk_op_tol": 0.0,
    "gui_clk_os_en": false,
    "gui_clk_os_freq": 25.0,
    "gui_en_pll_reset": true,
    "gui_en_pll_lock": true
  } \
  -ip_iname "pll0_inst"

adi_ip_instance -vlnv {latticesemi.com:module:ahbl0:1.3.0} \
  -ip_path "$preinst_ip_mod_dir/ip/common/ahb_lite_interconnect" \
  -ip_params {
    "TOTAL_MASTER_CNT": 2,
    "TOTAL_SLAVE_CNT": 5
  } \
  -ip_iname "ahbl0_inst"
adi_ip_instance -vlnv {latticesemi.com:module:ahbl2apb0:1.1.0} \
  -ip_path "$preinst_ip_mod_dir/ip/common/ahb_lite_to_apb_bridge" \
  -ip_params {
    "APB_CLK_EN": false
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
    "ADDR_DEPTH": 32768,
    "MEMORY_TYPE": "LRAM",
    "PORT_COUNT": 2,
    "INIT_MEM": false,
    "REGMODE_S0": true,
    "REGMODE_S1": true
  } \
  -ip_iname "sysmem0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:isr_ram0:1.1.2} \
  -ip_path "$preinst_ip_mod_dir/ip/common/system_memory" \
  -ip_params {
    "ADDR_DEPTH": 8192,
    "MEMORY_TYPE": "EBR",
    "REGMODE_S0": true
  } \
  -ip_iname "isr_ram0_inst"
#     "INIT_FILE": "../../noos_template_ctpnxe.mem",
sbp_add_gluelogic -name equation_module0_inst \
  -logicinfo [sbp_create_glue_logic equation equation_module0 {} { {
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

sbp_connect_net "$project_name/cpu0_inst/system_resetn_o" \
  "$project_name/ahbl2apb0_inst/rst_n_i" \
  "$project_name/apb0_inst/apb_presetn_i" \
  "$project_name/uart0_inst/rst_n_i" \
  "$project_name/ahbl0_inst/ahbl_hresetn_i" \
  "$project_name/gpio0_inst/resetn_i" \
  "$project_name/gpio1_inst/resetn_i" \
  "$project_name/sysmem0_inst/ahbl_hresetn_i" \
  "$project_name/isr_ram0_inst/ahbl_hresetn_i" \
  "$project_name/spi0_inst/rst_n_i" \
  "$project_name/i2c0_inst/rst_n_i"

sbp_connect_net "$project_name/equation_module0_inst/O" \
  "$project_name/cpu0_inst/rst_n_i"

sbp_connect_net "$project_name/clk_125" \
  "$project_name/pll0_inst/clki_i"

sbp_connect_net "$project_name/pll0_inst/clkop_o" \
  "$project_name/ahbl2apb0_inst/clk_i" \
  "$project_name/ahbl0_inst/ahbl_hclk_i" \
  "$project_name/cpu0_inst/clk_i" \
  "$project_name/sysmem0_inst/ahbl_hclk_i" \
  "$project_name/isr_ram0_inst/ahbl_hclk_i" \
  "$project_name/spi0_inst/clk_i" \
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

sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M00" \
  "$project_name/isr_ram0_inst/AHBL_S0"
sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M01" \
  "$project_name/sysmem0_inst/AHBL_S0"
sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M04" \
  "$project_name/sysmem0_inst/AHBL_S1"
sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M02" \
  "$project_name/ahbl2apb0_inst/AHBL_S0"
sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M03" \
  "$project_name/spi0_inst/AHBL_S0"
sbp_connect_interface_net "$project_name/ahbl2apb0_inst/APB_M0" \
  "$project_name/apb0_inst/APB_S00"
sbp_connect_interface_net "$project_name/apb0_inst/APB_M00" \
  "$project_name/uart0_inst/APB_S0"
sbp_connect_interface_net "$project_name/apb0_inst/APB_M01" \
  "$project_name/gpio0_inst/APB_S0"
sbp_connect_interface_net "$project_name/apb0_inst/APB_M03" \
  "$project_name/gpio1_inst/APB_S0"
sbp_connect_interface_net "$project_name/apb0_inst/APB_M02" \
  "$project_name/i2c0_inst/APB_S0"
sbp_connect_interface_net "$project_name/cpu0_inst/AHBL_M0_INSTR" \
  "$project_name/ahbl0_inst/AHBL_S01"
sbp_connect_interface_net "$project_name/cpu0_inst/AHBL_M1_DATA" \
  "$project_name/ahbl0_inst/AHBL_S00"
sbp_connect_interface_net "$project_name/gpio0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S1"
sbp_connect_interface_net "$project_name/gpio1_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S4"
sbp_connect_interface_net "$project_name/uart0_inst/INT_M0" \
  "$project_name/cpu0_inst/IRQ_S0"
sbp_connect_interface_net "$project_name/spi0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S2"
sbp_connect_interface_net "$project_name/i2c0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S3"

# sbp_assign_addr_seg -offset 'h00190000 "$project_name/ahbl0_inst/AHBL_M00" \
sbp_assign_addr_seg -offset 'h00000000 "$project_name/ahbl0_inst/AHBL_M00" \
  "$project_name/isr_ram0_inst/AHBL_S0"
sbp_assign_addr_seg -offset 'h000C0000 "$project_name/ahbl0_inst/AHBL_M01" \
  "$project_name/sysmem0_inst/AHBL_S0"
sbp_assign_addr_seg -offset 'h000E0000 "$project_name/ahbl0_inst/AHBL_M04" \
  "$project_name/sysmem0_inst/AHBL_S1"

sbp_assign_addr_seg -offset 'h00186000 "$project_name/apb0_inst/APB_M02" \
  "$project_name/i2c0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h00186400 "$project_name/apb0_inst/APB_M00" \
  "$project_name/uart0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h00186800 "$project_name/ahbl0_inst/AHBL_M03" \
  "$project_name/spi0_inst/AHBL_S0"
sbp_assign_addr_seg -offset 'h00186C00 "$project_name/apb0_inst/APB_M01" \
  "$project_name/gpio0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h00187000 "$project_name/apb0_inst/APB_M03" \
  "$project_name/gpio1_inst/APB_S0"

# sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M00" \
#   "$project_name/sysmem0_inst/AHBL_S1"
# sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M01" \
#   "$project_name/ahbl2apb0_inst/AHBL_S0"
# sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M02" \
#   "$project_name/spi0_inst/AHBL_S0"
# sbp_connect_interface_net "$project_name/ahbl2apb0_inst/APB_M0" \
#   "$project_name/apb0_inst/APB_S00"
# sbp_connect_interface_net "$project_name/apb0_inst/APB_M00" \
#   "$project_name/uart0_inst/APB_S0"
# sbp_connect_interface_net "$project_name/apb0_inst/APB_M01" \
#   "$project_name/gpio0_inst/APB_S0"
# sbp_connect_interface_net "$project_name/apb0_inst/APB_M02" \
#   "$project_name/i2c0_inst/APB_S0"
# sbp_connect_interface_net "$project_name/cpu0_inst/AHBL_M0_INSTR" \
#   "$project_name/sysmem0_inst/AHBL_S0"
# sbp_connect_interface_net "$project_name/cpu0_inst/AHBL_M1_DATA" \
#   "$project_name/ahbl0_inst/AHBL_S00"
# sbp_connect_interface_net "$project_name/gpio0_inst/INTR" \
#   "$project_name/cpu0_inst/IRQ_S1"
# sbp_connect_interface_net "$project_name/uart0_inst/INT_M0" \
#   "$project_name/cpu0_inst/IRQ_S0"
# sbp_connect_interface_net "$project_name/spi0_inst/INTR" \
#   "$project_name/cpu0_inst/IRQ_S2"
# sbp_connect_interface_net "$project_name/i2c0_inst/INTR" \
#   "$project_name/cpu0_inst/IRQ_S3"
# sbp_connect_interface_net "$project_name/gpio1_inst/INTR" \
#   "$project_name/cpu0_inst/IRQ_S4"
# sbp_connect_interface_net "$project_name/apb0_inst/APB_M03" \
#   "$project_name/gpio1_inst/APB_S0"

# sbp_connect_constant -constant 1'B1 "$project_name/osc0_inst/hf_out_en_i"

# sbp_assign_addr_seg -offset 'h00000000 "$project_name/cpu0_inst/AHBL_M0_INSTR" \
#   "$project_name/sysmem0_inst/AHBL_S0"
# sbp_assign_addr_seg -offset 'h00008400 "$project_name/apb0_inst/APB_M01" \
#   "$project_name/gpio0_inst/APB_S0"
# sbp_assign_addr_seg -offset 'h00008800 "$project_name/apb0_inst/APB_M02" \
#   "$project_name/i2c0_inst/APB_S0"
# sbp_assign_addr_seg -offset 'h00008C00 "$project_name/ahbl0_inst/AHBL_M02" \
#   "$project_name/spi0_inst/AHBL_S0"
# sbp_assign_addr_seg -offset 'h00000000 "$project_name/ahbl0_inst/AHBL_M00" \
#   "$project_name/sysmem0_inst/AHBL_S1"
# sbp_assign_addr_seg -offset 'h00008000 "$project_name/apb0_inst/APB_M00" \
#   "$project_name/uart0_inst/APB_S0"
# sbp_assign_addr_seg -offset 'h00009000 "$project_name/apb0_inst/APB_M03" \
#   "$project_name/gpio1_inst/APB_S0"

#sbp_design auto_assign_addresses
