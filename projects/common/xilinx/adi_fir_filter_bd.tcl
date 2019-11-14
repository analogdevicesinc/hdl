
###################################################################################################
###################################################################################################
##
# ad_add_decimation_filter - Creates a subsystem based on the Xilinx fir_compiler IP.
# \param[name] - Subsystem name
# \param[filter_rate] - Filter rate. E.g., 8
# \param[n_chan] - Number of channels to filter
# \param[parallel_paths] - Number of paralell paths. For scenarios where
# the sampling rate is x times the core clock.
# \param[core_clk_mhz] - Core clock in MHz
# \param[sampl_freq_mhz] - Sampling frequency in MHz
proc ad_add_decimation_filter {name filter_rate n_chan parallel_paths \
                              core_clk_mhz sampl_freq_mhz coe_file} {
  global ad_hdl_dir

  create_bd_cell -type hier $name
  set filter_name "fir_decimation"

  create_bd_pin -dir I $name/aclk
  create_bd_pin -dir I $name/active

  # Adding the ad_bus_axis.v file in the project fileset sources_1 will not work
  add_files -norecurse  $ad_hdl_dir/library/common/ad_bus_mux.v
  add_files -norecurse  $ad_hdl_dir/library/util_cdc/sync_bits.v
  add_files -norecurse -fileset constrs_1 $ad_hdl_dir/projects/common/xilinx/adi_fir_filter_constr.xdc

  # cdc active/source
  create_bd_cell -type module -reference sync_bits $name/cdc_sync_active

  ad_connect $name/aclk $name/cdc_sync_active/out_clk
  ad_connect $name/cdc_sync_active/out_resetn VCC
  ad_connect $name/active $name/cdc_sync_active/in_bits

  # add filter instances for n channels
  for {set i 0} {$i < $n_chan} {incr i} {
    ad_ip_instance fir_compiler $name/${filter_name}_${i} [ list \
      Decimation_Rate $filter_rate \
      Filter_Type "Decimation" \
      Interpolation_Rate 1 \
      Number_Paths $parallel_paths \
      Clock_Frequency $core_clk_mhz \
      Sample_Frequency $sampl_freq_mhz \
      CoefficientSource COE_File \
      Coefficient_File $coe_file \
      Coefficient_Fractional_Bits 0 \
      Data_Fractional_Bits 15 \
      Coefficient_Sets 1 \
      Coefficient_Sign Signed \
      Coefficient_Structure Inferred \
      Coefficient_Width 16 \
      ColumnConfig 5 \
      Filter_Architecture Systolic_Multiply_Accumulate \
      Number_Channels 1 \
      Output_Rounding_Mode Symmetric_Rounding_to_Zero \
      Output_Width 16 \
      Quantization Integer_Coefficients \
      RateSpecification Frequency_Specification \
      Zero_Pack_Factor 1
    ]

    ad_connect $name/aclk $name/${filter_name}_${i}/aclk

    create_bd_pin -dir I $name/valid_in_$i
    create_bd_pin -dir I $name/enable_in_$i
    create_bd_pin -dir O $name/valid_out_$i
    create_bd_pin -dir O $name/enable_out_$i
    create_bd_pin -dir I -from [expr 16*$parallel_paths-1] -to 0 $name/data_in_$i
    create_bd_pin -dir O -from [expr 16*$parallel_paths-1] -to 0 $name/data_out_$i

    create_bd_cell -type module -reference ad_bus_mux $name/out_mux_$i
    set_property -dict [list \
      CONFIG.DATA_WIDTH [expr 16 * $parallel_paths]] [get_bd_cells $name/out_mux_$i]

    ad_connect  $name/valid_in_$i  $name/out_mux_${i}/valid_in_0
    ad_connect  $name/enable_in_$i  $name/out_mux_${i}/enable_in_0
    ad_connect  $name/data_in_$i  $name/out_mux_${i}/data_in_0

    ad_connect  $name/valid_in_$i  $name/${filter_name}_${i}/s_axis_data_tvalid
    ad_connect  $name/enable_in_$i  $name/out_mux_${i}/enable_in_1
    ad_connect  $name/data_in_$i  $name/${filter_name}_${i}/s_axis_data_tdata

    ad_connect  $name/${filter_name}_${i}/m_axis_data_tvalid  $name/out_mux_${i}/valid_in_1
    ad_connect  $name/${filter_name}_${i}/m_axis_data_tdata  $name/out_mux_${i}/data_in_1

    ad_connect  $name/valid_out_$i  $name/out_mux_${i}/valid_out
    ad_connect  $name/enable_out_$i  $name/out_mux_${i}/enable_out
    ad_connect  $name/data_out_$i  $name/out_mux_${i}/data_out

    ad_connect  $name/cdc_sync_active/out_bits $name/out_mux_${i}/select_path
  }
}


###################################################################################################
###################################################################################################
##
# ad_add_interpolation_filter - Creates a subsystem based on the Xilinx fir_compiler IP.
# \param[name] - Subsystem name
# \param[filter_rate] - Filter rate. E.g., 8
# \param[n_chan] - Number of channels to filter
# \param[parallel_paths] - Number of paralell paths. For scenarios where
# the sampling rate is x times the core clock.
# \param[core_clk_mhz] - Core clock in MHz
# \param[sampl_freq_mhz] - Sampling frequency in MHz
proc ad_add_interpolation_filter {name filter_rate n_chan parallel_paths \
                                 core_clk_mhz sampl_freq_mhz coe_file} {
  global ad_hdl_dir

  create_bd_cell -type hier $name
  set filter_name "fir_interpolation"

  add_files -norecurse $ad_hdl_dir/library/common/ad_bus_mux.v
  add_files -norecurse $ad_hdl_dir/library/common/util_pulse_gen.v
  add_files -norecurse $ad_hdl_dir/library/util_cdc/sync_bits.v
  add_files -norecurse -fileset constrs_1 $ad_hdl_dir/projects/common/xilinx/adi_fir_filter_constr.xdc

  create_bd_pin -dir I $name/aclk
  create_bd_pin -dir I $name/active

  # cdc active/source
  create_bd_cell -type module -reference sync_bits $name/cdc_sync_active

  ad_connect $name/aclk $name/cdc_sync_active/out_clk
  ad_connect $name/cdc_sync_active/out_resetn VCC
  ad_connect $name/active $name/cdc_sync_active/in_bits

  # Create pulse generator for ready/valid signals - This is required because
  # there is only one clock domain for the slave and master data paths.
  # The generator will give a 1 clock cycle pulse every N clock cycle periods.
  # N = data  rate.
  create_bd_cell -type module -reference util_pulse_gen $name/rate_gen
  set_property -dict [list \
    CONFIG.PULSE_WIDTH {1} \
    CONFIG.PULSE_PERIOD [expr $filter_rate -1]] [get_bd_cells $name/rate_gen]

  ad_connect  $name/aclk  $name/rate_gen/clk
  ad_connect  $name/rate_gen/pulse_width  GND
  ad_connect  $name/rate_gen/pulse_period  GND
  ad_connect  $name/rate_gen/load_config  GND
  ad_connect  $name/cdc_sync_active/out_bits  $name/rate_gen/rstn

  # add filter instances for n channels
  for {set i 0} {$i < $n_chan} {incr i} {
    ad_ip_instance fir_compiler $name/${filter_name}_${i} [ list \
      Decimation_Rate 1 \
      Filter_Type "Interpolation" \
      Interpolation_Rate $filter_rate \
      Number_Paths $parallel_paths \
      Clock_Frequency $core_clk_mhz \
      Sample_Frequency $sampl_freq_mhz \
      CoefficientSource COE_File \
      Coefficient_File $coe_file \
      Coefficient_Fractional_Bits 0 \
      Data_Fractional_Bits 15 \
      Coefficient_Sets 1 \
      Coefficient_Sign Signed \
      Coefficient_Structure Inferred \
      Coefficient_Width 16 \
      ColumnConfig 5 \
      Filter_Architecture Systolic_Multiply_Accumulate \
      Number_Channels 1 \
      Output_Rounding_Mode Symmetric_Rounding_to_Zero \
      Output_Width 16 \
      Quantization Integer_Coefficients \
      RateSpecification Frequency_Specification \
      Zero_Pack_Factor 1
    ]

    ad_connect $name/aclk $name/${filter_name}_${i}/aclk

    create_bd_pin -dir I $name/dac_valid_$i
    create_bd_pin -dir I $name/dac_enable_$i
    create_bd_pin -dir O $name/valid_out_$i
    create_bd_pin -dir O $name/enable_out_$i
    create_bd_pin -dir I -from [expr 16*$parallel_paths-1] -to 0 $name/data_in_$i
    create_bd_pin -dir O -from [expr 16*$parallel_paths-1] -to 0 $name/data_out_$i

    ad_ip_instance util_vector_logic $name/logic_and_$i [list \
      C_SIZE 1]

    create_bd_cell -type module -reference ad_bus_mux $name/out_mux_$i
    set_property -dict [list \
      CONFIG.DATA_WIDTH [expr 16 * $parallel_paths]] [get_bd_cells $name/out_mux_$i]

    ad_connect  $name/rate_gen/pulse  $name/logic_and_$i/Op1
    ad_connect  $name/dac_valid_$i  $name/logic_and_$i/Op2
    ad_connect  $name/logic_and_$i/Res  $name/${filter_name}_${i}/s_axis_data_tvalid
    ad_connect  $name/${filter_name}_${i}/s_axis_data_tdata  $name/data_in_$i

    ad_connect  $name/rate_gen/pulse  $name/out_mux_${i}/valid_in_1
    ad_connect  $name/dac_enable_$i  $name/out_mux_${i}/enable_in_1
    ad_connect  $name/${filter_name}_${i}/m_axis_data_tdata  $name/out_mux_${i}/data_in_1

    ad_connect  $name/dac_valid_$i  $name/out_mux_${i}/valid_in_0
    ad_connect  $name/dac_enable_$i  $name/out_mux_${i}/enable_in_0
    ad_connect  $name/data_in_$i  $name/out_mux_${i}/data_in_0

    ad_connect  $name/out_mux_${i}/valid_out  $name/valid_out_$i
    ad_connect  $name/out_mux_${i}/enable_out  $name/enable_out_$i
    ad_connect  $name/out_mux_${i}/data_out  $name/data_out_$i

    ad_connect  $name/cdc_sync_active/out_bits  $name/out_mux_${i}/select_path
  }
}

