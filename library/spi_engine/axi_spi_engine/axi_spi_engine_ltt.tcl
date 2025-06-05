###############################################################################
## Copyright (C) 2024 - 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::parse_module ./axi_spi_engine.v]
set ip $::ipl::ip

set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]
# set ip [ipl::add_parameters_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::general \
    -vlnv "analog.com:ip:axi_spi_engine:1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2023.2" \
    -min_esi_version "2023.2" -ip $ip]

set ip [ipl::general -ip $ip -display_name "AXI SPI Engine ADI"]
set ip [ipl::general -ip $ip -supported_products {*}]
set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
set ip [ipl::general -ip $ip -href "https://analogdevicesinc.github.io/hdl/library/spi_engine/axi_spi_engine.html#spi-engine-axi"]

# set ip [ipl::add_component_generator -name blabla -generator eval/blabla.py -ip $ip]

set ip [ipl::add_memory_map -ip $ip \
    -name "axi_spi_engine_mem_map" \
    -description "axi_spi_engine_mem_map" \
    -baseAddress 0 \
    -range 65536 \
    -width 32]

set ip [ipl::add_axi_interfaces -ip $ip -mod_data $mod_data]

set ip [ipl::add_interface -ip $ip \
    -inst_name spi_engine_ctrl \
    -display_name spi_engine_ctrl \
    -description spi_engine_ctrl \
    -master_slave master \
    -portmap { \
        {"cmd_ready" "CMD_READY"} \
		{"cmd_valid" "CMD_VALID"} \
		{"cmd_data" "CMD_DATA"} \
		{"sdo_data_ready" "SDO_READY"} \
		{"sdo_data_valid" "SDO_VALID"} \
		{"sdo_data" "SDO_DATA"} \
		{"sdi_data_ready" "SDI_READY"} \
		{"sdi_data_valid" "SDI_VALID"} \
		{"sdi_data" "SDI_DATA"} \
		{"sync_ready" "SYNC_READY"} \
		{"sync_valid" "SYNC_VALID"} \
		{"sync_data" "SYNC_DATA"} \
    } \
    -vlnv {analog.com:ADI:spi_engine_ctrl:1.0}]
set ip [ipl::add_interface -ip $ip \
    -inst_name spi_engine_offload_ctrl0 \
    -display_name spi_engine_offload_ctrl0 \
    -description spi_engine_offload_ctrl0 \
    -master_slave master \
    -portmap { \
		{"offload0_cmd_wr_en" "CMD_WR_EN"} \
		{"offload0_cmd_wr_data" "CMD_WR_DATA"} \
		{"offload0_sdo_wr_en" "SDO_WR_EN"} \
		{"offload0_sdo_wr_data" "SDO_WR_DATA"} \
		{"offload0_enable" "ENABLE"} \
		{"offload0_enabled" "ENABLED"} \
		{"offload0_mem_reset" "MEM_RESET"} \
		{"offload_sync_ready" "SYNC_READY"} \
		{"offload_sync_valid" "SYNC_VALID"} \
		{"offload_sync_data" "SYNC_DATA"} \
    } \
    -vlnv {analog.com:ADI:spi_engine_offload_ctrl:1.0}]

set ip [ipl::add_interface -ip $ip \
    -inst_name IRQ \
    -display_name IRQ \
    -description IRQ \
    -master_slave master \
    -portmap [list {"irq" "IRQ"}] \
    -vlnv {spiritconsortium.org:busdef.interrupt:interrupt:1.0}]

set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
    "$ad_hdl_dir/library/common/up_axi.v" \
    "$ad_hdl_dir/library/common/ad_rst.v" \
    "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
    "$ad_hdl_dir/library/util_cdc/sync_gray.v" \
    "$ad_hdl_dir/library/common/ad_mem.v" \
    "$ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v" \
    "$ad_hdl_dir/library/util_axis_fifo/util_axis_fifo_address_generator.v" \
    "axi_spi_engine.v" ]]

set ip [ipl::set_parameter -ip $ip \
    -id ID \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {Core ID} \
    -default 0 \
    -output_formatter nostr \
    -value_range {(0, 255)} \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DATA_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {Parallel data width} \
    -default 8 \
    -output_formatter nostr \
    -value_range {(8, 256)} \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id NUM_OF_SDI \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {Number of MISO lines} \
    -default 1 \
    -output_formatter nostr \
    -value_range {(1, 8)} \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id MM_IF_TYPE \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {Memory Mapped Interface Type} \
    -default 0 \
    -options {[('AXI4 Memory Mapped', 0), ('ADI uP FIFO', 1)]} \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id ASYNC_SPI_CLK \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {Asynchronous core clock} \
    -default 0 \
    -options {[(True, 1), (False, 0)]} \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]

set ip [ipl::set_parameter -ip $ip \
    -id CMD_FIFO_ADDRESS_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {Command FIFO address width} \
    -default 4 \
    -output_formatter nostr \
    -value_range {(1, 16)} \
    -group1 {Command stream FIFO configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id SYNC_FIFO_ADDRESS_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {SYNC FIFO address width} \
    -default 4 \
    -output_formatter nostr \
    -value_range {(1, 16)} \
    -group1 {Command stream FIFO configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id SDO_FIFO_ADDRESS_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {MOSI FIFO address width} \
    -default 5 \
    -output_formatter nostr \
    -value_range {(1, 16)} \
    -group1 {Command stream FIFO configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id SDI_FIFO_ADDRESS_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {MISO FIFO address width} \
    -default 5 \
    -output_formatter nostr \
    -value_range {(1, 16)} \
    -group1 {Command stream FIFO configuration} \
    -group2 Config]

set ip [ipl::set_parameter -ip $ip \
    -id NUM_OFFLOAD \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {Number of offloads} \
    -default 0 \
    -output_formatter nostr \
    -value_range {(0, 8)} \
    -group1 {Offload module configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id OFFLOAD0_CMD_MEM_ADDRESS_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {Offload command FIFO address width} \
    -default 4 \
    -output_formatter nostr \
    -editable {(NUM_OFFLOAD > 0)} \
    -value_range {(1, 16)} \
    -group1 {Offload module configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id OFFLOAD0_SDO_MEM_ADDRESS_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_spi_engine \
    -title {Offload MOSI FIFO address width} \
    -default 4 \
    -output_formatter nostr \
    -editable {(NUM_OFFLOAD > 0)} \
    -value_range {(1, 16)} \
    -group1 {Offload module configuration} \
    -group2 Config]

set ip [ipl::ignore_ports_by_prefix -ip $ip \
    -mod_data $mod_data \
    -v_prefix s_axi \
    -expression {(MM_IF_TYPE != 0)}]
set ip [ipl::ignore_ports -ip $ip \
    -portlist {
        up_clk
        up_rstn
        up_wreq
        up_waddr
        up_wdata
        up_rreq
        up_raddr
        up_wack
        up_rdata
        up_rack
    } \
    -expression {(MM_IF_TYPE != 1)}]

ipl::generate_ip $ip
