###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

########### This file contains only the tcl commands for importing lib ########
########### components and the assemly of the design. #########################

set preinst_ip_mod_dir ${env(TOOLRTF)}
set ip_download_path ${env(USERPROFILE)}/PropelIPLocal
set conf_dir $ad_hdl_dir/projects/common/ctpnxe/ipcfg

#config libraries from library sources and config options
sbp_design config_ip -vlnv {latticesemi.com:ip:cpu0:2.4.0} \
  -meta_loc "$ip_download_path/latticesemi.com_ip_riscv_mc_2.4.0" \
  -cfg "$conf_dir/cpu0.cfg"
sbp_design config_ip -vlnv {latticesemi.com:ip:gpio0:1.6.1} \
  -meta_loc "$ip_download_path/latticesemi.com_ip_gpio_1.6.1" \
  -cfg "$conf_dir/gpio0.cfg"
sbp_design config_ip -vlnv {latticesemi.com:ip:uart0:1.3.0} \
  -meta_loc "$ip_download_path/latticesemi.com_ip_uart_1.3.0" \
  -cfg "$conf_dir/uart0.cfg"
sbp_design config_ip -vlnv {latticesemi.com:ip:spi0:1.4.1} \
  -meta_loc "$ip_download_path/latticesemi.com_ip_spi_master_1.4.1" \
  -cfg "$conf_dir/spi0.cfg"
sbp_design config_ip -vlnv {latticesemi.com:ip:i2c0:1.5.0} \
  -meta_loc "$ip_download_path/latticesemi.com_ip_i2c_master_1.5.0" \
  -cfg "$conf_dir/i2c0.cfg"

sbp_design config_ip -vlnv {latticesemi.com:module:pll0:1.7.0} \
  -meta_loc "$preinst_ip_mod_dir/ip/lifcl/pll" \
  -cfg "$conf_dir/pll0.cfg"
sbp_design config_ip -vlnv {latticesemi.com:module:osc0:1.4.0} \
  -meta_loc "$preinst_ip_mod_dir/ip/lifcl/osc" \
  -cfg "$conf_dir/osc0.cfg"
sbp_design config_ip -vlnv {latticesemi.com:module:ahbl0:1.3.0} \
  -meta_loc "$preinst_ip_mod_dir/ip/common/ahb_lite_interconnect" \
  -cfg "$conf_dir/ahbl0.cfg"
sbp_design config_ip -vlnv {latticesemi.com:module:ahbl2apb0:1.1.0} \
  -meta_loc "$preinst_ip_mod_dir/ip/common/ahb_lite_to_apb_bridge" \
  -cfg "$conf_dir/ahbl2apb0.cfg"
sbp_design config_ip -vlnv {latticesemi.com:module:apb0:1.2.0} \
  -meta_loc "$preinst_ip_mod_dir/ip/common/apb_interconnect" \
  -cfg "$conf_dir/apb0.cfg"
sbp_design config_ip -vlnv {latticesemi.com:ip:sysmem0:1.1.2} \
  -meta_loc "$preinst_ip_mod_dir/ip/common/system_memory" \
  -cfg "$conf_dir/sysmem0.cfg"

sbp_add_component -vlnv {latticesemi.com:ip:cpu0:2.4.0} -name cpu0_inst
sbp_add_component -vlnv {latticesemi.com:ip:gpio0:1.6.1} -name gpio0_inst
sbp_add_component -vlnv {latticesemi.com:ip:sysmem0:1.1.2} -name sysmem0_inst
sbp_add_component -vlnv {latticesemi.com:ip:uart0:1.3.0} -name uart0_inst
sbp_add_component -vlnv {latticesemi.com:module:ahbl0:1.3.0} -name ahbl0_inst
sbp_add_component -vlnv {latticesemi.com:module:ahbl2apb0:1.1.0} \
	-name ahbl2apb0_inst
sbp_add_component -vlnv {latticesemi.com:module:apb0:1.2.0} -name apb0_inst
sbp_add_component -vlnv {latticesemi.com:module:osc0:1.4.0} -name osc0_inst
sbp_add_component -vlnv {latticesemi.com:module:pll0:1.7.0} -name pll0_inst
sbp_add_component -vlnv {latticesemi.com:ip:spi0:1.4.1} -name spi0_inst
sbp_add_component -vlnv {latticesemi.com:ip:i2c0:1.5.0} -name i2c0_inst

sbp_add_gluelogic -name equation_module0_inst \
  -logicinfo [sbp_create_glue_logic equation equation_module0 {} { {
    "expr": "A & B",
    "module_name": "equation_module0"
  }}]

sbp_add_port -direction in rstn_i
sbp_add_port -direction in rxd_i
sbp_add_port -direction out txd_o
sbp_add_port -from 31 -to 0 -direction inout gpio

sbp_add_port -direction out mosi_o
sbp_add_port -direction out sclk_o
sbp_add_port -direction in  miso_i
sbp_add_port -from 0 -to 0 -direction out ssn_o

sbp_add_port -direction inout scl_io
sbp_add_port -direction inout sda_io

sbp_connect_net "$project_name/cpu0_inst/system_resetn_o" \
  "$project_name/ahbl2apb0_inst/presetn_i" \
  "$project_name/ahbl2apb0_inst/rst_n_i" \
  "$project_name/apb0_inst/apb_presetn_i" \
  "$project_name/uart0_inst/rst_n_i" \
  "$project_name/ahbl0_inst/ahbl_hresetn_i" \
  "$project_name/gpio0_inst/resetn_i" \
  "$project_name/sysmem0_inst/ahbl_hresetn_i" \
  "$project_name/spi0_inst/rst_n_i" \
  "$project_name/i2c0_inst/rst_n_i"

sbp_connect_net "$project_name/equation_module0_inst/O" \
  "$project_name/cpu0_inst/rst_n_i"

sbp_connect_net "$project_name/osc0_inst/hf_clk_out_o" \
  "$project_name/pll0_inst/clki_i"

sbp_connect_net "$project_name/pll0_inst/clkop_o" \
  "$project_name/ahbl2apb0_inst/clk_i" \
  "$project_name/ahbl0_inst/ahbl_hclk_i" \
  "$project_name/cpu0_inst/clk_i" \
  "$project_name/sysmem0_inst/ahbl_hclk_i"  \
  "$project_name/spi0_inst/clk_i"

sbp_connect_net "$project_name/pll0_inst/clkos_o" \
  "$project_name/ahbl2apb0_inst/pclk_i" \
  "$project_name/apb0_inst/apb_pclk_i" \
  "$project_name/uart0_inst/clk_i" \
  "$project_name/gpio0_inst/clk_i" \
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

sbp_connect_constant -constant 1'B1 "$project_name/osc0_inst/hf_out_en_i"

sbp_assign_addr_seg -offset 'h00000000 "$project_name/cpu0_inst/AHBL_M0_INSTR" \
  "$project_name/sysmem0_inst/AHBL_S0"
sbp_assign_addr_seg -offset 'h00008400 "$project_name/apb0_inst/APB_M01" \
  "$project_name/gpio0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h00008800 "$project_name/apb0_inst/APB_M02" \
  "$project_name/i2c0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h00008C00 "$project_name/ahbl0_inst/AHBL_M02" \
  "$project_name/spi0_inst/AHBL_S0"
sbp_assign_addr_seg -offset 'h00000000 "$project_name/ahbl0_inst/AHBL_M00" \
  "$project_name/sysmem0_inst/AHBL_S1"
sbp_assign_addr_seg -offset 'h00008000 "$project_name/apb0_inst/APB_M00" \
  "$project_name/uart0_inst/APB_S0"

#sbp_design auto_assign_addresses
