
package require qsys
package require quartus::device

source ../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create axi_ad9361 {AXI AD9361 Interface} axi_ad9361_elab
set_module_property VALIDATION_CALLBACK info_param_validate

ad_ip_files axi_ad9361 [list\
  $ad_hdl_dir/library/intel/common/ad_mul.v \
  $ad_hdl_dir/library/intel/common/ad_dcfilter.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/ad_pnmon.v \
  $ad_hdl_dir/library/common/ad_dds_cordic_pipe.v \
  $ad_hdl_dir/library/common/ad_dds_sine_cordic.v \
  $ad_hdl_dir/library/common/ad_dds_sine.v \
  $ad_hdl_dir/library/common/ad_dds_2.v \
  $ad_hdl_dir/library/common/ad_dds_1.v \
  $ad_hdl_dir/library/common/ad_dds.v \
  $ad_hdl_dir/library/common/ad_datafmt.v \
  $ad_hdl_dir/library/common/ad_iqcor.v \
  $ad_hdl_dir/library/common/ad_addsub.v \
  $ad_hdl_dir/library/common/ad_tdd_control.v \
  $ad_hdl_dir/library/common/ad_pps_receiver.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/up_xfer_cntrl.v \
  $ad_hdl_dir/library/common/up_xfer_status.v \
  $ad_hdl_dir/library/common/up_clock_mon.v \
  $ad_hdl_dir/library/common/up_delay_cntrl.v \
  $ad_hdl_dir/library/common/up_adc_common.v \
  $ad_hdl_dir/library/common/up_adc_channel.v \
  $ad_hdl_dir/library/common/up_dac_common.v \
  $ad_hdl_dir/library/common/up_dac_channel.v \
  $ad_hdl_dir/library/common/up_tdd_cntrl.v \
  intel/axi_ad9361_lvds_if_10.v \
  intel/axi_ad9361_lvds_if_c5.v \
  intel/axi_ad9361_lvds_if.v \
  intel/axi_ad9361_cmos_if.v \
  axi_ad9361_rx_pnmon.v \
  axi_ad9361_rx_channel.v \
  axi_ad9361_rx.v \
  axi_ad9361_tx_channel.v \
  axi_ad9361_tx.v \
  axi_ad9361_tdd.v \
  axi_ad9361_tdd_if.v \
  axi_ad9361.v \
  $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
  axi_ad9361_constr.sdc]

# parameters

ad_ip_parameter ID INTEGER 0
ad_ip_parameter MODE_1R1T INTEGER 0
ad_ip_parameter TDD_DISABLE INTEGER 0
ad_ip_parameter CMOS_OR_LVDS_N INTEGER 0
ad_ip_parameter ADC_DATAPATH_DISABLE INTEGER 0
ad_ip_parameter ADC_USERPORTS_DISABLE INTEGER 0
ad_ip_parameter ADC_DATAFORMAT_DISABLE INTEGER 0
ad_ip_parameter ADC_DCFILTER_DISABLE INTEGER 0
ad_ip_parameter ADC_IQCORRECTION_DISABLE INTEGER 0
ad_ip_parameter DAC_IODELAY_ENABLE INTEGER 0
ad_ip_parameter DAC_DATAPATH_DISABLE INTEGER 0
ad_ip_parameter DAC_DDS_DISABLE INTEGER 0
ad_ip_parameter DAC_USERPORTS_DISABLE INTEGER 0
ad_ip_parameter DAC_IQCORRECTION_DISABLE INTEGER 0
ad_ip_parameter IO_DELAY_GROUP STRING {dev_if_delay_group}
ad_ip_parameter MIMO_ENABLE INTEGER 0
ad_ip_parameter RX_NODPA INTEGER 0

adi_add_auto_fpga_spec_params

# interfaces

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

ad_interface signal dac_sync_in input 1
ad_interface signal dac_sync_out output 1
ad_interface signal tdd_sync input 1
ad_interface signal tdd_sync_cntr output 1

ad_interface clock delay_clk input 1
ad_interface clock l_clk output 1
ad_interface clock clk input 1

ad_interface reset rst output 1 if_clk
set_interface_property if_rst associatedResetSinks s_axi_reset

add_interface adc_ch_0 conduit end
add_interface_port adc_ch_0 adc_enable_i0 enable Output 1
add_interface_port adc_ch_0 adc_valid_i0 valid Output 1
add_interface_port adc_ch_0 adc_data_i0 data Output 16

set_interface_property adc_ch_0 associatedClock if_clk
set_interface_property adc_ch_0 associatedReset none

add_interface adc_ch_1 conduit end
add_interface_port adc_ch_1 adc_enable_q0 enable Output 1
add_interface_port adc_ch_1 adc_valid_q0 valid Output 1
add_interface_port adc_ch_1 adc_data_q0 data Output 16

set_interface_property adc_ch_1 associatedClock if_clk
set_interface_property adc_ch_1 associatedReset none

add_interface adc_ch_2 conduit end
add_interface_port adc_ch_2 adc_enable_i1 enable Output 1
add_interface_port adc_ch_2 adc_valid_i1 valid Output 1
add_interface_port adc_ch_2 adc_data_i1 data Output 16

set_interface_property adc_ch_2 associatedClock if_clk
set_interface_property adc_ch_2 associatedReset none

add_interface adc_ch_3 conduit end
add_interface_port adc_ch_3 adc_enable_q1 enable Output 1
add_interface_port adc_ch_3 adc_valid_q1 valid Output 1
add_interface_port adc_ch_3 adc_data_q1 data Output 16

set_interface_property adc_ch_3 associatedClock if_clk
set_interface_property adc_ch_3 associatedReset none

ad_interface signal adc_dovf input 1 ovf
ad_interface signal adc_r1_mode output 1 r1_mode

add_interface dac_ch_0 conduit end
add_interface_port dac_ch_0 dac_enable_i0 enable Output 1
add_interface_port dac_ch_0 dac_valid_i0 valid Output 1
add_interface_port dac_ch_0 dac_data_i0 data Input 16

set_interface_property dac_ch_0 associatedClock if_clk
set_interface_property dac_ch_0 associatedReset none

add_interface dac_ch_1 conduit end
add_interface_port dac_ch_1 dac_enable_q0 enable Output 1
add_interface_port dac_ch_1 dac_valid_q0 valid Output 1
add_interface_port dac_ch_1 dac_data_q0 data Input 16

set_interface_property dac_ch_1 associatedClock if_clk
set_interface_property dac_ch_1 associatedReset none

add_interface dac_ch_2 conduit end
add_interface_port dac_ch_2 dac_enable_i1 enable Output 1
add_interface_port dac_ch_2 dac_valid_i1 valid Output 1
add_interface_port dac_ch_2 dac_data_i1 data Input 16

set_interface_property dac_ch_2 associatedClock if_clk
set_interface_property dac_ch_2 associatedReset none

add_interface dac_ch_3 conduit end
add_interface_port dac_ch_3 dac_enable_q1 enable Output 1
add_interface_port dac_ch_3 dac_valid_q1 valid Output 1
add_interface_port dac_ch_3 dac_data_q1 data Input 16

set_interface_property dac_ch_3 associatedClock if_clk
set_interface_property dac_ch_3 associatedReset none

ad_interface signal dac_dunf input 1 unf
ad_interface signal dac_r1_mode output 1 r1_mode

ad_interface signal up_enable input 1
ad_interface signal up_txnrx input 1
ad_interface signal up_dac_gpio_in input 32
ad_interface signal up_dac_gpio_out output 32
ad_interface signal up_adc_gpio_in input 32
ad_interface signal up_adc_gpio_out output 32

# updates

proc axi_ad9361_elab {} {

  set m_fpga_technology [get_parameter_value "FPGA_TECHNOLOGY"]
  set m_cmos_or_lvds_n [get_parameter_value "CMOS_OR_LVDS_N"]
  set rx_nodpa [get_parameter_value "RX_NODPA"]

  # 103 - stands for "Arria 10" see adi_intel_device_info_enc.tcl
  if {$m_fpga_technology == 103} {

    add_hdl_instance axi_ad9361_serdes_clk intel_serdes 1.0
    set_instance_parameter_value axi_ad9361_serdes_clk {DEVICE_FAMILY} {Arria 10}
    set_instance_parameter_value axi_ad9361_serdes_clk {MODE} {CLK}
    set_instance_parameter_value axi_ad9361_serdes_clk {DDR_OR_SDR_N} {1}
    set_instance_parameter_value axi_ad9361_serdes_clk {SERDES_FACTOR} {4}
    set_instance_parameter_value axi_ad9361_serdes_clk {CLKIN_FREQUENCY} {250.0}

    set rx_serdes_mode IN
    if {$rx_nodpa == 1} {set rx_serdes_mode IN_NODPA}

    add_hdl_instance axi_ad9361_serdes_in intel_serdes 1.0
    set_instance_parameter_value axi_ad9361_serdes_in {DEVICE_FAMILY} {Arria 10}
    set_instance_parameter_value axi_ad9361_serdes_in {MODE} $rx_serdes_mode
    set_instance_parameter_value axi_ad9361_serdes_in {DDR_OR_SDR_N} {1}
    set_instance_parameter_value axi_ad9361_serdes_in {SERDES_FACTOR} {4}
    set_instance_parameter_value axi_ad9361_serdes_in {CLKIN_FREQUENCY} {250.0}

    add_hdl_instance axi_ad9361_serdes_out intel_serdes 1.0
    set_instance_parameter_value axi_ad9361_serdes_out {DEVICE_FAMILY} {Arria 10}
    set_instance_parameter_value axi_ad9361_serdes_out {MODE} {OUT}
    set_instance_parameter_value axi_ad9361_serdes_out {DDR_OR_SDR_N} {1}
    set_instance_parameter_value axi_ad9361_serdes_out {SERDES_FACTOR} {4}
    set_instance_parameter_value axi_ad9361_serdes_out {CLKIN_FREQUENCY} {250.0}

    add_hdl_instance axi_ad9361_data_out altera_gpio 19.1
    set_instance_parameter_value axi_ad9361_data_out {DEVICE_FAMILY} {Arria 10}
    set_instance_parameter_value axi_ad9361_data_out {PIN_TYPE_GUI} {Output}
    set_instance_parameter_value axi_ad9361_data_out {SIZE} {1}
    set_instance_parameter_value axi_ad9361_data_out {gui_io_reg_mode} {DDIO}

    add_hdl_instance clk_buffer altclkctrl 19.1
    set_instance_parameter_value clk_buffer {DEVICE_FAMILY} {Arria 10}

  }

  add_interface device_if conduit end
  set_interface_property device_if associatedClock none
  set_interface_property device_if associatedReset none

  if {$m_cmos_or_lvds_n == 1} {

    add_interface_port device_if rx_clk_in rx_clk_in Input 1
    add_interface_port device_if rx_frame_in rx_frame_in Input 1
    add_interface_port device_if rx_data_in rx_data_in Input 12
    add_interface_port device_if tx_clk_out tx_clk_out Output 1
    add_interface_port device_if tx_frame_out tx_frame_out Output 1
    add_interface_port device_if tx_data_out tx_data_out Output 12
  }

  if {$m_cmos_or_lvds_n == 0} {

    add_interface_port device_if rx_clk_in_p rx_clk_in_p Input 1
    add_interface_port device_if rx_clk_in_n rx_clk_in_n Input 1
    add_interface_port device_if rx_frame_in_p rx_frame_in_p Input 1
    add_interface_port device_if rx_frame_in_n rx_frame_in_n Input 1
    add_interface_port device_if rx_data_in_p rx_data_in_p Input 6
    add_interface_port device_if rx_data_in_n rx_data_in_n Input 6
    add_interface_port device_if tx_clk_out_p tx_clk_out_p Output 1
    add_interface_port device_if tx_clk_out_n tx_clk_out_n Output 1
    add_interface_port device_if tx_frame_out_p tx_frame_out_p Output 1
    add_interface_port device_if tx_frame_out_n tx_frame_out_n Output 1
    add_interface_port device_if tx_data_out_p tx_data_out_p Output 6
    add_interface_port device_if tx_data_out_n tx_data_out_n Output 6
  }

  add_interface_port device_if enable enable Output 1
  add_interface_port device_if txnrx txnrx Output 1
}

