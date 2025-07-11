.. _corundum:

Corundum Network Stack
================================================================================

.. toctree::
   :hidden:

   Corundum Core <corundum_core/index>
   Corundum Ethernet Core <ethernet/index>

The :git-hdl:`Corundum <library/corundum>` framework repackages
`Corundum NIC <https://github.com/ucsdsysnet/corundum>`__ into 2 separate IP
cores. These cores are the :ref:`corundum_core`, which is common in all projects
that use the Corundum Network Stack and the :ref:`corundum_ethernet_core`, which
is specific to each FPGA board and encompasses the Ethernet physical layer and
other auxiliary structures such as SPI and I2C that are required by the Corundum
system.

Sub-modules
--------------------------------------------------------------------------------

* :ref:`corundum_core`
* :ref:`corundum_ethernet_core`

Software support
--------------------------------------------------------------------------------

* :git-linux:`Linux Driver <staging/corundum:drivers/net/mqnic/mqnic_main.c>`:
  Linux driver for the Corundum Network Stack.

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

* HDL IP cores at :git-hdl:`library/corundum`
