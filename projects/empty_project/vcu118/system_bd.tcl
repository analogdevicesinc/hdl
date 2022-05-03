
source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

#  --------
# Flash SPI access
ad_ip_instance axi_quad_spi axi_cfg_spi [list \
  C_SPI_MEMORY {2} \
  C_USE_STARTUP {1} \
  C_USE_STARTUP_INT {1} \
  C_NUM_SS_BITS {1} \
  QSPI_BOARD_INTERFACE {Custom} \
  C_DUAL_QUAD_MODE {0} \
  C_SPI_MODE {2} \
  C_SCK_RATIO {2} \
  C_FIFO_DEPTH {256} \
  C_TYPE_OF_AXI4_INTERFACE {0} \
  ]

ad_cpu_interconnect 0x44A80000 axi_cfg_spi

ad_cpu_interrupt NA mb-7 axi_cfg_spi/ip2intc_irpt

# Take a 100 MHz clock from the DDR controller
ad_connect $sys_cpu_clk axi_cfg_spi/ext_spi_clk

#  --------

