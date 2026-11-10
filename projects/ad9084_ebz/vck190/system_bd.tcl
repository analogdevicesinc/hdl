###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

set ASYMMETRIC_A_B_MODE [ expr { [info exists ad_project_params(ASYMMETRIC_A_B_MODE)] \
                          ? $ad_project_params(ASYMMETRIC_A_B_MODE) : 0 } ]

if {$ASYMMETRIC_A_B_MODE == 1} {
  ## ADC B Side FIFO depth in samples per converter
  set adc_b_fifo_samples_per_converter [expr $ad_project_params(RX_B_KS_PER_CHANNEL)*1024]
  ## DAC B Side FIFO depth in samples per converter
  set dac_b_fifo_samples_per_converter [expr $ad_project_params(TX_B_KS_PER_CHANNEL)*1024]
}

set SIDE_B_ONLY [ expr { [info exists ad_project_params(SIDE_B_ONLY)] \
                          ? $ad_project_params(SIDE_B_ONLY) : 0 } ]

set CORUNDUM [ expr { [info exists ad_project_params(CORUNDUM)] \
                       ? $ad_project_params(CORUNDUM) : 0 } ]
set CORUNDUM_APP_ENABLE [ expr { [info exists ad_project_params(APP_ENABLE)] \
                                  ? $ad_project_params(APP_ENABLE) : 0 } ]

if {$CORUNDUM_APP_ENABLE && !$CORUNDUM} {
  error "APP_ENABLE=1 needs CORUNDUM=1"
}
if {$CORUNDUM && $SIDE_B_ONLY} {
  error "CORUNDUM=1 is not supported with SIDE_B_ONLY=1"
}

source $ad_hdl_dir/projects/common/vck190/vck190_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

if {$CORUNDUM} {
  adi_project_files ad9084_ebz_vck190 [list \
    "system_top_corundum.v" \
  ]
} elseif {!$SIDE_B_ONLY} {
  adi_project_files ad9084_ebz_vck190 [list \
    "system_top.v" \
  ]
} else {
  adi_project_files ad9084_ebz_vck190 [list \
    "system_top_side_b_only.v" \
  ]
}

set ADI_PHY_SEL 0
set MAX_NUMBER_OF_QUADS 3
set TRANSCEIVER_TYPE GTY
set EXTERNAL_LINK_CLK 0
set HSCI_BANKS 2
set HSCI_ENABLE [ expr { [info exists ad_project_params(HSCI_ENABLE)] \
                          ? $ad_project_params(HSCI_ENABLE) : 1 } ]

source $ad_hdl_dir/projects/ad9084_ebz/common/ad9084_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

if {$ASYMMETRIC_A_B_MODE == 1} {
  ad_ip_parameter axi_apollo_rx_b_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
  ad_ip_parameter axi_apollo_tx_b_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1
}

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# Second SPI controller
create_bd_port -dir O -from 7 -to 0 apollo_spi_csn_o
create_bd_port -dir I -from 7 -to 0 apollo_spi_csn_i
create_bd_port -dir I apollo_spi_clk_i
create_bd_port -dir O apollo_spi_clk_o
create_bd_port -dir I apollo_spi_sdo_i
create_bd_port -dir O apollo_spi_sdo_o
create_bd_port -dir I apollo_spi_sdi_i

ad_ip_instance axi_quad_spi axi_spi_2
ad_ip_parameter axi_spi_2 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_2 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_2 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_2 CONFIG.Multiples16 1

ad_connect apollo_spi_csn_i axi_spi_2/ss_i
ad_connect apollo_spi_csn_o axi_spi_2/ss_o
ad_connect apollo_spi_clk_i axi_spi_2/sck_i
ad_connect apollo_spi_clk_o axi_spi_2/sck_o
ad_connect apollo_spi_sdo_i axi_spi_2/io0_i
ad_connect apollo_spi_sdo_o axi_spi_2/io0_o
ad_connect apollo_spi_sdi_i axi_spi_2/io1_i

ad_connect $sys_cpu_clk axi_spi_2/ext_spi_clk

ad_cpu_interrupt ps-9 mb-16 axi_spi_2/ip2intc_irpt

ad_cpu_interconnect 0x44A80000 axi_spi_2

if {$HSCI_ENABLE} {
  set_property range 256K [get_bd_addr_segs {sys_cips/M_AXI_FPD/SEG_data_axi_hsci_0}]
}

if {$CORUNDUM} {
  source $ad_hdl_dir/library/corundum/scripts/corundum_vck190_cfg.tcl

  set ETH_LOOPBACK_ENABLE 0

  # The cfg above disables the application block unconditionally. The
  # application only uses the sync TX/RX path, at 250 MHz.
  if {$CORUNDUM_APP_ENABLE} {
    set APP_ENABLE 1
    set APP_ID "32'h12340001"
    set APP_AXIS_SYNC_ENABLE 1
    set APP_GPIO_IN_WIDTH 32
    set APP_GPIO_OUT_WIDTH 32

    # With the application, corundum_core requires RAM_SEL_WIDTH to be exactly
    # $clog2(IF_COUNT + app DMA) + 2; the cfg's 3 assumes an app DMA port.
    set RAM_SEL_WIDTH [expr {int(ceil(log($IF_COUNT + ($APP_DMA_ENABLE ? 1 : 0)) / log(2))) + 2}]

    set INPUT_CHANNELS $RX_NUM_OF_CONVERTERS
    set INPUT_SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL
    set INPUT_SAMPLE_DATA_WIDTH $RX_DMA_SAMPLE_WIDTH

    set OUTPUT_CHANNELS $TX_NUM_OF_CONVERTERS
    set OUTPUT_SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL
    set OUTPUT_SAMPLE_DATA_WIDTH $TX_DMA_SAMPLE_WIDTH
  }

  # ptp_clk is the 156.25 MHz QSFP refclk; corundum_core derives the PTP
  # increment from this period.
  set PTP_CLK_PERIOD_NS_NUM   32
  set PTP_CLK_PERIOD_NS_DENOM 5

  source $ad_hdl_dir/library/corundum/scripts/corundum.tcl

  create_bd_port -dir I gt_ref_clk_p
  create_bd_port -dir I gt_ref_clk_n
  ad_connect gt_ref_clk_p corundum_hierarchy/gt_ref_clk_p
  ad_connect gt_ref_clk_n corundum_hierarchy/gt_ref_clk_n

  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 qsfp_serial
  ad_connect corundum_hierarchy/qsfp_serial qsfp_serial

  create_bd_port -dir O mrmac_link_ready
  ad_connect corundum_hierarchy/mrmac_link_ready mrmac_link_ready

  ad_connect corundum_hierarchy/mrmac_loopback_en       GND
  ad_connect corundum_hierarchy/mrmac_loopback_mac_swap GND

  # gt_freerun_clk must be 100 MHz: it also clocks mrmac_0/s_axi, mrmac_init
  # and gtwiz_freerun_clk. clk_corundum is driven before the interconnect
  # helpers so their associated-clock auto-drive is a no-op.
  ad_ip_instance clk_wizard corundum_clkgen
  ad_ip_parameter corundum_clkgen CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY \
    {250.000,100.000,100.000,100.000,100.000,100.000,100.000}
  ad_ip_parameter corundum_clkgen CONFIG.CLKOUT_USED \
    {true,false,false,false,false,false,false}
  ad_ip_parameter corundum_clkgen CONFIG.PRIM_SOURCE {Global_buffer}
  ad_ip_parameter corundum_clkgen CONFIG.USE_LOCKED true
  ad_connect corundum_clkgen/clk_in1 sys_cpu_clk

  ad_connect corundum_hierarchy/clk_corundum   corundum_clkgen/clk_out1
  ad_connect corundum_hierarchy/gt_freerun_clk sys_cpu_clk

  # 390.625 MHz is the MRMAC 100G non-segmented 384b client clock. ts_clk must
  # match CONFIG.TIMESTAMP_CLK_PERIOD_NS (4.0 ns) in corundum_vck190_mac.tcl.
  # From 100 MHz no VCO gives both with integer divides, hence two primitives.
  ad_ip_instance clk_wizard corundum_mac_clkgen
  ad_ip_parameter corundum_mac_clkgen CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY \
    {390.625,100.000,100.000,100.000,100.000,100.000,100.000}
  ad_ip_parameter corundum_mac_clkgen CONFIG.CLKOUT_USED \
    {true,false,false,false,false,false,false}
  ad_ip_parameter corundum_mac_clkgen CONFIG.PRIM_SOURCE {Global_buffer}

  ad_ip_instance clk_wizard corundum_mac_ts_clkgen
  ad_ip_parameter corundum_mac_ts_clkgen CONFIG.PRIMITIVE_TYPE {PLL}
  ad_ip_parameter corundum_mac_ts_clkgen CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY \
    {250.000,100.000,100.000,100.000,100.000,100.000,100.000}
  ad_ip_parameter corundum_mac_ts_clkgen CONFIG.CLKOUT_USED \
    {true,false,false,false,false,false,false}
  ad_ip_parameter corundum_mac_ts_clkgen CONFIG.PRIM_SOURCE {Global_buffer}

  ad_connect corundum_mac_clkgen/clk_in1    sys_cpu_clk
  ad_connect corundum_mac_ts_clkgen/clk_in1 sys_cpu_clk
  ad_connect corundum_hierarchy/mrmac_axis_clk corundum_mac_clkgen/clk_out1
  ad_connect corundum_hierarchy/mrmac_ts_clk   corundum_mac_ts_clkgen/clk_out1

  ad_connect corundum_hierarchy/ptp_clk corundum_hierarchy/ptp_refclk_bufg
  ad_connect corundum_hierarchy/ptp_sample_clk sys_350m_clk

  ad_connect corundum_hierarchy/mac_resetn sys_cpu_resetn

  ad_ip_instance proc_sys_reset corundum_ptp_rstgen
  ad_ip_parameter corundum_ptp_rstgen CONFIG.C_EXT_RST_WIDTH 1
  ad_connect corundum_ptp_rstgen/slowest_sync_clk corundum_hierarchy/ptp_refclk_bufg
  ad_connect corundum_ptp_rstgen/ext_reset_in     sys_cips/pl0_resetn
  ad_connect corundum_hierarchy/ptp_rst corundum_ptp_rstgen/peripheral_reset

  # Without dcm_locked the core leaves reset before clk_corundum is stable.
  ad_connect corundum_rstgen/slowest_sync_clk corundum_clkgen/clk_out1
  ad_connect corundum_rstgen/ext_reset_in     sys_cips/pl0_resetn
  ad_connect corundum_rstgen/dcm_locked       corundum_clkgen/locked
  # corundum.tcl sets C_AUX_RESET_HIGH 1 and drives aux_reset_in only for MB.
  # Left open, Vivado ties it to 1 and holds the core in reset.
  ad_connect corundum_rstgen/aux_reset_in     GND

  ad_cpu_interconnect 0x46000000 corundum_hierarchy s_axil_corundum
  ad_cpu_interconnect 0x47000000 corundum_hierarchy s_axi_mac
  ad_cpu_interconnect 0x48000000 corundum_hierarchy s_axi_gt

  # s_axil_corundum and s_axil_application are in the 250 MHz core domain
  ad_ip_parameter axi_fpd_interconnect CONFIG.NUM_CLKS 2
  ad_connect axi_fpd_interconnect/aclk1 corundum_clkgen/clk_out1

  ad_mem_hp0_interconnect corundum_clkgen/clk_out1 corundum_hierarchy/m_axi

  ad_cpu_interrupt "ps-5" "mb-5" corundum_hierarchy/irq

  if {$CORUNDUM_APP_ENABLE} {
    ad_cpu_interconnect 0x49000000 corundum_hierarchy s_axil_application

    # A second pack of the A-side ADC samples, independent of the DMA path and
    # fed like it (after FSRC when that is enabled)
    ad_ip_instance util_cpack2 util_corundum_cpack [list \
      NUM_OF_CHANNELS $INPUT_CHANNELS \
      SAMPLES_PER_CHANNEL $INPUT_SAMPLES_PER_CHANNEL \
      SAMPLE_DATA_WIDTH $INPUT_SAMPLE_DATA_WIDTH \
    ]

    ad_connect rx_device_clk util_corundum_cpack/clk
    ad_connect $rx_valid_src util_corundum_cpack/fifo_wr_en
    for {set i 0} {$i < $INPUT_CHANNELS} {incr i} {
      ad_connect rx_apollo_tpl_core/adc_enable_$i util_corundum_cpack/enable_$i
      ad_connect ${rx_data_src}_$i util_corundum_cpack/fifo_wr_data_$i
    }
    ad_connect GND util_corundum_cpack/packed_fifo_wr_overflow

    ad_connect corundum_hierarchy/input_clk  rx_device_clk
    ad_connect corundum_hierarchy/input_rstn rx_device_clk_rstgen/peripheral_aresetn
    ad_connect corundum_hierarchy/output_clk  $sys_dma_clk
    ad_connect corundum_hierarchy/output_rstn $sys_dma_resetn

    ad_connect corundum_hierarchy/input_axis_tvalid util_corundum_cpack/packed_fifo_wr_en
    ad_connect corundum_hierarchy/input_axis_tdata  util_corundum_cpack/packed_fifo_wr_data

    ad_ip_instance ilreduced_logic corundum_cpack_rst_logic
    ad_ip_parameter corundum_cpack_rst_logic config.c_operation {or}
    ad_ip_parameter corundum_cpack_rst_logic config.c_size {4}

    ad_ip_instance ilvector_logic corundum_input_not_ready
    ad_ip_parameter corundum_input_not_ready config.c_operation {not}
    ad_ip_parameter corundum_input_not_ready config.c_size {1}
    ad_connect corundum_hierarchy/input_axis_tready corundum_input_not_ready/Op1

    ad_ip_instance ilconcat corundum_cpack_reset_sources
    ad_ip_parameter corundum_cpack_reset_sources config.num_ports {4}
    ad_connect rx_device_clk_rstgen/peripheral_reset corundum_cpack_reset_sources/in0
    ad_connect rx_apollo_tpl_core/adc_tpl_core/adc_rst corundum_cpack_reset_sources/in1
    ad_connect corundum_input_not_ready/res corundum_cpack_reset_sources/in2
    ad_connect corundum_hierarchy/input_packer_reset corundum_cpack_reset_sources/in3

    ad_connect corundum_cpack_reset_sources/dout corundum_cpack_rst_logic/op1
    ad_connect corundum_cpack_rst_logic/res util_corundum_cpack/reset

    ad_ip_instance ilconcat corundum_input_enable_concat
    ad_ip_parameter corundum_input_enable_concat config.num_ports $INPUT_CHANNELS
    for {set i 0} {$i < $INPUT_CHANNELS} {incr i} {
      ad_connect rx_apollo_tpl_core/adc_enable_$i corundum_input_enable_concat/In$i
    }
    ad_connect corundum_input_enable_concat/dout corundum_hierarchy/input_enable

    ad_ip_instance ilconcat corundum_output_enable_concat
    ad_ip_parameter corundum_output_enable_concat config.num_ports $OUTPUT_CHANNELS
    for {set i 0} {$i < $OUTPUT_CHANNELS} {incr i} {
      ad_connect tx_apollo_tpl_core/dac_enable_$i corundum_output_enable_concat/In$i
    }
    ad_connect corundum_output_enable_concat/dout corundum_hierarchy/output_enable

    # The application loads the DAC data offload in place of the TX DMA; the
    # offload then replays the buffer (corundum_dac_load.v).
    if {$OUTPUT_CHANNELS * $OUTPUT_SAMPLES_PER_CHANNEL * $OUTPUT_SAMPLE_DATA_WIDTH != $dac_data_width} {
      error "application output width does not match the DAC data offload"
    }

    adi_project_files ad9084_ebz_vck190 [list \
      "../common/corundum_dac_load.v" \
      "../common/corundum_pause_merge.v" \
      "$ad_hdl_dir/library/common/up_axi.v" \
    ]
    update_compile_order -fileset sources_1

    create_bd_cell -type module -reference corundum_dac_load corundum_dac_load
    set_property CONFIG.DATA_WIDTH $dac_data_width [get_bd_cells corundum_dac_load]

    ad_connect $sys_dma_clk    corundum_dac_load/clk
    ad_connect $sys_dma_resetn corundum_dac_load/resetn

    delete_bd_objs [get_bd_intf_nets -of_objects [get_bd_intf_pins axi_apollo_tx_dma/m_axis]]
    delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_apollo_tx_dma/m_axis_xfer_req]]

    ad_connect axi_apollo_tx_dma/m_axis corundum_dac_load/s_dma_axis
    ad_connect axi_apollo_tx_dma/m_axis_xfer_req corundum_dac_load/dma_xfer_req

    ad_connect corundum_hierarchy/output_axis_tvalid corundum_dac_load/s_app_axis_tvalid
    ad_connect corundum_hierarchy/output_axis_tready corundum_dac_load/s_app_axis_tready
    ad_connect corundum_hierarchy/output_axis_tdata  corundum_dac_load/s_app_axis_tdata

    ad_connect corundum_dac_load/m_axis $dac_data_offload_name/s_axis
    ad_connect corundum_dac_load/init_req $dac_data_offload_name/init_req

    ad_connect tx_device_clk corundum_dac_load/dac_clk
    ad_connect util_apollo_upack/fifo_rd_valid     corundum_dac_load/dac_rd_valid
    ad_connect util_apollo_upack/fifo_rd_underflow corundum_dac_load/dac_rd_underflow

    # The application's RX tap is ahead of the FIFO whose fill raises
    # Corundum's own pause request, so corundum_dac_load raises one for its
    # FIFO and it is ORed in at the MRMAC. connect_bd_net: the mrmac_0 pin
    # names collide with its single-pin bus interfaces.
    create_bd_cell -type module -reference corundum_pause_merge corundum_hierarchy/corundum_pause_merge
    create_bd_pin -dir I corundum_hierarchy/app_pause_req
    delete_bd_objs [get_bd_nets -of_objects [get_bd_pins corundum_hierarchy/mrmac_0/ctl_tx_pause_req_0]]
    connect_bd_net [get_bd_pins corundum_hierarchy/mrmac_versal_glue/mrmac_ctl_tx_pause_req_0] \
                   [get_bd_pins corundum_hierarchy/corundum_pause_merge/req_in]
    connect_bd_net [get_bd_pins corundum_hierarchy/corundum_pause_merge/req_out] \
                   [get_bd_pins corundum_hierarchy/mrmac_0/ctl_tx_pause_req_0]
    connect_bd_net [get_bd_pins corundum_hierarchy/mrmac_axis_clk] \
                   [get_bd_pins corundum_hierarchy/corundum_pause_merge/clk]
    connect_bd_net [get_bd_pins corundum_hierarchy/app_pause_req] \
                   [get_bd_pins corundum_hierarchy/corundum_pause_merge/pause_in]
    ad_connect corundum_dac_load/pause_req corundum_hierarchy/app_pause_req

    ad_cpu_interconnect 0x4A000000 corundum_dac_load

    ad_ip_parameter axi_fpd_interconnect CONFIG.NUM_CLKS 3
    ad_connect axi_fpd_interconnect/aclk2 $sys_dma_clk
  }
}
