.. _template_framework instruction-set:

Template Instruction Set Specification
================================================================================

The {instruction set} set is a {brief description}

Instructions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Transfer Instruction
--------------------------------------------------------------------------------

== == == == == == = = = = = = = = = =
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
== == == == == == = = = = = = = = = =
0  0  0  0  0  0  r w n n n n n n n n
== == == == == == = = = = = = = = = =

{description}

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - r
     - Read
     - If set to 1 data will be read {...}.
   * - w
     - Write
     - If set to 1 data will be taken from {...}.
   * - n
     - Length
     - n + 1 number of words that {...}.

Other Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

== == == == == == = = = = = = = = = =
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
== == == == == == = = = = = = = = = =
0  0  0  1  0  0  t t s s s s s s s s
== == == == == == = = = = = = = = = =

The {instruction name} instruction updates the {...}.

.. math::

   delay = t * \frac{div + 1}{f_{clk}}

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

Yet Another Instruction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

== == == == == == = = = = = = = = = =
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
== == == == == == = = = = = = = = = =
0  0  1  0  0  0  r r v v v v v v v v
== == == == == == = = = = = = = = = =

The {instruction name} instruction updates the {...}.

The configuration writes instruction updates a
:ref:`template_framework configuration-registers`
of the {module name} module with a new value.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - r
     - Register
     - Configuration register address.
       2'b00 = :ref:`template_framework register`
   * - v
     - Value
     - New value for the configuration register.

.. _template_framework configuration-registers:

Configuration Registers
--------------------------------------------------------------------------------

The {module name} module has a set of {#}-bit configuration registers which
can be used to dynamically modify the behavior of the module at runtime.

.. _template_framework register:

Template Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The {registe name} register configures {description}.

.. list-table::
   :widths: 10 15 75
   :header-rows: 1

   * - Bits
     - Name
     - Description
   * - [7:3]
     - reserved
     - Must always be 0.
   * - [2]
     - three_wire
     - Configures {...}.
