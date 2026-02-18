###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

adi_ip_instance -vlnv {latticesemi.com:sim_model:clk_rst_gen:1.0.0} \
    -meta_vlnv {latticesemi.com:sim_model:Clock_Reset_Generator:1.0.0} \
    -cfg_value {TB_CLK_PERIOD:8} \
    -ip_iname "clk_rst_gen_inst"
adi_ip_instance -vlnv {latticesemi.com:sim_model:uart:1.0.0} \
    -meta_vlnv {latticesemi.com:sim_model:UART_Model:1.0.0} \
    -cfg_value {CLK_MHZ:125} \
    -ip_iname "uart_inst"
adi_ip_instance -vlnv {analog.com:sim_model:sdo_sim:1.0} \
    -meta_vlnv {analog.com:sim_model:spi_sdo_sin_tb:1.0} \
    -cfg_value [subst  {
        WORD_LENGTH:$DATA_WIDTH,
        SAMPLE_COUNT:400,
        TRI_STATE_BETWEEN_FRAMES:1,
        SIGNED:0,
        SPI_MODE:3,
        SDO_LANES:$NUM_OF_SDI
    } ] \
    -ip_iname "sdo_sim_inst"

sbp_connect_net ${project_name}_v/uart_inst/clk \
    ${project_name}_v/clk_rst_gen_inst/tb_clk_o
sbp_connect_net -name ${project_name}_v/clk_rst_gen_inst_tb_clk_o_net \
    ${project_name}_v/dut_inst/clk_125
sbp_connect_net ${project_name}_v/clk_rst_gen_inst/tb_rst_o \
    ${project_name}_v/uart_inst/rstn \
    ${project_name}_v/dut_inst/rstn_i \
    ${project_name}_v/sdo_sim_inst/rstn
sbp_connect_net ${project_name}_v/dut_inst/rxd_i \
    ${project_name}_v/uart_inst/uart_txd
sbp_connect_net ${project_name}_v/dut_inst/txd_o \
    ${project_name}_v/uart_inst/uart_rxd

sbp_connect_net ${project_name}_v/dut_inst/spi_master0_cs \
    ${project_name}_v/sdo_sim_inst/cs_n
sbp_connect_net ${project_name}_v/dut_inst/spi_master0_sclk \
    ${project_name}_v/sdo_sim_inst/sclk
if {$NUM_OF_SDI > 1} {
    sbp_connect_net ${project_name}_v/sdo_sim_inst/sdo \
        ${project_name}_v/dut_inst/spi_master0_sdi
} else {
    sbp_connect_net ${project_name}_v/sdo_sim_inst/sdo0 \
        ${project_name}_v/dut_inst/spi_master0_sdi
}
