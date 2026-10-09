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
set_property FORCE_MAX_FANOUT 1 [get_nets -hierarchical -filter {NAME =~ *mode_64b66b.gen_lane[*].all_buffer_ready_n_d}]

# Reduce max fanout for each dac_sync_int[] FF for better timing.
set_property FORCE_MAX_FANOUT 100 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */tx_apollo_tpl_core/*/i_core/dac_sync_int*[*]/Q}]]

# Force max fanout for data_offload paths going to BRAM blocks to half of what it normally is, to reduce routing delays
set_property FORCE_MAX_FANOUT 14 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */apollo_tx_data_offload/storage_unit/inst/i_mem_data/m_ram_reg_bram*_i_*/O}]]
set_property FORCE_MAX_FANOUT 4 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */apollo_rx_data_offload/storage_unit/inst/i_mem_data/m_ram_reg_bram*_i_*/O}]]

# Constrain all_buffer_ready pipeline stage to be in SLR1, same as most of the logic preceding it.
# Thus, the paths upstream from this register would have just one SLR crossing (SLR0 -> SLR1).
# The paths downstream from this register have at most one SLR crossing anyway, since the downstream
# logic is entirely in one lane per pipeline replica (thus entirely in SLR0 or entirely in SLR1).
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[*].i_all_buffer_ready_pipeline_stage}]

# Reduce fanout on high fanout nets which also have a SLR crossing.
# RX side
set_property FORCE_MAX_FANOUT 1 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_*.gen_lane[*].i_lane/i_rx_header/system_rx_0_jes30_LUT6_5/O}]]
set_property FORCE_MAX_FANOUT 16 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_*.i_jesd204_rx_ctrl_64b/status_err_cnt[*]_i_*/O}]]

# TX side
set_property FORCE_MAX_FANOUT 35 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/dual_lmfc_mode.i_tx_gearbox/out_addr_reg[*]*/Q}]]
set_property FORCE_MAX_FANOUT 19 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.tx_ready_64b_reg*/Q}]]
set_property FORCE_MAX_FANOUT 16 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/lmc_edge_d3_reg*/Q}]]
set_property FORCE_MAX_FANOUT 2 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/i_header_gen/sync_word[*]_i_*/O}]]
set_property FORCE_MAX_FANOUT 6 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx_axi/inst/i_up_common/core_cfg_lanes_disable[*]_i_*/O}]]
set_property FORCE_MAX_FANOUT 2 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/dual_lmfc_mode.i_tx_gearbox/mem_rd_data_reg[*]/Q}]]
set_property FORCE_MAX_FANOUT 2 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/i_scrambler/state_reg[*]/Q}]]
