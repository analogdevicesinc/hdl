
set dac_fifo_address_width 10

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/hanpilot/hanpilot_system_qsys.tcl

# altera_iopll

add_instance sma_iopll altera_iopll
set_instance_parameter_value sma_iopll {gui_operation_mode} {normal}
set_instance_parameter_value sma_iopll {gui_number_of_clocks} {1}
set_instance_parameter_value sma_iopll {gui_use_locked} {0}
set_instance_parameter_value sma_iopll {gui_en_extclkout_ports} {1}
set_instance_parameter_value sma_iopll {gui_output_clock_frequency0} {30.72}
add_connection sys_clk.clk_reset sma_iopll.reset
add_interface sma_iopll_refclk refclk end
set_interface_property sma_iopll_refclk EXPORT_OF sma_iopll.refclk
add_interface sma_iopll_out extclk_out end
set_interface_property sma_iopll_out EXPORT_OF sma_iopll.extclk_out

source $ad_hdl_dir/projects/common/hanpilot/hanpilot_sodimm_plddr4_dacfifo_qsys.tcl
source ../common/adrv9371x_qsys.tcl

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

sysid_gen_sys_init_file;
