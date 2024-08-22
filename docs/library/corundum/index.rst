.. _corundum:

Corundum
================================================================================

.. hdl-component-diagram::

The :git-hdl:`Corundum <library/corundum>` IP core
repackages `Corundum NIC <https://github.com/corundum/corundum>`__ as an IP Core.

Features
--------------------------------------------------------------------------------

* AXI-based configuration
* Vivado compatible

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/corundum/corundum.v`
     - Verilog source for the Corundum top module.
   * - :git-hdl:`library/corundum/corundum_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

Building
--------------------------------------------------------------------------------

This project uses `Corundum NIC <https://github.com/corundum/corundum>`_
and it needs to be cloned alongside this repository.

.. code::

   hdl/../> git clone https://github.com/corundum/corundum.git
   hdl/../corundum/> git checkout ed4a26e2cbc0a429c45d5cd5ddf1177f86838914
   hdl/library/corundum> make &

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

* HDL IP core at :git-hdl:`library/corundum`
* HDL project at :git-hdl:`projects/ad_gmsl2eth_sl`
* :adi:`AD-GMSL2ETH-SL`
* :ref:`ad_gmsl2eth_sl`