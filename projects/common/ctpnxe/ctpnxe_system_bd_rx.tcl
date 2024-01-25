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
adi_ip_instance -vlnv {latticesemi.com:ip:cpu0:2.3.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_riscv_rtos_2.3.0" \
  -ip_params {
    "TCM_ENABLE": true,
    "IRQ_NUM": 16,
    "UART_EN": true
} \
  -ip_iname "cpu0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:gpio0:1.6.2} \
  -ip_path "$ip_download_path/latticesemi.com_ip_gpio_1.6.2" \
  -ip_params {
    "IO_LINES_COUNT": 32,
    "EXTERNAL_BUF": true,
    "DIRECTION_DEF_VAL_INPUT": "00FFFFFF"
  } \
  -ip_iname "gpio0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:gpio1:1.6.2} \
  -ip_path "$ip_download_path/latticesemi.com_ip_gpio_1.6.2" \
  -ip_params {
    "IO_LINES_COUNT": 32,
    "EXTERNAL_BUF": true,
    "DIRECTION_DEF_VAL_INPUT": "00000000"
  } \
  -ip_iname "gpio1_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:spi0:1.4.1} \
  -ip_path "$ip_download_path/latticesemi.com_ip_spi_master_1.4.1" \
  -ip_params {
    "DATA_WIDTH": 8,
    "FIFO_DEPTH": 256,
    "SYS_CLOCK_FREQ": 100
  } \
  -ip_iname "spi0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:i2c0:1.5.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_i2c_master_1.5.0" \
  -ip_params {
    "SYS_CLOCK_FREQ": 100
  } \
  -ip_iname "i2c0_inst"

adi_ip_instance -vlnv {latticesemi.com:module:pll0:1.8.0} \
  -ip_path "$preinst_ip_mod_dir/ip/lifcl/pll" \
  -ip_params {
    "gui_refclk_freq": 125.0,
    "gui_clk_os_en": true,
    "gui_clk_os_byp": false,
    "gui_clk_os_freq": 10.0
    } \
  -ip_iname "pll0_inst"

adi_ip_instance -vlnv {latticesemi.com:ip:axi_interc0:1.2.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_axi_interconnect_1.2.0" \
  -ip_params {
    "TOTAL_EXTMAS_CNT": 1,
    "TOTAL_EXTSLV_CNT": 4,
    "EXT_MAS_AXI_ID_WIDTH": 1,
    "EXT_SLV_AXI_ID_WIDTH": 8
    } \
  -ip_iname "axi_interc0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_ahb0:1.1.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_axi2ahb_bridge_1.1.0" \
  -ip_params {} \
  -ip_iname "axi_ahb0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_ahb1:1.1.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_axi2ahb_bridge_1.1.0" \
  -ip_params {
    "AXI_ID_WIDTH": 1
    } \
  -ip_iname "axi_ahb1_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_apb0:1.1.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_axi2apb_bridge_1.1.0" \
  -ip_params {} \
  -ip_iname "axi_apb0_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_apb1:1.1.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_axi2apb_bridge_1.1.0" \
  -ip_params {} \
  -ip_iname "axi_apb1_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:axi_apb2:1.1.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_axi2apb_bridge_1.1.0" \
  -ip_params {} \
  -ip_iname "axi_apb2_inst"
adi_ip_instance -vlnv {latticesemi.com:ip:sysmem0:2.1.0} \
  -ip_path "$preinst_ip_mod_dir/ip/common/system_memory" \
  -ip_params {
    "INTERFACE": "AXI4",
    "ADDR_DEPTH": 8192,
    "REGMODE_S0": true
    } \
  -ip_iname "sysmem0_inst"
# sbp_design save
adi_ip_instance -vlnv {latticesemi.com:ip:tcm0:1.3.9} \
  -ip_path "$preinst_ip_mod_dir/ip/common/localbus_tcm" \
  -ip_params {
    "PORT_COUNT": 2,
    "ADDR_DEPTH_A": 16384,
    "ADDR_DEPTH_B": 16384
    } \
  -ip_iname "tcm0_inst"

sbp_add_gluelogic -name equation_module_inst -logicinfo [sbp_create_glue_logic equation equation_module {} { {
 "expr": "A & B",
 "module_name": "equation_module"
}
}]

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

#cpu rst out
sbp_connect_net "$project_name/cpu0_inst/system_resetn_o" \
  "$project_name/sysmem0_inst/axi_resetn_i" \
  "$project_name/tcm0_inst/sys_rst_n" \
  "$project_name/axi_interc0_inst/axi_aresetn_i" \
  "$project_name/axi_ahb0_inst/aresetn_i" \
  "$project_name/axi_ahb1_inst/aresetn_i" \
  "$project_name/axi_apb0_inst/aresetn_i" \
  "$project_name/axi_apb1_inst/aresetn_i" \
  "$project_name/axi_apb2_inst/aresetn_i" \
  "$project_name/spi0_inst/rst_n_i" \
  "$project_name/i2c0_inst/rst_n_i" \
  "$project_name/gpio0_inst/resetn_i" \
  "$project_name/gpio1_inst/resetn_i"

#clk
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
  "$project_name/axi_ahb1_inst/aclk_i" \
  "$project_name/axi_apb0_inst/aclk_i" \
  "$project_name/axi_apb1_inst/aclk_i" \
  "$project_name/axi_apb2_inst/aclk_i" \
  "$project_name/spi0_inst/clk_i" \
  "$project_name/i2c0_inst/clk_i" \
  "$project_name/gpio0_inst/clk_i" \
  "$project_name/gpio1_inst/clk_i"

#rst
sbp_connect_net "$project_name/equation_module_inst/A" \
  "$project_name/pll0_inst/lock_o"
sbp_connect_net "$project_name/equation_module_inst/B" \
  "$project_name/pll0_inst/rstn_i" \
  "$project_name/rstn_i"
sbp_connect_net "$project_name/equation_module_inst/O" \
  "$project_name/cpu0_inst/rstn_i"

#uart
sbp_connect_net "$project_name/cpu0_inst/uart_rxd_i" \
  "$project_name/rxd_i"
sbp_connect_net "$project_name/cpu0_inst/uart_txd_o" \
  "$project_name/txd_o"

#gpio
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

#i2c
sbp_connect_net "$project_name/i2c0_inst/scl_io" \
  "$project_name/scl_io"
sbp_connect_net "$project_name/i2c0_inst/sda_io" \
  "$project_name/sda_io"

#spi
sbp_connect_net "$project_name/spi0_inst/mosi_o" \
  "$project_name/mosi_o"
sbp_connect_net "$project_name/spi0_inst/miso_i" \
  "$project_name/miso_i"
sbp_connect_net "$project_name/spi0_inst/sclk_o" \
  "$project_name/sclk_o"
sbp_connect_net "$project_name/spi0_inst/ssn_o" \
  "$project_name/ssn_o"

#axi to ahb
sbp_connect_interface_net "$project_name/axi_interc0_inst/AXI_M00" \
  "$project_name/axi_ahb0_inst/AXI4_S"

#axi to apb
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
  "$project_name/tcm0_inst/LOCAL_BUS_IF_S0"
sbp_connect_interface_net "$project_name/cpu0_inst/LOCAL_BUS_M_INSTR" \
  "$project_name/tcm0_inst/LOCAL_BUS_IF_S1"

sbp_connect_interface_net "$project_name/spi0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S2"
sbp_connect_interface_net "$project_name/i2c0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S3"
sbp_connect_interface_net "$project_name/gpio0_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S4"
sbp_connect_interface_net "$project_name/gpio1_inst/INTR" \
  "$project_name/cpu0_inst/IRQ_S5"

sbp_assign_addr_seg -offset 'h10004000 "$project_name/axi_apb2_inst/APB3_M" \
  "$project_name/gpio1_inst/APB_S0"
sbp_assign_addr_seg -offset 'h10003000 "$project_name/axi_apb1_inst/APB3_M" \
  "$project_name/gpio0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h10002000 "$project_name/axi_apb0_inst/APB3_M" \
  "$project_name/i2c0_inst/APB_S0"
sbp_assign_addr_seg -offset 'h10000000 "$project_name/axi_ahb0_inst/AHBL_M" \
  "$project_name/spi0_inst/AHBL_S0"
sbp_assign_addr_seg -offset 'h00000000 "$project_name/cpu0_inst/LOCAL_BUS_M_DATA" \
  "$project_name/tcm0_inst/LOCAL_BUS_IF_S0"

sbp_assign_addr_seg -offset 'h00200000 "$project_name/cpu0_inst/AXI_M_INSTR" \
  "$project_name/sysmem0_inst/AXI_S0"
sbp_assign_addr_seg -offset 'h00000000 "$project_name/cpu0_inst/LOCAL_BUS_M_INSTR" \
  "$project_name/tcm0_inst/LOCAL_BUS_IF_S1"
# sbp_design auto_assign_addresses