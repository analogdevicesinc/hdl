
package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

ad_ip_create axi_ad9361 {AXI AD9361 Interface} axi_ad9361_elab
ad_ip_files axi_ad9361 [list\
  $ad_hdl_dir/library/altera/common/ad_cmos_out_core_c5.v \
  $ad_hdl_dir/library/altera/common/ad_serdes_in_core_c5.v \
  $ad_hdl_dir/library/altera/common/ad_serdes_out_core_c5.v \
  $ad_hdl_dir/library/altera/common/ad_mul.v \
  $ad_hdl_dir/library/altera/common/ad_dcfilter.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/ad_pnmon.v \
  $ad_hdl_dir/library/common/ad_dds_sine.v \
  $ad_hdl_dir/library/common/ad_dds_1.v \
  $ad_hdl_dir/library/common/ad_dds.v \
  $ad_hdl_dir/library/common/ad_datafmt.v \
  $ad_hdl_dir/library/common/ad_iqcor.v \
  $ad_hdl_dir/library/common/ad_addsub.v \
  $ad_hdl_dir/library/common/ad_tdd_control.v \
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
  altera/axi_ad9361_lvds_if.v \
  altera/axi_ad9361_cmos_if.v \
  axi_ad9361_rx_pnmon.v \
  axi_ad9361_rx_channel.v \
  axi_ad9361_rx.v \
  axi_ad9361_tx_channel.v \
  axi_ad9361_tx.v \
  axi_ad9361_tdd.v \
  axi_ad9361_tdd_if.v \
  axi_ad9361.v \
  $ad_hdl_dir/library/common/ad_axi_ip_constr.sdc \
  axi_ad9361_constr.sdc] \
  axi_ad9361_fileset

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter ID INTEGER 0
ad_ip_parameter MODE_1R1T INTEGER 0
ad_ip_parameter DEVICE_TYPE INTEGER 0
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

# interfaces

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn
 
ad_alt_intf signal dac_sync_in input 1
ad_alt_intf signal dac_sync_out output 1
ad_alt_intf signal tdd_sync input 1
ad_alt_intf signal tdd_sync_cntr output 1

ad_alt_intf clock delay_clk input 1
ad_alt_intf clock l_clk output 1
ad_alt_intf clock clk input 1

ad_alt_intf reset rst output 1 if_clk
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

ad_alt_intf signal adc_dovf input 1 ovf
ad_alt_intf signal adc_dunf input 1 unf
ad_alt_intf signal adc_r1_mode output 1 r1_mode

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

ad_alt_intf signal dac_dovf input 1 ovf
ad_alt_intf signal dac_dunf input 1 unf
ad_alt_intf signal dac_r1_mode output 1 r1_mode

ad_alt_intf signal up_enable input 1
ad_alt_intf signal up_txnrx input 1
ad_alt_intf signal up_dac_gpio_in input 32
ad_alt_intf signal up_dac_gpio_out output 32
ad_alt_intf signal up_adc_gpio_in input 32
ad_alt_intf signal up_adc_gpio_out output 32

# generated cores

add_hdl_instance ad_serdes_clk_core alt_serdes
set_instance_parameter_value ad_serdes_clk_core {MODE} {CLK}
set_instance_parameter_value ad_serdes_clk_core {DDR_OR_SDR_N} {1}
set_instance_parameter_value ad_serdes_clk_core {SERDES_FACTOR} {4}
set_instance_parameter_value ad_serdes_clk_core {CLKIN_FREQUENCY} {250.0}

add_hdl_instance ad_serdes_in_core_a10 alt_serdes
set_instance_parameter_value ad_serdes_in_core_a10 {MODE} {IN}
set_instance_parameter_value ad_serdes_in_core_a10 {DDR_OR_SDR_N} {1}
set_instance_parameter_value ad_serdes_in_core_a10 {SERDES_FACTOR} {4}
set_instance_parameter_value ad_serdes_in_core_a10 {CLKIN_FREQUENCY} {250.0}

add_hdl_instance ad_serdes_out_core_a10 alt_serdes
set_instance_parameter_value ad_serdes_out_core_a10 {MODE} {OUT}
set_instance_parameter_value ad_serdes_out_core_a10 {DDR_OR_SDR_N} {1}
set_instance_parameter_value ad_serdes_out_core_a10 {SERDES_FACTOR} {4}
set_instance_parameter_value ad_serdes_out_core_a10 {CLKIN_FREQUENCY} {250.0}

add_hdl_instance ad_cmos_out_core_a10 alt_serdes
set_instance_parameter_value ad_cmos_out_core_a10 {MODE} {OUT}
set_instance_parameter_value ad_cmos_out_core_a10 {DDR_OR_SDR_N} {1}
set_instance_parameter_value ad_cmos_out_core_a10 {SERDES_FACTOR} {2}
set_instance_parameter_value ad_cmos_out_core_a10 {CLKIN_FREQUENCY} {250.0}

# updates

proc axi_ad9361_elab {} {

  set m_cmos_or_lvds_n [get_parameter_value CMOS_OR_LVDS_N]

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

proc axi_ad9361_fileset {entityName} {

  ad_ip_modfile ad_cmos_out.v ad_cmos_out.v ad_cmos_out_core_a10
  ad_ip_modfile ad_serdes_in.v ad_serdes_in.v ad_serdes_in_core_a10
  ad_ip_modfile ad_serdes_out.v ad_serdes_out.v ad_serdes_out_core_a10
  ad_ip_modfile ad_serdes_clk.v ad_serdes_clk.v ad_serdes_clk_core
}

