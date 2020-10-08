
set device AD469X
set mode 0

set hier_spi_engine spi_ad469x

if [info exists ::env(ADI_DAC_MODE)] {
  set mode $::env(ADI_DAC_MODE)
} else {
  set env(ADI_DAC_MODE) $mode
}

#                     W  A  NC NS D
set params(AD469X,0) {32 1  1  1  1}

proc get_config_param {param} {
  upvar device device
  upvar mode mode
  upvar params params

  set spi_params {DATA_WIDTH ASYNC_SPI_CLK NUM_CS NUM_SDI SDI_DELAY}
  set index [lsearch $spi_params $param]

  return [lindex $params($device,$mode) $index]
}
