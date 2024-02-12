#!/bin/bash

# module load xlm

xmvlog -sv ../jesd204_common/lfsr_input.sv
xmvlog -sv ../jesd204_tx/jesd204_fec_encode.sv
xmvlog -sv tb_jesd204_fec_encode.sv
xmelab -access +rwc -timescale 1ns/1ns tb_jesd204_fec_encode

if [ "$#" -ne 1 ]; then
    xmsim -gui tb_jesd204_fec_encode &
fi
