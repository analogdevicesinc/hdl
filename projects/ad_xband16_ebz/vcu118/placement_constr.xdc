###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# USER_SLR_ASSIGNMENT property documented in UG912.
# Putting each of these TX IPs in a single SLR, since otherwise the tools would have a
# tendency of splitting them across two SLRs (SLR1 and SLR2, respectively).
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */util_apollo_upack}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */apollo_tx_data_offload}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */tx_apollo_tpl_core}]
# Putting each JESD204 lane in a single SLR, where its transceiver is also located.
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[0].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[1].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[2].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[3].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[4].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[5].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[6].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[7].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[8].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[9].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[10].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[11].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[12].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[13].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[14].i_lane}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[15].i_lane}]

# Make sure that each i_all_buffer_ready_pipeline_stage circuit does not drive more than one output.
set_property FORCE_MAX_FANOUT 1 [get_nets -hierarchical *mode_64b66b.gen_lane[*].all_buffer_ready_n_d]