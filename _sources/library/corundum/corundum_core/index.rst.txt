.. _corundum_core:

Corundum Core
================================================================================

.. hdl-component-diagram::

The :git-hdl:`Corundum Core <library/corundum/corundum_core>` is common in all
projects and is used by the Corundum Network Stack. It repackages part of the
`Corundum NIC <https://github.com/ucsdsysnet/corundum>`__ as an IP Core to be
used with the ADI workflow.

Features
--------------------------------------------------------------------------------

* Supports ARM and Microblaze processors

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/corundum/corundum_core/corundum.v`
     - Verilog source for the Corundum Core top module.
   * - :git-hdl:`library/corundum/corundum_core/corundum_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project.
   * - :git-hdl:`library/corundum/corundum_core/mqnic_app_block.v`
     - Verilog source for the Application Core that is found inside the Corundum
       core.
   * - :git-hdl:`library/corundum/corundum_core/mqnic_app_custom_params.vh`
     - Verilog header file used to parameterize the Application Core.
   * - :git-hdl:`library/corundum/corundum_core/mqnic_app_custom_ports.vh`
     - Verilog header file used to create the ports and interfaces for the
       Application Core.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

Building
--------------------------------------------------------------------------------

This IP uses `Corundum NIC <https://github.com/ucsdsysnet/corundum>`_
repository, which needs to be cloned alongside the HDL repository.
Do a git checkout to the latest tested version (commit - 37f2607).
When the 10G-based implementation (e.g., in case of K26) is used,
apply the indicated patch.

.. shell::

   ~/workspace
   $git clone https://github.com/ucsdsysnet/corundum.git
   $cd corundum
   $git checkout 37f2607
   $cd hdl/library/corundum/corundum_core
   $make

.. admonition:: Publications

   The following papers pertain to the Corundum source code:

   -  J- A. Forencich, A. C. Snoeren, G. Porter, G. Papen, Corundum: An Open-Source 100-Gbps NIC, in FCCM'20.
      (`FCCM Paper`_, `FCCM Presentation`_)
   -  J- A. Forencich, System-Level Considerations for Optical Switching in Data Center Networks. (`Thesis`_)

.. _FCCM Paper: https://www.cse.ucsd.edu/~snoeren/papers/corundum-fccm20.pdf
.. _FCCM Presentation: https://www.fccm.org/past/2020/forums/topic/corundum-an-open-source-100-gbps-nic/
.. _Thesis: https://escholarship.org/uc/item/3mc9070t

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/corundum/corundum_core`
