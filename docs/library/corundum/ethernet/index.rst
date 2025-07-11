.. _corundum_ethernet_core:

Corundum Ethernet Core
================================================================================

.. toctree::
   :hidden:

   VCU118 <vcu118/index>

The :git-hdl:`Corundum Ethernet Core <library/corundum/ethernet_core>` is used
by the Corundum Network Stack. The Ethernet Core is specific to each FPGA board
and encompasses the Ethernet physical layer and other auxiliary structures such
as SPI and I2C that are required by the Corundum system. The configurations are
based on `Corundum NIC <https://github.com/ucsdsysnet/corundum>`__ reference
designs that were adapted to suit the ADI workflow.

Depending on the board for which the IP is built, different HDL component
diagrams will be available.

* :ref:`corundum_ethernet_core_vcu118`

Features
--------------------------------------------------------------------------------

* Supports 100G Ethernet-based systems that uses the CMAC core on the VCU118
  board

Files
--------------------------------------------------------------------------------

Depending on the board for which the IP is built, different source files will
be available.

Configuration Parameters
--------------------------------------------------------------------------------

Depending on the board for which the IP is built, different HDL parameters will
be available.

Interface
--------------------------------------------------------------------------------

Depending on the board for which the IP is built, different HDL interfaces and
ports will be available.

Building
--------------------------------------------------------------------------------

This IP uses `Corundum NIC <https://github.com/ucsdsysnet/corundum>`_
repository, which needs to be cloned alongside the HDL repository.

.. shell::

   ~/workspace
   $git clone https://github.com/ucsdsysnet/corundum.git
   $cd hdl/library/corundum/ethernet_core

An environment variable must be exported for this IP, so Vivado builds the
appropriate configuration.

.. shell::

   ~/workspace/hdl/library/corundum/ethernet_core
   $export BOARD=VCU118
   $make

.. attention::

   If the Ethernet Core has to be used in a project that is designed for a
   different board than the one the IP was originally built for, then the BOARD
   variable must be overwritten and the IP rebuilt!

.. hint::

   To check what board the IP was built for, check the content of the board.env
   file after the build.

.. shell::

   ~/workspace
   $cd hdl/library/corundum/ethernet_core
   $cat board.env

.. important::

   It is recommended to include the BOARD variable inside the project's Makefile
   as it will check if the IP is built with the specified variable, and if not,
   it will build/rebuild it.

.. shell::

   export BOARD := VCU118

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

* HDL IP core at :git-hdl:`library/corundum/ethernet`
