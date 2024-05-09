.. _spi_engine offload-control-interface:

SPI Engine Offload Control Interface
================================================================================

The SPI-Engine offload control interface is used to configure and control a
:ref:`spi_engine offload`.
It is used to activate/deactivate the core as well re-program the command and
SDO data RAM.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_engine/interfaces/spi_engine_offload_ctrl_rtl.xml`
     - Interface definition file

Signal Pins
--------------------------------------------------------------------------------

.. list-table::
   :widths: 10 10 70
   :header-rows: 1

   * - Name
     - Direction (Manager)
     - Description
   * - ``cmd_wr_en``
     - Output
     - If asserted cmd_wr_data is written to the command memory.
   * - ``cmd_wr_data``
     - Output
     - Data to write to the command memory.
   * - ``sdo_wr_en``
     - Output
     - If asserted sdo_wr_data is written to the SDO data memory.
   * - ``sdo_wr_data``
     - Output
     - Data to write to the SDO data memory.
   * - ``mem_reset``
     - Output
     - Reset the contents of both the command and SDO data memory.
   * - ``enable``
     - Output
     - If asserted the connected offload core will get enabled.
   * - ``enabled``
     - Input
     - If asserted the connected offload core is enabled.

Theory of Operation
--------------------------------------------------------------------------------

The SPI-Engine offload core typically implements to RAMs, one for the command
stream and one for the SDO data stream. If the ``mem_reset`` signal is asserted
the content of both memories is cleared. Asserting ``cmd_wr_en`` will write the
value of ``cmd_wr_data`` to the command memory and increase the write address by
one. The next time ``cmd_wr_en`` is asserted the next entry in the memory will
be written and so on. If ``cmd_wr_en`` is asserted more times than the size of
the command memory (without a reset in between) undefined behavior will occur.
``sdo_wr_en`` and ``sdo_wr_data`` behave analogously for the SDO data memory.

If the ``enable`` signal the is asserted the SPI-Engine offload core will be
active, this means it will listen to external trigger events and execute the
stored SPI transfer when the external trigger is asserted. If ``enable`` is not
asserted the core will no longer listen to trigger events and will not start new
transfers. But it might still be busy executing a SPI transfer that was started
previously. The ``enabled`` signal is used to indicate this and it will stay
asserted even after ``enable`` as been deasserted until the currently active SPI
transfer has been completed.

If either ``enable`` or ``enabled`` is asserted ``cmd_wr_en``, ``sdo_wr_en``, or
``memt_reset`` must not be asserted, otherwise undefined behavior can occur. In
other words as long as the SPI-Engine offload core is active the content of both
the command and SDO data memory must remain stable and be consistent.
