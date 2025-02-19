.. _cn0363_phase_data_sync:

CN0363 Phase Data Sync
================================================================================

.. hdl-component-diagram::

The :adi:`CN0363` Phase Data Sync FPGA Peripheral is part of the
:ref:`EVAL-CN0363-PMDZ HDL reference design <cn0363>` and is responsible for
preparing the ADC conversion result data and aligning it with the phase and
feeding both to the processing pipeline.

Files
--------------------------------------------------------------------------------

.. list-table::
    :header-rows: 1

    * - Name
      - Description
    * - :git-hdl:`/library/cn0363/cn0363_phase_data_sync/cn0363_phase_data_sync.v`
      - Verilog source for the peripheral.
    * - :git-hdl:`/library/cn0363/cn0363_phase_data_sync/cn0363_phase_data_sync_ip.tcl`
      - TCL script to generate the Vivado IP-integrator project for the
        peripheral.

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

    * - clk
      - Clock
      - All other signals are synchronous to this clock.
    * - resetn
      - Synchronous active low reset
      - Resets the internal state machine of the core.
    * - processing_resetn
      - Synchronous active low reset
      - Indicator that the processing pipeline is in reset.
    * - S_AXIS_SAMPLE
      - AXI-Stream slave
      - Input sample data stream
    * - M_AXIS_SAMPLE
      - AXI-Stream master
      - Output sample data stream
    * - M_AXIS_PHASE
      - AXI-Stream master
      - Output phase data stream
    * - sample_has_stat
      - Input
      - Whether the incoming data on ``S_AXIS_SAMPLE`` has the STAT register
        appended.
    * - conv_done
      - Input
      - Conversion done signal from the ADC.
    * - phase
      - Input
      - Current excitation signal phase.
    * - overflow
      - Input
      - The overflow signal is asserted if a new sample arrives before the
        previous one has been consumed.

Detailed Description
--------------------------------------------------------------------------------

The :adi:`CN0363` Phase Data Sync FPGA Peripheral takes the raw ADC sample data
read by a SPI controller from the ADC on the S_AXIS_SAMPLE stream. The data is
assembled into 24-bit word and converted from offset binary to two's complement
signed.

When a rising edge is detected on the ``conv_done signal`` the core takes a
snapshot of the phase input signal. This data will be assumed to the phase
that belongs to the next incoming data sample on the S_AXIS_SAMPLE. The data
is aligned with the corresponding phase data and both are send out on the
``M_AXIS_SAMPLE`` and ``M_AXIS_PHASE stream``.

If the ``sample_has_stat`` signal is asserted the core will receive 32-bit
instead of 24-bit per sample on the S_AXIS_SAMPLE stream. The last 8-bit are
assumed to contain the STAT register of the ADC, which among other things
contains the information about which channel the ADC result belongs to. This
information can be used to detect and fix channel swaps. If
``sample_has_stat`` is not asserted the core assumes that no channel swaps
happen and the whole pipeline is always running fast enough to accept a
sample before the next one is ready.

If ``processing_resetn`` is asserted the processing pipeline is assumed to be
in reset and incapable of accepting new samples and when a new sample arrives at
the ``S_AXIS_SAMPLE`` port a overflow condition is generated. The signal also
resets the channel swap detection logic and makes sure that the next sample that
is inserted into the processing pipeline after the reset belongs to the first
channel.

Software Support
--------------------------------------------------------------------------------

* Linux device driver at :git-linux:`drivers/iio/adc/ad7173.c`
* Linux device driver documentation at :dokuwiki:`Linux Device Drivers <resources/eval/user-guides/eval-cn0363-pmdz/software/linux/drivers>`
* No-OS device driver at :git-no-os:`drivers/adc/ad717x`
* No-OS device driver documentation at :dokuwiki:`AD717X No-OS Software Drivers <resources/tools-software/uc-drivers/ad717x>`

References
--------------------------------------------------------------------------------

* HDL IP Core at :git-hdl:`library/cn0363/cn0363_phase_data_sync`
* HDL project at :git-hdl:`projects/cn0363`
* HDL project documentation at :ref:`cn0363`
* :adi:`CN0363`
* :adi:`AD7175-2`
* :xilinx:`Zynq-7000 SoC Overview <support/documentation/data_sheets/ds190-Zynq-7000-Overview.pdf>`
* :xilinx:`Zynq-7000 SoC Packaging and Pinout <support/documentation/user_guides/ug865-Zynq-7000-Pkg-Pinout.pdf>`
