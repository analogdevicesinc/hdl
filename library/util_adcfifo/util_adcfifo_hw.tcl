

package require -exact qsys 15.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl


set_module_property NAME util_adcfifo
set_module_property DESCRIPTION "ADC FIFO utility"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME util_adcfifo

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_adcfifo

add_fileset_file ad_axis_inf_rx.v             VERILOG PATH ../common/ad_axis_inf_rx.v
add_fileset_file ad_mem_asym.v                VERILOG PATH ../common/ad_mem_asym.v
add_fileset_file util_adcfifo.v               VERILOG PATH util_adcfifo.v TOP_LEVEL_FILE
add_fileset_file util_adcfifo_constr.sdc      SDC     PATH util_adcfifo_constr.sdc

# parameters

add_parameter ADC_DATA_WIDTH INTEGER 0
set_parameter_property ADC_DATA_WIDTH DEFAULT_VALUE 256
set_parameter_property ADC_DATA_WIDTH DISPLAY_NAME ADC_DATA_WIDTH
set_parameter_property ADC_DATA_WIDTH TYPE INTEGER
set_parameter_property ADC_DATA_WIDTH UNITS None
set_parameter_property ADC_DATA_WIDTH HDL_PARAMETER true

add_parameter DMA_DATA_WIDTH INTEGER 0
set_parameter_property DMA_DATA_WIDTH DEFAULT_VALUE 64
set_parameter_property DMA_DATA_WIDTH DISPLAY_NAME DMA_DATA_WIDTH
set_parameter_property DMA_DATA_WIDTH TYPE INTEGER
set_parameter_property DMA_DATA_WIDTH UNITS None
set_parameter_property DMA_DATA_WIDTH HDL_PARAMETER true

add_parameter DMA_READY_ENABLE INTEGER 0
set_parameter_property DMA_READY_ENABLE DEFAULT_VALUE 1
set_parameter_property DMA_READY_ENABLE DISPLAY_NAME DMA_READY_ENABLE
set_parameter_property DMA_READY_ENABLE TYPE INTEGER
set_parameter_property DMA_READY_ENABLE UNITS None
set_parameter_property DMA_READY_ENABLE HDL_PARAMETER true

add_parameter DMA_ADDRESS_WIDTH INTEGER 0
set_parameter_property DMA_ADDRESS_WIDTH DEFAULT_VALUE 10
set_parameter_property DMA_ADDRESS_WIDTH DISPLAY_NAME DMA_ADDRESS_WIDTH
set_parameter_property DMA_ADDRESS_WIDTH TYPE INTEGER
set_parameter_property DMA_ADDRESS_WIDTH UNITS None
set_parameter_property DMA_ADDRESS_WIDTH HDL_PARAMETER true

# defaults

ad_alt_intf clock   adc_clk         input   1               adc_clk
ad_alt_intf reset   adc_rst         input   1               if_adc_clk
ad_alt_intf signal  adc_wr          input   1               valid
ad_alt_intf signal  adc_wdata       input   ADC_DATA_WIDTH  data
ad_alt_intf signal  adc_wovf        output  1               ovf

ad_alt_intf clock   dma_clk           input   1                 clk
ad_alt_intf signal  dma_wr            output  1                 valid
ad_alt_intf signal  dma_wdata         output  DMA_DATA_WIDTH    data
ad_alt_intf signal  dma_wready        input   1                 ready
ad_alt_intf signal  dma_xfer_req      input   1                 xfer_req
