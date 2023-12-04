.. _template_framework module:

Template Module
================================================================================

.. hdl-component-diagram::
   :path: library/spi_engine/spi_engine_execution

The {module name} is responsible for {brief description}.

Files
-------------------------------------------------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_engine/spi_engine_execution/spi_engine_execution.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`library/spi_engine/spi_engine_execution/spi_engine_execution_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project for the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::
   :path: library/spi_engine/spi_engine_interconnect

   * - DATA_WIDTH
     - Data width of the parallel SDI/SDO data interfaces.

Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::
   :path: library/spi_engine/spi_engine_interconnect

Theory of Operation
--------------------------------------------------------------------------------

The {module name}  module implements {brief description}.

.. image:: ../spi_engine/spi_engine.svg
