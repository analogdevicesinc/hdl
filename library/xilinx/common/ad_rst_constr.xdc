# the "-quiet" option is added for the axi_spi_engine ip where the ad_rst.v 
# module is not always inferred and this causes critical warnings

set_property -quiet ASYNC_REG TRUE [get_cells -hierarchical -filter {name =~ *rst_async_d*_reg}]
set_property -quiet ASYNC_REG TRUE [get_cells -hierarchical -filter {name =~ *rst_sync_reg}]

set_false_path -quiet -to [get_pins -hierarchical *rst_sync_reg/PRE] 
set_false_path -quiet -to [get_pins -hierarchical *rst_async_d1_reg/PRE]
set_false_path -quiet -to [get_pins -hierarchical *rst_async_d2_reg/PRE]
