####################################################################################
####################################################################################
## Copyright 2018(c) Analog Devices, Inc.
####################################################################################
####################################################################################

# All test-bench dependencies except test programs
SV_DEPS += ../common/sv/utils.svh
SV_DEPS += ../common/sv/logger_pkg.sv
SV_DEPS += ../common/sv/reg_accessor.sv
SV_DEPS += ../common/sv/m_axis_sequencer.sv
SV_DEPS += ../common/sv/s_axis_sequencer.sv
SV_DEPS += ../common/sv/m_axi_sequencer.sv
SV_DEPS += ../common/sv/s_axi_sequencer.sv
SV_DEPS += ../common/sv/dmac_api.sv
SV_DEPS += ../common/sv/adi_regmap_pkg.sv
SV_DEPS += ../common/sv/adi_regmap_dmac_pkg.sv
SV_DEPS += ../common/sv/dma_trans.sv
SV_DEPS += ../common/sv/axi_dmac_pkg.sv
SV_DEPS += environment.sv
#SV_DEPS += scoreboard.sv
SV_DEPS += system_tb.sv

ENV_DEPS += cfgs/common_cfg.tcl
ENV_DEPS += system_project.tcl
ENV_DEPS += system_bd.tcl
ENV_DEPS +=../scripts/adi_sim.tcl
ENV_DEPS +=../scripts/run_sim.tcl

#LIB_DEPS := axi_dmac io_vip

LIB_DEPS += jesd204/ad_ip_jesd204_tpl_dac
LIB_DEPS += jesd204/axi_jesd204_tx
LIB_DEPS += jesd204/jesd204_tx
LIB_DEPS += jesd204/ad_ip_jesd204_tpl_adc
LIB_DEPS += jesd204/axi_jesd204_rx
LIB_DEPS += jesd204/jesd204_rx
LIB_DEPS += xilinx/axi_adxcvr
LIB_DEPS += xilinx/util_adxcvr


# default test program
TP := test_program

# config files should have the following format
#  cfg_<param1>_<param2>.tcl
CFG_FILES := $(notdir $(wildcard cfgs/cfg*.tcl))
#$(warning $(CFG_FILES))

# List of tests and configuration combinations that has to be run
# Format is:  <configuration>:<test name>
TESTS := $(foreach cfg, $(basename $(CFG_FILES)), $(cfg):$(TP))
#TESTS += cfg1_mm2mm_default:directed_test
#TESTS += cfg1:test_program
#TESTS += cfg2_fsync:test_program
#TESTS += cfg2_fsync:test_frame_delay

include ../scripts/project-sim.mk

# usage :
#
# run specific test on a specific configuration in gui mode
# 	make CFG=cfg2_fsync TST=test_frame_delay MODE=gui
#
# run all test from a configuration
# 	make cfg1_mm2mm_default



####################################################################################
####################################################################################
