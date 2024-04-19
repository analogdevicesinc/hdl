###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Determine the device based on the board name
if [regexp "_lfcpnx" $project_name] {
  set device "LFCPNX-100-9LFG672C"
  set speed "9_High-Performance_1.0V"
  set board "Certus Pro NX Evaluation Board"
}
