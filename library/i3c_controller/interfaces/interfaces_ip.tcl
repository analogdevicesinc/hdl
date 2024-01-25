###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

# Bus interface

adi_if_define "i3c_controller"
adi_if_ports output 1 scl
adi_if_ports output 1 sdo
adi_if_ports input  1 sdi
adi_if_ports output 1 t

# Interface between Host Interface and Core for commands

adi_if_define "i3c_controller_cmdp"
adi_if_ports input   1 cmdp_ready
adi_if_ports output  1 cmdp_valid
adi_if_ports output 31 cmdp
adi_if_ports input   3 cmdp_error
adi_if_ports input   1 cmdp_nop
adi_if_ports input   1 cmdp_daa_trigger

# Interface between Host Interface and Core for register map access

adi_if_define "i3c_controller_rmap"
adi_if_ports output 2 rmap_ibi_config
adi_if_ports output 2 rmap_pp_sg
adi_if_ports input  7 rmap_dev_char_addr
adi_if_ports output 4 rmap_dev_char_data

# Interface between Host Interface and Core for data transfer

adi_if_define "i3c_controller_sdio"
adi_if_ports input  1  sdo_ready
adi_if_ports output 1  sdo_valid
adi_if_ports output 8  sdo
adi_if_ports output 1  sdi_ready
adi_if_ports input  1  sdi_valid
adi_if_ports input  1  sdi_last
adi_if_ports input  8  sdi
adi_if_ports output 1  ibi_ready
adi_if_ports input  1  ibi_valid
adi_if_ports input  15 ibi
