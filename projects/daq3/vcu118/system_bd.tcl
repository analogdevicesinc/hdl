###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## FIFO depth is 4Mb - 250k samples
set adc_fifo_address_width 16

## FIFO depth is 4Mb - 250k samples
set dac_fifo_address_width 15

source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/daq3_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "RX:M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
TX:M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
ADC_FIFO_ADDR_WIDTH=$adc_fifo_address_width\
DAC_FIFO_ADDR_WIDTH=$dac_fifo_address_width"

sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG0 0x331C
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG1 0xD038
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG2 0xFC1
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG3 0x120
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG4 0x2
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG1_G3 0xD038
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG2_G3 0xFC1

ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG0 0x3fe
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG1 0x29
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG2 0x203
ad_ip_parameter util_daq3_xcvr CONFIG.RX_CLK25_DIV 25
ad_ip_parameter util_daq3_xcvr CONFIG.TX_CLK25_DIV 25

ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_DEST true
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_SRC true
ad_ip_parameter axi_ad9152_dma CONFIG.AXI_SLICE_DEST true
ad_ip_parameter axi_ad9152_dma CONFIG.AXI_SLICE_SRC true

ad_ip_parameter axi_ddr_cntrl CONFIG.C0_CLOCK_BOARD_INTERFACE default_250mhz_clk1
ad_ip_parameter axi_ddr_cntrl CONFIG.C0_DDR4_BOARD_INTERFACE ddr4_sdram_c1_062

# delete_bd_objs [get_bd_intf_ports iic_main] [get_bd_cells axi_iic_main]
# ad_connect sys_concat_intc/In9 GND

set INPUT_WIDTH 128

source $ad_hdl_dir/library/corundum/scripts/corundum_vcu118_cfg.tcl
source $ad_hdl_dir/library/corundum/scripts/corundum.tcl

ad_ip_parameter axi_dp_interconnect CONFIG.NUM_CLKS 3
ad_connect axi_dp_interconnect/aclk2 sys_250m_clk

ad_ip_instance clk_wiz clk_wiz_125mhz

ad_connect clk_wiz_125mhz/clk_in1 sys_250m_clk
ad_connect clk_wiz_125mhz/reset sys_250m_reset

ad_ip_instance proc_sys_reset sys_125m_rstgen
ad_connect sys_125m_rstgen/slowest_sync_clk clk_wiz_125mhz/clk_out1
ad_connect sys_125m_rstgen/ext_reset_in axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst

create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qspi_rtl:1.0 qspi0
create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qspi_rtl:1.0 qspi1
create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qsfp_rtl:1.0 qsfp
# create_bd_intf_port -mode Master -vlnv analog.com:interface:if_i2c_rtl:1.0 i2c

create_bd_port -dir O -from 0 -to 0 -type rst qsfp_rst
create_bd_port -dir O fpga_boot
create_bd_port -dir O -type clk qspi_clk
create_bd_port -dir I -type rst ptp_rst
set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports ptp_rst]
create_bd_port -dir I -type clk qsfp_mgt_refclk
create_bd_port -dir I -type clk qsfp_mgt_refclk_bufg

create_bd_port -dir O -type clk clk_125mhz
create_bd_port -dir O -type clk clk_250mhz

ad_connect clk_wiz_125mhz/clk_out1 clk_125mhz
ad_connect sys_250m_clk clk_250mhz

ad_connect corundum_hierarchy/aux_reset_in sys_250m_rstgen/aux_reset_in

ad_connect corundum_hierarchy/clk_125mhz clk_wiz_125mhz/clk_out1
ad_connect corundum_hierarchy/clk_250mhz sys_250m_clk

ad_connect corundum_hierarchy/rst_125mhz sys_125m_rstgen/peripheral_reset
ad_connect corundum_hierarchy/rst_250mhz sys_250m_reset

ad_connect corundum_hierarchy/qspi0 qspi0
ad_connect corundum_hierarchy/qspi1 qspi1
ad_connect corundum_hierarchy/qsfp qsfp
# ad_connect corundum_hierarchy/i2c i2c
ad_connect corundum_hierarchy/qsfp_rst qsfp_rst
ad_connect corundum_hierarchy/fpga_boot fpga_boot
ad_connect corundum_hierarchy/qspi_clk qspi_clk
ad_connect corundum_hierarchy/ptp_rst ptp_rst
ad_connect corundum_hierarchy/qsfp_mgt_refclk qsfp_mgt_refclk
ad_connect corundum_hierarchy/qsfp_mgt_refclk_bufg qsfp_mgt_refclk_bufg

ad_cpu_interconnect 0x50000000 corundum_hierarchy s_axil_corundum
ad_cpu_interconnect 0x52000000 corundum_hierarchy s_axil_gpio_reset

ad_mem_hp1_interconnect sys_250m_clk corundum_hierarchy/m_axi

ad_cpu_interrupt "ps-5" "mb-5" corundum_hierarchy/irq

if {$APP_ENABLE == 1} {
  ad_cpu_interconnect 0x51000000 corundum_hierarchy s_axil_application
}

ad_connect corundum_hierarchy/input_clk util_daq3_xcvr/rx_out_clk_0
ad_connect corundum_hierarchy/input_rstn axi_ad9680_jesd_rstgen/peripheral_aresetn

ad_connect corundum_hierarchy/input_axis_tvalid axi_ad9680_cpack/packed_fifo_wr_data
ad_connect corundum_hierarchy/input_axis_tdata axi_ad9680_cpack/packed_fifo_wr_en
