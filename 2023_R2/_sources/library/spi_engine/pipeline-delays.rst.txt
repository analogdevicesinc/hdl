.. _spi_engine pipeline-delays:

SPI Engine Pipeline Delays
================================================================================

The SPI Engine implementation imposes certain constraints on the timing of
different commands. Each instruction requires some number of cycles to execute,
which may depend on the instruction parameters. Additionally, there are delays
associated with the internal architecture of the SPI Engine, which become
relevant unless we are using the Offload functionality.

.. _instruction_execution_times:

Instruction Execution
--------------------------------------------------------------------------------

Every instruction requires 1 cycle minimum for communication between the offload
module and the execution module. Additionally, the Chip Select, Sleep, Transfer
and Sync instructions require another cycle for checking the idle condition
(total 2 fixed delay for these).

The exact values are, counting from the execution
module:

.. list-table::
   :widths: 10 80
   :header-rows: 1

   * - Instruction
     - Cycles
   * - Configuration Write
     - 1 cycle.
   * - Sync
     - 2 cycles.
   * - Chip-select
     - :math:`2+ 2*t*((div+1)*2)`. Where :math:`t` is the chip select delay
       parameter on the instruction, and :math:`div` is the prescaler register
       value. The CS value change happens after the first
       :math:`2+t*((div+1)*2)` cycles.
   * - Sleep
     - :math:`2 + t*((div+1)*2)`. Where :math:`t` is the sleep delay parameter
       on the instruction, and :math:`div` is the prescaler register value.
   * - Transfer
     - 2 cycles, plus the transfer time.

Counting from the execution module means that these values are useful for
calculating the delays on the offload case (simply add up each instruction
execution time). For other cases, the detailed delays of the architecture are
needed.

.. _detailed_delays:

Detailed Delays
--------------------------------------------------------------------------------

This section lists the delays inside the SPI Engine architecture. To make use of
this information, one needs some degree of familiarity with the hdl
implementation (knowledge of the sub-modules and the way they communicate).

See also: :ref:`spi_engine control-interface`,
:ref:`spi_engine offload-control-interface`.

Offload Module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
All the delays measured for this module are in terms of SPI Engine clock cycles.

* Trigger input to command valid output: 1 + 1-2(from a 2FF CDC, 0 if not
  asynchronous) cycles.
* Trigger in to sdo_data_valid: 1 + 1-2(from a 2FF CDC, 0 if not asynchronous)
  cycles.
* Maximum command throughput: 1 command per cycle.
* sdi_data_valid to offload_sdi_valid: 0 cycles.

Interconnect Module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
All the delays measured for this module are in terms of SPI Engine clock cycles.

The interconnect will only accept one manager at a time, and will wait until a
sync handshake back to the manager is completed to free the channel.

* Command valid input to command valid output (s0/s1 to m): 1 cycle if idle, 0
  if already "owned" by the source (s0 or s1).
* Sync valid from m side to s0/s1 sync valid (back to originating manager): 0
  cycle.
* Sync ready to idle (delay after finishing transaction response): 1 cycle
* Thus, 2 cycles per command minimum if changing managers, 3 if accounting for
  sync (this is the worst case).
* 1 cycle per command (can accept back to back) if from same manager.
* Thus, :math:`2+N_{cmd}` minimum cycles per :math:`N_{cmd}` "burst" from same
  source.
* s0/s1_sdo_valid to m_sdo_valid:  0 if already "owned" by the source (s0 or
  s1). Otherwise has to wait until s0/s1 owns the channel.
* m_sdi_valid to s0/s1_sdi_valid:  0 if already "owned" by the sink (s0 or s1).
  Otherwise has to wait until s0/s1 owns the channel.

Execution Module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
All the delays measured for this module are in terms of SPI Engine clock cycles.
See above: :ref:`instruction_execution_times`

* Every instruction requires 1 cycle minimum for communication between the
  Offload Module and the Execution Module. Additionally, the Chip Select, Sleep,
  Transfer and Sync instructions require another cycle for checking the idle
  condition (total 2 fixed delay for these).

  * Chip Select, Sleep and Transfer have additional cycle requirements due to
    intentional delays in execution. This is better detailed at
    :ref:`instruction_execution_times`.

* SDI data delay: 0 cycles (sdi_data_valid arrives at the same cycle as the
  Transfer instruction finishes and the next command is accepted).

AXI Module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* AXI transaction to take effect internally: 1 (AXI clock).

  * Meaning: if counting delay to other parts of the design (e.g. command fifo),
    this is the AXI delay. Other AXI delays affect only AXI throughput, creating
    backpressure for the AXI manager.

* Throughput: 4 cycles (AXI clock) per transaction.
* Command FIFO delay: depends on parametrization:

  * Synchronous, 1 deep: 1 clk (AXI clock = SPI Engine clock).
  * Asynchronous, 1 deep: 1 (AXI clock), + 1-2 (SPI Engine clock) (2FF CDC)
    input to output; + 1-2 (AXI clock) (2FF CDC) until ready to accept next.
  * Asynchronous, true FIFO: 2 (AXI clock) (mem write + bin2gray addr), + 1-2
    (SPI Engine clock) (2FF CDC), + 2 (SPI Engine clock) (gray2bin + valid) .

* AXI transaction start to command valid (total for async FIFO case): 3 AXI
  clock + 3-4 SPI Engine clock.
* SDO Data FIFO delay: same as Command FIFO.
* SDI Data FIFO delay: depends on parametrization:

  * Synchronous, 1 deep: 1 clk (AXI clock = SPI Engine clock).
  * Asynchronous, 1 deep: 1 (SPI Engine clock), + 1-2 (AXI clock) (2FF CDC)
    input to output; + 1-2 (SPI Engine clock) (2FF CDC) until ready to accept
    next.
  * Asynchronous, true FIFO: 2 (SPI Engine clock) (mem write + bin2gray addr), +
    1-2 (AXI clock) (2FF CDC), + 2 (AXI clock) (gray2bin + valid) .
