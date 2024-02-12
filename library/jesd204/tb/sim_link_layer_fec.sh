#!/bin/bash

# module load xlm

xmvlog  ../../../util_cdc/fpga_src/sync_bits.v
xmvlog  ../../../util_cdc/fpga_src/sync_event.v

xmvlog  ../jesd204_common/jesd204_lmfc.v
xmvlog  ../jesd204_common/jesd204_scrambler.v
xmvlog  ../jesd204_common/jesd204_scrambler_64b.v
xmvlog  ../jesd204_common/jesd204_crc12.v
xmvlog  ../jesd204_common/jesd204_frame_mark.v
xmvlog  ../jesd204_common/jesd204_frame_align_replace.v
xmvlog  ../jesd204_common/pipeline_stage.v

xmvlog -sv ../jesd204_common/lfsr_input.sv
xmvlog -sv ../jesd204_tx/jesd204_fec_encode.sv
xmvlog  ../jesd204_tx/jesd204_tx_lane.v
xmvlog  ../jesd204_tx/jesd204_tx_lane_64b.v
xmvlog  ../jesd204_tx/jesd204_tx_gearbox.v
xmvlog  ../jesd204_tx/jesd204_tx_header.v
xmvlog  ../jesd204_tx/jesd204_tx_ctrl.v
xmvlog  ../jesd204_tx/jesd204_tx.v

xmvlog  ../../../ad_common/fpga_src/ad_mem_dist.v
xmvlog -sv ../jesd204_rx/jesd204_rx_fec_lfsr.sv
xmvlog -sv ../jesd204_rx/jesd204_fec_decode.sv
xmvlog  ../jesd204_rx/jesd204_rx_lane.v
xmvlog  ../jesd204_rx/jesd204_rx_lane_64b.v
xmvlog  ../jesd204_rx/jesd204_rx_header.v
xmvlog  ../jesd204_rx/jesd204_rx_cgs.v
xmvlog  ../jesd204_rx/jesd204_rx_ctrl.v
xmvlog  ../jesd204_rx/jesd204_rx_ctrl_64b.v
xmvlog  ../jesd204_rx/elastic_buffer.v
xmvlog  ../jesd204_rx/error_monitor.v
xmvlog  ../jesd204_rx/jesd204_ilas_monitor.v
xmvlog  ../jesd204_rx/align_mux.v
xmvlog  ../jesd204_rx/jesd204_lane_latency_monitor.v
xmvlog  ../jesd204_rx/jesd204_rx_frame_align.v
xmvlog  ../jesd204_rx/jesd204_rx.v

xmvlog  ../jesd204_rx_static_config/jesd204_rx_static_config.v
xmvlog  ../jesd204_tx_static_config/jesd204_tx_static_config.v
xmvlog  ../jesd204_tx_static_config/jesd204_ilas_cfg_static.v

xmvlog -sv tb_link_layer_fec.sv
xmelab -LICQUEUE -access +rwc -timescale 1ns/1ns tb_link_layer_fec

if [ "$#" -ne 1 ]; then
    xmsim -LICQUEUE -gui tb_link_layer_fec &
fi
