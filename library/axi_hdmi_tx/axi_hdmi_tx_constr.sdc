
set_false_path  -from [get_registers *hdmi_fs_toggle*]                                    -to [get_registers *vdma_fs_toggle_m1]
set_false_path  -from [get_registers *hdmi_raddr_g*]                                      -to [get_registers *vdma_raddr_g_m1*]
set_false_path  -from [get_registers *vdma_fs_ret_toggle*]                                -to [get_registers *hdmi_fs_ret_toggle_m1]
set_false_path  -from [get_registers *vdma_fs_waddr*]                                     -to [get_registers *hdmi_fs_waddr*]

set_false_path  -from [get_registers *up_xfer_status:i_vdma_xfer_status|up_xfer_toggle*]  -to [get_registers *up_xfer_status:i_vdma_xfer_status|d_xfer_state_m1*]
set_false_path  -from [get_registers *up_xfer_status:i_vdma_xfer_status|d_xfer_toggle*]   -to [get_registers *up_xfer_status:i_vdma_xfer_status|up_xfer_toggle_m1*]
set_false_path  -from [get_registers *up_xfer_status:i_vdma_xfer_status|d_xfer_data*]     -to [get_registers *up_xfer_status:i_vdma_xfer_status|up_data_status*]
set_false_path  -from [get_registers *up_core_preset*]                                    -to [get_registers *ad_rst_sync_m1]
