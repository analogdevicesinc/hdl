set_false_path -from [get_cells -hier -filter {name =~ *up_drp_locked_reg  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *dac_status_m1_reg     && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ */axi_ad9122/*/i_core_rst_reg/rst_reg* && IS_SEQUENTIAL}] 
               -to   [get_cells -hier -filter {name =~ */axi_ad9122/inst/i_if/i_serdes_out_clk/g_data[0].i_serdes && IS_SEQUENTIAL}]
