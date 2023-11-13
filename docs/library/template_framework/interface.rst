.. _template_framework interface:

Template Interface
================================================================================

The {interface name} is used to {brief description}.

The interface consists of {#} streams:

* The {stream name} stream which carries the {...}.

{brief description, handshaking info}

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_engine/interfaces/spi_engine_ctrl_rtl.xml`
     - Interface definition file

Signal Pins
--------------------------------------------------------------------------------

.. list-table::
   :widths: 10 10 10 70
   :header-rows: 1

   * - Width
     - Name
     - Direction (Master)
     - Description
   * -
     - ``cmd_ready``
     - Input
     - Ready signal of the CMD stream
   * -
     - ``cmd_valid``
     - Output
     - Valid signal of the CMD stream
   * - [15:0]
     - ``cmd_data``
     - Output
     - Data signal of the CMD stream
