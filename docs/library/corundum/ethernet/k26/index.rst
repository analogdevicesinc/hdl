.. _corundum_ethernet_core_k26:

Corundum Ethernet Core for K26
================================================================================

.. hdl-component-diagram::

The :git-hdl:`Corundum Ethernet Core <library/corundum/corundum_ethernet_core_k26>`
is used by the Corundum Network Stack. This Ethernet Core is specific to the K26
FPGA board and encompasses the Ethernet physical layer and other auxiliary
structures such as SPI and I2C that are required by the Corundum system. The
configurations are based on
`Corundum NIC <https://github.com/ucsdsysnet/corundum>`__ reference designs that
were adapted to suit the ADI workflow.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/corundum/ethernet_core/ethernet_core_k26.v`
     - Verilog source for the Ethernet Core top module for the K26-based
       AD-GMSL2ETH-SL evaluation kit.
   * - :git-hdl:`library/corundum/ethernet_core/ethernet_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/corundum/ethernet_core`
