###############################################################################
## Copyright (C) 2023, 2026 Analog Devices, Inc. All rights reserved.
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
