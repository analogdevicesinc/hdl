
set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg* && IS_SEQUENTIAL}] \
                -to [get_cells -hierarchical -filter {name =~ i_system* && IS_SEQUENTIAL}]
set_false_path  -from [get_cells -hierarchical -filter {name =~ i_system* && IS_SEQUENTIAL}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg* && IS_SEQUENTIAL}]

set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg* && IS_SEQUENTIAL}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*i_pn_mon* && IS_SEQUENTIAL}]

set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*input_pipeline_phase* && IS_SEQUENTIAL}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*ddata_reg* && IS_SEQUENTIAL}]

set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Decimation* && IS_SEQUENTIAL}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*dst_adc_ddata_reg*}]
set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation* && IS_SEQUENTIAL}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*dst_dac_ddata_reg*}]

set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Decimation*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Decimation*regout_re_reg* && IS_SEQUENTIAL}]
set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Decimation*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Decimation*regout_im_reg* && IS_SEQUENTIAL}]

set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*cur_count_reg*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*regout_re_reg* && IS_SEQUENTIAL}]
set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*cur_count_reg*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*regout_im_reg* && IS_SEQUENTIAL}]

set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*prcfg_dac*mode_reg*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation* && IS_SEQUENTIAL}]
set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*prcfg_dac*mode_reg*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*dst_dac_ddata_reg* && IS_SEQUENTIAL}]

set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*pn_data_reg*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*regout_re_reg* && IS_SEQUENTIAL}]
set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*pn_data_reg*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*regout_im_reg* && IS_SEQUENTIAL}]
set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*pn_data_reg*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*dst_dac_ddata_reg* && IS_SEQUENTIAL}]

set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*delay_pipeline_re_reg*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*regout_re_reg* && IS_SEQUENTIAL}]
set_false_path  -from [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*delay_pipeline_im_reg*}] \
                -to [get_cells -hierarchical -filter {name =~ i_prcfg*FIR_Interpolation*regout_im_reg* && IS_SEQUENTIAL}]

