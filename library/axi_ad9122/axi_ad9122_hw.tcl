
package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

set_module_property NAME axi_ad9122
set_module_property DESCRIPTION "AXI AD9122 Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad9122

# files

add_fileset quartus_synth QUARTUS_SYNTH "ad9122_fileset_callback" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9122

add_fileset_file ad_mul.v                 VERILOG PATH  $ad_hdl_dir/library/xilinx/common/ad_mul.v
add_fileset_file ad_dds_sine.v            VERILOG PATH  $ad_hdl_dir/library/common/ad_dds_sine.v
add_fileset_file ad_dds_1.v               VERILOG PATH  $ad_hdl_dir/library/common/ad_dds_1.v
add_fileset_file ad_dds.v                 VERILOG PATH  $ad_hdl_dir/library/common/ad_dds.v
add_fileset_file ad_rst.v                 VERILOG PATH  $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file ad_mmcm_drp.v            VERILOG PATH  $ad_hdl_dir/library/xilinx/common/ad_mmcm_drp.v
add_fileset_file ad_serdes_out.v          VERILOG PATH  $ad_hdl_dir/library/xilinx/common/ad_serdes_out.v
add_fileset_file up_axi.v                 VERILOG PATH  $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v          VERILOG PATH  $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v         VERILOG PATH  $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v           VERILOG PATH  $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_dac_common.v          VERILOG PATH  $ad_hdl_dir/library/common/up_dac_common.v
add_fileset_file up_dac_channel.v         VERILOG PATH  $ad_hdl_dir/library/common/up_dac_channel.v
add_fileset_file axi_ad9122_channel.v     VERILOG PATH  axi_ad9122_channel.v
add_fileset_file axi_ad9122_core.v        VERILOG PATH  axi_ad9122_core.v
add_fileset_file axi_ad9122_if.v          VERILOG PATH  axi_ad9122_if.v
add_fileset_file axi_ad9122.v             VERILOG PATH  axi_ad9122.v TOP_LEVEL_FILE
add_fileset_file ad_axi_ip_constr.sdc     SDC     PATH  $ad_hdl_dir/library/common/ad_axi_ip_constr.sdc
add_fileset_file axi_ad9122_constr.sdc    SDC     PATH  axi_ad9122_constr.sdc

# paramter for fileset callback

add_parameter HDL_LIB_PATH STRING $ad_hdl_dir
set_parameter_property HDL_LIB_PATH TYPE STRING
set_parameter_property HDL_LIB_PATH HDL_PARAMETER false

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

add_parameter SERDES_OR_DDR_N INTEGER 0
set_parameter_property SERDES_OR_DDR_N DEFAULT_VALUE 1
set_parameter_property SERDES_OR_DDR_N DISPLAY_NAME SERDES_OR_DDR_N
set_parameter_property SERDES_OR_DDR_N TYPE INTEGER
set_parameter_property SERDES_OR_DDR_N UNITS None
set_parameter_property SERDES_OR_DDR_N HDL_PARAMETER true

add_parameter MMCM_OR_BUFIO_N INTEGER 0
set_parameter_property MMCM_OR_BUFIO_N DEFAULT_VALUE 0
set_parameter_property MMCM_OR_BUFIO_N DISPLAY_NAME MMCM_OR_BUFIO_N
set_parameter_property MMCM_OR_BUFIO_N TYPE INTEGER
set_parameter_property MMCM_OR_BUFIO_N UNITS None
set_parameter_property MMCM_OR_BUFIO_N HDL_PARAMETER false

add_parameter MMCM_CLKIN_PERIOD FLOAT 0
set_parameter_property MMCM_CLKIN_PERIOD DEFAULT_VALUE 1.667
set_parameter_property MMCM_CLKIN_PERIOD DISPLAY_NAME MMCM_CLKIN_PERIOD
set_parameter_property MMCM_CLKIN_PERIOD TYPE INTEGER
set_parameter_property MMCM_CLKIN_PERIOD UNITS None
set_parameter_property MMCM_CLKIN_PERIOD HDL_PARAMETER false

add_parameter MMCM_VCO_DIV INTEGER 0
set_parameter_property MMCM_VCO_DIV DEFAULT_VALUE 2
set_parameter_property MMCM_VCO_DIV DISPLAY_NAME MMCM_VCO_DIV
set_parameter_property MMCM_VCO_DIV TYPE INTEGER
set_parameter_property MMCM_VCO_DIV UNITS None
set_parameter_property MMCM_VCO_DIV HDL_PARAMETER false

add_parameter MMCM_VCO_MUL INTEGER 0
set_parameter_property MMCM_VCO_MUL DEFAULT_VALUE 4
set_parameter_property MMCM_VCO_MUL DISPLAY_NAME MMCM_VCO_MUL
set_parameter_property MMCM_VCO_MUL TYPE INTEGER
set_parameter_property MMCM_VCO_MUL UNITS None
set_parameter_property MMCM_VCO_MUL HDL_PARAMETER false

add_parameter MMCM_CLK0_DIV INTEGER 0
set_parameter_property MMCM_CLK0_DIV DEFAULT_VALUE 2
set_parameter_property MMCM_CLK0_DIV DISPLAY_NAME MMCM_CLK0_DIV
set_parameter_property MMCM_CLK0_DIV TYPE INTEGER
set_parameter_property MMCM_CLK0_DIV UNITS None
set_parameter_property MMCM_CLK0_DIV HDL_PARAMETER false

add_parameter MMCM_CLK1_DIV INTEGER 0
set_parameter_property MMCM_CLK1_DIV DEFAULT_VALUE 8
set_parameter_property MMCM_CLK1_DIV DISPLAY_NAME MMCM_CLK1_DIV
set_parameter_property MMCM_CLK1_DIV TYPE INTEGER
set_parameter_property MMCM_CLK1_DIV UNITS None
set_parameter_property MMCM_CLK1_DIV HDL_PARAMETER false

add_parameter DAC_DATAPATH_DISABLE INTEGER 0
set_parameter_property DAC_DATAPATH_DISABLE DEFAULT_VALUE 8
set_parameter_property DAC_DATAPATH_DISABLE DISPLAY_NAME DAC_DATAPATH_DISABLE
set_parameter_property DAC_DATAPATH_DISABLE TYPE INTEGER
set_parameter_property DAC_DATAPATH_DISABLE UNITS None
set_parameter_property DAC_DATAPATH_DISABLE HDL_PARAMETER true

add_parameter IO_DELAY_GROUP INTEGER 0
set_parameter_property IO_DELAY_GROUP DEFAULT_VALUE 8
set_parameter_property IO_DELAY_GROUP DISPLAY_NAME IO_DELAY_GROUP
set_parameter_property IO_DELAY_GROUP TYPE INTEGER
set_parameter_property IO_DELAY_GROUP UNITS None
set_parameter_property IO_DELAY_GROUP HDL_PARAMETER true

# axi4 slave

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

# dac device interface

add_interface device_if conduit end
set_interface_property device_if associatedClock none
set_interface_property device_if associatedReset none

add_interface_port device_if dac_clk_in_p dac_clk_in_p Input 1
add_interface_port device_if dac_clk_in_n dac_clk_in_n Input 1
add_interface_port device_if dac_clk_out_p dac_clk_out_p Output 1
add_interface_port device_if dac_clk_out_n dac_clk_out_n Output 1
add_interface_port device_if dac_frame_out_p dac_frame_out_p Output 1
add_interface_port device_if dac_frame_out_n dac_frame_out_n Output 1
add_interface_port device_if dac_data_out_p dac_data_out_p Output 16
add_interface_port device_if dac_data_out_n dac_data_out_n Output 16

add_interface_port device_if dac_sync_out dac_sync_out Output 1
add_interface_port device_if dac_sync_in  dac_sync_in  Input 1

# dma interface

ad_alt_intf clock dac_div_clk Output 1

add_interface dac_ch_0 conduit end
add_interface_port dac_ch_0 dac_valid_0   valid  Output 1
add_interface_port dac_ch_0 dac_enable_0  enable Output 1
add_interface_port dac_ch_0 dac_ddata_0   data   Input 64
set_interface_property dac_ch_0 associatedClock if_dac_div_clk
set_interface_property dac_ch_0 associatedReset none

add_interface dac_ch_1 conduit end
add_interface_port dac_ch_1 dac_valid_1   valid  Output 1
add_interface_port dac_ch_1 dac_enable_1  enable Output 1
add_interface_port dac_ch_1 dac_ddata_1   data   Input 64
set_interface_property dac_ch_1 associatedClock if_dac_div_clk
set_interface_property dac_ch_1 associatedReset none

ad_alt_intf signal dac_dovf input 1 ovf
ad_alt_intf signal dac_dunf input 1 unf

# SERDES instances and configurations

add_hdl_instance alt_serdes_clk_core_tx alt_serdes
set_instance_parameter_value alt_serdes_clk_core_tx {MODE} {CLK}
set_instance_parameter_value alt_serdes_clk_core_tx {DDR_OR_SDR_N} {1}
set_instance_parameter_value alt_serdes_clk_core_tx {SERDES_FACTOR} {8}
set_instance_parameter_value alt_serdes_clk_core_tx {CLKIN_FREQUENCY} {500.0}

add_hdl_instance alt_serdes_out_core alt_serdes
set_instance_parameter_value alt_serdes_out_core {MODE} {OUT}
set_instance_parameter_value alt_serdes_out_core {DDR_OR_SDR_N} {1}
set_instance_parameter_value alt_serdes_out_core {SERDES_FACTOR} {8}
set_instance_parameter_value alt_serdes_out_core {CLKIN_FREQUENCY} {500.0}

# fileset callback to create the SERDES CLOCK instances

proc ad9122_fileset_callback { entityName } {

  send_message INFO "Generating SERDES clock instance for $entityName"
  set ad_hdl_dir [get_parameter_value HDL_LIB_PATH]
  exec mkdir -p generated

  # copy the generic ad_serdes_clk into working directory with modified ALT_IOPLL instance name
  ad_generate_module_inst "alt_serdes_clk_core" "tx" $ad_hdl_dir/library/altera/common/ad_serdes_clk.v generated/ad_serdes_clk.v

  add_fileset_file  generated/ad_serdes_clk.v   VERILOG PATH  generated/ad_serdes_clk.v
}

