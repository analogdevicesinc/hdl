.. _util_sigma_delta_spi:

Util Sigma Delta SPI
===============================================================================

.. hdl-component-diagram::

ADCs from the :adi:`ADI <>` Sigma-Delta converter family use a low-level
communication protocol that multiplexes the SPI bus MISO signal and the data
ready interrupt signal over the same physical wire (DOUT/RDY).

The :git-hdl:`Sigma-Delta SPI Util <library/util_sigma_delta_spi>` peripheral
can be used to de-multiplex these signals inside a FPGA.

Files
-------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/util_sigma_delta_spi/util_sigma_delta_spi.v`
     - Verilog source for the peripheral
   * - :git-hdl:`library/util_sigma_delta_spi/util_sigma_delta_spi_ip.tcl`
     - Tcl script to generate the Vivado IP Integrator project for the peripheral

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::
   :path: library/util_sigma_delta_spi

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::
   :path: library/util_sigma_delta_spi

Detailed Description
--------------------------------------------------------------------------------

The :git-hdl:`Sigma-Delta SPI Util <library/util_sigma_delta_spi>` peripheral
monitors the SPI bus that is connected to the ``s_spi`` interface for the
converter's data ready condition.

The ``m_spi`` interface is directly connected to the ``s_spi`` interface.
In a typical configuration, the ``s_spi`` interface is connected to a SPI
controller and the ``m_spi`` interface is connected to external SPI bus pins.

The ``data_ready`` signal is high-level active and will be asserted as long as
the data ready condition is detected.

For example, it can be connected to an interrupt controller to start an
interrupt service routine that will read the converted data sample from
the ADC, or it can be connected to a HDL block, like the
:ref:`SPI Engine Offload <spi_engine offload>` block that will generate a SPI
transaction to read the converted signal.

The data ready condition is only detected if the chip-select signal (which is
connected to the converter) has been asserted for **at least** ``IDLE_TIMEOUT``
clock cycles.

The timeout is used to avoid spurious signal detection and the ``IDLE_TIMEOUT``
parameter should be configured so that the period it takes to complete
``IDLE_TIMEOUT`` clock cycles with the ``clk`` clock, is larger than the
"CS falling edge to DOUT/RDY active time"
and "SCLK inactive edge to DOUT/RDY high/low"
as specified in the data sheet for the converter.

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/util_sigma_delta_spi`
