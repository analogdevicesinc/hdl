###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

if {![llength [info commands ::ipm::instantiate_hdl_core]]} {
	source [file join $ad_hdl_dir library scripts adi_ip_microchip.tcl]
}

set sd_name system_lb
set apb_interconnect_component fmcomms2_fic3_apb
set apb_dma_interconnect_component fmcomms2_fic3_apb_dma
set axi_mem_interconnect0_component fmcomms2_fic0_mem_interconnect
set axi_mem_interconnect1_component fmcomms2_fic1_mem_interconnect

download_core -vlnv {Actel:DirectCore:COREAXI4INTERCONNECT:2.8.103} \
	-location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Actel:DirectCore:CoreAPB3:4.2.100} \
	-location {www.microchip-ip.com/repositories/DirectCore}

# APB register interconnect on FIC3 (two cascaded CoreAPB3).
# Same register map as the Microchip reference design / Linux devicetree
# (Zed map with 0x79/0x7C replaced by 0x44):
#   axi_ad9361_0         @ 0x4402_0000
#   axi_ad9361_adc_dma_0 @ 0x4440_0000
#   axi_ad9361_dac_dma_0 @ 0x4442_0000
#   axi_sysid_0          @ 0x44A3_0000
# FIC3 reaches level 1 through a registered APB stage (util_apb_pipe).
# Level 1, MADDR_BITS:24 -> 16 slots of 1 MB selected by PADDR[23:20]:
#   slot0 axi_ad9361_0, slot4 level 2 (through util_apb_pipe), slot10 axi_sysid_0
# Level 2, MADDR_BITS:20 -> 16 slots of 64 KB selected by PADDR[19:16]:
#   slot0 axi_ad9361_adc_dma_0, slot2 axi_ad9361_dac_dma_0
create_and_configure_core -core_vlnv {Actel:DirectCore:CoreAPB3:4.2.100} \
	-component_name $apb_interconnect_component \
	-params {\
"APB_DWIDTH:32" \
"APBSLOT0ENABLE:true" \
"APBSLOT1ENABLE:false" \
"APBSLOT2ENABLE:false" \
"APBSLOT3ENABLE:false" \
"APBSLOT4ENABLE:true" \
"APBSLOT5ENABLE:false" \
"APBSLOT6ENABLE:false" \
"APBSLOT7ENABLE:false" \
"APBSLOT8ENABLE:false" \
"APBSLOT9ENABLE:false" \
"APBSLOT10ENABLE:true" \
"APBSLOT11ENABLE:false" \
"APBSLOT12ENABLE:false" \
"APBSLOT13ENABLE:false" \
"APBSLOT14ENABLE:false" \
"APBSLOT15ENABLE:false" \
"IADDR_OPTION:0" \
"MADDR_BITS:24" \
"SC_0:false" \
"SC_1:false" \
"SC_2:false" \
"SC_3:false" \
"SC_4:false" \
"SC_5:false" \
"SC_6:false" \
"SC_7:false" \
"SC_8:false" \
"SC_9:false" \
"SC_10:false" \
"SC_11:false" \
"SC_12:false" \
"SC_13:false" \
"SC_14:false" \
"SC_15:false" \
"UPR_NIBBLE_POSN:5" }

create_and_configure_core -core_vlnv {Actel:DirectCore:CoreAPB3:4.2.100} \
	-component_name $apb_dma_interconnect_component \
	-params {\
"APB_DWIDTH:32" \
"APBSLOT0ENABLE:true" \
"APBSLOT1ENABLE:false" \
"APBSLOT2ENABLE:true" \
"APBSLOT3ENABLE:false" \
"APBSLOT4ENABLE:false" \
"APBSLOT5ENABLE:false" \
"APBSLOT6ENABLE:false" \
"APBSLOT7ENABLE:false" \
"APBSLOT8ENABLE:false" \
"APBSLOT9ENABLE:false" \
"APBSLOT10ENABLE:false" \
"APBSLOT11ENABLE:false" \
"APBSLOT12ENABLE:false" \
"APBSLOT13ENABLE:false" \
"APBSLOT14ENABLE:false" \
"APBSLOT15ENABLE:false" \
"IADDR_OPTION:0" \
"MADDR_BITS:20" \
"SC_0:false" \
"SC_1:false" \
"SC_2:false" \
"SC_3:false" \
"SC_4:false" \
"SC_5:false" \
"SC_6:false" \
"SC_7:false" \
"SC_8:false" \
"SC_9:false" \
"SC_10:false" \
"SC_11:false" \
"SC_12:false" \
"SC_13:false" \
"SC_14:false" \
"SC_15:false" \
"UPR_NIBBLE_POSN:4" }

# DMA data interconnects: adc_dma -> FIC0 target, dac_dma -> FIC1 target.
# Each carries the two masters of one DMA (m_dest/m_src + m_sg).
create_and_configure_core -core_vlnv {Actel:DirectCore:COREAXI4INTERCONNECT:2.8.103} \
	-component_name $axi_mem_interconnect0_component \
	-params {\
"ADDR_WIDTH:38" \
"CROSSBAR_MODE:0" \
"DATA_WIDTH:64" \
"ID_WIDTH:3" \
"MASTER0_CHAN_RS:true" \
"MASTER0_CLOCK_DOMAIN_CROSSING:false" \
"MASTER0_DATA_WIDTH:64" \
"MASTER0_DWC_DATA_FIFO_DEPTH:16" \
"MASTER0_READ_INTERLEAVE:false" \
"MASTER0_READ_SLAVE0:true" \
"MASTER0_TYPE:0" \
"MASTER0_WRITE_SLAVE0:true" \
"MASTER1_CHAN_RS:true" \
"MASTER1_CLOCK_DOMAIN_CROSSING:false" \
"MASTER1_DATA_WIDTH:64" \
"MASTER1_DWC_DATA_FIFO_DEPTH:16" \
"MASTER1_READ_INTERLEAVE:false" \
"MASTER1_READ_SLAVE0:true" \
"MASTER1_TYPE:0" \
"MASTER1_WRITE_SLAVE0:true" \
"NUM_MASTERS:2" \
"NUM_MASTERS_WIDTH:1" \
"NUM_SLAVES:1" \
"NUM_THREADS:1" \
"OPEN_TRANS_MAX:1" \
"OPTIMIZATION:3" \
"RD_ARB_EN:true" \
"SLAVE0_CHAN_RS:true" \
"SLAVE0_CLOCK_DOMAIN_CROSSING:false" \
"SLAVE0_DATA_WIDTH:64" \
"SLAVE0_DWC_DATA_FIFO_DEPTH:16" \
"SLAVE0_END_ADDR:0xffffffff" \
"SLAVE0_END_ADDR_UPPER:0x3f" \
"SLAVE0_READ_INTERLEAVE:false" \
"SLAVE0_START_ADDR:0x00000000" \
"SLAVE0_START_ADDR_UPPER:0x0" \
"SLAVE0_TYPE:0" }

create_and_configure_core -core_vlnv {Actel:DirectCore:COREAXI4INTERCONNECT:2.8.103} \
	-component_name $axi_mem_interconnect1_component \
	-params {\
"ADDR_WIDTH:38" \
"CROSSBAR_MODE:0" \
"DATA_WIDTH:64" \
"ID_WIDTH:3" \
"MASTER0_CHAN_RS:true" \
"MASTER0_CLOCK_DOMAIN_CROSSING:false" \
"MASTER0_DATA_WIDTH:64" \
"MASTER0_DWC_DATA_FIFO_DEPTH:16" \
"MASTER0_READ_INTERLEAVE:false" \
"MASTER0_READ_SLAVE0:true" \
"MASTER0_TYPE:0" \
"MASTER0_WRITE_SLAVE0:true" \
"MASTER1_CHAN_RS:true" \
"MASTER1_CLOCK_DOMAIN_CROSSING:false" \
"MASTER1_DATA_WIDTH:64" \
"MASTER1_DWC_DATA_FIFO_DEPTH:16" \
"MASTER1_READ_INTERLEAVE:false" \
"MASTER1_READ_SLAVE0:true" \
"MASTER1_TYPE:0" \
"MASTER1_WRITE_SLAVE0:true" \
"NUM_MASTERS:2" \
"NUM_MASTERS_WIDTH:1" \
"NUM_SLAVES:1" \
"NUM_THREADS:1" \
"OPEN_TRANS_MAX:1" \
"OPTIMIZATION:3" \
"RD_ARB_EN:true" \
"SLAVE0_CHAN_RS:true" \
"SLAVE0_CLOCK_DOMAIN_CROSSING:false" \
"SLAVE0_DATA_WIDTH:64" \
"SLAVE0_DWC_DATA_FIFO_DEPTH:16" \
"SLAVE0_END_ADDR:0xffffffff" \
"SLAVE0_END_ADDR_UPPER:0x3f" \
"SLAVE0_READ_INTERLEAVE:false" \
"SLAVE0_START_ADDR:0x00000000" \
"SLAVE0_START_ADDR_UPPER:0x0" \
"SLAVE0_TYPE:0" }

foreach port_def {
	{RX_CLK_P IN 0}
	{RX_CLK_N IN 0}
	{TX_CLK OUT 0}
	{TX_CLK_N OUT 0}
	{enable OUT 0}
	{txnrx OUT 0}
	{up_enable IN 0}
	{up_txnrx IN 0}
	{tdd_sync_o OUT 0}
	{tdd_sync_i IN 0}
	{tdd_sync_t OUT 0}
} {
	lassign $port_def port_name port_dir is_pad
	sd_create_scalar_port -sd_name $sd_name -port_name $port_name -port_direction $port_dir -port_is_pad $is_pad
}

sd_create_bus_port -sd_name $sd_name -port_name {RXD} -port_direction {IN} -port_range {[6:0]} -port_is_pad {0}
sd_create_bus_port -sd_name $sd_name -port_name {RXD_N} -port_direction {IN} -port_range {[6:0]} -port_is_pad {0}
sd_create_bus_port -sd_name $sd_name -port_name {TXD} -port_direction {OUT} -port_range {[6:0]} -port_is_pad {0}
sd_create_bus_port -sd_name $sd_name -port_name {TXD_N} -port_direction {OUT} -port_range {[6:0]} -port_is_pad {0}

sd_instantiate_component -sd_name $sd_name -component_name $apb_interconnect_component -instance_name {fmcomms2_fic3_apb_0}
sd_instantiate_component -sd_name $sd_name -component_name $apb_dma_interconnect_component -instance_name {fmcomms2_fic3_apb_dma_0}
sd_instantiate_component -sd_name $sd_name -component_name $axi_mem_interconnect0_component -instance_name {fmcomms2_fic0_mem_interconnect_0}
sd_instantiate_component -sd_name $sd_name -component_name $axi_mem_interconnect1_component -instance_name {fmcomms2_fic1_mem_interconnect_0}
sd_instantiate_macro -sd_name $sd_name -macro_name {INV} -instance_name {fmcomms2_reset_inv}
sd_instantiate_macro -sd_name $sd_name -macro_name {OR2} -instance_name {util_ad9361_divclk_sel_or}

ipm::instantiate_hdl_core {apb_ad9361} {axi_ad9361_0} -sd_name $sd_name -params [list \
		"ID:0" \
		"ADC_INIT_DELAY:23" \
		"DAC_DDS_TYPE:1" \
		"DAC_DDS_CORDIC_DW:14" \
		"CMOS_OR_LVDS_N:0" \
		"TDD_DISABLE:0" \
		"USE_SSI_CLK:1" \
		"DELAY_REFCLK_FREQUENCY:200"]

sd_connect_pins -sd_name $sd_name -pin_names {RX_CLK_P axi_ad9361_0:rx_clk_in_p}
sd_connect_pins -sd_name $sd_name -pin_names {RX_CLK_N axi_ad9361_0:rx_clk_in_n}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:tx_clk_out_p TX_CLK}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:tx_clk_out_n TX_CLK_N}

for {set i 0} {$i < 7} {incr i} {
	set slice [format {[%d:%d]} $i $i]
	sd_create_pin_slices -sd_name $sd_name -pin_name {RXD} -pin_slices $slice
	sd_create_pin_slices -sd_name $sd_name -pin_name {RXD_N} -pin_slices $slice
	sd_create_pin_slices -sd_name $sd_name -pin_name {TXD} -pin_slices $slice
	sd_create_pin_slices -sd_name $sd_name -pin_name {TXD_N} -pin_slices $slice
}

for {set i 0} {$i < 6} {incr i} {
	set slice [format {[%d:%d]} $i $i]
	sd_create_pin_slices -sd_name $sd_name -pin_name {axi_ad9361_0:rx_data_in_p} -pin_slices $slice
	sd_create_pin_slices -sd_name $sd_name -pin_name {axi_ad9361_0:rx_data_in_n} -pin_slices $slice
	sd_create_pin_slices -sd_name $sd_name -pin_name {axi_ad9361_0:tx_data_out_p} -pin_slices $slice
	sd_create_pin_slices -sd_name $sd_name -pin_name {axi_ad9361_0:tx_data_out_n} -pin_slices $slice
	sd_connect_pins -sd_name $sd_name -pin_names "RXD\[$i:$i\] axi_ad9361_0:rx_data_in_p\[$i:$i\]"
	sd_connect_pins -sd_name $sd_name -pin_names "RXD_N\[$i:$i\] axi_ad9361_0:rx_data_in_n\[$i:$i\]"
	sd_connect_pins -sd_name $sd_name -pin_names "axi_ad9361_0:tx_data_out_p\[$i:$i\] TXD\[$i:$i\]"
	sd_connect_pins -sd_name $sd_name -pin_names "axi_ad9361_0:tx_data_out_n\[$i:$i\] TXD_N\[$i:$i\]"
}

sd_connect_pins -sd_name $sd_name -pin_names {RXD[6:6] axi_ad9361_0:rx_frame_in_p}
sd_connect_pins -sd_name $sd_name -pin_names {RXD_N[6:6] axi_ad9361_0:rx_frame_in_n}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:tx_frame_out_p TXD[6:6]}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:tx_frame_out_n TXD_N[6:6]}

ipm::instantiate_hdl_core {util_tdd_sync} {util_ad9361_tdd_sync_0} -sd_name $sd_name -params [list \
	"TDD_SYNC_PERIOD:10000000"]

set mem_init_file [file normalize [file join $ad_project_dir mem_init_sys.txt]]
set mem_init_file_param [format {"%s"} [string map {\\ /} $mem_init_file]]

ipm::instantiate_hdl_core {apb_sysid} {axi_sysid_0} -sd_name $sd_name -params [list \
	"ROM_ADDR_BITS:9" \
	"ROM_WIDTH:32"]
ipm::instantiate_hdl_core {sysid_rom} {rom_sys_0} -sd_name $sd_name -params [list \
	"ROM_ADDR_BITS:9" \
	"ROM_WIDTH:32" \
	"PATH_TO_FILE:$mem_init_file_param"]

ipm::instantiate_hdl_core {util_apb_pipe} {fmcomms2_fic3_apb_pipe_0} -sd_name $sd_name -params [list \
	"NUM_OF_STAGES:1"]
# the MSS FIC3 initiator is a master, which SmartDesign connects only to a
# mirroredMaster
ipm::instantiate_hdl_core {util_apb_pipe} {fmcomms2_fic3_apb_pipe_1} -sd_name $sd_name -params [list \
	"NUM_OF_STAGES:1"] -bif_roles {s_apb mirroredMaster}

ipm::instantiate_hdl_core {util_clkdiv} {util_ad9361_divclk_0} -sd_name $sd_name

ipm::instantiate_hdl_core {ad_rst} {util_ad9361_divclk_reset_0} -sd_name $sd_name

ipm::instantiate_hdl_core {util_wfifo} {util_ad9361_adc_fifo_0} -sd_name $sd_name -params [list \
	"NUM_OF_CHANNELS:4" \
	"DIN_DATA_WIDTH:16" \
	"DOUT_DATA_WIDTH:16" \
	"DIN_ADDRESS_WIDTH:4"]

ipm::instantiate_hdl_core {util_cpack2} {util_ad9361_adc_pack_0} -sd_name $sd_name -params [list \
	"NUM_OF_CHANNELS:4" \
	"SAMPLE_DATA_WIDTH:16"]

# Not cyclic as in fmcomms2_bd.tcl, unless the project sets ADC_DMA_CYCLIC
# (the simulation project does, to capture the RX data cyclically)
set adc_dma_cyclic 0
if {[info exists ::ad_project_params(ADC_DMA_CYCLIC)]} {
  set adc_dma_cyclic $::ad_project_params(ADC_DMA_CYCLIC)
}
ipm::instantiate_hdl_core {apb_dmac} {axi_ad9361_adc_dma_0} -sd_name $sd_name -params [list \
		"DMA_TYPE_SRC:2" \
		"DMA_TYPE_DEST:0" \
		"CYCLIC:$adc_dma_cyclic" \
		"SYNC_TRANSFER_START:1" \
		"ASYNC_CLK_DEST_REQ:1" \
		"ASYNC_CLK_SRC_DEST:1" \
		"ASYNC_CLK_REQ_SRC:1" \
		"ASYNC_CLK_REQ_SG:1" \
		"ASYNC_CLK_SRC_SG:1" \
		"ASYNC_CLK_DEST_SG:1" \
		"DMA_2D_TRANSFER:0" \
		"DMA_SG_TRANSFER:1" \
		"DMA_DATA_WIDTH_SRC:64" \
		"DMA_DATA_WIDTH_DEST:64" \
		"DMA_DATA_WIDTH_SG:64" \
		"DMA_AXI_ADDR_WIDTH:38" \
		"CACHE_COHERENT:1" \
		"AXI_SLICE_SRC:0" \
		"AXI_SLICE_DEST:0"]

ipm::instantiate_hdl_core {util_rfifo} {util_ad9361_dac_fifo_0} -sd_name $sd_name -params [list \
	"DIN_DATA_WIDTH:16" \
	"DOUT_DATA_WIDTH:16" \
	"DIN_ADDRESS_WIDTH:4"]

set util_ad9361_dac_upack_core_name [ipm::package_hdl_core \
	{util_upack2} \
	{util_ad9361_dac_upack_0} \
	-params [list \
		"NUM_OF_CHANNELS:4" \
		"SAMPLE_DATA_WIDTH:16"]]
hdl_core_add_bif \
	-hdl_core_name $util_ad9361_dac_upack_core_name \
	-bif_definition {AXI4Stream:AMBA:AMBA4:slave} \
	-bif_name {s_axis} \
	-signal_map {TVALID:s_axis_valid TREADY:s_axis_ready TDATA:s_axis_data}
sd_instantiate_hdl_core -sd_name $sd_name -hdl_core_name $util_ad9361_dac_upack_core_name \
	-instance_name {util_ad9361_dac_upack_0}

ipm::instantiate_hdl_core {apb_dmac} {axi_ad9361_dac_dma_0} -sd_name $sd_name -params [list \
		"DMA_TYPE_SRC:0" \
		"DMA_TYPE_DEST:1" \
		"CYCLIC:1" \
		"ASYNC_CLK_DEST_REQ:1" \
		"ASYNC_CLK_SRC_DEST:1" \
		"ASYNC_CLK_REQ_SRC:1" \
		"ASYNC_CLK_REQ_SG:1" \
		"ASYNC_CLK_SRC_SG:1" \
		"ASYNC_CLK_DEST_SG:1" \
		"DMA_2D_TRANSFER:0" \
		"DMA_SG_TRANSFER:1" \
		"DMA_DATA_WIDTH_SRC:64" \
		"DMA_DATA_WIDTH_DEST:64" \
		"DMA_DATA_WIDTH_SG:64" \
		"DMA_AXI_ADDR_WIDTH:38" \
		"CACHE_COHERENT:1" \
		"AXI_SLICE_SRC:0" \
		"AXI_SLICE_DEST:0"]

puts {TRACE: starting axi_ad9361 external port connects}
sd_connect_pins -sd_name $sd_name -pin_names {enable axi_ad9361_0:enable}
sd_connect_pins -sd_name $sd_name -pin_names {txnrx axi_ad9361_0:txnrx}
sd_connect_pins -sd_name $sd_name -pin_names {up_enable axi_ad9361_0:up_enable}
sd_connect_pins -sd_name $sd_name -pin_names {up_txnrx axi_ad9361_0:up_txnrx}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_tdd_sync_0:sync_out axi_ad9361_0:tdd_sync tdd_sync_o}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:tdd_sync_cntr util_ad9361_tdd_sync_0:sync_mode tdd_sync_t}
sd_connect_pins -sd_name $sd_name -pin_names {tdd_sync_i util_ad9361_tdd_sync_0:sync_in}
puts {TRACE: starting clock and reset connects}
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_resetn_pin fmcomms2_reset_inv:A]
sd_disconnect_pins -sd_name $sd_name -pin_names {MSS:FIC_0_ACLK MSS:FIC_1_ACLK}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_r1_mode util_ad9361_divclk_sel_or:A}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:dac_r1_mode util_ad9361_divclk_sel_or:B}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_divclk_sel_or:Y util_ad9361_divclk_0:clk_sel}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:l_clk axi_ad9361_0:clk util_ad9361_divclk_0:clk util_ad9361_adc_fifo_0:din_clk util_ad9361_dac_fifo_0:dout_clk}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_divclk_0:clk_out util_ad9361_divclk_reset_0:clk util_ad9361_adc_fifo_0:dout_clk util_ad9361_adc_pack_0:clk axi_ad9361_adc_dma_0:fifo_wr_clk util_ad9361_dac_fifo_0:din_clk util_ad9361_dac_upack_0:clk axi_ad9361_dac_dma_0:m_axis_aclk}
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_reset_inv:Y util_ad9361_divclk_reset_0:rst_async}
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_clk_pin axi_ad9361_0:delay_clk axi_ad9361_0:s_axi_aclk util_ad9361_tdd_sync_0:clk axi_ad9361_adc_dma_0:s_axi_aclk axi_ad9361_adc_dma_0:m_dest_axi_aclk axi_ad9361_adc_dma_0:m_sg_axi_aclk axi_ad9361_dac_dma_0:s_axi_aclk axi_ad9361_dac_dma_0:m_src_axi_aclk axi_ad9361_dac_dma_0:m_sg_axi_aclk MSS:FIC_0_ACLK MSS:FIC_1_ACLK fmcomms2_fic0_mem_interconnect_0:ACLK fmcomms2_fic1_mem_interconnect_0:ACLK]
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_resetn_pin axi_ad9361_0:s_axi_aresetn util_ad9361_tdd_sync_0:rstn axi_ad9361_adc_dma_0:s_axi_aresetn axi_ad9361_adc_dma_0:m_dest_axi_aresetn axi_ad9361_adc_dma_0:m_sg_axi_aresetn axi_ad9361_dac_dma_0:s_axi_aresetn axi_ad9361_dac_dma_0:m_src_axi_aresetn axi_ad9361_dac_dma_0:m_sg_axi_aresetn fmcomms2_fic0_mem_interconnect_0:ARESETN fmcomms2_fic1_mem_interconnect_0:ARESETN]
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:rst util_ad9361_adc_fifo_0:din_rst util_ad9361_dac_fifo_0:dout_rst}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_divclk_reset_0:rstn util_ad9361_adc_fifo_0:dout_rstn util_ad9361_dac_fifo_0:din_rstn}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_divclk_reset_0:rst util_ad9361_adc_pack_0:reset util_ad9361_dac_upack_0:reset}
puts {TRACE: starting APB register interface connects}
# Below 125 MHz the MSS samples FIC3 PREADY and PRDATA on the falling edge of
# FIC_3_PCLK (FIC DLL bypassed): registered APB stages at FIC3 and between the
# two CoreAPB3 levels, so no combinational CoreAPB3 path is in the half cycle.
sd_connect_pins -sd_name $sd_name -pin_names {MSS:FIC_3_APB_INITIATOR fmcomms2_fic3_apb_pipe_1:s_apb}
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_fic3_apb_pipe_1:m_apb fmcomms2_fic3_apb_0:APB3mmaster}
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_clk_pin fmcomms2_fic3_apb_pipe_1:clk]
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_resetn_pin fmcomms2_fic3_apb_pipe_1:resetn]
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_fic3_apb_0:APBmslave0 axi_ad9361_0:s_apb}
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_fic3_apb_0:APBmslave10 axi_sysid_0:s_apb}
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_clk_pin axi_sysid_0:s_axi_aclk rom_sys_0:clk]
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_resetn_pin axi_sysid_0:s_axi_aresetn]
sd_connect_pins -sd_name $sd_name -pin_names {axi_sysid_0:rom_addr rom_sys_0:rom_addr}
sd_connect_pins -sd_name $sd_name -pin_names {axi_sysid_0:sys_rom_data rom_sys_0:rom_data}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {axi_sysid_0:pr_rom_data} -value {GND}
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_fic3_apb_0:APBmslave4 fmcomms2_fic3_apb_pipe_0:s_apb}
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_fic3_apb_pipe_0:m_apb fmcomms2_fic3_apb_dma_0:APB3mmaster}
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_clk_pin fmcomms2_fic3_apb_pipe_0:clk]
sd_connect_pins -sd_name $sd_name -pin_names [list $sys_resetn_pin fmcomms2_fic3_apb_pipe_0:resetn]
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_fic3_apb_dma_0:APBmslave0 axi_ad9361_adc_dma_0:s_apb}
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_fic3_apb_dma_0:APBmslave2 axi_ad9361_dac_dma_0:s_apb}

puts {TRACE: starting DMA memory interface connects}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_adc_dma_0:m_dest_axi fmcomms2_fic0_mem_interconnect_0:AXI4mmaster0}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_adc_dma_0:m_sg_axi fmcomms2_fic0_mem_interconnect_0:AXI4mmaster1}
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_fic0_mem_interconnect_0:AXI4mslave0 MSS:FIC_0_AXI4_TARGET}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_dac_dma_0:m_src_axi fmcomms2_fic1_mem_interconnect_0:AXI4mmaster0}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_dac_dma_0:m_sg_axi fmcomms2_fic1_mem_interconnect_0:AXI4mmaster1}
sd_connect_pins -sd_name $sd_name -pin_names {fmcomms2_fic1_mem_interconnect_0:AXI4mslave0 MSS:FIC_1_AXI4_TARGET}

puts {TRACE: starting ADC datapath connects}
puts {TRACE: adc to wfifo}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_enable_i0 util_ad9361_adc_fifo_0:din_enable_0}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_valid_i0 util_ad9361_adc_fifo_0:din_valid_0}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_data_i0 util_ad9361_adc_fifo_0:din_data_0}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_enable_q0 util_ad9361_adc_fifo_0:din_enable_1}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_valid_q0 util_ad9361_adc_fifo_0:din_valid_1}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_data_q0 util_ad9361_adc_fifo_0:din_data_1}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_enable_i1 util_ad9361_adc_fifo_0:din_enable_2}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_valid_i1 util_ad9361_adc_fifo_0:din_valid_2}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_data_i1 util_ad9361_adc_fifo_0:din_data_2}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_enable_q1 util_ad9361_adc_fifo_0:din_enable_3}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_valid_q1 util_ad9361_adc_fifo_0:din_valid_3}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_0:adc_data_q1 util_ad9361_adc_fifo_0:din_data_3}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_adc_fifo_0:din_ovf axi_ad9361_0:adc_dovf}

puts {TRACE: wfifo to cpack}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_adc_fifo_0:dout_valid_0 util_ad9361_adc_pack_0:fifo_wr_en}

for {set index 0} {$index < 4} {incr index} {
	sd_connect_pins -sd_name $sd_name -pin_names [list util_ad9361_adc_fifo_0:dout_enable_$index util_ad9361_adc_pack_0:enable_$index]
	sd_connect_pins -sd_name $sd_name -pin_names [list util_ad9361_adc_fifo_0:dout_data_$index util_ad9361_adc_pack_0:fifo_wr_data_$index]
}

for {set index 4} {$index < 64} {incr index} {
	sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list util_ad9361_adc_pack_0:enable_$index] -value {GND}
	sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list util_ad9361_adc_pack_0:fifo_wr_data_$index] -value {GND}
}

sd_connect_pins_to_constant -sd_name $sd_name -pin_names {util_ad9361_adc_pack_0:packed_fifo_wr_overflow} -value {GND}

puts {TRACE: cpack to dmac}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_adc_pack_0:fifo_wr_overflow util_ad9361_adc_fifo_0:dout_ovf}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_adc_pack_0:packed_fifo_wr_en axi_ad9361_adc_dma_0:fifo_wr_en}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_adc_pack_0:packed_fifo_wr_data axi_ad9361_adc_dma_0:fifo_wr_din}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_adc_pack_0:packed_sync axi_ad9361_adc_dma_0:sync}

puts {TRACE: starting DAC datapath connects}
puts {TRACE: rfifo to axi_ad9361}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_enable_0 axi_ad9361_0:dac_enable_i0}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_valid_0 axi_ad9361_0:dac_valid_i0}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_data_0 axi_ad9361_0:dac_data_i0}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_enable_1 axi_ad9361_0:dac_enable_q0}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_valid_1 axi_ad9361_0:dac_valid_q0}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_data_1 axi_ad9361_0:dac_data_q0}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_enable_2 axi_ad9361_0:dac_enable_i1}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_valid_2 axi_ad9361_0:dac_valid_i1}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_data_2 axi_ad9361_0:dac_data_i1}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_enable_3 axi_ad9361_0:dac_enable_q1}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_valid_3 axi_ad9361_0:dac_valid_q1}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_data_3 axi_ad9361_0:dac_data_q1}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_fifo_0:dout_unf axi_ad9361_0:dac_dunf}

puts {TRACE: upack to rfifo}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_upack_0:fifo_rd_en util_ad9361_dac_fifo_0:din_valid_0}
sd_connect_pins -sd_name $sd_name -pin_names {util_ad9361_dac_upack_0:fifo_rd_underflow util_ad9361_dac_fifo_0:din_unf}

for {set index 0} {$index < 4} {incr index} {
	sd_connect_pins -sd_name $sd_name -pin_names [list util_ad9361_dac_upack_0:enable_$index util_ad9361_dac_fifo_0:din_enable_$index]
	sd_connect_pins -sd_name $sd_name -pin_names [list util_ad9361_dac_upack_0:fifo_rd_valid util_ad9361_dac_fifo_0:din_valid_in_$index]
	sd_connect_pins -sd_name $sd_name -pin_names [list util_ad9361_dac_upack_0:fifo_rd_data_$index util_ad9361_dac_fifo_0:din_data_$index]
}

for {set index 4} {$index < 64} {incr index} {
	sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list util_ad9361_dac_upack_0:enable_$index] -value {GND}
}

for {set index 4} {$index < 8} {incr index} {
	sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list util_ad9361_dac_fifo_0:din_valid_in_$index] -value {GND}
	sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list util_ad9361_dac_fifo_0:din_data_$index] -value {GND}
	sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list util_ad9361_dac_fifo_0:dout_enable_$index] -value {GND}
	sd_connect_pins_to_constant -sd_name $sd_name -pin_names [list util_ad9361_dac_fifo_0:dout_valid_$index] -value {GND}
}

puts {TRACE: dmac to upack}
sd_connect_pins -sd_name $sd_name -pin_names {axi_ad9361_dac_dma_0:m_axis util_ad9361_dac_upack_0:s_axis}

puts {TRACE: adc constants and unused}
foreach pin {
	axi_ad9361_0:rx_clk_in
	axi_ad9361_0:rx_frame_in
	axi_ad9361_0:rx_data_in
	axi_ad9361_0:dac_sync_in
	axi_ad9361_0:gps_pps
	axi_ad9361_0:up_dac_gpio_in
	axi_ad9361_0:up_adc_gpio_in
	util_ad9361_adc_fifo_0:din_enable_4
	util_ad9361_adc_fifo_0:din_valid_4
	util_ad9361_adc_fifo_0:din_data_4
	util_ad9361_adc_fifo_0:din_enable_5
	util_ad9361_adc_fifo_0:din_valid_5
	util_ad9361_adc_fifo_0:din_data_5
	util_ad9361_adc_fifo_0:din_enable_6
	util_ad9361_adc_fifo_0:din_valid_6
	util_ad9361_adc_fifo_0:din_data_6
	util_ad9361_adc_fifo_0:din_enable_7
	util_ad9361_adc_fifo_0:din_valid_7
	util_ad9361_adc_fifo_0:din_data_7
	axi_ad9361_adc_dma_0:m_src_axi_aclk
	axi_ad9361_adc_dma_0:m_src_axi_aresetn
	axi_ad9361_adc_dma_0:s_axis_aclk
	axi_ad9361_adc_dma_0:m_axis_aclk
	axi_ad9361_adc_dma_0:m_axis_ready
	axi_ad9361_adc_dma_0:fifo_rd_clk
	axi_ad9361_adc_dma_0:fifo_rd_en
	axi_ad9361_adc_dma_0:m_frame_in
	axi_ad9361_adc_dma_0:m_frame_in_valid
	axi_ad9361_adc_dma_0:s_frame_in
	axi_ad9361_adc_dma_0:s_frame_in_valid
	axi_ad9361_adc_dma_0:src_ext_sync
	axi_ad9361_adc_dma_0:dest_ext_sync
	axi_ad9361_dac_dma_0:sync
	axi_ad9361_dac_dma_0:m_dest_axi_aclk
	axi_ad9361_dac_dma_0:m_dest_axi_aresetn
	axi_ad9361_dac_dma_0:s_axis_aclk
	axi_ad9361_dac_dma_0:fifo_wr_clk
	axi_ad9361_dac_dma_0:fifo_wr_en
	axi_ad9361_dac_dma_0:fifo_wr_din
	axi_ad9361_dac_dma_0:fifo_rd_clk
	axi_ad9361_dac_dma_0:fifo_rd_en
	axi_ad9361_dac_dma_0:m_frame_in
	axi_ad9361_dac_dma_0:m_frame_in_valid
	axi_ad9361_dac_dma_0:s_frame_in
	axi_ad9361_dac_dma_0:s_frame_in_valid
	axi_ad9361_dac_dma_0:src_ext_sync
	axi_ad9361_dac_dma_0:dest_ext_sync
} {
	sd_connect_pins_to_constant -sd_name $sd_name -pin_names $pin -value {GND}
}

# Route the DMA interrupts onto the MSS fabric-to-processor interrupt bus.
# Same order as the Microchip reference: F2M[0] (PLIC 118) dac_dma,
# F2M[1] (PLIC 119) adc_dma.
sd_disconnect_pins -sd_name $sd_name -pin_names {MSS:MSS_INT_F2M}
sd_create_pin_slices -sd_name $sd_name -pin_name {MSS:MSS_INT_F2M} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name $sd_name -pin_name {MSS:MSS_INT_F2M} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name $sd_name -pin_name {MSS:MSS_INT_F2M} -pin_slices {[63:2]}
sd_connect_pins_to_constant -sd_name $sd_name -pin_names {MSS:MSS_INT_F2M[63:2]} -value {GND}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:MSS_INT_F2M[0:0] axi_ad9361_dac_dma_0:irq}
sd_connect_pins -sd_name $sd_name -pin_names {MSS:MSS_INT_F2M[1:1] axi_ad9361_adc_dma_0:irq}

sd_mark_pins_unused -sd_name $sd_name -pin_names {axi_ad9361_0:gps_pps_irq}
