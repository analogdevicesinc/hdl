###############################################################################
## Copyright (C) 2016-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_data_offload_type 1                      ; ## PL_DDR
set dac_data_offload_size [expr 1024*1024*1024]  ; ## 1 GB
set dac_axi_data_width 512

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
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
RX_OS:M=$ad_project_params(RX_OS_JESD_M)\
L=$ad_project_params(RX_OS_JESD_L)\
S=$ad_project_params(RX_OS_JESD_S)\
DAC_OFFLOAD:TYPE=$dac_data_offload_type\
SIZE=$dac_data_offload_size"

sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 250

ad_ip_instance proc_sys_reset sys_250m_rstgen
ad_ip_parameter sys_250m_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect  sys_250m_clk sys_ps7/FCLK_CLK2
ad_connect  sys_250m_reset sys_250m_rstgen/peripheral_reset
ad_connect  sys_250m_resetn sys_250m_rstgen/peripheral_aresetn
ad_connect  sys_250m_clk sys_250m_rstgen/slowest_sync_clk
ad_connect  sys_250m_rstgen/ext_reset_in sys_ps7/FCLK_RESET2_N

set sys_dma_clk           [get_bd_nets sys_250m_clk]
set sys_dma_reset         [get_bd_nets sys_250m_reset]
set sys_dma_resetn        [get_bd_nets sys_250m_resetn]

source ../common/adrv9009_bd.tcl

if {$dac_data_offload_type} {

    ad_ip_instance proc_sys_reset axi_rstgen
    ad_ip_instance mig_7series axi_ddr_cntrl
    file copy -force $ad_hdl_dir/projects/common/zc706/zc706_plddr3_mig.prj [get_property IP_DIR \
      [get_ips [get_property CONFIG.Component_Name [get_bd_cells axi_ddr_cntrl]]]]
    ad_ip_parameter axi_ddr_cntrl CONFIG.XML_INPUT_FILE zc706_plddr3_mig.prj

    # PL-DDR data offload interfaces
    create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk
    create_bd_port -dir I -type rst sys_rst
    set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports sys_rst]
    create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3

    ad_connect axi_ddr_cntrl/ui_clk axi_rstgen/slowest_sync_clk
    ad_connect axi_ddr_cntrl/ui_clk $dac_data_offload_name/storage_unit/m_axi_aclk
    ad_connect axi_ddr_cntrl/S_AXI $dac_data_offload_name/storage_unit/MAXI_0
    ad_connect axi_rstgen/peripheral_aresetn $dac_data_offload_name/storage_unit/m_axi_aresetn
    ad_connect axi_rstgen/peripheral_aresetn axi_ddr_cntrl/aresetn
    ad_connect sys_cpu_resetn axi_rstgen/ext_reset_in

    assign_bd_address [get_bd_addr_segs -of_objects [get_bd_cells axi_ddr_cntrl]]

    ad_connect  sys_rst axi_ddr_cntrl/sys_rst
    ad_connect  sys_clk axi_ddr_cntrl/SYS_CLK
    ad_connect  ddr3    axi_ddr_cntrl/DDR3
    ad_connect  axi_ddr_cntrl/device_temp_i GND
    ad_connect  $dac_data_offload_name/i_data_offload/ddr_calib_done axi_ddr_cntrl/init_calib_complete

    ad_ip_parameter $dac_data_offload_name/storage_unit CONFIG.DDR_BASE_ADDDRESS [format "%d" 0x80000000]

}

ad_ip_parameter axi_adrv9009_rx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.MAX_BYTES_PER_BURST 4096

ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.CLK1_DIV 6
