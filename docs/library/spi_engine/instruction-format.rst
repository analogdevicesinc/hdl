.. _spi_engine instruction-format:

SPI Engine Instruction Set Specification
================================================================================

The SPI Engine instruction set is a 16-bit instruction set of which 13-bits are
currently allocated (bits 15,11,10 are always 0).

Instructions
--------------------------------------------------------------------------------

Transfer Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - 15
     - 14
     - 13
     - 12
     - 11
     - 10
     - 9
     - 8
     - 7
     - 6
     - 5
     - 4
     - 3
     - 2
     - 1
     - 0
   * - rv
     - 0
     - 0
     - 0
     - rv
     - rv
     - r
     - w
     - n
     - n
     - n
     - n
     - n
     - n
     - n
     - n

The transfer instruction perform a low-level SPI transfer. It generates SCLK
transitions for the specified amount of cycles according to the SPI
configuration register. If the r bit is set, the SDI pin is sampled and stored
in the shift register up to the end of the word, and then is output in the
SDI_DATA stream. If the w bit is set, the SDO pin is updated with the data
received from the SDO_DATA stream. By setting w bit, the sdo_t pin is set to 0
during the transfer. If the SDI_DATA stream cannot accept any data or SDO_DATA
stream cannot provide any data, then the execution module is stalled until
there's no longer any backpressure condition.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - rv
     - Reserved
     - Reserved bit. Must always be set to 0.
   * - r
     - Read
     - If set to 1, data is read from the SDI pin and the read words are
       available on the SDI_DATA interface.
   * - w
     - Write
     - If set to 1, data is consumed from the SDO_DATA interface and output on
       the SDO pin.
   * - n
     - Length
     - n + 1 number of words to be transferred.


.. _spi_engine cs-instruction:

Chip-Select Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - 15
     - 14
     - 13
     - 12
     - 11
     - 10
     - 9
     - 8
     - 7
     - 6
     - 5
     - 4
     - 3
     - 2
     - 1
     - 0
   * - rv
     - 0
     - 0
     - 1
     - rv
     - rv
     - t
     - t
     - s
     - s
     - s
     - s
     - s
     - s
     - s
     - s

The chip-select instruction updates the value of the chip-select output signal
of the SPI Engine execution module.

The physical output value for every pin may differ from what is defined in this
instruction depending on the mask set in the
:ref:`spi_engine cs-invert-mask-instruction`, because this mask acts only on
the output registers of the Chip-Select pins. Thus, if the last 8 bits of the
Chip-Select instruction are 0xFE, only CS[0] is active regardless of polarity.
The polarity inversion process (if needed) is transparent to the programmer.

Before and after any update, the execution module is paused for the specified
delay. The length of the delay depends on the module clock frequency, the
value of the prescaler register, and the parameter :math:`t` of the
instruction. This delay is inserted before and after any update of the
chip-select signal which results in twice the delay value defined. Furthermore,
it is necessary to add 2 clock cycles for the internal logic (fast clock, not
prescaled).

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
   * - rv
     - Reserved
     - Reserved bit. Must always be set to 0.
   * - t
     - Delay
     - Delay before and after setting the new configuration.
   * - s
     - Chip-select
     - The new chip-select configuration.

Configuration Write Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - 15
     - 14
     - 13
     - 12
     - 11
     - 10
     - 9
     - 8
     - 7
     - 6
     - 5
     - 4
     - 3
     - 2
     - 1
     - 0
   * - rv
     - 0
     - 1
     - 0
     - rv
     - rv
     - rg
     - rg
     - v
     - v
     - v
     - v
     - v
     - v
     - v
     - v

The configuration write instruction updates the
:ref:`spi_engine configuration-registers` of the SPI Engine execution module
with a new value.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - rv
     - Reserved
     - Reserved bit. Must always be set to 0.
   * - rg
     - Register
     - Configuration register address:
      
       - 2'b00 = :ref:`spi_engine prescaler-configuration-register`.
       - 2'b01 = :ref:`spi_engine spi-configuration-register`.
       - 2'b10 = :ref:`spi_engine dynamic-transfer-length-register`.
       - 2'b11 = :ref:`spi_engine spi-lane-mask-register`.
   * - v
     - Value
     - New value for the configuration register.

Synchronize Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - 15
     - 14
     - 13
     - 12
     - 11
     - 10
     - 9
     - 8
     - 7
     - 6
     - 5
     - 4
     - 3
     - 2
     - 1
     - 0
   * - rv
     - 0
     - 1
     - 1
     - rv
     - rv
     - 0
     - 0
     - v
     - v
     - v
     - v
     - v
     - v
     - v
     - v

The synchronize instruction generates a synchronization event on the SYNC
output stream. This can be used to monitor the progress of the command stream.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - rv
     - Reserved
     - Reserved bit. Must always be set to 0.
   * - v
     - id
     - Value of the generated synchronization event.

Sleep Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - 15
     - 14
     - 13
     - 12
     - 11
     - 10
     - 9
     - 8
     - 7
     - 6
     - 5
     - 4
     - 3
     - 2
     - 1
     - 0
   * - rv
     - 0
     - 1
     - 1
     - rv
     - rv
     - 0
     - 1
     - t
     - t
     - t
     - t
     - t
     - t
     - t
     - t

The sleep instruction stops the execution of the command stream for the
specified amount of time. The sleep time relies on the external clock
frequency, the configuration value of the prescaler register, and the time
parameter of the instruction. Also, a 2 clock-cycle delay is required for
internal logic (fast clock, not prescaled).

.. math::

   sleep\_time = \frac{2+(t+1) * ((div + 1) * 2)}{f_{clk}}

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - rv
     - Reserved
     - Reserved bit. Must always be set to 0.
   * - t
     - Time
     - The amount of prescaler cycles to wait minus one.

.. _spi_engine cs-invert-mask-instruction:

CS Invert Mask Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - 15
     - 14
     - 13
     - 12
     - 11
     - 10
     - 9
     - 8
     - 7
     - 6
     - 5
     - 4
     - 3
     - 2
     - 1
     - 0
   * - rv
     - 1
     - 0
     - 0
     - rv
     - rv
     - rv
     - rv
     - m
     - m
     - m
     - m
     - m
     - m
     - m
     - m

The CS Invert Mask Instruction allows the user to select on a per-pin basis
whether the Chip Select will be active-low (default) or active-high (inverted).

.. note::
  Chip-Select instruction must remain the same since the value of CS is inverted at
  the output register. So, current Invert Mask does not affect the use of the
  :ref:`spi_engine cs-instruction`. Additional logic (e.g. reset counters)
  occurs when the CS active state is asserted.

For example, a Chip-Select Instruction with the 's' field equal to 0xFE will
always result in only CS[0] being active. For an Invert Mask of 0xFF, this would
result on only CS[0] being high. For an Invert Mask of 0x00, this would result
on only CS[0] being low. For an Invert Mask of 0x01, this would result on all CS
pins being high, but only CS[0] is active in this case (since it's the only one
currently treated as active-high).

**This was introduced in version 1.02.00 of the core.**

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - rv
     - reserved
     - Reserved for future use. Must always be set to 0.
   * - m
     - Mask
     - Mask for selecting inverted CS channels. For the bits set to 1, the
       corresponding channel will be inverted at the output.

.. _spi_engine configuration-registers:

Configuration Registers
--------------------------------------------------------------------------------

The SPI Engine execution module has a set of 8-bit configuration registers
which can be used to dynamically modify the behavior of the module at runtime.

.. _spi_engine spi-configuration-register:

SPI Configuration Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The SPI configuration register configures several aspects of the low-level SPI
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
     - Configures the polarity of the SCLK signal:
      
       - When 0, the idle state of the SCLK signal is low.
       - When 1, the idle state of the SCLK signal is high.
   * - [0]
     - CPHA
     - Configures the phase of the SCLK signal:
      
       - When 0, data is sampled on the leading edge and updated on the
         trailing edge.
       - When 1, data is sampled on the trailing edge and updated on the
         leading edge.


.. _spi_engine spi-lane-mask-register:

SPI Lane Mask Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This register configures the mask that defines which lanes are active
(active-high). The user must define a mask that contains up to ``NUM_OF_SDI``
lanes (the number of activated lanes cannot be bigger than the numer of lanes).
For now, it is possible to have up to 8 lanes due to the instruction size.

.. list-table::
   :widths: 10 15 50
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - [7:0]
     - Lane mask
     - Only bits set to 1 have their respective lane active.

.. _spi_engine prescaler-configuration-register:

Prescaler Configuration Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The prescaler configuration register defines the divider that is applied to
the module clock when generating the SCLK signal and other internal control
signals used by the sleep and chip-select instructions.

.. list-table::
   :widths: 10 15 30
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - [7:0]
     - Div
     - Prescaler clock divider. The default value of div is 0.

The frequency of the SCLK signal is derived from the module clock frequency
using the following formula:

.. math::

   f\_{sclk} = \frac{f_{clk}}{((div + 1) * 2)}

.. _spi_engine dynamic-transfer-length-register:

Dynamic Transfer Length Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The dynamic transfer length register sets the length (in bits) of a transfer. By
default, the transfer length is equal to the DATA_WIDTH of the execution module.
If required, the user can reduce this length by setting this register. A
general rule of thumb is to set the DATA_WIDTH parameter to be the largest
transfer length supported by the target device.

.. list-table::
   :widths: 10 15 30
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - [7:0]
     - Div
     - Dynamic transfer length.
