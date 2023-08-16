.. _spi_engine spi-bus-interface:

SPI Bus Interface
================================================================================

The SPI bus interface carries logical low-level SPI bus signals.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`master:library/spi_engine/interfaces/spi_master_rtl.xml`
     - Interface definition file

Signal Pins
--------------------------------------------------------------------------------

.. list-table::
   :widths: 10 15 65
   :header-rows: 1

   * - Name
     - Direction (Master)
     - Description
   * - ``sclk``
     - Output
     - SPI Clock.
   * - ``sdo``
     - Output
     - SPI SDO (MOSI) signal.
   * - ``sdo_t``
     - Output
     - ``sdo`` tri-state enable. If 1 the MOSI signal should be tristated and
       not be connected to ``sdo``
   * - ``sdi``
     - Input
     - SPI SDI (MISO) signal. Execution module supports max 8 individual
       ``sdi`` lines.
   * - ``cs``
     - Output
     - SPI chip-select signal.
   * - ``three_wire``
     - Output
     - If set to 1 the bus should operate in three-wire mode. In three-wire
       mode ``sdi`` is connected to MOSI instead of MISO.

IO configuration
--------------------------------------------------------------------------------

.. image:: spi_bus.svg
   :width: 30%
   :align: right

The SPI bus interface only carries a logical representation of the low-level SPI
bus signals. The top-level module in the FPGA design project is responsible for
translating the signal to physical SPI bus signals by instantiating and
connecting it to appropriate IO primitives.

The ``sclk`` and ``cs`` signals can typically be directly connected to a output
buffer. ``sdi`` should be connected to a mux, that depending on the setting of
the ``three_wire`` signal connects to a input buffer connected to the ``miso``
signal or to a input buffer connected to the ``mosi`` signal. The ``sdo`` signal
should be connected to a output tri-state buffer with the ``sdo_t`` signal
controlling the tri-state setting.

In some configurations three-wire support may not be required and ``sdi`` can
directly be connected to the input buffer for the ``miso`` signal. Similarly
when ``mosi`` tri-stating is not required the ``sdo`` signal can be directly
connected to the ``mosi`` signal leaving the ``sdo_t`` signal unconnected.
