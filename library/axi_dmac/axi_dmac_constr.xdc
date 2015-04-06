
set_false_path -from [get_cells *in_count_gray* -hierarchical -filter {NAME =~ *i_request_arb* && PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *out_count_gray_m1* -hierarchical -filter {NAME =~ *i_request_arb* && PRIMITIVE_SUBGROUP == flop}]

set_false_path -to [get_cells *out_m1* -hierarchical -filter {NAME =~ *i_request_arb* && PRIMITIVE_SUBGROUP == flop}]


