###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

# SPI interface

adi_if_define "spi_engine"
adi_if_ports output 1 sclk
adi_if_ports output 1 sdo
adi_if_ports output 1 sdo_t
adi_if_ports input -1 sdi
adi_if_ports output -1 cs
adi_if_ports output 1 three_wire

# Control interface

adi_if_define "spi_engine_ctrl"
adi_if_ports input 1 cmd_ready
adi_if_ports output 1 cmd_valid
adi_if_ports output 16 cmd_data
adi_if_ports input 1 sdo_data_ready
adi_if_ports output 1 sdo_data_valid
adi_if_ports output -1 sdo_data
adi_if_ports output 1 sdi_data_ready
adi_if_ports input 1 sdi_data_valid
adi_if_ports input -1 sdi_data
adi_if_ports output 1 sync_ready
adi_if_ports input 1 sync_valid
adi_if_ports input 8 sync_data

# Offload control interface

adi_if_define "spi_engine_offload_ctrl"
adi_if_ports output 1 cmd_wr_en
adi_if_ports output 16 cmd_wr_data
adi_if_ports output 1 sdo_wr_en
adi_if_ports output -1 sdo_wr_data
adi_if_ports output 1 mem_reset
adi_if_ports output 1 enable
adi_if_ports input 1 enabled
adi_if_ports output 1 sync_ready
adi_if_ports input 1 sync_valid
adi_if_ports input 8 sync_data
