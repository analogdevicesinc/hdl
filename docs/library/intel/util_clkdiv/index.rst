.. _util_clkdiv_intel:

Util Clock Divider
================================================================================

The :git-hdl:`Util Clock Divider <library/intel/util_clkdiv>` core
divides the input clock by two and provides a reset for the divided clock
domain.

Features
--------------------------------------------------------------------------------

* Supports Intel Cyclone V devices
* Fixed divide-by-two output clock
* Reset output for the divided clock domain

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/intel/util_clkdiv/util_clkdiv.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`library/intel/util_clkdiv/util_clkdiv_hw.tcl`
     - Platform Designer component definition of the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - ``SIM_DEVICE``
     - Target device family. Only ``CYCLONE5`` (default) is supported.
   * - ``CLOCK_TYPE``
     - Clock network type.

The parameters are not exposed in the Platform Designer component, so their
default values are always used.

Interface
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - ``clk``
     - Input clock.
   * - ``reset``
     - Active-high reset input, associated with ``clk``.
   * - ``clk_out``
     - Output clock, with half the frequency of ``clk``.
   * - ``reset_out``
     - Active-high reset output, associated with ``clk_out``.

Detailed Description
--------------------------------------------------------------------------------

The :git-hdl:`util_clkdiv <library/intel/util_clkdiv/util_clkdiv.v>`
is a clock divider that generates a clock with half the frequency of the input
clock. It uses the Cyclone V clock enable primitive (``cyclonev_clkena``),
which lets the input clock through on every other clock cycle.

The ``reset_out`` signal is the ``reset`` input extended by one ``clk`` cycle,
so that it lasts for at least one ``clk_out`` cycle.

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/intel/util_clkdiv`
