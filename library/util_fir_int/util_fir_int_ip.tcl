###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_fir_int

set fir_interp [create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_interp]
 set_property -dict [ list \
CONFIG.Clock_Frequency {61.44} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../coefile_int.coe} \
CONFIG.Coefficient_Fractional_Bits {0} \
CONFIG.Data_Fractional_Bits {15} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.S_DATA_Has_FIFO {true} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {5} \
CONFIG.Decimation_Rate {1} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Interpolation} \
CONFIG.Interpolation_Rate {8} \
CONFIG.M_DATA_Has_TREADY {false} \
CONFIG.Number_Channels {1} \
CONFIG.Number_Paths {2} \
CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
CONFIG.Output_Width {16} \
CONFIG.Quantization {Integer_Coefficients} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {7.68} \
CONFIG.Zero_Pack_Factor {1} \
 ] [get_ips fir_interp]

generate_target {all} [get_files util_fir_int.srcs/sources_1/ip/fir_interp/fir_interp.xci]


adi_ip_files util_fir_int [list \
"util_fir_int.v" ]

adi_ip_properties_lite util_fir_int

ipx::save_core [ipx::current_core]
