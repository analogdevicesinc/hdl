
set m_dma_cfg [list \
   DMA_TYPE_SRC 1 \
   DMA_TYPE_DEST 0 \
   DMA_2D_TRANSFER 1 \
   CYCLIC 1 \
   ENABLE_FRAME_LOCK 1 \
   SYNC_TRANSFER_START 1 \
   DMA_2D_TLAST_MODE {1} \
   \
   HAS_AUTORUN           {1} \
   DMAC_DEF_FLAGS        {0xB} \
   DMAC_DEF_SRC_ADDR     {0x00000000} \
   DMAC_DEF_DEST_ADDR    {0x00001000} \
   DMAC_DEF_X_LENGTH     {0x3FF} \
   DMAC_DEF_Y_LENGTH     {0x7} \
   DMAC_DEF_SRC_STRIDE   {0x000} \
   DMAC_DEF_DEST_STRIDE  {0x400} \
   DMAC_DEF_FLOCK_CFG    {0x00303} \
   DMAC_DEF_FLOCK_STRIDE {0x2000} \
]

set s_dma_cfg [list \
   DMA_TYPE_SRC {0} \
   DMA_TYPE_DEST {1} \
   DMA_2D_TRANSFER 1 \
   CYCLIC 1 \
   ENABLE_FRAME_LOCK 1 \
   USE_EXT_SYNC 1 \
   DMA_2D_TLAST_MODE {1} \
   \
   HAS_AUTORUN           {1} \
   DMAC_DEF_FLAGS        {0xB} \
   DMAC_DEF_SRC_ADDR     {0x00001000} \
   DMAC_DEF_DEST_ADDR    {0x00000000} \
   DMAC_DEF_X_LENGTH     {0x3FF} \
   DMAC_DEF_Y_LENGTH     {0x7} \
   DMAC_DEF_SRC_STRIDE   {0x000} \
   DMAC_DEF_DEST_STRIDE  {0x400} \
   DMAC_DEF_FLOCK_CFG    {0x00303} \
   DMAC_DEF_FLOCK_STRIDE {0x2000} \
]


# VDMA config
set vdma_cfg [list \
 c_m_axis_mm2s_tdata_width {64} \
 c_num_fstores {8} \
 c_use_mm2s_fsync {1} \
 c_use_s2mm_fsync {2} \
 c_enable_vert_flip {0} \
 c_mm2s_genlock_mode {1} \
 c_s2mm_genlock_mode {0} \
]


# SRC AXIS
set src_axis_vip_cfg [list \
   INTERFACE_MODE {MASTER} \
   HAS_TLAST {1} \
   TUSER_WIDTH {1} \
   TDATA_NUM_BYTES {8}
  ]

# DST AXIS
set dst_axis_vip_cfg [list \
   INTERFACE_MODE {SLAVE} \
   HAS_TLAST {1} \
   TDATA_NUM_BYTES {8}
]

