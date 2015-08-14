
create_pblock pb_prcfg

add_cells_to_pblock [get_pblocks pb_prcfg] [get_cells -quiet [list i_prcfg]]

resize_pblock [get_pblocks pb_prcfg] -add {SLICE_X90Y0:SLICE_X161Y149}
resize_pblock [get_pblocks pb_prcfg] -add {SLICE_X90Y150:SLICE_X122Y199}
resize_pblock [get_pblocks pb_prcfg] -add {RAMB18_X4Y0:RAMB18_X7Y59}
resize_pblock [get_pblocks pb_prcfg] -add {RAMB18_X4Y60:RAMB18_X4Y79}
resize_pblock [get_pblocks pb_prcfg] -add {RAMB36_X4Y0:RAMB36_X7Y29}
resize_pblock [get_pblocks pb_prcfg] -add {DSP48_X4Y0:DSP48_X6Y59}
resize_pblock [get_pblocks pb_prcfg] -add {DSP48_X4Y60:DSP48_X4Y79}

set_property SNAPPING_MODE ON [get_pblocks pb_prcfg]
set_property RESET_AFTER_RECONFIG 1 [get_pblocks pb_prcfg]

