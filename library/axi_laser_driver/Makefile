####################################################################################
## Copyright (c) 2018 - 2023 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################

LIBRARY_NAME := axi_laser_driver

GENERIC_DEPS += ../common/up_clock_mon.v
GENERIC_DEPS += axi_laser_driver.v
GENERIC_DEPS += axi_laser_driver_regmap.v

XILINX_DEPS += ../xilinx/common/up_clock_mon_constr.xdc
XILINX_DEPS += axi_laser_driver_constr.xdc
XILINX_DEPS += axi_laser_driver_ip.tcl

XILINX_LIB_DEPS += axi_pulse_gen
XILINX_LIB_DEPS += util_cdc

INTEL_DEPS += ../axi_pulse_gen/axi_pulse_gen_constr.sdc
INTEL_DEPS += ../axi_pulse_gen/axi_pulse_gen_regmap.v
INTEL_DEPS += ../common/ad_rst.v
INTEL_DEPS += ../common/up_axi.v
INTEL_DEPS += ../common/util_pulse_gen.v
INTEL_DEPS += ../util_cdc/sync_bits.v
INTEL_DEPS += ../util_cdc/sync_event.v
INTEL_DEPS += axi_laser_driver_constr.sdc
INTEL_DEPS += axi_laser_driver_hw.tcl

include ../scripts/library.mk
