#!/bin/bash

# module load xlm

xmvlog -sv ../jesd204_common/lfsr_input.sv
xmvlog -sv tb_lfsr_input.sv
xmelab -access +rwc -timescale 1ns/1ns tb_lfsr_input

if [ "$#" -ne 1 ]; then
    xmsim -gui tb_lfsr_input &
fi
