
# ltc2387

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports ref_clk_p]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports ref_clk_n]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_p]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_n]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports da_p]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports da_n]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports db_p]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports db_n]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25} [get_ports clk_p]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25} [get_ports clk_n]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25} [get_ports cnv_p]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25} [get_ports cnv_n]

# clocks

create_clock -period 5.128 -name dco [get_ports dco_p]
create_clock -period 10.000 -name ref_clk [get_ports ref_clk_p]

create_generated_clock -name data_clk -source [get_pins i_system_wrapper/system_i/axi_clkgen/inst/i_mmcm_drp/i_mmcm/CLKIN1] -master_clock ref_clk [get_pins i_system_wrapper/system_i/axi_clkgen/inst/i_mmcm_drp/i_mmcm/CLKOUT0]

set_multicycle_path 2 -setup -end -from dco -to data_clk
set_multicycle_path 1 -hold -start -from dco -to data_clk

set_input_delay -clock dco -max 0.2 [get_ports da_p];
set_input_delay -clock dco -min -0.2 [get_ports da_p];
set_input_delay -clock dco -max 0.2 [get_ports da_p] -clock_fall -add_delay;
set_input_delay -clock dco -min -0.2 [get_ports da_p] -clock_fall -add_delay;

set_input_delay -clock dco -max 0.2 [get_ports db_p];
set_input_delay -clock dco -min -0.2 [get_ports db_p];
set_input_delay -clock dco -max 0.2 [get_ports db_p] -clock_fall -add_delay;
set_input_delay -clock dco -min -0.2 [get_ports db_p] -clock_fall -add_delay;

set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387/inst/i_if/i_rx_db/i_rx_data_idelay]
set_property IDELAY_VALUE 27 [get_cells i_system_wrapper/system_i/axi_ltc2387/inst/i_if/i_rx_da/i_rx_data_idelay]
