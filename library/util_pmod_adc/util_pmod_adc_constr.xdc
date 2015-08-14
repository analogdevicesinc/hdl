create_generated_clock -name adc_spi_clk -source [get_ports clk] -divide_by 16 [get_pins -hier *adc_spi_clk_reg/Q]
