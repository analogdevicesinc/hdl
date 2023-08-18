###############################################################################
## Copyright (C) 2017-2022 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

# TX interfaces

adi_if_define "jesd204_tx_cfg"
adi_if_ports output -1 lanes_disable
adi_if_ports output -1 links_disable
adi_if_ports output 10 octets_per_multiframe
adi_if_ports output 8 octets_per_frame
adi_if_ports output 1 continuous_cgs
adi_if_ports output 1 continuous_ilas
adi_if_ports output 1 skip_ilas
adi_if_ports output 8 mframes_per_ilas
adi_if_ports output 1 disable_char_replacement
adi_if_ports output 1 disable_scrambler
adi_if_ports output 10 device_octets_per_multiframe
adi_if_ports output 8 device_octets_per_frame
adi_if_ports output 8 device_beats_per_multiframe
adi_if_ports output 8 device_lmfc_offset
adi_if_ports output 1 device_sysref_oneshot
adi_if_ports output 1 device_sysref_disable

adi_if_define "jesd204_tx_ilas_config"
adi_if_ports output 1 rd
adi_if_ports output 2 addr
adi_if_ports input 32 data

adi_if_define "jesd204_tx_status"
adi_if_ports output 1 state
adi_if_ports output 1 sync
adi_if_ports output -1 synth_params0
adi_if_ports output -1 synth_params1
adi_if_ports output -1 synth_params2

adi_if_define "jesd204_tx_event"
adi_if_ports output 1 sysref_alignment_error
adi_if_ports output 1 sysref_edge

adi_if_define "jesd204_tx_ctrl"
adi_if_ports output 1 manual_sync_request

# RX interfaces

adi_if_define "jesd204_rx_cfg"
adi_if_ports output -1 lanes_disable
adi_if_ports output -1 links_disable
adi_if_ports output 10 octets_per_multiframe
adi_if_ports output 8 octets_per_frame
adi_if_ports output 1 disable_char_replacement
adi_if_ports output 1 disable_scrambler
adi_if_ports output 8 frame_align_err_threshold
adi_if_ports output 10 device_octets_per_multiframe
adi_if_ports output 8 device_octets_per_frame
adi_if_ports output 8 device_beats_per_multiframe
adi_if_ports output 8 device_lmfc_offset
adi_if_ports output 1 device_sysref_oneshot
adi_if_ports output 1 device_sysref_disable
adi_if_ports output 1 device_buffer_early_release
adi_if_ports output 1 device_buffer_delay
adi_if_ports output 1 err_statistics_reset
adi_if_ports output 7 err_statistics_mask

adi_if_define "jesd204_rx_status"
adi_if_ports output 3 ctrl_state
adi_if_ports output -1 lane_cgs_state
adi_if_ports output -1 lane_emb_state
adi_if_ports output -1 lane_frame_align
adi_if_ports output -1 lane_ifs_ready
adi_if_ports output -1 lane_latency_ready
adi_if_ports output -1 lane_latency
adi_if_ports output -1 err_statistics_cnt
adi_if_ports output -1 synth_params0
adi_if_ports output -1 synth_params1
adi_if_ports output -1 synth_params2

adi_if_define "jesd204_rx_ilas_config"
adi_if_ports output -1 valid
adi_if_ports output -1 addr
adi_if_ports input -1 data

adi_if_define "jesd204_rx_event"
adi_if_ports output 1 sysref_alignment_error
adi_if_ports output 1 sysref_edge
adi_if_ports output 1 frame_alignment_error
adi_if_ports output 1 unexpected_lane_state_error
