
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# adc's SPI frequency in Mhz
global adc_spi_freq

# EVAL-CN0335[6/7]-PMDZ
set adc_spi_freq  7
# EVAL-CN0350-PMDZ
#set adc_spi_freq  50

adi_project_create cftl_custom_zed
adi_project_files cftl_custom_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

adi_project_run cftl_custom_zed

