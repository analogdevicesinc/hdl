
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/ad77681evb_bd.tcl

# Disable a CRITICAL WARNING, which appears because of the SPI_ENGINE and DMA data width
# missmatch.
# The warning are the following:
#
#   CRITICAL WARNING: [BD 41-237] Bus Interface property TDATA_NUM_BYTES does not
#   match between /axi_ad77681_dma_1/s_axis(4) and /spi_adc1/m_axis_samples_24/M_AXIS(3)
#   CRITICAL WARNING: [BD 41-237] Bus Interface property TDATA_NUM_BYTES does not
#   match between /axi_ad77681_dma_2/s_axis(4) and /spi_adc2/m_axis_samples_24/M_AXIS(3)
set_msg_config -severity {CRITICAL WARNING} -quiet -id {BD 41-237} -new_severity info
