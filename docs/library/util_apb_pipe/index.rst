.. _util_apb_pipe:

Util APB Pipe
================================================================================

The :git-hdl:`Util APB Pipe <library/util_apb_pipe>` core is a registered APB
pipeline: ``NUM_OF_STAGES`` register stages between an APB slave and an APB
master port. Each stage registers the request and the response and adds wait
states to the transfer, so a long APB path (for example the PolarFire SoC
FIC3 APB to the cores of the fabric) can be cut for timing.

Features
--------------------------------------------------------------------------------

* APB3 slave and master ports, with ``PREADY`` and ``PSLVERR``
* Configurable number of register stages
* Supports Microchip devices

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/util_apb_pipe/util_apb_pipe.v`
     - The pipeline of ``NUM_OF_STAGES`` stages.
   * - :git-hdl:`library/util_apb_pipe/util_apb_pipe_stage.v`
     - One register stage.

Configuration Parameters
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Default
     - Description
   * - ``ADDRESS_WIDTH``
     - 32
     - Width of ``PADDR``.
   * - ``DATA_WIDTH``
     - 32
     - Width of ``PWDATA`` and ``PRDATA``.
   * - ``NUM_OF_STAGES``
     - 1
     - Number of register stages.

Interface
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - ``clk``, ``resetn``
     - Clock and active low reset of the stages (the APB clock).
   * - ``s_apb_*``
     - APB slave port, from the APB master (e.g. CoreAPB3).
   * - ``m_apb_*``
     - APB master port, to the APB slave.

The :ref:`fmcomms2` PolarFire SoC Video Kit project uses two of them, one
stage each: one right at the FIC3 APB of the MSS, which samples the APB
response on the falling edge of the APB clock, and one between the two
cascaded CoreAPB3.
