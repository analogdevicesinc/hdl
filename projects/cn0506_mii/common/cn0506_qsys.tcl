
# Instances and instance parameters

set_instance_parameter_value sys_hps {CLK_EMACA_SOURCE} {1}
set_instance_parameter_value sys_hps {CLK_EMACB_SOURCE} {1}
set_instance_parameter_value sys_hps {CLK_EMAC_PTP_SOURCE} {1}
set_instance_parameter_value sys_hps {EMAC0_CLK} {250}
set_instance_parameter_value sys_hps {EMAC0_Mode} {RMII_with_MDIO}
set_instance_parameter_value sys_hps {EMAC0_PTP} {0}
set_instance_parameter_value sys_hps {EMAC0_PinMuxing} {FPGA}
set_instance_parameter_value sys_hps {EMAC0_SWITCH_Enable} {0}
set_instance_parameter_value sys_hps {EMAC1_CLK} {250}
set_instance_parameter_value sys_hps {EMAC1_Mode} {RMII_with_MDIO}
set_instance_parameter_value sys_hps {EMAC1_PTP} {0}
set_instance_parameter_value sys_hps {EMAC1_PinMuxing} {FPGA}
set_instance_parameter_value sys_hps {EMAC1_SWITCH_Enable} {0}
set_instance_parameter_value sys_hps {EMAC2_CLK} {250}
set_instance_parameter_value sys_hps {EMAC2_Mode} {N/A}
set_instance_parameter_value sys_hps {EMAC2_PTP} {0}
set_instance_parameter_value sys_hps {EMAC2_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {EMAC2_SWITCH_Enable} {0}
set_instance_parameter_value sys_hps {EMAC_PTP_REF_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC0_GTX_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC0_MD_CLK} {2.5}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_GTX_CLK} {125}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_MD_CLK} {2.5}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC2_GTX_CLK} {125}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC2_MD_CLK} {2.5}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C0_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C1_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2CEMAC0_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2CEMAC1_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2CEMAC2_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_QSPI_SCLK_OUT} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SDMMC_CCLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM0_SCLK_OUT} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM1_SCLK_OUT} {100}


# exported interfaces
add_interface sys_hps_emac0 conduit end
set_interface_property sys_hps_emac0 EXPORT_OF sys_hps.emac0
add_interface sys_hps_emac0_md_clk clock source
set_interface_property sys_hps_emac0_md_clk EXPORT_OF sys_hps.emac0_md_clk
add_interface sys_hps_emac0_rx_clk_in clock sink
set_interface_property sys_hps_emac0_rx_clk_in EXPORT_OF sys_hps.emac0_rx_clk_in
add_interface sys_hps_emac0_tx_clk_in clock sink
set_interface_property sys_hps_emac0_tx_clk_in EXPORT_OF sys_hps.emac0_tx_clk_in
add_interface sys_hps_emac1 conduit end
set_interface_property sys_hps_emac1 EXPORT_OF sys_hps.emac1
add_interface sys_hps_emac1_md_clk clock source
set_interface_property sys_hps_emac1_md_clk EXPORT_OF sys_hps.emac1_md_clk
add_interface sys_hps_emac1_rx_clk_in clock sink
set_interface_property sys_hps_emac1_rx_clk_in EXPORT_OF sys_hps.emac1_rx_clk_in
add_interface sys_hps_emac1_tx_clk_in clock sink
set_interface_property sys_hps_emac1_tx_clk_in EXPORT_OF sys_hps.emac1_tx_clk_in

# internal connections
add_connection sys_clk.clk sys_hps.emac_ptp_ref_clock

