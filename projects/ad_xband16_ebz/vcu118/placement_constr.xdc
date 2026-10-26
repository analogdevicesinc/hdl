###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# USER_SLR_ASSIGNMENT property documented in UG912.
# Putting each of these TX IPs in a single SLR, since otherwise the tools would have a
# tendency of splitting them across two SLRs (SLR1 and SLR2, respectively).
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */apollo_tx_data_offload}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */util_apollo_upack}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */tx_apollo_tpl_core}]
# Putting each JESD204 TX/RX lane in a single SLR, where its transceiver is also located.
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
# Putting each JESD204 TX/RX lane input pipeline stage in a single SLR, where its lane is also located.
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[0].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[1].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[2].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[3].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[4].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[5].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[6].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[7].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[8].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[9].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[10].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[11].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[12].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[13].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[14].i_input_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */mode_*.gen_lane[15].i_input_pipeline_stage}]
# Putting each JESD204 RX lane output pipeline stage in a single SLR, where its lane is also located.
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[0].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[1].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[2].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[3].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[4].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[5].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[6].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[7].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[8].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[9].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[10].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[11].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[12].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[13].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[14].i_output_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[15].i_output_pipeline_stage}]
# Constrain each JESD204 RX all_buffer_ready pipeline instance to be in the same SLR as its corresponding lane.
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[0].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[1].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[2].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[3].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[4].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[5].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[6].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[7].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[8].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[9].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[10].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[11].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[12].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[13].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[14].i_all_buffer_ready_pipeline_stage}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.gen_lane[15].i_all_buffer_ready_pipeline_stage}]

# Reduce fanout on high fanout nets which might also have a SLR crossing.
# RX side
set_property FORCE_MAX_FANOUT 1 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_*.gen_lane[*].i_lane/i_rx_header/system_rx_0_jes30_LUT6_5/O}]]
set_property FORCE_MAX_FANOUT 16 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_64b66b.i_jesd204_rx_ctrl_64b/status_err_cnt[*]_i_*/O}]]
set_property FORCE_MAX_FANOUT 6 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_*.gen_lane[*].i_lane/buffer_ready_n_reg*/Q}]]
set_property FORCE_MAX_FANOUT 8 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx_axi/inst/i_up_common/core_cfg_octets_per_multiframe_reg[*]*/Q}]]
set_property FORCE_MAX_FANOUT 30 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx_axi/inst/i_up_common/core_reset_dly2*/Q}]]
set_property FORCE_MAX_FANOUT 80 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx_axi/inst/i_up_common/core_cfg_disable_scrambler_reg*/Q}]]
set_property FORCE_MAX_FANOUT 16 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx_axi/inst/i_up_common/core_cfg_header_mode_reg[*]*/Q}]]
set_property FORCE_MAX_FANOUT 37 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/buffer_release_n_reg*/Q}]]
set_property FORCE_MAX_FANOUT 250 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_rx_jesd/rx/inst/mode_*.gen_lane[*].i_lane/i_elastic_buffer/mem_rd_data[*]_i*/O}]]
# Force max fanout for data_offload paths going to BRAM blocks to half of what it normally is, to reduce routing delays
set_property FORCE_MAX_FANOUT 4 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */apollo_rx_data_offload/storage_unit/inst/i_mem_data/m_ram_reg_bram*_i_*/O}]]

# TX side
set_property FORCE_MAX_FANOUT 15 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/dual_lmfc_mode.i_tx_gearbox/out_addr_reg[*]*/Q}]]
set_property FORCE_MAX_FANOUT 4 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_64b66b.tx_ready_64b_reg*/Q}]]
set_property FORCE_MAX_FANOUT 16 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/lmc_edge_d3_reg*/Q}]]
set_property FORCE_MAX_FANOUT 2 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/i_header_gen/sync_word[*]_i_*/O}]]
set_property FORCE_MAX_FANOUT 6 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx_axi/inst/i_up_common/core_cfg_lanes_disable[*]_i_*/O}]]
set_property FORCE_MAX_FANOUT 1 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/i_scrambler/state_reg[*]/Q}]]
set_property FORCE_MAX_FANOUT 1 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/dual_lmfc_mode.i_tx_gearbox/system_tx_0*/O}]]
set_property FORCE_MAX_FANOUT 1 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/dual_lmfc_mode.i_tx_gearbox/state[*]_i_*/O}]]
set_property FORCE_MAX_FANOUT 16 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/lmc_edge_d2_reg*/Q}]]
set_property FORCE_MAX_FANOUT 16 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/lmc_edge_d1_reg*/Q}]]
set_property FORCE_MAX_FANOUT 2 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/scrambled_data_reg[*]*/Q}]]
set_property FORCE_MAX_FANOUT 64 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx_axi/inst/i_up_common/core_cfg_disable_scrambler_reg*/Q}]]
set_property FORCE_MAX_FANOUT 100 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx_axi/inst/i_up_common/core_reset_dly2*/Q}]]
# Reduce max fanout for each dac_sync_int[] FF for better timing.
set_property FORCE_MAX_FANOUT 100 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */tx_apollo_tpl_core/*/i_core/dac_sync_int*[*]/Q}]]

# Remap to LUTs single CARRY cells that are not part of a carry chain.
set_property CARRY_REMAP 1 [get_cells -hier -filter {ref_name == CARRY8}]

# Try to prevent SLR crossings on paths starting from these pins
set_property USER_CROSSING_SLR 0 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_*.gen_lane[*].i_lane/cfg_lane_disable_int_reg*/Q}]]
set_property USER_CROSSING_SLR 0 [get_nets -of [get_pins -hierarchical -filter {NAME =~ */axi_apollo_tx_jesd/tx/inst/mode_64b66b.tx_ready_64b_reg*/Q}]]
