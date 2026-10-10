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

# Must follow adi_ip_properties: it drops every bus interface and infers s_axi
# alone, so the MSI master is inferred after it. PCIE_TYPE == 0 hides it below,
# but the interface is packaged either way.

adi_ip_infer_mm_interfaces axi_pcie_intc

set cc [ipx::current_core]

set_property description \
  "Gates level-sensitive interrupt sources onto MSI/MSI-X vectors of a PCIe \
endpoint: usr_irq_req per the PG195 contract on a Xilinx endpoint, or the MSI \
write issued by the core itself on the ZynqMP PS PCIe controller, which has no \
usr_irq_req equivalent." $cc

# The inferred space tracks M_AXI_ADDR_WIDTH; adding one here would pin it to
# the 4 KB / 32-bit default instead.
set_property master_address_space_ref m_axi \
  [ipx::get_bus_interfaces m_axi -of_objects $cc]

# Not adi_add_bus_clock: s_axi_aclk already is one and the master shares it.
ipx::associate_bus_interfaces -busif m_axi -clock s_axi_aclk $cc

# The inference leaves the aximm defaults, narrow bursts and 256 beats. The RTL
# emits one full-width 32-bit beat per message. 64 rather than 1 to match
# axi_dmac's masters, so a shared bridge declares one value for the whole set.

foreach {name value} {SUPPORTS_NARROW_BURST 0 MAX_BURST_LENGTH 64} {
  set intf [ipx::get_bus_interfaces m_axi -of_objects $cc]
  set p [ipx::get_bus_parameters $name -of_objects $intf]
  if {$p == ""} {
    set p [ipx::add_bus_parameter $name $intf]
  }
  set_property value $value $p
}

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
[ipx::get_user_parameters NUM_SOURCES -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "1" \
 ] \
[ipx::get_user_parameters PCIE_TYPE -of_objects $cc]

# Floor of 12: an aperture smaller than a page cannot hold a mapped doorbell.

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "12" \
  "value_validation_range_maximum" "64" \
 ] \
[ipx::get_user_parameters M_AXI_ADDR_WIDTH -of_objects $cc]

# Mutually exclusive, so show only the one in use: the PG195 handshake at
# PCIE_TYPE == 0, the write master at 1.

foreach p [list usr_irq_req usr_irq_ack] {
  set_property enablement_dependency \
    "spirit:decode(id('MODELPARAM_VALUE.PCIE_TYPE')) = 0" \
    [ipx::get_ports $p -of_objects $cc]
}

set_property enablement_dependency \
  "spirit:decode(id('MODELPARAM_VALUE.PCIE_TYPE')) = 1" \
  [ipx::get_bus_interfaces m_axi -of_objects $cc]

# An unconnected source bit ties low rather than float. A hole is still routed,
# though, so size NUM_SOURCES to the sources that exist.
#
# usr_irq_ack is excluded: it is one of the two conditions that release a vector,
# so a design that leaves it unconnected wedges every vector after its first
# interrupt. With no driver value it has to be connected or Vivado says so.

set_property driver_value 0 [ipx::get_ports \
  -filter "direction==in && name!=usr_irq_ack" -of_objects $cc]

ipx::create_xgui_files $cc
ipx::save_core $cc
