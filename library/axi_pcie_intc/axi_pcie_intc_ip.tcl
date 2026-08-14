###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_pcie_intc
adi_ip_files axi_pcie_intc [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "axi_pcie_intc.v"]

adi_ip_properties axi_pcie_intc

set cc [ipx::current_core]

set_property description \
  "Holds usr_irq_req per the PG195 contract so level-sensitive interrupt \
sources can drive MSI/MSI-X vectors on a Xilinx PCIe endpoint." $cc

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
[ipx::get_user_parameters NUM_VECTORS -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "32" \
 ] \
[ipx::get_user_parameters SRC_PER_VEC -of_objects $cc]

# One input port per vector; hide the ones this configuration does not use.
# ipx::get_ports takes a glob, so "intr_1" with no wildcard matches intr_1
# alone -- not intr_10..intr_15.

for {set v 0} {$v < 16} {incr v} {
  set_property enablement_dependency \
    "spirit:decode(id('MODELPARAM_VALUE.NUM_VECTORS')) > $v" \
    [ipx::get_ports intr_$v -of_objects $cc]
}

# usr_irq_ack only feeds the DELIVERED diagnostic, so leaving it unconnected is
# legitimate; a disabled or unconnected source port ties low rather than float,
# which is what lets a hole in a pinned layout need no tie-off cell.

set_property driver_value 0 [ipx::get_ports -filter "direction==in" \
  -of_objects $cc]

ipx::save_core $cc
