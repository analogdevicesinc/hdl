
set_property ASYNC_REG TRUE \
  [get_cells -hier *sync_mode_d*]

set_false_path -to [get_cells -hier -filter {name =~ *sync_mode_d1*   && IS_SEQUENTIAL}]

