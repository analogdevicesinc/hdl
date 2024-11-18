.. _spi_engine instruction-format:

SPI Engine Instruction Set Specification
================================================================================

The SPI Engine instruction set is a simple 16-bit instruction set of which
13-bits are currently allocated (bits 15,11,10 are always 0).

Instructions
--------------------------------------------------------------------------------

Transfer Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

== == == == == == = = = = = = = = = =
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
== == == == == == = = = = = = = = = =
0  0  0  0  0  0  r w n n n n n n n n
== == == == == == = = = = = = = = = =

The transfer instructions perform a low-level SPI transfer. It will generate
SCLK transitions for the specified amount of cycles according to the SPI
configuration register. If the r bit is set the SDI pin will be sampled and
stored in the shift register at the end of each word the data is output on the
SDI_DATA stream. If the w bit is set the SDO pin will be updated with the data
received from the SDO_DATA stream. If the w bit is set the sdo_t signal will
also be set to 0 for the duration of the transfer. If the SDI_DATA stream is not
able to accept data or the SDO_DATA stream is not able to provide data the
execution is stalled at the end/start of the transfer until data is
accepted/becomes available.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - r
     - Read
     - If set to 1 data will be read from the SDI pin during and the read words
       will be available on the SDI_DATA interface.
   * - w
     - Write
     - If set to 1 data will be taken from the SDO_DATA interface and output on
       the SDO pin.
   * - n
     - Length
     - n + 1 number of words that will be transferred.


.. _spi_engine cs-instruction:

Chip-Select Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

== == == == == == = = = = = = = = = =
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
== == == == == == = = = = = = = = = =
0  0  0  1  0  0  t t s s s s s s s s
== == == == == == = = = = = = = = = =

The chip-select instruction updates the value chip-select output signal of the
SPI Engine execution module.

The physical outputs on each pin may be inverted relative to the command
according to the mask set by :ref:`spi_engine cs-invert-mask-instruction`. The
Invert Mask acts only on the output registers of the Chip-Select pins. Thus, if
the last 8 bits of the Chip-Select instruction are 0xFE, only CS[0] will be
active regardless of polarity. The polarity inversion process (if needed) is
transparent to the programmer.

Before and after the update is performed the execution module is paused for the
specified delay. The length of the delay depends on the module clock frequency,
the setting of the prescaler register and the parameter :math:`t` of the
instruction. This delay is inserted before and after the update of the
chip-select signal, so the total execution time of the chip-select instruction
is twice the delay, with an added fixed 2 clock cycles (fast clock, not
prescaled) before for the internal logic.

.. math::

   delay\_{before} = 2+ t * \frac{(div + 1)*2}{f_{clk}}

.. math::

   delay\_{after}  = t * \frac{(div + 1)*2}{f_{clk}}

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - t
     - Delay
     - Delay before and after setting the new configuration.
   * - s
     - Chip-select
     - The new chip-select configuration.

Configuration Write Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

== == == == == == = = = = = = = = = =
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
== == == == == == = = = = = = = = = =
0  0  1  0  0  0  r r v v v v v v v v
== == == == == == = = = = = = = = = =

The configuration writes instruction updates a
:ref:`spi_engine configuration-registers`
of the SPI Engine execution module with a new value.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - r
     - Register
     - Configuration register address.
       2'b00 = :ref:`spi_engine prescaler-configuration-register`
       2'b01 = :ref:`spi_engine spi-configuration-register`
       2'b10 = :ref:`spi_engine dynamic-transfer-length-register`.
   * - v
     - Value
     - New value for the configuration register.

Synchronize Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

== == == == == == = = = = = = = = = =
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
== == == == == == = = = = = = = = = =
0  0  1  1  0  0  0 0 n n n n n n n n
== == == == == == = = = = = = = = = =

The synchronize instruction generates a synchronization event on the SYNC output
stream. This can be used to monitor the progress of the command stream. The
synchronize instruction is also used by the :ref:`spi_engine interconnect`
module to identify the end of a transaction and re-start the arbitration
process.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - n
     - id
     - Value of the generated synchronization event.

Sleep Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

== == == == == == = = = = = = = = = =
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
== == == == == == = = = = = = = = = =
0  0  1  1  0  0  0 1 t t t t t t t t
== == == == == == = = = = = = = = = =

The sleep instruction stops the execution of the command stream for the
specified amount of time. The time is based on the external clock frequency the
configuration value of the prescaler register and the time parameter of the
instruction. A fixed delay of two clock cycles (fast, not affected by the prescaler)
is the minimum, needed by the internal logic.

.. math::

   sleep\_time = \frac{2+(t+1) * ((div + 1) * 2)}{f_{clk}}

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - t
     - Time
     - The amount of prescaler cycles to wait, minus one.

.. _spi_engine cs-invert-mask-instruction:

CS Invert Mask Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

== == == == == == = = = = = = = = = =
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
== == == == == == = = = = = = = = = =
0  1  0  0  r  r  r r m m m m m m m m
== == == == == == = = = = = = = = = =

The CS Invert Mask Instructions allows the user to select on a per-pin basis
whether the Chip Select will be active-low (default) or active-high (inverted).
Note that the Chip-Select instructions should remain the same because the value
of CS is inverted at the output register, and additional logic (e.g. reset
counters) occurs when the CS active state is asserted.

Since the physical values on the pins are inverted at the output, the current
Invert Mask does not affect the use of the :ref:`spi_engine cs-instruction`. As
an example, a Chip-Select Instruction with the 's' field equal to 0xFE will
always result in only CS[0] being active. For an Invert Mask of 0xFF, this would
result on only CS[0] being high. For an Invert Mask of 0x00, this would result
on only CS[0] being low. For an Invert Mask of 0x01, this would result on all CS
pins being high, but only CS[0] is active in this case (since it's the only one
currently treated as active-high).

This was introduced in
version 1.02.00 of the core.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - r
     - reserved
     - Reserved for future use. Must always be set to 0.
   * - m
     - Mask
     - Mask for selecting inverted CS channels. For the bits set to 1, the
       corresponding channel will be inverted at the output.

.. _spi_engine configuration-registers:

Configuration Registers
--------------------------------------------------------------------------------

The SPI Engine execution module has a set of 8-bit configuration registers which
can be used to dynamically modify the behavior of the module at runtime.

.. _spi_engine spi-configuration-register:

SPI Configuration Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The SPI configuration register configures various aspects of the low-level SPI
bus behavior.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - [7:4]
     - reserved
     - Must always be 0.
   * - [3]
     - sdo_idle_state
     - Configures the output of the SDO pin when CS is inactive or during
       read-only transfers.
   * - [2]
     - three_wire
     - Configures the output of the three_wire pin.
   * - [1]
     - CPOL
     - Configures the polarity of the SCLK signal. When 0, the idle state of
       the SCLK signal is low. When 1, the idle state of the SCLK signal is
       high.
   * - [0]
     - CPHA
     - Configures the phase of the SCLK signal. When 0, data is sampled on the
       leading edge and updated on the trailing edge. When 1, data is
       sampled on the trailing edge and updated on the leading edge.

.. _spi_engine prescaler-configuration-register:

Prescaler Configuration Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The prescaler configuration register configures the divider that is applied to
the module clock when generating the SCLK signal and other internal control
signals used by the sleep and chip-select commands.

===== ==== =======================
Bits  Name Description
===== ==== =======================
[7:0] div  Prescaler clock divider
===== ==== =======================

The frequency of the SCLK signal is derived from the module clock frequency
using the following formula:

.. math::

   f\_{sclk} = \frac{f_{clk}}{((div + 1) * 2)}


If no prescaler block is present div is 0.

.. _spi_engine dynamic-transfer-length-register:

Dynamic Transfer Length Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The dynamic transfer length register sets the length (in bits) of a transfer. By
default, the transfer length is equal to the DATA_WIDTH of the execution module.
If required the user can reduce this length by setting this register. A general
rule of thumb is to set the DATA_WIDTH parameter to the largest transfer length
supported by the target device.

===== ==== =======================
Bits  Name Description
===== ==== =======================
[7:0] div  Dynamic transfer length
===== ==== =======================
