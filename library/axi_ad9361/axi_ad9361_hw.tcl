

package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

set_module_property NAME axi_ad9361
set_module_property DESCRIPTION "AXI AD9361 Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad9361
set_module_property ELABORATION_CALLBACK p_axi_ad9361

# files

add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL axi_ad9361
add_fileset_file ad_rst.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file ad_lvds_clk.v            VERILOG PATH $ad_hdl_dir/library/altera/common/ad_lvds_clk.v
add_fileset_file ad_lvds_in.v             VERILOG PATH $ad_hdl_dir/library/altera/common/ad_lvds_in.v
add_fileset_file ad_lvds_out.v            VERILOG PATH $ad_hdl_dir/library/altera/common/ad_lvds_out.v
add_fileset_file ad_cmos_clk.v            VERILOG PATH $ad_hdl_dir/library/altera/common/ad_cmos_clk.v
add_fileset_file ad_cmos_in.v             VERILOG PATH $ad_hdl_dir/library/altera/common/ad_cmos_in.v
add_fileset_file ad_cmos_out.v            VERILOG PATH $ad_hdl_dir/library/altera/common/ad_cmos_out.v
add_fileset_file ad_mul.v                 VERILOG PATH $ad_hdl_dir/library/altera/common/ad_mul.v
add_fileset_file ad_pnmon.v               VERILOG PATH $ad_hdl_dir/library/common/ad_pnmon.v
add_fileset_file ad_dds_sine.v            VERILOG PATH $ad_hdl_dir/library/common/ad_dds_sine.v
add_fileset_file ad_dds_1.v               VERILOG PATH $ad_hdl_dir/library/common/ad_dds_1.v
add_fileset_file ad_dds.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_dds.v
add_fileset_file ad_datafmt.v             VERILOG PATH $ad_hdl_dir/library/common/ad_datafmt.v
add_fileset_file ad_dcfilter.v            VERILOG PATH $ad_hdl_dir/library/common/ad_dcfilter.v
add_fileset_file ad_iqcor.v               VERILOG PATH $ad_hdl_dir/library/common/ad_iqcor.v
add_fileset_file ad_addsub.v              VERILOG PATH $ad_hdl_dir/library/common/ad_addsub.v
add_fileset_file ad_tdd_control.v         VERILOG PATH $ad_hdl_dir/library/common/ad_tdd_control.v
add_fileset_file up_axi.v                 VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v          VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v         VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v           VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_delay_cntrl.v         VERILOG PATH $ad_hdl_dir/library/common/up_delay_cntrl.v
add_fileset_file up_adc_common.v          VERILOG PATH $ad_hdl_dir/library/common/up_adc_common.v
add_fileset_file up_adc_channel.v         VERILOG PATH $ad_hdl_dir/library/common/up_adc_channel.v
add_fileset_file up_dac_common.v          VERILOG PATH $ad_hdl_dir/library/common/up_dac_common.v
add_fileset_file up_dac_channel.v         VERILOG PATH $ad_hdl_dir/library/common/up_dac_channel.v
add_fileset_file up_tdd_cntrl.v           VERILOG PATH $ad_hdl_dir/library/common/up_tdd_cntrl.v
add_fileset_file axi_ad9361_lvds_if.v     VERILOG PATH axi_ad9361_lvds_if.v
add_fileset_file axi_ad9361_cmos_if.v     VERILOG PATH axi_ad9361_cmos_if.v
add_fileset_file axi_ad9361_rx_pnmon.v    VERILOG PATH axi_ad9361_rx_pnmon.v
add_fileset_file axi_ad9361_rx_channel.v  VERILOG PATH axi_ad9361_rx_channel.v
add_fileset_file axi_ad9361_rx.v          VERILOG PATH axi_ad9361_rx.v
add_fileset_file axi_ad9361_tx_channel.v  VERILOG PATH axi_ad9361_tx_channel.v
add_fileset_file axi_ad9361_tx.v          VERILOG PATH axi_ad9361_tx.v
add_fileset_file axi_ad9361_tdd.v         VERILOG PATH axi_ad9361_tdd.v
add_fileset_file axi_ad9361_tdd_if.v      VERILOG PATH axi_ad9361_tdd_if.v
add_fileset_file axi_ad9361.v             VERILOG PATH axi_ad9361.v TOP_LEVEL_FILE
add_fileset_file ad_axi_ip_constr.sdc     SDC     PATH $ad_hdl_dir/library/common/ad_axi_ip_constr.sdc
add_fileset_file axi_ad9361_constr.sdc    SDC     PATH axi_ad9361_constr.sdc

# parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID TYPE INTEGER
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

add_parameter DEVICE_TYPE INTEGER 0
set_parameter_property DEVICE_TYPE DEFAULT_VALUE 0
set_parameter_property DEVICE_TYPE DISPLAY_NAME DEVICE_TYPE
set_parameter_property DEVICE_TYPE TYPE INTEGER
set_parameter_property DEVICE_TYPE UNITS None
set_parameter_property DEVICE_TYPE HDL_PARAMETER true

add_parameter CMOS_OR_LVDS_N INTEGER 0
set_parameter_property CMOS_OR_LVDS_N DEFAULT_VALUE 0
set_parameter_property CMOS_OR_LVDS_N DISPLAY_NAME CMOS_OR_LVDS_N
set_parameter_property CMOS_OR_LVDS_N TYPE INTEGER
set_parameter_property CMOS_OR_LVDS_N UNITS None
set_parameter_property CMOS_OR_LVDS_N HDL_PARAMETER true

add_parameter DAC_DATAPATH_DISABLE INTEGER 0
set_parameter_property DAC_DATAPATH_DISABLE DEFAULT_VALUE 0
set_parameter_property DAC_DATAPATH_DISABLE DISPLAY_NAME DAC_DATAPATH_DISABLE
set_parameter_property DAC_DATAPATH_DISABLE TYPE INTEGER
set_parameter_property DAC_DATAPATH_DISABLE UNITS None
set_parameter_property DAC_DATAPATH_DISABLE HDL_PARAMETER true

add_parameter ADC_DATAPATH_DISABLE INTEGER 0
set_parameter_property ADC_DATAPATH_DISABLE DEFAULT_VALUE 0
set_parameter_property ADC_DATAPATH_DISABLE DISPLAY_NAME ADC_DATAPATH_DISABLE
set_parameter_property ADC_DATAPATH_DISABLE TYPE INTEGER
set_parameter_property ADC_DATAPATH_DISABLE UNITS None
set_parameter_property ADC_DATAPATH_DISABLE HDL_PARAMETER true

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY AFFECTS_GENERATION true
set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
set_parameter_property DEVICE_FAMILY ENABLED false

# axi4 slave interface

add_interface s_axi_clock clock end
add_interface_port s_axi_clock s_axi_aclk clk Input 1

add_interface s_axi_reset reset end
set_interface_property s_axi_reset associatedClock s_axi_clock
add_interface_port s_axi_reset s_axi_aresetn reset_n Input 1

add_interface s_axi axi4lite end
set_interface_property s_axi associatedClock s_axi_clock
set_interface_property s_axi associatedReset s_axi_reset
add_interface_port s_axi s_axi_awvalid awvalid Input 1
add_interface_port s_axi s_axi_awaddr awaddr Input 16
add_interface_port s_axi s_axi_awprot awprot Input 3
add_interface_port s_axi s_axi_awready awready Output 1
add_interface_port s_axi s_axi_wvalid wvalid Input 1
add_interface_port s_axi s_axi_wdata wdata Input 32
add_interface_port s_axi s_axi_wstrb wstrb Input 4
add_interface_port s_axi s_axi_wready wready Output 1
add_interface_port s_axi s_axi_bvalid bvalid Output 1
add_interface_port s_axi s_axi_bresp bresp Output 2
add_interface_port s_axi s_axi_bready bready Input 1
add_interface_port s_axi s_axi_arvalid arvalid Input 1
add_interface_port s_axi s_axi_araddr araddr Input 16
add_interface_port s_axi s_axi_arprot arprot Input 3
add_interface_port s_axi s_axi_arready arready Output 1
add_interface_port s_axi s_axi_rvalid rvalid Output 1
add_interface_port s_axi s_axi_rresp rresp Output 2
add_interface_port s_axi s_axi_rdata rdata Output 32
add_interface_port s_axi s_axi_rready rready Input 1

# master-slave interface

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

add_hdl_instance alt_ddio_in altera_gpio
set_instance_parameter_value alt_ddio_in {PIN_TYPE_GUI} {Input}
set_instance_parameter_value alt_ddio_in {SIZE} {1}
set_instance_parameter_value alt_ddio_in {gui_diff_buff} {0}
set_instance_parameter_value alt_ddio_in {gui_io_reg_mode} {DDIO}

add_hdl_instance alt_ddio_out altera_gpio
set_instance_parameter_value alt_ddio_out {PIN_TYPE_GUI} {Output}
set_instance_parameter_value alt_ddio_out {SIZE} {1}
set_instance_parameter_value alt_ddio_out {gui_diff_buff} {0}
set_instance_parameter_value alt_ddio_out {gui_io_reg_mode} {DDIO}

add_hdl_instance alt_clk altera_iopll
set_instance_parameter_value alt_clk {gui_reference_clock_frequency} {250.0}
set_instance_parameter_value alt_clk {gui_use_locked} {1}
set_instance_parameter_value alt_clk {gui_operation_mode} {source synchronous}
set_instance_parameter_value alt_clk {gui_number_of_clocks} {1}
set_instance_parameter_value alt_clk {gui_output_clock_frequency0} {250.0}
set_instance_parameter_value alt_clk {gui_ps_units0} {degrees}
set_instance_parameter_value alt_clk {gui_phase_shift_deg0} {90.0}
set_instance_parameter_value alt_clk {system_info_device_family} DEVICE_FAMILY

# updates

proc p_axi_ad9361 {} {

  set m_cmos_or_lvds_n [get_parameter_value CMOS_OR_LVDS_N]
  set m_device_type [get_parameter_value DEVICE_TYPE]
  set m_device_family [get_parameter_value DEVICE_FAMILY]

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

  if {$m_device_type == 1} {

    ## add_hdl_instance do not work here (pending altera support)
  }

  if {$m_device_type == 0} {

    ## add_hdl_instance do not work here (pending altera support)
  }
}

