.. _spi_engine interconnect:

SPI Engine Interconnect Module
================================================================================

.. hdl-component-diagram::

The :git-hdl:`SPI Engine Interconnect <library/spi_engine/spi_engine_interconnect>`
allows connecting multiple :ref:`spi_engine control-interface` managers to a single
:ref:`spi_engine control-interface` subordinate.
This enables two command stream generators to connect to a single
:ref:`spi_engine execution` and consequentially give them access to the same SPI bus.
The interconnect module is responsible for proper arbitration between the command
streams.

Combining two command stream generators in a design and connecting them to a single
execution module allows the creation of an efficient and flexible design by using
standard components.

Files
--------------------------------------------------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_engine/spi_engine_interconnect/spi_engine_interconnect.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`library/spi_engine/spi_engine_interconnect/spi_engine_interconnect_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project for the
       peripheral.


Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - DATA_WIDTH
     - Data width of the parallel SDI/SDO data interfaces.
   * - NUM_OF_SDIO
     - Number of SDI/SDO lines on the physical SPI interface.


Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - clk
     - |
   * - resetn
     - | Synchronous active-low reset.
       | Resets the internal state of the module.
   * - s0_ctrl
     - | :ref:`spi_engine control-interface` subordinate.
       | Connects to the offload control interface manager.
   * - s1_ctrl
     - | :ref:`spi_engine control-interface` subordinate.
       | Connects to the fifo control interface manager.
   * - m_ctrl
     - | :ref:`spi_engine control-interface` manager.
       | Connects to the control interface subordinate.
   * - s_interconnect_ctrl
     - | m_interconnect_ctrl (:ref:`spi_engine offload`) subordinate.
       | Defines whether offload mode is active or not (active high).
   * - m_offload_active_ctrl
     - | Forwards the signals of the s_interconnect_ctrl interface.
       | Defines whether offload mode is active or not (active high).

Theory of Operation
--------------------------------------------------------------------------------

The SPI Engine Interconnect module has two :ref:`spi_engine control-interface`
subordinate ports and a single :ref:`spi_engine control-interface` manager
port. It can be used to connect two command stream generators to a single
command execution engine. Arbitration between streams is done based on the
``s_interconnect_ctrl`` interface, there is a copy of this interface to
``m_offload_active_ctrl`` to indicate whether the stream belongs to offload (s0) or
fifo mode (s1).