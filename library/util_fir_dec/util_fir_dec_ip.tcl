source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_fir_dec

set fir_decim [create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_decim]
 set_property -dict [ list \
CONFIG.Clock_Frequency {61.44} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../coefile_dec.coe} \
CONFIG.Coefficient_Fractional_Bits {0} \
CONFIG.Data_Fractional_Bits {15} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {5} \
CONFIG.Decimation_Rate {8} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Number_Paths {2} \
CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
CONFIG.Output_Width {16} \
CONFIG.Quantization {Integer_Coefficients} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {61.44} \
CONFIG.Zero_Pack_Factor {1} \
 ] [get_ips fir_decim]

generate_target {all} [get_files util_fir_dec.srcs/sources_1/ip/fir_decim/fir_decim.xci]


adi_ip_files util_fir_dec [list \
"util_fir_dec.v" ]

adi_ip_properties_lite util_fir_dec

ipx::save_core [ipx::current_core]
