

package require -exact qsys 15.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

ad_ip_create util_adcfifo {UTIL ADC FIFO Interface}
ad_ip_files util_adcfifo [list\
  $ad_hdl_dir/library/altera/common/ad_mem_asym.v \
  $ad_hdl_dir/library/common/ad_axis_inf_rx.v \
  util_adcfifo.v \
  util_adcfifo_constr.sdc]

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter ADC_DATA_WIDTH INTEGER 256
ad_ip_parameter DMA_DATA_WIDTH INTEGER 64
ad_ip_parameter DMA_READY_ENABLE INTEGER 1
ad_ip_parameter DMA_ADDRESS_WIDTH INTEGER 10

# interfaces

ad_alt_intf clock adc_clk input 1 adc_clk
ad_alt_intf reset adc_rst input 1 if_adc_clk
ad_alt_intf signal adc_wr input 1 valid
ad_alt_intf signal adc_wdata input ADC_DATA_WIDTH data
ad_alt_intf signal adc_wovf output 1 ovf

ad_alt_intf clock dma_clk input 1 clk
ad_alt_intf signal dma_wr output 1 valid
ad_alt_intf signal dma_wdata output DMA_DATA_WIDTH data
ad_alt_intf signal dma_wready input 1 ready
ad_alt_intf signal dma_xfer_req input 1 xfer_req
ad_alt_intf signal dma_xfer_status output 4 xfer_status

