.. _jesd204_component_testbenches:

JESD204 Component-Level Testbenches
================================================================================

Overview
-------------------------------------------------------------------------------

The component-level testbenches verify individual JESD204 IP modules in
isolation. They are located in the HDL repository at
:git-hdl:`library/jesd204/tb`.

These testbenches complement the system-level testbenches (like
`JESD loopback <https://analogdevicesinc.github.io/testbenches/testbenches/ip_based/jesd_loopback/>`__)
by testing specific functionality at a granular level and supporting multiple
simulators.

Supported Simulators
-------------------------------------------------------------------------------

The simulator can be selected through the ``SIMULATOR`` environment variable:

============ =====================================
$SIMULATOR   Simulator
============ =====================================
modelsim     Mentor/Siemens ModelSim/QuestaSim
xsim         AMD Xilinx Vivado Simulator
xcelium      Cadence Xcelium
*(default)*  Icarus Verilog (iverilog)
============ =====================================

Available Testbenches
-------------------------------------------------------------------------------

Link Layer - Register Map
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Testbench
     - Description
   * - axi_jesd204_rx_regmap_tb
     - Verifies AXI register read/write interface for RX link layer peripheral
   * - axi_jesd204_tx_regmap_tb
     - Verifies AXI register read/write interface for TX link layer peripheral

Link Layer - Core
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Testbench
     - Description
   * - rx_tb
     - Tests RX link layer core including PHY ready and lane alignment
   * - rx_cgs_tb
     - Tests Code Group Synchronization (CGS) state machine
   * - rx_ctrl_tb
     - Tests RX control logic
   * - rx_lane_tb
     - Tests individual RX lane handling
   * - tx_tb
     - Tests TX link layer with multi-link SYNC handling
   * - tx_ctrl_phase_tb
     - Tests TX control phase alignment
   * - tx_64b_tb
     - Tests TX 64b66b mode (JESD204C)

Loopback (Full TX to RX Stack)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Testbench
     - Description
   * - loopback_tb
     - Full 8b10b JESD204B loopback test with data integrity verification

Scrambler/Descrambler
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Testbench
     - Description
   * - scrambler_tb
     - Tests 8b10b scrambler/descrambler loopback integrity
   * - scrambler_64b_tb
     - Tests 64b66b scrambler/descrambler using reference vectors

Frame Handling
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Testbench
     - Description
   * - frame_align_tb
     - Tests frame alignment with configurable error injection
   * - jesd204_frame_align_replace_tb
     - Tests character replacement at frame boundaries
   * - jesd204_frame_mark_tb
     - Tests SOF/EOF frame marking logic

Soft PCS (8b10b Physical Coding Sublayer)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Testbench
     - Description
   * - soft_pcs_8b10b_sequence_tb
     - Tests 8b10b encoder output sequences
   * - soft_pcs_8b10b_table_tb
     - Verifies 8b10b encoding lookup table
   * - soft_pcs_loopback_tb
     - Tests soft PCS encode/decode loopback
   * - soft_pcs_pattern_align_tb
     - Tests comma pattern detection and alignment

Utility
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Testbench
     - Description
   * - crc12_tb
     - Tests CRC-12 calculation per JESD204C specification

Building and Running
-------------------------------------------------------------------------------

#. Open a Cygwin or bash terminal
#. Navigate to the testbench folder:

   .. code-block:: bash

      cd library/jesd204/tb

#. (Optional) Set the simulator:

   .. code-block:: bash

      export SIMULATOR=xsim

#. Run a testbench:

   .. code-block:: bash

      ./loopback_tb

Output files:

-  VCD waveforms: ``vcd/<testbench_name>.vcd``
-  Simulation logs: ``<testbench_name>_<simulator>.log``

Resources
-------------------------------------------------------------------------------

HDL Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 30 40 30
   :header-rows: 1

   * - Module
     - Source
     - Documentation
   * - jesd204_rx
     - :git-hdl:`library/jesd204/jesd204_rx`
     - :ref:`axi_jesd204_rx`
   * - jesd204_tx
     - :git-hdl:`library/jesd204/jesd204_tx`
     - :ref:`axi_jesd204_tx`
   * - jesd204_scrambler
     - :git-hdl:`library/jesd204/jesd204_common`
     - ---
   * - jesd204_lmfc
     - :git-hdl:`library/jesd204/jesd204_common`
     - ---
