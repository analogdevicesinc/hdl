
set device AD40XX
set mode 0

set hier_spi_engine spi_ad40xx

#if [info exists ::env(ADI_DAC_DEVICE)] {
#  set device $::env(ADI_DAC_DEVICE)
#} else {
#  set env(ADI_DAC_DEVICE) $device
#}
#
#if [info exists ::env(ADI_DAC_MODE)] {
#  set mode $::env(ADI_DAC_MODE)
#} else {
#  set env(ADI_DAC_MODE) $mode
#}

#set data_width 32
#set async_spi_clk 1
#set num_cs 1
#set num_sdi 1
#set sdi_delay 2

#set params(AD40XX,00) {$data_width $async_spi_clk $num_cs $num_sdi $sdi_delay}

#                     W  A NC NS D
set params(AD40XX,0) {32 1 1 1 2}

proc get_config_param {param} {
  upvar device device
  upvar mode mode
  upvar params params

  set spi_params {DATA_WIDTH ASYNC_SPI_CLK NUM_CS NUM_SDI SDI_DELAY}
  set index [lsearch $spi_params $param]

  return [lindex $params($device,$mode) $index]
}