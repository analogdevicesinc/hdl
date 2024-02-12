#!/bin/bash

# module load xlm

xmvlog -sv ../jesd204_common/lfsr_input.sv
xmvlog ../../../ad_common/fpga_src/ad_mem_dist.v
xmvlog -sv ../jesd204_tx/jesd204_fec_encode.sv
xmvlog -sv ../jesd204_rx/jesd204_rx_fec_lfsr.sv
xmvlog -sv ../jesd204_rx/jesd204_fec_decode.sv
xmvlog -sv tb_link_layer_fec.v
xmelab -LICQUEUE -access +rwc -timescale 1ns/1ns tb_link_layer_fec

if [ "$#" -ne 1 ]; then
    xmsim -gui tb_link_layer_fec &
fi

