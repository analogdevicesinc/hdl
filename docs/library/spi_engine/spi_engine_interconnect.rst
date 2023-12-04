.. _spi_engine interconnect:

SPI Engine Interconnect Module
================================================================================

.. hdl-component-diagram::

The SPI Engine Interconnect module allows connecting multiple
:ref:`spi_engine control-interface` masters to a single
:ref:`spi_engine control-interface` slave.
This enables multiple command stream generators to connect to a single
:ref:`spi_engine execution` and consequential give them access to the same SPI bus.
The interconnect modules take care of properly arbitrating between the different
command streams.

Combining multiple command stream generators in a design and connecting them to
a single execution module allows for the creation of flexible and efficient
designs using standard components.

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
   * - NUM_OF_SDI
     - Number of SDI lines on the physical SPI interface.


Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - clk
     - A signals of the module are synchronous to this clock.
   * - resetn
     - Synchronous active-low reset.
       Resets the internal state of the module.
   * - s0_ctrl
     - :ref:`spi_engine control-interface` slave.
       Connects to the first control interface master.
   * - s1_ctrl
     - :ref:`spi_engine control-interface` slave.
       Connects to the second control interface master.
   * - m_ctrl
     - :ref:`spi_engine control-interface` master.
       Connects to the control interface slave.

Theory of Operation
--------------------------------------------------------------------------------

The SPI Engine Interconnect module has multiple
:ref:`spi_engine control-interface` slave ports and a single
:ref:`spi_engine control-interface` master port.
It can be used to connect multiple command stream generators to a single command
execution engine. Arbitration between the streams is done on a priority
basis, streams with a lower index have higher priority. This means if commands
are present on two streams arbitration will be granted to the one with the lower
index. Once arbitration has been granted the port it was granted to stays in
control until it sends a SYNC command. When the interconnect module sees a SYNC
command arbitration will be re-evaluated after the SYNC command has been
completed. This makes sure that once a SPI transaction consisting of multiple
commands has been started it is able to complete without being interrupted by a
higher priority stream.
