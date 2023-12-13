.. _hdl_coding_guideline:

ADI HDL coding guideline
===============================================================================

1. Introduction
-------------------------------------------------------------------------------

This document contains coding and documentation guidelines which must be
followed by all HDL projects. The purpose of this document is to
establish a set of rules that specify the layout, naming conventions and
some general coding practices for the HDL modules implementation.
Specific HDL coding practices meant to obtain maximum performance from a
FPGA design are described by external documents such as
`[1] <http://www.xilinx.com/support/documentation/white_papers/wp231.pdf>`__
and
`[2] <http://www.asic-world.com/code/verilog_tutorial/peter_chambers_10_commandments.pdf>`__
and are not included in this document.

There are two types of rules: *should* and *must* rules
 * *Should* rules are advisory rules. They suggest the recommended way of doing things.
 * **Must** rules are mandatory requirements.

The coding rules are intended to be applied to HDL modules written using
VHDL or Verilog.

When an external IP is used, the naming conventions practiced by the IP
*should* be kept, even if they do not match the rules specified in this
document.

2. Coding style
-------------------------------------------------------------------------------

A. Layout
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**A1**

Spaces **must** be used instead of tabs.

This allows the code to be properly visualized by any editor. **Do not**
leave spaces at the end of a line. The following editor settings **must**
be used: *Tab Size*: 2, *Indent Size*: 2.

**A2**

One white space **must** be inserted around operators, such as
=, ==, &&, \|\|, &, \|, ^, etc.

.. _example-a2:

Incorrect:

.. code-block::

   if((my_signal1==1'b0)&&(my_bus[3:0]==4'd5))

Correct:

.. code-block::

   if ((my_signal == 1'b0) && (my_bus[3:0] == 4'd5))

**A3**

The *always* block *should* have a space before \*\*@\*\* symbol.

.. _example-a3:

Incorrect:

.. code-block::

   always@(posedge clk) begin
     ...
   end

Correct:

.. code-block::

   always @(posedge clk) begin
     ...
   end

**A4**

The Verilog ``begin``/``end`` block **must** always be used,
even if there is only one statement. This makes adding lines of code
much easier and with fewer errors.

**A5**

Indentation levels **must** be used to show code nesting. Blank
lines may be used as desired to improve code readability, but *not* in
all cases.

.. _example-a5:

Incorrect:

.. code-block::
   :linenos:

   if (my_signal == 1'b0) begin
     if (my_bus[3:0]==4'd5) begin
     statement1;
     statement2;
     end
   statement3;
   statement4;
   end
   else
   statement5;

Correct:

.. code-block::
   :linenos:
   :emphasize-lines: 2-4,7

   if (my_signal == 1'b0) begin
     if (my_bus[3:0] == 4'd5) begin
       statement1;
       statement2;
     end
     statement3;
     statement4;
   end else begin
     statement5;
   end

**A6**

In a ``case`` definition, indentation levels **must** be used to
offset the statements that are encapsulated, but the use of blank lines
can be used or omitted to best show the statement groupings (if really
necessary). ``end`` should be indented as in the correct example.

.. _example-a6:

Incorrect:

.. code-block::
   :linenos:

   case ( my_bus[3:0] )
     4'b0000 : my_signal1 = TRUE;
     4'b0001 : my_signal1 = FALSE;
     4'b0010 :
     begin
     my_signal1 = TRUE;
     my_signal2 = FALSE;
     end
     4'b0100 : my_signal2 = FALSE;
     default : my_signal1 = TRUE;
   endcase

Correct:

.. code-block::
   :linenos:
   :emphasize-lines: 2-4

   case (my_bus[3:0])
     4'b0000: begin
       my_signal1 = TRUE;
       end
     4'b0001: begin
       my_signal1 = FALSE;
       end
     4'b0010: begin
       my_signal1 = TRUE;
       my_signal2 = FALSE;
       end
     4'b0100: begin
       my_signal2 = FALSE;
       end
     default: begin
       my_signal1 = TRUE;
       end
   endcase

**A7**

Alignment **should** be used in declarations, assignments,
multi-line statements, and end of line comments. The code **must** be
written in a tabular format.

.. _example-a7:

Incorrect:

.. code-block::
   :linenos:

   reg[3:0] my_signal1; // description
   reg[31:0] my_decoded_signal1; // description
   reg[4:0] my_signal2, my_signal3; // description
   wire[2:0] my_select; // description

Correct:

.. code-block::
   :linenos:

   reg  [ 3:0]  my_signal1;         // description
   reg  [31:0]  my_decoded_signal1; // description
   reg  [ 4:0]  my_signal2;         // description
   reg          my_signal3;         // description

   wire [ 2:0]  my_select;          // description

**A8**

Parentheses **must** be used around all boolean statements and
in complex equations, in order to force the order of operations and
avoid confusion. Complex boolean expressions *should* be expressed as
multi-line aligned statements.

.. _example-a8:

Incorrect:

.. code-block::
   :linenos:

   if ((my_signal1 && your_signal1) || (my_signal2 && your_signal2) || (my_signal3 && your_signal3)) begin
     my_signal1 = TRUE;
     my_delayed_signal1 = !your_signal;
   end

Correct:

.. code-block::
   :linenos:
   :emphasize-lines: 1-3

   if ((my_signal1 && your_signal1) ||
       (my_signal2 && your_signal2) ||
       (my_signal3 && your_signal3)) begin
     my_signal1 = TRUE;
     my_delayed_signal1 = !your_signal;
   end

**A9**

A line **must** not contain more than one statement. **Do not**
concatenate multiple statements on the same line.

.. _example-a9:

Incorrect:

.. code-block::

   upper_en = (p5type && xadr1[0]); lower_en = (p5type && !xadr1[0]);

Correct:

.. code-block::

   upper_en = (p5type && xadr1[0]);
   lower_en = (p5type && !xadr1[0]);

**A10**

In module instances:

**A10.1**

**All** parameters and ports, **must** be written on a
separate line, even if there are few of them or their names are short.

.. _example-a10.1:

Incorrect:

.. code-block::

   my_module #(.PARAMETER1 (PARAMETER1)) i_my_module (.clk (clk));

Correct:

.. code-block::
   :linenos:

   my_module #(
     .PARAMETER1 (PARAMETER1)
   ) i_my_module (
     .clk (clk));

**A10.2**

When instantiating a module, the label of the module instance
**must** be on a separate line, with the closing parenthesis of the
parameters list (if that's the case) and the opening parenthesis of the
ports list. The closing parenthesis of the ports list must be right next
to the last parenthesis of the last port.

.. _example-a10.2:

.. code-block::
   :linenos:
   :emphasize-lines: 4

   my_module #(
     .PARAMETER1 (PARAMETER1),
     .PARAMETER2 (PARAMETER2)
   ) i_my_module (
     .clk (clk),
     .rst (rst),
     .data_in (data_in),
     .en (en),
     .response_out (response_out));

**A10.3**

Commented parts of code **must** not be added to the main
branch (i.e if, case, module instances, etc).

**A11**

In module declarations:

**A11.1**

Verilog modules **must** use Verilog-2001 style parameter
declarations. This increases legibility and consistency.

.. _example-a11.1:

.. code-block::
   :linenos:
   :emphasize-lines: 1-4,19,20

   module my_module #(
     parameter PARAMETER1 = 0
   ) (
     input         clk,
     input         rst,
     input  [7:0]  data_0,
     input  [7:0]  data_1,
     input         enable,
     input         valid,

     // interface 1
     input         interf1_clk,
     inout         interf1_some_signal,
     output [15:0] interf1_data_i,
     output [15:0] interf1_data_q,

     // interface 2
     input         interf2_some_signal,
     output        interf2_data_out
   );

**A11.2**

Comments are allowed inside a module declaration **only** for
separating the interfaces by specifying the name and giving
supplementary explanations.

**A11.3**

When declaring a module, the closing parenthesis of the
parameters list **must** be on the same line with the last parameter and
with the opening parenthesis of the ports list (as shown in the correct
examples).

**A11.4**

After ``endmodule`` there **must** be only one newline, and
nothing else after.

**A12**

Ports **must** be indicated individually; that is, one port per
line must be declared, using the direction indication and data type with
each port.

**A13**

Signals and variables **must** be declared individually; that
is, one signal/variable per line **must** be declared.

**A14**

All ports and signals **must** be grouped by interface. Group
ports declaration by direction starting with input, inout and output
ports.

**A15**

The clock and reset ports **must** be declared first.

**A16**

Verilog wires and registers declarations **must** be grouped in
separate sections. **Firstly** register types and then wire types.

**A17**

The source files *should* have the format shown in Annex 1 for
Verilog code and Annex 2 for VHDL code.

B. Naming Conventions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**B1**

All the names in the source code **must** be written in English.

**B2**

Names **must** start with a letter, be composed of alphanumeric
characters or underscores **[A-Z, a-z, 0-9,\_]**.

**B3**

All modules, signal and register names **must** be lower case,
delimited by underscores \_.

.. _example-b3:

.. code-block::
   :linenos:

   module my_module (
     input           ena_fft,
     input           ena_mdi,
     input           fft_in,
     output          mdi_out,
     output [15:0]   my_signal1
   );

**B4**

A file **must** contain a single module. File name **must** be
the same as the module name. For sub-modules the name **must** be
composed in the following way:

.. code-block::

   <top_module_name>_<sub_module_description>.

**B5**

All parameter names **must** be upper case with underscore
delimiters.

**B6**

Signals names *should* be composed in the following way:

.. code-block::

   [interface|clock domain]_<signal_name>[_ns][_l][_p][_n][_m1][_m2][_s]

The suffix component may be used as described below and, in the case of
multiple suffixes being used in the same signal name, must only be used
in the order specified in the signal name descriptions above.

``*_ns`` - State machine next state.

``*_l`` - Latch output. Optional for signals leaving top-level module
or sub-module, required for signals internal to a module

``*_p`` - Positive side of differential signal.

``*_n`` - Negative side of differential signal. - Active low signal.
Can also be used for negative side of differential signal.

``*_m1/\_m2`` - Used to describe registers synchronizers
(e.g. up_ack_m1, up_ack_m2)

``*_s`` - Used to qualify wires/signals (e.g. up_ack_s)

This rule is useful for complex modules where it is possible to
incorrectly use a signal if its name does not contain a suffix to
specify its purpose. Generally this rule can lead to an unnecessary
naming complexity and thus can be overlooked unless it is absolutely
necessary.

**B7**

Ports names *should* be composed in the following way:

.. code-block::

   <interface_name>_<port_name>[_clk][_rst][_p][_n]

``*_clk`` - Clock signal. Exception: Signals whose names obviously
indicate clocks (e.g. system_clock or clk32m), or when specifying a
clock with a certain frequency (in this case clk *should* be used as a
prefix: e.g. clk_625mhz)

``*_rst / \_rstn`` - Reset signal (e.g. module_rst). Exception: Signals
whose names obviously indicate resets.

``*_p`` - Positive side of differential signal.

``*_n`` - Active low signal. Can also be used for negative side of
differential signal.

**B8**

Global text macros specified by the ```define`` directive
**must** be preceded with the top-level module name, as in:

.. code-block::

   <top_level_module_name>_<text macro name>

**B9**

Consistent usage in the spelling and naming style of nets and
variables **must** be used throughout the design.

**B10**

Abbreviations used in a module **must** be documented and
uncommon abbreviations *should* be avoided.

**B11**

Reset and clock names **must** remain the same across
hierarchy.

C. Comments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**C1**

Comments **must** be used to describe the functionality of the
HDL code. Liberal use of comments is strongly encouraged. Adding obvious
comments is discouraged. Basically, extensive comments that proceed
blocks of code, coupled with sparse back references, guide the reader
through the code.

**C2**

Each functional section of the code *should* be preceded by
comments describing the code's intent and function.

**C3**

Unusual or non-obvious implementations **must** be explained and
their limitations documented with a comment.

**C4**

Each port declaration *should* have a descriptive comment,
**only** on the preceding line.

**C5**

Other declarations, such as regs, wires, local parameters,
*should* have a descriptive comment. Either on the same line
(discouraged), or on the preceding line. This rule is optional for
auto-generated code.

**C6**

All synthesis-specific directives **must** be documented where
used, identifying the reason they are used, the tool and the directive
used.

**C7**

The comments inserted in the code **must** comply with the
format shown in Annex 1 for Verilog code and Annex 2 for VHDL code.

D. General
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**D1**

A file **must** contain a single module.

**D2**

A file **must** contain either: digital-only Verilog code (files
with .v extension); analog-only Verilog code (files with .va or .vams
extension); or mixed-signal Verilog code (files with .vams extension).

**D3**

Symbolic constants (local parameter) *should* be used for
register field values rather than fixed numerical constants. The fields
may be one or more bits or the entire register.

**D4**

Port connection width **must** match. In module instantiations,
nets connected to ports must have the same width as the respective port
declaration.

**D5**

The ranges in both the vector port declaration and the
net/variable declaration **must** be equal.

**D6**

Operands sizes **must** match. No expression may have its size
implicitly extended or reduced. In a ``case`` statement, all the
``case`` item expressions and the ``case`` expression must have the same
size.

**D7**

Combinational logic **must** be specified completely (i.e., a
value must be assigned to the logic outputs for all input combinations).
In a construct derived from either a ``case`` or an ``if`` statement,
the outputs may be assigned default values before the ``case`` or ``if``
statement, and then the logic is completely specified.

**D8**

The sensitivity list of Verilog ``always`` and VHDL ``process``
constructs **must** be completely specified.

**D9**

Modules **must** be instantiated with all I/O: port names
and signal connections must be listed on all module instantiations. Do
not leave any input ports open (even if they are unused), always tie
them to 0 or 1. Leave unused outputs open **but do** list them.

**D10**

A ```timescale`` directive that is best for simulation *should*
be used in Verilog modules.

**D11**

Compile warnings **must** be treated as potential errors and
*should* always try to be resolved. In case a warning is not resolved
its cause and effects must be fully understood.

**D12**

Critical warnings **must** be treated and fixed.

**D13**

Each file **must** contain a license header, and when changes
are made to a file, when making a PR, the year *should* be updated to
the current year.

3. Annexes
-------------------------------------------------------------------------------

Annex 1 Verilog file format
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: verilog
   :linenos:

   // ***************************************************************************
   // ***************************************************************************
   // Copyright (C) year-year Analog Devices, Inc. All rights reserved.
   //
   // In this HDL repository, there are many different and unique modules, consisting
   // of various HDL (Verilog or VHDL) components. The individual modules are
   // developed independently, and may be accompanied by separate and unique license
   // terms.
   //
   // The user should read each of these license terms, and understand the
   // freedoms and responsabilities that he or she has by using this source/core.
   //
   // This core is distributed in the hope that it will be useful, but WITHOUT ANY
   // WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
   // A PARTICULAR PURPOSE.
   //
   // Redistribution and use of source or resulting binaries, with or without modification
   // of this file, are permitted under one of the following two license terms:
   //
   //   1. The GNU General Public License version 2 as published by the
   //      Free Software Foundation, which can be found in the top level directory
   //      of this repository (LICENSE_GPL2), and also online at:
   //      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
   //
   // OR
   //
   //   2. An ADI specific BSD license, which can be found in the top level directory
   //      of this repository (LICENSE_ADIBSD), and also on-line at:
   //      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
   //      This will allow to generate bit files and not release the source code,
   //      as long as it attaches to an ADI device.
   //
   // ***************************************************************************
   // ***************************************************************************

   `timescale 1ns/100ps

   module prescaler #(
     // range = 1-16
     parameter FIRST_PARAMETER = 8,
     // range = N/A
     parameter SECOND_PARAMETER = 12
   ) (
     input           core_32m_clk,         // 32 MHz clock
     input           system_clk,           // system clock
     input           scan_mode_test,       // scan mode clock
     input           reset_n,              // active low hard reset, synch w/
                                           // system_clk
     output  reg     div16_clk,            // input clock divided by 16
     output  reg     div16_clk_n           // input clock divided by 16 and inverted
   );
     // local parameters

     // registers declarations

     reg     [3:0]   count;          // 4-bit counter to make clock divider
     reg     [3:0]   count1;         // 4-bit counter to make clock divider

     // wires declarations

     wire    [3:0]   count1_ns;      // clock divider next state input

     // functions definitions

     // this block updates the internal counter
     always @(posedge core_32m_clk or negedge reset_n) begin
       if (!reset_n) begin
         count <= 4'b0000;
       end else begin
         // update counter
         count <= count + 4'b0001;
       end
     end

     // this block updates the output clock signals
     always @(scan_mode_test or system_clk or count) begin
       if (!scan_mode_test) begin
         // normal operation clock assign
         div16_clk = count[3];
         div16_clk_n = ~count[3];
       end else begin
         // scan mode clock assign
         div16_clk = system_clk;
         div16_clk_n = system_clk;
       end
     end

     // Modules Instantiations

   endmodule

Annex 2 VHDL file format
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: vhdl
   :linenos:

   -- ***************************************************************************
   -- ***************************************************************************
   -- Copyright (C) year-year Analog Devices, Inc. All rights reserved.
   --
   -- In this HDL repository, there are many different and unique modules, consisting
   -- of various HDL (Verilog or VHDL) components. The individual modules are
   -- developed independently, and may be accompanied by separate and unique license
   -- terms.
   --
   -- The user should read each of these license terms, and understand the
   -- freedoms and responsabilities that he or she has by using this source/core.
   --
   -- This core is distributed in the hope that it will be useful, but WITHOUT ANY
   -- WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
   -- A PARTICULAR PURPOSE.
   --
   -- Redistribution and use of source or resulting binaries, with or without modification
   -- of this file, are permitted under one of the following two license terms:
   --
   --   1. The GNU General Public License version 2 as published by the
   --      Free Software Foundation, which can be found in the top level directory
   --      of this repository (LICENSE_GPL2), and also online at:
   --      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
   --
   -- OR
   --
   --   2. An ADI specific BSD license, which can be found in the top level directory
   --      of this repository (LICENSE_ADIBSD), and also on-line at:
   --      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
   --      This will allow to generate bit files and not release the source code,
   --      as long as it attaches to an ADI device.
   --
   -- ***************************************************************************
   -- ***************************************************************************

   entity prescaler is
     Port (
       core_32m_clk      : in  std_logic,    -- 32 MHz clock
       system_clk        : in  std_logic,    -- system clock
       scan_mode_test    : in  std_logic,    -- scan mode clock
       reset_n           : in  std_logic,    -- active low hard reset, synch
       -- w/ system_clock
       div16_clk         : out std_logic,    -- input clock divided by 16
       div16_clk_n       : out std_logic     -- input clock divided by 16
        -- and inverted
     );
   end prescaler;

   architecture Behavioral of  prescaler is

   -- Components Declarations

   -- Local Types Declarations

   --  Constants Declarations

   -- Signals Declarations
     signal count        : std_logic_vector(3 downto 0); -- 4-bit counter to
     -- make clock divider
     signal count_ns     : std_logic_vector(3 downto 0); -- clock divider next
     -- state input

   -- Module Implementation
   begin

     -- This process updates the internal counter
     process(core_32m_clk)
     begin
       if (rising_edge(core_32m_clk)) then
         if (reset_n = '0') then
           -- reset counter
           count <= "0000";
         else
           -- update counter
           count <= count + "0001";
         end if;
       end if;
     end process;

     -- This process updates the output clock signals
     process(scan_mode_test, system_clk, count)
     begin
       if (scan_mode_test = '0') then
         -- normal operation clock assign
         div16_clk <= count(3);
         div16_clk_n <= not count(3);
       else
         -- scan mode clock assign
         div16_clk <= system_clk;
         div16_clk_n <= system_clk;
       end if;
     end process;

   end Behavioral;

4. References
-------------------------------------------------------------------------------

`[1] Philippe Garrault, Brian Philofsky, "HDL Coding Practices to Accelerate
Design Performance", Xilinx, 2006
<http://www.xilinx.com/support/documentation/white_papers/wp231.pdf>`__

`[2] Peter Chambers, "The Ten Commandments of Excellent Design", VLSI
Technology, 1997
<http://www.asic-world.com/code/verilog_tutorial/peter_chambers_10_commandments.pdf>`__

`[3] "Verilog Coding Techniques, v3.2", Freescale Semiconductor, 2005
<http://courses.cit.cornell.edu/ece576/Verilog/FreescaleVerilog.pdf>`__

`[4] Jane Smith, "Verilog Coding Guidelines, Rev. B", Cisco Systems 2000
<http://www.engr.sjsu.edu/cpham/VERILOG/VerilogCodingStyle.pdf>`__
