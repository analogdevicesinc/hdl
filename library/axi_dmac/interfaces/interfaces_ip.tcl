###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

# Framelock bus interface

adi_if_define if_framelock
adi_if_ports  input   -1  s2m_framelock       none    0
adi_if_ports  input    1  s2m_framelock_valid none    0
adi_if_ports  output  -1  m2s_framelock       none    0
adi_if_ports  output   1  m2s_framelock_valid none    0



