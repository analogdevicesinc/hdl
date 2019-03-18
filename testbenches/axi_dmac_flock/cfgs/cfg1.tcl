
set m_dma_cfg [list \
   DMA_TYPE_SRC 1 \
   DMA_TYPE_DEST 0 \
   DMA_2D_TRANSFER 1 \
   CYCLIC 1 \
   ENABLE_FRAME_LOCK 1 \
   DMA_2D_TLAST_MODE {1} \
]

set s_dma_cfg [list \
   DMA_TYPE_SRC {0} \
   DMA_TYPE_DEST {1} \
   DMA_2D_TRANSFER 1 \
   CYCLIC 1 \
   ENABLE_FRAME_LOCK 1 \
   DMA_2D_TLAST_MODE {1} \
]

# VDMA config
set vdma_cfg [list \
 c_m_axis_mm2s_tdata_width {64} \
 c_num_fstores {3} \
 c_use_mm2s_fsync {0} \
 c_use_s2mm_fsync {0} \
 c_enable_vert_flip {0} \
 c_mm2s_genlock_mode {3} \
 c_s2mm_genlock_mode {2} \
 c_mm2s_linebuffer_depth {8192} \
 c_s2mm_linebuffer_depth {8192} \
]

# SRC AXIS
set src_axis_vip_cfg [list \
   INTERFACE_MODE {MASTER} \
   HAS_TLAST {1} \
   TDATA_NUM_BYTES {8}
  ]

# DST AXIS
set dst_axis_vip_cfg [list \
   INTERFACE_MODE {SLAVE} \
   HAS_TLAST {1} \
   TDATA_NUM_BYTES {8}
]

