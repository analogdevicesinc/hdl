source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_xilinx.tcl
source ../../scripts/adi_board.tcl
source ../common/config.tcl

adi_project ad469x_fmc_zed 0 [list \
  DATA_WIDTH      [get_config_param DATA_WIDTH] \
  ASYNC_SPI_CLK   [get_config_param ASYNC_SPI_CLK] \
  NUM_CS          [get_config_param NUM_CS] \
  NUM_SDI         [get_config_param NUM_SDI] \
  SDI_DELAY       [get_config_param SDI_DELAY] \
]

adi_project_files ad469x_fmc_zed [list \
    "../../../library/common/ad_iobuf.v" \
    "../../common/zed/zed_system_constr.xdc" \
    "system_top.v" \
    "system_constr.xdc"]

adi_project_run ad469x_fmc_zed
