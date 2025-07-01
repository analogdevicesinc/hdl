###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set FMCOMMS8 1

## FIFO depth is 18Mb - 1M samples

source ../common/adrv9009zu11eg_bd.tcl
source ../common/adrv2crr_fmc_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

create_bd_port -dir I ref_clk_c
create_bd_port -dir I ref_clk_d

create_bd_port -dir I core_clk_c
create_bd_port -dir I core_clk_d

create_bd_port -dir I -from 31 -to 0 fmcomms8_gpio0_i
create_bd_port -dir O -from 31 -to 0 fmcomms8_gpio0_o
create_bd_port -dir O -from 31 -to 0 fmcomms8_gpio0_t
create_bd_port -dir I -from 31 -to 0 fmcomms8_gpio1_i
create_bd_port -dir O -from 31 -to 0 fmcomms8_gpio1_o
create_bd_port -dir O -from 31 -to 0 fmcomms8_gpio1_t

create_bd_port -dir O -from 2 -to 0 spi1_csn
create_bd_port -dir O spi1_sclk
create_bd_port -dir O spi1_mosi
create_bd_port -dir I spi1_miso

set adc_data_offload_name adrv9009_rx_data_offload
set adc_data_width [expr $RX_SAMPLE_WIDTH * $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_CHANNEL]

# spi

set_property -dict [list CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {1} CONFIG.PSU__SPI1__PERIPHERAL__IO {EMIO}] [get_bd_cells sys_ps8]
set_property -dict [list CONFIG.PSU__SPI1__GRP_SS1__ENABLE {1} CONFIG.PSU__SPI1__GRP_SS2__ENABLE {1}] [get_bd_cells sys_ps8]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_rtl_0
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_ref_0

ad_ip_instance ip:ddr4 ddr4_0
ad_ip_parameter ddr4_0 CONFIG.C0.DDR4_DataWidth {32}
ad_ip_parameter ddr4_0 CONFIG.C0.DDR4_AxiDataWidth {256}
ad_ip_parameter ddr4_0 CONFIG.C0.DDR4_TimePeriod {833}
ad_ip_parameter ddr4_0 CONFIG.C0.DDR4_AxiAddressWidth {31}
ad_ip_parameter ddr4_0 CONFIG.C0.DDR4_InputClockPeriod {3332}
ad_ip_parameter ddr4_0 CONFIG.C0.DDR4_MemoryPart {MT40A512M16LY-075}
ad_ip_parameter ddr4_0 CONFIG.C0.BANK_GROUP_WIDTH {1}
ad_ip_parameter ddr4_0 CONFIG.C0.DDR4_CasLatency {17}

ad_connect ddr4_rtl_0 ddr4_0/C0_DDR4

set_property -dict [list CONFIG.FREQ_HZ {300000000}] [get_bd_intf_ports ddr4_ref_0]
ad_connect ddr4_ref_0 ddr4_0/C0_SYS_CLK

set data_offload_size [expr 1024 * 1024 * 1024]
ad_data_offload_create $adc_data_offload_name \
                       0 \
                       1 \
                       $data_offload_size \
                       $adc_data_width \
                       $adc_data_width \
                       256

ad_ip_parameter $adc_data_offload_name/storage_unit CONFIG.DDR_BASE_ADDDRESS [format "%d" 0x80000000]
ad_connect $adc_data_offload_name/sync_ext GND

create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr4_0_rstgen
ad_connect ddr4_0_rstgen/slowest_sync_clk ddr4_0/c0_ddr4_ui_clk
ad_connect ddr4_0/c0_ddr4_ui_clk_sync_rst ddr4_0_rstgen/ext_reset_in

ad_connect sys_reset ddr4_0/sys_rst

ad_ip_instance xlconcat spi1_csn_concat
ad_ip_parameter spi1_csn_concat CONFIG.NUM_PORTS 3
ad_connect  sys_ps8/emio_spi1_ss_o_n spi1_csn_concat/In0
ad_connect  sys_ps8/emio_spi1_ss1_o_n spi1_csn_concat/In1
ad_connect  sys_ps8/emio_spi1_ss2_o_n spi1_csn_concat/In2
ad_connect  spi1_csn_concat/dout spi1_csn
ad_connect  sys_ps8/emio_spi1_sclk_o spi1_sclk
ad_connect  sys_ps8/emio_spi1_m_o spi1_mosi
ad_connect  sys_ps8/emio_spi1_m_i spi1_miso
ad_connect  sys_ps8/emio_spi1_ss_i_n VCC
ad_connect  sys_ps8/emio_spi1_sclk_i GND
ad_connect  sys_ps8/emio_spi1_s_i GND

ad_ip_instance axi_gpio axi_fmcomms8_gpio
ad_ip_parameter axi_fmcomms8_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter axi_fmcomms8_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_fmcomms8_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter axi_fmcomms8_gpio CONFIG.C_INTERRUPT_PRESENT 1

ad_connect  fmcomms8_gpio0_i axi_fmcomms8_gpio/gpio_io_i
ad_connect  fmcomms8_gpio0_o axi_fmcomms8_gpio/gpio_io_o
ad_connect  fmcomms8_gpio0_t axi_fmcomms8_gpio/gpio_io_t
ad_connect  fmcomms8_gpio1_i axi_fmcomms8_gpio/gpio2_io_i
ad_connect  fmcomms8_gpio1_o axi_fmcomms8_gpio/gpio2_io_o
ad_connect  fmcomms8_gpio1_t axi_fmcomms8_gpio/gpio2_io_t

ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/qpll_ref_clk_8
ad_xcvrpll  ref_clk_d util_adrv9009_som_xcvr/cpll_ref_clk_8
ad_xcvrpll  ref_clk_d util_adrv9009_som_xcvr/cpll_ref_clk_9
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/cpll_ref_clk_10
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/cpll_ref_clk_11
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/qpll_ref_clk_12
ad_xcvrpll  ref_clk_d util_adrv9009_som_xcvr/cpll_ref_clk_12
ad_xcvrpll  ref_clk_d util_adrv9009_som_xcvr/cpll_ref_clk_13
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/cpll_ref_clk_14
ad_xcvrpll  ref_clk_c util_adrv9009_som_xcvr/cpll_ref_clk_15

ad_xcvrpll  axi_adrv9009_som_tx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_qpll_rst_8
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_8
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_9
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_10
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_11
ad_xcvrpll  axi_adrv9009_som_tx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_qpll_rst_12
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_12
ad_xcvrpll  axi_adrv9009_som_rx_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_13
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_14
ad_xcvrpll  axi_adrv9009_som_obs_xcvr/up_pll_rst util_adrv9009_som_xcvr/up_cpll_rst_15

ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.DMA_TYPE_SRC 1
# ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.SYNC_TRANSFER_START 1
ad_connect sys_dma_clk axi_adrv9009_som_rx_dma/s_axis_aclk

ad_connect ddr4_0/c0_ddr4_aresetn ddr4_0_rstgen/peripheral_aresetn
ad_connect ddr4_0/c0_ddr4_ui_clk $adc_data_offload_name/storage_unit/m_axi_aclk
ad_connect ddr4_0/C0_DDR4_S_AXI $adc_data_offload_name/storage_unit/MAXI_0
ad_connect ddr4_0_rstgen/peripheral_aresetn $adc_data_offload_name/storage_unit/m_axi_aresetn
ad_connect $adc_data_offload_name/i_data_offload/ddr_calib_done ddr4_0/c0_init_calib_complete

ad_connect util_som_rx_cpack/packed_fifo_wr_en $adc_data_offload_name/i_data_offload/s_axis_valid
ad_connect util_som_rx_cpack/packed_fifo_wr_data $adc_data_offload_name/i_data_offload/s_axis_data

ad_connect $adc_data_offload_name/m_axis axi_adrv9009_som_rx_dma/s_axis
ad_connect $adc_data_offload_name/init_req axi_adrv9009_som_rx_dma/s_axis_xfer_req

ad_connect sys_cpu_clk $adc_data_offload_name/s_axi_aclk
ad_connect sys_cpu_resetn $adc_data_offload_name/s_axi_aresetn
ad_connect core_clk_b $adc_data_offload_name/s_axis_aclk
ad_connect core_clk_b_rstgen/peripheral_aresetn $adc_data_offload_name/s_axis_aresetn
ad_connect  $adc_data_offload_name/s_axis_tlast GND
ad_connect  $adc_data_offload_name/s_axis_tkeep VCC

set sys_dma_clk dma_clk_wiz/clk_out1
ad_connect sys_dma_clk $adc_data_offload_name/m_axis_aclk
ad_connect sys_dma_resetn $adc_data_offload_name/m_axis_aresetn

# Reset pack cores
# ad_ip_instance util_reduced_logic cpack_rst_logic
# ad_ip_parameter cpack_rst_logic config.c_operation {or}
# ad_ip_parameter cpack_rst_logic config.c_size {3}

# ad_ip_instance util_vector_logic rx_do_rstout_logic
# ad_ip_parameter rx_do_rstout_logic config.c_operation {not}
# ad_ip_parameter rx_do_rstout_logic config.c_size {1}

# ad_connect $adc_data_offload_name/s_axis_tready rx_do_rstout_logic/Op1

# ad_ip_instance xlconcat cpack_reset_sources
# ad_ip_parameter cpack_reset_sources config.num_ports {3}

ad_disconnect util_som_rx_cpack/reset rx_adrv9009_som_tpl_core/adc_rst
ad_connect core_clk_b_rstgen/peripheral_reset util_som_rx_cpack/reset
# ad_connect core_clk_b_rstgen/peripheral_reset cpack_reset_sources/in0
# ad_connect rx_adrv9009_som_tpl_core/adc_rst cpack_reset_sources/in1
# ad_connect rx_do_rstout_logic/res cpack_reset_sources/in2

# ad_connect cpack_reset_sources/dout cpack_rst_logic/op1
# ad_connect cpack_rst_logic/res util_som_rx_cpack/reset

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
S=$ad_project_params(RX_OS_JESD_S)"

sysid_gen_sys_init_file $sys_cstring

ad_cpu_interconnect 0x46000000 axi_fmcomms8_gpio
ad_cpu_interconnect 0x7c430000 $adc_data_offload_name

create_bd_addr_seg -range 0x40000000 -offset 0x80000000 \
    [get_bd_addr_spaces $adc_data_offload_name/storage_unit/MAXI_0] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_ddr4_0_C0_DDR4_ADDRESS_BLOCK

# interconnect (mem/dac)

ad_cpu_interrupt ps-4 mb-4 axi_fmcomms8_gpio/ip2intc_irpt
