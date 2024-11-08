.. _i3c_controller control-interface:

Control Interface
================================================================================

The control interface exchanges data between the cores within the I3C Controller.

The interface consists of five streams:

* cmd: carries instructions on what procedures the I3C Controller should execute.
* cmdr: carries synchronization events and metadata from sent instructions.
* sdo: carries data to be transmitted in the I3C bus.
* sdi: carries data received from the I3C bus during a CCC or private transfer.
* ibi: carries data received from the I3C bus during an IBI.

.. _i3c_controller instruction-format:

Instruction Set Specification
--------------------------------------------------------------------------------

The I3C Controller instruction set is a pair of 32-bit command descriptors
(command 0 and command 1), with the latter present only for some command 0 values.

.. _i3c_controller command_descriptors:

Command Descriptors
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

The generic structure of command 0 is:

+--------------------------------------------------------------------+
| Command 0                                                          |
+---------+-------+--------------------------------------------------+
| Name    | Range | Description                                      |
+=========+=======+==================================================+
|         | 31:23 | Reserved.                                        |
+---------+-------+--------------------------------------------------+
| Is CCC  | 22    | Indicate if it is a CCC transfer (1) or not (0). |
+---------+-------+--------------------------------------------------+
| Bcast.  | 21    | Include broadcast header in private transfer (1) |
| header  |       | or not (0).                                      |
+---------+-------+--------------------------------------------------+
| Sr      | 20    | Repeated start flag, yield a Sr (1) or P (0)     |
|         |       | at the end of the transfer.                      |
+---------+-------+--------------------------------------------------+
| Buffer  | 19:8  | Unsigned 12-bits payload length, direction       |
| lenght  |       | depends on RNW value.                            |
+---------+-------+--------------------------------------------------+
| DA      |  7:1  | 7-bit device address (don't care in broadcast    |
|         |       | mode).                                           |
+---------+-------+--------------------------------------------------+
| RNW     |  0:0  | If should retrieve data from device (1) or not   |
|         |       | (0).                                             |
+---------+-------+--------------------------------------------------+

The Sr flag will be ignored if the next Command Descriptor is available at the
correct clock cycle.
Also, the software must ensure the next Command Descriptor is from the same branch
of the state machine, for example, cannot jump from a Private Transfer to a
Broadcast CCC, must always return to Start (Sr=0).
For a flowchart of the those paths, see Fig. 168, p.387 from MIPI I3C
specification\ [#f1]_.

The structure of command 1 depends on command 0 first bits and are defined in
the following subsections.

.. note::

  CCC always broadcast header after a bus available, therefore "Bcast. header"
  is ignored for CCC\s.

.. _i3c_controller ccc:

CCC Instruction
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sent with :code:`adi_i3c_controller_send_ccc_cmd`, it does a CCC transfer.
The CCC ID is defined in the *linux/i3c/ccc.h* file.

.. note::

   The Controller enters the DAA procedure with the ENTDAA CCC
   instruction and exits when its the hardware state machine sequence finishes.
   For the ENTDAA CCC buffer length should be 0, even though DAs are sent during
   the procedure.

Bits not presented in the tables are assumed 0.
When Value is filled, it means it is the required constant value for this
transfer.

+------------------------------------------------------------------------------+
| Command 0, CCC instruction                                                   |
+----------+-------+--------+--------------------------------------------------+
| Name     | Range | Value  | Description                                      |
+==========+=======+========+==================================================+
| Is CCC   | 22    | 1      | CCC transfer type.                               |
+----------+-------+--------+--------------------------------------------------+
| Sr       | 20    |        | Repeated start flag, yield a Sr (1) or P (0)     |
|          |       |        | at the end of the transfer.                      |
+----------+-------+--------+--------------------------------------------------+
| Buffer   | 19:8  |        | Unsigned 12-bits payload length, direction       |
| length   |       |        | depends on RNW value.                            |
+----------+-------+--------+--------------------------------------------------+
| DA       |  7:1  |        | 7-bit device address (don't care in broadcast    |
|          |       |        | mode).                                           |
+----------+-------+--------+--------------------------------------------------+
| RNW      |  0:0  |        | (1) sets the payload buffer as rx and (0) as tx. |
+----------+-------+--------+--------------------------------------------------+

+------------------------------------------------------------------------------+
| Command 1, CCC instruction                                                   |
+---------+-------+---------+--------------------------------------------------+
| Name    | Range | Value   | Description                                      |
+=========+=======+=========+==================================================+
| Type    |  7    |         | Direct (1) or broadcast (0), except SETXTIME     |
|         |       |         | and VENDOR.                                      |
+---------+-------+---------+--------------------------------------------------+
| ID      |  6:0  |         | CCC to transfer, is the same content as the      |
|         |       |         | payload to be sent in the bus.                   |
+---------+-------+---------+--------------------------------------------------+

Private Transfer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sent with :code:`adi_i3c_controller_priv_xfers`, it does a private transfer.

Bits not presented in the tables are assumed 0.
When Value is filled, it means it is is the required constant value for this
transfer.

+------------------------------------------------------------------------------+
| Command 0, private instruction                                               |
+----------+-------+--------+--------------------------------------------------+
| Name     | Range | Value  | Description                                      |
+==========+=======+========+==================================================+
| Is CCC   | 22    | 0      | Not a CCC transfer type.                         |
+----------+-------+--------+--------------------------------------------------+
| Broad.   | 21    |        | Include broadcast header in private transfer (1) |
| header   |       |        | or not (0).                                      |
+----------+-------+--------+--------------------------------------------------+
| Sr       | 20    |        | Repeated start flag, yield a Sr (1) or P (0)     |
|          |       |        | at the end of the transfer.                      |
+----------+-------+--------+--------------------------------------------------+
| Buffer   | 19:8  |        | Unsigned 12-bits payload length, direction       |
| lenght   |       |        | depends on RNW value.                            |
+----------+-------+--------+--------------------------------------------------+
| DA       |  7:1  |        | 7-bit device address (don't care in broadcast    |
|          |       |        | mode).                                           |
+----------+-------+--------+--------------------------------------------------+
| RNW      |  0:0  |        | (1) sets the payload buffer as rx and (0) as tx. |
+----------+-------+--------+--------------------------------------------------+

+------------------------------------------------------------------------------+
| Command 1, private instruction (unused)                                      |
+---------+-------+---------+--------------------------------------------------+
| Name    | Range | Value   | Description                                      |
+=========+=======+=========+==================================================+
+---------+-------+---------+--------------------------------------------------+

.. _i3c_controller cmdr:

Command Receipts
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Command receipts (cmdr) are returned descriptors for each command descriptor
executed (cmd).
When a new cmdr is written to the CMDR FIFO, an interrupton is sent to
PS, see :ref:`i3c_controller interrupts`.

In the cmdr, the buffer length is updated with the number of bytes actually
transferred.
For sending to the peripheral (RNW=0), it will be either 0, when the peripheral
does not ACK the address, or the original buffer length, since the peripheral
cannot stop the transfer in the middle, as it can during a rx transfer (RNW=1).

The structure of the command receipt is:

+--------------------------------------------------------------------+
| Command receipt                                                    |
+---------+-------+--------------------------------------------------+
| Name    | Range | Description                                      |
+=========+=======+==================================================+
|         | 31:24 | Reserved.                                        |
+---------+-------+--------------------------------------------------+
| Error   | 23:20 | If an error occurred during the transfer.        |
+---------+-------+--------------------------------------------------+
| Buffer  | 19:8  | Unsigned 12-bits transferred payload length.     |
| length  |       |                                                  |
+---------+-------+--------------------------------------------------+
| Sync    |  7:0  | Command synchronization.                         |
+---------+-------+--------------------------------------------------+

The Sync is a synchronization identifier that increases (then returns to 0)
at each transfer.

Error codes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The error codes are:

+---------------------------------------------------------------------+
| Command receipt error codes                                         |
+------+-----------+--------------------------------------------------+
| Code | ID        | Description                                      |
+======+===========+==================================================+
| 0    | NO_ERROR  | No error.                                        |
+------+-----------+--------------------------------------------------+
| 1    | CE0_ERROR | Illegally formatted CCC.                         |
+------+-----------+--------------------------------------------------+
| 4    | CE2_ERROR | No response to broadcast address.                |
+------+-----------+--------------------------------------------------+
| 6    | NACK_RESP | The peripheral did not ACK the transfer.         |
+------+-----------+--------------------------------------------------+
| 8    | UDA_ERROR | DA in CMD instruction or IBI is unknown.         |
+------+-----------+--------------------------------------------------+

The C0-3 errors are defined by the I3C specification.
The CE0 occurs when an unexpected number of bytes are received by the controller
during in a CCC.
The CE1 and CE3 never occurs in the implementation.
CE2 and NACK_RESP are very similar, but CE2 is restricted for the first ACK of
a transfer, when the controller sends the broadcast address 7'h7e.

On software, check bit:

* 3: for any NACK response.
* 4: for unknown address.

.. _i3c_controller ibi:

In-Band Interrupts
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

IBI's are resolved autonomously during bus available per specification,
if they are accepted or rejected depends if the feature itself is enabled;
see I3C Controller's :ref:`i3c_controller regmap` register ``IBI_CONFIG`` for
more info.
The accepted IBI's fill the IBI FIFO and generate an interrupt to the
PS.

The structure of the received IBI is:

+--------------------------------------------------------------------+
| In-band interrupt                                                  |
+---------+-------+--------------------------------------------------+
| Name    | Range | Description                                      |
+=========+=======+==================================================+
|         | 31:23 | Reserved.                                        |
+---------+-------+--------------------------------------------------+
| DA      | 23:17 | Dynamic address.                                 |
+---------+-------+--------------------------------------------------+
|         | 16    | Reserved.                                        |
+---------+-------+--------------------------------------------------+
| MDB     | 15:8  | Mandatory data byte.                             |
+---------+-------+--------------------------------------------------+
| Sync    |  7:0  | IBI synchronization.                             |
+---------+-------+--------------------------------------------------+

.. note::

   Additional bytes are not supported.

The software interprets the mandatory data bytes, some by the I3C controller
driver and some by the peripheral driver.
The MIPI pre-defines and reserves some values for the MDB,
which are kept updated at the I3C MDB Values implementers table\ [#f0]_.

There is two configurations for the IBI, to enable accepting IBI\s
and listen to peripheral IBI requests.

If IBI is disabled, the controller will NACK IBI requests.
If enabled, the controller will ACK the IBI request and receive the
MDB.
In both cases, the controller will proceed with the cmd transfer after resolving
the IBI request (since the request occur during the header broadcast).

SDI and SDO
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

During the serialization of the 32-bits FIFOs into 1-byte packages,
if the command descriptor describes a payload of length 5, the controller will
send the 4 bytes of the element at the top of SDO FIFO's stack, then the
left-most byte of the next SDO FIFO's element.

For example, consider the following data:

.. code:: c

   u32 data[2] = {0x78563412, 0xFE};

The table below exemplifies the sequence ("D" is discarded):

+----------------------------------------------------+
| Payload transfer, length = 5                       |
+--------------------+-------+-------+-------+-------+
| SDO FIFO Stack     | Byte3 | Byte2 | Byte1 | Byte0 |
+====================+=======+=======+=======+=======+
| #0                 | 0x78  | 0x56  | 0x34  | 0x12  |
+--------------------+-------+-------+-------+-------+
| #1                 | D     | D     | D     | 0xFE  |
+--------------------+-------+-------+-------+-------+

For the SDI FIFO, considering the I3C bus sends the most significant byte first,
a transfer of 6 bytes would fill the SDI FIFO as follows:

+----------------------------------------------------+
| Payload transfer, length = 5                       |
+--------------------+-------+-------+-------+-------+
| SD1 FIFO Stack     | Byte3 | Byte2 | Byte1 | Byte0 |
+====================+=======+=======+=======+=======+
| #0                 | 0     | 1     |  2    | 3     |
+--------------------+-------+-------+-------+-------+
| #1                 | 4     | D     | D     | D     |
+--------------------+-------+-------+-------+-------+

.. _i3c_controller daa:

Dynamic Address Assignment
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

The Dynamic Address Assignment (DAA) is a procedure that is entered through the
ENTDAA CCC, see :ref:`i3c_controller ccc` for the instruction itself.

.. attention::

   The ``SDO`` FIFO **must** be empty before entering the DAA.

During the DAA, after a peripheral acknowledges the procedure and sends its
PID, BCR, and DCR, the controller triggers the ``DAA_PENDING`` interrupt,
requesting a Dynamic Address (DA).
The software reads twice the SDI FIFO to acquire the PID, BCR and DCR (optional),
and writes a DA with T-bit to the MSB of SDO FIFO:

.. code:: verilog

   reg [6:0] da;
   reg [31:0] sdo;
   sdo <= {da, ~^da, 24'b0} // DA + T-bit + don't care

Then, it clears the ``PENDING_DAA`` interrupt (see :ref:`i3c_controller interrupts`).

The controller repeats the procedure for every device that requests an address
during the DAA, and also the software resolves every subsequent interrupt.

The read of the SDI FIFO is optional because the software can either:

* Seek the desired DA using the received PID.
* Assign another DA using the ``GETPID`` and ``SETNEWDA`` CCCs at a latter opportunity.

The second approach has the advantaged of stalling the bus for a shorter period of
time, while the first guarantees the target will be assigned the desired address.

Word Command Interface
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

The word command interface is an internal interface between the Framing/DAA and
the Word modules, it is based on the patterns of the I3C specifications, allowing
to yield events as commands, for example, broadcasting the I3C 7'h7e and waiting
the ACK.

For cohesion, this interface uses the abbreviations from Fig. 168, p.397 from
MIPI I3C specification\ [#f1]_, e.g. the last example is BCAST_7E_W.

The command has two fields: header and body, the header is an enumeration of
the possible commands, and body is a 1-byte that depends on the header.

Configuration Registers
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. _i3c_controller offload-interface:

Offload Interface
--------------------------------------------------------------------------------

The offload interface allows to cyclic operation with SDI output to a DMA.
The offload commands are the same as in :ref:`i3c_controller command_descriptors`,
however no command receipt is emitted and less complex transactions are preferred
with this interface, specially that the I3C specification allows the peripheral to
reject a transfer;
in summary, are suitable of the offload interface register read transfers, e.g.
ADC readings.

To use this mode,
instead of writing the command to the CMD FIFO and the payloads to SDO FIFO:

* Write the command descriptors in sequence of execution to the OFFLOAD_CMD_*
  registers.
* Populate the OFFLOAD_SDO_* registers with the SDO payload, preserving unused
  bytes slots (don't mix different commands payload in the same address).
* Update the OPS_OFFLOAD_LENGTH register subfield with the number of commands
  descriptors.

The offload logic will then execute a burst for each offload_trigger
(OPS_MODE must be 'b1).
Also, one shall set the OPS_MODE to offload at the same write of the
OPS_OFFLOAD_LENGTH.

The Block RAM Offload
--------------------------------------------------------------------------------

A 5-bit wide address, 32-bit data dual access block ram is used to store the
offload commands and SDO.

The bit 5 indicates if it's a command descriptor ('b0) or a SDO payload ('b1).
The actual width of the address and data depends on the implementation, but in
general the 5-bit address is placed as a 16-bit address with the 11 MSB grounded.

Debugging Tips
--------------------------------------------------------------------------------

To ease debugging with the ILA core, the following signals are recommended to be
sampled:

* ``bit_mod:rx_raw``: SDI input after one register sampling (data).
* ``bit_mod:scl``: SCL output (data).
* ``word:sm``: Current Word Command state (data).
* ``framing:cmdp_ccc_id``: CCC ID without broadcast field (trigger, data).

.. warning::

   Do not sample the ``bit_mod:sdo`` signal, it will alter the SDA I/O logic and
   the core won't work properly.

The trigger at ``cmd_parser:cmdp_ccc_id`` allows to start the capture at the start
of the CCC of interest, then the other three debug signals provide a clear view of
the bus and the state of the state machine.

For the depth of the ILA core, between 4096 and 8192 is sufficient to sample whole
transfers.
In particular, 8192 with "Trigger position on window" set to 0 is sufficient to sample
a whole ``ENTDAA`` with 1 peripheral requesting address.

.. rubric:: Footnotes

.. [#f0] `I3C MDB Values implementers table <https://www.mipi.org/MIPI_I3C_mandatory_data_byte_values_public>`_
.. [#f1] `I3C Basic Specification v1.1.1 <https://www.mipi.org/specifications/i3c-sensor-specification>`_
