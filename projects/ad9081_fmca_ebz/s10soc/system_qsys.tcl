###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/s10soc/s10soc_system_qsys.tcl
source $ad_hdl_dir/projects/common/intel/dacfifo_qsys.tcl
source $ad_hdl_dir/projects/common/intel/adcfifo_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/ad9081_fmca_ebz_qsys.tcl
} else {
  source ../common/ad9081_fmca_ebz_qsys.tcl
}

