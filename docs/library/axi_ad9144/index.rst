.. _axi_ad9144:

AXI AD9144 (OBSOLETE)
================================================================================

.. warning::

   The support for :git-hdl:`AXI AD9144 <hdl_2019_r2:library/axi_ad9144>`
   has been discontinued, the latest tested release being ``hdl_2019_r2``.
   This page is for legacy purposes only.

The :git-hdl:`AXI AD9144 <hdl_2019_r2:library/axi_ad9144>` IP core can be used
to interface the :adi:`AD9144` DAC. An AXI Memory Map interface is used for
configuration. Data is sent in a format that can be transmitted by AMD Xilinx's
JESD IP.

More about the generic framework interfacing DACs, can be read in :ref:`axi_adc`.

Features
--------------------------------------------------------------------------------

* AXI based configuration
* Hardware PRBS generation
* Hardware DDS generation
* Xilinx Vivado compatible
* Altera Quartus compatible

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`hdl_2019_r2:library/axi_ad9144/axi_ad9144.v`
     - Verilog source for the AXI AD9144.
   * - :git-hdl:`hdl_2019_r2:library/axi_ad9144/axi_ad9144_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project.
   * - :git-hdl:`hdl_2019_r2:library/axi_ad9144/axi_ad9144_hw.tcl`
     - TCL script to generate the Quartus IP-integrator project.
   * - :git-hdl:`hdl_2019_r2:library/axi_ad9144/axi_ad9144_constr.xdc`
     - Constraint file of the IP.

Block Diagram
--------------------------------------------------------------------------------

.. image:: block_diagram.svg
   :alt: AXI AD9144 block diagram
   :align: center

Configuration Parameters
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - ID
     - Core ID should be unique for each IP in the system
   * - QUAD_OR_DUAL_N
     - Selects if 4 lanes (1) or 2 lanes (0) are connected
   * - DAC_DATAPATH_DISABLE
     - The delay group name which is set for the delay controller

Interface
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - jesd_interface
     - Data to be connected to the JESD core
   * - s_axi
     - Standard AXI Slave Memory Map interface
   * - dma_interface
     - FIFO interface for connecting to the DMA
   * - dac_clk
     - Loopback of the tx_clk. Most of the modules of the core run on this clock
   * - dac_enable
     - Set when the channel is enabled, activated by software
   * - dac_valid
     - Set when valid data is available on the bus
   * - adc_enable
     - Set when the channel is enabled, activated by software
   * - dac_ddata
     - Data for channel samples
   * - dac_dovf
     - Data overflow input
   * - dac_dunf
     - Data underflow input

Detailed Architecture
--------------------------------------------------------------------------------

.. image:: detailed_architecture.svg
   :alt: AXI AD9144 detailed architecture
   :align: center

Detailed Description
--------------------------------------------------------------------------------

The top module, axi_ad9144, instantiates:

* the JESD204B interface module
* the DAC core module
* the AXI handling interface

The JESD204B interface module handles the serialization and deserialization of
data to and from the DAC, ensuring proper data alignment and timing for
high-speed communication.

The DAC core module includes:

* Data path for digital-to-analog conversion PRBS (Pseudo-Random Binary
  Sequence) generation for testing
* DDS (Direct Digital Synthesis) for generating sine waves and other waveforms
* Fixed pattern generators for consistent test signals

The AXI handling interface manages the communication between the DAC and the
system's AXI bus, facilitating efficient data transfer and control.

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: COMMON
   :no-type-info:

.. hdl-regmap::
   :name: DAC_COMMON
   :no-type-info:

.. hdl-regmap::
   :name: DAC_CHANNEL
   :no-type-info:

.. hdl-regmap::
   :name: JESD_TPL
   :no-type-info:

Design Guidelines
--------------------------------------------------------------------------------

The IP was developed part of the
:dokuwiki+deprecated:`[Wiki] AD9144 Evaluation Boards <resources/eval/dpg/eval-ad9144>`.

The control of the :git-hdl:`AXI AD9144 <hdl_2019_r2:library/axi_ad9144>` chip
is done through a SPI interface, using ACE software. The ACE
(Analysis - Control- Evaluate) software provides a graphical user interface for
configuring and controlling the :adi:`AD9144`, allowing for easy setup and
evaluation of the DAC's performance.

.. warning::
   We **do not** offer support for ACE anymore. Limited support is available.

Software Support
--------------------------------------------------------------------------------

* Linux device driver at :git-linux:`2019_R2:drivers/iio/frequency/ad9144.c`
* Linux device tree at:

  * :git-linux:`2019_R2:arch/arm64/boot/dts/xilinx/adi-ad9144-fmc-ebz.dtsi`
  * :git-linux:`2019_R2:arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9144-fmc-ebz.dts`

* No-OS device driver at:

  * :git-no-os:`2019_r2:drivers/dac/ad9144/ad9144.c`
  * :git-no-os:`2019_r2:drivers/dac/ad9144/iio_ad9144.c`

* No-OS project at :git-no-os:`2019_r2:drivers/dac/ad9144`

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`hdl_2019_r2:library/axi_ad9144`
* :adi:`AD9144`
* :dokuwiki+deprecated:`[Wiki] Evaluating the AD9144 DIGITAL-TO-ANALOG converter <resources/eval/dpg/ace_ad9144-fmc-ebz>`
* :dokuwiki+deprecated:`[Wiki] AD9144-ADRF6720-EBZ Evaluation Board Quick Start Guide <resources/eval/dpg/ad9144-adrf6720-ebz>`
* :dokuwiki+deprecated:`[Wiki] AD9144-EBZ Evaluation Board Quick Start Guide <resources/eval/dpg/ad9144-ebz>`
* :dokuwiki+deprecated:`[Wiki] AD9144-FMC-EBZ Evaluation Board Quick Start Guide <resources/eval/dpg/ad9144-fmc-ebz>`
* :dokuwiki+deprecated:`[Wiki] AD9144-EBZ Evaluation Board Quick Start Guide Using ACE (Analysis | Control | Evaluate) Software <resources/eval/dpg/ace_ad9144-ebz>`
* :xilinx:`7 Series libraries <support/documentation/sw_manuals/xilinx2016_2/ug953-vivado-7series-libraries.pdf>`
