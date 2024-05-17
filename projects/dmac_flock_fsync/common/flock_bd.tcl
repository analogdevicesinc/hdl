###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

ad_ip_instance v_tpg axi_vtpg
ad_ip_parameter axi_vtpg CONFIG.SAMPLES_PER_CLOCK 2

ad_ip_instance frame_combiner frm_cmbnr

ad_ip_instance axi_dmac axi_tpg_dma
ad_ip_parameter axi_tpg_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_tpg_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_tpg_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_tpg_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_tpg_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_tpg_dma CONFIG.DMA_2D_TRANSFER 1
ad_ip_parameter axi_tpg_dma CONFIG.AXIS_TUSER_SYNC 0
ad_ip_parameter axi_tpg_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_tpg_dma CONFIG.DMA_LENGTH_WIDTH 14
ad_ip_parameter axi_tpg_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_tpg_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_tpg_dma CONFIG.FIFO_SIZE 16
ad_ip_parameter axi_tpg_dma CONFIG.FRAMELOCK 1
ad_ip_parameter axi_tpg_dma CONFIG.DMA_2D_TLAST_MODE 1

# change parameters of hdmi DMAC
ad_ip_parameter axi_hdmi_dma CONFIG.FRAMELOCK 1
ad_ip_parameter axi_hdmi_dma CONFIG.AXIS_TUSER_SYNC 0
ad_ip_parameter axi_hdmi_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_hdmi_dma CONFIG.USE_EXT_SYNC 1
ad_ip_parameter axi_hdmi_dma CONFIG.DMA_2D_TLAST_MODE 0

ad_ip_instance xlconcat xlconcat_0
ad_ip_parameter xlconcat_0 CONFIG.IN0_WIDTH.VALUE_SRC USER
ad_ip_parameter xlconcat_0 CONFIG.IN1_WIDTH.VALUE_SRC USER
ad_ip_parameter xlconcat_0 CONFIG.IN2_WIDTH.VALUE_SRC USER
ad_ip_parameter xlconcat_0 CONFIG.IN3_WIDTH.VALUE_SRC USER
ad_ip_parameter xlconcat_0 CONFIG.NUM_PORTS {4}
ad_ip_parameter xlconcat_0 CONFIG.IN0_WIDTH {24}
ad_ip_parameter xlconcat_0 CONFIG.IN1_WIDTH {8}
ad_ip_parameter xlconcat_0 CONFIG.IN2_WIDTH {24}
ad_ip_parameter xlconcat_0 CONFIG.IN3_WIDTH {8}

ad_ip_instance xlconstant xlconstant_0
ad_ip_parameter xlconstant_0 CONFIG.CONST_WIDTH {8}
ad_ip_parameter xlconstant_0 CONFIG.CONST_VAL {0}

ad_ip_instance xlslice xlslice_0
ad_ip_parameter xlslice_0 CONFIG.DIN_TO {0}
ad_ip_parameter xlslice_0 CONFIG.DIN_WIDTH {48}
ad_ip_parameter xlslice_0 CONFIG.DIN_FROM {23}
ad_ip_parameter xlslice_0 CONFIG.DOUT_WIDTH {24}

ad_ip_instance xlslice xlslice_1
ad_ip_parameter xlslice_1 CONFIG.DIN_TO {24}
ad_ip_parameter xlslice_1 CONFIG.DIN_WIDTH {48}
ad_ip_parameter xlslice_1 CONFIG.DIN_FROM {47}
ad_ip_parameter xlslice_1 CONFIG.DOUT_WIDTH {24}

ad_cpu_interconnect 0x43C00000 axi_vtpg
ad_cpu_interconnect 0x43C20000 axi_tpg_dma
ad_cpu_interconnect 0x43C30000 frm_cmbnr

# disconnect HDMI DMAC from HDMI Tx
set pin [get_bd_pins axi_hdmi_core/vdma_end_of_frame]
delete_bd_objs [get_bd_nets -of $pin]
set pin [get_bd_pins axi_hdmi_core/vdma_valid]
delete_bd_objs [get_bd_nets -of $pin]
set pin [get_bd_pins axi_hdmi_core/vdma_data]
delete_bd_objs [get_bd_nets -of $pin]
set pin [get_bd_pins axi_hdmi_core/vdma_ready]
delete_bd_objs [get_bd_nets -of $pin]
delete_bd_objs [get_bd_intf_nets axi_hdmi_dma_m_axis]

# link the two DMACs
ad_connect axi_tpg_dma/m_framelock axi_hdmi_dma/s_framelock

# connect VTPG to frame combiner
ad_connect axi_vtpg/m_axis_video_TREADY frm_cmbnr/s_in_axis_ready
ad_connect axi_vtpg/m_axis_video_TVALID frm_cmbnr/s_in_axis_valid
ad_connect axi_vtpg/m_axis_video_TLAST frm_cmbnr/s_in_axis_last
ad_connect axi_vtpg/m_axis_video_TUSER frm_cmbnr/s_in_axis_user
ad_connect axi_vtpg/m_axis_video_TDATA xlslice_0/Din
ad_connect axi_vtpg/m_axis_video_TDATA xlslice_1/Din

ad_connect xlslice_0/Dout    xlconcat_0/In0
ad_connect xlconstant_0/dout xlconcat_0/In1
ad_connect xlslice_1/Dout    xlconcat_0/In2
ad_connect xlconstant_0/dout xlconcat_0/In3
ad_connect xlconcat_0/dout   frm_cmbnr/s_in_axis_data

# connect frame combiner to DMAC pair
ad_connect frm_cmbnr/m_fb_out_axis axi_tpg_dma/s_axis
ad_connect axi_hdmi_dma/m_axis frm_cmbnr/s_fb_in_axis

# connect frame combiner to HDMI interface
ad_connect frm_cmbnr/m_out_axis_valid  axi_hdmi_core/vdma_valid
ad_connect frm_cmbnr/m_out_axis_data   axi_hdmi_core/vdma_data
ad_connect frm_cmbnr/m_out_axis_ready  axi_hdmi_core/vdma_ready
ad_connect frm_cmbnr/m_out_axis_last   axi_hdmi_core/vdma_end_of_frame

ad_connect frm_cmbnr/fsync_fb axi_hdmi_dma/dest_ext_sync

# connect clocks and resets
ad_connect sys_cpu_clk axi_tpg_dma/s_axis_aclk
ad_connect sys_cpu_resetn axi_tpg_dma/m_dest_axi_aresetn


ad_connect sys_cpu_clk frm_cmbnr/s_in_axis_aclk
ad_connect sys_cpu_clk frm_cmbnr/s_fb_in_axis_aclk
ad_connect sys_cpu_clk frm_cmbnr/m_out_axis_aclk
ad_connect sys_cpu_clk frm_cmbnr/m_fb_out_axis_aclk

ad_connect sys_cpu_resetn frm_cmbnr/axis_resetn

# connect AXI MM interfaces to cpu
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_tpg_dma/m_dest_axi

# interrupts
ad_cpu_interrupt ps-12 mb-12 axi_tpg_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_vtpg/interrupt
