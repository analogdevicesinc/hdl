###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
package require quartus::device

source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create axi_adrv9001 {AXI ADRV9001 Interface} axi_adrv9001_elab
set_module_property VALIDATION_CALLBACK info_param_validate

ad_ip_files axi_adrv9001 [list\
  "$ad_hdl_dir/library/intel/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_dds_cordic_pipe.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine_cordic.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds_2.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_tdd_cntrl.v" \
  "$ad_hdl_dir/library/common/ad_tdd_control.v" \
  "$ad_hdl_dir/library/common/ad_addsub.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/common/ad_pngen.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc" \
  "$ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc" \
  "$ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc" \
  "$ad_hdl_dir/library/intel/common/up_rst_constr.sdc" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/util_cdc/util_cdc_constr.tcl" \
  "intel/adrv9001_rx.v" \
  "intel/adrv9001_tx.v" \
  "adrv9001_pack.v" \
  "adrv9001_aligner4.v" \
  "adrv9001_aligner8.v" \
  "adrv9001_rx_link.v" \
  "adrv9001_tx_link.v" \
  "axi_adrv9001_rx.v" \
  "axi_adrv9001_rx_channel.v" \
  "axi_adrv9001_if.v" \
  "axi_adrv9001_tx.v" \
  "axi_adrv9001_tx_channel.v" \
  "axi_adrv9001_core.v" \
  "axi_adrv9001_constr.sdc" \
  "axi_adrv9001_tdd.v" \
  "axi_adrv9001.v" ]

# parameters

ad_ip_parameter ID INTEGER 0
ad_ip_parameter CMOS_LVDS_N INTEGER 0
ad_ip_parameter IO_DELAY_GROUP STRING {dev_if_delay_group}

adi_add_auto_fpga_spec_params

# interfaces

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

#ad_interface clock delay_clk input 1
ad_interface clock adc_1_clk output 1
ad_interface clock adc_2_clk output 1
ad_interface clock dac_1_clk output 1
ad_interface clock dac_2_clk output 1

ad_interface reset adc_1_rst output 1 if_adc_1_clk
ad_interface reset adc_2_rst output 1 if_adc_2_clk
ad_interface reset dac_1_rst output 1 if_dac_1_clk
ad_interface reset dac_2_rst output 1 if_dac_2_clk

add_interface adc_1_ch_0 conduit end
add_interface_port adc_1_ch_0 adc_1_enable_i0 enable Output 1
add_interface_port adc_1_ch_0 adc_1_valid_i0 valid Output 1
add_interface_port adc_1_ch_0 adc_1_data_i0 data Output 16

add_interface adc_1_ch_1 conduit end
add_interface_port adc_1_ch_1 adc_1_enable_q0 enable Output 1
add_interface_port adc_1_ch_1 adc_1_valid_q0 valid Output 1
add_interface_port adc_1_ch_1 adc_1_data_q0 data Output 16

add_interface adc_1_ch_2 conduit end
add_interface_port adc_1_ch_2 adc_1_enable_i1 enable Output 1
add_interface_port adc_1_ch_2 adc_1_valid_i1 valid Output 1
add_interface_port adc_1_ch_2 adc_1_data_i1 data Output 16

add_interface adc_1_ch_3 conduit end
add_interface_port adc_1_ch_3 adc_1_enable_q1 enable Output 1
add_interface_port adc_1_ch_3 adc_1_valid_q1 valid Output 1
add_interface_port adc_1_ch_3 adc_1_data_q1 data Output 16

ad_interface signal adc_1_dovf input 1 ovf

set_interface_property adc_1_ch_0 associatedClock if_adc_1_clk
set_interface_property adc_1_ch_1 associatedClock if_adc_1_clk
set_interface_property adc_1_ch_2 associatedClock if_adc_1_clk
set_interface_property adc_1_ch_3 associatedClock if_adc_1_clk
set_interface_property adc_1_ch_0 associatedReset adc_1_rst
set_interface_property adc_1_ch_1 associatedReset adc_1_rst
set_interface_property adc_1_ch_2 associatedReset adc_1_rst
set_interface_property adc_1_ch_3 associatedReset adc_1_rst

add_interface adc_2_ch_0 conduit end
add_interface_port adc_2_ch_0 adc_2_enable_i0 enable Output 1
add_interface_port adc_2_ch_0 adc_2_valid_i0 valid Output 1
add_interface_port adc_2_ch_0 adc_2_data_i0 data Output 16

add_interface adc_2_ch_1 conduit end
add_interface_port adc_2_ch_1 adc_2_enable_q0 enable Output 1
add_interface_port adc_2_ch_1 adc_2_valid_q0 valid Output 1
add_interface_port adc_2_ch_1 adc_2_data_q0 data Output 16

ad_interface signal adc_2_dovf input 1 ovf

set_interface_property adc_2_ch_0 associatedClock if_adc_2_clk
set_interface_property adc_2_ch_1 associatedClock if_adc_2_clk
set_interface_property adc_2_ch_0 associatedReset adc_2_rst
set_interface_property adc_2_ch_1 associatedReset adc_2_rst

# DAC interfaces
add_interface dac_1_ch_0 conduit end
add_interface_port dac_1_ch_0 dac_1_enable_i0 enable Output 1
add_interface_port dac_1_ch_0 dac_1_valid_i0 valid Output 1
add_interface_port dac_1_ch_0 dac_1_data_i0 data Input 16

add_interface dac_1_ch_1 conduit end
add_interface_port dac_1_ch_1 dac_1_enable_q0 enable Output 1
add_interface_port dac_1_ch_1 dac_1_valid_q0 valid Output 1
add_interface_port dac_1_ch_1 dac_1_data_q0 data Input 16

add_interface dac_1_ch_2 conduit end
add_interface_port dac_1_ch_2 dac_1_enable_i1 enable Output 1
add_interface_port dac_1_ch_2 dac_1_valid_i1 valid Output 1
add_interface_port dac_1_ch_2 dac_1_data_i1 data Input 16

add_interface dac_1_ch_3 conduit end
add_interface_port dac_1_ch_3 dac_1_enable_q1 enable Output 1
add_interface_port dac_1_ch_3 dac_1_valid_q1 valid Output 1
add_interface_port dac_1_ch_3 dac_1_data_q1 data Input 16

set_interface_property dac_1_ch_0 associatedClock if_dac_1_clk
set_interface_property dac_1_ch_1 associatedClock if_dac_1_clk
set_interface_property dac_1_ch_2 associatedClock if_dac_1_clk
set_interface_property dac_1_ch_3 associatedClock if_dac_1_clk
set_interface_property dac_1_ch_0 associatedReset dac_1_rst
set_interface_property dac_1_ch_1 associatedReset dac_1_rst
set_interface_property dac_1_ch_2 associatedReset dac_1_rst
set_interface_property dac_1_ch_3 associatedReset dac_1_rst

ad_interface signal dac_1_dunf input 1 unf

add_interface dac_2_ch_0 conduit end
add_interface_port dac_2_ch_0 dac_2_enable_i0 enable Output 1
add_interface_port dac_2_ch_0 dac_2_valid_i0 valid Output 1
add_interface_port dac_2_ch_0 dac_2_data_i0 data Input 16

add_interface dac_2_ch_1 conduit end
add_interface_port dac_2_ch_1 dac_2_enable_q0 enable Output 1
add_interface_port dac_2_ch_1 dac_2_valid_q0 valid Output 1
add_interface_port dac_2_ch_1 dac_2_data_q0 data Input 16

ad_interface signal dac_2_dunf input 1 unf

set_interface_property dac_2_ch_0 associatedClock if_dac_2_clk
set_interface_property dac_2_ch_1 associatedClock if_dac_2_clk
set_interface_property dac_2_ch_0 associatedReset dac_2_rst
set_interface_property dac_2_ch_1 associatedReset dac_2_rst

add_interface tdd_if conduit end
add_interface_port tdd_if gpio_rx1_enable_in rx1_enable_in Input 1
add_interface_port tdd_if gpio_rx2_enable_in rx2_enable_in Input 1
add_interface_port tdd_if gpio_tx1_enable_in tx1_enable_in Input 1
add_interface_port tdd_if gpio_tx2_enable_in tx2_enable_in Input 1
add_interface_port tdd_if tdd_sync tdd_sync_in Input 1

# updates

proc axi_adrv9001_elab {} {
  set m_fpga_technology [get_parameter_value "FPGA_TECHNOLOGY"]
  set m_cmos_lvds_n [get_parameter_value "CMOS_LVDS_N"]

  add_hdl_instance adrv9001_gpio_in altera_gpio
  set_instance_parameter_value adrv9001_gpio_in {DEVICE_FAMILY} {Arria 10}
  set_instance_parameter_value adrv9001_gpio_in {PIN_TYPE_GUI} {Input}
  set_instance_parameter_value adrv9001_gpio_in {SIZE} {1}
  set_instance_parameter_value adrv9001_gpio_in {gui_io_reg_mode} {DDIO}

  add_hdl_instance adrv9001_gpio_out altera_gpio
  set_instance_parameter_value adrv9001_gpio_out {DEVICE_FAMILY} {Arria 10}
  set_instance_parameter_value adrv9001_gpio_out {PIN_TYPE_GUI} {Output}
  set_instance_parameter_value adrv9001_gpio_out {SIZE} {1}
  set_instance_parameter_value adrv9001_gpio_out {gui_io_reg_mode} {DDIO}

  add_hdl_instance periphery_clk_buf altclkctrl
  set_instance_parameter_value periphery_clk_buf {DEVICE_FAMILY} {Arria 10}
  set_instance_parameter_value periphery_clk_buf {CLOCK_TYPE} {Periphery Clock}

  add_interface device_if conduit end
  set_interface_property device_if associatedClock none
  set_interface_property device_if associatedReset none

  if {$m_cmos_lvds_n == 1} {

    add_interface_port device_if rx1_dclk_in_p_dclk_in     rx1_dclk_in_p_dclk_in     Input 1
    add_interface_port device_if rx1_idata_in_n_idata0     rx1_idata_in_n_idata0     Input 1
    add_interface_port device_if rx1_idata_in_p_idata1     rx1_idata_in_p_idata1     Input 1
    add_interface_port device_if rx1_qdata_in_n_qdata2     rx1_qdata_in_n_qdata2     Input 1
    add_interface_port device_if rx1_qdata_in_p_qdata3     rx1_qdata_in_p_qdata3     Input 1
    add_interface_port device_if rx1_strobe_in_p_strobe_in rx1_strobe_in_p_strobe_in Input 1
    add_interface_port device_if rx1_enable                rx1_enable                Output 1

    add_interface_port device_if rx2_dclk_in_p_dclk_in     rx2_dclk_in_p_dclk_in     Input 1
    add_interface_port device_if rx2_idata_in_n_idata0     rx2_idata_in_n_idata0     Input 1
    add_interface_port device_if rx2_idata_in_p_idata1     rx2_idata_in_p_idata1     Input 1
    add_interface_port device_if rx2_qdata_in_n_qdata2     rx2_qdata_in_n_qdata2     Input 1
    add_interface_port device_if rx2_qdata_in_p_qdata3     rx2_qdata_in_p_qdata3     Input 1
    add_interface_port device_if rx2_strobe_in_p_strobe_in rx2_strobe_in_p_strobe_in Input 1
    add_interface_port device_if rx2_enable                rx2_enable                Output 1

    add_interface_port device_if tx1_dclk_out_p_dclk_out     tx1_dclk_out_p_dclk_out     Output 1
    add_interface_port device_if tx1_dclk_in_p_dclk_in       tx1_dclk_in_p_dclk_in       Input 1
    add_interface_port device_if tx1_idata_out_n_idata0      tx1_idata_out_n_idata0      Output 1
    add_interface_port device_if tx1_idata_out_p_idata1      tx1_idata_out_p_idata1      Output 1
    add_interface_port device_if tx1_qdata_out_n_qdata2      tx1_qdata_out_n_qdata2      Output 1
    add_interface_port device_if tx1_qdata_out_p_qdata3      tx1_qdata_out_p_qdata3      Output 1
    add_interface_port device_if tx1_strobe_out_p_strobe_out tx1_strobe_out_p_strobe_out Output 1
    add_interface_port device_if tx1_enable                  tx1_enable                  Output 1

    add_interface_port device_if tx2_dclk_out_p_dclk_out     tx2_dclk_out_p_dclk_out     Output 1
    add_interface_port device_if tx2_dclk_in_p_dclk_in       tx2_dclk_in_p_dclk_in       Input 1
    add_interface_port device_if tx2_idata_out_n_idata0      tx2_idata_out_n_idata0      Output 1
    add_interface_port device_if tx2_idata_out_p_idata1      tx2_idata_out_p_idata1      Output 1
    add_interface_port device_if tx2_qdata_out_n_qdata2      tx2_qdata_out_n_qdata2      Output 1
    add_interface_port device_if tx2_qdata_out_p_qdata3      tx2_qdata_out_p_qdata3      Output 1
    add_interface_port device_if tx2_strobe_out_p_strobe_out tx2_strobe_out_p_strobe_out Output 1
    add_interface_port device_if tx2_enable                  tx2_enable                  Output 1
  }
}

